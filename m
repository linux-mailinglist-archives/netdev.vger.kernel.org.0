Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4752D5900
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389359AbgLJLLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 06:11:45 -0500
Received: from 1.mo68.mail-out.ovh.net ([46.105.41.146]:59339 "EHLO
        1.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387554AbgLJLLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 06:11:44 -0500
X-Greylist: delayed 3333 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2020 06:11:42 EST
Received: from player728.ha.ovh.net (unknown [10.108.4.24])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id 21D53182807
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 11:15:27 +0100 (CET)
Received: from armadeus.com (lfbn-str-1-77-132.w92-140.abo.wanadoo.fr [92.140.204.132])
        (Authenticated sender: sebastien.szymanski@armadeus.com)
        by player728.ha.ovh.net (Postfix) with ESMTPSA id D2BEC18F28450;
        Thu, 10 Dec 2020 10:15:08 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-97G0020d5c1313-f4da-4972-9333-06acb63b90e1,
                    8EAEE80FF2F1CA12C9851A06ABB588534C704F12) smtp.auth=sebastien.szymanski@armadeus.com
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Philippe Schenker <philippe.schenker@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, linux-imx@nxp.com,
        kernel@pengutronix.de, David Jander <david@protonic.nl>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org
References: <20201209122051.26151-1-o.rempel@pengutronix.de>
From:   =?UTF-8?Q?S=c3=a9bastien_Szymanski?= 
        <sebastien.szymanski@armadeus.com>
Subject: Re: [PATCH v1] ARM: imx: mach-imx6ul: remove 14x14 EVK specific PHY
 fixup
Message-ID: <4650b811-0bd8-74b5-044b-562b287c0e09@armadeus.com>
Date:   Thu, 10 Dec 2020 11:15:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201209122051.26151-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 17671843464484443388
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedrudektddgudefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepvfhfhffukffffgggjggtgfesthekredttdefjeenucfhrhhomhepuforsggrshhtihgvnhgpufiihihmrghnshhkihcuoehsvggsrghsthhivghnrdhsiiihmhgrnhhskhhisegrrhhmrgguvghushdrtghomheqnecuggftrfgrthhtvghrnhepfedtjeduffegfedvgeeffffhgfffjeejfeevheekgffhkefhgfetjefgleduuddunecukfhppedtrddtrddtrddtpdelvddrudegtddrvddtgedrudefvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejvdekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepshgvsggrshhtihgvnhdrshiihihmrghnshhkihesrghrmhgruggvuhhsrdgtohhmpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/9/20 1:20 PM, Oleksij Rempel wrote:
> Remove board specific PHY fixup introduced by commit:
> 
> | 709bc0657fe6f9f5 ("ARM: imx6ul: add fec MAC refrence clock and phy fixup init")
> 
> This fixup addresses boards with a specific configuration: a KSZ8081RNA
> PHY with attached clock source to XI (Pin 8) of the PHY equal to 50MHz.
> 
> For the KSZ8081RND PHY, the meaning of the reg 0x1F bit 7 is different
> (compared to the KSZ8081RNA). A set bit means:
> 
> - KSZ8081RNA: clock input to XI (Pin 8) is 50MHz for RMII
> - KSZ8081RND: clock input to XI (Pin 8) is 25MHz for RMII

OPOS6UL has a KSZ80801RNB. On this PHY variant, bit 7 of reg 0x1F means:
1: RMII 50MHz clock mode; clock input to XI (Pin 9) is 50MHz
0: RMII 25MHz clock mode; clock input to XI (Pin 9) is 25MHz

> 
> In other configurations, for example a KSZ8081RND PHY or a KSZ8081RNA
> with 25Mhz clock source, the PHY will glitch and stay in not recoverable
> state.
> 
> It is not possible to detect the clock source frequency of the PHY. And
> it is not possible to automatically detect KSZ8081 PHY variant - both
> have same PHY ID. It is not possible to overwrite the fixup
> configuration by providing proper device tree description. The only way
> is to remove this fixup.
> 
> If this patch breaks network functionality on your board, fix it by
> adding PHY node with following properties:
> 
> 	ethernet-phy@x {
> 		...
> 		micrel,led-mode = <1>;
> 		clocks = <&clks IMX6UL_CLK_ENET_REF>;
> 		clock-names = "rmii-ref";
> 		...
> 	};

On OPOS6UL, this fix do fixes network breakage introduced by this patch.
So, for OPOS6UL,

Tested-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>

> 
> The board which was referred in the initial patch is already fixed.
> See: arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  arch/arm/mach-imx/mach-imx6ul.c | 21 ---------------------
>  1 file changed, 21 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mach-imx6ul.c b/arch/arm/mach-imx/mach-imx6ul.c
> index e018e716735f..eabcd35c01a5 100644
> --- a/arch/arm/mach-imx/mach-imx6ul.c
> +++ b/arch/arm/mach-imx/mach-imx6ul.c
> @@ -27,30 +27,9 @@ static void __init imx6ul_enet_clk_init(void)
>  		pr_err("failed to find fsl,imx6ul-iomux-gpr regmap\n");
>  }
>  
> -static int ksz8081_phy_fixup(struct phy_device *dev)
> -{
> -	if (dev && dev->interface == PHY_INTERFACE_MODE_MII) {
> -		phy_write(dev, 0x1f, 0x8110);
> -		phy_write(dev, 0x16, 0x201);
> -	} else if (dev && dev->interface == PHY_INTERFACE_MODE_RMII) {
> -		phy_write(dev, 0x1f, 0x8190);
> -		phy_write(dev, 0x16, 0x202);
> -	}
> -
> -	return 0;
> -}
> -
> -static void __init imx6ul_enet_phy_init(void)
> -{
> -	if (IS_BUILTIN(CONFIG_PHYLIB))
> -		phy_register_fixup_for_uid(PHY_ID_KSZ8081, MICREL_PHY_ID_MASK,
> -					   ksz8081_phy_fixup);
> -}
> -
>  static inline void imx6ul_enet_init(void)
>  {
>  	imx6ul_enet_clk_init();
> -	imx6ul_enet_phy_init();
>  }
>  
>  static void __init imx6ul_init_machine(void)
> 


-- 
Sébastien Szymanski, Armadeus Systems
Software engineer
