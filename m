Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A594CA361
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbiCBLUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241417AbiCBLTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:19:24 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A248A26AD5
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 03:18:03 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id a23so3013193eju.3
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 03:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D0sqPtYUx1IaKQQ5NZtOIjB+m27XWbtlilnWNE9woZo=;
        b=otVe95AslrjqIdNLE670/6X47Ce3Oqc/RedY3AHvj1KGZC3D5pis92Jm4/FZ7TlJUf
         MDjqGwzn9JhMd1f9hCQrM7DnlpIwymcN0JezbS96X49w9nEMh+yQWjGo2FYUuOOUySpJ
         +to+TjCTa6DhXUP6/dAsJQk0znDxu3BI00k3YEs4nvTj8v4YMZVRafpmIigSiQghNSeC
         Zc8UINRqQZdN3hdgXwHScze3Xo9FiHZXll60Vbw72n3gd1tpkvsVzW4VscGwyfBdLtbn
         NKhHPRJ5PnhIsGUdlqj/cGitNRJR+jR0eeom8jIO8vnsZU+UcPzR0GwiKEzW33pvq+Na
         J2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D0sqPtYUx1IaKQQ5NZtOIjB+m27XWbtlilnWNE9woZo=;
        b=lPkBKwHeYGJ5AjHGNwr02e5+JuacRffU5/ggHUdayXh/XpfqQ3gaoN8pPxAeNKWpIT
         pNLWHtQO7ApSJh13bx8CHKMXF+CGZCCDSkyVK+On3wU00UZa/rsV+umnpuPAFdgxac36
         Ojbd+kvbYaRyEnSzlAf+kaHSbuG3evAbifp1ujpuori2yBGJBZNo6WTHy2L+7EmkPhR3
         kAihizJQ0M7QbwwCj0XkrAH47UnBJ/oCG5/R+7TKMn6s2Zm5XnkrUl6Hf4J2ECaZeyfT
         jKzwMCs+HMMS0EIXudcO12NYI0kyvhP3Tg7awtqbD32okIUUO7h5WNqfTD8A4WbMHGfa
         vYkA==
X-Gm-Message-State: AOAM5320U5YdoWpJovPoEH0tbSPlt+tHhGuhx8aOMNaSAWDZFbJZCLrc
        0LG5XATg/OVOqyizVOW6Duk=
X-Google-Smtp-Source: ABdhPJzZyYSguxbxFsTqf1PrvuKRZZ+9H3MYlSukf1lpJejpg6GYETE4YARCBZIifTYZpk3LLXqeCA==
X-Received: by 2002:a17:906:3a18:b0:6cd:ba45:995f with SMTP id z24-20020a1709063a1800b006cdba45995fmr23203043eje.328.1646219881568;
        Wed, 02 Mar 2022 03:18:01 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id p7-20020aa7cc87000000b00410ee30cefbsm8385614edt.71.2022.03.02.03.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:18:01 -0800 (PST)
Date:   Wed, 2 Mar 2022 13:17:59 +0200
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
Message-ID: <20220302111759.xylbcwkiev6igmqg@skbuf>
References: <20210224114350.2791260-1-olteanv@gmail.com>
 <20210224114350.2791260-6-olteanv@gmail.com>
 <YD0GyJfbhqpPjhVd@shredder.lan>
 <CA+h21hrtnXr11VXsRXokkZHQ3AQ8nNCLsWTC4ztoLMmNmQoxxg@mail.gmail.com>
 <YhUVNc58trg+r3V9@shredder>
 <20220222171810.bpoddx7op3rivenm@skbuf>
 <YheGlwjp849dhcpq@shredder>
 <20220224135241.ne6c64segpt6azed@skbuf>
 <Yh5H1zexT0/Q2bc4@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh5H1zexT0/Q2bc4@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 06:20:39PM +0200, Ido Schimmel wrote:
