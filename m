Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB7E190064
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgCWVcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:32:31 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:33598 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgCWVcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 17:32:31 -0400
Received: by mail-wr1-f47.google.com with SMTP id a25so19039308wrd.0
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 14:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=greyhouse-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=37rpULBqOtvJeXsKanCdUi/mhHcfOFfuviH6aQLBoD0=;
        b=R1WyNOmOnNVQGRhWhAK+5E9FgAwz11ZvOat8EY4ChYI5GQGq47F90UZScZ4w3ZM99N
         5YH4KNvMubkG9K20yZFkg1HW04ANkoohY4V16Q2s2cvDq/n+skNE3SaNDB+u21b74jEL
         N686s5MoUcCMwGDtWYQn2A2YDFdIylR6s7DxefI38vVTHMv2sMtIJZZ4biFFUNn8Ty3O
         faJLDrIeBfVZXjpBfOdv7CAwC2FNLkGjbP+XX5+TeiBt3aKyLtblNeNENgu0dRQt7Pqm
         o6vSKB3CwYiySwkJcBtK1JsrgRQbdPiiC6jZbjRB0tsNzAMZc1W5rL+0MrMLP2jsWF4d
         tNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=37rpULBqOtvJeXsKanCdUi/mhHcfOFfuviH6aQLBoD0=;
        b=tByUu0tx6/gM83egxnb70XYVmvQv/lolsWRe2hSRAanTXYeUFZwb+HNqgAWoS2pRge
         1qJRvgPKfTSY2OtPLUOyeh2PgmzV2q1nayl2M3w4SxajsyIw+jaRo9BxeZhFpKkWcJtD
         at2jxNQRqhcetEp9C2pMMwVfEU+mPyp5v3K6MqF5dgSsbqdeBMHgq5xQ1EELYwrUi6LM
         1gx1yln9ooFnXodka6JT5Sct3NJw6poFDrLwM6ot9VI7J5O6RYvPABM8kU6Cf9Y04cqU
         8gXRuasCMrYNdQmEHsW4jgMKw5OC6W86lz7NHOU117rEa+xuNfj2Alc46wM0+El+YGfU
         Dp5w==
X-Gm-Message-State: ANhLgQ0Pa8cXg2HJere2sVCrcLzaI8+OKM/MSx+bQFEPqHSze4JDuB+U
        t/BA0K4KMfcXqkblMG3wRcyncw==
X-Google-Smtp-Source: ADFU+vsNd+PHI0aKpC+0SvC9Lw99E3gJfa/rTnK9E4SnLd7pGHrgqOIfnCDVqgN64eSRVVF5Zv/GhA==
X-Received: by 2002:adf:80af:: with SMTP id 44mr32865692wrl.241.1584999147581;
        Mon, 23 Mar 2020 14:32:27 -0700 (PDT)
Received: from C02YVCJELVCG.greyhouse.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id h26sm1247381wmb.19.2020.03.23.14.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 14:32:26 -0700 (PDT)
Date:   Mon, 23 Mar 2020 17:32:19 -0400
From:   Andy Gospodarek <andy@greyhouse.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, parav@mellanox.com, yuvalav@mellanox.com,
        jgg@ziepe.ca, saeedm@mellanox.com, leon@kernel.org,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        moshe@mellanox.com, ayal@mellanox.com, eranbe@mellanox.com,
        vladbu@mellanox.com, kliteyn@mellanox.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, tariqt@mellanox.com,
        oss-drivers@netronome.com, snelson@pensando.io,
        drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, magnus.karlsson@intel.com
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200323213219.GC21532@C02YVCJELVCG.greyhouse.net>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[Sorry to do this, but I'm going to reply to a few different parts in
different messages.  I'm a bit late to the party and there's lots that
has already been worked out, but I want to address some of those in
detail.  Thanks to Jiri et al at Mellanox for starting this detailed
thread and sharing with the community.]

