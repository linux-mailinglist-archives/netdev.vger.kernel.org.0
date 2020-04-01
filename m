Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 806E419ADCF
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733024AbgDAO36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:29:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59273 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732881AbgDAO36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 10:29:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585751397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4ob21dviZZTdHWvIb0KtdbZMYAWwzulXdFLfkbiywrA=;
        b=AN1NBRfrzpEd4CG/XCNa62rq21Bu5FLDOhyUPX8cUhw1K81Od4wgc7reRc+gLLzF58ndIS
        HHb5X/ClFSVIU2bBCsYP/8viyT/ENCneBjrwtII0FzEHkiJVk/hYKIJKvHODbYh/ZAgF+d
        NixIDSsM6LAUfZZ5VgBnQvsPUEHLYu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-LLU-8J5nMAyD8jcOvJnLMA-1; Wed, 01 Apr 2020 10:29:55 -0400
X-MC-Unique: LLU-8J5nMAyD8jcOvJnLMA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AFC1107ACC9;
        Wed,  1 Apr 2020 14:29:51 +0000 (UTC)
Received: from [10.72.12.139] (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2512110016EB;
        Wed,  1 Apr 2020 14:29:33 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3dd3b7e7-e3d9-dba4-00fc-868081f95ab7@redhat.com>
Date:   Wed, 1 Apr 2020 22:29:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200401100954-mutt-send-email-mst@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------5648EAC33934DF4E8BCAE88D"
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------5648EAC33934DF4E8BCAE88D
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 2020/4/1 =E4=B8=8B=E5=8D=8810:13, Michael S. Tsirkin wrote:
> On Wed, Apr 01, 2020 at 10:08:59PM +0800, Jason Wang wrote:
>> On 2020/4/1 =E4=B8=8B=E5=8D=889:22, Michael S. Tsirkin wrote:
>>> On Thu, Mar 26, 2020 at 10:01:17PM +0800, Jason Wang wrote:
>>>> Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vhost =
is
>>>> not necessarily for VM since it's a generic userspace and kernel
>>>> communication protocol. Such dependency may prevent archs without
>>>> virtualization support from using vhost.
>>>>
>>>> To solve this, a dedicated vhost menu is created under drivers so
>>>> CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.
>>>>
>>>> While at it, also squash Kconfig.vringh into vhost Kconfig file. Thi=
s
>>>> avoids the trick of conditional inclusion from VOP or CAIF. Then it
>>>> will be easier to introduce new vringh users and common dependency f=
or
>>>> both vringh and vhost.
>>>>
>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>> Is this just so we can drop the dependency on CONFIG_VIRTUALIZATION?
>>> If yes what happens if we drop this patch?
>>
>> The problem is that then VHOST_RING must depend on CONFIG_VIRTUALIZATI=
ON
>> (which enable VHOST_IOTLB) to work.
>>
>> But it looks to me CAIF and VOP doesn't requires CONFIG_VIRTUALIZATION=
.
> How about stubs for IOTLB so VHOST_RING does not depend on VHOST_IOTLB?


That could work.


> I'm pretty sure neither user of vringh can actually use IOTLB, it's a
> software only thing.


Right.


>
>>> Given the impact it had I'd like to defer it till next release if
>>> possible.
>>>
>>>
>>>> ---
>>>>    arch/arm/kvm/Kconfig         |  2 --
>>>>    arch/arm64/kvm/Kconfig       |  2 --
>>>>    arch/mips/kvm/Kconfig        |  2 --
>>>>    arch/powerpc/kvm/Kconfig     |  2 --
>>>>    arch/s390/kvm/Kconfig        |  4 ----
>>>>    arch/x86/kvm/Kconfig         |  4 ----
>>>>    drivers/Kconfig              |  2 ++
>>>>    drivers/misc/mic/Kconfig     |  4 ----
>>>>    drivers/net/caif/Kconfig     |  4 ----
>>>>    drivers/vhost/Kconfig        | 23 ++++++++++++++---------
>>>>    drivers/vhost/Kconfig.vringh |  6 ------
>>>>    11 files changed, 16 insertions(+), 39 deletions(-)
>>>>    delete mode 100644 drivers/vhost/Kconfig.vringh
>>>>
>>>> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
>>>> index f591026347a5..be97393761bf 100644
>>>> --- a/arch/arm/kvm/Kconfig
>>>> +++ b/arch/arm/kvm/Kconfig
>>>> @@ -54,6 +54,4 @@ config KVM_ARM_HOST
>>>>    	---help---
>>>>    	  Provides host support for ARM processors.
>>>> -source "drivers/vhost/Kconfig"
>>>> -
>>>>    endif # VIRTUALIZATION
>>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>>>> index a475c68cbfec..449386d76441 100644
>>>> --- a/arch/arm64/kvm/Kconfig
>>>> +++ b/arch/arm64/kvm/Kconfig
>>>> @@ -64,6 +64,4 @@ config KVM_ARM_PMU
>>>>    config KVM_INDIRECT_VECTORS
>>>>           def_bool KVM && (HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VEC=
TORS)
>>>> -source "drivers/vhost/Kconfig"
>>>> -
>>>>    endif # VIRTUALIZATION
>>>> diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
>>>> index eac25aef21e0..b91d145aa2d5 100644
>>>> --- a/arch/mips/kvm/Kconfig
>>>> +++ b/arch/mips/kvm/Kconfig
>>>> @@ -72,6 +72,4 @@ config KVM_MIPS_DEBUG_COP0_COUNTERS
>>>>    	  If unsure, say N.
>>>> -source "drivers/vhost/Kconfig"
>>>> -
>>>>    endif # VIRTUALIZATION
>>>> diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
>>>> index 711fca9bc6f0..12885eda324e 100644
>>>> --- a/arch/powerpc/kvm/Kconfig
>>>> +++ b/arch/powerpc/kvm/Kconfig
>>>> @@ -204,6 +204,4 @@ config KVM_XIVE
>>>>    	default y
>>>>    	depends on KVM_XICS && PPC_XIVE_NATIVE && KVM_BOOK3S_HV_POSSIBLE
>>>> -source "drivers/vhost/Kconfig"
>>>> -
>>>>    endif # VIRTUALIZATION
>>>> diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
>>>> index d3db3d7ed077..def3b60f1fe8 100644
>>>> --- a/arch/s390/kvm/Kconfig
>>>> +++ b/arch/s390/kvm/Kconfig
>>>> @@ -55,8 +55,4 @@ config KVM_S390_UCONTROL
>>>>    	  If unsure, say N.
>>>> -# OK, it's a little counter-intuitive to do this, but it puts it ne=
atly under
>>>> -# the virtualization menu.
>>>> -source "drivers/vhost/Kconfig"
>>>> -
>>>>    endif # VIRTUALIZATION
>>>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
>>>> index 991019d5eee1..0dfe70e17af9 100644
>>>> --- a/arch/x86/kvm/Kconfig
>>>> +++ b/arch/x86/kvm/Kconfig
>>>> @@ -94,8 +94,4 @@ config KVM_MMU_AUDIT
>>>>    	 This option adds a R/W kVM module parameter 'mmu_audit', which =
allows
>>>>    	 auditing of KVM MMU events at runtime.
>>>> -# OK, it's a little counter-intuitive to do this, but it puts it ne=
atly under
>>>> -# the virtualization menu.
>>>> -source "drivers/vhost/Kconfig"
>>>> -
>>>>    endif # VIRTUALIZATION
>>>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>>>> index 8befa53f43be..7a6d8b2b68b4 100644
>>>> --- a/drivers/Kconfig
>>>> +++ b/drivers/Kconfig
>>>> @@ -138,6 +138,8 @@ source "drivers/virt/Kconfig"
>>>>    source "drivers/virtio/Kconfig"
>>>> +source "drivers/vhost/Kconfig"
>>>> +
>>>>    source "drivers/hv/Kconfig"
>>>>    source "drivers/xen/Kconfig"
>>>> diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
>>>> index b6841ba6d922..8f201d019f5a 100644
>>>> --- a/drivers/misc/mic/Kconfig
>>>> +++ b/drivers/misc/mic/Kconfig
>>>> @@ -133,8 +133,4 @@ config VOP
>>>>    	  OS and tools for MIC to use with this driver are available fro=
m
>>>>    	  <http://software.intel.com/en-us/mic-developer>.
>>>> -if VOP
>>>> -source "drivers/vhost/Kconfig.vringh"
>>>> -endif
>>>> -
>>>>    endmenu
>>>> diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
>>>> index e74e2bb61236..9db0570c5beb 100644
>>>> --- a/drivers/net/caif/Kconfig
>>>> +++ b/drivers/net/caif/Kconfig
>>>> @@ -58,8 +58,4 @@ config CAIF_VIRTIO
>>>>    	---help---
>>>>    	  The CAIF driver for CAIF over Virtio.
>>>> -if CAIF_VIRTIO
>>>> -source "drivers/vhost/Kconfig.vringh"
>>>> -endif
>>>> -
>>>>    endif # CAIF_DRIVERS
>>>> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
>>>> index 3d03ccbd1adc..4aef10a54cd1 100644
>>>> --- a/drivers/vhost/Kconfig
>>>> +++ b/drivers/vhost/Kconfig
>>>> @@ -1,8 +1,20 @@
>>>>    # SPDX-License-Identifier: GPL-2.0-only
>>>> +config VHOST_RING
>>>> +	tristate
>>>> +	help
>>>> +	  This option is selected by any driver which needs to access
>>>> +	  the host side of a virtio ring.
>>>> +
>>>> +menuconfig VHOST
>>>> +	tristate "Host kernel accelerator for virtio (VHOST)"
>>>> +	help
>>>> +	  This option is selected by any driver which needs to access
>>>> +	  the core of vhost.
>>>> +if VHOST
>>>> +
>>> The description here is wrong, isn't it?
>>> VHOST and VHOST_RING are no longer selected, right?
>>
>> For VHOST not currently.
> Can we just bring it back and select it?


Right, so if bring it back, we don't even need the stub.

How about something like attached?

Thanks


>
>> For VHOST_RING, it was selected by CAIF, VOP and VDPASIM.
>>
>> Thanks
>>
>>
>>>
>>>>    config VHOST_NET
>>>>    	tristate "Host kernel accelerator for virtio net"
>>>>    	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
>>>> -	select VHOST
>>>>    	---help---
>>>>    	  This kernel module can be loaded in host kernel to accelerate
>>>>    	  guest networking with virtio_net. Not to be confused with virt=
io_net
>>>> @@ -14,7 +26,6 @@ config VHOST_NET
>>>>    config VHOST_SCSI
>>>>    	tristate "VHOST_SCSI TCM fabric driver"
>>>>    	depends on TARGET_CORE && EVENTFD
>>>> -	select VHOST
>>>>    	default n
>>>>    	---help---
>>>>    	Say M here to enable the vhost_scsi TCM fabric module
>>>> @@ -24,7 +35,6 @@ config VHOST_VSOCK
>>>>    	tristate "vhost virtio-vsock driver"
>>>>    	depends on VSOCKETS && EVENTFD
>>>>    	select VIRTIO_VSOCKETS_COMMON
>>>> -	select VHOST
>>>>    	default n
>>>>    	---help---
>>>>    	This kernel module can be loaded in the host kernel to provide A=
F_VSOCK
>>>> @@ -34,12 +44,6 @@ config VHOST_VSOCK
>>>>    	To compile this driver as a module, choose M here: the module wi=
ll be called
>>>>    	vhost_vsock.
>>>> -config VHOST
>>>> -	tristate
>>>> -	---help---
>>>> -	  This option is selected by any driver which needs to access
>>>> -	  the core of vhost.
>>>> -
>>>>    config VHOST_CROSS_ENDIAN_LEGACY
>>>>    	bool "Cross-endian support for vhost"
>>>>    	default n
>>>> @@ -54,3 +58,4 @@ config VHOST_CROSS_ENDIAN_LEGACY
>>>>    	  adds some overhead, it is disabled by default.
>>>>    	  If unsure, say "N".
>>>> +endif
>>>> diff --git a/drivers/vhost/Kconfig.vringh b/drivers/vhost/Kconfig.vr=
ingh
>>>> deleted file mode 100644
>>>> index c1fe36a9b8d4..000000000000
>>>> --- a/drivers/vhost/Kconfig.vringh
>>>> +++ /dev/null
>>>> @@ -1,6 +0,0 @@
>>>> -# SPDX-License-Identifier: GPL-2.0-only
>>>> -config VHOST_RING
>>>> -	tristate
>>>> -	---help---
>>>> -	  This option is selected by any driver which needs to access
>>>> -	  the host side of a virtio ring.
>>>> --=20
>>>> 2.20.1

--------------5648EAC33934DF4E8BCAE88D
Content-Type: text/x-patch;
 name="0001-vhost-let-CONFIG_VHOST-to-be-selected-by-drivers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-vhost-let-CONFIG_VHOST-to-be-selected-by-drivers.patch"

From 9b3a5d23b8bf6b0a11e65e688335d782f8e6aa5c Mon Sep 17 00:00:00 2001
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 1 Apr 2020 22:17:27 +0800
Subject: [PATCH] vhost: let CONFIG_VHOST to be selected by drivers

The defconfig on some archs enable vhost_net or vhost_vsock by
default. So instead of adding CONFIG_VHOST=m to all of those files,
simply letting CONFIG_VHOST to be selected by all of the vhost
drivers. This fixes the build on the archs with CONFIG_VHOST_NET=m in
their defconfig.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/Kconfig | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 2523a1d4290a..362b832f5338 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -11,19 +11,23 @@ config VHOST_RING
 	  This option is selected by any driver which needs to access
 	  the host side of a virtio ring.
 
-menuconfig VHOST
-	tristate "Host kernel accelerator for virtio (VHOST)"
-	depends on EVENTFD
+config VHOST
+	tristate
 	select VHOST_IOTLB
 	help
 	  This option is selected by any driver which needs to access
 	  the core of vhost.
 
-if VHOST
+menuconfig VHOST_MENU
+	bool "VHOST drivers"
+	default y
+
+if VHOST_MENU
 
 config VHOST_NET
 	tristate "Host kernel accelerator for virtio net"
 	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
+	select VHOST
 	---help---
 	  This kernel module can be loaded in host kernel to accelerate
 	  guest networking with virtio_net. Not to be confused with virtio_net
@@ -35,6 +39,7 @@ config VHOST_NET
 config VHOST_SCSI
 	tristate "VHOST_SCSI TCM fabric driver"
 	depends on TARGET_CORE && EVENTFD
+	select VHOST
 	default n
 	---help---
 	Say M here to enable the vhost_scsi TCM fabric module
@@ -43,6 +48,7 @@ config VHOST_SCSI
 config VHOST_VSOCK
 	tristate "vhost virtio-vsock driver"
 	depends on VSOCKETS && EVENTFD
+	select VHOST
 	select VIRTIO_VSOCKETS_COMMON
 	default n
 	---help---
@@ -56,6 +62,7 @@ config VHOST_VSOCK
 config VHOST_VDPA
 	tristate "Vhost driver for vDPA-based backend"
 	depends on EVENTFD
+	select VHOST
 	select VDPA
 	help
 	  This kernel module can be loaded in host kernel to accelerate
-- 
2.20.1


--------------5648EAC33934DF4E8BCAE88D--

