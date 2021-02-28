Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA2E3274FA
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 23:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhB1Wsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 17:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhB1Wss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 17:48:48 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D32C06174A
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 14:48:08 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id f6so2523612edd.12
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 14:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZCGeFsZH83GtKBBYzx45cZC0zr/0BJD6gO7hkTDkN/s=;
        b=SQ2ngMgcxGBS8hJgxxtovb3QXaDAN01Esf3mDZiyLzJN4yMQB5z7j7DwaK55LLpmzc
         LicHc2KQEVSmhRydoCOsQI1PgOSXvxkw98qNnyL0Qe8+iQTKTmYym4v0UkGQS/WRFaje
         fonbwmZ50Z/U7umoF2+QYiOHgYEgVFuEHRESuVcXPJSQ7W6toMO1aapKN02hC7ec+f44
         j5Ugrb7TY9XJNMzuPohHcit1jmXja+r9a6cnTUsLBRlnwQLd8MhxzJZ+tdKDPqg6w9X5
         BS2A/1Sl4HynUNlm0hbraOxzgWEF5K4thAn0gExqqe/cIS50EEF7mwaSh/IVvt6P0fTJ
         5UNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZCGeFsZH83GtKBBYzx45cZC0zr/0BJD6gO7hkTDkN/s=;
        b=Otykx951IkirmvssqvH+eXIf1uYPA6sH6gUdNfvB5/6n7cT+UgpKVlCiwLkAFc1HqV
         EY4FFKUYI3JgrzZynEXLS7mFcWNFYRsoASnNlQ37+gROSvDhrzpmSdIHWf899CK1hxjU
         wNE1PR8x114gwbOqr4WJmR2gET0uz5KTVLPyCsfaFEkveGRYC6MtDg2HLPCn6J+5wCuE
         AiqtVDYpXYUXqN51vB5dJu+2vDVC+Gt8F+EJT/tdDZ8qSyS1bDXdMhUCjOlV5qLpzJEo
         FeaPViSh+OynCbodjeqOjk92fj1rCZL19CREGJzW5X/C0sjdXhp/QA0xF5abGLTft+Nd
         tHBg==
X-Gm-Message-State: AOAM530/yKgrE8Tnkbi5vVpndvAkrETRnkPdxiGPBPim+gG5QQ76a7SW
        1KF48ySI1EzVj5W7HkXRkEPQTnf5A8E=
X-Google-Smtp-Source: ABdhPJzc7a1mKtdWRsCf1Y6JxcBy4QCSVjhNka7fyW6uRDyGvmHi7iTj0SYN1aNT4us2wlByBimtew==
X-Received: by 2002:aa7:c1d5:: with SMTP id d21mr208695edp.167.1614552486773;
        Sun, 28 Feb 2021 14:48:06 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id x21sm11393117eje.118.2021.02.28.14.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:48:06 -0800 (PST)
Date:   Mon, 1 Mar 2021 00:48:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Markus =?utf-8?Q?Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
Message-ID: <20210228224804.2zpenxrkh5vv45ph@skbuf>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-6-olteanv@gmail.com>
 <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210226234244.w7xw7qnpo3skdseb@skbuf>
 <20210226154922.5956512b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210227001651.geuv4pt2bxkzuz5d@skbuf>
 <7bb61f7190bebadb9b6281cb02fa103d@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bb61f7190bebadb9b6281cb02fa103d@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 27, 2021 at 02:18:20PM +0100, Michael Walle wrote:
> Am 2021-02-27 01:16, schrieb Vladimir Oltean:
> > On Fri, Feb 26, 2021 at 03:49:22PM -0800, Jakub Kicinski wrote:
> > > On Sat, 27 Feb 2021 01:42:44 +0200 Vladimir Oltean wrote:
> > > > On Fri, Feb 26, 2021 at 03:28:36PM -0800, Jakub Kicinski wrote:
> > > > > I don't understand what you're fixing tho.
> > > > >
> > > > > Are we trying to establish vlan-filter-on as the expected behavior?
> > > >
> > > > What I'm fixing is unexpected behavior, according to the applicable
> > > > standards I could find.
>
> In the referenced thread you quoted from the IEEE802.3 about the promisc
> mode.
>   The MAC sublayer may also provide the capability of operating in the
>   promiscuous receive mode. In this mode of operation, the MAC sublayer
>   recognizes and accepts all valid frames, regardless of their Destination
>   Address field values.
>
> Your argument was that the standard just talks about disabling the DMAC
> filter. But was that really the _intention_ of the standard? Does the
> standard even mention a possible vlan tag? What I mean is: maybe the
> standard just mention the DMAC because it is the only filtering mechanism
> in this standard and it's enough to disable it to "accept all valid frames".
>
> I was biten by "the NIC drops frames with an unknown VLAN" even if
> promisc mode was enabled. And IMHO it was quite suprising for me.

In short, promiscuity is a function of the MAC sublayer, which is the
lower portion of the Data Link Layer (the higher portion being the
Logical Link Control layer - LLC). The MAC sublayer is governed by IEEE
802.3, and IEEE 802.1Q does not change anything related to promiscuity,
so everything still applies.

