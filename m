Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD91534F26
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347250AbiEZMcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242383AbiEZMb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:31:58 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44414113B
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 05:31:55 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gh17so2750172ejc.6
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 05:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vR19COdd7rLCx06KsdVQN3mBv+nvItv+GZMJ2z5Y6Ak=;
        b=qVzYwnG5VWib2XFjrWjbGuDbCqw+iV8G/p4XLXA7/wMglslxhJ0DSvQyiZh6gpvRmM
         0/6s9FNkZPpcBTz+6mLXeb6VNR6xkYhN5aDo9IRhFNc5yLqASye/s3J6c8nfTDvbyebw
         Eke1ZDx9fFe43zwI1ctOo4PuYT0vVKuZXvx5voloWAGPcU43UexjQ1vCTXbgs9yRIfOI
         TGfp/MhzaDO7CteQA5dCSj1q/lbl+CW66d/PJ6lSBZaYvbhW75fs5H+HmNikutxlivr4
         6pVNP5qokmkqYz8ef+tgXcrRHEp2lCKGJVgcpwYVt8gmaXCsjQOZ/bE7gtYYtkLxC/6v
         TWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vR19COdd7rLCx06KsdVQN3mBv+nvItv+GZMJ2z5Y6Ak=;
        b=fjg9nWs4XHPZZXbylkGe9VFNqRkAIqXsKKWhIX/fqZSzOxAe0RWqp6uRKD/OgzETKm
         U3+Wkw2cJdwol/BjDpjFN/pKsWuvDm1XtTe/AYR/9kjzMeaVvPUGHLS+tClzTAfzDO17
         yhi1a475E/KM+7YT1rPHYcHpqy5rV5dGB4YMNYe6C89LdkDlFKJZlG1KN9eNnWfFl16k
         MWAPbVZ4e3s/BC97Qz+dQf4YGnRpRBBlVGOgP4oDA8OB4bTRgamc+yg5kSfLqOb6JNko
         UlBA6ITXweTtecTRRSUTxgHqLPPQ8C+B8t5Gh2SaemLuF9bPPNoNW4TZt7WvkyYOmnhn
         Ph+w==
X-Gm-Message-State: AOAM531nB4pc7bmWvZuwX9QpTPOEQckf3aZBXIa7kLYCS080L7qBxVuH
        +3P6Rjld7OQN5GIALQI4am4=
X-Google-Smtp-Source: ABdhPJzJADTPQxdQxzsgS9v27zgOd6vsuHAOSC44NXcw5tlX4HWjUq123ZwRcqJr3iXAAe0iQrenZw==
X-Received: by 2002:a17:907:94c7:b0:6fe:d85b:e101 with SMTP id dn7-20020a17090794c700b006fed85be101mr18753118ejc.533.1653568313668;
        Thu, 26 May 2022 05:31:53 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id a9-20020a170906274900b006feb20b5235sm485830ejd.84.2022.05.26.05.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 05:31:53 -0700 (PDT)
Date:   Thu, 26 May 2022 15:31:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rodolfo Giometti <giometti@enneenne.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Matej Zachar <zachar.matej@gmail.com>, netdev@vger.kernel.org
Subject: Re: [DSA] fallback PTP to master port when switch does not support it
Message-ID: <20220526123152.zfkyqjl4iucv2fr6@skbuf>
References: <25688175-1039-44C7-A57E-EB93527B1615@gmail.com>
 <YktrbtbSr77bDckl@lunn.ch>
 <20220405124851.38fb977d@kernel.org>
 <20220407094439.ubf66iei3wgimx7d@skbuf>
 <8b90db13-03ca-3798-2810-516df79d3986@enneenne.com>
 <20220525155536.7kjqwnp6cepmrngr@skbuf>
 <a554a5cd-541c-ebe5-c70e-953d0b8b1b87@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a554a5cd-541c-ebe5-c70e-953d0b8b1b87@enneenne.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 09:45:39AM +0200, Rodolfo Giometti wrote:
> On 25/05/22 17:55, Vladimir Oltean wrote:
> > On Wed, May 25, 2022 at 05:00:24PM +0200, Rodolfo Giometti wrote:
> > > On 07/04/22 11:44, Vladimir Oltean wrote:
> > > > On Tue, Apr 05, 2022 at 12:48:51PM -0700, Jakub Kicinski wrote:
> > > > > On Tue, 5 Apr 2022 00:04:30 +0200 Andrew Lunn wrote:
> > > > > > What i don't like about your proposed fallback is that it gives the
> > > > > > impression the slave ports actually support PTP, when they do not.
> > > > > 
> > > > > +1, running PTP on the master means there is a non-PTP-aware switch
> > > > > in the path, which should not be taken lightly.
> > > > 
> > > > +2, the change could probably be technically done, and there are aspects
> > > > worth discussing, but the goal presented here is questionable and it's
> > > > best to not fool ourselves into thinking that the variable queuing delays
> > > > of the switch are taken into account when reporting the timestamps,
> > > > which they aren't.
> > > > 
> > > > I think that by the time you realize that you need PTP hardware
> > > > timestamping on switch ports but you have a PTP-unaware switch
> > > > integrated *into* your system, you need to go back to the drawing board.
> > > 
> > > IMHO this patch is a great hack but what you say sounds good to me.
> > 
> > How many Ethernet connections are there between the switch and the host?
> 
> It depends how the hardware is designed. However usually the host has an
> ethernet connected to a switch's port named CPU port, so just one.
> 
> > One alternative which requires no code changes is to connect one more
> > switch port and run PTP at your own risk on the attached FEC port
> > (not DSA master).
> 
> I see, but here we are talking about of not-so-well designed boards :( whose
> have a switch that can't manage PTP and we still need to have a sort of time
> sync. The trick can be to forward PTP packets to the host's ethernet (and
> viceversa).
> 
> > What switch driver is it? There are 2 paths to be discussed.
> > On TX, does the switch forward DSA-untagged packets from the host port? Where to?
> > On RX, does the switch tag all packets with a DSA header towards the
> > host? I guess yes,
> 
> Of course it's in charge of the DSA to properly setup the switch in order to
> abstract all switch's ports as host's ethernet ports, so all packets go
> where they have to go.

