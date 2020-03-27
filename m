Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9F2196026
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgC0U7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbgC0U7b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 16:59:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAE3F20658;
        Fri, 27 Mar 2020 20:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585342771;
        bh=uEzsS3oNREwJM8i+8B59WhSwRyezZLTRaLoDPECGNzc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KgjTzZOYQCC1K3iNlFbGHzIWE9oNO38lN5yruAwH7rxTPdxGMbjAFIABRnq6ErDxR
         5D7JNVinoSuHni6UqxttNbhNDssYze9hq1w0cKMs3QUQ+9PYFx2l8VRDQTFy1KwOKE
         u889YZgd3NFgXkxJfWX/fjqpb1VwgCRqAbE+DmfY=
Date:   Fri, 27 Mar 2020 13:59:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Tariq Toukan <tariqt@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Alex Vesker <valex@mellanox.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        mlxsw <mlxsw@mellanox.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200327135928.344e45b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <22e86150-925f-0229-3d54-a7d82d504835@intel.com>
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
        <a02cf0e6-98ad-65c4-0363-8fb9d67d2c9c@intel.com>
        <20200327121010.3e987488@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ea8a8434b1db2b692489edfd4abbc2274a77228c.camel@mellanox.com>
        <22e86150-925f-0229-3d54-a7d82d504835@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Mar 2020 13:47:44 -0700 Samudrala, Sridhar wrote:
> >> But the sub-functions are just a subset of slices, PF and VFs also
> >> have a slice associated with them.. And all those things have a port,
> >> too.
> >>  
> > 
> > PFs/VFs, might have more than one port sometimes ..  
> 
> Yes. When the uplink ports are in a LAG, then a PF/VF/slice should be 
> able to send or receive from more than 1 port.

So that's a little simpler to what I was considering, in mlx4 and older
nfps we have 1 PCI PF for multi-port devices. There is only one PF with
multiple BAR regions corresponding to different device ports.

So you can still address fully independently the pipelines for two
ports, but they are "mapped" in the same PCI PF.
