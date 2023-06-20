Return-Path: <netdev+bounces-12202-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17E80736AEB
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:29:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCC0B1C20BAA
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A863F12B87;
	Tue, 20 Jun 2023 11:29:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950BF2F5B
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 11:29:05 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA7AE41
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:29:04 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-51a2160a271so5780833a12.1
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687260542; x=1689852542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x5fXKYRyIxOrpBidiyVfWWYnPdUCbvNibuf/VriGwRA=;
        b=hklyxFPS4R1Hui+lMTok8OyC+BMtHw39/2Y5ogMVSB4VTS8K+DYtBCIlKV7qx3Ultd
         YuxBbVNDkxzaLxZiBwrHMGxXrZA5XdIICHuQZtQAqraQCfo4f9N2kB7iz9FMc7RGss90
         o0HJBNGTxt3X1joSBcrW0VMv7SdSFBSTVlrdZek5VRVF5nwPRayH2/Nuz0JjYuGfLZTi
         rNuKunfeETIAT6qT1+u45ddxedP6Loj4P2vjoYLBNnnSctj+4PuY3SJOncsFtIRNTKm3
         UgzT3rfG8DwSOqR+Bd5FFaWGG9NcS3dujYDBleBrmythpm0XI49WaFTWZMJXQh7j3And
         a9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687260542; x=1689852542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5fXKYRyIxOrpBidiyVfWWYnPdUCbvNibuf/VriGwRA=;
        b=E9MIgA1c0klCrXNRE8ahIp2TTb4rc1dzY4zeZk+AvyB8HtwRkp6+RXMt5nMcvVPCya
         aMZpNgUuk1NgKm+/YJYq0CXAPr2p83ekJ2OUK90FJpWgDz0nJIETKweLYTyen02YABMY
         Z/UcQMdJpAZ80dnlr96botMqhG+vMVfNEkcLdy4W8ylOKFFPD2lbMpLWgRwETVWyHUNR
         mkk/pZNASdicdvxIvydsm3K/OE/F+4VlHDsRdMMJJ3Sj6CPS4jxjUoWX9MDeB/YHsnDj
         VwwRRjHbooCaH6GH14S7/Iu2tNq3rGEIYCUqIsxsXHiDXMNDj6VEn2V8mhOW256BOmo4
         BlSQ==
X-Gm-Message-State: AC+VfDw03GEDC5lJhBk4okhIvX6l/Iq1IdfRltWCKRZu0+r2SXmiwpVR
	ouf/we9OJgM206+4woWKj4Q=
X-Google-Smtp-Source: ACHHUZ5QXFaFfygs0qzK1PHwWxj6IQdTjoJVFl7UV7c+P6nAoiD460u84TaLP0zCRu5LQTcVewLhwA==
X-Received: by 2002:a05:6402:111a:b0:514:a110:6bed with SMTP id u26-20020a056402111a00b00514a1106bedmr7931237edv.27.1687260542396;
        Tue, 20 Jun 2023 04:29:02 -0700 (PDT)
Received: from skbuf ([188.25.159.134])
        by smtp.gmail.com with ESMTPSA id t18-20020aa7d712000000b0051827a12b47sm1014611edq.15.2023.06.20.04.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 04:29:02 -0700 (PDT)
Date: Tue, 20 Jun 2023 14:28:58 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Couzens <lynxis@fe80.eu>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Marcin Wojtas <mw@semihalf.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Michal Simek <michal.simek@amd.com>, netdev@vger.kernel.org,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 11/15] net: qca8k: update PCS driver to use
 neg_mode
Message-ID: <20230620112858.p7v5w767vfhksyrn@skbuf>
References: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
 <E1qA8EU-00EaG9-1l@rmk-PC.armlinux.org.uk>
 <ZJFu1cPT2sOVuczK@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJFu1cPT2sOVuczK@shell.armlinux.org.uk>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 20, 2023 at 10:18:13AM +0100, Russell King (Oracle) wrote:
> On Fri, Jun 16, 2023 at 01:07:14PM +0100, Russell King (Oracle) wrote:
> > Update qca8k's embedded PCS driver to use neg_mode rather than the
> > mode argument. As there is no pcs_link_up() method, this only affects
> > the pcs_config() method.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> I see netdevbpf patchwork is complaining that I didn't Cc a maintainer
> for this patch (ansuelsmth@gmail.com). Why is it complaining? This
> address is *not* in the MAINTAINERS file in the net-next tree neither
> for the version I generated the patch against (tip on submission date),
> today's tip, nor the net tree.
> 
> Is patchwork using an outdated MAINTAINERS file?
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

I can presume that patchwork runs scripts/get_maintainer.pl, which looks
not only at the MAINTAINERS file, but also at the recent authors and
sign offs from git for a certain file path.

