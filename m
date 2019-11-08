Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84856F59BD
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732169AbfKHVVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:21:34 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43920 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731721AbfKHVVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:21:34 -0500
Received: by mail-lf1-f68.google.com with SMTP id f24so2508019lfh.10
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 13:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=4AwusGWH9OPeVecK4a1wDOaOYn+BOlwvafdvQ4PGgJ8=;
        b=hYlaDJxT9HWu175XauIGfsL0We4WuAR8Y0x5qTVPb/INSssphy4iS2Ri2f0X3LQq1E
         9kEj8XywzMJJ/dcTsjjoKo4IxQmFm6c6pp0ENKTu4PnCF4zYE6a2tPPqFHUm2pdERpHP
         o25uR2niArBeDtdoBWi9Dw2/3UzCJQAI8pmSXfoZIkUpslvwXQ+011IcsLehJXHWFH6c
         YzKxhhzu2saaExwe9XcF5I2vubXH/lCGhBbyDHp+TYmbMT9jXSgdE/IplUvi6Dk6pHi4
         FdxHu6/NN1YEqRiQCdssVTNVHhhnw6/poMmLdPGpnFx24bIZIi7rgMTogdSH8vYD4P/q
         M1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=4AwusGWH9OPeVecK4a1wDOaOYn+BOlwvafdvQ4PGgJ8=;
        b=OTm5Kms+e8AC/7uyNd+/zkJrxl5FYbqSZ1PJfeZ8qzrm5ybWoQNK2HZ0TNTIFftKL5
         5/dx9jOS1dRos9aq6uxk7Fk5fN953kRyJ+MG69uRRgbO04z3VNhTzwKi6WH4I+o+dgK2
         Ok8jOadAX+0cY5UmpRH1GNQTEEepzI26Fv7AWfh27tTMYxo+boQLZB8244TXXZLo35Ob
         cMxU5z1nqhsKDfVjskHXUz1k+WyduOAXcTDfv0COBf8SyNiE133fsTa/z/EJKB0HlcUq
         zPqF1uvwO/EjiggzUgxil/7KcHjNA5JPqxYGRdVkH9++wJ1PS1ntK/VwL/d2NuckmKGD
         CHqA==
X-Gm-Message-State: APjAAAVCqDNwkkMZqtWSM3+hH3fIHPZVr92WWEJxVNt/epCTAHW54ndW
        DTYr+NfyAysAr92tIeT0HypxJw==
X-Google-Smtp-Source: APXvYqycFa3kFxVvJ6YknM3rJDdERg7nKNQQ3Wws9W3T5pZ1uy45uMYgaezlORqSsjxwzYhmWrz01Q==
X-Received: by 2002:ac2:51c5:: with SMTP id u5mr8149817lfm.154.1573248090033;
        Fri, 08 Nov 2019 13:21:30 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m62sm3479021lfa.10.2019.11.08.13.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:21:29 -0800 (PST)
Date:   Fri, 8 Nov 2019 13:21:20 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Parav Pandit <parav@mellanox.com>, alex.williamson@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org, netdev@vger.kernel.org,
        saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108132120.510d8b87@cakuba>
In-Reply-To: <20191108194118.GY6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108110640.225b2724@cakuba>
        <20191108194118.GY6990@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 20:41:18 +0100, Jiri Pirko wrote:
> Fri, Nov 08, 2019 at 08:06:40PM CET, jakub.kicinski@netronome.com wrote:
> >On Fri, 8 Nov 2019 13:12:33 +0100, Jiri Pirko wrote:  
> >> Thu, Nov 07, 2019 at 09:32:34PM CET, jakub.kicinski@netronome.com wrote:  
> >> >On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote:    
> >> >> Mellanox sub function capability allows users to create several hundreds
> >> >> of networking and/or rdma devices without depending on PCI SR-IOV support.    
> >> >
> >> >You call the new port type "sub function" but the devlink port flavour
> >> >is mdev.
> >> >
> >> >As I'm sure you remember you nacked my patches exposing NFP's PCI 
> >> >sub functions which are just regions of the BAR without any mdev
> >> >capability. Am I in the clear to repost those now? Jiri?    
> >> 
> >> Well question is, if it makes sense to have SFs without having them as
> >> mdev? I mean, we discussed the modelling thoroughtly and eventually we
> >> realized that in order to model this correctly, we need SFs on "a bus".
> >> Originally we were thinking about custom bus, but mdev is already there
> >> to handle this.  
> >
> >But the "main/real" port is not a mdev in your case. NFP is like mlx4. 
> >It has one PCI PF for multiple ports.  
> 
> I don't see how relevant the number of PFs-vs-uplink_ports is.

Well. We have a slice per external port, the association between the
port and the slice becomes irrelevant once switchdev mode is enabled,
but the queues are assigned statically so it'd be a waste of resources
to not show all slices as netdevs.

> >> Our SFs are also just regions of the BAR, same thing as you have.
> >> 
> >> Can't you do the same for nfp SFs?
> >> Then the "mdev" flavour is enough for all.  
> >
> >Absolutely not. 
> >
> >Why not make the main device of mlx5 a mdev, too, if that's acceptable.
> >There's (a) long precedence for multiple ports on one PCI PF in
> >networking devices, (b) plenty deployed software 
> >which depend on the main devices hanging off the PCI PF directly.
> >
> >The point of mdevs is being able to sign them to VFs or run DPDK on
> >them (map to user space).
> >
> >For normal devices existing sysfs hierarchy were one device has
> >multiple children of a certain class, without a bus and a separate
> >driver is perfectly fine. Do you think we should also slice all serial
> >chips into mdevs if they have multiple lines.
> >
> >Exactly as I predicted much confusion about what's being achieved here,
> >heh :)  
> 
> Please let me understand how your device is different.
> Originally Parav didn't want to have mlx5 subfunctions as mdev. He
> wanted to have them tight to the same pci device as the pf. No
> difference from what you describe you want. However while we thought
> about how to fit things in, how to handle na phys_port_name, how to see
> things in sysfs we came up with an idea of a dedicated bus.

The difference is that there is naturally a main device and subslices
with this new mlx5 code. In mlx4 or nfp all ports are equal and
statically allocated when FW initializes based on port breakout.

Maybe it's the fact I spent last night at an airport but I'm feeling
like I'm arguing about this stronger than I actually care :)

> We took it upstream and people suggested to use mdev bus for this.
> 
> Parav, please correct me if I'm wrong but I don't think where is a plan
> to push SFs into VM or to userspace as Jakub expects, right?

There's definitely a plan to push them to VFs, I believe that was part
of the original requirements, otherwise there'd be absolutely no need
for a bus to begin with.
