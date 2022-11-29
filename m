Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2132763C23E
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbiK2ORh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235791AbiK2ORK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:17:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7938B64A08;
        Tue, 29 Nov 2022 06:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CFajEF7LzhmFbTWhHrHm09iOIRTmdCIIsnx1w9YoJK0=; b=DiwJ8SWIYWJXgEPMjXLwb+FiqU
        bza4a7KMWRIK/uG3vEa3hy+zhrqbCrjwfRCy8kI19QlWQbCsoHTU9ATJiKAsgex/n9BFCVNVxLqpq
        qJ1YxKT/xupmhmJz1ehcbm0hjKhhnl949LoxWrzsMIdhoa8v0qrcSgoVI1x4VF1ASico=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p01O3-003sSi-NE; Tue, 29 Nov 2022 15:15:03 +0100
Date:   Tue, 29 Nov 2022 15:15:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v1 00/26] net: dsa: microchip: stats64, fdb, error
Message-ID: <Y4YT5wfckSO1sfRw@lunn.ch>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
 <7f0a7acc-4b6b-8e33-7098-e5dfcb67945f@intel.com>
 <20221129053539.GA25526@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129053539.GA25526@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 06:35:39AM +0100, Oleksij Rempel wrote:
> On Mon, Nov 28, 2022 at 03:09:19PM -0800, Jacob Keller wrote:
> > 
> > 
> > On 11/28/2022 3:59 AM, Oleksij Rempel wrote:
> > > This patch series is a result of maintaining work on ksz8 part of
> > > microchip driver. It includes stats64 and fdb support. Error handling.
> > > Loopback fix and so on...
> > > 
> > > Oleksij Rempel (26):
> > >    net: dsa: microchip: add stats64 support for ksz8 series of switches
> > >    net: dsa: microchip: ksz8: ksz8_fdb_dump: fix port validation and VID
> > >      information
> > >    net: dsa: microchip: ksz8: ksz8_fdb_dump: fix not complete fdb
> > >      extraction
> > >    net: dsa: microchip: ksz8: ksz8_fdb_dump: fix time stamp extraction
> > >    net: dsa: microchip: ksz8: ksz8_fdb_dump: do not extract ghost entry
> > >      from empty table
> > >    net: dsa: microchip: ksz8863_smi: fix bulk access
> > >    net: dsa: microchip: ksz8_r_dyn_mac_table(): remove timestamp support
> > >    net: dsa: microchip: make ksz8_r_dyn_mac_table() static
> > >    net: dsa: microchip: ksz8_r_dyn_mac_table(): remove fid support
> > >    net: dsa: microchip: ksz8: refactor ksz8_fdb_dump()
> > >    net: dsa: microchip: ksz8: ksz8_fdb_dump: dump static MAC table
> > >    net: dsa: microchip: ksz8: move static mac table operations to a
> > >      separate functions
> > >    net: dsa: microchip: ksz8: add fdb_add/del support
> > >    net: dsa: microchip: KSZ88x3 fix loopback support
> > >    net: dsa: microchip: ksz8_r_dyn_mac_table(): move main part of the
> > >      code out of if statement
> > >    net: dsa: microchip: ksz8_r_dyn_mac_table(): use ret instead of rc
> > >    net: dsa: microchip: ksz8_r_dyn_mac_table(): ksz: do not return EAGAIN
> > >      on timeout
> > >    net: dsa: microchip: ksz8_r_dyn_mac_table(): return read/write error
> > >      if we got any
> > >    net: dsa: microchip: ksz8_r_dyn_mac_table(): use entries variable to
> > >      signal 0 entries
> > >    net: dsa: microchip: make ksz8_r_sta_mac_table() static
> > >    net: dsa: microchip: ksz8_r_sta_mac_table(): do not use error code for
> > >      empty entries
> > >    net: dsa: microchip: ksz8_r_sta_mac_table(): make use of error values
> > >      provided by read/write functions
> > >    net: dsa: microchip: make ksz8_w_sta_mac_table() static
> > >    net: dsa: microchip: ksz8_w_sta_mac_table(): make use of error values
> > >      provided by read/write functions
> > >    net: dsa: microchip: remove ksz_port:on variable
> > >    net: dsa: microchip: ksz8: do not force flow control by default
> > > 
> > 
> > 
> > My understanding is that we typically limit series to 15 patches. Do you
> > have some justification for why this goes over 15 and can't reasonably be
> > split into two series?
> > 
> > At a glance it seems like a bunch of smaller cleanups.
> 
> The previous patch set got request to do more clean ups:
> https://lore.kernel.org/all/20221124101458.3353902-1-o.rempel@pengutronix.de/
> 
> I need to show, there are already more patches in the queue.

There is some psychology involved here. I see 26 patches and decide i
need to allocate 30 minutes to this sometime, and put the review off
until later, without even looking at them. If i get 5 patches, i
probably just do it, knowing i will be finished pretty quickly. My
guess is, 5 patches a day for 5 days will be merged faster than 26
patches in one go.

     Andrew
