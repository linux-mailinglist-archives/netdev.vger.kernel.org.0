Return-Path: <netdev+bounces-2923-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 771FA70485F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:00:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EA982815FD
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E12EE156E5;
	Tue, 16 May 2023 09:00:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD83D2C72C
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:00:16 +0000 (UTC)
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18B92702
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:00:14 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-3078a3f3b5fso10802662f8f.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684227613; x=1686819613;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fsHEp9W20r9XdmKlIDDyodAYlSBIH8ji8/Tkxn0QNCM=;
        b=EI3yy1gMDzOa3sRNIs4cGVaUpuybteTmQjUSmi39/6T5sWzyPQW8BCk1U7VWtIIlqN
         X7siL8aqFCh2WyjzTrVq2K+Pmg9FBT3hNlRldbFLJLRZm1KNQcWvxX410ZGf/gI5p6mr
         SQYB9A8VAaaQ8UlUuHKkUyuIX0UqxBly3i9Nui6T4qS+xbMawfouhaIbPn+bC0amOPNY
         Gu6vvjzNWfr1swI+Y0oE30/OPEXiX0EdtLdfwzIhUjfkxypBjFianjmeGRLvMcHXRERF
         io/rk42GKZuU85ACKtf49Ri7yvfsUXzwhzAnVNgsbhvDDTFv1Sz1lwRu3GjgGS0hzAfz
         J4iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684227613; x=1686819613;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fsHEp9W20r9XdmKlIDDyodAYlSBIH8ji8/Tkxn0QNCM=;
        b=kaBc7HG63isvA3caiGW9rYI788cyUcm1RDPeE/3+JIsl0CoiQs19IWG+CowVZadon7
         Ab2wboMkjxuBI2+bnqDBO2TumYbd4mEyoHFAC727FUzDqGazBZ7M7X15C4cgkyaKDFM1
         XiGDYJkvQX4zqEAprlWzDoD07Rjwn6x3tsyn3ovvp20AwGYV0xTGg9ITj4eibky6KmFu
         f5lM/eZGL6dcdPiBNQpEZiZPnxXSGMo3DjkQyhiXYY8+JAK6Fk9B2sC6M3GqTiXGajlX
         xn5o29oRLzzOyGalc+H596BMY4D2ZplWSSj6htaRvVKfW4l67KxF5Kd7b8hnyvVVm2Ez
         aMOg==
X-Gm-Message-State: AC+VfDxNaa4mi2shxQYjBU2V39kLk5LU2zOpm/5WaRNUjXLmq/9v8R+V
	uztiPXsdA+LnTSUMC4LRcIA=
X-Google-Smtp-Source: ACHHUZ5K2045tsZAxqNWSGpdXx/aeLKhFn5YwgVE1hM6EJ531hsulbZdDNavi1x1JUWjqgDnzlEItw==
X-Received: by 2002:adf:e909:0:b0:306:2db9:cc2c with SMTP id f9-20020adfe909000000b003062db9cc2cmr28921146wrm.32.1684227612710;
        Tue, 16 May 2023 02:00:12 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id j6-20020adfff86000000b003078cd719ffsm1810033wrr.95.2023.05.16.02.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 02:00:12 -0700 (PDT)
Date: Tue, 16 May 2023 12:00:09 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>, John Crispin <john@phrozen.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Marcin Wojtas <mw@semihalf.com>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>, Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] Providing a helper for PCS inband negotiation
Message-ID: <20230516090009.ssq3uedjl53kzsjr@skbuf>
References: <ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk>
 <20230515195616.uwg62f7hw47mktfu@skbuf>
 <ZGKn8c2W1SI2CPq4@shell.armlinux.org.uk>
 <20230515220833.up43pd76zne2suy2@skbuf>
 <ZGLCAfbUjexCJ2+v@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZGLCAfbUjexCJ2+v@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 12:36:33AM +0100, Russell King (Oracle) wrote:
