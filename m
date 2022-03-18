Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F2A4DD5AA
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 08:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbiCRH7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 03:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiCRH7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 03:59:33 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2D4174B82
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 00:58:14 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id bn33so10300704ljb.6
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 00:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ff18nPqwD55LvDSkw2fNPrc8o/rSIvAVZw7h1TN+HHU=;
        b=gyBgBz7h0WHK1YfY4pMNH4ty9H8IBO4WLbMXOov4No887x+rVw/viHGhX84e35Lw3D
         Op0GPQGtjE+51/kOtje45o1tKY0c5Ue4YL2evkp3gBVoPA+vPHGOtCKWxWVVkg0aRuUO
         4ENiYYSLo1wLseOdfIU46z4AX0FNXIRz5PHPihjhZFxLTWCzoQXTxCc+4hpPZx2/QZCt
         qyTpriIS4eSUDd6Vzgcgd2qO7wd0Fx0cmV4WEk4I/6tCRFkhn1BM17s78HyV5QIEhFm0
         Aa99Ir+aJMssCIe1QoQqomshNaKyesiBEI3WlevrbwOvqRhDB3HdzIFRjcjrMO33k90+
         0rtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ff18nPqwD55LvDSkw2fNPrc8o/rSIvAVZw7h1TN+HHU=;
        b=7gDKP6hQTjvXSWYU8lPv5DzMX2uT1Qfi8VdIEB4OWwAy3mAyAQ/dTctScPeD1f/ofe
         xQzmPRtaLsnslzgbLtGjBWlrgC6+BOcqDpNC+uwXgVR5x3YD1OCn+iPrVcvA2KF+tFmM
         zxdIMQCPdxfNJFar8pUzUKIuTHqRtu986ht97MRLe+/6g/Gux1kwKW+fj0KPNuAomakt
         BcPwn32AdUxwbEN83KYYEV05MRW4n2cHkAuNVUVU01PCd+qeEVNITojxsPPDugwJkzpv
         QqOv3xm6ppVhXOWSpEo6EkA0Wp8Icx0RS1O3qoVewjIIMLX28Z9lFr/qMJTrasx7wgaU
         cJVQ==
X-Gm-Message-State: AOAM531E/yNtkJ+a+wE9cle1i8Ulw1YKER+7JG4KYY6HF4s89VtwD4ba
        T3IrisIMOF+6rN+pVy9YJMLbmQ==
X-Google-Smtp-Source: ABdhPJy/FXDe4vwDk88UN/SV3UP4Q/Sumnn2L8xkoh0KlXF0tfeqx93VoHTSGqrXj+LTuLcMTze8jg==
X-Received: by 2002:a2e:9dcf:0:b0:247:f8eb:90d5 with SMTP id x15-20020a2e9dcf000000b00247f8eb90d5mr5293970ljj.23.1647590292795;
        Fri, 18 Mar 2022 00:58:12 -0700 (PDT)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id p13-20020a2e804d000000b0024802bf2abasm810467ljg.116.2022.03.18.00.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 00:58:12 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
In-Reply-To: <20220317140525.e2iqiy2hs3du763l@skbuf>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <2d38e998-396f-db39-7ccf-2a991d4e02cb@gmail.com>
 <87ilsxo052.fsf@waldekranz.com> <20220317140525.e2iqiy2hs3du763l@skbuf>
