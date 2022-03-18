Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7134DD8C3
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 12:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbiCRLNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 07:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbiCRLNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 07:13:12 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A6A1B7571
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 04:11:53 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id qa43so16260595ejc.12
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 04:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EPWKDDXt6LukRrgSrUCjleSHy5g1RRpgs7yzK6Q8780=;
        b=a0wHDYOJQm17Un1sgWz1iYEroj7YsSddNWMMcxd6hjZFmhzF1O0u60pNhj23bPQKEN
         ZtyU3ZnEcnA2XEBNZZpGUA8QmVH3KqeSu/sM73gcD0N+qhuJDMv4R2B1V5DaTEgY4ptv
         8eR8LVWHpWHxeTbHmBeOpfEVmLBqAttik9sDaiW4NGovAQPil+9Z/zBkiaIXK/Cg4bFR
         YmqfbgJXpLCUclRI+q+hI7AQ3fij1SthvTEeYCRNSGSes7hypYagJLa10Bv+E6tfnxxP
         lZ8BFme10rZ4IxWW+9UlHdkYApzlKbzsyHxcnoucMWKRsBJZg779golXIzmyLnLiqRFR
         jiRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EPWKDDXt6LukRrgSrUCjleSHy5g1RRpgs7yzK6Q8780=;
        b=H+llJWPYiAJxeQFtH3aaT5qov+On474TB2W1AFMFfOlyIFdOEwS31rTnjDPYzrg0Tg
         lj4DpdSGcGxq3168W6ufM6evRVmfVOnVhq3lWeNyIaQ46L9+g74EJ/W4wMGBL1z7Pkuh
         Z28OrK74ch2dqIoW81sYhmRZ3XKtWiPrgLJKxoEzFD8UzwWwVofGT+woYUDbuNLInIY7
         efAGDPbsn+rBFuLKXHTZ0rLPX6ymTVMGofobOsvoHfbjjJfskTSwhd/FFsVhbrFX+Srh
         i2wRhMRDW/P3dYR2VD5UHRBq71d8MnnJNIi58DBs5OYSovmoovxJ7bTc+EgsQLVUy2q3
         Kh7A==
X-Gm-Message-State: AOAM532JxVaMp7V1V8aJsvu1xf4EWrrHFu+D329M7z/DtFrwenZu9xXO
        0zb58VbIxPzOPbjyyN90E/0=
X-Google-Smtp-Source: ABdhPJxxRL2wVH87dTvr/ZuT8fNA6/dvjfLmpSb3QdmfzokdhQPOwhp8eUK3/0aDTXvBMaMG4Evo+A==
X-Received: by 2002:a17:906:c14c:b0:6df:a37b:35ac with SMTP id dp12-20020a170906c14c00b006dfa37b35acmr5302781ejc.441.1647601912008;
        Fri, 18 Mar 2022 04:11:52 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id hd35-20020a17090796a300b006dfbfc80ce1sm472692ejc.128.2022.03.18.04.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 04:11:51 -0700 (PDT)
Date:   Fri, 18 Mar 2022 13:11:50 +0200
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
Message-ID: <20220318111150.2g2pjcajjqhpr3wk@skbuf>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <2d38e998-396f-db39-7ccf-2a991d4e02cb@gmail.com>
 <87ilsxo052.fsf@waldekranz.com>
 <20220317140525.e2iqiy2hs3du763l@skbuf>
 <87k0crk7zg.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0crk7zg.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 08:58:11AM +0100, Tobias Waldekranz wrote:
