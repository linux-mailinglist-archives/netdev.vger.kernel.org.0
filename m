Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550BA589F9C
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 18:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbiHDQ6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 12:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbiHDQ6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 12:58:02 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7508167CB8;
        Thu,  4 Aug 2022 09:58:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id u133so26065pfc.10;
        Thu, 04 Aug 2022 09:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=kcSGs+fZuWMXLT8zv9vm9AaTYUZcm+hY8x4vuZxcqO4=;
        b=KGtRlv4dcnACfh2AWJWv+FJR7v3O72dX7m83WhrgoTl3oSgJBk/pmKKaW3j0dcdfbd
         f5YMdxxVKOh1Ndf7yjXllO/4i72QPQjiXSxCcOzJTieTj33LipenWCHkX804ZQVeP7oo
         7uySwlS5+DENHUJ8D7ii+D8tG2h/dW7JIvc9hao4fqPhZPLUmDlk7tpdZe1R88Can+/C
         IRoqVDCG99gC8yt2pxX9JyENJns/9HcolNbk+5VSh/TUKlgXoo6oLfytCoPQw1+F2hTb
         y97x/CAmiEK6WZG4b9CMmc1UmmhRCnuD5JGeE6Xdzn7SvcqQHasazmZRQmD26RfhUuZQ
         vzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=kcSGs+fZuWMXLT8zv9vm9AaTYUZcm+hY8x4vuZxcqO4=;
        b=Q+udMhLhjLOalGtUGEosPV6nEIDyeyFAcZ++poR3rX/EDTpOVgfmezbHw0Xo3/SDlI
         Shg5E31A5zLCTNiaRT7g0bxLJXXAyXgAbql3Fb+kG4cX/n1yssbpm9GPbeapeehdQpXY
         P20flEcXixw0SmdEAEqrS9n6m1VHuKGf8Jpx7LHQkltoE9Azd0uuJ1D3oYhXD65qrzE5
         ichdF4WDpxYyGKFDEiML9U7tcfBPx9fGYFNouViSKGRlbr7Z671rUE/1atz3p5jogBGY
         Sn3zX5qvP6jetrc138AJjsBrIAd/ttqda65uhDR7Q8vXBKtJg+1gDLiH9gk8XDSZaSY8
         I4Xw==
X-Gm-Message-State: ACgBeo3nCFoJMxP5L2aeskLWWZfgaHh+zKoi1vxM0mLYzafnRrUYz2rE
        Ia+eWkTFDPYxRee1CRvQvok=
X-Google-Smtp-Source: AA6agR4Aogd2F75JVozSzkz3uRZ/PBrMX9MpACR5b1bkQvz18Y8JaiotVwjnYzL+BeNVLlvnlB6Sdw==
X-Received: by 2002:a63:5f09:0:b0:41c:da4f:e498 with SMTP id t9-20020a635f09000000b0041cda4fe498mr2378174pgb.276.1659632280734;
        Thu, 04 Aug 2022 09:58:00 -0700 (PDT)
Received: from ?IPV6:2620:10d:c083:3603:1885:b229:3257:6535? ([2620:10d:c090:500::1:a8ba])
        by smtp.gmail.com with ESMTPSA id a1-20020a170902ecc100b0016cf714d029sm1154466plh.288.2022.08.04.09.57.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 09:58:00 -0700 (PDT)
Message-ID: <7c42bf11-8a30-3220-9d52-34b46b68888f@gmail.com>
Date:   Thu, 4 Aug 2022 09:57:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.0
Subject: Re: [RFC net-next 1/6] net: Documentation on QUIC kernel Tx crypto.
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <adel.abushaev@gmail.com>
 <20220803164045.3585187-1-adel.abushaev@gmail.com>
 <20220803164045.3585187-2-adel.abushaev@gmail.com> <Yuq9PMIfmX0UsYtL@lunn.ch>
 <4a757ba1-7b8e-6012-458e-217056eaee63@gmail.com> <Yuvl9uKX8z0dh5YY@lunn.ch>
From:   Adel Abouchaev <adel.abushaev@gmail.com>
In-Reply-To: <Yuvl9uKX8z0dh5YY@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looking at 
https://github.com/shemminger/iproute2/blob/main/misc/ss.c#L589 the ss.c 
still uses proc/.

Adel.

On 8/4/22 8:29 AM, Andrew Lunn wrote:
> On Wed, Aug 03, 2022 at 11:51:59AM -0700, Adel Abouchaev wrote:
>> Andrew,
>>
>>     Could you add more to your comment? The /proc was used similarly to kTLS.
>> Netlink is better, though, unsure how ULP stats would fit in it.
> How do tools like ss(1) retrieve the protocol summary statistics? Do
> they still use /proc, or netlink?
>
>       Andrew
