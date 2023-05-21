Return-Path: <netdev+bounces-4103-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51DE670AE17
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 14:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EB5F1C20959
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 12:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2573D394;
	Sun, 21 May 2023 12:35:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5477EB
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 12:35:18 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A756B8;
	Sun, 21 May 2023 05:35:17 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-510b56724caso5103939a12.1;
        Sun, 21 May 2023 05:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684672516; x=1687264516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S1z5JoYZQ8RVr22ygDUG9JiPVIu9F3BCyzXtdyfVabI=;
        b=B1i+eN1IqHozvY8XK2aR250T7bVTA7uZBDsE9H3RBD4nEIu29hVV0AVTXf0hO3BUEd
         377rR0EuZKCGQcZLRceuJ51IMJ/qPjSaTwC86psNPDUSyqN2YHkn+wdx1ctOOH/K87V8
         vtoZUxZYqfPqnrjIVF51GbP5wJwKnMe0DKjHv0IE7R2grzGcn9nGo9ouExBbk23pdNY4
         PfOzKvO3UrZCmO8n8F1LOhFp+nNvoNdStTmu6OK8dkaXu2x01mIMGxW4IsGFiUGYBiuC
         l1K7QHVs3b9uWRAh9b4dS5xPf7ThSC8lBhLEiNynno8aT0ZakWx7yPlAx/1zBcM9cTqa
         Wx6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684672516; x=1687264516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S1z5JoYZQ8RVr22ygDUG9JiPVIu9F3BCyzXtdyfVabI=;
        b=Yynsbi8RHDkl4pRgUKjNhuk7EolRRDtCXEXeu1dKpXUK0pGn9BVzyvlMVfb6t1wcW9
         kX88Qp9VQysWOR4d1Ps3GuQKtAVtJFT9UkRk2lmJgxb37TZRQntE0NiWkWkcZxzLjL3a
         AljJ8R+LmNnfSJXx6cNCRBYLNRhQxZ3rKrKBYebaLCodJ67yV3TWRmx45QhYWJNGiC9O
         h18lBkMJ8LIZWk5a9n2o2a8y/kE9wKrXNVal9Gfm4eIslFaYZJhuEbDm/K9nk21YSpIu
         n1fyl6YB+FrZdld/4FSKrJGXuCUp2eUOmvZvjb7E6dFsbZYi3b5c6ZZIwMJ+KkYeRFRS
         XOpA==
X-Gm-Message-State: AC+VfDxF5Dn90lMsNNa4dL7NreguPaKk+JgJ+N6jxMAVRIIicy5SgRHk
	4Tei18lV5AZcxyjhxcBRE2A=
X-Google-Smtp-Source: ACHHUZ4qAoRw03WNaNYz/kYgAFWNXjEJRPwB9Yp9QepTokDLsiesAXaaqBvmxS45KJ0F6EJhww4U5A==
X-Received: by 2002:aa7:d848:0:b0:505:d16:9374 with SMTP id f8-20020aa7d848000000b005050d169374mr7816603eds.9.1684672515495;
        Sun, 21 May 2023 05:35:15 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id z5-20020aa7c645000000b0050bc6983041sm1795578edr.96.2023.05.21.05.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 05:35:15 -0700 (PDT)
Date: Sun, 21 May 2023 15:35:12 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 3/3] net: phy: mscc: enable VSC8501/2 RGMII RX clock
Message-ID: <20230521123512.3kpy66sjnzj2chie@skbuf>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 20, 2023 at 06:06:03PM +0200, David Epping wrote:
> By default the VSC8501 and VSC8502 RGMII RX clock output is disabled.
> To allow packet forwarding towards the MAC it needs to be enabled.
> The same may be necessary for GMII and MII modes, but that's currently
> unclear.
> 
> For VSC853x and VSC854x the respective disable bit is reserved and the
> clock output is enabled by default.
> 
> Signed-off-by: David Epping <david.epping@missinglinkelectronics.com>
> ---
>  drivers/net/phy/mscc/mscc.h      |  1 +
>  drivers/net/phy/mscc/mscc_main.c | 24 ++++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> index 79cbb2418664..defe5cc6d4fc 100644
> --- a/drivers/net/phy/mscc/mscc.h
> +++ b/drivers/net/phy/mscc/mscc.h
> @@ -179,6 +179,7 @@ enum rgmii_clock_delay {
>  #define VSC8502_RGMII_CNTL		  20
>  #define VSC8502_RGMII_RX_DELAY_MASK	  0x0070
>  #define VSC8502_RGMII_TX_DELAY_MASK	  0x0007
> +#define VSC8502_RGMII_RX_CLK_DISABLE	  0x0800
>  
>  #define MSCC_PHY_WOL_LOWER_MAC_ADDR	  21
>  #define MSCC_PHY_WOL_MID_MAC_ADDR	  22
> diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
> index 29fc27a16805..c7a8f5561c66 100644
> --- a/drivers/net/phy/mscc/mscc_main.c
> +++ b/drivers/net/phy/mscc/mscc_main.c
> @@ -547,6 +547,26 @@ static int vsc85xx_rgmii_set_skews(struct phy_device *phydev, u32 rgmii_cntl,
>  	return rc;
>  }
>  
> +/* For VSC8501 and VSC8502 the RGMII RX clock output is disabled by default. */

This statement is not exactly true, proven by my board where I've just
printed these values:

[    6.454638] Microsemi GE VSC8502 SyncE 0000:00:00.3:03: vsc85xx_rgmii_enable_rx_clk: RGMII_CNTL 0x44, RX_CLK_DISABLE 0x0
[    6.544652] sja1105 spi2.2 sw2p0 (uninitialized): PHY [0000:00:00.3:03] driver [Microsemi GE VSC8502 SyncE] (irq=POLL)
[    6.630864] Microsemi GE VSC8502 SyncE 0000:00:00.3:02: vsc85xx_rgmii_enable_rx_clk: RGMII_CNTL 0x44, RX_CLK_DISABLE 0x0
[    6.720218] sja1105 spi2.2 sw2p1 (uninitialized): PHY [0000:00:00.3:02] driver [Microsemi GE VSC8502 SyncE] (irq=POLL)
[    6.806876] Microsemi GE VSC8502 SyncE 0000:00:00.3:11: vsc85xx_rgmii_enable_rx_clk: RGMII_CNTL 0x44, RX_CLK_DISABLE 0x0
[    6.896185] sja1105 spi2.2 sw2p2 (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8502 SyncE] (irq=POLL)
[    6.982775] Microsemi GE VSC8502 SyncE 0000:00:00.3:10: vsc85xx_rgmii_enable_rx_clk: RGMII_CNTL 0x44, RX_CLK_DISABLE 0x0
[    7.071988] sja1105 spi2.2 sw2p3 (uninitialized): PHY [0000:00:00.3:10] driver [Microsemi GE VSC8502 SyncE] (irq=POLL)

Let's resolve that difference before the patches are merged, and write
some correct comments.

I agree that the datasheet is not clear, but I think that the RX_CLK
output is enabled or not based on the strapping of the RCVRDCLK1 and
RCVRDCLK2 pins. Coincidentally, these are also muxed with PHYADD1 and
PHYADD2, so the default value of RX_CLK_DISABLE might depend on the
PHY address (?!).

What is your PHY address? Mine are 0x10 and 0x11 for the VSC8502 on my
board.

Not saying that the patch is wrong or that the resolution should be any
different than it is. Just that it's clear we can't both be right, and
my PHYs clearly work (re-tested just now).

--
pw-bot: changes-requested

