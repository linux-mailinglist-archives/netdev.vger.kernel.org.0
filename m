Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3368F1029A9
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbfKSQqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:46:35 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44559 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbfKSQqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:46:35 -0500
Received: by mail-qk1-f193.google.com with SMTP id m16so18388802qki.11
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 08:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9PNpRcE0uVma5xN3FBSJmZpM2jm61gwUGX17V4ua8zI=;
        b=Lp72rfCT8FdLdR64JLtInWUYtmv7ZHvZLVuui7mNblNTGtWik+q1hUP3PiVgPdRFYL
         9CyvmdkvCU2A1z7InZAJqbf+r1tdacBtLJcBY2laBa+9HiTlQ09CBsZbcdCC8Up6fBp7
         avVI5z1BzMRJTmanbeye3rAlZIrbwk4LsLRlCgbZ7jYjIaz3GmiGMJmKfdoIK6aQXN32
         JXuSilzZKo4HX8Ijk/IrPk8PZ6EYD3uvsi2/sl9LS5G+vQWjWtQ/nbDlaItMPGyhKHQe
         kD3qqOSk1ZIZ25cuLIVhi/r31iZcklXQStlSKZ9fiSpCHflF0l3BMsWu+W3KwJtQJhGc
         9q+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9PNpRcE0uVma5xN3FBSJmZpM2jm61gwUGX17V4ua8zI=;
        b=kK5fVOxtcgKOxNYM6+suTMQyw8FvZUQotm80CJcqld3dqTH4r0ukcT8dJn+tsrqGCS
         2hpu9LOdaOhntwfh2Gh+2/4xotIgdT9UDVMv46Tx+1TVdR2OXlJPuRazdb+M0hKrWEUi
         4CKYjnTfC0lQsxRwli/+SS4u4IPxKl9jsQO5d2Oaa7RFalzpDhrSdDJGa27pcG5PzHqi
         +POdyB0HE1IgicUwbFh0ia/leYIndm58WbhfHDzrbWAXvSECEWN1BiZb2Y4kmjNQPnw8
         8D9XtmxQ7E1H850fHN2ISlshrH6B4NPbX9sAQR4DW0tEEkr2RESWoJLqSsMhWRJ8l0He
         lF5Q==
X-Gm-Message-State: APjAAAWSxj/GTqX5JirKYm23UJuTsz8b2Oi+UTDpth77PCafmbby1gDQ
        EK33dsWQIfgCtKHk8n3XMklbOQ==
X-Google-Smtp-Source: APXvYqxxFVHS62/ZKoFpMFnPT6ZCy67+DTYrT/ZDPYcHXXjB4ULX6v17osKUteav+OwwEDyAF2NSdA==
X-Received: by 2002:a05:620a:149a:: with SMTP id w26mr29908593qkj.361.1574181993809;
        Tue, 19 Nov 2019 08:46:33 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id q16sm10356002qkm.27.2019.11.19.08.46.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 08:46:33 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iX6e8-0001TG-KD; Tue, 19 Nov 2019 12:46:32 -0400
Date:   Tue, 19 Nov 2019 12:46:32 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191119164632.GA4991@ziepe.ca>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 03:37:03PM +0800, Jason Wang wrote:

> > Jiri, Jason, me think that even virtio accelerated devices will need eswitch support. And hence, life cycling virtio accelerated devices via devlink makes a lot of sense to us.
> > This way user has single tool to choose what type of device he want to use (similar to ip link add link type).
> > So sub function flavour will be something like (virtio or sf).
> 
> Networking is only one of the types that is supported in virtio-mdev. The
> codes are generic enough to support any kind of virtio device (block, scsi,
> crypto etc). Sysfs is less flexible but type independent. I agree that
> devlink is standard and feature richer but still network specific. It's
> probably hard to add devlink to other type of physical drivers. I'm thinking
> whether it's possible to combine syfs and devlink: e.g the mdev is available
> only after the sub fuction is created and fully configured by devlink.

The driver providing the virtio should really be in control of the
life cycle policy. For net related virtio that is clearly devlink.

Even for block we may find that network storage providers (ie some
HW accelerated virtio-blk-over-ethernet) will want to use devlink to
create a combination ethernet and accelerated virtio-block widget.

This is why the guid life cycle stuff should be in a library that can
be used by the drivers that need it (assuming all drivers don't just
use devlink as Parav proposes)

As always, this is all very hard to tell without actually seeing real
accelerated drivers implement this. 

Your patch series might be a bit premature in this regard.

Jason
