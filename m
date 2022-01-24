Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C5C498526
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243882AbiAXQq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243897AbiAXQqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:46:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE51AC061401
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 08:46:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9D3EB81145
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 16:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BF8C340E5;
        Mon, 24 Jan 2022 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643042811;
        bh=BvRf80LbhAJRbx8R65apxv18iSzzg/gd0C2URGCy0ug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=esLLYD/Z/Z2HLFVwG7SqONRYwaPhuBmTglqFNw5PmEk6SjHWWlm2tFsFGjiOJmyEN
         hSRSVg8yOSiALww8JtPEp03zBE2Nym55amiIs7pl1JYondkb7qbJSN0xyUMzYfIcTh
         xHczIUPp4jt6gBUrGXiwuVwt+QHCYsV3wMRsd3cQfHhznWcnGfIjMz5jykDi1vsyD6
         0qBx7F1WXtcnpN9hCmwZOWR7kOGkr1MaFtpxPDiohCnMeXQsGowgoOv+vRrx5pYQl8
         nLJJYhpCxOdIkvtaWJ+6q2FCAISQpUFGxvzfBtFjQgNhraCY46KAy5hgTbo2ExBwST
         jz53fOzq3+v7Q==
Date:   Mon, 24 Jan 2022 08:46:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb:
 multiple cpu ports, non cpu extint
Message-ID: <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124153147.agpxxune53crfawy@skbuf>
References: <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
        <Yea+uTH+dh9/NMHn@lunn.ch>
        <20220120151222.dirhmsfyoumykalk@skbuf>
        <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
        <20220121020627.spli3diixw7uxurr@skbuf>
        <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
        <20220121185009.pfkh5kbejhj5o5cs@skbuf>
        <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
        <20220121224949.xb3ra3qohlvoldol@skbuf>
        <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
        <20220124153147.agpxxune53crfawy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 17:31:47 +0200 Vladimir Oltean wrote:
> > I checked DSA doc again and it says:
> > 
> > "Since tagging protocols in category 1 and 2 break software (and most
> > often also hardware) packet dissection on the DSA master, features
> > such as RPS (Receive Packet Steering) on the DSA master would be
> > broken. The DSA framework deals with this by hooking into the flow
> > dissector and shifting the offset at which the IP header is to be
> > found in the tagged frame as seen by the DSA master. This behavior is
> > automatic based on the overhead value of the tagging protocol. If not
> > all packets are of equal size, the tagger can implement the
> > flow_dissect method of the struct dsa_device_ops and override this
> > default behavior by specifying the correct offset incurred by each
> > individual RX packet. Tail taggers do not cause issues to the flow
> > dissector."
> > 
> > It makes me think that it is the master network driver that does not
> > implement that IP header location shift. Anyway, I believe it also
> > depends on HW capabilities to inform that shift, right?
> > 
> > I'm trying to think as a DSA newbie (which is exactly what I am).
> > Differently from an isolated ethernet driver, with DSA, the system
> > does have control of "something" after the offload should be applied:
> > the dsa switch. Can't we have a generic way to send a packet to the
> > switch and make it bounce back to the CPU (passing through the offload
> > engine)? Would it work if I set the destination port as the CPU port?
> > This way, we could simply detect if the offload worked and disable
> > those features that did not work. It could work with a generic
> > implementation or, if needed, a specialized optional ds_switch_ops
> > function just to setup that temporary lookback forwarding rule.  
> 
> To be clear, do you consider this simpler than an ndo operation that
> returns true or false if a certain DSA master can offload a certain
> netdev feature in the presence of a certain DSA tag?
> 
> Ignoring the fact that there are subtly different ways in which various
> hardware manufacturers implement packet injection from the CPU (and this
> is reflected in the various struct dsa_device_ops :: xmit operation),
> plus the fact that dsa_device_ops :: xmit takes a slave net_device as
> argument, for which there is none to represent the CPU port. These
> points mean that you'd need to implement a separate, hardware-specific
> loopback xmit for each tagging protocol. But again, ignoring that for a
> second.
> 
> When would be a good time to probe for DSA master features? The DSA
> master might be down when DSA switches probe. What should we do with
> packets sent on a DSA port until we've finished probing for DSA master
> capabilities?

I thought for drivers setting the legacy NETIF_F_IP*_CSUM feature
it's driver's responsibility to validate the geometry of the packet
will work with the parser the device has. Or at least I think that's
what Tom was pushing for when he was cleaning up the checksumming last
(and wrote the long comment on the subject in skbuff.h).
