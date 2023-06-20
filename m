Return-Path: <netdev+bounces-12196-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F407369F5
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9735C1C20BAA
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC4C101E6;
	Tue, 20 Jun 2023 10:54:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713F32F5B
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 10:54:10 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D703DEB
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:54:08 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-9881b9d8cbdso543845066b.1
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687258447; x=1689850447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0pTLkAbPP/GnH3yWboKr5sOmxoDXms4RVfLz3wTjurY=;
        b=ER7EqP2SxxwBxWZB+akA0IbKbF1IWJpDiI43qP9u2Y5yYEgEo/J50/cliOrkAxq98e
         arsBlFRMEVO3YXOKkrmtZdctNdg5gTKFhwyLKYEWtRxvLNBILz+coy+wh5n5Q00o1xiA
         pqvJ/TFioOrqTa3JxOKUkmKOVc6+XNiaMNNfMKG7p50xfSjWqS3ShhkIln7V5/503azn
         ZHCf+khh5aRVuHgT/Y0jNpNGedTcNqmUbMs1KB0oKHfInrS9ObAVid7Ccz9kDmomMopt
         ILjtm/oWPEV3lvMgZhwGbME236LCsxb6KHqCBHW32FuZHM5Mq6IgXIXuqsmn6pYFlbff
         JaZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687258447; x=1689850447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0pTLkAbPP/GnH3yWboKr5sOmxoDXms4RVfLz3wTjurY=;
        b=A0POqLvg0bDrCqI3sPObyNRLEyAQjMfKSnPGlqvHhSODzHR7eieDIQDYN5AeiVumdh
         mwvsVS7HR6ul1VefxMCsqPwf8FSPbtNSRcO++cbC7MYAkNARC0ZT2R9jnaFUWog+e5d4
         LZITIrBqLxaxE9xI2XNEQgmF7a+vBuYhzB1ZGy46OnH0KJEYggg6LyDOW6S9wFyVbgeE
         sx9QsC2lA2x6nywmd4RunIQQDFHRne1/ss9paxX2aiv4AJTBghrqBq4qqHO91mVBFLqf
         SloZaT64xPTJ7Hmvc90L28vKvjf4SOG7I9/yuFmqCYewZyHe4SGMGNlNt6OwFzOY68Z5
         EWzg==
X-Gm-Message-State: AC+VfDxyFSeWE33KsfQKCJxHP1/e9L9qsvPAmJfXMfafr9nQPpZ/iI/k
	CUsdY0SCkXUscs5Ichu+63c=
X-Google-Smtp-Source: ACHHUZ5xIaksACNe3rnG0kTzrSSKzxgJX5o2PzVue47GfUe+2DAETMrVSD7j1dmrZ0gBdRTD6XIOqg==
X-Received: by 2002:a17:907:d26:b0:977:d468:827 with SMTP id gn38-20020a1709070d2600b00977d4680827mr12260141ejc.17.1687258447047;
        Tue, 20 Jun 2023 03:54:07 -0700 (PDT)
Received: from skbuf ([188.25.159.134])
        by smtp.gmail.com with ESMTPSA id gu1-20020a170906f28100b009829a5ae8b3sm1171511ejb.64.2023.06.20.03.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 03:54:06 -0700 (PDT)
Date: Tue, 20 Jun 2023 13:54:03 +0300
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
Message-ID: <20230620105403.bkwwigh77wrkxbjr@skbuf>
References: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
 <20230616150055.kb7dyuwqqvfkfuh7@skbuf>
 <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
 <20230616150055.kb7dyuwqqvfkfuh7@skbuf>
 <ZIyD31CaVxjSDtz3@shell.armlinux.org.uk>
 <ZIyD31CaVxjSDtz3@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIyD31CaVxjSDtz3@shell.armlinux.org.uk>
 <ZIyD31CaVxjSDtz3@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 04:46:39PM +0100, Russell King (Oracle) wrote:
> So, no, the Microchip driver code is not the reason why these
> definitions were chosen. They were chosen because it's the logical
> set that gives PCS drivers what they need to know.
> 
> Start from inband + autoneg. Then inband + !autoneg. Then inband
> possible but not being used. Then "there's no inband possible for this
> mode". That's the four states.
> 
> I think having this level of detail is important if we want to think
> about those pesky inband-AN bypass modes, which make sense for only
> really the PHYLINK_PCS_NEG_INBAND_DISABLED state and not OUTBAND nor
             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

don't you mean PHYLINK_PCS_NEG_INBAND_ENABLED? I fail to see why would
the bypass make any difference for INBAND_DISABLED, where presumably the
fiber BMCR of the attached PHY would have BMCR_ANENABLE unset.

And in that case, I still don't understand the need for distinguishing
between INBAND_DISABLED, OUTBAND, NONE. Sorry, slow-witted :)

> NONE state. Bypass mode doesn't make sense for e.g. SGMII because
> one needs to know the speed for the link to come up, and if you're
> getting that through an out-of-band mechanism, you're into forcing
> the configuration at the PCS end.
> 
> Makes sense?

I refreshed my memory with this thread
https://patchwork.kernel.org/project/netdevbpf/patch/20221118000124.2754581-4-vladimir.oltean@nxp.com/
regarding in-band AN bypass on m88e1011, and the fact that enabling
in-band AN bypass with SGMII forces an advertisement of only
1000baseT/Half and 1000baseT/Full on the media side.

So.. correct, but I still don't get the overall answer to the question
I have, which is "why would drivers want to make any legitimate
distinction between INBAND_DISABLED and OUTBAND, when for all intents
and purposes, those 2 modes are nothing but the same physical state,
reached from 2 different phylink configuration path"?

