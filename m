Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38728104822
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 02:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfKUBiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 20:38:21 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:38869 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKUBiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 20:38:20 -0500
Received: by mail-qv1-f66.google.com with SMTP id q19so772274qvs.5
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 17:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c40M1cst4ML5N7ApczvXgI2sQfbBl98vL2Dm1XX73oQ=;
        b=aPQefoVORKlqsxMSCgSGYy45ZOjexE/92layDmnOnX7nQDs7xmKRpalOXJSDjbJWGd
         JNtn/yTU9UddEN+q/ZbGxvSXBbB4poMjtT0rg3uUYt1xImEcGUmj9gr9Ps11PSWzpTd3
         hzWsBfItntrDqlh8NpaayzGJ4K+P6/bXTL99hoKRJfeB76gWwGJ9/xP38+j0DvSeU2ZV
         ypkvbEAylZS/TzK0fHFSgW8zl+NHZ29XP9XjfVXKLvCr0uoQguuAuZSTcQt7yCgoycs4
         gbDG4zVb0LTYwjSHTxpzpQA+OHe//fk/wI9GWHfIG4l2Bd/hNCmoC86VoSKJDqbAyLVb
         z6xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c40M1cst4ML5N7ApczvXgI2sQfbBl98vL2Dm1XX73oQ=;
        b=QUPx+6kYeDeqyWp2+r/YhFurSCYVGd7uoOr+DQxC1fG4Rl53TvZ8Uet08quXGyI0G+
         mVF7TiCM+2P6ZHpWRIbDBP+2vDc2KbgXmfa4u1K25Ldo9pDvJgxY33VnvV3js7LBWQIs
         9F9dcOAtYmogEEaq28MFdOPDzQDbl9hcUtvqFNTRCyXTTRLA4FbPvL1ws2XUGUNRFUf8
         ujxqUQS/UtaH41RKFhkJDdtz1ZtbXnEcp5qI2rcf27PHeYZ5wgCKnsg0x2Ch1aRGTVHM
         lR553Av3/xzLPI6Nt2PTw8k2yUXnd2lc8MMgCpjf5rBABwgd8Tuw3D05cGYa2WLwu0Uh
         qLFQ==
X-Gm-Message-State: APjAAAVc6zWGsBnUagFOmN7pn4EQvjvzakNrgEgcXXSwiSvka0ZqHbXF
        c6kzJGZzusxoQHO6iMbKo3dVeg==
X-Google-Smtp-Source: APXvYqxfD0egClyACS2Sz5SOlGnKnevgwWbZBp6kTtoP7xYygY+jpMRDwbE+sqwiF3tdcI6b23Czhw==
X-Received: by 2002:a0c:f4d2:: with SMTP id o18mr5856536qvm.100.1574300298519;
        Wed, 20 Nov 2019 17:38:18 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id t65sm617238qkh.99.2019.11.20.17.38.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Nov 2019 17:38:17 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXbQH-0000cf-5H; Wed, 20 Nov 2019 21:38:17 -0400
Date:   Wed, 20 Nov 2019 21:38:17 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191121013817.GA16914@ziepe.ca>
References: <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <20191120022141-mutt-send-email-mst@kernel.org>
 <20191120130319.GA22515@ziepe.ca>
 <20191120083908-mutt-send-email-mst@kernel.org>
 <20191120143054.GF22515@ziepe.ca>
 <20191120093607-mutt-send-email-mst@kernel.org>
 <20191120164525.GH22515@ziepe.ca>
 <20191120165748-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120165748-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 05:05:00PM -0500, Michael S. Tsirkin wrote:
> On Wed, Nov 20, 2019 at 12:45:25PM -0400, Jason Gunthorpe wrote:
> > > > For instance, this VFIO based approach might be very suitable to the
> > > > intel VF based ICF driver, but we don't yet have an example of non-VF
> > > > HW that might not be well suited to VFIO.
> > >
> > > I don't think we should keep moving the goalposts like this.
> > 
> > It is ABI, it should be done as best we can as we have to live with it
> > for a long time. Right now HW is just starting to come to market with
> > VDPA and it feels rushed to design a whole subsystem style ABI around
> > one, quite simplistic, driver example.
> 
> Well one has to enable hardware in some way. It's not really reasonable
> to ask for multiple devices to be available just so there's a driver and
> people can use them.

Er, this has actually been a fairly standard ask for new subsystems.

I think virtio is well grounded here compared to other things I've
seen, but it should still be done with a lot more NIC community involvement.

> At this rate no one will want to be the first to ship new devices ;)

Why?
 
> > > If people write drivers and find some infrastruture useful,
> > > and it looks more or less generic on the outset, then I don't
> > > see why it's a bad idea to merge it.
> > 
> > Because it is userspace ABI, caution is always justified when defining
> > new ABI.
> 
> Reasonable caution, sure. Asking Alex to block Intel's driver until
> someone else catches up and ships competing hardware isn't reasonable
> though. If that's your proposal I guess we'll have to agree to disagree.

Vendors may be willing to participate, as Mellanox is doing,
pre-product.

Jason
