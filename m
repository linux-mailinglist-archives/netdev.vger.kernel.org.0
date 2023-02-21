Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D6269E00A
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbjBUMP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbjBUMPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:15:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F78659F
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676981583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ueMcPyVImz9cpfurZM9ATdM8rr4FlZ3uotbL1JWr8HM=;
        b=EnTYwn9mHxFQ9Il0xKdhrBgWzkcIYj1LvmAP54MnxnsmIKHAEpep7PIc6yioTcXOaoGq1d
        EWAa52FlzzTeVql2VDNiT3PFihpVFYWT/RuGhR2GWuYC9KlkBUOo2tJ71Ib7yrgsmedxpI
        baKV5CD66TYRAEN4sIfcZKIyPUrf7mg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-596-kkJTLdoqNPegeOKba6BVKQ-1; Tue, 21 Feb 2023 06:59:29 -0500
X-MC-Unique: kkJTLdoqNPegeOKba6BVKQ-1
Received: by mail-wr1-f70.google.com with SMTP id a7-20020a056000188700b002c53d342406so729241wri.2
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 03:59:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ueMcPyVImz9cpfurZM9ATdM8rr4FlZ3uotbL1JWr8HM=;
        b=bR4iqv5KjqZKGpaYuHvT7FQ1/47uueMfoFImMEXlnaqTVcf8nKidpIjsfXE35pgu4C
         szOFxMDWebOykgwjsumt84SbYVdLanCaOFwtVdEPo1uqaWinkk9D14cfI09z5LvNjHpM
         /ZJgKNSXdvlxCSYY1pPcTv/IOdhhXXtbgl5vyaXBIyDOogCXw68I2FumQvtSmGL0/MqD
         yxOTWbbTT39BYYt8MaOggKccPNY5m3M2zxG/2aNN75AZ3QWVWz0Fy8RGb+RaIrmplh9j
         VyTFBjLwInLPy6P9qdlsJlRsAgYey7R59/7m0svDaGJ/Jg/nO2uoy/fB8DzDZMHQ+wob
         wHJw==
X-Gm-Message-State: AO0yUKWeuxpCLGa6p537nKp2uNwsXUb7xNQiSvG1U5DfomDo49EraSgG
        15x6nahFT+NUzRViheaHF+X/mCqj6pcT7uFhdXoq05DPyARvdMcKgKJNQATfwXCUaCu7QtbcAPK
        uMAjjJj1su44C3a70
X-Received: by 2002:a05:600c:319a:b0:3dc:5b88:e706 with SMTP id s26-20020a05600c319a00b003dc5b88e706mr3432726wmp.1.1676980768036;
        Tue, 21 Feb 2023 03:59:28 -0800 (PST)
X-Google-Smtp-Source: AK7set9/y3GWYFDjk83DDi2agWds5UsLqjyHuOZHo4YSWP+L1MT5uBLFjcUtMLjAIHbcdUqV8+nX8w==
X-Received: by 2002:a05:600c:319a:b0:3dc:5b88:e706 with SMTP id s26-20020a05600c319a00b003dc5b88e706mr3432713wmp.1.1676980767741;
        Tue, 21 Feb 2023 03:59:27 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id ay14-20020a05600c1e0e00b003e20cf0408esm5177202wmb.40.2023.02.21.03.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 03:59:27 -0800 (PST)
Message-ID: <3cf5c962768651adb2c1a7fa95aff7517d821bd6.camel@redhat.com>
Subject: Re: [PATCH net-next v10 00/12] net: ethernet: mtk_eth_soc: various
 enhancements
