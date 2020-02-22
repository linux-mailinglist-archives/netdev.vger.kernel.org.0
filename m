Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8279168E8E
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 12:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgBVLlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 06:41:51 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:48477 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgBVLlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 06:41:51 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id AFB6122F43;
        Sat, 22 Feb 2020 12:41:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582371709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5rMQSooxdrmNpbI3Gk43YVHWsQamSQ5BVKAeoY/eF7Y=;
        b=jMOey1VlZv3VJgw/HwupTlvFr8BmPI+3mJ2XOKlxoCvvUWG0/qApZQFvQOxpERW9yD4jSI
        aMZikSrlb/dkgNVdbLLiU7IAaEYvZckTFqrpQOmhZXbDazQ2b0rpfPLbhKtEJnKmnzTabu
        1MrK0NIa9lvMcuxlJWxqdeO0hprU1EU=
From:   Michael Walle <michael@walle.cc>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, vivien.didelot@gmail.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH v2 net-next/devicetree 5/5] arm64: dts: fsl: ls1028a: enable switch PHYs on RDB
Date:   Sat, 22 Feb 2020 12:41:36 +0100
Message-Id: <20200222114136.595-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200219151259.14273-6-olteanv@gmail.com>
References: <20200219151259.14273-6-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++
X-Spam-Level: ****
X-Rspamd-Server: web
X-Spam-Status: No, score=4.90
X-Spam-Score: 4.90
X-Rspamd-Queue-Id: AFB6122F43
X-Spamd-Result: default: False [4.90 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.635];
         DKIM_SIGNED(0.00)[];
         DBL_PROHIBIT(0.00)[0.0.0.12:email,0.0.0.11:email,0.0.0.13:email,0.0.0.10:email];
         RCPT_COUNT_TWELVE(0.00)[12];
         MID_CONTAINS_FROM(1.00)[];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c::/31, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,davemloft.net,vger.kernel.org,gmail.com,arm.com,kernel.org,walle.cc]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Link the switch PHY nodes to the central MDIO controller PCIe endpoint
> node on LS1028A (implemented as PF3) so that PHYs are accessible via
> MDIO.
> 
> Enable SGMII AN on the Felix PCS by telling PHYLINK that the VSC8514
> quad PHY is capable of in-band-status.
> 
> The PHYs are used in poll mode due to an issue with the interrupt line
> on current revisions of the LS1028A-RDB board.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> Changes in v2:
> None.
> 
>  .../boot/dts/freescale/fsl-ls1028a-rdb.dts    | 51 +++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> index afb55653850d..9353c00e46a7 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> @@ -194,6 +194,57 @@
>  	status = "disabled";
>  };
>  
> +&enetc_mdio_pf3 {
> +	/* VSC8514 QSGMII quad PHY */
> +	qsgmii_phy0: ethernet-phy@10 {
> +		reg = <0x10>;
> +	};
> +
> +	qsgmii_phy1: ethernet-phy@11 {
> +		reg = <0x11>;
> +	};
> +
> +	qsgmii_phy2: ethernet-phy@12 {
> +		reg = <0x12>;
> +	};
> +
> +	qsgmii_phy3: ethernet-phy@13 {
> +		reg = <0x13>;
> +	};
> +};
> +
> +&mscc_felix_port0 {
> +	status = "okay";
status should be the last property, correct?

-michael

> +	label = "swp0";
> +	managed = "in-band-status";
> +	phy-handle = <&qsgmii_phy0>;
> +	phy-mode = "qsgmii";
> +};
> +
> +&mscc_felix_port1 {
> +	status = "okay";
> +	label = "swp1";
> +	managed = "in-band-status";
> +	phy-handle = <&qsgmii_phy1>;
> +	phy-mode = "qsgmii";
> +};
> +
> +&mscc_felix_port2 {
> +	status = "okay";
> +	label = "swp2";
> +	managed = "in-band-status";
> +	phy-handle = <&qsgmii_phy2>;
> +	phy-mode = "qsgmii";
> +};
> +
> +&mscc_felix_port3 {
> +	status = "okay";
> +	label = "swp3";
> +	managed = "in-band-status";
> +	phy-handle = <&qsgmii_phy3>;
> +	phy-mode = "qsgmii";
> +};
> +
>  &sai4 {
>  	status = "okay";
>  };
> -- 
> 2.17.1