> > Clause 73 negotiates the actual use of 10GBase-KR as a SERDES protocol
> > through the copper backplane in favor of other "Base-K*" alternative
> > link modes, so it's not quite proper to say that 10GBase-KR is a clause
> > 73 using protocol.
> 
> I believe it is correct to state it as such, because:
> 
> 72.1: Table 72–1—Physical Layer clauses associated with the 10GBASE-KR PMD
> 
> 	73—Auto-Negotiation for Backplane Ethernet              Required
> 
> Essentially, 802.3 doesn't permit 10GBASE-KR without hardware support
> for Clause 73 AN (but that AN doesn't have to be enabled by management
> software.)

Just like clause 40 (PCS and PMA for 1000BASE-T) requires clause 28 AN
to be supported. But, when the autoneg process begins, the use of
10GBase-KR as a protocol over the backplane link hasn't even been yet
established, so I find it unnatural to speak of clause 73 autoneg as
something that 10GBase-KR has.

The reason why I'm insisting on this is because to me, to treat clause
73 as an in-band autoneg process of 10GBase-KR sounds like a reversal of
causality. The clause 73 link codeword has a Technology Ability field
through which 10GBase-KR, 1GBase-KX etc are advertised as supported
protocols. If C73 is an inband protocol of 10GBase-KR, what should the
local PCS advertise for its Technology Ability? Only 10GBase-KR, because
this is what is implied by treating it as an attribute of 10GBase-KR, no?
But that would be a denatured way of negotiating - advertise a single
link mode, take it or leave it. And what other inband autoneg protocols
permit, say, starting from SGMII and ending in 1000Base-X? Clause 73
can't be directly compared to what we currently mean by managed =
"in-band-status".

Not only is C37 autoneg not directly comparable to C73, but they are not
mutually exclusive, either. I would say they are more or less orthogonal.
More below.

I don't believe that toggling clause 73 autoneg based on phylink_pcs_neg_mode()
makes much sense.

> > To me, the goals of clause 73 autoneg are much more similar to those of
> > the twisted pair autoneg process - clause 28, which similarly selects
> > between different media side protocols in the PHY, using a priority
> > resolution function. For those, we use phylib and the phy_device
> > structure. What are the merits of using phylink_pcs for copper backplanes
> > and not phylib?
> 
> I agree with you on that, because not only does that fit better with
> our ethernet PHY model, but it also means PHY_INTERFACE_MODE_XLGMII
> makes sense.
> 
> However, by that same token, 1000BASE-X should never have been a
> PHY_INTERFACE_MODE_xxx, and this should also have been treated purely
> as a PHY.
> 
> Taking that still further, this means SGMII, which is 1000BASE-X but
> modified for Cisco's purposes, would effectively be a media converting
> PHY sat between the MAC/RS and the "real" ethernet PHY. In this case,
> PHY_INTERFACE_MODE_SGMII might make sense because the "real" ethernet
> PHY needs to know that.
> 
> Then there's 1000BASE-X used to connect a "real" ethernet PHY to the
> MAC/RS, which means 1000BASE-X can't really be any different from
> SGMII.
> 
> This all makes the whole thing extremely muddy, but this deviates away
> from the original topic, because we're now into a "what should we call
> a PCS" vs "what should we call a PHY" discussion. Then we'll get into
> a discussion about phylib, difficulties with net_device only being
> able to have one phylib device, stacked PHYs, and phylib not being
> able to cope with non-MDIO based devices that we find on embedded
> platforms (some which don't even offer anything that approximates the
> 802.3 register set, so could never be a phylib driver.)
> 
> It even impacts on the DT description, since what does "managed =
> "in-band-status";" mean if we start considering 1000base-X the same
> way as 1000base-T and the "PHY" protocol for 1000base-X becomes GMII.
> A GMII link has no inband AN, so "managed = "in-band-status";" at
> that point makes no sense.
> 
> That is definitely a can of worms I do *not* want to open with this
> discussion - and much of the above has a long history and considerably
> pre-dates phylink.

I don't have much of a problem accepting that not everything we have
in-tree is consistent/correct. But if you think it's too big of a can of
worms to open, okay.

