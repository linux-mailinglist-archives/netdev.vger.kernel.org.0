Return-Path: <netdev+bounces-10479-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A3C272EAFB
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:29:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B3791C203B2
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD163D38E;
	Tue, 13 Jun 2023 18:29:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9DC38CA4
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 18:29:40 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C2710CC;
	Tue, 13 Jun 2023 11:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DXfkpTd4BgNrWMUgFq3EjpQXH5nUJQkyJKKnkCOa5Zk=; b=O19PVe2L/0aXNxgPLyhPb8w6Sp
	nKuVjsn1qMFhWQsMddhnsavhxJox9cdxWE13H2FW74HQKEn+TFPm1hi2CPvQHIEw9uOsJrzyu5Y5k
	ONqAWhYz/mbbqXtDYrWrivVe3x/1BZAERDePJZ9ZLyTAsVybcj0vb+4H3ZAL2iMHPaP085RNGaJBy
	+OMPtcJKrZpMULnW1vHejvvo9/kRP3j0Ui2daorSwKMLccOabS9tbFd9DH8ARZCacQUVeYK8zvmZN
	zi1DSc0tcof9oVe2GuBWu4SZtL35rRYwXyxYKKWz7ucdpdWxW7XR1Qiz2a0qj7kRRH+oA3QQuEN5r
	SqhNpZGw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43678)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q98lf-0000Z9-GS; Tue, 13 Jun 2023 19:29:23 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q98la-0006Fs-DQ; Tue, 13 Jun 2023 19:29:18 +0100
Date: Tue, 13 Jun 2023 19:29:18 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Vladimir Oltean <olteanv@gmail.com>,
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
Subject: Re: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7530
Message-ID: <ZIi1fixnNqj9Gfcg@shell.armlinux.org.uk>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <20230611081547.26747-2-arinc.unal@arinc9.com>
 <20230613150815.67uoz3cvvwgmhdp2@skbuf>
 <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
 <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
 <20230613172402.grdpgago6in4jogq@skbuf>
 <ca78b2f9-bf98-af26-0267-60d2638f7f00@arinc9.com>
 <20230613173908.iuofbuvkanwyr7as@skbuf>
 <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 08:58:33PM +0300, Arınç ÜNAL wrote:
> On 13.06.2023 20:39, Vladimir Oltean wrote:
> > On Tue, Jun 13, 2023 at 08:30:28PM +0300, Arınç ÜNAL wrote:
> > > That fixes port 5 on certain variants of the MT7530 switch, as it was
> > > already working on the other variants, which, in conclusion, fixes port 5 on
> > > all MT7530 variants.
> > 
> > Ok. I didn't pay enough attention to the commit message.
> > 
> > > And no, trapping works. Having only CPU port 5 defined on the devicetree
> > > will cause the CPU_PORT bits to be set to port 5. There's only a problem
> > > when multiple CPU ports are defined.
> > 
> > Got it. Then this is really not a problem, and the commit message frames
> > it incorrectly.
> 
> Actually this patch fixes the issue it describes. At the state of this
> patch, when multiple CPU ports are defined, port 5 is the active CPU port,
> CPU_PORT bits are set to port 6.

Maybe it's just me being dumb, but I keep finding things difficult to
understand, such as the above paragraph.

It sounds like you're saying that _before_ this patch, port 5 is the
active CPU port, but the CPU_PORT *FIELD* NOT BITS are set such that
port 6 is the active CPU port. Therefore, things are broken, and this
patch fixes it.

Or are you saying that after this patch is applied, port 5 is the
active CPU port, but the CPU_PORT *FIELD* is set to port 6. If that's
true, then I've no idea what the hell is going on here because it
seems to be senseless.

I think at this point I just give up trying to understand what the
hell these patches are trying to do - in my opinion, the commit
messages are worded attrociously and incomprehensively.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

