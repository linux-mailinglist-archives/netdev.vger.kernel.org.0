Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E922DA5DB
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 02:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbgLOByf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 20:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgLOBy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 20:54:27 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6FCC0617A6;
        Mon, 14 Dec 2020 17:53:46 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id n4so18920808iow.12;
        Mon, 14 Dec 2020 17:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S8foV+uFVBLRcTv1clMz6DeBVA+omVBwR16In0ogmE0=;
        b=mt9RiGT+cvqvmXuZW5If26mCQ9bLCkuBuqtoHDQYbpC222F1KPK7i5h6YY3jrYX9g3
         hH4yJcrrnasy5d6ngNkeM8NuvHlrd6VRerXk+wIa2hn53VMNOnWWBTeC1OC127kEeO+U
         fSh3qOkoHIxF0t3A/qRlQU7gGjn+HTHfcrf+ZotcXaqOt1dT9Kozijkx3VWle6ulIMN/
         577bfT/43/hU8ApwfoPYllC52oemGrl+EAzoA5WXlT87Vi3MVPCcUgI548VvGzwOVz4m
         Xd5sJ2MNKfundCPUk2STHOZoyOY/1Ppky1a5P3OhgUUE1/kJ4JAy+nlEegtK9rse6m/g
         kpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S8foV+uFVBLRcTv1clMz6DeBVA+omVBwR16In0ogmE0=;
        b=ry/LVlfJOsUabKomaEbQ/jKDsAdP91A722yfX36Csgt9pcWYQggqG98ORUDgzJzTmH
         RsIDoF0U1MtUHT6hnxbJopnJ+6QDJUOw+JTZRwr/8ouB/prmQDP+9LIU8n/TRRyavQsQ
         6/vpXfstb7JG3Tb9MH1Cpfh7Z6NTQEi9DkDHYOzPioRt9adWU+ODsfSDTodulGSY3YYE
         KJo75a0t8FQCuUYKjx6IxEB34vsHlTdzwh7H+A0EsGFlo//9q30RWLDrPZAzfZGw3Wqa
         COReEREr6AEqni5RoiLsn/HEn/D58ra8dQ8w6KOgI3Txl9QG+mnRVuiY/LjSjN+2t41V
         xY/A==
X-Gm-Message-State: AOAM530zKsfaBSqaLGtK211SWAarn85qHs3lXB+fnGo/F2g1Ob3fI60A
        PeEYs50x1O/7bizE7g8Ry5q4tqgSHlLMjYd39ak=
X-Google-Smtp-Source: ABdhPJwaRyyQQ3lpYwTJni8yZZWN7AVZ9detD7MVMapdzRW4vB1YfFH8DA9y6RuDdeTUZDkVJ8gExPCCJNosoqo2lh0=
X-Received: by 2002:a05:6602:152:: with SMTP id v18mr35631735iot.187.1607997225910;
 Mon, 14 Dec 2020 17:53:45 -0800 (PST)
MIME-Version: 1.0
References: <20201214214352.198172-1-saeed@kernel.org>
In-Reply-To: <20201214214352.198172-1-saeed@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 14 Dec 2020 17:53:34 -0800
Message-ID: <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 1:49 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> Hi Dave, Jakub, Jason,
>
> This series form Parav was the theme of this mlx5 release cycle,
> we've been waiting anxiously for the auxbus infrastructure to make it into
> the kernel, and now as the auxbus is in and all the stars are aligned, I
> can finally submit this V2 of the devlink and mlx5 subfunction support.
>
> Subfunctions came to solve the scaling issue of virtualization
> and switchdev environments, where SRIOV failed to deliver and users ran
> out of VFs very quickly as SRIOV demands huge amount of physical resources
> in both of the servers and the NIC.
>
> Subfunction provide the same functionality as SRIOV but in a very
> lightweight manner, please see the thorough and detailed
> documentation from Parav below, in the commit messages and the
> Networking documentation patches at the end of this series.
>

Just to clarify a few things for myself. You mention virtualization
and SR-IOV in your patch description but you cannot support direct
assignment with this correct? The idea here is simply logical
partitioning of an existing network interface, correct? So this isn't
so much a solution for virtualization, but may work better for
containers. I view this as an important distinction to make as the
first thing that came to mind when I read this was mediated devices
which is similar, but focused only on the virtualization case:
https://www.kernel.org/doc/html/v5.9/driver-api/vfio-mediated-device.html

> Parav Pandit Says:
> =================
>
> This patchset introduces support for mlx5 subfunction (SF).
>
> A subfunction is a lightweight function that has a parent PCI function on
> which it is deployed. mlx5 subfunction has its own function capabilities
> and its own resources. This means a subfunction has its own dedicated
> queues(txq, rxq, cq, eq). These queues are neither shared nor stealed from
> the parent PCI function.