Date:   Fri, 18 Mar 2022 08:58:11 +0100
Message-ID: <87k0crk7zg.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 16:05, Vladimir Oltean <olteanv@gmail.com> wrote:
> Hello Tobias,
>
> On Tue, Mar 01, 2022 at 10:04:09PM +0100, Tobias Waldekranz wrote:
>> On Tue, Mar 01, 2022 at 09:14, Florian Fainelli <f.fainelli@gmail.com> wrote:
>> > On 3/1/2022 4:31 AM, Mattias Forsblad wrote:
>> >> Greetings,
>> >> 
>> >> This series implements a new bridge flag 'local_receive' and HW
>> >> offloading for Marvell mv88e6xxx.
>> >> 
>> >> When using a non-VLAN filtering bridge we want to be able to limit
>> >> traffic to the CPU port to lessen the CPU load. This is specially
>> >> important when we have disabled learning on user ports.
>> >> 
>> >> A sample configuration could be something like this:
>> >> 
>> >>         br0
>> >>        /   \
>> >>     swp0   swp1
>> >> 
>> >> ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
>> >> ip link set swp0 master br0
>> >> ip link set swp1 master br0
>> >> ip link set swp0 type bridge_slave learning off
>> >> ip link set swp1 type bridge_slave learning off
>> >> ip link set swp0 up
>> >> ip link set swp1 up
>> >> ip link set br0 type bridge local_receive 0
>> >> ip link set br0 up
>> >> 
>> >> The first part of the series implements the flag for the SW bridge
>> >> and the second part the DSA infrastructure. The last part implements
>> >> offloading of this flag to HW for mv88e6xxx, which uses the
>> >> port vlan table to restrict the ingress from user ports
>> >> to the CPU port when this flag is cleared.
>> >
>> > Why not use a bridge with VLAN filtering enabled? I cannot quite find it 
>> > right now, but Vladimir recently picked up what I had attempted before 
>> > which was to allow removing the CPU port (via the bridge master device) 
>> > from a specific group of VLANs to achieve that isolation.
>> >
>> 
>> Hi Florian,
>> 
>> Yes we are aware of this work, which is awesome by the way! For anyone
>> else who is interested, I believe you are referring to this series:
>> 
>> https://lore.kernel.org/netdev/20220215170218.2032432-1-vladimir.oltean@nxp.com/
>> 
>> There are cases though, where you want a TPMR-like setup (or "dumb hub"
>> mode, if you will) and ignore all tag information.
>> 
>> One application could be to use a pair of ports on a switch as an
>> ethernet extender/repeater for topologies that span large physical
>> distances. If this repeater is part of a redundant topology, you'd to
>> well to disable learning, in order to avoid dropping packets when the
>> surrounding active topology changes. This, in turn, will mean that all
>> flows will be classified as unknown unicast. For that reason it is very
>> important that the CPU be shielded.
>
> So have you seriously considered making the bridge ports that operate in
> 'dumb hub' mode have a pvid which isn't installed as a 'self' entry on
> the bridge device?

Just so there's no confusion, you mean something like...

    ip link add dev br0 type bridge vlan_filtering 1 vlan_default_pvid 0

    for p in swp0 swp1; do
        ip link set dev $p master br0
        bridge vlan add dev $p vid 1 pvid untagged
    done

... right?

In that case, the repeater is no longer transparent with respect to
tagged packets, which the application requires.

>> You might be tempted to solve this using flooding filters of the
>> switch's CPU port, but these go out the window if you have another
>> bridge configured, that requires that flooding of unknown traffic is
>> enabled.
>
> Not if CPU flooding can be managed on a per-user-port basis.

True, but we aren't lucky enough to have hardware that can do that :)

>> Another application is to create a similar setup, but with three ports,
>> and have the third one be used as a TAP.
>
> Could you expand more on this use case?

Its just the standard use-case for a TAP really. You have some link of
interest that you want to snoop, but for some reason there is no way of
getting a PCAP from the station on either side:

   Link of interest
          |
.-------. v .-------.
| Alice +---+  Bob  |
'-------'   '-------'

So you insert a hub in the middle, and listen on a third port:

.-------.   .-----.   .-------.
| Alice +---+ TAP +---+  Bob  |
'-------'   '--+--'   '-------'
               |
 PC running tcpdump/wireshark

The nice thing about being able to set this up in Linux is that if your
hardware comes with a mix of media types, you can dynamically create the
TAP for the job at hand. E.g. if Alice and Bob are communicating over a
fiber, but your PC only has a copper interface, you can bridge to fiber
ports with one copper; if you need to monitor a copper link 5min later,
you just swap out the fiber ports for two copper ports.

>> >> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
>> >
>> > I don't believe this tag has much value since it was presumably carried 
>> > over from an internal review. Might be worth adding it publicly now, though.
>> 
>> I think Mattias meant to replicate this tag on each individual
>> patch. Aside from that though, are you saying that a tag is never valid
>> unless there is a public message on the list from the signee? Makes
>> sense I suppose. Anyway, I will send separate tags for this series.
