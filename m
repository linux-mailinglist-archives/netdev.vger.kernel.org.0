Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5144FBDE6
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346800AbiDKN5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346754AbiDKN5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:57:49 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10551E3E5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:55:34 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id k23so31033412ejd.3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qqtenZckfiTITPhBrUh2ZbNLreazLJYuT01BKr682xA=;
        b=n14yiL5Rbu8zEeFVppawimqThutPl4ZybXyOjl232lqIE8ms4jjV+gy0KGOlpk1px/
         O0Ll2CJAsM4CxpMtRJcrS9vZaJZsSwfOhA9mB8mWdnJVBt9YU93inMQ9fjk7EgHNFuCZ
         hZYElqhStm/plnohn9q58ngNdJ7waUn22p+wMwGXdAO142UaCPIYcJcXqL8caLGBoCtc
         vtYvIC/UohCSctKlNrpiSlR+e/N5k2PL5xM+MThn4IcpTlTAq7vc7t48/PbgQy62XyzS
         VZVuOVnwlRU/yZHmrr+EOuecDsQ6s39rHHxG4l+UqDVS7npl5uVN1fpCvdaPdexmV4Lf
         AChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qqtenZckfiTITPhBrUh2ZbNLreazLJYuT01BKr682xA=;
        b=fz6brAaAKxfadNKRj50Bvh8QYVTFtwov2bxh4CtICVURNqNwyasim4wQxgzIzlqmv0
         uh1jEu/tVYJSZRPQaFh9O73uG1Xsq5ZcMBleNDtZBNfbeCAofd2dkuwOFS/cfnW9gnqG
         bxZ8bR1QeU/L6vfGPK2FqQvRGb+T/t6eNTOA3zn0hHSUszN5Z249IpqjVMRuOa0gbYcT
         31A6lNnWVBj4ZZJ3iBmjluuF8+j0FUYUQwg5deEX/8SW4moTzG5fP5aTmRA8C4tJUFic
         MkM+OQX+9yLDfWgAb6hI6A1hD18ocL26HfRaP/4SQjx93wQppkrWSfAAVZAgja1qT0Z2
         h22Q==
X-Gm-Message-State: AOAM533bgBTM06N2Ql+i3i2OAa41+PmLmqKUy19mjihY15v4C7k8tXtF
        oYZPsZqXWq8I+WF4Tn8nz6cxWZ1kOes=
X-Google-Smtp-Source: ABdhPJxKsY25Oyf/BteLsHgpuEP4QBejDrfv4PcsRw9GQEf3oWLYP80Nbvfhi1iqPBLvEcEp/rfKQQ==
X-Received: by 2002:a17:907:3fa6:b0:6e8:a222:3ba1 with SMTP id hr38-20020a1709073fa600b006e8a2223ba1mr1548303ejc.461.1649685332993;
        Mon, 11 Apr 2022 06:55:32 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id g2-20020a50bf42000000b0041cc5233252sm12138871edk.57.2022.04.11.06.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:55:32 -0700 (PDT)
Date:   Mon, 11 Apr 2022 16:55:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: Re: [PATCH net-next 0/6] Disable host flooding for DSA ports under a
 bridge
Message-ID: <20220411135530.2nu4rlofyd6nphb2@skbuf>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
 <877d7yhwep.fsf@waldekranz.com>
 <20220409204557.4ul4ohf3tjtb37dx@skbuf>
 <8735ikizq2.fsf@waldekranz.com>
 <20220410220324.4c3l3idubwi3w6if@skbuf>
 <87zgksge17.fsf@waldekranz.com>
 <20220411105534.rkwicu6skd3v37qu@skbuf>
 <87wnfvhidq.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wnfvhidq.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 03:14:25PM +0200, Tobias Waldekranz wrote:
> > The station attached to that bridge port *receives* it. You as a bridge
> > cannot control whether that station will actually *receive* it.
> > That is the analogy with the bridge device as a bridge port.
> > BR_MCAST_FLOOD may decide whether the forwarding plane sends the flow to
> > the bridge, but the bridge's RX filter still needs to decide whether it
> > accepts it.
> 
> So in br_pass_frame_up we would have a separate validation of whether
> the DA matches the termination plane's Rx filter or not? That makes
> sense.

Yes, I know it would make sense. It's also not possible without
introducing regressions (the bridge currently being able to receive
unknown multicast without IFF_ALLMULTI sounds like a big roadblock).
It also introduces questions about whether user space and upper
interfaces need to be aware that the termination plane is not the only
thing they need to configure.

> > For practical reasons (unicast traffic has a single destination), we may
> > mirror that address by installing it to the FDB as a local entry. And
> > maybe we could get away with that.
> 
> More than getting away with it, I would argue that it's the Right
> Thing™. Station addresses on an Ethernet segment must be unique, so if
> we know a station's location (by any means) then by definition it can
> only be in that location.

Actually, you said it yourself that IFF_PROMISC creates a second copy of
a forwarded known unicast packet, on which it calls br_pass_frame_up().
Think of dev_uc_add() as the IFF_PROMISC behavior applied to a single
unicast MAC DA, as opposed to all MAC DAs. You can't add a local FDB
entry *and* be consistent with bridge IFF_PROMISC behavior.

