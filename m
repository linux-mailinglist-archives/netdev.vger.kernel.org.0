Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E934C4B7E24
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243681AbiBPDNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:13:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbiBPDNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:13:54 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2042CA32A;
        Tue, 15 Feb 2022 19:13:42 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id l19so1031005pfu.2;
        Tue, 15 Feb 2022 19:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9cauhw4HdG0CAFmvrug/PoHbP3oDfg44byQLiUdi3IA=;
        b=II7Li7EiHZML6ng8myu8Bn6vcSrX67bfF2vBk4wc4WvdJCbvrDVmPafa/rE+dMpd9s
         UT6KFEh00LL0Vn6ihtvb85AJGagbTC6gp7Tuea0cYMCLscO17k8CsiYWYKAJ1+rOeuRz
         xrP+hvI/K4eJqK5l5BV2+8RgjziyT26Gm/OEYsPsjreP3p7glL/aKGeytGw8GwDL99Yy
         PC1OQRt+McPVtc2uJk8yxNNJe3AGTld9MANGhA6/hCUn6e+HXE4aqzcONepyNfN0SeUh
         XdivCaljb9W4d3r85HJVDStLRrFu4Dmt9uoAR6iYbnLYspU9V25/Qz764MWdw65LC9vz
         5r3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9cauhw4HdG0CAFmvrug/PoHbP3oDfg44byQLiUdi3IA=;
        b=IjMA9HGNhkMqHd6OGg0oSyT1jHGa8JAoD3aBg2UoEQyGJ+skYhAoInGNBnCjo2sUtH
         k5ZpiwkASkv7ouj/zbz9lUXT2i3rEq7vY0pFD0HGhdlAA8IdmYZ4W0755iwdkXd+BEL4
         dGSX3KcTv3EcZ3baK6NH3nN92aHPXPgm3HDXLvH3wbMLe8OTIcfzh9tsnLNgteip7sA3
         NBZHMSaqPxG+qtQjgThcbf+WNUfZbr39gV0h5dIasYfkC+nzPWVWH2rE3QGjCwwd5nDe
         LIvrC709iWYPIlLngfjO2vhQrq0loruFN1r4qIvjUgJx94RvWS2p9kEjFupouBUnNyFp
         U6dg==
X-Gm-Message-State: AOAM533N2C+dcXyu600xYri6mLfLRVTiLR71RCEU/5zGhF8bKRH3BJTE
        CsMx29C6fUTRU38HoOGshro=
X-Google-Smtp-Source: ABdhPJzgIwpx5SOWmR9b7r+xKKnrCRG7ayfwffy+WjYebdbNErLoxcZUZue1e4sqwqQDwmYWQ6wWmw==
X-Received: by 2002:a63:5c22:0:b0:34e:1a4:3bc with SMTP id q34-20020a635c22000000b0034e01a403bcmr584463pgb.487.1644981222318;
        Tue, 15 Feb 2022 19:13:42 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:fd58:13e6:31bf:9336? ([2600:8802:b00:4a48:fd58:13e6:31bf:9336])
        by smtp.gmail.com with ESMTPSA id s1sm18462315pjr.56.2022.02.15.19.13.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 19:13:41 -0800 (PST)
Message-ID: <5c23585b-7865-54fb-3835-12e58a7aee46@gmail.com>
Date:   Tue, 15 Feb 2022 19:13:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2] ath9k: use hw_random API instead of directly dumping
 into random.c
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, miaoqing@codeaurora.org,
        rsalvaterra@gmail.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <CAHmME9pZaYW-p=zU4v96TjeSijm-g03cNpvUJcNvhOqh5v+Lwg@mail.gmail.com>
 <20220216000230.22625-1-Jason@zx2c4.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220216000230.22625-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/15/2022 4:02 PM, Jason A. Donenfeld wrote:
> Hardware random number generators are supposed to use the hw_random
> framework. This commit turns ath9k's kthread-based design into a proper
> hw_random driver.
> 
> This compiles, but I have no hardware or other ability to determine
> whether it works. I'll leave further development up to the ath9k
> and hw_random maintainers.
> 
> Cc: Toke Høiland-Jørgensen <toke@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---

[snip]

>   	if (!AR_SREV_9300_20_OR_LATER(ah))
>   		return;
>   
> -	sc->rng_task = kthread_run(ath9k_rng_kthread, sc, "ath9k-hwrng");
> -	if (IS_ERR(sc->rng_task))
> -		sc->rng_task = NULL;
> +	sc->rng_ops.name = "ath9k";

You will have to give this instance an unique name because there can be 
multiple ath9k adapters registered in a given system (like Wi-Fi 
routers), and one of the first thing hwrng_register() does is ensure 
that there is not an existing rng with the same name.

Maybe using a combination of ath9k + dev_name() ought to be unique enough?
-- 
Florian
