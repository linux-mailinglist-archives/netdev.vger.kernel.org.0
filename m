Return-Path: <netdev+bounces-10792-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E954C73053B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:42:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 267D21C20A94
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632B82EC10;
	Wed, 14 Jun 2023 16:42:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EB52EC07
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:42:45 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1098F1A3;
	Wed, 14 Jun 2023 09:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wuwv6R2n6vyyWA1URLZOiy/KvbTZmgcum6LrvrKQKuA=; b=FRLQvfRAZ9owE+A6TYcFTPP6sA
	7xc+Gy5Tw5YiQ26W0GFfesvUBAw2VdDGFHxNoYgaSjVErnJKDZMTsViqd7FVmFEeZMDIw6t5suZrO
	I2j5+ZvZtGcYhYH2gd93hMpbsvGcc1a1WHWTBHMUnbng/HumUuKtndpGZdGfpjNBJ1mKbnqa1TyuR
	fyTSWcYtjdKUtdZ51q1V8SYajVIlrZU4jYwEKP2VCfPvWHtv9GkeGhTd6WnIF6xETRjoUJS/H4k64
	tstEhMyUdR8FlaYl+xYe19ySassHmSauHQm/Mtn1fYKxxS6CP6C1qXWd/2SwybxVV6zdA48/31x18
	daVpNdzA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57494)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q9TZl-00020S-NU; Wed, 14 Jun 2023 17:42:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q9TZi-0000aD-CA; Wed, 14 Jun 2023 17:42:26 +0100
Date: Wed, 14 Jun 2023 17:42:26 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: arinc9.unal@gmail.com
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
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
Subject: Re: [PATCH net v4 5/7] net: dsa: mt7530: fix handling of LLDP frames
Message-ID: <ZInt8mmrZ6tCGy1N@shell.armlinux.org.uk>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-6-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230612075945.16330-6-arinc.unal@arinc9.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 10:59:43AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> LLDP frames are link-local frames, therefore they must be trapped to the
> CPU port. Currently, the MT753X switches treat LLDP frames as regular
> multicast frames, therefore flooding them to user ports. To fix this, set
> LLDP frames to be trapped to the CPU port(s).
> 
> The mt753x_bpdu_port_fw enum is universally used for trapping frames,
> therefore rename it and the values in it to mt753x_port_fw.
> 
> For MT7530, LLDP frames received from a user port will be trapped to the
> numerically smallest CPU port which is affine to the DSA conduit interface
> that is up.
> 
> For MT7531 and the switch on the MT7988 SoC, LLDP frames received from a
> user port will be trapped to the CPU port that is affine to the user port
> from which the frames are received.
> 
> The bit for R0E_MANG_FR is 27. When set, the switch regards the frames with
> :0E MAC DA as management (LLDP) frames. This bit is set to 1 after reset on
> MT7530 and MT7531 according to the documents MT7620 Programming Guide v1.0
> and MT7531 Reference Manual for Development Board v1.0, so there's no need
> to deal with this bit. Since there's currently no public document for the
> switch on the MT7988 SoC, I assume this is also the case for this switch.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")

Patch 4 claims to be a fix for this commit, and introduces one of these
modifications to MT753X_BPC, which this patch then changes.

On the face of it, it seems this patch is actually a fix to patch 4 as
well as the original patch, so does that mean that patch 4 only half
fixes a problem?

Bah, I give up with this. IMHO it's just too much of a mess trying to
do any sane review of it. No, I'm not going to give any acks or
reviewed-bys to it because nothing here makes much sense to me.

And I just can't be bothered trying to parse the commit messages
anymore.

Sorry but no, I'm going to be ignoring these patch sets from now on.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

