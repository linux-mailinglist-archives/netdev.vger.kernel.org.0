Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FC0474E98
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbhLNXeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbhLNXeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 18:34:24 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2151C061574;
        Tue, 14 Dec 2021 15:34:23 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v1so68903993edx.2;
        Tue, 14 Dec 2021 15:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=uZGukkBweIo5gn1bnPy0Us16OfUUmARfBRhy9r6jxjE=;
        b=hYhopJj51UGRybxT1Lgbi03Pfs3dy2jUQeLKUpciJU9Q7yIbZ39xCejQUwTBLAKuEX
         aNyccVLSE4bRhR28Hb/bk0HbnrrDGUfK46Zf2x8gQ5kfSNkkemn3TcxGP+k2WE659/an
         RnKfmLSB+eYRO1wiCgA1if0QRo1R/eCQOeKHEEbAH98uHJCMFR9pQ619Iu3W6xgChnMV
         l7R4cRzpgzvK91zg9ZEvD+O4/an+I0UcyZONmWe+lJhsKnVwusZcnNKYJssGwJBjWxtu
         AhgtOJ+b+ufAh+DvUPsqMIPLjR5JGFjd1/Zug7ywHpDUY6+rWmrAryABhq1zq/BSuCYB
         wIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=uZGukkBweIo5gn1bnPy0Us16OfUUmARfBRhy9r6jxjE=;
        b=8M8DINFZcCzZlUmHJyrHdBRNqj1rocSOBuoYe/AhHMTlMo4ZoQN43Uun3fTnKkDZ6w
         XWFd+qDlemiGFBe7/Og3wjQUMvV082gC14KFb1XnWRs6N0MiHkpBrEo4LbWBERf1s0a3
         j/PZpOIh/1/ckCeTHljqDf+evlJNQaVDuVWjsfFKGzkvmMiZ72MVZR7xUUxuRgFFbNny
         hYcISc+zPnsXMqRDneXdbGvmEMzfPe6ABSP6Ho0chwVYq333Dtv/nBIGwUqhOYA2VQK9
         jNDpFJ2COaHyABDEntSaqvokGm31NLDhUqmPhz07xiWHkDasJGd9PSgQyFrO9WjHWDiM
         Vn1Q==
X-Gm-Message-State: AOAM533qB9IaqmNc1Eji3ocnEokHw9OFhsKGc8WBsPtcL0q9ZOb7wHCT
        J7CzrtQlbb+/1HTRAHRZ1clDx9+12yFeAA==
X-Google-Smtp-Source: ABdhPJxT9+KtU9KafrNMgNKpVuD2rg7QBo4azy94A6JyappSLWP/2WfO7eix4xXtE4Bp5m+KNMkRuw==
X-Received: by 2002:a17:906:9746:: with SMTP id o6mr8544335ejy.747.1639524862005;
        Tue, 14 Dec 2021 15:34:22 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id g14sm89451edq.86.2021.12.14.15.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 15:34:21 -0800 (PST)
