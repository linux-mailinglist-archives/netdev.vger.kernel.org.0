Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00C0B15D12B
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 05:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgBNEkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 23:40:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46725 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728699AbgBNEkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 23:40:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581655214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x3yOWLF6bcHCCuN6HWm7zeGRKO0RfJCz2+K5iNwYZJc=;
        b=Z+oxFQ6FiIGWjS4ZsRD9RNgGuHUCuR9dwgc4qnVmBVXWlSxGqgEBwA3jqW14VZ5hRxR6Y1
        IBYG2uFWjH0mi7rQCBTojboH/CiamevXpScdlFKkbXSpsPialqo/CU4VOA8A2EojR7C54E
        4sD9aY9L0zT58Hqs2FyEM/SRxLp3MOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-o4poq0lXOLKmZXu4jaC7VQ-1; Thu, 13 Feb 2020 23:40:13 -0500
X-MC-Unique: o4poq0lXOLKmZXu4jaC7VQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFBC81851FC6;
        Fri, 14 Feb 2020 04:40:10 +0000 (UTC)
Received: from [10.72.13.213] (ovpn-13-213.pek2.redhat.com [10.72.13.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB4B68AC40;
        Fri, 14 Feb 2020 04:39:49 +0000 (UTC)
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <20200213103714-mutt-send-email-mst@kernel.org>
 <20200213155154.GX4271@mellanox.com>
 <20200213105743-mutt-send-email-mst@kernel.org>
 <20200213161320.GY4271@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <da994ac0-6f44-109f-962e-5df9cfbc3221@redhat.com>
Date:   Fri, 14 Feb 2020 12:39:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200213161320.GY4271@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/14 =E4=B8=8A=E5=8D=8812:13, Jason Gunthorpe wrote:
> On Thu, Feb 13, 2020 at 10:59:34AM -0500, Michael S. Tsirkin wrote:
>> On Thu, Feb 13, 2020 at 11:51:54AM -0400, Jason Gunthorpe wrote:
>>> The 'class' is supposed to provide all the library functions to remov=
e
>>> this duplication. Instead of plugging the HW driver in via some bus
>>> scheme every subsystem has its own 'ops' that the HW driver provides
>>> to the subsystem's class via subsystem_register()
>> Hmm I'm not familiar with subsystem_register. A grep didn't find it
>> in the kernel either ...
> I mean it is the registration function provided by the subsystem that
> owns the class, for instance tpm_chip_register(),
> ib_register_device(), register_netdev(), rtc_register_device() etc
>
> So if you have some vhost (vhost net?) class then you'd have some
> vhost_vdpa_init/alloc(); vhost_vdpa_register(), sequence
> presumably. (vs trying to do it with a bus matcher)
>
> I recommend to look at rtc and tpm for fairly simple easy to follow
> patterns for creating a subsystem in the kernel. A subsystem owns a cla=
ss,
> allows HW drivers to plug in to it, and provides a consistent user
> API via a cdev/sysfs/etc.
>
> The driver model class should revolve around the char dev and sysfs
> uABI - if you enumerate the devices on the class then they should all
> follow the char dev and sysfs interfaces contract of that class.
>
> Those examples show how to do all the refcounting semi-sanely,
> introduce sysfs, cdevs, etc.
>
> I thought the latest proposal was to use the existing vhost class and
> largely the existing vhost API, so it probably just needs to make sure
> the common class-wide stuff is split from the 'driver' stuff of the
> existing vhost to netdev.


Still, netdev is only one of the type we want to support. And we can not=20
guarantee or forecast that vhost is the only API that is used.

Let's take virtio as an example, it is implemented through a bus which=20
allows different subsystems on top. And it can provide a variety of=20
different uAPIs. For best performance, VFIO could be used for userspace=20
drivers, but it requires the bus has support from VFIO.

For vDPA devices, it's just the same logic. A bus allows different=20
drivers and subsystems on top. One of the subsystem could be vhost that=20
provides a unified API for userspace driver.

Thanks


>
> Jason
>

