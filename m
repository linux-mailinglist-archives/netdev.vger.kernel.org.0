Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077116D1705
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjCaFvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjCaFvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:51:44 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F70212CFF;
        Thu, 30 Mar 2023 22:51:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680241837; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ic1Zl8sh4KT0Ax/q9hwmH3t7PgKApI5VtyqNdxk5hG7lwObmn9CsrtI2abVQNAMdQUfYRrTsctjMkdkxp2I7vAwXYiAvo7ileGV3kA2HpEEA6vcUkTY+48RsLA/sv8DBucI1l7FuJo7Pm4ldFqm56MiXlT8xTrKph9tG5m7KP3Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680241837; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=q/BsPbhW7vFpTCL55oyjByd3N9hDsleO2jxgMjcyVBs=; 
        b=CyCFS5Ncxd+lbrSNsDT8j7K8Fg1T96FS0wE/QQLRlVMsOkbGXgkj3MJWY8UA7Ea/rghino9XHDENudNJdbN+97LnKdgWS3qnAmyAmQWYXtlkdSXaD0pOuNzssmt8RrdSzv+h79dBX9B6h2BiTGZbQXisNWV5YddJD3j3qMqWn80=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680241837;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=q/BsPbhW7vFpTCL55oyjByd3N9hDsleO2jxgMjcyVBs=;
        b=CnuIuOLtP0+y6gEdlg0HC2LhNdJgnb6NMyEY7DRi1evpAFKWexebULKMZtVz+oHi
        xGzUwyAFclDpkmdObP1dzHbxah2pKYN+Xoi7cvelTmTwmmD4z98kvfa0VvV+mVfUexU
        ZrkSTWr82+nx0blufKW/nFzjnBrQE7E5omnriNS0=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680241835272948.3264795872119; Thu, 30 Mar 2023 22:50:35 -0700 (PDT)
Message-ID: <6a7c5f81-a8a3-27b5-4af3-7175a3313f9a@arinc9.com>
Date:   Fri, 31 Mar 2023 08:50:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 14/15] net: dsa: mt7530: introduce driver for
 MT7988 built-in switch
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
References: <cover.1680180959.git.daniel@makrotopia.org>
 <fef2cb2fe3d2b70fa46e93107a0c862f53bb3bfa.1680180959.git.daniel@makrotopia.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <fef2cb2fe3d2b70fa46e93107a0c862f53bb3bfa.1680180959.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.03.2023 18:23, Daniel Golle wrote:
> Add driver for the built-in Gigabit Ethernet switch which can be found
> in the MediaTek MT7988 SoC.
> 
> The switch shares most of its design with MT7530 and MT7531, but has
> it's registers mapped into the SoCs register space rather than being
> connected externally or internally via MDIO.
> 
> Introduce a new platform driver to support that.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>   MAINTAINERS                   |   2 +
>   drivers/net/dsa/Kconfig       |  12 ++++
>   drivers/net/dsa/Makefile      |   1 +
>   drivers/net/dsa/mt7530-mmio.c | 101 ++++++++++++++++++++++++++++++++++
>   drivers/net/dsa/mt7530.c      |  86 ++++++++++++++++++++++++++++-
>   drivers/net/dsa/mt7530.h      |  12 ++--
>   6 files changed, 206 insertions(+), 8 deletions(-)
>   create mode 100644 drivers/net/dsa/mt7530-mmio.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 14924aed15ca7..674673dbdfd8b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13174,9 +13174,11 @@ MEDIATEK SWITCH DRIVER
>   M:	Sean Wang <sean.wang@mediatek.com>
>   M:	Landen Chao <Landen.Chao@mediatek.com>
>   M:	DENG Qingfang <dqfext@gmail.com>
> +M:	Daniel Golle <daniel@makrotopia.org>
>   L:	netdev@vger.kernel.org
>   S:	Maintained
>   F:	drivers/net/dsa/mt7530-mdio.c
> +F:	drivers/net/dsa/mt7530-mmio.c
>   F:	drivers/net/dsa/mt7530.*
>   F:	net/dsa/tag_mtk.c
>   
> diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
> index c2551b13324c2..de4d86e37973f 100644
> --- a/drivers/net/dsa/Kconfig
> +++ b/drivers/net/dsa/Kconfig
> @@ -52,6 +52,18 @@ config NET_DSA_MT7530
>   	  Multi-chip module MT7530 in MT7621AT, MT7621DAT, MT7621ST and
>   	  MT7623AI SoCs is supported as well.
>   
> +config NET_DSA_MT7988
> +	tristate "MediaTek MT7988 built-in Ethernet switch support"
> +	select NET_DSA_MT7530_COMMON
> +	depends on HAS_IOMEM
> +	help
> +	  This enables support for the built-in Ethernet switch found
> +	  in the MediaTek MT7988 SoC.
> +	  The switch is a similar design as MT7531, however, unlike
> +	  other MT7530 and MT7531 the switch registers are directly
> +	  mapped into the SoCs register space rather than being accessible
> +	  via MDIO.
> +
>   config NET_DSA_MV88E6060
>   	tristate "Marvell 88E6060 ethernet switch chip support"
>   	select NET_DSA_TAG_TRAILER
> diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
> index 71250d7dd41af..103a33e20de4b 100644
> --- a/drivers/net/dsa/Makefile
> +++ b/drivers/net/dsa/Makefile
> @@ -8,6 +8,7 @@ endif
>   obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
>   obj-$(CONFIG_NET_DSA_MT7530_COMMON) += mt7530.o
>   obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530-mdio.o
> +obj-$(CONFIG_NET_DSA_MT7988)	+= mt7530-mmio.o

I'm not fond of this way. Wouldn't it be better if we split the mdio and 
mmio drivers to separate modules and kept switch hardware support on 
mt7530.c?

The mmio driver could be useful in the future for the MT7530 on the 
MT7620 SoCs or generally new hardware that would use MMIO to be controlled.

Luiz did this for the Realtek switches that use MDIO and SMI to be 
controlled.

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/realtek/Kconfig

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/realtek/Makefile

Arınç
