Return-Path: <netdev+bounces-3015-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD79C705053
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:15:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8904C1C20E06
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4035E28C0E;
	Tue, 16 May 2023 14:15:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EAB34CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:15:54 +0000 (UTC)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45271FEB
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:15:50 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-3062b101ae1so9342569f8f.2
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684246549; x=1686838549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/KV+Di6Ta48Z3epDbXpwwzm5dV8uJgv3AJwtxlWfCg=;
        b=rrOfddcnfEZBwxzmGgMUvs0GaeImSK2XDlrisZWpbFOMOZHSlcxtTvHUUB4mQmH+eV
         g8jI0Ef4kkCZuWbyfGJJ+/531XMWhB7wS+Ke9EQgY1pWxR17c3V1ylgAMmrB62hUyVB/
         yIUSSzR1lkxya1024jRDl91LbJRXI8v7ZEoaXUe+dEvMz+F4vT8FCJyaN9pKO+rtxMsi
         DB12YZ4hx7n5iHT3wnV5h9Gym77Hx48P9SfEwrNhW5f7ucgUfniH5fmCwEEB4dCaC0qc
         E5voin6GVkmVTZ4ge3qvLwhFkc87KM7UM4qNJ9vbQ5iMQPlyakWVftf5o2OBlay7px8I
         ht+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684246549; x=1686838549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/KV+Di6Ta48Z3epDbXpwwzm5dV8uJgv3AJwtxlWfCg=;
        b=SYtAgO63sMG4Z0RSBi8scqMrWvrh8aCs0duxice6C4puXuNKTxzZExfBrPQQg9rrT0
         UUxjovex3Q+g7Flh+OymVcx/ZGH4BC/TKw3/VrF8Z+WDnntozMOX28YZ+NuYa8KyKhmt
         LtYsqiTLU7eaboI5RfdNWwk0scYdcgQy7cMKr/UF3X7oTOsGQ/sH1NlCcFAi8ztTN7K/
         V+ZwNI2lyuNi52TMIdKUcWEhvapFLGoJQe6QNgs+3Wu67u/rBfFiFaEb5BtqCBzZYxkg
         c+EBbRWaUnTyv9ND30YQ/LycTEZiZ1Svx5awUM/T3+vR7O9KHTf1br6gzpc0cz68GwlY
         puRg==
X-Gm-Message-State: AC+VfDxGww+jpAE+wPPYp4DcsnJWmqkeksuBY0z0doaF6TxOaRmQm/oj
	mU93C8qSONgmBL1iTqE5wOs=
X-Google-Smtp-Source: ACHHUZ7gv5FIY5ANveCmNmgink+NyF7kPovM0wBIJjVCLnmRAVn93SUkOHiTagFj0xuY6thsjMMmuA==
X-Received: by 2002:a5d:4d0f:0:b0:307:c3bc:536 with SMTP id z15-20020a5d4d0f000000b00307c3bc0536mr14143099wrt.64.1684246548391;
        Tue, 16 May 2023 07:15:48 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id z3-20020adff1c3000000b003093a412310sm963509wro.92.2023.05.16.07.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 07:15:48 -0700 (PDT)
Date: Tue, 16 May 2023 17:15:44 +0300
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
Message-ID: <20230516141544.t2e3ll3snrbi3oqq@skbuf>
References: <ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk>
 <20230515195616.uwg62f7hw47mktfu@skbuf>
 <ZGKn8c2W1SI2CPq4@shell.armlinux.org.uk>
 <20230515220833.up43pd76zne2suy2@skbuf>
 <ZGLCAfbUjexCJ2+v@shell.armlinux.org.uk>
 <20230516090009.ssq3uedjl53kzsjr@skbuf>
 <ZGNt2MFeRolKGFck@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGNt2MFeRolKGFck@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 12:49:44PM +0100, Russell King (Oracle) wrote:
> What I'm getting at is if the interface mode is
> PHY_INTERFACE_MODE_USXGMII, then... okay... we _may_ wish to do
> clause 73 negotiation advertising 10GBASE-KR and then do clause 73
                                                                  ~~
                                                                  37

> for the USXGMII control word - but the driver doesn't do this as far
> as I can see. If C73 AN is being used, it merely reads the C73
> state and returns the resolution from that. Any speed information that
> a USXGMII PHY passes back over the C37 inband signalling would be
> ignored because there seems to be no provision for the USXGMII
> inband signalling.
> 
> So I'm confused what the xpcs driver _actually_ does when USXGMII
> mode is selected by PHY_INTERFACE_MODE_USXGMII, because looking at
> the driver, it doesn't look like it's USXGMII at all.

If what you're looking for is strictly the USXGMII in-band autoneg code
word derived from C37, then the short answer is that you won't find it,
even when going back to the initial commit fcb26bd2b6ca ("net: phy: Add
Synopsys DesignWare XPCS MDIO module").

To the larger question 'what does XPCS actually do in phy-mode "usxgmii"',
I guess the simple answer looking at the aforementioned initial commit
is 'it violates the advertised coding scheme by using BASE-R instead of
BASE-X for speeds lower than 10G', and 'if you don't want the USXGMII
replicator just use phy-mode "10gbase-kr" which behaves basically the
same except it doesn't advertise the rate-adapted speeds'. Disclaimer:
I'm saying this based solely on the code and documentation.

> If we want to change that back to the old behaviour, that needs to
> be:
> 		if (test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)) {
> 			...
> 		}
> 		break;

Ok. I should send a patch fixing this, since I introduced the behavior
change. I'll add your suggested tag.

> but that wouldn't ever have been sufficient, even when the code was
> using an_enabled, because both of these reflect the user configuration.
> (an_enabled was just a proxy for this Autoneg bit). I'm going to call
> both of these an "AN indicator" in the question below.
> 
> Isn't it rather perverse that the driver configures AN if this AN
> indicator is set, but then does nothing if it isn't?

Maybe. My copy of the databook is parameterized based on
instantiation-dependent variables, and I can't really tell what are the
out-of-reset register values for hardware I don't have, so it is hard
for me to infer what is the behavior when AN is not enabled.

> As this is the only phylink-using implementation that involves clause
> 73 at present, I would like to ensure that there's a clear resolution
> of the expected behaviour before we get further implementations, and
> preferably document what's expected.

+1
that's where I would like this to go, too.

