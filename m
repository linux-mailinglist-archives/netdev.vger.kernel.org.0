Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680D5595F03
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 17:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiHPP1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 11:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiHPP1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 11:27:51 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6F63F30B
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:27:50 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t5so13944288edc.11
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Say4LoMjsRHvfFbzuGwcNAzFchPyeLq2BkHn0plPSqs=;
        b=yo4NPfMwpB96DqzqUjO+pGH374KJdj5ikHj4sFsku8QjiKFu458lz0p0b7PCH3NDxg
         qAcmPChyRySvoOFgu88pir1pMF5fyY4QcvEo2tKZMN7h9h+Pe+2Q3dFTCPyyzYzHLLQS
         PXFC7gyvPpzxV7+sB46jXOHtY5XGVVfrpmY5sQKu/YkwNKfXKsBNkTTX9HYrAYDrckVI
         4VHeffSrUriR7ExYM2MIof6i5BG4aR/4hH5OhnxAhhs3vvFrneJdYkpjf3+HbaKDR62r
         TuE5zC/1vBMyks/2MoxYI2L4+2B0W0g28OCE8DTY3neRI5ukp1DhPRQc17j69aRRb+5h
         a9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Say4LoMjsRHvfFbzuGwcNAzFchPyeLq2BkHn0plPSqs=;
        b=hTzFIzeuMC5ErJ8FHCdBqvpHTM77W+b+IjeE6g7Vp1250j/VI9CfjSlLVamhlBh+6u
         sbCR9JKgY7J3MXe9RWBjD4iWy54gTFvI4B/FnnfJJDcmcrJueV12+tG0wV7f8GXo8QrS
         U7uPsapadNnuwcXkSOpneHRJ82krgXfCshjC/uvKx2gi8IwrgRfC/tBTfr6ahHTCXi3R
         HWTfRkvugyJ7pR/skgIXI+uYCYrgvm/nt9t/BYNNg0jKEqHk18XdILaf+DRsSkDLXWn8
         Cc8XumnuFKzGEtWj7plW2vnp1X+C53GhO3mv8OAlHr9EIZmczGD5qF91uqXZO2pUAxt1
         H4Qw==
X-Gm-Message-State: ACgBeo22qPEvg4VgJYwRdZxAJwKng0m+LKhvIse/mBXc/NLlu2Q0coqR
        u73acekI5D+dl6SyOseDnpzQtffiS+kvTdSW
X-Google-Smtp-Source: AA6agR4Ue+fa4gp1tzWGf4g5483ak1cl4l7HthPE2OGoS9fKwP+U3MGinCE1sqwWtZmd5tPE6zz4uw==
X-Received: by 2002:a05:6402:331d:b0:43d:9e2e:6966 with SMTP id e29-20020a056402331d00b0043d9e2e6966mr19652333eda.214.1660663668625;
        Tue, 16 Aug 2022 08:27:48 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id h23-20020a50cdd7000000b0043d3e06519fsm8711891edj.57.2022.08.16.08.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 08:27:47 -0700 (PDT)
Message-ID: <f815e326-942e-36e3-56ea-7d181e2cc814@blackwall.org>
Date:   Tue, 16 Aug 2022 18:27:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH ipsec] xfrm: policy: fix md_dst skb->dev xmit null pointer
 dereference
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20220816145838.13951-1-razor@blackwall.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220816145838.13951-1-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Self-NAK, sorry for the noise. I meant dst->dev, not skb->dev obviously.
I'll send v2 with fixed subject.
