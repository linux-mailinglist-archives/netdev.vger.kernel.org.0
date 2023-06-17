Return-Path: <netdev+bounces-11658-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8368D733D1D
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 02:10:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A1CC1C21066
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 00:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4942839D;
	Sat, 17 Jun 2023 00:10:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB2236B
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 00:10:28 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61F83590
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 17:10:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-66643830ab3so1386829b3a.0
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 17:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686960627; x=1689552627;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=36qNA2f7zTuDbreRBdsUnQVFrSylrkaQvplWBGLK3SY=;
        b=fo0ntEsxAIwIB1cUebXThD2IP6IhLLwz2SfnD+axpmO7WVeU4NgfLQc6+gZV5kdddg
         +KbtcCghE/wy6zbf9zAhzxYE3+bAW1TZgfXwP2coaRGMqk5GiB3usHAELnUKU3btSLsh
         zJLSXrTCiwuUcLylyh/RTiaD/gAAdFL6YPt5yJ/0ZPnXQcRvBCVIaTF6IT5kZfJY6h+0
         ZA/f25CqBNE/7+FTa3PRGH3iG8C5zpSH9txA3Yv7t/6X1HhYkQOpR7XeVhkftDa/m5sM
         wrNkTzHoqlixRWeJHLnj4TAei1XQsHkECbml7nl9F6AgW19UAzYey6t0y9FqnpUhobpR
         aKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686960627; x=1689552627;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=36qNA2f7zTuDbreRBdsUnQVFrSylrkaQvplWBGLK3SY=;
        b=KY7rGw+ERb1jRZCDivkLVWS60iGCSOjyC9LKb0fKrEkj7wHyTA2h8onCi9drtUgVT2
         sgJxcb+pxRDED7NBsZsd6urlcuIZZ4XTmQ/ETP2JNX+YX9MGToPFkpeO9Syp4FDZm23K
         9l+9o1UmpFmBHJonwWEM2vgj4jSuzLGLLNucYi7KscO3gIgp8asWOjOibUrOrEFDh0Mx
         XRxbZKYMHd4Rq5ZtuGpOAhLfHxpoufs+N9sC8yCXSeDPPMrL8r/RsmG5VAhq038RwB0S
         53ID3MBho8muFdYWPNGqrRKh8g0L7a/Po8FMxkXpJ6DLToH1eGrHoKcZG5NHsgiHW6kC
         R4nQ==
X-Gm-Message-State: AC+VfDzLoVLVMcVel4DSM1n00jhV1sNnuuXTiuUrzK9vV3fUo7U3/s1s
	LQ8RZGoA7+lNyYvlShO2IBk=
X-Google-Smtp-Source: ACHHUZ6NA9LBTrttwU0y6+DmfpJNvNYDlbb9FdO6hbRTiZXKq1XWYzfowaPfIyPwc8qWOMlsDUvmNw==
X-Received: by 2002:a05:6a20:a110:b0:10e:e58d:ce85 with SMTP id q16-20020a056a20a11000b0010ee58dce85mr4940817pzk.10.1686960627220;
        Fri, 16 Jun 2023 17:10:27 -0700 (PDT)
Received: from ?IPV6:2600:6c52:7b00:5db2:81d6:3141:aa4:155b? ([2600:6c52:7b00:5db2:81d6:3141:aa4:155b])
        by smtp.googlemail.com with ESMTPSA id m26-20020aa78a1a000000b0065c8c5b3a7dsm14540370pfa.13.2023.06.16.17.10.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 17:10:26 -0700 (PDT)
Message-ID: <5c3f4c48-3bd8-26c2-9b58-a7fda7d2f22c@gmail.com>
Date: Fri, 16 Jun 2023 17:10:23 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH net-next v2 1/2] net: create device lookup API with
 reference tracking
Content-Language: en-US
To: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com
References: <20230612214944.1837648-1-kuba@kernel.org>
 <20230612214944.1837648-2-kuba@kernel.org>
 <CANn89iLgNEosmFdi7R6Rg1Wk-Z5rWB2LB40H++qPtCE0Czo7kA@mail.gmail.com>
From: David Ahern <dsahern@gmail.com>
In-Reply-To: <CANn89iLgNEosmFdi7R6Rg1Wk-Z5rWB2LB40H++qPtCE0Czo7kA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/16/23 2:21 AM, Eric Dumazet wrote:
> Oops, ip6_validate_gw() is able to change dev under us (this is done
> in ip6_route_check_nh())
> 
> Crazy, I know...

I presume you saw this with a test case or syzbot? If so, can you share?

ip6_route_check_nh sets but never resets the device:

        if (dev) {
                if (dev != res.nh->fib_nh_dev)
                        err = -EHOSTUNREACH;
        } else {
                *_dev = dev = res.nh->fib_nh_dev;
                dev_hold(dev);
                *idev = in6_dev_get(dev);
        }

