Return-Path: <netdev+bounces-11381-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38CB8732D4C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6980C1C20B25
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97607182B1;
	Fri, 16 Jun 2023 10:19:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F37DDC9
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:19:32 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F047AC;
	Fri, 16 Jun 2023 03:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sK1OkILI3tCCKrHsANJ/lF6HcUCMTaIXmnshn6ttAEk=; b=lyBGCl/4UEreZscOrhXlDdFEY4
	8/SdOD5RAX1cvJtX4AUwvr6vRfY4GQ9uQpyTdDVJDXg3tnQfumKhfUUU6x+mkJ3aTBCBzvQUmaE2T
	v+rsBLj++yRFKRbhNvB4++SLl+/O8uvxvbBqOHH+vo/A4u4148LxHnd5EvPMik6IMxy1pHOAk2QG0
	OxMZrQ2IXmCRx3k2QsO/FjYT3itl3JMOpPnqOenIQamEqLlWL9xgwcnog9t+gMovtoNzQEYoS1ppV
	mfM2ieIDwipcSKqGgGsvYft6Y/C8QyJZXEhynQR/ZxEshY8qY+hDCrEXTYpBj0HUV3zNfJ+C7lkmU
	9ED59txA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45520)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qA6Y3-0004mw-QS; Fri, 16 Jun 2023 11:19:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qA6Y2-0002QX-ND; Fri, 16 Jun 2023 11:19:18 +0100
Date: Fri, 16 Jun 2023 11:19:18 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: arinc9.unal@gmail.com,
	=?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v5 3/6] net: dsa: mt7530: fix handling of BPDUs on
 MT7530 switch
Message-ID: <ZIw3JiJlnNZYf0/Z@shell.armlinux.org.uk>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
 <20230616025327.12652-1-arinc.unal@arinc9.com>
 <20230616025327.12652-4-arinc.unal@arinc9.com>
 <20230616025327.12652-4-arinc.unal@arinc9.com>
 <20230616101108.wq5aote3yjpekilu@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230616101108.wq5aote3yjpekilu@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 01:11:08PM +0300, Vladimir Oltean wrote:
> On Fri, Jun 16, 2023 at 05:53:24AM +0300, arinc9.unal@gmail.com wrote:
> > From: Arınç ÜNAL <arinc.unal@arinc9.com>
> > 
> > BPDUs are link-local frames, therefore they must be trapped to the CPU
> > port. Currently, the MT7530 switch treats BPDUs as regular multicast
> > frames, therefore flooding them to user ports. To fix this, set BPDUs to be
> > trapped to the CPU port.
> > 
> > Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> > Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> > ---
> >  drivers/net/dsa/mt7530.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > index e9fbe7ae6c2c..7b72cf3a0e30 100644
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -2262,6 +2262,10 @@ mt7530_setup(struct dsa_switch *ds)
> >  
> >  	priv->p6_interface = PHY_INTERFACE_MODE_NA;
> >  
> > +	/* Trap BPDUs to the CPU port */
> > +	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> > +		   MT753X_BPDU_CPU_ONLY);
> > +
> >  	/* Enable and reset MIB counters */
> >  	mt7530_mib_reset(ds);
> >  
> > -- 
> > 2.39.2
> > 
> 
> Ok, so this issue dates back to v4.12, but the patch won't apply that
> far due to the difference in patch context.
> 
> Since the definition itself of the MT753X_BPC register was added as part
> of commit c288575f7810 ("net: dsa: mt7530: Add the support of MT7531
> switch") - dated v5.10 - then this patch cannot be practically be
> backported beyond that.
> 
> So I see no possible objection to the request I'm about to make, which is:
> please group this and the identical logic from mt7531_setup() into a
> common function and call that.

I agree.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

