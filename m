Return-Path: <netdev+bounces-11479-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE30733416
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF2251C20E8E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9971427C;
	Fri, 16 Jun 2023 15:01:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CB13D62
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 15:01:03 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F171F30C5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:01:00 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9864d03e838so105265866b.2
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686927659; x=1689519659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EiplLJBv4iqfSc+ZrhjbYoS87s9MPGVY4fSzkTGtwSU=;
        b=DnzqQaO54DvSwXb1NGYn3VSTxF+H3ni1Kbidm6dY0PaQlhhtC1Hrh0KTtVRhe6lMRW
         HbO9YFSp557m2licEHMm3MgQdD+a5TPBSkb6zA1Ln2R01Xb3ynXhpmmUhLc3KRr9bB4a
         pqVyusXWLTQgs28/mttECgsE/7+4++CrzZ0GMx7OwrIrX9FUtsD65dzLL9hPa5uGt3G5
         cU5tsj0cFXLLZiUVBjaskvUnNgogyJiOtOV1vsPH4lUDYVhvCqdMQG40niBLOQuEmSo3
         j/0d/MIUhDRmO6wjMJBkt7kEBStEPbd4K3LiGkFpsrThSH4wO5KcFJR4o+Tf2jEUqlf/
         Cr+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686927659; x=1689519659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EiplLJBv4iqfSc+ZrhjbYoS87s9MPGVY4fSzkTGtwSU=;
        b=Z4kQxj4hVLZGqxU6C8NIZonPfrex/8ItEiLKksydkTogRJ2vpFeF1lDytp9rdyT4ee
         EZOeubGvc3GrRtPHPSt//6I8+4FQTN8IKXWTddg7CRoNgw9tJDpU3rL/sNI0E0Pd1pyi
         nz78YY+6tGQw+DGlVtAZNRcpErao28qahA8SEqsS0IOzcz5qToKlL5rnK0VBiNTVGBao
         F6rm9zfnh1vNJRtyOw5sJKP4M7/XWt6mi+hwkynT4+RlWbP3zb0zjm0s/+plNy5DjLfJ
         L+ME+T5QsHyJXNHfImyC7/NBcVcDmN+c38TXVWkJW/53Xq/JnXBiEoQ17qkAQBCjAFtm
         Qs1A==
X-Gm-Message-State: AC+VfDwzk6Mwf597GAG34jgog8Is2F8vdFQY4cOIxbbv6PIHrMgcYMQ+
	X/yL1om4qzdPMZVlDRmZmcQ=
X-Google-Smtp-Source: ACHHUZ48rZ8rIS75oGkcfaUIFGqF7j5KaPNb16bpKPAP6kzgGfv5NTZF84DNkjbIZIReJV9OHv7e/g==
X-Received: by 2002:a17:907:808:b0:977:ceab:3996 with SMTP id wv8-20020a170907080800b00977ceab3996mr2006721ejb.76.1686927659093;
        Fri, 16 Jun 2023 08:00:59 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id c19-20020a170906925300b0096f67b55b0csm10913465ejx.115.2023.06.16.08.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 08:00:58 -0700 (PDT)
Date: Fri, 16 Jun 2023 18:00:55 +0300
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
Message-ID: <20230616150055.kb7dyuwqqvfkfuh7@skbuf>
References: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 01:05:52PM +0100, Russell King (Oracle) wrote:
> Hi,
> 
> Earlier this month, I proposed a helper for deciding whether a PCS
> should use inband negotiation modes or not. There was some discussion
> around this topic, and I believe there was no disagreement about
> providing the helper.
> 
> The initial discussion can be found at:
> 
> https://lore.kernel.org/r/ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk
> 
> Subsequently, I posted a RFC series back in May:
> 
> https://lore.kernel.org/r/ZGzhvePzPjJ0v2En@shell.armlinux.org.uk
> 
> that added a helper, phylink_pcs_neg_mode() which PCS drivers could use
> to parse the state, and updated a bunch of drivers to use it. I got
> a couple of bits of feedback to it, including some ACKs.
> 
> However, I've decided to take this slightly further and change the
> "mode" parameter to both the pcs_config() and pcs_link_up() methods
> when a PCS driver opts in to this (by setting "neg_mode" in the
> phylink_pcs structure.) If this is not set, we default to the old
> behaviour. That said, this series converts all the PCS implementations
> I can find currently in net-next.
> 
> Doing this has the added benefit that the negotiation mode parameter
> is also available to the pcs_link_up() function, which can now know
> whether inband negotiation was in fact enabled or not at pcs_config()
> time.
> 
> It has been posted as RFC at:
> 
> https://lore.kernel.org/r/ZIh/CLQ3z89g0Ua0@shell.armlinux.org.uk
> 
> and received one reply, thanks Elad, which is a similar amount of
> interest to previous postings. Let's post it as non-RFC and see
> whether we get more reaction.

Sorry, I was in the process of reviewing the RFC, but I'm not sure I
know what to ask to make sure that I understand the motivation :-/
Here's a question that might or might not result in a code change.

In the single-patch RFC at:
https://lore.kernel.org/all/ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk/
you bring sparx5 and lan966x as a motivation for introducing
PHYLINK_PCS_NEG_OUTBAND as separate from PHYLINK_PCS_NEG_INBAND_DISABLED,
with both meaning that in-band autoneg isn't used, but in the former
case it's not enabled at all, while in the latter it's disabled through
ethtool (if I get that right?).

I've opened the Sparx5 documentation at:
https://ww1.microchip.com/downloads/en/DeviceDoc/SparX-5_Family_L2L3_Enterprise_10G_Ethernet_Switches_Datasheet_00003822B.pdf
and also cross-checked with the PCS1G documentation from VSC7514
(Ocelot: https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10491.pdf,
there's another embedded PDF with registers at page 283), trying to find
exactly what the PCS1G_MODE_CFG.SGMII_MODE_ENA field does (which is
controlled in sparx5 and lan966x based on the presence or absence of the
managed = "in-band-status" property).

Do you know for sure what this bit does and whether it makes sense for
drivers to even distinguish between OUTBAND and INBAND_DISABLED in the
way that this series is proposing?

It's hard to know for sure, not having the hardware, but I believe that
the bit selects between the SGMII and the 1000Base-X control word
format (so, even though there's a dedicated and fully programmable
PCS1G_ANEG_CFG.ADV_ABILITY register, the link partner ability is still
decoded as per the programmed expected format). The documents talk about
using the PCS in "SGMII mode" vs "1000BASE-X SERDES mode".

If that's the case, then it is selecting between those 2 based on
phylink_autoneg_inband(mode) and irrespective of the phy-mode, i.e.:

- enabling the SGMII control word format for phy-mode = "1000base-x" and
  no managed = "in-band-status", or
- enabling the 1000Base-X control word format for phy-mode = "sgmii" and
  managed = "in-band-status"

...is that a model to follow?

