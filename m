Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67BD219AE38
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732997AbgDAOoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:44:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56175 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726640AbgDAOoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 10:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585752259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3BPU8cwn4wg2zbZqCCchSQUn3Ax59cAUAtMjE3S7aOY=;
        b=f9tRftPZjazx4XEX0Ym5bMQ4fA+HQRFkXbWPVDXffzPO+rP8DrfDORJ3ZSDVhVY7PPQPRX
        MnpLx/InqPIVXuhJ4vSSRqOkwMJ4PtPkqAKihz5f0aTR1vECOL0RK3rD6HUEtE6y36Lwka
        segS3NmvrLMxjiOYUCltASFrLJ7Mq58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-bqPjN9Y6N3-rZRk9X2Igbg-1; Wed, 01 Apr 2020 10:44:18 -0400
X-MC-Unique: bqPjN9Y6N3-rZRk9X2Igbg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DDBF193578B;
        Wed,  1 Apr 2020 14:44:15 +0000 (UTC)
Received: from [10.72.12.139] (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56B7E98A53;
        Wed,  1 Apr 2020 14:43:58 +0000 (UTC)
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
 <20200401103659-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <12f0ff8f-cdf2-9aac-883c-48c39138b7ea@redhat.com>
Date:   Wed, 1 Apr 2020 22:43:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200401103659-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/1 =E4=B8=8B=E5=8D=8810:39, Michael S. Tsirkin wrote:
>> >From 9b3a5d23b8bf6b0a11e65e688335d782f8e6aa5c Mon Sep 17 00:00:00 200=
1
>> From: Jason Wang<jasowang@redhat.com>
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
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
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
> In fact this is similar to VIRTIO, and I wonder whether VIRTIO has also
> been broken by
> 	commit 7b95fec6d2ffa53f4a8d637b0f223644d458ea4e
> 	Author: Vincent Legoll<vincent.legoll@gmail.com>
> 	Date:   Sun Jan 7 12:33:56 2018 +0100
>
> 	    virtio: make VIRTIO a menuconfig to ease disabling it all
>
> I see lots of defconfigs set VIRTIO_PCI but not VIRTIO_MENU ...


Probably not since VIRTIO_MENU has "default y"

E.g for powerpc, I got:

# make ARCH=3Dpowerpc defconfig
*** Default configuration is based on 'ppc64_defconfig'
#
# No change to .config
#
# grep CONFIG_VIRTIO .config
CONFIG_VIRTIO_BLK=3Dm
CONFIG_VIRTIO_NET=3Dm
CONFIG_VIRTIO_CONSOLE=3Dm
CONFIG_VIRTIO=3Dm
CONFIG_VIRTIO_MENU=3Dy
CONFIG_VIRTIO_PCI=3Dm
CONFIG_VIRTIO_PCI_LEGACY=3Dy
# CONFIG_VIRTIO_VDPA is not set
CONFIG_VIRTIO_BALLOON=3Dm
# CONFIG_VIRTIO_INPUT is not set
# CONFIG_VIRTIO_MMIO is not set
# CONFIG_VIRTIO_FS is not set

Thanks

