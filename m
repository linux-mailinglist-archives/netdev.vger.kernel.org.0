Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53A9D102FB8
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfKSXK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:10:26 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44244 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfKSXKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:10:25 -0500
Received: by mail-qt1-f193.google.com with SMTP id o11so26688326qtr.11
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 15:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9PMAt9BpsUAZp7Bq1/geFdXKwd/meD5cyXpSWT+Lwjw=;
        b=pE71tkb4vz6SNRqGBbLLdLfetZLPw3HitJWCvIUNNIpyeTQh2eXlnQnH/Kfd//LZ1b
         k5g6pc66cOli0osrRQfkd/iJ7Wqt4ogWX9G1drEftRQG0+huQYwK77FnWqvnXnKvfh75
         1NO0F9IQS8S7S6ggZ7pY8UrfoUAMQZfXpYfoPMkGKhSl5u+YY9PcUnPeRylw7t9jCING
         ZZqkMNA8BRIhV5nI/jrILCSSim4qtwFNlb6VYnUeXkTxjRxL1sUGV7qe1QehW572+M3P
         BM4YOI5Io5j+4xAUK02y/VcmRTBkC5v684YEVYTZ5n+Xlj3d+kP5LFNoxzqFRWfgZePq
         rMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9PMAt9BpsUAZp7Bq1/geFdXKwd/meD5cyXpSWT+Lwjw=;
        b=EEk3c5HRhPHIPwTCv2Z7mu3VdLGLBnlAd6Deq2piFoCkY2TA4C4KpV4qFVgxXBdOGs
         W/NydTk1u6rgK7CeVL6ehb3EDDkDiQM7bx2+WwW1SzVLOqIAO+b8oZ2WKIztPNrQQIsJ
         oAYKiors44egZhX3u8WB6DB/hgjOShcSb9h3clf8bLWGbiyyqYHhNWuGVCDaPLneNW6H
         5Zyb319ywN9RjPZHGqWaACzXmeEVcu70VD5NXB9RrpnjwVFtyPPwr6sqzudLBwJT4nDV
         uXT/Fd9fCvzPyhVG48jEXymQfQPiidEqLoR9V6r0Narkdkkm4M6NTDscNljV9UcjnMhF
         iozA==
X-Gm-Message-State: APjAAAUXWF7Bem4jTYPt4n9RIOO1H9qQ+GeMyKZ1zbseKkPr1a0PkJ9g
        uAWwqqPoLzedJ7KFuDlv4sVJzA==
X-Google-Smtp-Source: APXvYqzesiXM2A+pKq+Xz4FHwQgAiCe2v9inGm0MQBdQeEcjFmSBfQkf/yh83hwKuJJZQN0EGsfZwQ==
X-Received: by 2002:ac8:3475:: with SMTP id v50mr334772qtb.105.1574205024721;
        Tue, 19 Nov 2019 15:10:24 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id d131sm122112qkg.62.2019.11.19.15.10.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 15:10:24 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXCdb-0004gv-0x; Tue, 19 Nov 2019 19:10:23 -0400
Date:   Tue, 19 Nov 2019 19:10:23 -0400
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
Message-ID: <20191119231023.GN4991@ziepe.ca>
References: <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119163147-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 04:33:40PM -0500, Michael S. Tsirkin wrote:
> On Tue, Nov 19, 2019 at 03:15:47PM -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 19, 2019 at 01:58:42PM -0500, Michael S. Tsirkin wrote:
> > > On Tue, Nov 19, 2019 at 12:46:32PM -0400, Jason Gunthorpe wrote:
> > > > As always, this is all very hard to tell without actually seeing real
> > > > accelerated drivers implement this. 
> > > > 
> > > > Your patch series might be a bit premature in this regard.
> > > 
> > > Actually drivers implementing this have been posted, haven't they?
> > > See e.g. https://lwn.net/Articles/804379/
> > 
> > Is that a real driver? It looks like another example quality
> > thing. 
> > 
> > For instance why do we need any of this if it has '#define
> > IFCVF_MDEV_LIMIT 1' ?
> > 
> > Surely for this HW just use vfio over the entire PCI function and be
> > done with it?
> 
> What this does is allow using it with unmodified virtio drivers
> within guests.  You won't get this with passthrough as it only
> implements parts of virtio in hardware.

I don't mean use vfio to perform passthrough, I mean to use vfio to
implement the software parts in userspace while vfio to talk to the
hardware.

  kernel -> vfio -> user space virtio driver -> qemu -> guest

Generally we don't want to see things in the kernel that can be done
in userspace, and to me, at least for this driver, this looks
completely solvable in userspace.

Jason
