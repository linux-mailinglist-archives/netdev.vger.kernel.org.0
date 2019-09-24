Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D211EBC6AC
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 13:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504690AbfIXLXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 07:23:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33788 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504665AbfIXLXm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 07:23:42 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ABB5B308FBA9;
        Tue, 24 Sep 2019 11:23:41 +0000 (UTC)
Received: from [10.72.12.44] (ovpn-12-44.pek2.redhat.com [10.72.12.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E04460C5D;
        Tue, 24 Sep 2019 11:23:17 +0000 (UTC)
Subject: Re: [PATCH 1/6] mdev: class id support
To:     Parav Pandit <parav@mellanox.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "zhi.a.wang@intel.com" <zhi.a.wang@intel.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
        "rodrigo.vivi@intel.com" <rodrigo.vivi@intel.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "sebott@linux.ibm.com" <sebott@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        Ido Shamay <idos@mellanox.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>
References: <20190923130331.29324-1-jasowang@redhat.com>
 <20190923130331.29324-2-jasowang@redhat.com>
 <AM0PR05MB486657BB8E48F744D219CF9BD1850@AM0PR05MB4866.eurprd05.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5b9340a9-35b0-aa97-bb5e-c99d7320b386@redhat.com>
Date:   Tue, 24 Sep 2019 19:23:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB486657BB8E48F744D219CF9BD1850@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 24 Sep 2019 11:23:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/24 上午5:02, Parav Pandit wrote:
> Hi Jason,
>
>
>> -----Original Message-----
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Monday, September 23, 2019 8:03 AM
>> To: kvm@vger.kernel.org; linux-s390@vger.kernel.org; linux-
>> kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; intel-
>> gfx@lists.freedesktop.org; intel-gvt-dev@lists.freedesktop.org;
>> kwankhede@nvidia.com; alex.williamson@redhat.com; mst@redhat.com;
>> tiwei.bie@intel.com
>> Cc: virtualization@lists.linux-foundation.org; netdev@vger.kernel.org;
>> cohuck@redhat.com; maxime.coquelin@redhat.com;
>> cunming.liang@intel.com; zhihong.wang@intel.com;
>> rob.miller@broadcom.com; xiao.w.wang@intel.com;
>> haotian.wang@sifive.com; zhenyuw@linux.intel.com; zhi.a.wang@intel.com;
>> jani.nikula@linux.intel.com; joonas.lahtinen@linux.intel.com;
>> rodrigo.vivi@intel.com; airlied@linux.ie; daniel@ffwll.ch;
>> farman@linux.ibm.com; pasic@linux.ibm.com; sebott@linux.ibm.com;
>> oberpar@linux.ibm.com; heiko.carstens@de.ibm.com; gor@linux.ibm.com;
>> borntraeger@de.ibm.com; akrowiak@linux.ibm.com; freude@linux.ibm.com;
>> lingshan.zhu@intel.com; Ido Shamay <idos@mellanox.com>;
>> eperezma@redhat.com; lulu@redhat.com; Parav Pandit
>> <parav@mellanox.com>; Jason Wang <jasowang@redhat.com>
>> Subject: [PATCH 1/6] mdev: class id support
>>
>> Mdev bus only supports vfio driver right now, so it doesn't implement match
>> method. But in the future, we may add drivers other than vfio, one example is
>> virtio-mdev[1] driver. This means we need to add device class id support in bus
>> match method to pair the mdev device and mdev driver correctly.
>>
>> So this patch adds id_table to mdev_driver and class_id for mdev parent with
>> the match method for mdev bus.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>  Documentation/driver-api/vfio-mediated-device.rst |  7 +++++--
>>  drivers/gpu/drm/i915/gvt/kvmgt.c                  |  2 +-
>>  drivers/s390/cio/vfio_ccw_ops.c                   |  2 +-
>>  drivers/s390/crypto/vfio_ap_ops.c                 |  3 ++-
>>  drivers/vfio/mdev/mdev_core.c                     | 14 ++++++++++++--
>>  drivers/vfio/mdev/mdev_driver.c                   | 14 ++++++++++++++
>>  drivers/vfio/mdev/mdev_private.h                  |  1 +
>>  drivers/vfio/mdev/vfio_mdev.c                     |  6 ++++++
>>  include/linux/mdev.h                              |  7 ++++++-
>>  include/linux/mod_devicetable.h                   |  8 ++++++++
>>  samples/vfio-mdev/mbochs.c                        |  2 +-
>>  samples/vfio-mdev/mdpy.c                          |  2 +-
>>  samples/vfio-mdev/mtty.c                          |  2 +-
>>  13 files changed, 59 insertions(+), 11 deletions(-)
>>
> You additionally need modpost support for id table integration to modifo, modprobe and other tools.
> A small patch similar to this one [1] is needed.
> Please include in the series.
>
> [1] https://lore.kernel.org/patchwork/patch/1046991/


My understanding is this could be done on top and may require uevent
support for the bus. I can try to implement this in V2.

Thanks

>
>
