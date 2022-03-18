Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1464DD9EB
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 13:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbiCRMqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 08:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiCRMqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 08:46:14 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8CE21A8A0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 05:44:55 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id qx21so16735231ejb.13
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 05:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JalXLMXwUmAW7dSuwsrQpDTtfSDYvtQ/bnXTzy1j2w0=;
        b=QLIwpX+ghXeEQBScxya22wYtCj+Hr2ySlNVIY7gBJKx1GrtXx4T8Uuk8eocqcI1txG
         KHmuVJDK+M621ROAGYoA4YETjh/ZOxcG2lfZsyO7HoaZa/nxccqU7QdNMjnO+w/1SlP5
         NLoYqceDG4KIcg6E7y4TY07nUSp2VbxyCPlUi5D7CbtQoSCkyLmWSgKqx1wFZpGOhDq/
         2H9iaYajYB4Ngr3TF5tzRNh2CeJmqs9zh9Gwc4FvA6ezJ6hnAac/QbGCO6zFtk25qBQn
         ZcAunUlj42qJcnwO5GHylv6Mz4qyWtEGKtw4jwFtf7Z0nU+lFGct1ags3DIKmU3S7F5C
         RsDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JalXLMXwUmAW7dSuwsrQpDTtfSDYvtQ/bnXTzy1j2w0=;
        b=197/1KfTRPVz/CI+b2UIhX5YRRaLNhmKNB6LArqnaTup/K5BSlsy/7l6JoXzbMtHNQ
         3Rm6w/jW6BEJ+rjQFBb0QcdWn2qLtSnGQHWqc5Fk0iCWqwh/gqLenrfFbbTnzuVcVC5g
         U4T6FXCGf4A+Vye5Q6eE3kr51XoK7dnz/sMLv9FV1lGK0K1K1O9jK+nbf1BngWA+sKPg
         IypJYUToZjsDWhHjbIkyAKGbdBVuB/B+pjhlfWzquN9RdFLs4PyY+1gGZsL5up5Llyb5
         mAHhfLie6nG533dfcKUKnCJhk6sNslEt/KS/TBrmWnYscDNLWATaB+soux/nck8z7Pfw
         XvmQ==
X-Gm-Message-State: AOAM530EcBnqUFxX2vIayj3aWT1icSushmB4oPyJFM0P1PgAq0DUHzSm
        z/Kiu1llt/I9oRFaRGvvcSQ=
X-Google-Smtp-Source: ABdhPJwp2ikleriryi70nkWoRn+XRYYOjoNYh4TcRsq0ynzs0r59WnHxFeJ0tkI6eNluorTzNXdDWA==
X-Received: by 2002:a17:907:7284:b0:6df:917c:1796 with SMTP id dt4-20020a170907728400b006df917c1796mr7168216ejc.644.1647607493355;
        Fri, 18 Mar 2022 05:44:53 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id dz11-20020a0564021d4b00b00418ce7d3d17sm4226309edb.66.2022.03.18.05.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 05:44:52 -0700 (PDT)
Date:   Fri, 18 Mar 2022 14:44:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 0/3] bridge: dsa: switchdev: mv88e6xxx:
 Implement local_receive bridge flag
Message-ID: <20220318124451.jdclhe2dlgvggemr@skbuf>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <2d38e998-396f-db39-7ccf-2a991d4e02cb@gmail.com>
 <87ilsxo052.fsf@waldekranz.com>
 <20220317140525.e2iqiy2hs3du763l@skbuf>
 <87k0crk7zg.fsf@waldekranz.com>
 <20220318111150.2g2pjcajjqhpr3wk@skbuf>
 <87h77vjwd7.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h77vjwd7.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 01:09:08PM +0100, Tobias Waldekranz wrote:
> >> > So have you seriously considered making the bridge ports that operate in
> >> > 'dumb hub' mode have a pvid which isn't installed as a 'self' entry on
> >> > the bridge device?
> >> 
> >> Just so there's no confusion, you mean something like...
> >> 
> >>     ip link add dev br0 type bridge vlan_filtering 1 vlan_default_pvid 0
> >> 
> >>     for p in swp0 swp1; do
> >>         ip link set dev $p master br0
> >>         bridge vlan add dev $p vid 1 pvid untagged
> >>     done
> >> 
> >> ... right?
> >> 
> >> In that case, the repeater is no longer transparent with respect to
> >> tagged packets, which the application requires.
> >
> > If you are sure that there exists one VLAN ID which is never used (like
> > 4094), what you could do is you could set the port pvids to that VID
> > instead of 1, and add the entire VLAN_N_VID range sans that VID in the
> > membership list of the two ports, as egress-tagged.
> 
> Yeah, I've thought about this too. If the device's only role is to act
> as a repeater, then you can get away with it. But you will have consumed
> all rows in the VTU and half of the rows in the ATU (we add an entry for
> the broadcast address in every FID). So if you want to use your other
> ports for regular bridging you're left with a very limited feature set.

But VLANs in other bridges would reuse the same FIDs, at least in the
current mv88e6xxx implementation with no FDB isolation, no? So even
though the VTU is maxed out, it wouldn't get 'more' maxed out.

As for the broadcast address needing to be present in the ATU, honestly
I don't know too much about that. I see that some switches have a
FloodBC bit, wouldn't that be useful?

> > This is 'practical transparency' - if true transparency is required then
> > yes, this doesn't work.
> >
> >> >> You might be tempted to solve this using flooding filters of the
> >> >> switch's CPU port, but these go out the window if you have another
> >> >> bridge configured, that requires that flooding of unknown traffic is
> >> >> enabled.
> >> >
> >> > Not if CPU flooding can be managed on a per-user-port basis.
> >> 
> >> True, but we aren't lucky enough to have hardware that can do that :)
> >> 
> >> >> Another application is to create a similar setup, but with three ports,
> >> >> and have the third one be used as a TAP.
> >> >
> >> > Could you expand more on this use case?
> >> 
> >> Its just the standard use-case for a TAP really. You have some link of
> >> interest that you want to snoop, but for some reason there is no way of
> >> getting a PCAP from the station on either side:
> >> 
> >>    Link of interest
> >>           |
> >> .-------. v .-------.
> >> | Alice +---+  Bob  |
> >> '-------'   '-------'
> >> 
> >> So you insert a hub in the middle, and listen on a third port:
> >> 
> >> .-------.   .-----.   .-------.
> >> | Alice +---+ TAP +---+  Bob  |
> >> '-------'   '--+--'   '-------'
> >>                |
> >>  PC running tcpdump/wireshark
> >> 
> >> The nice thing about being able to set this up in Linux is that if your
> >> hardware comes with a mix of media types, you can dynamically create the
> >> TAP for the job at hand. E.g. if Alice and Bob are communicating over a
> >> fiber, but your PC only has a copper interface, you can bridge to fiber
> >> ports with one copper; if you need to monitor a copper link 5min later,
> >> you just swap out the fiber ports for two copper ports.
> >> 
> >> >> >> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> >> >
> >> >> > I don't believe this tag has much value since it was presumably carried 
> >> >> > over from an internal review. Might be worth adding it publicly now, though.
> >> >> 
> >> >> I think Mattias meant to replicate this tag on each individual
> >> >> patch. Aside from that though, are you saying that a tag is never valid
> >> >> unless there is a public message on the list from the signee? Makes
> >> >> sense I suppose. Anyway, I will send separate tags for this series.
