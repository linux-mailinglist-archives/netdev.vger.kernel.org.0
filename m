Return-Path: <netdev+bounces-10225-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 927EB72D129
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:54:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41929280C20
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52819D2E0;
	Mon, 12 Jun 2023 20:54:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F01EA0
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 20:54:04 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4405256;
	Mon, 12 Jun 2023 13:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ib/BYS6PUvyGMIURzmXU2ExMoFjE66F8x1vPECql7zg=; b=uA1wKZOuSeYItA2kecWFqYWSNd
	u7M4CIA1EUKLaMVVCftV+C4/9P5qDqEH8jIFCLDdUdqdXjCrYJLss9rux8ensn0+Xniyizrf7O7fL
	3nn9eALfAWI9wSNLgQCcu8Poh6HuR2HcjNRzVN+ex9VNYT9VKsu+iSO4JIgfq7XKALrfCoOxNCSyt
	YKoGW8eGb8gbbr/1uFnzmtEaoM0aZWERtxBTQNBUZOxeUJTWBPun00GJv5moHg9n2BxkfknZW/lcl
	OR2eR2ftI9VyLdvhs6OFn0tk0jPkSCjLQgBcIqGyk65soJKY7kQ6aZNKHznqa6eIP6T2OzTDSEvhU
	0YHPnv+Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46250)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q8oWi-0006LF-Ro; Mon, 12 Jun 2023 21:52:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q8oWb-0005J4-4s; Mon, 12 Jun 2023 21:52:29 +0100
Date: Mon, 12 Jun 2023 21:52:29 +0100
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
Subject: Re: [PATCH net v4 0/7] net: dsa: mt7530: fix multiple CPU ports,
 BPDU and LLDP handling
Message-ID: <ZIeFjdxctcR4yRLZ@shell.armlinux.org.uk>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <ZIcDee2+Lz7nJ3j6@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIcDee2+Lz7nJ3j6@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 12:37:29PM +0100, Russell King (Oracle) wrote:
> Hi,
> 
> Please slow down your rate of patch submission - I haven't had a chance
> to review the other patches yet (and I suspect no one else has.) Always
> allow a bit of time for discussion.
> 
> Just because you receive one comment doesn't mean you need to rush to
> get a new series out. Give it at least a few days because there may be
> further discussion of the points raised.
> 
> Sending new versions quickly after previous comments significantly
> increases reviewer workload.

And a very illustratory point is that I responded with a follow up to
your reply on v2, hadn't noticed that you'd sent v4, and the comments
I subsequently made on v2 apply to v4... and I haven't even looked at
v3 yet.

This is precisely why you need to stop "I've received an email, I've
made changes. Quick! Post the next version!" No, don't do that. Wait
a while for further feedback before posting the next version,
particularly if you've replied to reviewer comments - give the
reviewer some time to respond before posting the next version.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