Message-ID: <61b929fd.1c69fb81.53d58.0735@mx.google.com>
X-Google-Original-Message-ID: <Ybkp+ZpFE9id66U2@Ansuel-xps.>
Date:   Wed, 15 Dec 2021 00:34:17 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH RFC v6 00/16] Add support for qca8k mdio rw in
 Ethernet packet
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214224409.5770-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:43:53PM +0100, Ansuel Smith wrote:
> Hi, this is ready but require some additional test on a wider userbase.
> 
> The main reason for this is that we notice some routing problem in the
> switch and it seems assisted learning is needed. Considering mdio is
> quite slow due to the indirect write using this Ethernet alternative way
> seems to be quicker.
> 
> The qca8k switch supports a special way to pass mdio read/write request
> using specially crafted Ethernet packet.
> This works by putting some defined data in the Ethernet header where the
> mac source and dst should be placed. The Ethernet type header is set to qca
> header and is set to a mdio read/write type.
> This is used to communicate to the switch that this is a special packet
> and should be parsed differently.
> 
> Currently we use Ethernet packet for
> - MIB counter
> - mdio read/write configuration
> - phy read/write for each port
> 
> Current implementation of this use completion API to wait for the packet
> to be processed by the tagger and has a timeout that fallback to the
> legacy mdio way and mutex to enforce one transaction at time.
> 
> We now have connect()/disconnect() ops for the tagger. They are used to
> allocate priv data in the dsa priv. The header still has to be put in
> global include to make it usable by a dsa driver.
> They are called when the tag is connect to the dst and the data is freed
> using discconect on tagger change.
> 
> (if someone wonder why the bind function is put at in the general setup
> function it's because tag is set in the cpu port where the notifier is
> still not available and we require the notifier to sen the
> tag_proto_connect() event.
> 
> We now have a tag_proto_connect() for the dsa driver used to put
> additional data in the tagger priv (that is actually the dsa priv).
> This is called using a switch event DSA_NOTIFIER_TAG_PROTO_CONNECT.
> Current use for this is adding handler for the Ethernet packet to keep
> the tagger code as dumb as possible.
> 
> The tagger priv implement only the handler for the special packet. All the
> other stuff is placed in the qca8k_priv and the tagger has to access
> it under lock.
> 
> We use the new API from Vladimir to track if the master port is
> operational or not. We had to track many thing to reach a usable state.
> Checking if the port is UP is not enough and tracking a NETDEV_CHANGE is
> also not enough since it use also for other task. The correct way was
> both track for interface UP and if a qdisc was assigned to the
> interface. That tells us the port (and the tagger indirectly) is ready
> to accept and process packet.
> 
> I tested this with multicpu port and with port6 set as the unique port and
> it's sad.
> It seems they implemented this feature in a bad way and this is only
> supported with cpu port0. When cpu port6 is the unique port, the switch
> doesn't send ack packet. With multicpu port, packet ack are not duplicated
> and only cpu port0 sends them. This is the same for the MIB counter.
> For this reason this feature is enabled only when cpu port0 is enabled and
> operational.
> 
> Current concern are:
> - Any hint about the naming? Is calling this mdio Ethernet correct?
>   Should we use a more ""standard""/significant name? (considering also
>   other switch will implement this)
> 
> v6:
> - Fix some error in ethtool handler caused by rebase/cleanup
> v5:
> - Adapt to new API fixes
> - Fix a wrong logic for noop
> - Add additional lock for master_state change
> - Limit mdio Ethernet to cpu port0 (switch limitation)
> - Add priority to these special packet
> - Move mdio cache to qca8k_priv
> v4:
> - Remove duplicate patch sent by mistake.
> v3:
> - Include MIB with Ethernet packet.
> - Include phy read/write with Ethernet packet.
> - Reorganize code with new API.
> - Introuce master tracking by Vladimir
> v2:
> - Address all suggestion from Vladimir.
>   Try to generilize this with connect/disconnect function from the
>   tagger and tag_proto_connect for the driver.
> 
> Ansuel Smith (12):
>   net: dsa: tag_qca: convert to FIELD macro
>   net: dsa: tag_qca: move define to include linux/dsa
>   net: dsa: tag_qca: enable promisc_on_master flag
>   net: dsa: tag_qca: add define for handling mdio Ethernet packet
>   net: dsa: tag_qca: add define for handling MIB packet
>   net: dsa: tag_qca: add support for handling mdio Ethernet and MIB
>     packet
>   net: dsa: qca8k: add tracking state of master port
>   net: dsa: qca8k: add support for mdio read/write in Ethernet packet
>   net: dsa: qca8k: add support for mib autocast in Ethernet packet
>   net: dsa: qca8k: add support for phy read/write with mdio Ethernet
>   net: dsa: qca8k: move page cache to driver priv
>   net: dsa: qca8k: cache lo and hi for mdio write
> 
> Vladimir Oltean (4):
>   net: dsa: provide switch operations for tracking the master state
>   net: dsa: stop updating master MTU from master.c
>   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
>   net: dsa: replay master state events in
>     dsa_tree_{setup,teardown}_master
> 
>  drivers/net/dsa/qca8k.c     | 600 ++++++++++++++++++++++++++++++++++--
>  drivers/net/dsa/qca8k.h     |  46 ++-
>  include/linux/dsa/tag_qca.h |  79 +++++
>  include/net/dsa.h           |  17 +
>  net/dsa/dsa2.c              |  81 ++++-
>  net/dsa/dsa_priv.h          |  13 +
>  net/dsa/master.c            |  29 +-
>  net/dsa/slave.c             |  32 ++
>  net/dsa/switch.c            |  15 +
>  net/dsa/tag_qca.c           |  81 +++--
>  10 files changed, 901 insertions(+), 92 deletions(-)
>  create mode 100644 include/linux/dsa/tag_qca.h
> 
> -- 
> 2.33.1
> 

I just tested if the Documentation is correct about this alternative way
being able to read/write 16byte of data at times (instead of 4).

I confirm this work but I need to understand how and if this can be
used. I can see I should use the regmap bulk api... But I assume I
should change the val_bits. (think that is not acceptable if regmap is
already init and would be problematic for the fallback...)

Wonder if I should register a separate regmap for eth and use that...
(and create an helper to switch between the mdio and the ethernet one?)

This would be very useful for fib read/write that require 4 read/write
to put data in the db. (1 lock, 1 packet instead of 4 lock 4 packet)

Would love any hint if we have other way to handle this but I think the
double regmap and the helper seems to be the cleaner way for this.

(obviously this will come later and won't be part of this already big
patch)

-- 
	Ansuel