Rather than calling this a subfunction, would it make more sense to
call it something such as a queue set? It seems like this is exposing
some of the same functionality we did in the Intel drivers such as
ixgbe and i40e via the macvlan offload interface. However the
ixgbe/i40e hardware was somewhat limited in that we were only able to
expose Ethernet interfaces via this sort of VMQ/VMDQ feature, and even
with that we have seen some limitations to the interface. It sounds
like you are able to break out RDMA capable devices this way as well.
So in terms of ways to go I would argue this is likely better. However
one downside is that we are going to end up seeing each subfunction
being different from driver to driver and vendor to vendor which I
would argue was also one of the problems with SR-IOV as you end up
with a bit of vendor lock-in as a result of this feature since each
vendor will be providing a different interface.

> When subfunction is RDMA capable, it has its own QP1, GID table and rdma
> resources neither shared nor stealed from the parent PCI function.
>
> A subfunction has dedicated window in PCI BAR space that is not shared
> with ther other subfunctions or parent PCI function. This ensures that all
> class devices of the subfunction accesses only assigned PCI BAR space.
>
> A Subfunction supports eswitch representation through which it supports tc
> offloads. User must configure eswitch to send/receive packets from/to
> subfunction port.
>
> Subfunctions share PCI level resources such as PCI MSI-X IRQs with
> their other subfunctions and/or with its parent PCI function.

This piece to the architecture for this has me somewhat concerned. If
all your resources are shared and you are allowing devices to be
created incrementally you either have to pre-partition the entire
function which usually results in limited resources for your base
setup, or free resources from existing interfaces and redistribute
them as things change. I would be curious which approach you are
taking here? So for example if you hit a certain threshold will you
need to reset the port and rebalance the IRQs between the various
functions?

> Patch summary:
> --------------
> Patch 1 to 4 prepares devlink
> patch 5 to 7 mlx5 adds SF device support
> Patch 8 to 11 mlx5 adds SF devlink port support
> Patch 12 and 14 adds documentation
>
> Patch-1 prepares code to handle multiple port function attributes
> Patch-2 introduces devlink pcisf port flavour similar to pcipf and pcivf
> Patch-3 adds port add and delete driver callbacks
> Patch-4 adds port function state get and set callbacks
> Patch-5 mlx5 vhca event notifier support to distribute subfunction
>         state change notification
> Patch-6 adds SF auxiliary device
> Patch-7 adds SF auxiliary driver
> Patch-8 prepares eswitch to handler SF vport
> Patch-9 adds eswitch helpers to add/remove SF vport
> Patch-10 implements devlink port add/del callbacks
> Patch-11 implements devlink port function get/set callbacks
> Patch-12 to 14 adds documentation
> Patch-12 added mlx5 port function documentation
> Patch-13 adds subfunction documentation
> Patch-14 adds mlx5 subfunction documentation
>
> Subfunction support is discussed in detail in RFC [1] and [2].
> RFC [1] and extension [2] describes requirements, design and proposed
> plumbing using devlink, auxiliary bus and sysfs for systemd/udev
> support. Functionality of this patchset is best explained using real
> examples further below.
>
> overview:
> --------
> A subfunction can be created and deleted by a user using devlink port
> add/delete interface.
>
> A subfunction can be configured using devlink port function attribute
> before its activated.
>
> When a subfunction is activated, it results in an auxiliary device on
> the host PCI device where it is deployed. A driver binds to the
> auxiliary device that further creates supported class devices.
>
> example subfunction usage sequence:
> -----------------------------------
> Change device to switchdev mode:
> $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
>
> Add a devlink port of subfunction flaovur:
> $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88

Typo in your description. Also I don't know if you want to stick with
"flavour" or just shorten it to the U.S. spelling which is "flavor".

> Configure mac address of the port function:
> $ devlink port function set ens2f0npf0sf88 hw_addr 00:00:00:00:88:88
>
> Now activate the function:
> $ devlink port function set ens2f0npf0sf88 state active
>
> Now use the auxiliary device and class devices:
> $ devlink dev show
> pci/0000:06:00.0
> auxiliary/mlx5_core.sf.4
>
> $ ip link show
> 127: ens2f0np0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether 24:8a:07:b3:d1:12 brd ff:ff:ff:ff:ff:ff
>     altname enp6s0f0np0
> 129: p0sf88: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether 00:00:00:00:88:88 brd ff:ff:ff:ff:ff:ff>

I assume that p0sf88 is supposed to be the newly created subfunction.
However I thought the naming was supposed to be the same as what you
are referring to in the devlink, or did I miss something?

> $ rdma dev show
> 43: rdmap6s0f0: node_type ca fw 16.29.0550 node_guid 248a:0703:00b3:d112 sys_image_guid 248a:0703:00b3:d112
> 44: mlx5_0: node_type ca fw 16.29.0550 node_guid 0000:00ff:fe00:8888 sys_image_guid 248a:0703:00b3:d112
>
> After use inactivate the function:
> $ devlink port function set ens2f0npf0sf88 state inactive
>
> Now delete the subfunction port:
> $ devlink port del ens2f0npf0sf88

This seems wrong to me as it breaks the symmetry with the port add
command and assumes you have ownership of the interface in the host. I
would much prefer to to see the same arguments that were passed to the
add command being used to do the teardown as that would allow for the
parent function to create the object, assign it to a container
namespace, and not need to pull it back in order to destroy it.
