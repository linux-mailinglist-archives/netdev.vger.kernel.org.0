Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 556B2F7632
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfKKORh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:17:37 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40643 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfKKORg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:17:36 -0500
Received: by mail-wm1-f67.google.com with SMTP id f3so13355600wmc.5
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 06:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MRo3diKBYBcGwLp50p5aMXNWzBa5ZFfKRAtoFXF24qM=;
        b=dXHguEr+pnsoyOwJp1GVq+vDV+A1Je27ggMBZ2b/vndbZJIaCDFTevPrer+RTDP3Um
         ogcdMj2g/XE7dIwkvXHxzOba0bqTQTUcGi+UgqhNOLZUlWeDgM57A5I8yzdfwfrmNZa6
         QlZ4nGHeSfAhCiW6uAJkk/h/pXD8YvkdU6UerlVTFHTdJfTl14zKQmyq+XgV9bcMONtx
         MigTj6GdtxHybPj3X5W5BgqtegohvqItwrvez3X73+zsyh5JRU/gy0p5F3YkaqLx0eW2
         ytnBoPCaRl8iC6tbJ4JOkuxu1AM+yrabi5Sw/GcWD44Izvyajky+FPFSfnodzF6wvkGx
         rrog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MRo3diKBYBcGwLp50p5aMXNWzBa5ZFfKRAtoFXF24qM=;
        b=Fpads7OZ6mHkwWTgD9QONhwg2glNk1bqTzT8Ab70HdPCo79MCduOlB06WgsSVdy/FN
         VfET/ut0gS5CV8KtzyNv36WaPRKPTG8ks01mfEkBt+e6IRC4gPlauMinRIm3z5jLDZrj
         37n82sCfgzOqI/LOmFSUz20Af5VJ4W7zsIEU0uJFycZMmWQgL9/f3YmdOcAPSLrXCxzK
         /lmv9j5CU4Cj6g/MPQncsLKBc6PWOH69f+m8d2YqSyX9PVq72TW+TCW94GZsEmBP1Yta
         C3ZaS3i47yzTA3Bq9FeMRhYZ5DC5BuNpPixBBU/nSYWheYBh7YM94kAz0YWk6aX77wgB
         GpFQ==
X-Gm-Message-State: APjAAAVsul/+uaFv/ovxrNu3k1vTxoaZIcDEOofr0CoCPzlBRDYHbeFG
        komyldY3GDkzxI/pmaV2k5Kt4g==
X-Google-Smtp-Source: APXvYqygTn1+LECGsozea1woUc7UCG2I1xnXTksMPMj5fVNHY0rtYCsRarOakCqPeCoTAmAEemWt2w==
X-Received: by 2002:a1c:60d7:: with SMTP id u206mr21651174wmb.101.1573481853654;
        Mon, 11 Nov 2019 06:17:33 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u13sm6360308wmm.45.2019.11.11.06.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 06:17:33 -0800 (PST)
Date:   Mon, 11 Nov 2019 15:17:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
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
Message-ID: <20191111141732.GB2202@nanopsycho>
References: <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108133435.6dcc80bd@x1.home>
 <20191108210545.GG10956@ziepe.ca>
 <20191108145210.7ad6351c@x1.home>
 <AM0PR05MB4866444210721BC4EE775D27D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191109005708.GC31761@ziepe.ca>
 <AM0PR05MB48660E49342EC2CD6AB825F8D1750@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB48660E49342EC2CD6AB825F8D1750@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Nov 10, 2019 at 08:48:31PM CET, parav@mellanox.com wrote:
>
>> From: Jason Gunthorpe <jgg@ziepe.ca>
>> Sent: Friday, November 8, 2019 6:57 PM
>> > We should be creating 3 different buses, instead of mdev bus being de-
>> multiplexer of that?
>> >
>> > Hence, depending the device flavour specified, create such device on right
>> bus?
>> >
>> > For example,
>> > $ devlink create subdev pci/0000:05:00.0 flavour virtio name foo
>> > subdev_id 1 $ devlink create subdev pci/0000:05:00.0 flavour mdev
>> > <uuid> subdev_id 2 $ devlink create subdev pci/0000:05:00.0 flavour
>> > mlx5 id 1 subdev_id 3
>> 
>> I like the idea of specifying what kind of interface you want at sub device
>> creation time. It fits the driver model pretty well and doesn't require abusing
>> the vfio mdev for binding to a netdev driver.
>> 
>> > $ devlink subdev pci/0000:05:00.0/<subdev_id> config <params> $ echo
>> > <respective_device_id> <sysfs_path>/bind
>> 
>> Is explicit binding really needed?
>No.
>
>> If you specify a vfio flavour why shouldn't
>> the vfio driver autoload and bind to it right away? That is kind of the point
>> of the driver model...
>> 
>It some configuration is needed that cannot be passed at device creation time, explicit bind later can be used.
>
>> (kind of related, but I don't get while all that GUID and lifecycle stuff in mdev
>> should apply for something like a SF)
>> 
>GUID is just the name of the device.
>But lets park this aside for a moment.
>
>> > Implement power management callbacks also on all above 3 buses?
>> > Abstract out mlx5_bus into more generic virtual bus (vdev bus?) so
>> > that multiple vendors can reuse?
>> 
>> In this specific case, why does the SF in mlx5 mode even need a bus?
>> Is it only because of devlink? That would be unfortunate
>>
>Devlink is one part due to identifying using bus/dev.
>How do we refer to its devlink instance of SF without bus/device?

Question is, why to have devlink instance for SF itself. Same as VF, you
don't need devlink instance. You only need devlink_port (or
devlink_subdev) instance on the PF devlink parent for it.


>Can we extend devlink_register() to accept optionally have sf_id?
>
>If we don't have a bus, creating sub function (a device), without a 'struct device' which will have BAR, resources, etc is odd.
>
>Now if we cannot see 'struct device' in sysfs, how do we persistently name them?
>Are we ok to add /sys/class/net/sf_netdev/subdev_id
>And
>/sys/class/infiniband/<rdma_dev>/subdev_id
>
>So that systemd/udev can rename them as en<X?><subdev_id> and roce<X><subdev_id>
>If so, what will be X without a bus type?
>
>This route without a bus is certainly helpful to overcome the IOMMU limitation where IOMMU only listens to pci bus type for DMAR setup, 
>dmar_register_bus_notifier(), and in 
>intel_iommu_init()-> bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
>and other IOMMU doing similar PCI/AMBA binding.
>This is currently overcome using WA dma_ops.
