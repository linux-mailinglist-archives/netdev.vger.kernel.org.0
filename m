Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9850447072E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238195AbhLJRdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238148AbhLJRdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:33:12 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F4DC0617A2
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:29:37 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id l25so32553440eda.11
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=9RxjzszKD9Od2e7YXG/V8VJLLgdKFHVpoBxdV2xV9Sg=;
        b=LR7UIFzXBJTvJ/2ftzA6+FUN6zNDCqpVodAdiO8Ey+SseHMDVX8HxfQM5tDjonYTmW
         LZQ7D9rUm7ie9HLr2I0PnNawo5Byv7qRNA2dqsxUXG9oe+v8oh7bgJTRBlE9q6UGvBw1
         DMBCYiirXfeI4c+Vr4Ix/ZPgIuKp9EMvLGdrONMuCw4B5YeD93pDt3QurD2WE+ton1zT
         tSAaDiy/XgEBcERj16fnn+ZxBAgqGmd+Hths5oGd0Dp4PUJfrUwGewYS41qVL/DnHlwl
         cHBJe/wL7seQMwboLb3+FkxmJachCDcQ7v1gH5iCmjH0LbD9BWTolz833ZZurbLNOyrA
         Kf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=9RxjzszKD9Od2e7YXG/V8VJLLgdKFHVpoBxdV2xV9Sg=;
        b=LQv+LnPgMp2MvGtAc3V1P31qovDEJpg1F165oLncdIrmVFgahNvuzt3PU68b/Fw9YY
         zuoX+iEfr6jZ4OWhoeARoRcaKJmohGppOWctN29/fX+TqhgfrjyBiCupohEVQEaunOCg
         ctxdOGlqDbxdWgW6UMgLYvtDMTm8SETnf9O+mVHBeVBg0C0dZyrnuY4bq9vfZB/QNXqo
         lTXImEqSoEF6/+FNcgMgchUVkCiyqv3FGOd+gjG9Dy2p8OCbuPHUgCU9EoDvfxT6OXgD
         VduTi2uyK1kGwp5Fdq/3irCiE5ZnGJkXE5c+rZWPB9Ndr1/rnfr5OrCLE9yJhzOHQwMG
         HyFQ==
X-Gm-Message-State: AOAM531gB7owf9S42KWPzeTLjSlZVsmWoSwnBA+PglrqCTwV2lL8DGbn
        w5aCjHLPcFCDRh1pti5CHuU=
X-Google-Smtp-Source: ABdhPJzt+E+1d9+t7u1kCRZSTqAaMJFAgii/jGX1dzx1wu1qeVTzcXyi2JSvYzkYvKpTwvJeeQFwow==
X-Received: by 2002:a05:6402:1453:: with SMTP id d19mr38714841edx.388.1639157375661;
        Fri, 10 Dec 2021 09:29:35 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id m22sm1726075eda.97.2021.12.10.09.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:29:35 -0800 (PST)
Message-ID: <61b38e7f.1c69fb81.96d1c.7933@mx.google.com>
X-Google-Original-Message-ID: <YbOOfJMDSR2rPoI7@Ansuel-xps.>
Date:   Fri, 10 Dec 2021 18:29:32 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 0/4] DSA master state tracking
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
 <61b2cb93.1c69fb81.2192a.3ef3@mx.google.com>
 <20211210170242.bckpdm2qa6lchbde@skbuf>
 <61b38a18.1c69fb81.95975.8545@mx.google.com>
 <20211210171530.xh7lajqsvct7dd3r@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210171530.xh7lajqsvct7dd3r@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 05:15:30PM +0000, Vladimir Oltean wrote:
