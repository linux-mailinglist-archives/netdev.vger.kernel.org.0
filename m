Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2DE5F6B0C
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 20:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfKJTEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 14:04:20 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35422 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfKJTEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 14:04:20 -0500
Received: by mail-qt1-f193.google.com with SMTP id n4so8657417qte.2
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 11:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4X+lJuxXpXDbRkVB7/MvwoAb9ZOQMHWI6c7L1sTBKq4=;
        b=e2epuT3DbyEliM62E016Oc2uFJQCWmIfHYgklM7m6mhAa/R1tVadAQYMNRUxbM5yvV
         PivYook4+PtSMJXOjE/grGeSKGRRp7Y6HoJWLNnDusXHtMI3QoWSkKEUpynggrfzLInH
         GeGMN3JRfPIff3gE1HY1hMoaYR2rC6gOdnDbs3TDfFXV22OGMFQ3KuccegsCKGWjUUrL
         MRCWyYoXjn9FTOgqQHsmw9ea6aUzZs9dz8Rbqoi6erWLWyT10C7wghRa8BjWjjbtSyQE
         CvUrDsvKnnaf0G30ydtTGDL7pUuX7MAb4E7i8TENiSbS0pzp/jLXAh2wB/5NvD+gM9ad
         GFxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4X+lJuxXpXDbRkVB7/MvwoAb9ZOQMHWI6c7L1sTBKq4=;
        b=ZSlRsQukihgX8vv2ZJsHOFPAVkWXBgHJ0xcwmBzT9IJwVIS5EmvcCn00ee3nYqKZs+
         Mc+ZEKBDxpFQlZ0eH4lGnrCvRcnU2Xwi8XYkFsnbAxCcJLEXS0SbTi6Gv43msFIz8nBd
         u50yAx4RTnZAcE/7GHIaFVe4wKbZ+8qzWLO5zT+/pH/ZNxVGK4Sk88cm2uhHLNQbK2Yd
         1y2XJdF01Z7fN+OlGUy0CnJFEJqGektqJ2PLjW5qfdJg/9z/IzNhPWk+bamSH1mCI2Ei
         3q31tk9kB+7UhGxd1sIuaPVZqPMWUgAJNsEBSzyYH2g82w+owHJ/N7kNUT2ywPu2zxBP
         3Zjg==
X-Gm-Message-State: APjAAAXh8T2XjEhcxbRlelRmcLKeEYNoJLuytrDV0taH26JLEhWmidMD
        +3nLvr6cg/cpO4eM9OvRSYLCaQ==
X-Google-Smtp-Source: APXvYqxLWlOngvz8JEYlq7KhAImGgPmaYLGP5ikKveosJheOQf3aQ/BeD8Yv/uQkBcuupt+Jx6Z8Ww==
X-Received: by 2002:aed:2ac2:: with SMTP id t60mr22796872qtd.376.1573412659023;
        Sun, 10 Nov 2019 11:04:19 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id x65sm6410210qkd.15.2019.11.10.11.04.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 10 Nov 2019 11:04:18 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iTsVV-00048v-JX; Sun, 10 Nov 2019 15:04:17 -0400
Date:   Sun, 10 Nov 2019 15:04:17 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Parav Pandit <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "Jason Wang (jasowang@redhat.com)" <jasowang@redhat.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191110190417.GD31761@ziepe.ca>
References: <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108133435.6dcc80bd@x1.home>
 <20191108210545.GG10956@ziepe.ca>
 <20191108145210.7ad6351c@x1.home>
 <AM0PR05MB4866444210721BC4EE775D27D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191109005708.GC31761@ziepe.ca>
 <20191109094103.739033a3@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109094103.739033a3@cakuba>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 09:41:03AM -0800, Jakub Kicinski wrote:
> On Fri, 8 Nov 2019 20:57:08 -0400, Jason Gunthorpe wrote:
> > On Fri, Nov 08, 2019 at 10:48:31PM +0000, Parav Pandit wrote:
> > > We should be creating 3 different buses, instead of mdev bus being de-multiplexer of that?
> > > 
> > > Hence, depending the device flavour specified, create such device on right bus?
> > > 
> > > For example,
> > > $ devlink create subdev pci/0000:05:00.0 flavour virtio name foo subdev_id 1
> > > $ devlink create subdev pci/0000:05:00.0 flavour mdev <uuid> subdev_id 2
> > > $ devlink create subdev pci/0000:05:00.0 flavour mlx5 id 1 subdev_id 3  
> > 
> > I like the idea of specifying what kind of interface you want at sub
> > device creation time. It fits the driver model pretty well and doesn't
> > require abusing the vfio mdev for binding to a netdev driver.
> 
> Aren't the HW resources spun out in all three cases exactly identical?

Exactly? No, not really. The only constant is that some chunk of the
BAR is dedicated to this subedv. The BAR is flexible, so a BAR chunk
configured for virtio is not going to support mlx5 mode.

Aside from that, there are other differences ie - mlx5 does not need a
dedicated set of MSI-X's while other modes do. There are fewer MSI-X's
than SF's, so managing this is important for the admin.

Even in modes which are very similar, like mlx5 vs mdev-vfio, the HW
still has to be configured to provide global DMA isolation on the NIC
for vfio as the IOMMU cannot be involved. This is extra overhead and
should not be activated unless vfio is being used.

.. and finally the driver core does not support a
'multiple-inheritance' like idea, so we can't have a 'foo_device' that
is three different things.

So somehow the 'flavour' of the 'struct device' has to be exposed to
userspace, and it is best if this is done at device creation time so
the BAR region and HW can be setup once and we don't have to have
complex reconfiguration flows.

Jason
