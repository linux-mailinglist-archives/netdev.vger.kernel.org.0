Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8404B4DC855
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbiCQOGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiCQOGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:06:50 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842BE9F38E
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:05:29 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w25so6671420edi.11
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AARcCr2zPD/DCwYN0PuRwVSEBi+RuxgtLbaAzhBrceo=;
        b=m0uECm45s1VOqD8NdmnHZKfwmtDX6tsQRDSeuYPDOO2QgFv7x7kDJ3eijWoA9efjGB
         zJePRoyCoAzqG7E6fY4529fDQ5CSoiPOPhBv7nZxSA3O6LNbltfli3tcSA9GfcBumdON
         qKMefzXuaixo0gWTo++ucyjWo7dqCczkFVg/7ukWkheyMjoin3w7jHatIZKilr1J9ViV
         Gd+ECoF8TYZ1WVDXsLKl1ZNT9H/romgU969OdiGID7lRB6HwXHbywirSaFIUctFUM6mr
         g6+YL9CaJ69RHRrL8/VsLJYQUffZINTKsvfY0CLh2nBkepajOX5U8eEHVAvHSxsQVlWo
         XaYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AARcCr2zPD/DCwYN0PuRwVSEBi+RuxgtLbaAzhBrceo=;
        b=bq//i2Yxx7YJw9uQggI0lK9zX1aX62yjTfK3Hv9OUA03UKmJwbdnC+Ceiuspt+WNTR
         k7qjbPiPOglFcsZOr1NrYULK1eO2QRbWm6GlPi1hWLVSLLb0xh6xjlnipq9S5oe0ozMJ
         KbwMM9OO/77Royqgy/5eGdeiOZdYfmQ9kk29tjSrid4yh9hX5aDi0FBN3fuSqrFCzTcc
         LA6I83D9zm3FVhVX0far7MraoBduPQ/8Na+/hdHqARtzdX7p0Rqealf74Ral/uQFVwKq
         McUP3pb3ObZCsmrMJeiNMQOzuG/xnTky+hAjjT+5z4HVGUGJeqdWpyckfyyoYJ0434+a
         jZYA==
X-Gm-Message-State: AOAM533DaL3VXK3zGn3DgaldC6Cay2pa/7QpF53EiTJwX86ZjY3h5s5D
        oq/edb8YzTN3MYZlaZAdYxtbz3d4MVs=
X-Google-Smtp-Source: ABdhPJyhWEcMGXp6EFQe/fBRfOp1ZcIDgCMwZ9da/6kkSQpqEYq8yV1oYZnoU06DbiQE2Fc2hewbZA==
X-Received: by 2002:a50:d949:0:b0:418:ecfe:8c25 with SMTP id u9-20020a50d949000000b00418ecfe8c25mr4627485edj.156.1647525927786;
        Thu, 17 Mar 2022 07:05:27 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id f5-20020a17090624c500b006cee6661b6esm2461143ejb.10.2022.03.17.07.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 07:05:27 -0700 (PDT)
Date:   Thu, 17 Mar 2022 16:05:25 +0200
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
Message-ID: <20220317140525.e2iqiy2hs3du763l@skbuf>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <2d38e998-396f-db39-7ccf-2a991d4e02cb@gmail.com>
 <87ilsxo052.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilsxo052.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Tobias,

On Tue, Mar 01, 2022 at 10:04:09PM +0100, Tobias Waldekranz wrote:
> On Tue, Mar 01, 2022 at 09:14, Florian Fainelli <f.fainelli@gmail.com> wrote:
> > On 3/1/2022 4:31 AM, Mattias Forsblad wrote:
> >> Greetings,
> >> 
> >> This series implements a new bridge flag 'local_receive' and HW
> >> offloading for Marvell mv88e6xxx.
> >> 
> >> When using a non-VLAN filtering bridge we want to be able to limit
> >> traffic to the CPU port to lessen the CPU load. This is specially
> >> important when we have disabled learning on user ports.
> >> 
> >> A sample configuration could be something like this:
> >> 
> >>         br0
> >>        /   \
> >>     swp0   swp1
> >> 
> >> ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
> >> ip link set swp0 master br0
> >> ip link set swp1 master br0
> >> ip link set swp0 type bridge_slave learning off
> >> ip link set swp1 type bridge_slave learning off
> >> ip link set swp0 up
> >> ip link set swp1 up
> >> ip link set br0 type bridge local_receive 0
> >> ip link set br0 up
> >> 
> >> The first part of the series implements the flag for the SW bridge
> >> and the second part the DSA infrastructure. The last part implements
> >> offloading of this flag to HW for mv88e6xxx, which uses the
> >> port vlan table to restrict the ingress from user ports
> >> to the CPU port when this flag is cleared.
> >
> > Why not use a bridge with VLAN filtering enabled? I cannot quite find it 
> > right now, but Vladimir recently picked up what I had attempted before 
> > which was to allow removing the CPU port (via the bridge master device) 
> > from a specific group of VLANs to achieve that isolation.
> >
> 
> Hi Florian,
> 
> Yes we are aware of this work, which is awesome by the way! For anyone
> else who is interested, I believe you are referring to this series:
> 
> https://lore.kernel.org/netdev/20220215170218.2032432-1-vladimir.oltean@nxp.com/
> 
> There are cases though, where you want a TPMR-like setup (or "dumb hub"
> mode, if you will) and ignore all tag information.
> 
> One application could be to use a pair of ports on a switch as an
> ethernet extender/repeater for topologies that span large physical
> distances. If this repeater is part of a redundant topology, you'd to
> well to disable learning, in order to avoid dropping packets when the
> surrounding active topology changes. This, in turn, will mean that all
> flows will be classified as unknown unicast. For that reason it is very
> important that the CPU be shielded.

So have you seriously considered making the bridge ports that operate in
'dumb hub' mode have a pvid which isn't installed as a 'self' entry on
the bridge device?

> You might be tempted to solve this using flooding filters of the
> switch's CPU port, but these go out the window if you have another
> bridge configured, that requires that flooding of unknown traffic is
> enabled.

Not if CPU flooding can be managed on a per-user-port basis.

> Another application is to create a similar setup, but with three ports,
> and have the third one be used as a TAP.

Could you expand more on this use case?

> >> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
> >
> > I don't believe this tag has much value since it was presumably carried 
> > over from an internal review. Might be worth adding it publicly now, though.
> 
> I think Mattias meant to replicate this tag on each individual
> patch. Aside from that though, are you saying that a tag is never valid
> unless there is a public message on the list from the signee? Makes
> sense I suppose. Anyway, I will send separate tags for this series.
