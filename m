Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C58A51F4A4
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 08:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiEIGfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 02:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbiEIGco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 02:32:44 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95102187D80
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 23:28:51 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id x12so11197391pgj.7
        for <netdev@vger.kernel.org>; Sun, 08 May 2022 23:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nnkKgOtRZpajFfn5k+JckXZje9jqCSsEoElY6uWQMWs=;
        b=Hkup1DQA1R9QqMdcWr1sFH0/CzK7ytflBPW3kBTsY21C08mgsnxSuibId3zoMlQ4U/
         ZW2pGGwqY6CG4cTLUCwfXR5by7NMVsEL6ZeSTXn8raHQHTfW91nU9iuZPH227ghcI9b3
         8xvCROOw+GRTo/9ZPB474aJUUDqu6jZIL5D9Ds8OWiy/vSaXJ210+y/tPUFYJHpFxnTG
         1rdiqOCbGyqshs4L427MhG2ZLqoo7TGZUdJxzEss/CxdwEqx1PQzu3mFucdt2Kax3jyp
         CGrOYnYF/lZIJJLhKPAmnwcQN2fdAG52Tf0Evc67jJ/SzAjN+eeQV9f6K0/Vv189Fv79
         JQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nnkKgOtRZpajFfn5k+JckXZje9jqCSsEoElY6uWQMWs=;
        b=2oPNVa13jSW325dnKbwO65VRLY2fEj+BoFCIigwG3TRaCZNvq/O5okAsQF4cmkFeHQ
         PT8Om87aElA5sQXJVOc0TTJsJ0bOIwUgxm+WrF8ftZf/Tgo1XjRvgnTxYD0hpv/X7le2
         mWuOzArSnVV8c1MP1jDHfSXHbbQu2N6vZ1xHyes9lyDuOh2UHrKc3bwb+FD4qiKK4vEU
         2tRYkC/DyPEAs4cmQzKw9vgcYPqQaAIFRqU5uG9AXsd5MmcLw2+JrcZh3/tLVglYVYCs
         i5sYjkY7j1sAKjtpHR8fqoec64WELKw0Jk57GujEoeD95wIQ0YkJ+eT7nGblPI+EoaDt
         tP5Q==
X-Gm-Message-State: AOAM5325enc8fa+2uhYh7vVYq1H7lhb8yiOL/SCgoL8f04CCezIBQH8H
        qFbTRQ6UNFi7iA6jRUIrh5J8e2eoqSVA7hXUnUCTzsgUYEYGVQ==
X-Google-Smtp-Source: ABdhPJzIv/bGQ3aiXnjd01pgavMikMNVSmlYMN09z5ZZHEKv+ULP3lZUDvv2Pn/Y5yE2z2+M9GHIU9aaHc4vgPBVeX4=
X-Received: by 2002:a63:3d0b:0:b0:37f:ef34:1431 with SMTP id
 k11-20020a633d0b000000b0037fef341431mr12063979pga.547.1652077728087; Sun, 08
 May 2022 23:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220508224848.2384723-1-hauke@hauke-m.de>
In-Reply-To: <20220508224848.2384723-1-hauke@hauke-m.de>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 9 May 2022 03:28:37 -0300
Message-ID: <CAJq09z7+bDpMShTxuOvURmp272d-FVDNaDpx1_-qjuOZOOrS3g@mail.gmail.com>
Subject: Re: [PATCH 0/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This was tested on a Buffalo WSR-2533DHP2. This is a board using a
> Mediatek MT7622 SoC and its 2.5G Ethernet MAC connected over a 2.5G
> HSGMII link to a RTL8367S switch providing 5 1G ports.
> This is the only board I have using this switch.
>
> With the DSA_TAG_PROTO_RTL8_4 tag format the TCP checksum for all TCP
> send packets is wrong. It is set to 0x83c6. The mac driver probably
> should do some TCP checksum offload, but it does not work.

0x83c6 might be yout tcp pseudo ip header sum.

> When I used the DSA_TAG_PROTO_RTL8_4T tag format the send packets are
> ok, but it looks like the system does TCP Large receive offload, but
> does not update the TCP checksum correctly. I see that multiple received
> TCP packets are combined into one (using tcpdump on switch port on
> device). The switch tag is also correctly removed. tcpdump complains
> that the checksum is wrong, it was updated somewhere, but it is wrong.
>
> Does anyone know what could be wrong here and how to fix this?

The good news, it is a known problem:

https://patchwork.kernel.org/project/netdevbpf/patch/20220411230305.28951-1=
-luizluca@gmail.com/
(there are some interesting discussions)
https://patchwork.kernel.org/project/netdevbpf/patch/20220416052737.25509-1=
-luizluca@gmail.com/
(merged)

The bad news, there is no way to enable checksum offload with
mediatek+realtek. You'll need to disable almost any type of offload.
For any tag before the IP header, if your driver/HW does not support a
way to set where the IP header starts and the offload HW does not
understand the tag protocol, the offload HW will keep the pseudo ip
header sum. And for tags after the payload, the offload HW will blend
the tag with the payload, generating bad checksums when the switch
removes the tag.

You can do that from userland, using ethtool on the master port before
the bridge is up, or patching the driver. You can try this patch
(written for MT7620 but it is easy to adapt it to upstream
mtk_eth_soc.c).
https://github.com/luizluca/openwrt/commit/d799bd363f902bf3b9c595972a1b9280=
a0b61dca
. I never submitted that upstream because I don't have the HW to test
it (Arin=C3=A7 tested a modified version in an MT7621) and I didn't
investigate how much those extra ifs in ndo_features_check will cost
in performance when the driver does support the tag (using a mediatek
switch).

And the DSA_TAG_PROTO_RTL8_4T already paid off. It was added exactly
as a way to test checksum errors. Probably no offload will work for
tags that are after the payload if the offload HW does not already
know that tag (e.g. same vendors). DSA_TAG_PROTO_RTL8_4T works because
it calculates the checksum in software before the tag is added.
However, during my tests, I never tested TCP Large receive offload.

> This uses the rtl8367s-sgmii.bin firmware file. I extracted it from a
> GPL driver source code with a GPL notice on top. I do not have the
> source code of this firmware. You can download it here:
> https://hauke-m.de/files/rtl8367/rtl8367s-sgmii.bin
> Here are some information about the source:
> https://hauke-m.de/files/rtl8367/rtl8367s-sgmii.txt
>
> This file does not look like intentional GPL. It would be nice if
> Realtek could send this file or a similar version to the linux-firmware
> repository under a license which allows redistribution. I do not have
> any contact at Realtek, if someone has a contact there it would be nice
> if we can help me on this topic.
>
> Hauke Mehrtens (4):
>   net: dsa: realtek: rtl8365mb: Fix interface type mask
>   net: dsa: realtek: rtl8365mb: Get chip option
>   net: dsa: realtek: rtl8365mb: Add setting MTU
>   net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
>
>  drivers/net/dsa/realtek/rtl8365mb.c | 444 ++++++++++++++++++++++++++--
>  1 file changed, 413 insertions(+), 31 deletions(-)
>
> --
> 2.30.2
>