> On Thu, Mar 17, 2022 at 16:05, Vladimir Oltean <olteanv@gmail.com> wrote:
> > Hello Tobias,
> >
> > On Tue, Mar 01, 2022 at 10:04:09PM +0100, Tobias Waldekranz wrote:
> >> On Tue, Mar 01, 2022 at 09:14, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >> > On 3/1/2022 4:31 AM, Mattias Forsblad wrote:
> >> >> Greetings,
> >> >> 
> >> >> This series implements a new bridge flag 'local_receive' and HW
> >> >> offloading for Marvell mv88e6xxx.
> >> >> 
> >> >> When using a non-VLAN filtering bridge we want to be able to limit
> >> >> traffic to the CPU port to lessen the CPU load. This is specially
> >> >> important when we have disabled learning on user ports.
> >> >> 
> >> >> A sample configuration could be something like this:
> >> >> 
> >> >>         br0
> >> >>        /   \
> >> >>     swp0   swp1
> >> >> 
> >> >> ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
> >> >> ip link set swp0 master br0
> >> >> ip link set swp1 master br0
> >> >> ip link set swp0 type bridge_slave learning off
> >> >> ip link set swp1 type bridge_slave learning off
> >> >> ip link set swp0 up
> >> >> ip link set swp1 up
> >> >> ip link set br0 type bridge local_receive 0
> >> >> ip link set br0 up
> >> >> 
> >> >> The first part of the series implements the flag for the SW bridge
> >> >> and the second part the DSA infrastructure. The last part implements
> >> >> offloading of this flag to HW for mv88e6xxx, which uses the
> >> >> port vlan table to restrict the ingress from user ports
> >> >> to the CPU port when this flag is cleared.
> >> >
> >> > Why not use a bridge with VLAN filtering enabled? I cannot quite find it 
> >> > right now, but Vladimir recently picked up what I had attempted before 
> >> > which was to allow removing the CPU port (via the bridge master device) 
> >> > from a specific group of VLANs to achieve that isolation.
> >> >
> >> 
> >> Hi Florian,
> >> 
> >> Yes we are aware of this work, which is awesome by the way! For anyone
> >> else who is interested, I believe you are referring to this series:
> >> 
> >> https://lore.kernel.org/netdev/20220215170218.2032432-1-vladimir.oltean@nxp.com/
> >> 
> >> There are cases though, where you want a TPMR-like setup (or "dumb hub"
> >> mode, if you will) and ignore all tag information.
> >> 
> >> One application could be to use a pair of ports on a switch as an
> >> ethernet extender/repeater for topologies that span large physical
> >> distances. If this repeater is part of a redundant topology, you'd to
> >> well to disable learning, in order to avoid dropping packets when the
> >> surrounding active topology changes. This, in turn, will mean that all
> >> flows will be classified as unknown unicast. For that reason it is very
> >> important that the CPU be shielded.
> >
> > So have you seriously considered making the bridge ports that operate in
> > 'dumb hub' mode have a pvid which isn't installed as a 'self' entry on
> > the bridge device?
> 
> Just so there's no confusion, you mean something like...
> 
>     ip link add dev br0 type bridge vlan_filtering 1 vlan_default_pvid 0
> 
>     for p in swp0 swp1; do
>         ip link set dev $p master br0
>         bridge vlan add dev $p vid 1 pvid untagged
>     done
> 
> ... right?
> 
> In that case, the repeater is no longer transparent with respect to
> tagged packets, which the application requires.

If you are sure that there exists one VLAN ID which is never used (like
4094), what you could do is you could set the port pvids to that VID
instead of 1, and add the entire VLAN_N_VID range sans that VID in the
membership list of the two ports, as egress-tagged.

This is 'practical transparency' - if true transparency is required then
yes, this doesn't work.

> >> You might be tempted to solve this using flooding filters of the
> >> switch's CPU port, but these go out the window if you have another
> >> bridge configured, that requires that flooding of unknown traffic is
> >> enabled.
> >
> > Not if CPU flooding can be managed on a per-user-port basis.
> 
> True, but we aren't lucky enough to have hardware that can do that :)
> 
> >> Another application is to create a similar setup, but with three ports,
> >> and have the third one be used as a TAP.
> >
> > Could you expand more on this use case?
> 
> Its just the standard use-case for a TAP really. You have some link of
> interest that you want to snoop, but for some reason there is no way of
> getting a PCAP from the station on either side:
> 
>    Link of interest
>           |
> .-------. v .-------.
> | Alice +---+  Bob  |
> '-------'   '-------'
> 
> So you insert a hub in the middle, and listen on a third port:
> 
> .-------.   .-----.   .-------.
> | Alice +---+ TAP +---+  Bob  |
> '-------'   '--+--'   '-------'
>                |
>  PC running tcpdump/wireshark
> 
> The nice thing about being able to set this up in Linux is that if your
> hardware comes with a mix of media types, you can dynamically create the
> TAP for the job at hand. E.g. if Alice and Bob are communicating over a
> fiber, but your PC only has a copper interface, you can bridge to fiber
> ports with one copper; if you need to monitor a copper link 5min later,
> you just swap out the fiber ports for two copper ports.
> 
> >> >> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> >
> >> > I don't believe this tag has much value since it was presumably carried 
> >> > over from an internal review. Might be worth adding it publicly now, though.
> >> 
> >> I think Mattias meant to replicate this tag on each individual
> >> patch. Aside from that though, are you saying that a tag is never valid
> >> unless there is a public message on the list from the signee? Makes
> >> sense I suppose. Anyway, I will send separate tags for this series.
