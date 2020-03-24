Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6CD9190F8F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgCXNUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:20:53 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37193 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728966AbgCXNUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 09:20:52 -0400
Received: by mail-qk1-f193.google.com with SMTP id x3so7592482qki.4
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 06:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4R8qSVTBNNHdFHDNVrbWEN3e/oAFsZ7M/WE+NPN40eo=;
        b=dAR3M3rPoWwLhMS6bdiPfzw7v7jr3TwqqezLwj4wkLB2LX8cMkXjAFiwJHdhu4P3qE
         tt4hu5n607bT0IjzEPCVcwMgrhdshwVVpV/OtAMx+pewsgg2J06qCUzcwW69tdJTlzK7
         Arq3exap+B9mDapLSLyM+7XNgF3LlkXwGvjTOqE+Y739ZLE869V0izZfFp+JtjrTSFcU
         LxXFJnWgq3jeHfj0nypBMhft6QpPebyNraeoDomhuU1j20SvAQA+1n4a74k+Uq0eLb5m
         aN64hPI3tJShboDvikzOXWAsYf/cxwNKirtTFhVUMJIS4bZWKA4GNCpZ4+I8PNnHEz+X
         HSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4R8qSVTBNNHdFHDNVrbWEN3e/oAFsZ7M/WE+NPN40eo=;
        b=SX2gcgOsx5OnzALTAbzoSJfs2fPeKaJbydmzO3KHNalcgNFXN1BWU4SyGcBA/xPrce
         PEG/4DX06tWpJCebOZ/+02ecteBPhmniVJ/MWPnlINxrEhzPk7k/tLd1oxpWG8XWqwDE
         3MB2bzzwENv/9N2bl6dUvZWSBWWA2MCjtDLSUnor5FVqdI/IRK9dfSXOULmD2+cYi3b5
         dt3zEBhc2spIrck2RXifTSHFSo8zJhUZAMceX3K3S5YW9CrSe2uEDTCsHwN2cXIiGIxG
         Bo/+ip4HycZlQrapNGn4u6eSUhJ37PrdyfeWROzEV7vEHQEVdlRc50XoSDNBoYJth2Vb
         HA8Q==
X-Gm-Message-State: ANhLgQ3U5EPoHfLCfr1hBWm4pxGNxQrbX98rCr/oszrUtRYwT9kbxXQG
        MuxB9yPgV1hOZoz2oslIZl9XRg==
X-Google-Smtp-Source: ADFU+vu0PONrlLa6lKdUyLPhin05s/vNsZkrmFTNA6w2C48eTxB6ardHyu5381DXZoAJUDgo+Twceg==
X-Received: by 2002:a05:620a:84d:: with SMTP id u13mr25686494qku.94.1585056046270;
        Tue, 24 Mar 2020 06:20:46 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d2sm1531258qkl.98.2020.03.24.06.20.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Mar 2020 06:20:45 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jGjU4-0002IK-RG; Tue, 24 Mar 2020 10:20:44 -0300
Date:   Tue, 24 Mar 2020 10:20:44 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, parav@mellanox.com, yuvalav@mellanox.com,
        saeedm@mellanox.com, leon@kernel.org,
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
Message-ID: <20200324132044.GI20941@ziepe.ca>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200323220605.GE20941@ziepe.ca>
 <20200323205619.2f957f1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323205619.2f957f1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 08:56:19PM -0700, Jakub Kicinski wrote:
> On Mon, 23 Mar 2020 19:06:05 -0300 Jason Gunthorpe wrote:
> > On Mon, Mar 23, 2020 at 12:21:23PM -0700, Jakub Kicinski wrote:
> > > > >I see so you want the creation to be controlled by the same entity that
> > > > >controls the eswitch..
> > > > >
> > > > >To me the creation should be on the side that actually needs/will use
> > > > >the new port. And if it's not eswitch manager then eswitch manager
> > > > >needs to ack it.    
> > > > 
> > > > Hmm. The question is, is it worth to complicate things in this way?
> > > > I don't know. I see a lot of potential misunderstandings :/  
> > > 
> > > I'd see requesting SFs over devlink/sysfs as simplification, if
> > > anything.  
> > 
> > We looked at it for a while, working the communication such that the
> > 'untrusted' side could request a port be created with certain
> > parameters and the 'secure eswitch' could know those parameters to
> > authorize and wire it up was super complicated and very hard to do
> > without races.
> > 
> > Since it is a security sensitive operation it seems like a much more
> > secure design to have the secure side do all the creation and present
> > the fully operational object to the insecure side.
> > 
> > To draw a parallel to qemu & kvm, the untrusted guest VM can't request
> > that qemu create a virtio-net for it. Those are always hot plugged in
> > by the secure side. Same flow here.
> 
> Could you tell us a little more about the races? Other than the
> communication channel what changes between issuing from cloud API
> vs devlink?

If I recall the problems came when trying to work with existing cloud
infrastructure that doesn't assume this operating model. You need to
somehow adapt an async APIs of secure/insecure communication with an
async API inside the cloud world. It was a huge mess.

> Side note - there is no communication channel between VM and hypervisor
> right now, which is the cause for weird designs e.g. the failover/auto
> bond mechanism.

Right, and considering the security concerns building one hidden
inside a driver seems like a poor idea..

> > The VF model is poor because the VF is just a dummy stub until the
> > representor/eswitch side is fully configured. There is no way for the
> > Linux driver to know if the VF is operational or not, so we get weird
> > artifacts where we sometimes bind a driver to a VF (and get a
> > non-working ethXX) and sometimes we don't. 
> 
> Sounds like an implementation issue :S

How so?

> > The only reason it is like this is because of how SRIOV requires
> > everything to be preallocated.
> 
> SF also requires pre-allocated resources, so you're not talking about
> PCI mem space etc. here I assume.

It isn't pre-allocated, the usage of the BAR space is dynamic.

> > The SFs can't even exist until they are configured, so there is no
> > state where a driver is connected to an inoperative SF.
> 
> You mean it doesn't exist in terms of sysfs device entry?

I mean literally do not exist at the HW level.

Jason
