Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70601195B4A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 17:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgC0Qid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 12:38:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbgC0Qid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 12:38:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88E8B206E6;
        Fri, 27 Mar 2020 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585327112;
        bh=deDTuu1jzjGnbi3OJe4c7nZIxvdzsPnwdEoPIN4Iu3s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jLprVHeO0FqbudliDyQijNJeIKcCwAXsRIKOclD81V6rf1a2bbqrksM4/YIN/EWXa
         yyaAiSUNAl1a5EEBChZL6YiUyaikgMhryHulWOG8SwKHDgAVdM8ZPFzBnsp0AqQ2Yt
         Hbht/cTZfxWoWJmXgFDKdl5KXIsY00kacnf/efFc=
Date:   Fri, 27 Mar 2020 09:38:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, parav@mellanox.com,
        yuvalav@mellanox.com, jgg@ziepe.ca, saeedm@mellanox.com,
        leon@kernel.org, andrew.gospodarek@broadcom.com,
        michael.chan@broadcom.com, moshe@mellanox.com, ayal@mellanox.com,
        eranbe@mellanox.com, vladbu@mellanox.com, kliteyn@mellanox.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        tariqt@mellanox.com, oss-drivers@netronome.com,
        snelson@pensando.io, drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, magnus.karlsson@intel.com
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200327074736.GJ11304@nanopsycho.orion>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Mar 2020 08:47:36 +0100 Jiri Pirko wrote:
> >So the queues, interrupts, and other resources are also part 
> >of the slice then?  
> 
> Yep, that seems to make sense.
> 
> >How do slice parameters like rate apply to NVMe?  
> 
> Not really.
> 
> >Are ports always ethernet? and slices also cover endpoints with
> >transport stack offloaded to the NIC?  
> 
> devlink_port now can be either "ethernet" or "infiniband". Perhaps,
> there can be port type "nve" which would contain only some of the
> config options and would not have a representor "netdev/ibdev" linked.
> I don't know.

I honestly find it hard to understand what that slice abstraction is,
and which things belong to slices and which to PCI ports (or why we even
have them).

With devices like NFP and Mellanox CX3 which have one PCI PF maybe it
would have made sense to have a slice that covers multiple ports, but
it seems the proposal is to have port to slice mapping be 1:1. And rate
in those devices should still be per port not per slice.

But this keeps coming back, and since you guys are doing all the work,
if you really really need it..
