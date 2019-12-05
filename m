Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9BC113BDB
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 07:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfLEGkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 01:40:53 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55970 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726007AbfLEGkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 01:40:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575528050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/J6KCYE9jeJZfzKbxa345PuEniQRQjk1Uf3CJ5cJfng=;
        b=ME79YasNMlzdiZ+VK1imKNYSiE7AOKX+ZTgsKOdQtW81llR2DqA4+jrItlSY/4tiY95K3f
        myP88tV8MlQL18VazHu+E6f0/lD2RAqFx2drKH7yf1Vlal9s/bg/Wz+yG9Fgps26OWbx8W
        3bg/IHXu+2JalgTldenKMFdY089eIxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-8SOlyITkPfqygQAmfmuEgg-1; Thu, 05 Dec 2019 01:40:46 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6467D800D54;
        Thu,  5 Dec 2019 06:40:45 +0000 (UTC)
Received: from [10.72.12.247] (ovpn-12-247.pek2.redhat.com [10.72.12.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC13B5DA32;
        Thu,  5 Dec 2019 06:40:37 +0000 (UTC)
Subject: Re: [PATCH 0/6] VFIO mdev aggregated resources handling
To:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
 <AM0PR05MB4866CA9B70A8BEC1868AF8C8D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108081925.GH4196@zhen-hp.sh.intel.com>
 <AM0PR05MB4866757033043CC007B5C9CBD15D0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191205060618.GD4196@zhen-hp.sh.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b15ae698-cd5e-dfb9-0478-b865cc0c2262@redhat.com>
Date:   Thu, 5 Dec 2019 14:40:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191205060618.GD4196@zhen-hp.sh.intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 8SOlyITkPfqygQAmfmuEgg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/12/5 =E4=B8=8B=E5=8D=882:06, Zhenyu Wang wrote:
> On 2019.12.04 17:36:12 +0000, Parav Pandit wrote:
>> + Jiri + Netdev since you mentioned netdev queue.
>>
>> + Jason Wang and Michael as we had similar discussion in vdpa discussion=
 thread.
>>
>>> From: Zhenyu Wang <zhenyuw@linux.intel.com>
>>> Sent: Friday, November 8, 2019 2:19 AM
>>> To: Parav Pandit <parav@mellanox.com>
>>>
>> My apologies to reply late.
>> Something bad with my email client, due to which I found this patch unde=
r spam folder today.
>> More comments below.
>>
>>> On 2019.11.07 20:37:49 +0000, Parav Pandit wrote:
>>>> Hi,
>>>>
>>>>> -----Original Message-----
>>>>> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On
>>>>> Behalf Of Zhenyu Wang
>>>>> Sent: Thursday, October 24, 2019 12:08 AM
>>>>> To: kvm@vger.kernel.org
>>>>> Cc: alex.williamson@redhat.com; kwankhede@nvidia.com;
>>>>> kevin.tian@intel.com; cohuck@redhat.com
>>>>> Subject: [PATCH 0/6] VFIO mdev aggregated resources handling
>>>>>
>>>>> Hi,
>>>>>
>>>>> This is a refresh for previous send of this series. I got impression
>>>>> that some SIOV drivers would still deploy their own create and
>>>>> config method so stopped effort on this. But seems this would still
>>>>> be useful for some other SIOV driver which may simply want
>>>>> capability to aggregate resources. So here's refreshed series.
>>>>>
>>>>> Current mdev device create interface depends on fixed mdev type,
>>>>> which get uuid from user to create instance of mdev device. If user
>>>>> wants to use customized number of resource for mdev device, then
>>>>> only can create new
>>>> Can you please give an example of 'resource'?
>>>> When I grep [1], [2] and [3], I couldn't find anything related to ' ag=
gregate'.
>>> The resource is vendor device specific, in SIOV spec there's ADI (Assig=
nable
>>> Device Interface) definition which could be e.g queue for net device, c=
ontext
>>> for gpu, etc. I just named this interface as 'aggregate'
>>> for aggregation purpose, it's not used in spec doc.
>>>
>> Some 'unknown/undefined' vendor specific resource just doesn't work.
>> Orchestration tool doesn't know which resource and what/how to configure=
 for which vendor.
>> It has to be well defined.
>>
>> You can also find such discussion in recent lgpu DRM cgroup patches seri=
es v4.
>>
>> Exposing networking resource configuration in non-net namespace aware md=
ev sysfs at PCI device level is no-go.
>> Adding per file NET_ADMIN or other checks is not the approach we follow =
in kernel.
>>
>> devlink has been a subsystem though under net, that has very rich interf=
ace for syscaller, device health, resource management and many more.
>> Even though it is used by net driver today, its written for generic devi=
ce management at bus/device level.
>>
>> Yuval has posted patches to manage PCI sub-devices [1] and updated versi=
on will be posted soon which addresses comments.
>>
>> For any device slice resource management of mdev, sub-function etc, we s=
hould be using single kernel interface as devlink [2], [3].
>>
>> [1] https://lore.kernel.org/netdev/1573229926-30040-1-git-send-email-yuv=
alav@mellanox.com/
>> [2] http://man7.org/linux/man-pages/man8/devlink-dev.8.html
>> [3] http://man7.org/linux/man-pages/man8/devlink-resource.8.html
>>
>> Most modern device configuration that I am aware of is usually done via =
well defined ioctl() of the subsystem (vhost, virtio, vfio, rdma, nvme and =
more) or via netlink commands (net, devlink, rdma and more) not via sysfs.
>>
> Current vfio/mdev configuration is via documented sysfs ABI instead of
> other ways. So this adhere to that way to introduce more configurable
> method on mdev device for standard, it's optional and not actually
> vendor specific e.g vfio-ap.
>
> I'm not sure how many devices support devlink now, or if really make
> sense to utilize devlink for other devices except net, or if really make
> sense to take mdev resource configuration from there...


It may make sense to allow other types of API to manage mdev other than=20
sysfs. But I'm not sure whether or not it will be a challenge for=20
orchestration.

Thanks


>>>>> mdev type for that which may not be flexible. This requirement comes
>>>>> not only from to be able to allocate flexible resources for KVMGT,
>>>>> but also from Intel scalable IO virtualization which would use
>>>>> vfio/mdev to be able to allocate arbitrary resources on mdev instance=
.
>>> More info on [1] [2] [3].
>>>>> To allow to create user defined resources for mdev, it trys to
>>>>> extend mdev create interface by adding new "aggregate=3Dxxx" paramete=
r
>>>>> following UUID, for target mdev type if aggregation is supported, it
>>>>> can create new mdev device which contains resources combined by
>>>>> number of instances, e.g
>>>>>
>>>>>      echo "<uuid>,aggregate=3D10" > create
>>>>>
>>>>> VM manager e.g libvirt can check mdev type with "aggregation"
>>>>> attribute which can support this setting. If no "aggregation"
>>>>> attribute found for mdev type, previous behavior is still kept for
>>>>> one instance allocation. And new sysfs attribute
>>>>> "aggregated_instances" is created for each mdev device to show alloca=
ted
>>> number.
>>>>> References:
>>>>> [1]
>>>>> https://software.intel.com/en-us/download/intel-virtualization-techn
>>>>> ology- for-directed-io-architecture-specification
>>>>> [2]
>>>>> https://software.intel.com/en-us/download/intel-scalable-io-virtuali
>>>>> zation-
>>>>> technical-specification
>>>>> [3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf
>>>>>
>>>>> Zhenyu Wang (6):
>>>>>    vfio/mdev: Add new "aggregate" parameter for mdev create
>>>>>    vfio/mdev: Add "aggregation" attribute for supported mdev type
>>>>>    vfio/mdev: Add "aggregated_instances" attribute for supported mdev
>>>>>      device
>>>>>    Documentation/driver-api/vfio-mediated-device.rst: Update for
>>>>>      vfio/mdev aggregation support
>>>>>    Documentation/ABI/testing/sysfs-bus-vfio-mdev: Update for vfio/mde=
v
>>>>>      aggregation support
>>>>>    drm/i915/gvt: Add new type with aggregation support
>>>>>
>>>>>   Documentation/ABI/testing/sysfs-bus-vfio-mdev | 24 ++++++
>>>>>   .../driver-api/vfio-mediated-device.rst       | 23 ++++++
>>>>>   drivers/gpu/drm/i915/gvt/gvt.c                |  4 +-
>>>>>   drivers/gpu/drm/i915/gvt/gvt.h                | 11 ++-
>>>>>   drivers/gpu/drm/i915/gvt/kvmgt.c              | 53 ++++++++++++-
>>>>>   drivers/gpu/drm/i915/gvt/vgpu.c               | 56 ++++++++++++-
>>>>>   drivers/vfio/mdev/mdev_core.c                 | 36 ++++++++-
>>>>>   drivers/vfio/mdev/mdev_private.h              |  6 +-
>>>>>   drivers/vfio/mdev/mdev_sysfs.c                | 79 ++++++++++++++++=
++-
>>>>>   include/linux/mdev.h                          | 19 +++++
>>>>>   10 files changed, 294 insertions(+), 17 deletions(-)
>>>>>
>>>>> --
>>>>> 2.24.0.rc0
>>> --
>>> Open Source Technology Center, Intel ltd.
>>>
>>> $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