> 
> My original question was more around: how do we decide what we
> currently have as a PCS should use inband negotiation.
> 
> For SGMII and close relatives, and 1000BASE-X it's been obvious. For
> 2500BASE-X less so (due to vendors coming up with it before its been
> standardised.)
> 
> We have implementations using this for other protocols, so it's
> a question that needs answering for these other protocols.
> 
> 
> However, if we did want to extend this topic, then there are a number
> of questions that really need to be asked is about the XPCS driver.
> Such as - what does 1000BASE-KX, 10000BASE-KX4, 10000BASE-KR and
> 2500BASE-X have to do with USXGMII, and why are there no copper
> ethtool modes listed when a USXGMII link can definitely support
> being connected to a copper PHY? (See xpcs_usxgmii_features[]).
> 
> Why does XPCS think that USXGMII uses Clause 73 AN? (see the first
> entry in synopsys_xpcs_compat[].)

First, in principle USXGMII and clause 73 are not mutually exclusive.

It is possible to use clause 73 to advertise 10GBase-KR as a link mode,
and that will give you link training for proper 3-tap electrical
equalization over the copper backplane.

Then, once C73 AN/LT ended and 10GBase-KR has been established, is
possible to configure the 10GBase-R PCS to enable C37 USXGMII to select
the actual data rate via symbol replication, while the SERDES lane
remains at 10GBaud. At least, the XPCS seems to permit enabling symbol
replication in conjunction with 10GBase-KR.

Cross-checking what the XPCS driver does with the XPCS databook, I think
it's this:

It doesn't use C37 autoneg, but it still uses the USXGMII replicator.
It uses C73 (standard or perhaps a vendor-specific form) to advertise
the 1000baseKX_Full, 2500baseX_Full, 10000baseKX4_Full, 10000baseKR_Full
link modes. Each of these corresponds to a bit in the SR_AN_ADV3
register.

Note that 2500baseX_Full doesn't have a "K", and for good reason -
because 802.3 Table 73–4—"Technology Ability Field encoding" doesn't
specify 2500Base-KX as a copper backplane mode that exists. But XPCS
does! To quote the databook:

| When DATA[32] is set to 1, it indicates that the local device
| supports 2.5GBASE-KX speed mode.

And since it advertises this through a code word visible to the link
partner, I would suggest this means that its C73 hardware implementation
is non-standard.

Then, there's the entire issue of what the software does.

When 1GBase-KX is established through C73 autoneg, the XPCS driver
will leave the lane in 10GBase-R mode, and enable 1:10 symbol replication
in the USXGMII block. Sure, this is a 1Gbit data rate, but it uses the
64b/66b encoding (BASE-R), and not the advertised 8b/10b encoding
(BASE-X)! So it will likely only work between 2 XPCS devices!!!

Then, there's the entire issue that the code, as it was originally
introduced, is not the same as it is now. For example, this bit in
xpcs_do_config():

	switch (compat->an_mode) {
	case DW_AN_C73:
		if (phylink_autoneg_inband(mode)) {
			ret = xpcs_config_aneg_c73(xpcs, compat);
			if (ret)
				return ret;
		}
		break;

used to look at state->an_enabled rather than phylink_autoneg_inband().
Through my idiocy, I inadvertently converted that in commit 11059740e616
("net: pcs: xpcs: convert to phylink_pcs_ops").

> 
> xpcs_sgmii_features[] only mentions copper linkmodes, but as we know,
> it's common for copper PHYs to also support fibre with an auto-
> selection mechanism. So, 1000BASE-X is definitely possible if SGMII
> is supported, so why isn't it listed.

Most likely explanation is that XPCS has never been paired up until now
to such a PHY.

> As previously said, 1000BASE-X can be connected to a PHY that does
> 1000BASE-T, so why does xpcs_1000basex_features[] not mention
> 1000baseT_Full... there's probably more here as well.
> 
> Interestingly, xpcs_2500basex_features[] _does_ mention both
> 2500BASE-X and 2500BASE-T, but I think that only does because I
> happened to comment on it during a review.
> 
> I think xpcs is another can of worms, but is an easier can of worms
> to solve than trying to sort out that "what's an ethernet PHY"
> question we seem to be heading towards (which I think would be a
> mammoth task, even back when phylink didn't exist, to sort out.)

I wasn't necessarily going to go all the way into "what's a PHY?".
I just want to clarify some terms such that we can agree what is correct
and what is not. I believe that much of what's currently in XPCS w.r.t.
C73 is not correct, partly through initial intention and partly through
blind conversions such as mine.

