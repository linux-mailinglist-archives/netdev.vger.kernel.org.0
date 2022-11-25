Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660806388FA
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 12:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiKYLmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 06:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiKYLmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 06:42:37 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AF82ACE
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 03:42:34 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id p8so6462124lfu.11
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 03:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HuPscf/chfZUucxqeK0O8KtSwVLAMHyTryFfC0BnouI=;
        b=cRBJ1zIlVB87Nh4EHVcPOxoezUvVbm14AjUgY4f08Iy8TfC87vMcKJDo6glZPhWH7Z
         GwT8aTsLmweIygCJ/gUv3Vykf6eM7OeiH3i8V8Zy5GD+xPul5w495P7qrsOrnyDaOxLl
         11Yooh4D6KhfExQlcIjJp9pTmDEK/TrsXc1fkt2A+jNggyrcvkalMMV+LsSc+eKTBBl8
         aO/wg7tP+nsnZtL5r2c+Dib0cy3zswaht6L8po9wdwGFjhxB6EsSMDCMhj1aL8jVoU+r
         8Z+oahw4aQc+fkVoYQ8MpgIkXCKKc68nGnW00/rrfWqCGMvqKERweUhcQpK3NBZgJ2Uf
         I9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HuPscf/chfZUucxqeK0O8KtSwVLAMHyTryFfC0BnouI=;
        b=T3/rchffWlqczIVZF+Khr7j0srVQDPGUPC3Ol8BEzY+tpayDW0QkJnwbD+let7xFTu
         Exo+ZZKRWnGNPU5PSI89oAzLiFIDtk0pVCGKwhUmq9+MXZkr/qZqVbKfwWu3ax7Uck1M
         cM6ywVZXaa2HiWKXw1WYanj8H5O8oSr3wLXJj+8wDEkKSxLsfPoBIHbYF040TpSDDRwc
         xDcgaN0kFZqoC2CZ9gU36lYZNkzx3TM1wmH1Pw+9ecgLGeqoYSuFUlvlnlv7SgtA7e6m
         eM+9qmhKkimCOynzFEm3Byr2oy2NBokHz09YQt7yeL80RA0AJgDTMni2G5dvaz0hr0Q7
         2w+g==
X-Gm-Message-State: ANoB5pltKfLgrpH/v43J0+y9kQNaawClDFvZ/XpqVwYq8KdjpTcxIru0
        WvobA1Q4VrMGIUrYV+n/6rFxIg==
X-Google-Smtp-Source: AA0mqf69KgZUaBuDg3MrXss7tf94wwuwhowHtIdO7QNFzCE8H2TyG926JtAx4Z6Md29+4m7ZV17tMw==
X-Received: by 2002:a19:760b:0:b0:4b1:ebdb:be43 with SMTP id c11-20020a19760b000000b004b1ebdbbe43mr7257355lff.176.1669376552426;
        Fri, 25 Nov 2022 03:42:32 -0800 (PST)
Received: from [192.168.1.101] (95.49.32.48.neoplus.adsl.tpnet.pl. [95.49.32.48])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b004a2550db9ddsm494684lfo.245.2022.11.25.03.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 03:42:31 -0800 (PST)
Message-ID: <d03bd4d4-e4ef-681b-b4a5-02822e1eee75@linaro.org>
Date:   Fri, 25 Nov 2022 12:42:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Hector Martin <marcan@marcan.st>,
        "~postmarketos/upstreaming@lists.sr.ht" 
        <~postmarketos/upstreaming@lists.sr.ht>,
        "martin.botka@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen@somainline.org" <jamipkettunen@somainline.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Soon Tak Lee <soontak.lee@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st>
 <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
 <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
 <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk> <87sfke32pc.fsf@kernel.org>
 <4592f87a-bb61-1c28-13f0-d041a6e7d3bf@linaro.org>
 <CACRpkdax-3VVDd29iH51mfumakqM7jyEc8Pbb=AQwAgp2WsqFQ@mail.gmail.com>
Content-Language: en-US
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <CACRpkdax-3VVDd29iH51mfumakqM7jyEc8Pbb=AQwAgp2WsqFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.11.2022 14:56, Linus Walleij wrote:
> On Fri, Nov 18, 2022 at 5:47 PM Konrad Dybcio <konrad.dybcio@linaro.org> wrote:
> 
>> I can think of a couple of hacky ways to force use of 43596 fw, but I
>> don't think any would be really upstreamable..
> 
> If it is only known to affect the Sony Xperias mentioned then
> a thing such as:
> 
> if (of_machine_is_compatible("sony,xyz") ||
>     of_machine_is_compatible("sony,zzz")... ) {
>    // Enforce FW version
> }
> 
> would be completely acceptable in my book. It hammers the
> problem from the top instead of trying to figure out itsy witsy
> details about firmware revisions.
> 
> Yours,
> Linus Walleij
Actually, I think I came up with a better approach by pulling a page
out of Asahi folks' book - please take a look and tell me what you
think about this:

[1] https://github.com/SoMainline/linux/commit/4b6fccc995cd79109b0dae4e4ab2e48db97695e7
[2] https://github.com/SoMainline/linux/commit/e3ea1dc739634f734104f37fdbed046873921af7


Konrad
