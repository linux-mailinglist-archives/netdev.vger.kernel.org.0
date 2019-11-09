Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039F8F5C95
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfKIA5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:57:12 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33717 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfKIA5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 19:57:11 -0500
Received: by mail-qt1-f194.google.com with SMTP id y39so8753966qty.0
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 16:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VuQrMxWBxO6EoV/i1I70FM4gejpCWbnlTsIzbiitkKw=;
        b=h4qr1KxZ3XNnC+jXtuxPRFXMOnak60RHW2iWRXsgbjeBZc34SAWLDFquD64WYuwycq
         8Ke00fCQS+xYkvq/VMGYtZTkeq5C4rTFwHUU+/SLtom3DqZfAHKXX9shV4dCILHI9TJk
         VyoGcxT9dDwW9xgkATwDHK0ZgCGToxBG2B1B4EtFuV71F4jOUEz3PPn+Zma7YOUq5poP
         1HuXFvs3ig2p+BM3KW15n8w+bTqiX9VIcpsl8rSRb6Q80MNeRhNGBOoYOLXqcyK4Gsk4
         WhnoDW7jwRoaElJiJonLVlB9k4TKTPLK1RMyobAWgnuZgV/hwz2ekxqwKxk3L5bQ3X2V
         EVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VuQrMxWBxO6EoV/i1I70FM4gejpCWbnlTsIzbiitkKw=;
        b=XVUY/4o4dcQJ3WGpmgU0G5vMhfDjzVJluLEWmtw7U3MU/sQBda8i+/1D+a4uL7qlrr
         EfHPgmrNhUaetySBFrKIdQq/xIIstaFm+1aFBlNNhVWLLYX0+nONbSzfvo6E4WQ+eE0O
         otm9xW372/odXBlk9yUb4mPr2ow73xebak5FG8BtmTxwK+D6d5ZBaMxMDUAFPBYVortd
         0FPKYhZpgtBW6/QPAwNz+gjLcIOvTnM6V0graZSoFPoFntJ1AnqfGQiSiDk5FPJYyzoO
         DNr5jWTobXB+vSP7oe9i2i5tYK8zxNxD6I2NfH3DFpbY6Jb8Zb1VMqLfTyB3j41ZT+i2
         EXyQ==
X-Gm-Message-State: APjAAAVP7hIHL35dBA1Ii1GgUO0eJ9F5BNcd5zGJeR2hackycYWXgg+k
        9c6xhd9rxYtyIYJ5WhAS9bPTQQ==
X-Google-Smtp-Source: APXvYqxs5fv/Czk0u6Tq8dTd/u4S8g8hDvWuHaY0HMCDHty7xYz8WVMHbxQhmupy/IfwHd7AiQeq5Q==
X-Received: by 2002:ac8:608:: with SMTP id d8mr14458157qth.258.1573261029435;
        Fri, 08 Nov 2019 16:57:09 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id u9sm4353467qke.50.2019.11.08.16.57.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Nov 2019 16:57:08 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iTF3s-0001G7-Bx; Fri, 08 Nov 2019 20:57:08 -0400
Date:   Fri, 8 Nov 2019 20:57:08 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
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
Message-ID: <20191109005708.GC31761@ziepe.ca>
References: <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108133435.6dcc80bd@x1.home>
 <20191108210545.GG10956@ziepe.ca>
 <20191108145210.7ad6351c@x1.home>
 <AM0PR05MB4866444210721BC4EE775D27D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866444210721BC4EE775D27D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 10:48:31PM +0000, Parav Pandit wrote:
> We should be creating 3 different buses, instead of mdev bus being de-multiplexer of that?
> 
> Hence, depending the device flavour specified, create such device on right bus?
> 
> For example,
> $ devlink create subdev pci/0000:05:00.0 flavour virtio name foo subdev_id 1
> $ devlink create subdev pci/0000:05:00.0 flavour mdev <uuid> subdev_id 2
> $ devlink create subdev pci/0000:05:00.0 flavour mlx5 id 1 subdev_id 3

I like the idea of specifying what kind of interface you want at sub
device creation time. It fits the driver model pretty well and doesn't
require abusing the vfio mdev for binding to a netdev driver.

> $ devlink subdev pci/0000:05:00.0/<subdev_id> config <params>
> $ echo <respective_device_id> <sysfs_path>/bind

Is explicit binding really needed? If you specify a vfio flavour why
shouldn't the vfio driver autoload and bind to it right away? That is
kind of the point of the driver model...

(kind of related, but I don't get while all that GUID and lifecycle
stuff in mdev should apply for something like a SF)

> Implement power management callbacks also on all above 3 buses?
> Abstract out mlx5_bus into more generic virtual bus (vdev bus?) so
> that multiple vendors can reuse?

In this specific case, why does the SF in mlx5 mode even need a bus?
Is it only because of devlink? That would be unfortunate

Jason
