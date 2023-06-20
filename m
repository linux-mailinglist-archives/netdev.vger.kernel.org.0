Return-Path: <netdev+bounces-12201-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C195D736AE7
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CFB32811F6
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1618125C7;
	Tue, 20 Jun 2023 11:25:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58C210961
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 11:25:19 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E1710DB
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:25:17 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-987c932883bso522670366b.0
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687260316; x=1689852316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xztFpBQ5hfkK1I0h521s+/Vq+2fXss7j6iqMDxIBqO8=;
        b=en0CtCkcInlZuQXE+vrTUI1l0b5i3aocBz0b+937cgK6b/+FB/PAsyZ4WU9ElR9LKb
         0YA5ubMkywY7Tgs6bhemxy5rZP6hYGTd4R52xsPgPBMm1xxOtiFwaYX/jfmSCXdB5KeG
         T4LVTU6ABDAIIvOMhAjdpkQKnKkPizaBACzpot9Le3kmz30Tl2WfJlpzD1uDUF6cf6yM
         FN2MAyGJy+TCo3Z605TpuseIvg1/mPvrqs7l6PjjAE5zjLH9JcdJV3WTjoRERQ+vLT7D
         Hh18aPHrB0UBJowhHZtCVkGlAhsj685izY/hVjZiVaQTT8gR9mjOXRc5dzTvqdnMxZIT
         Paow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687260316; x=1689852316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xztFpBQ5hfkK1I0h521s+/Vq+2fXss7j6iqMDxIBqO8=;
        b=jtXQm2UzEHVZAbvLUH9VUsN48BLn4lV5uNTt/Q5KFljXrVVxOaEkY1U3ozhaQTkT+g
         r8k4rE7zmFwrw7Sy07oZgolv8r4D2JsZ3Xtu8DzHIoiMZ1+cyN0tKwN7+QneAO5dOZWH
         y6reYdmDvM2roY1VIH7n98QXqWnquv8SapVwOCrTXkIK9t/eXSKyXIWb7821b/DY7Jam
         ja5IsKQu8pQ2Td2suOb7bhd4j7l29FslxDS5heXRld+CjolvqdKqswGIbNc2lkZP0pId
         435x5cJMEsJOzkUdp/03tczrR9CMVDU4EFriB2IRgKofj9WyWKWyrGARAdgtkteQBQkI
         RqCg==
X-Gm-Message-State: AC+VfDw/JdESWVX+u54xZvkzzGO7DDBlabVO8d+x37vC1wPkwjqnpLhX
	13I2FRmRgfZw2xKTR3EiOk0=
X-Google-Smtp-Source: ACHHUZ6tQjdZTezaUGlU7aakJBJDEd2tryVIOPstL5aQpajUWOjUUatDGnfjg17agxOZmX9JbHFZwQ==
X-Received: by 2002:a17:907:7294:b0:988:d841:7f7f with SMTP id dt20-20020a170907729400b00988d8417f7fmr3292008ejc.63.1687260316030;
        Tue, 20 Jun 2023 04:25:16 -0700 (PDT)
Received: from skbuf ([188.25.159.134])
        by smtp.gmail.com with ESMTPSA id f22-20020a17090624d600b009786ae9ed50sm1192880ejb.194.2023.06.20.04.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 04:25:15 -0700 (PDT)
Date: Tue, 20 Jun 2023 14:25:12 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Alexander Couzens <lynxis@fe80.eu>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Cc@web.codeaurora.org:Claudiu Beznea <claudiu.beznea@microchip.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	DENG Qingfang <dqfext@gmail.com>, Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
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
	Paolo Abeni <pabeni@redhat.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 0/15] Add and use helper for PCS negotiation
 modes
Message-ID: <20230620112512.ikhdjt7hm34xespo@skbuf>
References: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
 <20230616150055.kb7dyuwqqvfkfuh7@skbuf>
 <ZIyD31CaVxjSDtz3@shell.armlinux.org.uk>
 <ZIyFNSnwahdL0A8s@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIyFNSnwahdL0A8s@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 04:52:21PM +0100, Russell King (Oracle) wrote:
> I should also add... yes, I did _then_ subsequently use the microchip
> driver as a justification for it. I probably should've explained it
> without using that as justification.
> 
> I could also have used the sja1105 driver as well, since:
> 
> 	MLO_AN_INBAND => PHYLINK_PCS_NEG_INBAND_ENABLED

Technically this should have been:

	MLO_AN_INBAND => neg_mode & PHYLINK_PCS_NEG_INBAND, which
	includes both INBAND_DISABLED and INBAND_ENABLED, right?

> 	MLO_AN_FIXED || MLO_AN_PHY => PHYLINK_PCS_NEG_OUTBAND
> 
> are the conversions done there, which fits with:
> 
> -               if (!phylink_autoneg_inband(mode)) {
> +               if (neg_mode == PHYLINK_PCS_NEG_OUTBAND) {
> 
> since the opposite of !inband is outband.

The conversion is correct - no doubt about it.

Maybe the SJA1105 and its use of the XPCS is also not the best example,
because it doesn't support 1000BASE-X. So it doesn't have to handle the
INBAND_DISABLED state. If it did, the !phylink_autoneg_inband(mode)
check would have been incorrect (insufficient to detect the xpcs state
that it's restoring).