> > But for multicast RX filters, when an entry would get added to dev->mc,
> > but that same multicast MAC address is absent from the MDB, we can't
> > really do much about adding it to the MDB either, because this would
> > transform the flow from being unregistered to being registered towards
> > the CPU, so stations that used to see this flow via flooding will no
> > longer see it.
> 
> Yes, multicast is much more tricky. For IP multicast, I think this
> already works because an IP_ADD_MEMBERSHIP will cause the kernel to
> generate an IGMP/MLD report which can be snooped by the bridge and an
> entry installed in the MDB.

Happy coincidence, because IP_ADD_MEMBERSHIP will eventually call
ip_mc_filter_add() -> dev_mc_add() and this will update the RX filter of
the bridge. And the multicast snooping code will update the forwarding
plane. I wonder if there's something similar to take away from this
w.r.t. unicast behavior. Like for example the bridge driver could do
dynamic address learning for locally originated traffic, and the
forwarding and termination planes would be once again in sync with no
need for higher layers to know about the distinction anyway. At least
for a while, until the entry ages out.

> We can do the same with L2 multicast by having a PACKET_ADD_MEMBERSHIP
> trigger an MMRP message, and then implement MMRP in the bridge.
> 
> So as an administrator, for L2 and L3 multicast, you have two choices:
> 
> 1. Enable the relevant control protocol (MMRP, or IGMP/MLD). In this
>    case you can get better filtering because we can load the multicast
>    address list into the MDB. The trade-off is that all group listeners
>    must speak the control protocol.
> 
> 2. Disable the control protocol. The address lists will be ignored by
>    the bridge, and you rely on flooding to distribute the traffic to
>    where it needs to get. This will work for stations that can't take
>    part in the control protocol.
> 
> There are also variations of (1) where you can help legacy devices by
> either marking the ports as permanent router ports or by adding static
> entries to the MDB.
> 
> > So much for our implementation of a mirror via the FDB/MDB, we'd instead
> > have to add actual mirroring logic of individual addresses, without
> > touching the FDB/MDB. Then have a way to offload those mirrors. And that
> > would be for the sake of correctness.
> >
> > In terms of usability in the context of dev_uc_add() and dev_mc_add()
> > though, that isn't really sane and just caters to the naive view that
> > "tcpdump should see everything after it sets IFF_PROMISC". Because when
> > a macvlan becomes an upper of the bridge, dev_uc_add() is what it'll
> > call, and this won't stop the bridge from flooding packets towards the
> > macvlan's MAC DA towards the network. It will just ensure that the
> > macvlan is copied to the traffic destined towards it, too.
> >
> > I maybe agree that the aggregate of all local entries is the termination
> > plane's Rx filter, in other words not more than that, i.e. the termination
> > plane shouldn't treat the RX filters as mirrors from the forwarding plane.
> > And in that view, yes maybe I agree that IFF_PROMISC would implicitly
> > correspond to BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD, and
> 
> I would phrase it as: IFF_PROMISC means that switchdevs should forward
> as much crap as possible towards the CPU. But at the DSA layer, I think
> calling a driver specific .bridge_set_promisc op would be better than
> assuming that driver's can't do any better.

I think letting individual DSA sub-drivers decide how generous they'd
like to be with a promiscuous bridge is pure insanity. Today a
promiscuous bridge wants to see all traffic being mirrored, and we don't
do that. That is an inconvenient truth we need to accept and have a
common position on. Supposedly a position driven centrally by the bridge
driver itself.

> > IFF_ALLMULTI would implicitly correspond to BR_MCAST_FLOOD (ok, also
> > adjust for mcast_router ports).
> 
> IFF flags shouldn't correspond to any bridge flags. They describe higher
> level features. Therefore, they should be passed down to the drivers,
> who in many cases may decide to use hardware resources that are shared
> with bridge flags (i.e. flood controls), but in some cases may be able
> to do something better.
> 
> As an example of "something better": some ASICs have separate flooding
> controls for IP and non-IP multicast.
> 
> So, I think
> 
>     ip link set dev br0 allmulticast on
> 
> Should be one way for userspace to tell the bridge to mark the host port
> as a permanent multicast router port. This in turn would trigger a
> 
>     switchdev_port_attr_set(dev,
>     	&{ .id = SWITCHDEV_ATTR_ID_BRIDGE_MROUTER ... }, extack);
> 
> At the DSA layer this info would be passed to the driver, which will
> decide if that means the same thing as BR_MCAST_FLOOD or something
> else.

Yeah, I don't think so. Doing nothing at all is way better than
entangling the RX filtering logic even more with the forwarding logic,
IMHO.

> > But I'd rather turn a blind eye to that, on the practical basis that
> > making any changes at all to this mess that isn't correct even now is
> > going to break something. I'm going to invent some new knobs which
> > broadly mean what IFF_PROMISC | IFF_ALLMULTI should have meant, and I'm
> > going to insist on the selling point that these allow me more
> > fine-grained control over which class of MAC DA is flooded. In any case
> > I'm not making things worse, because the BR_FLOOD flags towards the
> > bridge device still make some amount of sense even in the context of a
> > more normal interpretation of the bridge's RX filtering flags, if
> > someone from the future really gets infuriated by the bridge device's
> > behavior in the presence of uppers with different MAC address and has
> > the guts to change/break something. So maybe I can get away with this."
> >
> > Am I getting this right? Because maybe I can hop onboard :)
> 
> I think we're getting there. Would love to have you on deck! :)