The MAC sublayer provides its services to the MAC client through
something called the MAC service, which uses the following primitives:

MA_DATA.request(
	destination_address,
	source_address,
	mac_service_data_unit,
	frame_check_sequence)

to send a frame, and

MA_DATA.indication(
	destination_address,
	source_address,
	mac_service_data_unit,
	frame_check_sequence,
	ReceiveStatus)

to receive a frame.

One particular component of the MAC sublayer seems to be called the
Internal Sublayer Service (ISS), and this one is defined in IEEE
802.1AC-2016. To be frank, I don't quite grok why there needs to exist
this extra layering, but nonetheless, the ISS has some similar service
primitives to the MAC sublayer as well, and these are:

M_UNITDATA.indication(
	destination_address,
	source_address,
	mac_service_data_unit,
	priority,
	drop_eligible,
	frame_check_sequence,
	service_access_point_identifier,
	connection_identifier)

M_UNITDATA.request(
	destination_address,
	source_address,
	mac_service_data_unit,
	priority,
	drop_eligible,
	frame_check_sequence,
	service_access_point_identifier,
	connection_identifier)

where a "unit of data" is basically just very pompous speak for
"a frame", I guess.

Promiscuity is defined in IEEE 802.3 clause 4A.2.9 Frame reception,
which _in_context_ talks about the interface between the MAC client and
the MAC sublayer, so that means about the M_UNITDATA.indication or the
MA_DATA.indication.

Whereas VLAN filtering, as well as adding and removing VLAN tags, is
governed by IEEE 802.1Q, as a function of the Enhanced Internal Sublayer
Service (EISS), i.e. clause 6.8. In fact, the EISS is just an ISS
enhanced for VLAN filtering, as the naming and definition implies.

Of course (why not), the EISS has its own service primitives towards its
higher-level clients for transmitting and receiving a frame. These are:

EM_UNITDATA.request(
	destination_address,
	source_address,
	mac_service_data_unit,
	priority,
	drop_eligible,
	vlan_identifier,
	frame_check_sequence,
	service_access_point_identifier,
	connection_identifier,
	flow_hash,
	time_to_live)

EM_UNITDATA.indication(
	destination_address,
	source_address,
	mac_service_data_unit,
	priority,
	drop_eligible,
	vlan_identifier,
	frame_check_sequence,
	service_access_point_identifier,
	connection_identifier,
	flow_hash,
	time_to_live)

There's a big note in IEEE 802.1Q that says:

The destination_address, source_address, mac_service_data_unit,
priority, drop_eligible, service_access_point_identifier,
connection_identifier, and frame_check_sequence parameters are as
defined for the ISS.

So basically, although the EISS extends the ISS, it has not changed the
aspects of it regarding what constitutes a destination_address. So there
is nothing that redefines the promiscuity concept to extend it with the
vlan_identifier.

Additionally, the 802.1Q spec talks about this EISS Multiplex Entity
thing, which can be used by a VLAN-aware end station to provide a SAP
(Service Access Point, in context it means an instance of the Internal
Sublayer Service), one per VID of interest, to separate MAC clients.
That is to say, the EISS Multiplex Entity provides multiple
M_UNITDATA.indication and M_UNITDATA.request services to multiple MAC
clients, one per VLAN. Each individual service can be in "promiscuous"
mode. This is similar to how in Linux, each 8021q upper of a physical
interface can be promiscuous or not.

> > > > If I don't mark this change as a bug fix but as
> > > > a simple patch, somebody could claim it's a regression, since promiscuity
> > > > used to be enough to see packets with unknown VLANs, and now it no
> > > > longer is...
> > >
> > > Can we take it into net-next? What's your feeling on that option?
> >
> > I see how you can view this patch as pointless, but there is some
> > context to it. It isn't just for tcpdump/debugging, instead NXP has some
> > TSN use cases which involve some asymmetric tc-vlan rules, which is how
> > I arrived at this topic in the first place. I've already established
> > that tc-vlan only works with ethtool -K eth0 rx-vlan-filter off:
> > https://lore.kernel.org/netdev/CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com/
>
> Wasn't the conclusion that the VID should be added to the filter so it
> also works with vlan filter enabled? Am I missing another discussion?

Well, the conclusion was just that a tc-flower key that contains a VLAN
ID will not be accepted by a VLAN-filtering NIC. Similarly, a tc-flower
key that contains a destination MAC address will not be accepted by a
NIC with IFF_UNICAST_FLT.

There was no further discussion, it is just an elementary deduction from
that point. There are two equally valid options:
- make tc-flower use the vlan_vid_add API when it installs a vlan_id
  key, and the dev_uc_add/dev_mc_add API when it installs a dst_mac key
OR
- disable VLAN filtering if you're using vlan_id keys on VLAN-aware
  NICs, and put the interface in promiscuous mode if you're using
  dst_mac keys that are different from the NIC's filtering list.

I chose option 2 because it was way simpler and was just as correct.
