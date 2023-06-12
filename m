Return-Path: <netdev+bounces-10077-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A8372BE6C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:11:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C37E1C20A13
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED1218C2A;
	Mon, 12 Jun 2023 10:11:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1329218C29
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:11:18 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50A5F7DE;
	Mon, 12 Jun 2023 03:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+yjKKzdnGV2UUsk+B6shVDCi3BDA94ELYFsM4QUhQB0=; b=Q9gFFEqBJOoqsKLY+1HuM+QoVW
	esIoL5PNJsyp5o0kQ7sCIo6rBNpWJA0C4ZR6IssVf8AGR1cmTzDj3yUus70hPty1PuVkq2Yo4iccw
	oNvlotm6b5P62z4/jwNxaIc+hIgCUE6hRyozSs/QJiMiNr+9w0cc9oDGH0p30pnCHlU/utsD352bs
	cswMCUjp3aE0AGGUiBh4Du0xu5460W9Q+q44WDlxsFsXDM/49r977+cct8GQ2M/U0UZ1s0RII75WL
	YAXGsjMJFN/dyxpgnsjuMQWUFGNxOtrJmpZg3Pt91fwwpiDJODPPMohE4EluptIL9uH7fSv251BvW
	1C1wTYrQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43862)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q8eU9-0005V0-P3; Mon, 12 Jun 2023 11:09:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q8eU2-0004rh-NT; Mon, 12 Jun 2023 11:09:10 +0100
Date: Mon, 12 Jun 2023 11:09:10 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
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
Subject: Re: [PATCH net v2 1/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7531
Message-ID: <ZIbuxohDqHA0S7QP@shell.armlinux.org.uk>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <ZIXwc0V5Ye6xrpmn@shell.armlinux.org.uk>
 <9d571682-7271-2a5e-8079-900d14a5d7cd@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9d571682-7271-2a5e-8079-900d14a5d7cd@arinc9.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 09:40:45AM +0300, Arınç ÜNAL wrote:
> On 11.06.2023 19:04, Russell King (Oracle) wrote:
> > On Sun, Jun 11, 2023 at 11:15:41AM +0300, Arınç ÜNAL wrote:
> > > Every bit of the CPU port bitmap for MT7531 and the switch on the MT7988
> > > SoC represents a CPU port to trap frames to. These switches trap frames to
> > > the CPU port the user port, which the frames are received from, is affine
> > > to.
> > 
> > I think you need to reword that, because at least I went "err what" -
> > especially the second sentence!
> 
> Sure, how does this sound:
> 
> These switches trap frames to the CPU port that is affine to the user port
> from which the frames are received.

"... to the inbound user port." I think that's a better way to describe
"user port from which the frames are received."

However, I'm still struggling to understand what the overall message for
this entire commit log actually is.

The actual affinity of the user ports seems to be not relevant, but this
commit is more about telling the switch which of its ports are CPU
ports.

So, if the problem is that we only end up with a single port set as a
CPU port when there are multiple, isn't it going to be better to say
something like:

"For MT7531 and the switch on MT7988, we are not correctly indicating
which ports are CPU ports when we have more than one CPU port. In order
to solve this, we need to set multiple bits in the XYZ register so the
switch will trap frames to the appropriate CPU port for frames received
on the inbound user port.

> > > Currently, only the bit that corresponds to the first found CPU port is set
> > > on the bitmap.
> > 
> > Ok.
> > 
> > > When multiple CPU ports are being used, frames from the user
> > > ports affine to the other CPU port which are set to be trapped will be
> > > dropped as the affine CPU port is not set on the bitmap.
> > 
> > Hmm. I think this is trying to say:
> > 
> > "When multiple CPU ports are being used, trapped frames from user ports
> > not affine to the first CPU port will be dropped we do not set these
> > ports as being affine to the second CPU port."
> 
> Yes but it's not the affinity we set here. It's to enable the CPU port for
> trapping.

In light of that, is the problem that we only enable one CPU port to
receive trapped frames from their affine user ports?

> > > Only the MT7531
> > > switch is affected as there's only one port to be used as a CPU port on the
> > > switch on the MT7988 SoC.
> > 
> > Erm, hang on. The previous bit indicated there was a problem when there
> > are multiple CPU ports, but here you're saying that only one switch is
> > affected - and that switch has only one CPU port. This at the very least
> > raises eyebrows, because it's just contradicted the first part
> > explaining when there's a problem.
> 
> I meant to say, since I already explained at the start of the patch log that
> this patch changes the bits of the CPU port bitmap for MT7531 and the switch
> on the MT7988 SoC, only MT7531 is affected as there's only a single CPU port
> on the switch on the MT7988 SoC. So the switch on the MT7988 SoC cannot be
> affected.



> 
> > 
> > > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > > index 9bc54e1348cb..8ab4718abb06 100644
> > > --- a/drivers/net/dsa/mt7530.c
> > > +++ b/drivers/net/dsa/mt7530.c
> > > @@ -1010,6 +1010,14 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
> > >   	if (priv->id == ID_MT7621)
> > >   		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
> > > +	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
> > > +	 * the MT7988 SoC. Any frames set for trapping to CPU port will be
> > > +	 * trapped to the CPU port the user port, which the frames are received
> > > +	 * from, is affine to.
> > 
> > Please reword the second sentence.
> 
> Any frames set for trapping to CPU port will be trapped to the CPU port that
> is affine to the user port from which the frames are received.

Too many "port"s. Would:

"Add this port to the CPU port bitmap for the MT7531 and switch on the
MT7988. Trapped frames will be sent to the CPU port that is affine to
the inbound user port."

explain it better?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

