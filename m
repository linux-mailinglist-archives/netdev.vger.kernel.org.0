Return-Path: <netdev+bounces-2328-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BE8D70143A
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 05:35:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42644281BB3
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 03:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B99EBC;
	Sat, 13 May 2023 03:35:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B78A44
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 03:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8BAC433EF;
	Sat, 13 May 2023 03:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683948918;
	bh=LJSBg2oSMmGPX4IdUR4DuCz1AKEfkqIwUgL1BtnNHgE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nTro32U2FneGAHxNgX24g1csw/lLjOtSk0Rqu4F7a/7QjhQ/ZRL9OiGbpqvPXys4i
	 RwHMF19/y1lneMLqgBjbGbeMl1thghH2JKUYkxYAgnz9phiMXF0XWAkB7SO42UXim6
	 57ZX4t7n9PlwZ6/tzJ8whEytDbk2N5tQK38vYF4M+R/QuZjwJLSk9uRNyA3IhvVsYw
	 7DSQZ/ay6e+WLYdGhdAX6Ae2vz42KCyXzOylemrW3XCNvoots2U2sDn2csqRMjA9lu
	 ftl1PYyRF791ZFPGYgzKpm0D1IBuSlrkiizzXy/8ubFzPvakP6lLkxLI838WwNaVXp
	 iVLnYttYxP57w==
Date: Sat, 13 May 2023 11:35:09 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: s.hauer@pengutronix.de, Russell King <rmk+kernel@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>, arm-soc <arm@kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: vf610: ZII: Add missing phy-mode and fixed
 links
Message-ID: <20230513033509.GD727834@dragon>
References: <20230412003746.2392518-1-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412003746.2392518-1-andrew@lunn.ch>