It's a trick alright, but whom is it tricking? The user sees that netdev
X has a PHC and reports hardware timestamping, so he has no way of
knowing that packets aren't timestamped at the point where the MAC of
said netdev puts the frame's SFD on the wire. There's a reason why
hardware timestamping is taken at that point and not earlier.
Run an iperf3 at the same time as your PTP timestamping and you'll see why, too.
Or a shaper on the switch port.

Is hardware timestamping on the master better than no hardware
timestamping at all? Probably, maybe, sometimes. Does it work except
when it's sunny outside? No. Is it a lie to present a braindead solution
to the user in the exact same way as a proper solution would look? Yes,
no one will look at the device tree and say "oh, yes, it has the
allow-ptp-fallback property, I'm well aware that this is a hack".

My point is that not all hacks are meant to be part of the mainline
kernel, _especially_ if they are disingenuous.

> > but in that case, be aware that not many Ethernet
> > controllers can timestamp non-PTP packets. And you need anyway to demote
> > e.g. HWTSTAMP_FILTER_PTP_V2_EVENT to HWTSTAMP_FILTER_ALL when you pass
> > the request to the master to account for that, which you are not doing.
> 
> Mmm... I can't see problems here... can you please explain it?

HWTSTAMP_FILTER_PTP_V2_EVENT means "please timestamp PTP event packets,
L2 and L4". DSA-tagged PTP packets are not PTP packets as far as the
master is concerned, because the DSA header obfuscates the real
encapsulated protocol. So when you forward the request to the master,
you need to tell it to timestamp everything (and it may not be able to
do that).

By the way there's another problem with this approach. Your PTP packets
probably reach the DSA master by flooding. If the switch is going to
participate in the PTP network, it means that SYNC packets coming from
an external station A acting as GM will be flooded not only to the DSA
master, but also to the other stations B. But ptp4l running on the local
DSA switch as a boundary clock also generates SYNC packets of its own on
the ports that are in the MASTER state.
By flooding the SYNC packets of A, station B effectively sees SYNC
packets from multiple masters and gets confused about whom it should track.

The expected behavior is to install trap-to-CPU rules for PTP packets
when timestamping is enabled on a switch port. See commit 96ca08c05838
("net: mscc: ocelot: set up traps for PTP packets") for example.
You are not doing that, because you just forward the timestamping ioctls
to the master. So PTP support will be very buggy.

> > > However we can modify the patch in order to leave the default behavior as-is
> > > but adding the ability to enable this hack via DTS flag as follow:
> > > 
> > >                  ports {
> > >                          #address-cells = <1>;
> > >                          #size-cells = <0>;
> > > 
> > >                          port@0 {
> > >                                  reg = <0>;
> > >                                  label = "lan1";
> > >                                  allow-ptp-fallback;
> > >                          };
> > > 
> > >                          port@1 {
> > >                                  reg = <1>;
> > >                                  label = "lan2";
> > >                          };
> > > 
> > >                          ...
> > > 
> > >                          port@5 {
> > >                                  reg = <5>;
> > >                                  label = "cpu";
> > >                                  ethernet = <&fec>;
> > > 
> > >                                  fixed-link {
> > >                                          speed = <1000>;
> > >                                          full-duplex;
> > >                                  };
> > >                          };
> > >                  };
> > > 
> > > Then the code can do as follow:
> > > 
> > > static int dsa_slave_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
> > > {
> > >          struct dsa_slave_priv *p = netdev_priv(dev);
> > >          struct dsa_switch *ds = p->dp->ds;
> > >          int port = p->dp->index;
> > >          struct net_device *master = dsa_slave_to_master(dev);
> > > 
> > >          /* Pass through to switch driver if it supports timestamping */
> > >          switch (cmd) {
> > >          case SIOCGHWTSTAMP:
> > >                  if (ds->ops->port_hwtstamp_get)
> > >                          return ds->ops->port_hwtstamp_get(ds, port, ifr);
> > >                  if (p->dp->allow_ptp_fallback && master->netdev_ops->ndo_do_ioctl)
> > >                          return master->netdev_ops->ndo_do_ioctl(master, ifr, cmd);
> > >                  break;
> > >          case SIOCSHWTSTAMP:
> > >                  if (ds->ops->port_hwtstamp_set)
> > >                          return ds->ops->port_hwtstamp_set(ds, port, ifr);
> > >                  if (p->dp->allow_ptp_fallback && master->netdev_ops->ndo_do_ioctl)
> > >                          return master->netdev_ops->ndo_do_ioctl(master, ifr, cmd);
> > >                  break;
> > >          }
> > > 
> > >          return phylink_mii_ioctl(p->dp->pl, ifr, cmd);
> > > }
> > > 
> > > In this manner the default behavior is to return error if the switch doesn't
> > > support the PTP functions, but developers can intentionally enable the PTP
> > > fallback on specific ports only in order to be able to use PTP on buggy
> > > hardware.
> > > 
> > > Can this solution be acceptable?
> > 
> > Generally we don't allow policy configuration through the device tree.
> 
> I agree, but here we have to signal an hardware that can't do something and
> (IMHO) the device tree is a good point to address it. :)

You already know the driver can't do it because it doesn't implement the
timestamping ioctls. In fact you didn't answer my previous question of
what hardware this is. I'm curious if PTP support is really absent.
