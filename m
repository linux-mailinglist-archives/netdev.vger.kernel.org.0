Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120FB5F3684
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 21:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJCTlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 15:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiJCTk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 15:40:57 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBFD476E7
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 12:40:54 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a2so4290891ejx.10
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 12:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=7ZLCyV1XU+1W3eDd7/CmSFyAO+fA3pewktRa/83aHzU=;
        b=pYFEs9nuJmbl4b8v/8wrZQgGXosa7KIL9+iFOV6M5w0qs278SWgv6Q5/qHdyPFm+fz
         pM+TIj8acM/SsBdd+yYDHVw7XIfeXKVMW3T+dpGcI0NzyHXuQNWhBTwljdsW5B9Wal/o
         HdYf0j8l5J09BPDfag8LjbDRE/2nPV/VzrUN18OnTuGv2C0za3ywbbzJBj/nDVCjyZ0N
         MRRTcl61VuqtHHojHlSf1A0S5gz52p8JYcgnDTZR/JNPqR82noukQC6LE+oX1e4VxskR
         kdTv/fWycv1Iy5q0nrpIoQ5JNS77t/QadlARw6w6BCZdRfrrgQcPzK08ZB9rqboKaPLR
         dg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=7ZLCyV1XU+1W3eDd7/CmSFyAO+fA3pewktRa/83aHzU=;
        b=QAl3Xb7eNFYxX/WXgS4bPusFsSnQIH3wfdkH+Mx53U1K/Ol9LZTbXARNhq82dv0Fjf
         fKnvtL66vsutc+J1Fpf+ZfcHj9rX8193XW60/pHaBMn9apopEclXQ31pTTuofWuO42/c
         2VkMd17+h/YCJkeltfzPjDuvthmgVJEaCr11WvEAXl5QlhdjMlLHhoH6kh2Mxbaios5x
         BUalErg4K8vGveIeHNZMr/zVfYlH7C4kPYDYjpjPRtccypu6Rs6HQLZBMRyHXOBNFxsh
         YrQzcaMLG4tlhln/94oYkNXCg1kbjYD8LdTV1ZeVr2apj67Hb4edvVTXxIF6QVK7kLcQ
         Z6Gg==
X-Gm-Message-State: ACrzQf1Arob5aEneVdhEFH/EUsNPWhpqWr/tvU7PE+k/f1njWMKtAlyh
        yS76dFA327kjk/T0UHBaFkaLvH6g0NfBRTfQ5e/LOw==
X-Google-Smtp-Source: AMsMyM6tkVq2MdhMLHKwX56llqPV2lSc3XgaBqz998rQO2+KN9GxC4vKqSdg4b2CGaUnhasP4SgpivwfDofqxILhhk8=
X-Received: by 2002:a17:906:58c8:b0:6fe:91d5:18d2 with SMTP id
 e8-20020a17090658c800b006fe91d518d2mr16531848ejs.190.1664826053241; Mon, 03
 Oct 2022 12:40:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st> <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st> <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
 <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk> <CACRpkdYwJLO18t08zqu_Y1gaSpZJMc+3MFxRUtQzLkJF2MqmqQ@mail.gmail.com>
 <87wn9q35tp.fsf_-_@kernel.org>
In-Reply-To: <87wn9q35tp.fsf_-_@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 3 Oct 2022 21:40:41 +0200
Message-ID: <CACRpkda_dWNs9u4W4bvzD+riGCjbCYtCy5aWADzK+w2zaanOfA@mail.gmail.com>
Subject: Re: Stockholm syndrome with Linux wireless?
To:     Kalle Valo <kvalo@kernel.org>, Peter Robinson <perobins@redhat.com>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 10:20 AM Kalle Valo <kvalo@kernel.org> wrote:

> Thanks, this was a good read! I'm always interested about user and
> downstream feedback, both good and bad :) But I didn't get the Stockholm
> syndrome comment in the end, what does he mean with that?

That refers to this:
https://en.wikipedia.org/wiki/Stockholm_syndrome

What I think Peter means is we can't have a situation where the
community is held hostage by low quality wireless vendors and
even start sympathize with their development process and level
of support.

> BTW we have a wireless workshop in netdevconf 0x16, it would be great to
> have there a this kind of session discussing user pain points:
>
> https://netdevconf.info/0x16/session.html?Wireless-Workshop

I added Peter to the thread.

Yours,
Linus Walleij
