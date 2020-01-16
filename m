Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D26BF13DDBE
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgAPOnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:43:03 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40605 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgAPOnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 09:43:02 -0500
Received: by mail-pl1-f194.google.com with SMTP id s21so8406885plr.7
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 06:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=greyhouse-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=BnkfENlj/NWFL5LsjWpkCCVtvDOh/0c8F8zhP++fGFc=;
        b=Rh70rYH8N0zyb156RIWtC67c3yDdEuJW8/lre65xCsFGxS7Zy1NdJN7AR/SCw8Chqf
         7VEbAZAE2wFb6vfypGY7aD4KZwGDQ/Gnqk28NBkkDpU4PQhP/JRKmejjl8xKQ8vgmNjf
         MwCGQgrkRazu5bjwzGur8gZ5yMVJ0I1w5YMCKJmMYlxb9/zAy/ftsSKNH1xusbHPw7Lf
         K79hgq2gyad56Q3nLpl1FqT6kLkzKv6Bg+xII/0CkLSwicqDRxYVqxHjbdnHM8I6TsjZ
         YhRol9gvRtRH7lZigSMJ7+mGLidMMVM8Ow/8xtQSmkqYNJ8fqEMs9WnAG/Kr5cZuziFo
         g1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=BnkfENlj/NWFL5LsjWpkCCVtvDOh/0c8F8zhP++fGFc=;
        b=FBnGanOwBpX31BhzUXxu1wTA2JqT80mZD9luKFWcQWaKMm454ECw+/q0WoN5cQl6rI
         DSfuJI9+uxw1LzCfOpDDyCFa6V3Iz3r1kaX8SJzr4bNfcZXYIpLTBjNNSmDW8dg2+KWI
         G0nY6wNR25iGvpKfDjhkpNSemqW2Sf2CxD+/r0GPamDMs2Yf0HFi1v59I6H1/dS7znxZ
         tNFvbD0amqY5l0OrKBbyOYaOxb4WJ58ULkwF6QAx/2zHdGsuNrFSjOjlwxNnzAtmSAd1
         jHYiD6PgIT+2DFT7J1GwMJuC4kTj9b3vbeSydqiZv6fGEa+sWeWNBuQRiWB+AxdAmeIV
         zE4A==
X-Gm-Message-State: APjAAAUkIZn9Z0UTyH1RoRpUmlwK6CRFQBCYhDabUFg5z5atSNnDO/bJ
        F55zeODUV2B+G3r3shvuxvDQXw==
X-Google-Smtp-Source: APXvYqwzaskrQrzAoN2IFl6BioVNDyvnwWocuX1HhidXryeQee6VKGzKjx8Ec4UNbZ30gWDIpPITZA==
X-Received: by 2002:a17:90b:4398:: with SMTP id in24mr7284448pjb.29.1579185782044;
        Thu, 16 Jan 2020 06:43:02 -0800 (PST)
Received: from C02YVCJELVCG ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id r14sm25222748pfh.10.2020.01.16.06.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 06:43:00 -0800 (PST)
Date:   Thu, 16 Jan 2020 09:42:56 -0500
From:   Andy Gospodarek <andy@greyhouse.net>
To:     Jiri Pirko <jiri@resnulli.us>, Maor Gottlieb <maorg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: Expose bond_xmit_hash function
Message-ID: <20200116144256.GA87583@C02YVCJELVCG>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
 <20200115094513.GS2131@nanopsycho>
 <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
 <20200115141535.GT2131@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200115141535.GT2131@nanopsycho>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 03:15:35PM +0100, Jiri Pirko wrote:
> Wed, Jan 15, 2020 at 02:04:49PM CET, maorg@mellanox.com wrote:
> >
> >On 1/15/2020 11:45 AM, Jiri Pirko wrote:
> >> Wed, Jan 15, 2020 at 09:01:43AM CET, maorg@mellanox.com wrote:
> >>> RDMA over Converged Ethernet (RoCE) is a standard protocol which enables
> >>> RDMA’s efficient data transfer over Ethernet networks allowing transport
> >>> offload with hardware RDMA engine implementation.
> >>> The RoCE v2 protocol exists on top of either the UDP/IPv4 or the
> >>> UDP/IPv6 protocol:
> >>>
> >>> --------------------------------------------------------------
> >>> | L2 | L3 | UDP |IB BTH | Payload| ICRC | FCS |
> >>> --------------------------------------------------------------
> >>>
> >>> When a bond LAG netdev is in use, we would like to have the same hash
> >>> result for RoCE packets as any other UDP packets, for this purpose we
> >>> need to expose the bond_xmit_hash function to external modules.
> >>> If no objection, I will push a patch that export this symbol.
> >> I don't think it is good idea to do it. It is an internal bond function.
> >> it even accepts "struct bonding *bond". Do you plan to push netdev
> >> struct as an arg instead? What about team? What about OVS bonding?
> >
> >No, I am planning to pass the bond struct as an arg. Currently, team 
> 
> Hmm, that would be ofcourse wrong, as it is internal bonding driver
> structure.
> 
> 
> >bonding is not supported in RoCE LAG and I don't see how OVS is related.
> 
> Should work for all. OVS is related in a sense that you can do bonding
> there too.
> 
> 
> >
> >>
> >> Also, you don't really need a hash, you need a slave that is going to be
> >> used for a packet xmit.
> >>
> >> I think this could work in a generic way:
> >>
> >> struct net_device *master_xmit_slave_get(struct net_device *master_dev,
> >> 					 struct sk_buff *skb);
> >
> >The suggestion is to put this function in the bond driver and call it 
> >instead of bond_xmit_hash? is it still necessary if I have the bond pointer?
> 
> No. This should be in a generic code. No direct calls down to bonding
> driver please. Or do you want to load bonding module every time your
> module loads?
> 
> I thinks this can be implemented with ndo with "master_xmit_slave_get()"
> as a wrapper. Masters that support this would just implement the ndo.

In general I think this is a good idea (though maybe not with an skb as
an arg so we can use it easily within BPF), but I'm not sure if solves
the problem that Maor et al were setting out to solve.

Maor, if you did export bond_xmit_hash() to be used by another driver,
you would presumably have a check in place so if the RoCE and UDP
packets had a different hash function output you would make a change and
be sure that the UDP frames would go out on the same device that the
RoCE traffic would normally use.  Is this correct?  Would you also send
the frames directly on the interface using dev_queue_xmit() and bypass
the bonding driver completely?

I don't think I fundamentally have a problem with this, I just want to
make sure I understand your proposed code-flow.

Thanks!