From:   Paolo Abeni <pabeni@redhat.com>
To:     Daniel Golle <daniel@makrotopia.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Date:   Tue, 21 Feb 2023 12:59:25 +0100
In-Reply-To: <cover.1676933805.git.daniel@makrotopia.org>
References: <cover.1676933805.git.daniel@makrotopia.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-21 at 11:39 +0000, Daniel Golle wrote:
> This series brings a variety of fixes and enhancements for mtk_eth_soc,
> adds support for the MT7981 SoC and facilitates sharing the SGMII PCS
> code between mtk_eth_soc and mt7530.
>=20
> Note that this series depends on commit 697c3892d825
> ("regmap: apply reg_base and reg_downshift for single register ops") to
> not break mt7530 pcs register access.
>=20
> The whole series has been tested on MT7622+MT7531 (BPi-R64),
> MT7623+MT7530 (BPi-R2) and MT7981+GPY211 (GL.iNet GL-MT3000).
>=20
> Changes since v9:
>  * fix path in mediatek,sgmiisys dt-binding
>=20
> Changes since v8:
>  * move mediatek,sgmiisys dt-bindings to correct net/pcs folder
>  * rebase on top of net-next/main so series applies cleanly again
>=20
> Changes since v7:
>  * move mediatek,sgmiisys.yaml to more appropriate folder
>  * don't include <linux/phylink.h> twice in PCS driver, sort includes
>=20
> Changes since v6:
>  * label MAC MCR bit 12 in 08/12, MediaTek replied explaining its functio=
n
>=20
> Changes since v5:
>  * drop dev pointer also from struct mtk_sgmii, pass it as function
>    parameter instead
>  * address comments left for dt-bindings
>  * minor improvements to commit messages
>=20
> Changes since v4:
>  * remove unused dev pointer in struct pcs_mtk_lynxi
>  * squash link timer check into correct follow-up patch
>=20
> Changes since v3:
>  * remove unused #define's
>  * use BMCR_* instead of #define'ing our own constants
>  * return before changing registers in case of invalid link timer
>=20
> Changes since v2:
>  * improve dt-bindings, convert sgmisys bindings to dt-schema yaml
>  * fix typo
>=20
> Changes since v1:
>  * apply reverse xmas tree everywhere
>  * improve commit descriptions
>  * add dt binding documentation
>  * various small changes addressing all comments received for v1
>=20
>=20
> Daniel Golle (12):
>   net: ethernet: mtk_eth_soc: add support for MT7981 SoC
>   dt-bindings: net: mediatek,net: add mt7981-eth binding
>   dt-bindings: arm: mediatek: sgmiisys: Convert to DT schema
>   dt-bindings: arm: mediatek: sgmiisys: add MT7981 SoC
>   net: ethernet: mtk_eth_soc: set MDIO bus clock frequency
>   net: ethernet: mtk_eth_soc: reset PCS state
>   net: ethernet: mtk_eth_soc: only write values if needed
>   net: ethernet: mtk_eth_soc: fix RX data corruption issue
>   net: ethernet: mtk_eth_soc: ppe: add support for flow accounting
>   net: pcs: add driver for MediaTek SGMII PCS
>   net: ethernet: mtk_eth_soc: switch to external PCS driver
>   net: dsa: mt7530: use external PCS driver
>=20
>  .../arm/mediatek/mediatek,sgmiisys.txt        |  25 --
>  .../devicetree/bindings/net/mediatek,net.yaml |  52 ++-
>  .../bindings/net/pcs/mediatek,sgmiisys.yaml   |  55 ++++
>  MAINTAINERS                                   |   7 +
>  drivers/net/dsa/Kconfig                       |   1 +
>  drivers/net/dsa/mt7530.c                      | 277 ++++------------
>  drivers/net/dsa/mt7530.h                      |  47 +--
>  drivers/net/ethernet/mediatek/Kconfig         |   2 +
>  drivers/net/ethernet/mediatek/mtk_eth_path.c  |  14 +-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  67 +++-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h   | 105 +++---
>  drivers/net/ethernet/mediatek/mtk_ppe.c       | 114 ++++++-
>  drivers/net/ethernet/mediatek/mtk_ppe.h       |  25 +-
>  .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |   9 +-
>  .../net/ethernet/mediatek/mtk_ppe_offload.c   |   8 +
>  drivers/net/ethernet/mediatek/mtk_ppe_regs.h  |  14 +
>  drivers/net/ethernet/mediatek/mtk_sgmii.c     | 192 ++---------
>  drivers/net/pcs/Kconfig                       |   7 +
>  drivers/net/pcs/Makefile                      |   1 +
>  drivers/net/pcs/pcs-mtk-lynxi.c               | 302 ++++++++++++++++++
>  include/linux/pcs/pcs-mtk-lynxi.h             |  13 +
>  21 files changed, 801 insertions(+), 536 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediat=
ek,sgmiisys.txt
>  create mode 100644 Documentation/devicetree/bindings/net/pcs/mediatek,sg=
miisys.yaml
>  create mode 100644 drivers/net/pcs/pcs-mtk-lynxi.c
>  create mode 100644 include/linux/pcs/pcs-mtk-lynxi.h
>=20
>=20
> base-commit: 3fcdf2dfefb6313ea0395519d1784808c0b6559b

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.

