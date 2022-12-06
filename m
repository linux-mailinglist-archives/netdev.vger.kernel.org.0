Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB45644FB8
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLFXiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLFXiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:38:12 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE8545A20
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 15:38:10 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3e45d25de97so112919417b3.6
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 15:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iMeYuP/IHBLdEkldut+tJt83tnk8BcGmkM9CbSyHlFA=;
        b=r33OvNK2vouj/RUCapruSqB5z+SEWuKjo/v0FtdmTHNEiB1bhsl3LKwcWGxRLJxfQv
         QDXi9cX4aQk4XRdSOH/7iUu6Bl+b+eitsw2i3ooxmBigZvONyt8BVpbrLTdYkK+ATc0/
         kcdJD16MIbGQE1nJImcppwey7pxm/r1Ny2ZVFC+55SIiRPwqaD+aaGGyGtI6Ll1ztqX7
         XDAJKRp8iEyQfKuo9unh2ZHFeGRmEmGTfb+b7/FE/wPkNIDHNxovfvHeLPRjyAN0oSrE
         54rZpWflr8ixj07RdC+xedXQQjcSr9g41aWmZOBQXaw9cE/jK/klIvYe4Q9+KQNwAyMP
         C7CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iMeYuP/IHBLdEkldut+tJt83tnk8BcGmkM9CbSyHlFA=;
        b=CMQwk1yuVZvE2tWVSG2ddG9vGoz5L5WZCILKXD/JJ+uaHuouEDv+iOqeZQ1kl6Y+4D
         r9AWiX3JsQcpoXK+CQJWE1XA5wmsRQyTJF03ftIQnRymWjNAOCVYklTM7obqvzSSTgZy
         H1U74aIK+wO3Ui4uKgcNsRwQBoewenaHPu97AxQ0bhqcaYkWYV+im6Q9nj+s+tog8Xc5
         a+T2+/VUDQAFTrVPttaHlZlr/6Hs5SM7FHn9CPFEYPFHRnnhssdf2MFTo+anK0aQ05bo
         5/fzt4VXiy290/f0rQiC+9jlJ2V7eMNqv7oxRxeDEvi8fqTnYsZrJpB50oybd9skEea/
         vsOw==
X-Gm-Message-State: ANoB5pmT6p+E5nlxqVZZLjDU3eHdF19PPYvGMVjo0RKGCJE0bxUxmhNO
        ExeZ/ctzTkfDrumZ13vvT42VqZ361CXVoOVE1P0W5A==
X-Google-Smtp-Source: AA0mqf4GTH7r4BUD6E/vaD6DN9DWu08A2GD9X5LPfQeXKoAkdHS4YGuN+yaVSSkQbETQkqd4MnVh0mCw8oLrPP71MPQ=
X-Received: by 2002:a81:798f:0:b0:37a:e8f:3cd3 with SMTP id
 u137-20020a81798f000000b0037a0e8f3cd3mr19373621ywc.187.1670369889710; Tue, 06
 Dec 2022 15:38:09 -0800 (PST)
MIME-Version: 1.0
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org> <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
 <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org> <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
 <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk> <87sfke32pc.fsf@kernel.org>
 <4592f87a-bb61-1c28-13f0-d041a6e7d3bf@linaro.org> <CACRpkdax-3VVDd29iH51mfumakqM7jyEc8Pbb=AQwAgp2WsqFQ@mail.gmail.com>
 <d03bd4d4-e4ef-681b-b4a5-02822e1eee75@linaro.org> <87fse76yig.fsf@kernel.org>
 <fc2812b1-db96-caa6-2ecb-c5bb2c33246a@linaro.org> <87bkov6x1q.fsf@kernel.org>
 <CACRpkdbpJ8fw0UsuHXGX43JRyPy6j8P41_5gesXOmitHvyoRwQ@mail.gmail.com>
 <28991d2d-d917-af47-4f5f-4e8183569bb1@linaro.org> <c83d7496-7547-2ab4-571a-60e16aa2aa3d@broadcom.com>
 <6e4f1795-08b5-7644-d1fa-102d6d6b47fb@linaro.org> <af489711-6849-6f87-8ea3-6c8216f0007b@broadcom.com>
 <62566987-6bd2-eed3-7c2f-ec13c5d34d1b@gmail.com> <21fc5c0e-f880-7a14-7007-2d28d5e66c7d@linaro.org>
In-Reply-To: <21fc5c0e-f880-7a14-7007-2d28d5e66c7d@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 7 Dec 2022 00:37:57 +0100
Message-ID: <CACRpkdbNssF5c7oJnm-EbjAJnD25kv2V7wp+TCKQZnVHJsni-g@mail.gmail.com>
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
To:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend Van Spriel <aspriel@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Hector Martin <marcan@marcan.st>,
        "martin.botka@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen@somainline.org" <jamipkettunen@somainline.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, phone-devel@vger.kernel.org
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

On Tue, Dec 6, 2022 at 10:59 AM Konrad Dybcio <konrad.dybcio@linaro.org> wrote:

> Yes, it does seem to work just fine! The kernel now looks for
> brcm/brcmfmac4359c-pcie.sony,kagura-row.bin as we would expect.

So the Sony kagura needs a special brcmfmac firmware like so many
other mobile phones. There are a few Samsungs with custom firmware
as well.

Arend: what is the legal situation with these custom firmwares?

I was under the impression that Broadcom actually made these,
so they could in theory be given permission for redistribution in
linux-firmware?

Some that I have are newer versions than what is in Linux-firmware,
e.g this from linux-firmware:

brcm/brcmfmac4330-sdio.bin
4330b2-roml/sdio-ag-pool-ccx-btamp-p2p-idsup-idauth-proptxstatus-pno-aoe-toe-pktfilter-keepalive
Version: 5.90.125.104 CRC: 2570e6a3 Date: Tue 2011-10-25 19:34:26 PDT

There is this found in Samsung Codina GT-I8160:
4330b2-roml/sdio-g-p2p-aoe-pktfilter-keepalive-pno-ccx-wepso Version:
5.99.10.0 CRC: 4f7fccf Date: Wed 2012-12-05 01:02:50 PST FWID
01-52653ba9

Or:
brcmfmac4334-sdio.bin
4334b1min-roml/sdio-ag-pno-p2p-ccx-extsup-proptxstatus-dmatxrc-rxov-pktfilter-keepalive-aoe-vsdb-wapi-wl11d
Version: 6.10.0.0 CRC: 31410dd4 Date: Tue 2012-06-26 11:33:07 PDT FWID
01-8ee3be86

There is this found in Samsung Golden GT-I8190N:
4334b1-roml/sdio-ag-p2p-extsup-aoe-pktfilter-keepalive-pno-dmatxrc-rxov-proptxstatus-vsdb-mchan-okc-rcc-fmc-wepso-txpwr-autoabn-sr
Version: 6.10.58.99 CRC: 828f9174 Date: Mon 2013-08-26 02:13:44 PDT
FWID 01-e39d4d77

So in some cases more than a year newer firmware versions
compared to linux-firmware, I guess also customized for the
phones, but I can't really tell because we don't have anything
of similar date in linux-firmware.

Yours,
Linus Walleij
