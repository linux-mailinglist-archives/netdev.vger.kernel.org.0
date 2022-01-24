Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794754986FC
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbiAXRgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbiAXRgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:36:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8890C06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:36:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFB3EB811A2
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 17:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AD5C340E5;
        Mon, 24 Jan 2022 17:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643045758;
        bh=+E2BRWmmi8JiTRYDcTmCrVVlELYsNXDJimgRI50NbwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HRZLM1eL1tnpSGXYVasMkz+n7g1XgIhCdOy2qmh24HHNgTlAP7EG1Ws4lWUk3Xbds
         c3VVD3rYFPAexd0hzS/6FTUUqs2Ig3IMugjkNaBAwwyX+HivedwFdK3gfrAfEFbBCW
         /M0Wl/pS/KeGAvtEFQrlVN+Q5uT1nZ/RUaAdo1AGXNIgrtDahH+MR6DH2xFECmR715
         qTJcYY/e1Wx81kEs0hEiJJr4vgKHA8V18HfrCI5MgYc6P1bMoEQn3qx4RZoO4vSoWD
         gkLCnaJPy6xrcIeKtSDHn3/ogQ4cEDFiCnUVO0qxYYHtAyayoaQ5jHhGDpVTn9QE8G
         8Hd/DCPnkEX+Q==
Date:   Mon, 24 Jan 2022 09:35:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb:
 multiple cpu ports, non cpu extint
Message-ID: <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124172158.tkbfstpwg2zp5kaq@skbuf>
References: <20220121020627.spli3diixw7uxurr@skbuf>
        <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
        <20220121185009.pfkh5kbejhj5o5cs@skbuf>
        <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
        <20220121224949.xb3ra3qohlvoldol@skbuf>
        <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
        <20220124153147.agpxxune53crfawy@skbuf>
        <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220124165535.tksp4aayeaww7mbf@skbuf>
        <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
        <20220124172158.tkbfstpwg2zp5kaq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 19:21:58 +0200 Vladimir Oltean wrote:
> On Mon, Jan 24, 2022 at 09:01:20AM -0800, Florian Fainelli wrote:
> > On 1/24/2022 8:55 AM, Vladimir Oltean wrote:  
> > > Sorry Jakub, I don't understand what you mean to say when applied to the
> > > context discussed here?  
> > 
> > I believe what Jakub meant to say is that if a DSA conduit device driver
> > advertises any of the NETIF_F_IP*_CSUM feature bits, then the driver's
> > transmit path has the responsibility of checking that the payload being
> > transmitted has a chance of being checksummed properly by the hardware. The
> > problem here is not so much the geometry itself (linear or not, number/size
> > of fragments, etc.) as much as the placement of the L2/L3 headers usually.

Sorry I used "geometry" loosely.

What I meant is simply that if the driver uses NETIF_F_IP*_CSUM 
it should parse the packet before it hands it off to the HW.

There is infinity of protocols users can come up with, while the device
parser is very much finite, so it's only practical to check compliance
with the HW parser in the driver. The reverse approach of adding
per-protocol caps is a dead end IMO. And we should not bloat the stack
when NETIF_F_HW_CSUM exists and the memo that parsing packets on Tx is
bad b/c of protocol ossification went out a decade ago.

> > DSA conduit network device drivers do not have the ability today to
> > determine what type of DSA tagging is being applied onto the DSA master but
> > they do know whether DSA tagging is in use or not which may be enough to be
> > overly compatible.
> > 
> > It is not clear to me whether we can solve this generically within the DSA
> > framework or even if this is desirable, but once we have identified a
> > problematic association of DSA tagger and DSA conduit, we can always have
> > the DSA conduit driver do something like:
> > 
> > if (netdev_uses_dsa(dev))
> > 	skb_checksum_help()
> > 
> > or have a fix_features callback which does reject the enabling of
> > NETIF_F_IP*_CSUM if netdev_uses_dsa() becomes true.  
> 
> Yes, but as you point out, the DSA master driver doesn't know what
> header/trailer format it's dealing with. We could use netdev_uses_dsa()
> as a very rough approximation, and that might work when we know that the
> particular Ethernet controller is used only in conjunction with a single
> type of DSA switch [from the same vendor], but I think we're just
> delaying the inevitable, which is to treat the case where an Ethernet
> controller can be a DSA master for more than one switch type, and it
> understands some protocols but not others.
> Also, scattering "if (netdev_uses_dsa(dev)) skb_checksum_help()" in
> DSA-unaware drivers (the common case) seems like the improper approach.
> We might end up seeing this pattern quite a lot, so DSA-unaware drivers
> won't be DSA-unaware any longer.

It's not about DSA. The driver should not check

if (dsa())
	blah;

it should check 

if (!(eth [-> vlan] -> ip -> tcp/udp))
	csum_help();

> It's still possible I'm misunderstanding something...