On Wed, Apr 12, 2023 at 02:37:46AM +0200, Andrew Lunn wrote:
> The DSA framework has got more picky about always having a phy-mode
> for the CPU port. The Vybrid FEC is a Fast Ethrnet using RMII.
> 
> Additionally, the cpu label has never actually been used in the
> binding, so remove it.
> 
> Lastly, for DSA links between switches, add a fixed-link node
> indicating the expected speed/duplex of the link.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  arch/arm/boot/dts/vf610-zii-cfu1.dts      |  2 +-
>  arch/arm/boot/dts/vf610-zii-dev-rev-b.dts |  2 +-
>  arch/arm/boot/dts/vf610-zii-dev-rev-c.dts | 10 ++++++++-
>  arch/arm/boot/dts/vf610-zii-scu4-aib.dts  | 26 ++++++++++++++++++++++-
>  arch/arm/boot/dts/vf610-zii-spb4.dts      |  2 +-
>  arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts  |  2 +-
>  arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts |  2 +-
>  7 files changed, 39 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/vf610-zii-cfu1.dts b/arch/arm/boot/dts/vf610-zii-cfu1.dts
> index 96495d965163..b7bb2d6b3721 100644
> --- a/arch/arm/boot/dts/vf610-zii-cfu1.dts
> +++ b/arch/arm/boot/dts/vf610-zii-cfu1.dts
> @@ -202,7 +202,7 @@ port@5 {
>  
>  				port@6 {
>  					reg = <6>;
> -					label = "cpu";
> +					phy-mode = "rev-rmii";
>  					ethernet = <&fec1>;
>  
>  					fixed-link {
> diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
> index 6280c5e86a12..3f1bc7fc8526 100644
> --- a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
> +++ b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
> @@ -75,7 +75,7 @@ fixed-link {
>  
>  					port@6 {
>  						reg = <6>;
> -						label = "cpu";
> +						phy-mode = "rev-rmii";
>  						ethernet = <&fec1>;
>  
>  						fixed-link {
> diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> index c00d39562a10..811745077d2b 100644
> --- a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> +++ b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> @@ -44,7 +44,7 @@ ports {
>  
>  					port@0 {
>  						reg = <0>;
> -						label = "cpu";
> +						phy-mode = "rev-rmii";
>  						ethernet = <&fec1>;
>  
>  						fixed-link {
> @@ -82,6 +82,10 @@ switch0port10: port@10 {
>  						label = "dsa";
>  						phy-mode = "xaui";
>  						link = <&switch1port10>;
> +						fixed-link {

Have a newline between properties and child node.

Shawn

> +							speed = <10000>;
> +							full-duplex;
> +						};
>  					};
>  				};
>  
> @@ -174,6 +178,10 @@ switch1port10: port@10 {
>  						label = "dsa";
>  						phy-mode = "xaui";
>  						link = <&switch0port10>;
> +						fixed-link {
> +							speed = <10000>;
> +							full-duplex;
> +						};
>  					};
>  				};
>  				mdio {
> diff --git a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
> index 7b3276cd470f..7959307f7d13 100644
> --- a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
> +++ b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
> @@ -59,7 +59,7 @@ ports {
>  
>  					port@0 {
>  						reg = <0>;
> -						label = "cpu";
> +						phy-mode = "rev-rmii";
>  						ethernet = <&fec1>;
>  
>  						fixed-link {
> @@ -115,6 +115,10 @@ switch0port10: port@10 {
>  						link = <&switch1port10
>  							&switch3port10
>  							&switch2port10>;
> +						fixed-link {
> +							speed = <10000>;
> +							full-duplex;
> +						};
>  					};
>  				};
>  			};
> @@ -156,6 +160,10 @@ switch1port9: port@9 {
>  						phy-mode = "xgmii";
>  						link = <&switch3port10
>  							&switch2port10>;
> +						fixed-link {
> +							speed = <10000>;
> +							full-duplex;
> +						};
>  					};
>  
>  					switch1port10: port@10 {
> @@ -163,6 +171,10 @@ switch1port10: port@10 {
>  						label = "dsa";
>  						phy-mode = "xgmii";
>  						link = <&switch0port10>;
> +						fixed-link {
> +							speed = <10000>;
> +							full-duplex;
> +						};
>  					};
>  				};
>  			};
> @@ -246,6 +258,10 @@ switch2port10: port@10 {
>  						link = <&switch3port9
>  							&switch1port9
>  							&switch0port10>;
> +						fixed-link {
> +							speed = <2500>;
> +							full-duplex;
> +						};
>  					};
>  				};
>  			};
> @@ -295,6 +311,10 @@ switch3port9: port@9 {
>  						label = "dsa";
>  						phy-mode = "2500base-x";
>  						link = <&switch2port10>;
> +						fixed-link {
> +							speed = <2500>;
> +							full-duplex;
> +						};
>  					};
>  
>  					switch3port10: port@10 {
> @@ -303,6 +323,10 @@ switch3port10: port@10 {
>  						phy-mode = "xgmii";
>  						link = <&switch1port9
>  							&switch0port10>;
> +						fixed-link {
> +							speed = <10000>;
> +							full-duplex;
> +						};
>  					};
>  				};
>  			};
> diff --git a/arch/arm/boot/dts/vf610-zii-spb4.dts b/arch/arm/boot/dts/vf610-zii-spb4.dts
> index 180acb0795b9..3f9687953f57 100644
> --- a/arch/arm/boot/dts/vf610-zii-spb4.dts
> +++ b/arch/arm/boot/dts/vf610-zii-spb4.dts
> @@ -140,7 +140,7 @@ ports {
>  
>  				port@0 {
>  					reg = <0>;
> -					label = "cpu";
> +					phy-mode = "rev-rmii";
>  					ethernet = <&fec1>;
>  
>  					fixed-link {
> diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
> index 73fdace4cb42..d06a074bfe21 100644
> --- a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
> +++ b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
> @@ -129,7 +129,7 @@ ports {
>  
>  				port@0 {
>  					reg = <0>;
> -					label = "cpu";
> +					phy-mode = "rev-rmii";
>  					ethernet = <&fec1>;
>  
>  					fixed-link {
> diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> index 20beaa8433b6..c60639beda40 100644
> --- a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> +++ b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> @@ -154,7 +154,7 @@ ports {
>  
>  				port@0 {
>  					reg = <0>;
> -					label = "cpu";
> +					phy-mode = "rev-rmii";
>  					ethernet = <&fec1>;
>  
>  					fixed-link {
> -- 
> 2.40.0
> 

