Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E99219AE1F
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733084AbgDAOj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:39:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32110 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732843AbgDAOj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 10:39:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585751997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3dF1PbHxH2PUjMb+4bV/GaRouljVSwT6GLw7f2p2RYE=;
        b=a+aLqsr/I9qHDHqMIPi7scK5MVwbPEEdIBla0d6m7ayy6yBUHF/kQJFrZAvlnwVWvmBeIc
        9qZTq2VR14TXBaMsgVsUFLCywExGEQnflQz8oDe5YNrbb8CJ0vC/FWR/Dl6z9K70fpFiZs
        oh/2nJgYFgigzbL++jOe4F/W5qpezrc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-C322hxx7Nt6lcsGRbTY05w-1; Wed, 01 Apr 2020 10:39:55 -0400
X-MC-Unique: C322hxx7Nt6lcsGRbTY05w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5DCD8017FB;
        Wed,  1 Apr 2020 14:39:52 +0000 (UTC)
Received: from [10.72.12.139] (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A66DE19C69;
        Wed,  1 Apr 2020 14:39:35 +0000 (UTC)
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
 <20200401103311-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <51e43cc8-63fe-94c1-54f6-1200e5ef772d@redhat.com>
Date:   Wed, 1 Apr 2020 22:39:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200401103311-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/1 =E4=B8=8B=E5=8D=8810:35, Michael S. Tsirkin wrote:
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
> Will this not still have the problem with defconfigs? They don't set
> VHOST_MENU ...


Looks not, since it was enabled by default.

I tested this on s390/ppc defconfigs:

# make ARCH=3Ds390 defconfig
*** Default configuration is based on 'defconfig'
#
# No change to .config
#
# grep CONFIG_VHOST .config
CONFIG_VHOST_IOTLB=3Dm
CONFIG_VHOST=3Dm
CONFIG_VHOST_MENU=3Dy
CONFIG_VHOST_NET=3Dm
CONFIG_VHOST_VSOCK=3Dm
# CONFIG_VHOST_VDPA is not set
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

Thanks