> > > OK, I see the problem... So you want the bridge to support
> > > 'IFF_UNICAST_FLT' by installing local FDB entries? I see two potential
> > > problems:
> > > 
> > > 1. For VLAN-unaware bridges this is trivial as VLAN information is of no
> > > use. For VLAN-aware bridges we either need to communicate VLAN
> > > information from upper layers or install a local FDB entry per each
> > > configured VLAN (wasteful...). Note that VLAN information will not
> > > always be available (in PACKET_MR_UNICAST, for example), in which case a
> > > local FDB entry will need to be configured per each existing VLAN in
> > > order to maintain existing behavior. Which lead to me think about the
> > > second problem...
> > >
> > > 2. The bigger problem that I see is that if the bridge starts supporting
> > > 'IFF_UNICAST_FLT' by installing local FDB entries, then packets that
> > > were previously locally received and flooded will only be locally
> > > received. Only locally receiving them makes sense, but I don't know what
> > > will break if we change the existing behavior... Maybe this needs to be
> > > guarded by a new bridge option?
> > 
> > I think it boils down to whether PACKET_MR_UNICAST on br0 is equivalent to
> > 'bridge fdb add dev br0 self permanent' or not. Theoretically, the
> > former means "if a packet enters the local termination path of br0,
> > don't drop it", 
> 
> Trying to understand the first part of the sentence, are you saying that
> if user space decides to use this interface, then it is up to it to
> ensure that packets with the given unicast address are terminated on the
> bridge? That is, it is up to user space to install the necessary
> permanent FDB record?

This first part of the sentence is just wondering whether it is even
sane to make the bridge driver essentially provide an implementation for
PACKET_MR_UNICAST, and translate that into a local FDB entry which means
something else. User space can already install a local FDB entry with
the MAC address of the upper interface, and this will behave closer to
what is expected.

If the bridge ever implements the support for PACKET_MR_UNICAST, a new
FDB entry flag is probably needed, for local reception. If the MAC
address added with PACKET_MR_UNICAST is new, the bridge would create an
entry with fdb->dst = NULL. If it already exists, it would keep the
existing fdb->dst and just mark the local reception flag as true.
This is to comply with the "copy to CPU" semantics instead of altering
the forwarding destination. I'm not sure whether there are real use
cases beyond just complying to expected semantics.

> I think that is fair, it is just that right now this operation does
> something else and causes all the packets forwarded via the bridge to
> be locally terminated. Most of them will then be dropped by upper
> layers. I don't think this was the author's intention, it seems like
> an unfortunate side effect of current implementation.

Do you mean here that the "something else" is to turn on promiscuous
mode for the bridge, and this makes local_rcv = true for every packet in
br_handle_frame_finish?

Yes, that is a problem. The dev_uc_add() calls will keep the bridge's
promiscuity at 1, with no way to turn it back to 0 from user space.
To get rid of this we'd need to declare IFF_UNICAST_FLT at the very
least.

> This behavior is even more ridiculous when you take hardware offload
> into account, as usually the CPU is unable to handle all these
> packets.

If we keep the analogy that a PACKET_MR_UNICAST means "copy MAC address
X to CPU", then IFF_PROMISC means "copy all packets to CPU", no?

So I wouldn't say the behavior is even more ridiculous, it is just as
ridiculous, just on a different level. And maybe not even "ridiculous",
just "highly sub-optimal". Ridiculous would be to not comply to the
expected behavior.

> > while the other means "direct this MAC DA only towards
> > the local termination path of br0".
> 
> This I agree with.
> 
> > I.o.w. the difference between "copy to CPU" and "trap to CPU".
> > 
> > If we agree they aren't equivalent, and we also agree that a macvlan on
> > top of a bridge wants "trap to CPU" instead of "copy to CPU", I think
> > the only logical conclusion is that the communication mechanism between
> > the bridge and the macvlan that we're looking for doesn't exist -
> > dev_uc_add() does something slightly different.
> > 
> > Which is why I want to better understand your idea of having the bridge
> > track upper interfaces.
> 
> In my case these upper interfaces are actually router interfaces and I'm
> interested in their MAC (in addition to other attributes) to know which
> FDB entry to program towards the router port (your CPU port) on ingress
> and which SA to use on egress (the hardware has limitations on SAs).
> 
> I'm pretty sure bridge maintainers will not agree to have this code in
> the bridge driver in which case you can implement this in DSA. Should be
> quite simple as I guess most configurations use VLANs/MACVLANs uppers.

Yes, but this will record only the dev_addr of those upper interfaces.
It would not be fully compliant with what user space can ask for.