On Fri, Mar 20, 2020 at 02:25:08PM -0700, Jakub Kicinski wrote:
> On Fri, 20 Mar 2020 08:35:55 +0100 Jiri Pirko wrote:
> > Fri, Mar 20, 2020 at 04:32:53AM CET, kuba@kernel.org wrote:
> > >On Thu, 19 Mar 2020 20:27:19 +0100 Jiri Pirko wrote:  
> > >> 
> > >> ==================================================================
> > >> ||                                                              ||
> > >> ||                             PFs                              ||
> > >> ||                                                              ||
> > >> ==================================================================
> > >> 
> > >> There are 2 flavours of PFs:
> > >> 1) Parent PF. That is coupled with uplink port. The slice flavour is
> > >>    therefore "physical", to be in sync of the flavour of the uplink port.
> > >>    In case this Parent PF is actually a leg of upstream embedded switch,
> > >>    the slice flavour is "virtual" (same as the port flavour).
> > >> 
> > >>    $ devlink port show
> > >>    pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1 slice 0
> > >> 
> > >>    $ devlink slice show
> > >>    pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
> > >> 
> > >>    This slice is shown in both "switchdev" and "legacy" modes.
> > >> 
> > >>    If there is another parent PF, say "0000:06:00.1", that share the
> > >>    same embedded switch, the aliasing is established for devlink handles.
> > >> 
> > >>    The user can use devlink handles:
> > >>    pci/0000:06:00.0
> > >>    pci/0000:06:00.1
> > >>    as equivalents, pointing to the same devlink instance.
> > >> 
> > >>    Parent PFs are the ones that may be in control of managing
> > >>    embedded switch, on any hierarchy level.
> > >> 
> > >> 2) Child PF. This is a leg of a PF put to the parent PF. It is
> > >>    represented by a slice, and a port (with a netdevice):
> > >> 
> > >>    $ devlink port show
> > >>    pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1 slice 0
> > >>    pci/0000:06:00.0/1: flavour pcipf pfnum 2 type eth netdev enp6s0f0pf2 slice 20
> > >> 
> > >>    $ devlink slice show
> > >>    pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
> > >>    pci/0000:06:00.0/20: flavour pcipf pfnum 1 port 1 hw_addr aa:bb:cc:aa:bb:87 state active  <<<<<<<<<<
> > >> 
> > >>    This is a typical smartnic scenario. You would see this list on
> > >>    the smartnic CPU. The slice pci/0000:06:00.0/20 is a leg to
> > >>    one of the hosts. If you send packets to enp6s0f0pf2, they will
> > >>    go to he host.
> > >> 
> > >>    Note that inside the host, the PF is represented again as "Parent PF"
> > >>    and may be used to configure nested embedded switch.  
> > >
> > >This parent/child PF I don't understand. Does it stem from some HW
> > >limitations you have?  
> > 
> > No limitation. It's just a name for 2 roles. I didn't know how else to
> > name it for the documentation purposes. Perhaps you can help me.
> > 
> > The child can simply manage a "nested eswich". The "parent eswitch"
> > would see one leg (pf representor) one way or another. Only in case the
> > "nested eswitch" is there, the child would manage it - have separate
> > representors for vfs/sfs under its devlink instance.
> 
> I see! I wouldn't use the term PF. I think we need a notion of 
> a "virtual" port within the NIC to model the eswitch being managed 
> by the Host.
> 
> If Host manages the Eswitch - SmartNIC will no longer deal with its
> PCIe ports, but only with its virtual uplink.
> 

We have been referencing these as PFs for a while but without any
in-kernel way to differentiate between what you describe as a
parent/child relationship.  The terminology someone came up with was the
notion of referring to these as "PF Pairs" when all traffic on a
SmartNIC goes to a particular PF on a host.

This is partly because in the nominal case when our SmartNIC is booted
the eSwitch is configured so that traffic is passed to the proper PF
based on the destination MAC of the traffic.  Here is a dump of the
interfaces on the smartnic side and server side for a 2 port card:

[root@smartnic ~]# ip li sh | grep enp -A 1 
2: enP8p1s0f0np0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group de0
    link/ether 00:0a:f7:ac:cf:a0 brd ff:ff:ff:ff:ff:ff
3: enP8p1s0f1np1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group de0
    link/ether 00:0a:f7:ac:cf:a1 brd ff:ff:ff:ff:ff:ff
4: enP8p1s0f2np0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT grou0
    link/ether 00:0a:f7:ac:cf:a2 brd ff:ff:ff:ff:ff:ff
5: enP8p1s0f3np1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT grou0
    link/ether 00:0a:f7:ac:cf:a3 brd ff:ff:ff:ff:ff:ff

root@server:~# ip li sh | grep enp -A 1 
2: enp1s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 00:0a:f7:ac:cf:a8 brd ff:ff:ff:ff:ff:ff
3: enp1s0f1d1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:0a:f7:ac:cf:a9 brd ff:ff:ff:ff:ff:ff
4: enp1s0f2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:0a:f7:ac:cf:aa brd ff:ff:ff:ff:ff:ff
5: enp1s0f3d1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:0a:f7:ac:cf:ab brd ff:ff:ff:ff:ff:ff

So while it might not make sense at first to have less physical
interfaces than PFs on the server or smartnic this gives flexibility to
have a PF on the server side that does have direct network connectivity
so that traffic destined to MAC address 00:0a:f7:ac:cf:a8 will go
directly to enp1s0f0 when it comes off the wire or from other PFs on the
server or smartnic.

We can also essentially 'lock out' PFs from being able to access the
physical ports if we want.  When that is done then the parent/child
relationship would be what you would describe and we would match up

enP8p1s0f2np0 (smartnic) <---> enp1s0f0 (server)
and
enP8p1s0f3np1 (smartnic) <---> enp1s0f1d1 (server)

and delete enp1s0f2 and enp1s0f3d1 on the server.

In this case PF0 and PF1 (enP8p1s0f0np0 and enP8p1s0f1np1) on the
smartnic effectively become the physical ports as there would be no
other 'ports' on the eswitch that are in the same broadcast domain.

I'm sure it comes as no surprise to anyone, but we also have the idea
that VFs can be paired in similar ways to PFs.  Practically speaking,
however, there is not much of a reason to use VFs on the SmartNIC
without VMs on the SmartNIC unless you are using this same parent/child
relationship.  Are you proposing that this will also be an option?

One point is that we also find is that generally customers are not super
interested in having these changed in real-time.  I do LOVE the idea of
being able to query this information via devlink however, so let's keep
that rolling and if people want them to be real PCI b/d/f I think that
should be allowed.

