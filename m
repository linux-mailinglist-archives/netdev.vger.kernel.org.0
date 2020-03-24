Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203ED1903E0
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 04:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgCXDlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 23:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727060AbgCXDlU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 23:41:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75F53205ED;
        Tue, 24 Mar 2020 03:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585021279;
        bh=0LUjcNxmhDIClt7R21WW6KQltpvKDzQpdpYAIY9+0Nw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M1l3gzRYFlu5UKt3aiNZX+P4fD916AR8WImin2dm1w5CCHCl78X796J5DVw98yoMn
         SzUT4TUc4XE8UC5MOEUleOtB+YeffSMFQvFKr2clU18QQiyT47qPOcGxlW782ZLe5s
         Oz76C2TLldUahSQBAAQ+MGWe+07MdmYrLNArx7yY=
Date:   Mon, 23 Mar 2020 20:41:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
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
Message-ID: <20200323204116.7c2f6e46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200323225009.GA1839@ziepe.ca>
References: <20200319192719.GD11304@nanopsycho.orion>
        <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
        <20200320073555.GE11304@nanopsycho.orion>
        <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
        <997dbf25-a3e1-168c-c756-b33e79e7c51e@mellanox.com>
        <20200323123116.769e50e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200323225009.GA1839@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Mar 2020 19:50:09 -0300 Jason Gunthorpe wrote:
> On Mon, Mar 23, 2020 at 12:31:16PM -0700, Jakub Kicinski wrote:
> 
> > Right, that is the point. It's the host admin that wants the new
> > entity, so if possible it'd be better if they could just ask for it 
> > via devlink rather than some cloud API. Not that I'm completely opposed
> > to a cloud API - just seems unnecessary here.  
> 
> The cloud API provides all the permissions checks and security
> elements. It cannot be avoided.

Ack, the question is just who consults the cloud API, the Host or the
SmartNIC (latter would abstract differences between cloud APIs).

> If you try to do it as you say then it is weird. You have to use the
> cloud API to authorize the VM to touch a certain network, then the VM
> has to somehow take that network ID and use devlink to get a netdev
> for it. And the cloud side has to protect against a hostile VM sending
> garbage along this communication channel.

I don't understand how the VM needs to know the network ID, quite the
opposite, the Network ID should be gettable/settable by the hypervisor/
/PF. 

If VF starts requesting nested network IDs those should be in a
separate namespace from the the "outer" ones, no?

> vs simply host plugging in the correct network fully operational when
> the cloud API connects the VM to the network.

That means the user has to pre-allocate the device ID, or query the
cloud API after the device is created about its attributes (in the case
of two interfaces being requested simultaneously).

I don't feel very strongly about this, but given how many Linux
instances run in the cloud it'd seem nice if we had some APIs to meet
their basic needs.
