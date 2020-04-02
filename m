Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A501A19BAA2
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 05:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbgDBDXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 23:23:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38003 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732664AbgDBDXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 23:23:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585797802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lo4oQtgFAkpJN5E5vhIt9kZ5uAzDrIArkXhNzR8IY6M=;
        b=HE/q2pIuz2A3Bii6mHl2f4P5lMM3AyKXdjsNR90zMtq4sDCwSYuDzoP0QTy3r8TE/wE15T
        nzZ4Zx9z3H5EEqrUZ9R45IlU8EAm1eP6TJ0h3PCh9sLizumYW/fD62Z/WhOhN1R51RAKyE
        FgryWHi7TybJ8zOBieBK2oyqXRJ0zw8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-LVyMK6ydO8Sv_d3yw-jCFQ-1; Wed, 01 Apr 2020 23:23:18 -0400
X-MC-Unique: LVyMK6ydO8Sv_d3yw-jCFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 125D218A5511;
        Thu,  2 Apr 2020 03:23:16 +0000 (UTC)
Received: from [10.72.13.209] (ovpn-13-209.pek2.redhat.com [10.72.13.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EEDE89F0A;
        Thu,  2 Apr 2020 03:22:59 +0000 (UTC)
Subject: Re: [PATCH V9 1/9] vhost: refine vhost and vringh kconfig
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, zhangweining@ruijie.com.cn
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-2-jasowang@redhat.com>
 <20200401092004-mutt-send-email-mst@kernel.org>
 <6b4d169a-9962-6014-5423-1507059343e9@redhat.com>
 <20200401100954-mutt-send-email-mst@kernel.org>
 <3dd3b7e7-e3d9-dba4-00fc-868081f95ab7@redhat.com>
 <20200401120643-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c11c2195-88eb-2096-af47-40f2da5b389f@redhat.com>
Date:   Thu, 2 Apr 2020 11:22:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200401120643-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/2 =E4=B8=8A=E5=8D=8812:08, Michael S. Tsirkin wrote:
> On Wed, Apr 01, 2020 at 10:29:32PM +0800, Jason Wang wrote:
>> >From 9b3a5d23b8bf6b0a11e65e688335d782f8e6aa5c Mon Sep 17 00:00:00 200=
1
>> From: Jason Wang <jasowang@redhat.com>
>> Date: Wed, 1 Apr 2020 22:17:27 +0800
>> Subject: [PATCH] vhost: let CONFIG_VHOST to be selected by drivers
>>
>> The defconfig on some archs enable vhost_net or vhost_vsock by
>> default. So instead of adding CONFIG_VHOST=3Dm to all of those files,
>> simply letting CONFIG_VHOST to be selected by all of the vhost
>> drivers. This fixes the build on the archs with CONFIG_VHOST_NET=3Dm i=
n
>> their defconfig.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vhost/Kconfig | 15 +++++++++++----
>>   1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
>> index 2523a1d4290a..362b832f5338 100644
>> --- a/drivers/vhost/Kconfig
>> +++ b/drivers/vhost/Kconfig
>> @@ -11,19 +11,23 @@ config VHOST_RING
>>   	  This option is selected by any driver which needs to access
>>   	  the host side of a virtio ring.
>>  =20
>> -menuconfig VHOST
>> -	tristate "Host kernel accelerator for virtio (VHOST)"
>> -	depends on EVENTFD
>> +config VHOST
>> +	tristate
>>   	select VHOST_IOTLB
>>   	help
>>   	  This option is selected by any driver which needs to access
>>   	  the core of vhost.
>>  =20
>> -if VHOST
>> +menuconfig VHOST_MENU
>> +	bool "VHOST drivers"
>> +	default y
>> +
>> +if VHOST_MENU
>>  =20
>>   config VHOST_NET
>>   	tristate "Host kernel accelerator for virtio net"
>>   	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
>> +	select VHOST
>>   	---help---
>>   	  This kernel module can be loaded in host kernel to accelerate
>>   	  guest networking with virtio_net. Not to be confused with virtio_=
net
>> @@ -35,6 +39,7 @@ config VHOST_NET
>>   config VHOST_SCSI
>>   	tristate "VHOST_SCSI TCM fabric driver"
>>   	depends on TARGET_CORE && EVENTFD
>> +	select VHOST
>>   	default n
>>   	---help---
>>   	Say M here to enable the vhost_scsi TCM fabric module
>> @@ -43,6 +48,7 @@ config VHOST_SCSI
>>   config VHOST_VSOCK
>>   	tristate "vhost virtio-vsock driver"
>>   	depends on VSOCKETS && EVENTFD
>> +	select VHOST
>>   	select VIRTIO_VSOCKETS_COMMON
>>   	default n
>>   	---help---
>> @@ -56,6 +62,7 @@ config VHOST_VSOCK
>>   config VHOST_VDPA
>>   	tristate "Vhost driver for vDPA-based backend"
>>   	depends on EVENTFD
>> +	select VHOST


This part is not squashed.


>>   	select VDPA
>>   	help
>>   	  This kernel module can be loaded in host kernel to accelerate
> OK so I squashed this into the original buggy patch.
> Could you please play with vhost branch of my tree on various
> arches? If it looks ok to you let me know I'll push
> this to next.


With the above part squashed. I've tested all the archs whose defconfig=20
have VHOST_NET or VHOST_VSOCK enabled.

All looks fine.

Thanks

