Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D805EF775A
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 16:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfKKPGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 10:06:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32903 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfKKPGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 10:06:19 -0500
Received: by mail-wr1-f68.google.com with SMTP id w9so8212661wrr.0
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 07:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D7+Mln7zioZD6z9hmTpNuqpl/vZ6+iDnL/aNBB0t0B8=;
        b=vOTeLvaI3JoAPhQ1gZGRFtG1QJiZHvozDFYKeaIURUMNdAQkib65m+tjGMLojX0gFw
         xI3wyAbQ8xPD+CY60961ksYgQwTefeS3WQFVOTX+ecOWJzFgZBSQBbz6U3LKHaav8J9f
         1pInlZiU3nF0RywrzTKDmPNJFJxstLEIzjeY+MJ2Ij4QwJOiHCxYNmwzGdn3BTjnTE96
         OuHxbtM2LsGB2SSK1+cziKIJidUqrZ4kuE3CutB/1mSouPJAw5xEgN3+Wkkfpcsrkhn4
         4f5KV9us43gWKuRJ1l87rtq5fGDyYga3gSp81xQaoDjW2HtTdfSYRtA/DbNrCPLNLfCT
         30ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D7+Mln7zioZD6z9hmTpNuqpl/vZ6+iDnL/aNBB0t0B8=;
        b=gPuC7rRM6YiWXZhd6w6SOB4f6Ka3Q919xhznfB306w+ORtXDvmTh9PZABUtWCJBNQY
         Df0105yuiiS+C7ok2TgTQSzQSfRklUr1il0o1LftLxv5XS0U69aiP/KDHfBZ3pU/95Of
         kjdUy11d9XVKCwp0CUqMapNGiQ//OZ6gi9iIAh+uQpK/KKTNEC5t5jZISv2btW4Y9xZf
         +b1C2QPOH4fXvOxzC+bp8G6FEhTzlB59dSK6Wtzo8nfEi1DL8K0j4r8z/miT12jGO84L
         9PQ8kR6Ep2nOnh5OR47fRD5lJR2UVuhXtdzgPkuGcKxVdyrXBDYS1xFtxKXMBA2M30vV
         kJ8A==
X-Gm-Message-State: APjAAAUcwce6o6el+3Fkaockv037jFQP/b0roo9L8kRe25xqu9UG3BtV
        F7VsY0/MLKdObR1/5+PIcYeZrg==
X-Google-Smtp-Source: APXvYqz6okKQgXRrOy85hnlIawdK9gpnUJjod9cWU6khuWt2+pYd1K708rZyCf8daoD0He67rMrrDA==
X-Received: by 2002:adf:f60a:: with SMTP id t10mr17950637wrp.29.1573484774756;
        Mon, 11 Nov 2019 07:06:14 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f14sm14853190wrv.17.2019.11.11.07.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 07:06:14 -0800 (PST)
Date:   Mon, 11 Nov 2019 16:06:13 +0100
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
Message-ID: <20191111150613.GD2202@nanopsycho>
References: <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108133435.6dcc80bd@x1.home>
 <20191108210545.GG10956@ziepe.ca>
 <20191108145210.7ad6351c@x1.home>
 <AM0PR05MB4866444210721BC4EE775D27D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191109005708.GC31761@ziepe.ca>
 <AM0PR05MB48660E49342EC2CD6AB825F8D1750@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191111141732.GB2202@nanopsycho>
 <AM0PR05MB4866A5F11AED9ABA70FAE7EED1740@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866A5F11AED9ABA70FAE7EED1740@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 11, 2019 at 03:58:18PM CET, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Monday, November 11, 2019 8:18 AM
>> Sun, Nov 10, 2019 at 08:48:31PM CET, parav@mellanox.com wrote:
>> >
>> >> From: Jason Gunthorpe <jgg@ziepe.ca>
>> >> Sent: Friday, November 8, 2019 6:57 PM
>> >> > We should be creating 3 different buses, instead of mdev bus being
>> >> > de-
>> >> multiplexer of that?
>> >> >
>> >> > Hence, depending the device flavour specified, create such device
>> >> > on right
>> >> bus?
>> >> >
>> >> > For example,
>> >> > $ devlink create subdev pci/0000:05:00.0 flavour virtio name foo
>> >> > subdev_id 1 $ devlink create subdev pci/0000:05:00.0 flavour mdev
>> >> > <uuid> subdev_id 2 $ devlink create subdev pci/0000:05:00.0 flavour
>> >> > mlx5 id 1 subdev_id 3
>> >>
>> >> I like the idea of specifying what kind of interface you want at sub
>> >> device creation time. It fits the driver model pretty well and
>> >> doesn't require abusing the vfio mdev for binding to a netdev driver.
>> >>
>> >> > $ devlink subdev pci/0000:05:00.0/<subdev_id> config <params> $
>> >> > echo <respective_device_id> <sysfs_path>/bind
>> >>
>> >> Is explicit binding really needed?
>> >No.
>> >
>> >> If you specify a vfio flavour why shouldn't the vfio driver autoload
>> >> and bind to it right away? That is kind of the point of the driver
>> >> model...
>> >>
>> >It some configuration is needed that cannot be passed at device creation
>> time, explicit bind later can be used.
>> >
>> >> (kind of related, but I don't get while all that GUID and lifecycle
>> >> stuff in mdev should apply for something like a SF)
>> >>
>> >GUID is just the name of the device.
>> >But lets park this aside for a moment.
>> >
>> >> > Implement power management callbacks also on all above 3 buses?
>> >> > Abstract out mlx5_bus into more generic virtual bus (vdev bus?) so
>> >> > that multiple vendors can reuse?
>> >>
>> >> In this specific case, why does the SF in mlx5 mode even need a bus?
>> >> Is it only because of devlink? That would be unfortunate
>> >>
>> >Devlink is one part due to identifying using bus/dev.
>> >How do we refer to its devlink instance of SF without bus/device?
>> 
>> Question is, why to have devlink instance for SF itself. Same as VF, you don't
>mlx5_core has devlink instance for PF and VF for long time now.
>Health report, txq/rxq dumps etc all anchored to this devlink instance even for VF. (similar to PF).
>And so, SF same framework should work for SF.

Right, for health it makes sense.

>
>> need devlink instance. You only need devlink_port (or
>> devlink_subdev) instance on the PF devlink parent for it.
>> 
>Devlink_port or devlink_subdev are still on eswitch or mgmt side.
>They are not present on the side where devlink instance exist on side where txq/rxq/eq etc exist.
>

Got it.
