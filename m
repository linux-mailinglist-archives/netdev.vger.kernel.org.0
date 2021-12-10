Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046DD4706BD
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243846AbhLJRO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhLJROZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:14:25 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECBBC061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:10:50 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id e3so32691643edu.4
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=lJqmOoRlMg58C9w6zpz+gG2d8yd5AfUZK1CP6OCQNYY=;
        b=IZDoPhUcSHB9gauAv9uDSHZveQCwMQwDsH8Hld5eSCzziCw/p5nkPNk3FLR8LOyTcO
         rDaIsU+YYr0i9dH8tmk2p7PA7AcECs+hVohzUECdiCTJTy6k2+bVCNanbSlZ8cF43jDk
         wJdcsNGRGLlS5enxTubdtYnh70OjKVEaWU3fDEhTiRPydXINJgEl0BTmAGd4CvHz+YFV
         do48DX0aK7MbljMVb+V8Ue3lEOy9t5NVr2oluYurTQdigPALkzmf4Lu2N1MON3t+5B0Y
         if+JIJa4MbfBcmfO+8xuZID1XTdJUaOTa6V+TvXO8SfoIOlzNB8MjbAevX1biFyMrx6U
         csSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=lJqmOoRlMg58C9w6zpz+gG2d8yd5AfUZK1CP6OCQNYY=;
        b=EQIAQx1pI4tjkHaRT1ixwcOKX1e9kgmpumFjjsvEWbcazz6JIIbEBF1TYS3RXQtVoD
         LEBhZO/ftSUKmIilXSLe1SpiZxX7g1ri4TK3b69awINHtOEtSJvZ3x7XV0HLZDdoT5aS
         oy/3fmt0SgV3lbOh3phfH7zm/0brd0qOGcVeJ0nLv2Q5dS4TO7stDOU2cCNJXg5fYrJP
         EJnvBXrvYCn8wKgAzZH7q36J9AOCipMM7+uXPuA4Hv567SaQzvxFh1lb3ATmqT/4Qynp
         rHQy6Z7OfjaOApKowvQSs+E9IaO4EG0WPYZjsPjVE58mV5wPdxif+1ddVInOUbjU5wWc
         oAdQ==
X-Gm-Message-State: AOAM530OEDesWM5S5T84AJqZ6gWYID4iTEWzr3GUUBMTFssoNXp2OrUR
        z6kWvyveN2kZvDjQjXzBTI3gq9L+RNk=
X-Google-Smtp-Source: ABdhPJzBhwMa/qvBUYE8T0uawjO3DW0SG1wfaJ/t7quTTtjsxlUyR4l30L87ST7kClbO9sXVOs0gFw==
X-Received: by 2002:a05:6402:3590:: with SMTP id y16mr39017569edc.343.1639156248801;
        Fri, 10 Dec 2021 09:10:48 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id f17sm1841982edq.39.2021.12.10.09.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:10:48 -0800 (PST)
Message-ID: <61b38a18.1c69fb81.95975.8545@mx.google.com>
X-Google-Original-Message-ID: <YbOKFQlMlNe8rWLf@Ansuel-xps.>
Date:   Fri, 10 Dec 2021 18:10:45 +0100
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210170242.bckpdm2qa6lchbde@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 05:02:42PM +0000, Vladimir Oltean wrote:
> On Fri, Dec 10, 2021 at 04:37:52AM +0100, Ansuel Smith wrote:
> > On Thu, Dec 09, 2021 at 07:39:23PM +0200, Vladimir Oltean wrote:
> > > This patch set is provided solely for review purposes (therefore not to
> > > be applied anywhere) and for Ansuel to test whether they resolve the
> > > slowdown reported here:
> > > https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.7444-1-ansuelsmth@gmail.com/
> > > 
> > > The patches posted here are mainly to offer a consistent
> > > "master_state_change" chain of events to switches, without duplicates,
> > > and always starting with operational=true and ending with
> > > operational=false. This way, drivers should know when they can perform
> > > Ethernet-based register access, and need not care about more than that.
> > > 
> > > Changes in v2:
> > > - dropped some useless patches
> > > - also check master operstate.
> > > 
> > > Vladimir Oltean (4):
> > >   net: dsa: provide switch operations for tracking the master state
> > >   net: dsa: stop updating master MTU from master.c
> > >   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
> > >   net: dsa: replay master state events in
> > >     dsa_tree_{setup,teardown}_master
> > > 
> > >  include/net/dsa.h  | 11 +++++++
> > >  net/dsa/dsa2.c     | 80 +++++++++++++++++++++++++++++++++++++++++++---
> > >  net/dsa/dsa_priv.h | 13 ++++++++
> > >  net/dsa/master.c   | 29 ++---------------
> > >  net/dsa/slave.c    | 27 ++++++++++++++++
> > >  net/dsa/switch.c   | 15 +++++++++
> > >  6 files changed, 145 insertions(+), 30 deletions(-)
> > > 
> > > -- 
> > > 2.25.1
> > > 
> > 
> > Hi, I tested this v2 and I still have 2 ethernet mdio failing on init.
> > I don't think we have other way to track this. Am I wrong?
> > 
> > All works correctly with this and promisc_on_master.
> > If you have other test, feel free to send me other stuff to test.
> > 
> > (I'm starting to think the fail is caused by some delay that the switch
> > require to actually start accepting packet or from the reinit? But I'm
> > not sure... don't know if you notice something from the pcap)
> 
> I've opened the pcap just now. The Ethernet MDIO packets are
> non-standard. When the DSA master receives them, it expects the first 6
> octets to be the MAC DA, because that's the format of an Ethernet frame.
> But the packets have this other format, according to your own writing:
> 
> /* Specific define for in-band MDIO read/write with Ethernet packet */
> #define QCA_HDR_MDIO_SEQ_LEN           4 /* 4 byte for the seq */
> #define QCA_HDR_MDIO_COMMAND_LEN       4 /* 4 byte for the command */
> #define QCA_HDR_MDIO_DATA1_LEN         4 /* First 4 byte for the mdio data */
> #define QCA_HDR_MDIO_HEADER_LEN        (QCA_HDR_MDIO_SEQ_LEN + \
>                                        QCA_HDR_MDIO_COMMAND_LEN + \
>                                        QCA_HDR_MDIO_DATA1_LEN)
> 
> #define QCA_HDR_MDIO_DATA2_LEN         12 /* Other 12 byte for the mdio data */
> #define QCA_HDR_MDIO_PADDING_LEN       34 /* Padding to reach the min Ethernet packet */
> 
> The first 6 octets change like crazy in your pcap. Definitely can't add
> that to the RX filter of the DSA master.
> 
> So yes, promisc_on_master is precisely what you need, it exists for
> situations like this.
> 
> Considering this, I guess it works?

Yes it works! We can totally accept 2 mdio timeout out of a good way to
track the master port. It's probably related to other stuff like switch
delay or other.

Wonder the next step is wait for this to be accepted and then I can
propose a v3 of my patch? Or net-next is closed now and I should just
send v3 RFC saying it does depend on this?

-- 
	Ansuel
