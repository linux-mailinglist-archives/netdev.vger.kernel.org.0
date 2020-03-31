Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4F5199CF1
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgCaRc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgCaRc7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 13:32:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A3CC20BED;
        Tue, 31 Mar 2020 17:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585675978;
        bh=cmucYxywLs/6xs12rUx+nY6mPeGMkzSylvOT0+Ni0bQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ALd3h0gqDH4+3aRtlLkhY+BENCirr70yiMl7zzqMRsBBlVMs6h/8rDHwo+ovS0rwy
         OPzyr408N3yR4QWCsx5AblRyP6xhPJ9F/OIgF2PMSzQUOMblUvklK/CZlM5uEatrj4
         fpibrhNu3vtlbMYFBKtD4bj4lolBJqc8KsSfRyaI=
Date:   Tue, 31 Mar 2020 10:32:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200331103255.549ea899@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <50c0f739-592e-77a4-4872-878f99cc8b93@mellanox.com>
References: <20200319192719.GD11304@nanopsycho.orion>
        <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
        <20200320073555.GE11304@nanopsycho.orion>
        <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
        <20200321093525.GJ11304@nanopsycho.orion>
        <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200326144709.GW11304@nanopsycho.orion>
        <20200326145146.GX11304@nanopsycho.orion>
        <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200327074736.GJ11304@nanopsycho.orion>
        <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <35e8353f-2bfc-5685-a60e-030cd2d2dd24@mellanox.com>
        <20200330123623.634739de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <50c0f739-592e-77a4-4872-878f99cc8b93@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Mar 2020 07:45:51 +0000 Parav Pandit wrote:
> > In fact very little belongs to the port in that model. So why have
> > PCI ports in the first place?
> >  
> for few reasons.
> 1. PCI ports are establishing the relationship between eswitch port and
> its representor netdevice.
> Relying on plain netdev name doesn't work in certain pci topology where
> netdev name exceeds 15 characters.
> 2. health reporters can be at port level.

Why? The health reporters we have not AFAIK are for FW and for queues
hanging. Aren't queues on the slice and FW on the device?

> 3. In future at eswitch pci port, I will be adding dpipe support for the
> internal flow tables done by the driver.
> 4. There were inconsistency among vendor drivers in using/abusing
> phys_port_name of the eswitch ports. This is consolidated via devlink
> port in core. This provides consistent view among all vendor drivers.
> 
> So PCI eswitch side ports are useful regardless of slice.
> 
> >> Additionally devlink port object doesn't go through the same state
> >> machine as that what slice has to go through.
> >> So its weird that some devlink port has state machine and some doesn't.  
> > 
> > You mean for VFs? I think you can add the states to the API.
> >   
> As we agreed above that eswitch side objects (devlink port and
> representor netdev) should not be used for 'portion of device',

We haven't agreed, I just explained how we differ.
