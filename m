Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1262A1085E1
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 01:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfKYAJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 19:09:21 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43758 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfKYAJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 19:09:21 -0500
Received: by mail-qk1-f193.google.com with SMTP id p14so11200794qkm.10
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 16:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eisALaIH/ftQxCyio3ruokW4EdLzz1qLCdRAk4n2mxk=;
        b=HJh4oTl49ORQ3kXH4DqOVo3mz0ZYE9TzJoVgaSC3T2+4R3LJgobeJDPcxtXpWx+0GO
         2bTMKm1EtGxIdynhAae3LPl9Y5A7jN7fHh356ze9TG2XwxWe/E6USctkJ1jZRZeCgApl
         NacxAbArirS8KYsTdpASE08An0ZvVFRynLAgbJ7WlSfk8W/OPpwexbGA4Pfe6DP+K+nm
         pomKjg/LR3t0bl803SofHt1Zg14zST7F4Z5NYxOHcl81E3lhadrVRAjTbksVNFVSjH5z
         +1GRMr4nX3PWz0H7cxrf6dvRB9sU4emUVh1I/GKNYwpxYYd1kZTV5858v4l4RfM6dop0
         GqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eisALaIH/ftQxCyio3ruokW4EdLzz1qLCdRAk4n2mxk=;
        b=gieIdiR5L1I7+q3BEgk8/WchmAos9SFFRljLY+2IDgCx4i4ZEVqzXpkZjmbm1QGovA
         Jt0tVuxdgOJaUNy+gswgqsYkt9F9wXHbfISnh9px5sNPuh6L1UTUp/uKKGECYkSVE7Nt
         EU4VW9rF+e44oe6s1E27aK/WaP+1HlTMmg2Tskou2aJNsb8ZXoVun3XO61j/N4Jycm+l
         7WrE1tZL3g8/jce8hNoC6ZKws5Lr69xBZEzP7Hldh6b4W1VX4AWpEfBycx90FnDMmot6
         2PHfDZvJkxleQVA6I9LSkNRrUm2xDky6qKFsTDf/v219+koALfC/HCkEYKZFgqtYDS2o
         qJBg==
X-Gm-Message-State: APjAAAXe+cg7coRYG+lnBtb+NvbPC0SYinZk/YnnaACTgYiYBq1GwH28
        cW62CUdomXgqc53E1LjUMKCpTg==
X-Google-Smtp-Source: APXvYqzegBpQ+cLMw9AJG7zDPOggSsp9q1VWN3LzjKeejJX0Rbug8aaAWuyEissf0QV8gEVcvrIqRw==
X-Received: by 2002:a37:bd06:: with SMTP id n6mr7698406qkf.286.1574640560478;
        Sun, 24 Nov 2019 16:09:20 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id n19sm2514166qkn.52.2019.11.24.16.09.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 24 Nov 2019 16:09:19 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iZ1wN-0001f6-E3; Sun, 24 Nov 2019 20:09:19 -0400
Date:   Sun, 24 Nov 2019 20:09:19 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191125000919.GB5634@ziepe.ca>
References: <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
 <5dcef4ab-feb5-d116-b2a9-50608784a054@redhat.com>
 <20191121141732.GB7448@ziepe.ca>
 <721e49c2-a2e1-853f-298b-9601c32fcf9e@redhat.com>
 <20191122180214.GD7448@ziepe.ca>
 <20191123043951.GA364267@___>
 <20191123230948.GF7448@ziepe.ca>
 <20191124145124.GA374942@___>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191124145124.GA374942@___>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 24, 2019 at 10:51:24PM +0800, Tiwei Bie wrote:

> > > You removed JasonW's other reply in above quote. He said it clearly
> > > that we do want/need to assign parts of device BAR to the VM.
> > 
> > Generally we don't look at patches based on stuff that isn't in them.
> 
> The hardware is ready, and it's something really necessary (for
> the performance). It was planned to be added immediately after
> current series. If you want, it certainly can be included right now.

I don't think it makes a significant difference, there are enough
reasons already that this does not belong in vfio. Both Greg and I
already were very against using mdev as an alterative to the driver
core.

> > > IIUC, your point is to suggest us invent new DMA API for userspace to
> > > use instead of leveraging VFIO's well defined DMA API. Even if we don't
> > > use VFIO at all, I would imagine it could be very VFIO-like (e.g. caps
> > > for BAR + container/group for DMA) eventually.
> > 
> > None of the other user dma subsystems seem to have the problems you
> > are imagining here. Perhaps you should try it first?
> 
> Actually VFIO DMA API wasn't used at the beginning of vhost-mdev. But
> after the discussion in upstream during the RFC stage since the last
> year, the conclusion is that leveraging VFIO's existing DMA API would
> be the better choice and then vhost-mdev switched to that direction.

Well, unfortunately, I think that discussion may have led you
wrong. Do you have a link? Did you post an ICF driver that didn't use vfio?

Jason
