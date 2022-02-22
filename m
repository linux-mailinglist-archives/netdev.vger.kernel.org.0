Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435114BFFFD
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbiBVRSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234604AbiBVRSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:18:40 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC47A164D18
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:18:14 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id q17so38806819edd.4
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zwvy2SnmnpxbyZJ3Sx/ziiTTJOpmKCZsngzsb8WkQ9g=;
        b=QXJGssc4fYFBc4lPcFJ+HkeRYU1+9nVbBFcJY3zJDsWb9Ao3IOM5Op7o7bb8EYshN9
         Tf0hm8LRnFl8BvyFHuscXBHoUlPy6u4dRKX85TH+3aV3QcH9ItehLCu2hl7KD11AZ9LI
         6qSjoWP4mwlx7rzy3Vdbt0gg1fB+Jb4C9iXiYtXzIlmAblINDdZTpqDPnPR/2uih33G9
         R4zde5EjI1qFS8aN7avFs4s/vPFK9eboLLOoL1vCNnyMXglr5YpLjZ5BF6w1Ulj1404D
         uheCQgmMIStrVNJvRp/IEtsRFs8l1StEIWNTnzzV2rmHVRnvLQzAviO8sEpWX0iOBkU9
         TLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zwvy2SnmnpxbyZJ3Sx/ziiTTJOpmKCZsngzsb8WkQ9g=;
        b=gM4tloc6uNzVgUpsXCyW8w3cR9AH9840gKvEP4WqSm+n+X6JA7JWK3D4fx5Y4PIj7E
         UdrWtF3pzV3yBfPqgxmvSfu6XCB1TvbZXCi1UkRTI6Xp67aY87hLR+NZrGmF/31Wv0nN
         tQ3BtTiYqVOIdzy2lFkXGylJavPF3O3RiQUHh++K5aR0Gs46BOp3F4Yv9WPmUGeQuw8n
         6OoJ3SjYoaD2miwU3NXPmc6K6DWJdIL66SlPY/YDHG0YgQ8Pze4TYGIb6qrtVz/d0qvq
         lV3PCUdHwXifJsCGGG47TeLg64JhZCyaUrgQAe3AS9/z6Q6eVu5G9Psn9R6dbylq1l/C
         ZLRQ==
X-Gm-Message-State: AOAM531n7KZLmhO4SDm9+Cedo1CUqByS/gDgTmkBUCZcZxvgPhETmwTF
        2xVeK76Tn/nk6XIGwNTlYH0=
X-Google-Smtp-Source: ABdhPJz3So2YiYElNC1aGPxEKncR+8L7AiiNQMwd8j5y4+qaYMej2n4r3ly2R489/q0uo4+QYPCLOg==
X-Received: by 2002:a50:fd16:0:b0:410:82ea:7911 with SMTP id i22-20020a50fd16000000b0041082ea7911mr27108995eds.315.1645550293189;
        Tue, 22 Feb 2022 09:18:13 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id u19sm6561848ejy.171.2022.02.22.09.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 09:18:12 -0800 (PST)
Date:   Tue, 22 Feb 2022 19:18:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [RFC PATCH v2 net-next 05/17] net: bridge: implement unicast
 filtering for the bridge device
Message-ID: <20220222171810.bpoddx7op3rivenm@skbuf>
References: <20210224114350.2791260-1-olteanv@gmail.com>
 <20210224114350.2791260-6-olteanv@gmail.com>
 <YD0GyJfbhqpPjhVd@shredder.lan>
 <CA+h21hrtnXr11VXsRXokkZHQ3AQ8nNCLsWTC4ztoLMmNmQoxxg@mail.gmail.com>
 <YhUVNc58trg+r3V9@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhUVNc58trg+r3V9@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 06:54:13PM +0200, Ido Schimmel wrote:
> On Tue, Feb 22, 2022 at 01:21:53PM +0200, Vladimir Oltean wrote:
> > Hi Ido,
> > 
> > On Mon, 1 Mar 2021 at 17:22, Ido Schimmel <idosch@idosch.org> wrote:
> > >
> > > On Wed, Feb 24, 2021 at 01:43:38PM +0200, Vladimir Oltean wrote:
> > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > > The bridge device currently goes into promiscuous mode when it has an
> > > > upper with a different MAC address than itself. But it could do better:
> > > > it could sync the MAC addresses of its uppers to the software FDB, as
> > > > local entries pointing to the bridge itself. This is compatible with
> > > > switchdev, since drivers are now instructed to trap these MAC addresses
> > > > to the CPU.
> > > >
> > > > Note that the dev_uc_add API does not propagate VLAN ID, so this only
> > > > works for VLAN-unaware bridges.
> > >
> > > IOW, it breaks VLAN-aware bridges...
> > >
> > > I understand that you do not want to track bridge uppers, but once you
> > > look beyond L2 you will need to do it anyway.
> > >
> > > Currently, you only care about getting packets with specific DMACs to
> > > the CPU. With L3 offload you will need to send these packets to your
> > > router block instead and track other attributes of these uppers such as
> > > their MTU so that the hardware will know to generate MTU exceptions. In
> > > addition, the hardware needs to know the MAC addresses of these uppers
> > > so that it will rewrite the SMAC of forwarded packets.
> > 
> > Ok, let's say I want to track bridge uppers. How can I track the changes to
> > those interfaces' secondary addresses, in a way that keeps the association
> > with their VLAN ID, if those uppers are VLAN interfaces?
> 
> Hi,
> 
> I'm not sure what you mean by "secondary addresses", but the canonical
> way that I'm familiar with of adding MAC addresses to a netdev is to use
> macvlan uppers. For example:
> 
> # ip link add name br0 up type bridge vlan_filtering 1
> # ip link add link br0 name br0.10 type vlan id 10
> # ip link add link br0.10 name br0.10-v address 00:11:22:33:44:55 type macvlan mode private
> 
> keepalived uses it in VRRP virtual MAC mode (for example):
> https://github.com/acassen/keepalived/blob/master/doc/NOTE_vrrp_vmac.txt
> 
> In the software data path, this will result in br0 transitioning to
> promisc mode and passing all the packets to upper devices that will
> filter them.
> 
> In the hardware data path, you can apply promisc mode by flooding to
> your CPU port (I believe this is what you are trying to avoid) or
> install an FDB entry <00:11:22:33:44:55,10> that points to your CPU
> port.

Maybe the terminology is not the best, but by secondary addresses I mean
struct net_device :: uc and mc. To my knowledge, the MAC address of
vlan/macvlan uppers is not the only way in which these lists can be
populated. There is also AF_PACKET UAPI for PACKET_MR_MULTICAST and
PACKET_MR_UNICAST, and this ends up calling dev_mc_add() and
dev_uc_add(). User space may use this API to add a secondary address to
a VLAN upper interface of a bridge.

The question was how can the bridge get notified of changes to those 2
lists of its upper interfaces?

If it monitors NETDEV_CHANGEUPPER it has access to those lists only when
an upper joins or leaves.
If it monitors NETDEV_CHANGEADDR, it gets notified only to changes on
the primary addresses of the uppers (dev_addr and dev_addrs).
If it implements ndo_set_rx_mode (this patch), it has all the addresses
synced to it, but they lack a VLAN ID, because every address lacks
further information about which device added it.

If there's logic in the mlxsw driver that does this, unfortunately I
haven't found it.
