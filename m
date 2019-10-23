Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93220E2405
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 22:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389389AbfJWUKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 16:10:05 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:34066 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730318AbfJWUKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 16:10:05 -0400
Received: by mail-ed1-f49.google.com with SMTP id b72so7815429edf.1;
        Wed, 23 Oct 2019 13:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=C1NbfjOuUTsXYRctJ+TahLyVOHakGWGNdk4fyJjLp9A=;
        b=jNFK7rbG6GM43VxqVeMfmX0GUT/q18dLyodhNk8SHuNYeY8X7fC9oW7VEPm+C3J2Kz
         W1ZizKY60mZn8HGXuafW1xDpdwHlfedQexRfm5y/emsdCz54V4oP6eltP2XWyCd52Tal
         2dUg0OdoY4/G1Y5b9U9F2Vw7l6NNZ+b+K0UzkeJ7RR7x9Bv48C8yTookFgKqdI5DF9W7
         qnWZtevkurE0uHqLQfQ8VgFMT7AyzOUOscfvofm5lmpXME//G9/oCBgymH4cG+yWuiT4
         TYSqoh9uHv2NYm7W6Vs6if0QI5iUrE8sjYBfiGDy9GpYVZcSu1txKHuX+b2VMmvD9eR3
         gwyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=C1NbfjOuUTsXYRctJ+TahLyVOHakGWGNdk4fyJjLp9A=;
        b=I5KOLmqggJH+RI21RsNNNnVcL44HR+6ys4p9vZjkz7WyOFJXXDyKS32UHhIgJNc2bq
         SJe4QPAvGNuD4C16T3zLj1mn6rSnbfQCMZ8sUPT43zCJxtAi6tuAe1yL+HT0v3qGwd1L
         RMGUwBijVCqAQu2Ht8vbzw1/FRrv02IyU12/Q/m5c7QhzsqHaFkwn7yF2hcBIJVMnCNQ
         fBnUiAO9m6aw9cwXUc0meFBeJXvJtgWSMk+ISoVZ6BnD2JtNtfBHrgBcF8PPv58eEIFn
         uFXNq8p2GE5y5BNsV08Xic7yh96K3/HY/tlIR+xS99ZG8vMMfdaCNsxtgz9eLhG4dEP9
         7pFg==
X-Gm-Message-State: APjAAAU914NEC7E9dQ++PiyvfQxU4ripvoLnxb5TV9MoFEelqvr/DKhO
        wGFRxYFOTxtDY9tJAdTKNxc=
X-Google-Smtp-Source: APXvYqzYe28YjM3kzXcH00uYMzHG30FNnyv6ODvygeohVjBtT4lsFb7SivWJLOWKsqkEcP8yonn7kg==
X-Received: by 2002:a17:906:858d:: with SMTP id v13mr24700263ejx.61.1571861402855;
        Wed, 23 Oct 2019 13:10:02 -0700 (PDT)
Received: from localhost (ip1f113d5e.dynamic.kabel-deutschland.de. [31.17.61.94])
        by smtp.gmail.com with ESMTPSA id a20sm842757edt.95.2019.10.23.13.10.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 13:10:02 -0700 (PDT)
Date:   Wed, 23 Oct 2019 22:10:00 +0200
From:   Oliver Graute <oliver.graute@gmail.com>
To:     fugang.duan@nxp.com
Cc:     festevam@gmail.com,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Subject: fec driver: ethernet rx is deaf on variscite imx6ul board
Message-ID: <20191023201000.GE20321@ripley>
Mail-Followup-To: fugang.duan@nxp.com, festevam@gmail.com,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I use the following nodes in my devicetree to get two ethernet ports
working with fec driver on a Variscite DART-6UL SoM Board (imx6ul).

But ethernet RX is deaf and not working. Some clue whats is the issue
here? 

Best regards,

Oliver

&fec1 {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_enet1>;
	phy-mode = "rmii";
	phy-reset-gpios = <&gpio5 0 1>;
	phy-reset-duration = <100>;
	phy-handle = <&ethphy0>;
};

&fec2 {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_enet2>;
	phy-mode = "rmii";
	phy-handle = <&ethphy1>;
	phy-reset-gpios = <&gpio1 10 1>;
	phy-reset-duration = <100>;

	mdio {
		#address-cells = <1>;
		#size-cells = <0>;

		ethphy0: ethernet-phy@1 {
			compatible = "ethernet-phy-ieee802.3-c22";
			micrel,rmii-reference-clock-select-25-mhz;
			clocks = <&clk_rmii_ref>;
			clock-names = "rmii-ref";
			reg = <1>;
		};

		ethphy1: ethernet-phy@3 {
			compatible = "ethernet-phy-ieee802.3-c22";
			micrel,rmii-reference-clock-select-25-mhz;
			clocks = <&clk_rmii_ref>;
			clock-names = "rmii-ref";
			reg = <3>;
		};
	};
};
	pinctrl_enet1: enet1grp {
		fsl,pins = <
			MX6UL_PAD_ENET1_RX_EN__ENET1_RX_EN	0x1b0b0
			MX6UL_PAD_ENET1_RX_ER__ENET1_RX_ER	0x1b0b0
			MX6UL_PAD_ENET1_RX_DATA0__ENET1_RDATA00	0x1b0b0
			MX6UL_PAD_ENET1_RX_DATA1__ENET1_RDATA01	0x1b0b0
			MX6UL_PAD_ENET1_TX_EN__ENET1_TX_EN	0x1b0b0
			MX6UL_PAD_ENET1_TX_DATA0__ENET1_TDATA00	0x1b0b0
			MX6UL_PAD_ENET1_TX_DATA1__ENET1_TDATA01	0x1b0b0
			MX6UL_PAD_ENET1_TX_CLK__ENET1_REF_CLK1	0x4001b031
		>;
	};

	pinctrl_enet2: enet2grp {
		fsl,pins = <
			MX6UL_PAD_ENET2_RX_EN__ENET2_RX_EN	0x1b0b0
			MX6UL_PAD_ENET2_RX_ER__ENET2_RX_ER	0x1b0b0
			MX6UL_PAD_ENET2_RX_DATA0__ENET2_RDATA00	0x1b0b0
			MX6UL_PAD_ENET2_RX_DATA1__ENET2_RDATA01	0x1b0b0
			MX6UL_PAD_ENET2_TX_EN__ENET2_TX_EN	0x1b0b0
			MX6UL_PAD_ENET2_TX_DATA0__ENET2_TDATA00	0x1b0b0
			MX6UL_PAD_ENET2_TX_DATA1__ENET2_TDATA01	0x1b0b0
			MX6UL_PAD_ENET2_TX_CLK__ENET2_REF_CLK2	0x4001b031
			MX6UL_PAD_JTAG_MOD__GPIO1_IO10		0x1b0b0
		>;
	};
