Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD695B5B79
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 07:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfIRF65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 01:58:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfIRF65 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 01:58:57 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 98E773083363;
        Wed, 18 Sep 2019 05:58:56 +0000 (UTC)
Received: from [10.72.12.111] (ovpn-12-111.pek2.redhat.com [10.72.12.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72118600C8;
        Wed, 18 Sep 2019 05:58:44 +0000 (UTC)
Subject: Re: [RFC PATCH 2/4] mdev: introduce helper to set per device dma ops
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kwankhede@nvidia.com,
        cohuck@redhat.com, tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, idos@mellanox.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com
References: <20190910081935.30516-1-jasowang@redhat.com>
 <20190910081935.30516-3-jasowang@redhat.com>
 <20190917130044.4fb97637@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f0df968e-9322-829a-11c7-ca62408b9bae@redhat.com>
Date:   Wed, 18 Sep 2019 13:58:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190917130044.4fb97637@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 18 Sep 2019 05:58:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/18 上午3:00, Alex Williamson wrote:
> On Tue, 10 Sep 2019 16:19:33 +0800
> Jason Wang<jasowang@redhat.com>  wrote:
>
>> This patch introduces mdev_set_dma_ops() which allows parent to set
>> per device DMA ops. This help for the kernel driver to setup a correct
>> DMA mappings.
>>
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
>> ---
>>   drivers/vfio/mdev/mdev_core.c | 7 +++++++
>>   include/linux/mdev.h          | 2 ++
>>   2 files changed, 9 insertions(+)
>>
>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>> index b558d4cfd082..eb28552082d7 100644
>> --- a/drivers/vfio/mdev/mdev_core.c
>> +++ b/drivers/vfio/mdev/mdev_core.c
>> @@ -13,6 +13,7 @@
>>   #include <linux/uuid.h>
>>   #include <linux/sysfs.h>
>>   #include <linux/mdev.h>
>> +#include <linux/dma-mapping.h>
>>   
>>   #include "mdev_private.h"
>>   
>> @@ -27,6 +28,12 @@ static struct class_compat *mdev_bus_compat_class;
>>   static LIST_HEAD(mdev_list);
>>   static DEFINE_MUTEX(mdev_list_lock);
>>   
>> +void mdev_set_dma_ops(struct mdev_device *mdev, struct dma_map_ops *ops)
>> +{
>> +	set_dma_ops(&mdev->dev, ops);
>> +}
>> +EXPORT_SYMBOL(mdev_set_dma_ops);
>> +
> Why does mdev need to be involved here?  Your sample driver in 4/4 calls
> this from its create callback, where it could just as easily call:
>
>    set_dma_ops(mdev_dev(mdev), ops);
>
> Thanks,
> Alex


Yes, let me withdraw this patch.

Thanks