> On Fri, Dec 10, 2021 at 06:10:45PM +0100, Ansuel Smith wrote:
> > On Fri, Dec 10, 2021 at 05:02:42PM +0000, Vladimir Oltean wrote:
> > > On Fri, Dec 10, 2021 at 04:37:52AM +0100, Ansuel Smith wrote:
> > > > On Thu, Dec 09, 2021 at 07:39:23PM +0200, Vladimir Oltean wrote:
> > > > > This patch set is provided solely for review purposes (therefore not to
> > > > > be applied anywhere) and for Ansuel to test whether they resolve the
> > > > > slowdown reported here:
> > > > > https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.7444-1-ansuelsmth@gmail.com/
> > > > > 
> > > > > The patches posted here are mainly to offer a consistent
> > > > > "master_state_change" chain of events to switches, without duplicates,
> > > > > and always starting with operational=true and ending with
> > > > > operational=false. This way, drivers should know when they can perform
> > > > > Ethernet-based register access, and need not care about more than that.
> > > > > 
> > > > > Changes in v2:
> > > > > - dropped some useless patches
> > > > > - also check master operstate.
> > > > > 
> > > > > Vladimir Oltean (4):
> > > > >   net: dsa: provide switch operations for tracking the master state
> > > > >   net: dsa: stop updating master MTU from master.c
> > > > >   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
> > > > >   net: dsa: replay master state events in
> > > > >     dsa_tree_{setup,teardown}_master
> > > > > 
> > > > >  include/net/dsa.h  | 11 +++++++
> > > > >  net/dsa/dsa2.c     | 80 +++++++++++++++++++++++++++++++++++++++++++---
> > > > >  net/dsa/dsa_priv.h | 13 ++++++++
> > > > >  net/dsa/master.c   | 29 ++---------------
> > > > >  net/dsa/slave.c    | 27 ++++++++++++++++
> > > > >  net/dsa/switch.c   | 15 +++++++++
> > > > >  6 files changed, 145 insertions(+), 30 deletions(-)
> > > > > 
> > > > > -- 
> > > > > 2.25.1
> > > > > 
> > > > 
> > > > Hi, I tested this v2 and I still have 2 ethernet mdio failing on init.
> > > > I don't think we have other way to track this. Am I wrong?
> > > > 
> > > > All works correctly with this and promisc_on_master.
> > > > If you have other test, feel free to send me other stuff to test.
> > > > 
> > > > (I'm starting to think the fail is caused by some delay that the switch
> > > > require to actually start accepting packet or from the reinit? But I'm
> > > > not sure... don't know if you notice something from the pcap)
> > > 
> > > I've opened the pcap just now. The Ethernet MDIO packets are
> > > non-standard. When the DSA master receives them, it expects the first 6
> > > octets to be the MAC DA, because that's the format of an Ethernet frame.
> > > But the packets have this other format, according to your own writing:
> > > 
> > > /* Specific define for in-band MDIO read/write with Ethernet packet */
> > > #define QCA_HDR_MDIO_SEQ_LEN           4 /* 4 byte for the seq */
> > > #define QCA_HDR_MDIO_COMMAND_LEN       4 /* 4 byte for the command */
> > > #define QCA_HDR_MDIO_DATA1_LEN         4 /* First 4 byte for the mdio data */
> > > #define QCA_HDR_MDIO_HEADER_LEN        (QCA_HDR_MDIO_SEQ_LEN + \
> > >                                        QCA_HDR_MDIO_COMMAND_LEN + \
> > >                                        QCA_HDR_MDIO_DATA1_LEN)
> > > 
> > > #define QCA_HDR_MDIO_DATA2_LEN         12 /* Other 12 byte for the mdio data */
> > > #define QCA_HDR_MDIO_PADDING_LEN       34 /* Padding to reach the min Ethernet packet */
> > > 
> > > The first 6 octets change like crazy in your pcap. Definitely can't add
> > > that to the RX filter of the DSA master.
> > > 
> > > So yes, promisc_on_master is precisely what you need, it exists for
> > > situations like this.
> > > 
> > > Considering this, I guess it works?
> > 
> > Yes it works! We can totally accept 2 mdio timeout out of a good way to
> > track the master port. It's probably related to other stuff like switch
> > delay or other.
> > 
> > Wonder the next step is wait for this to be accepted and then I can
> > propose a v3 of my patch? Or net-next is closed now and I should just
> > send v3 RFC saying it does depend on this?
> 
> Wait a minute, I don't think I understood your previous reply.
> With promisc_on_master, is there or is there not any timeout?

With promisc_on_master I have only 2 timeout.

> My understanding was this: DSA tells you when the master is up and
> operational. That information is correct, except it isn't sufficient and
> you don't see the replies back. Later during boot, you have some init
> scripts triggered by user space that create a bridge interface and put
> the switch ports under the bridge. The bridge puts the switch interfaces
> in promiscuous mode, because that's what bridges do. Then DSA propagates
> the promiscuous mode from the switch ports to the DSA master, and once
> the master is promiscuous, the Ethernet MDIO starts working too.
> Now, with promisc_on_master set, the DSA master is already promiscuous
> by the time DSA tells you that it's up and running. Hence your message
> that "All works correctly with this and promisc_on_master."
> What did I misunderstand?

You got all correct. But still I have these 2 timeout at the very start.
Let me give you another pastebin to make this more clear. [0]
Transaction done is when the Ethernet packet is received and processed.
I added some pr with the events received by switch.c

I should check if the tagger receive some packet before the
"function timeout". 
What I mean with "acceptable state" is that aside from the 2
timeout everything else works correctly withtout any slowdown in the
init process.

[0] https://pastebin.com/VfGB5hAQ

-- 
	Ansuel
