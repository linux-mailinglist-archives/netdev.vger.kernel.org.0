Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFB3CDE9A6
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfJUKfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:35:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33267 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727110AbfJUKfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 06:35:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571654138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0DnCthajA3/6lfuH0XJTCH6IdeBMpPURlRQY1CtCFEo=;
        b=CVRlk/A/iObZ5OKnLlz4ZOhDtSoWX6SOh0uCNrPkAdWfymjzlsHPGtsJtlQCZRaVATVbIH
        MAJ6/84/vFmTBmqFgKHH3t7X0H95lAutXH9GynNUlORNriVi3FVSOCGb2RPA9zgeA0g9Tv
        tu82LRWwC7Nrio/zL5uIElz8ux+Iyvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143--6O332lDM9u_4VQHatygBg-1; Mon, 21 Oct 2019 06:35:35 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 038851800D79;
        Mon, 21 Oct 2019 10:35:34 +0000 (UTC)
Received: from [10.72.12.22] (ovpn-12-22.pek2.redhat.com [10.72.12.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7ACF5D9E2;
        Mon, 21 Oct 2019 10:35:24 +0000 (UTC)
Subject: Re: [RFC 1/2] vhost: IFC VF hardware operation layer
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016013050.3918-1-lingshan.zhu@intel.com>
 <20191016013050.3918-2-lingshan.zhu@intel.com>
 <991d41c6-4032-6341-f6c8-6e69d698f629@redhat.com>
 <cc508c6d-4aea-cd3f-3487-4acf11f42b8c@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <07b241a8-ecb1-5baa-c931-f9afb3bb4de5@redhat.com>
Date:   Mon, 21 Oct 2019 18:35:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cc508c6d-4aea-cd3f-3487-4acf11f42b8c@intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: -6O332lDM9u_4VQHatygBg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/21 =E4=B8=8B=E5=8D=886:00, Zhu, Lingshan wrote:
>
> On 10/16/2019 4:40 PM, Jason Wang wrote:
>>
>> On 2019/10/16 =E4=B8=8A=E5=8D=889:30, Zhu Lingshan wrote:
>>> This commit introduced ifcvf_base layer, which handles IFC VF NIC
>>> hardware operations and configurations.
>>
>>
>> It's better to describe the difference between ifc vf and virtio in=20
>> the commit log or is there a open doc for this?
>>
>>
> Hi Jason,
>
> Sure, I will split these code into small patches with detailed commit=20
> logs in v1 patchset.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>> =C2=A0 drivers/vhost/ifcvf/ifcvf_base.c | 390=20
>>> +++++++++++++++++++++++++++++++++++++++
>>> =C2=A0 drivers/vhost/ifcvf/ifcvf_base.h | 137 ++++++++++++++
>>> =C2=A0 2 files changed, 527 insertions(+)
>>> =C2=A0 create mode 100644 drivers/vhost/ifcvf/ifcvf_base.c
>>> =C2=A0 create mode 100644 drivers/vhost/ifcvf/ifcvf_base.h
>>>
>>> diff --git a/drivers/vhost/ifcvf/ifcvf_base.c=20
>>> b/drivers/vhost/ifcvf/ifcvf_base.c
>>> new file mode 100644
>>> index 000000000000..b85e14c9bdcf
>>> --- /dev/null
>>> +++ b/drivers/vhost/ifcvf/ifcvf_base.c
>>> @@ -0,0 +1,390 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Copyright (C) 2019 Intel Corporation.
>>> + */
>>> +
>>> +#include "ifcvf_base.h"
>>> +
>>> +static void *get_cap_addr(struct ifcvf_hw *hw, struct=20
>>> virtio_pci_cap *cap)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 u8 bar =3D cap->bar;
>>> +=C2=A0=C2=A0=C2=A0 u32 length =3D cap->length;
>>> +=C2=A0=C2=A0=C2=A0 u32 offset =3D cap->offset;
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *ifcvf =3D
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 container_of(hw, struct ifc=
vf_adapter, vf);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (bar >=3D IFCVF_PCI_MAX_RESOURCE) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC_ERR(ifcvf->dev,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "In=
valid bar number %u to get capabilities.\n", bar);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (offset + length < offset) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC_ERR(ifcvf->dev, "offset=
(%u) + length(%u) overflows\n",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 off=
set, length);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (offset + length > hw->mem_resource[cap->bar].le=
n) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC_ERR(ifcvf->dev,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "of=
fset(%u) + len(%u) overflows bar%u to get=20
>>> capabilities.\n",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 off=
set, length, bar);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return hw->mem_resource[bar].addr + offset;
>>> +}
>>> +
>>> +int ifcvf_read_config_range(struct pci_dev *dev,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uin=
t32_t *val, int size, int where)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 int i;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < size; i +=3D 4) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pci_read_config_dword(d=
ev, where + i, val + i / 4) < 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
urn -1;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>> +
>>> +int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>> +=C2=A0=C2=A0=C2=A0 u8 pos;
>>> +=C2=A0=C2=A0=C2=A0 struct virtio_pci_cap cap;
>>> +=C2=A0=C2=A0=C2=A0 u32 i;
>>> +=C2=A0=C2=A0=C2=A0 u16 notify_off;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D pci_read_config_byte(dev, PCI_CAPABILITY_LI=
ST, &pos);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC_ERR(&dev->dev, "failed =
to read PCI capability list.\n");
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EIO;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 while (pos) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D ifcvf_read_config_r=
ange(dev, (u32 *)&cap,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 sizeof(cap), pos);
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC=
_ERR(&dev->dev, "failed to get PCI capability at %x",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pos);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bre=
ak;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cap.cap_vndr !=3D PCI_C=
AP_ID_VNDR)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 got=
o next;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC_INFO(&dev->dev, "read P=
CI config:\n"
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "config type: %u.\n"
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "PCI bar: %u.\n"
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "PCI bar offset: %u.\n"
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "PCI config len: %u.\n",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cap.cfg_type, cap.bar,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cap.offset, cap.length);
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (cap.cfg_type) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case VIRTIO_PCI_CAP_COMMON_=
CFG:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hw-=
>common_cfg =3D get_cap_addr(hw, &cap);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC=
_INFO(&dev->dev, "hw->common_cfg =3D %p.\n",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hw->common_cfg);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bre=
ak;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case VIRTIO_PCI_CAP_NOTIFY_=
CFG:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pci=
_read_config_dword(dev, pos + sizeof(cap),
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &hw->notify_off_multiplier);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hw-=
>notify_bar =3D cap.bar;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hw-=
>notify_base =3D get_cap_addr(hw, &cap);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC=
_INFO(&dev->dev, "hw->notify_base =3D %p.\n",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hw->notify_base);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bre=
ak;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case VIRTIO_PCI_CAP_ISR_CFG=
:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hw-=
>isr =3D get_cap_addr(hw, &cap);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC=
_INFO(&dev->dev, "hw->isr =3D %p.\n", hw->isr);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bre=
ak;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case VIRTIO_PCI_CAP_DEVICE_=
CFG:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hw-=
>dev_cfg =3D get_cap_addr(hw, &cap);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC=
_INFO(&dev->dev, "hw->dev_cfg =3D %p.\n", hw->dev_cfg);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bre=
ak;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +next:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pos =3D cap.cap_next;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (hw->common_cfg =3D=3D NULL || hw->notify_base =
=3D=3D NULL ||
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hw->isr =3D=3D NULL || hw->=
dev_cfg =3D=3D NULL) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC_ERR(&dev->dev, "Incompl=
ete PCI capabilities.\n");
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < (IFCVF_MAX_QUEUE_PAIRS * 2); i++)=
 {
>>
>>
>> Any reason for using hard coded queue pairs limit other than the=20
>> max_queue_pairs in the net config?
> Hi Jason, Thanks for your kindly comments. For now the driver don't=20
> support MQ, we intend to provide a minimal feature sets in this=20
> version 1 driver.


Ok, it's better to add comment above IFCVF_MAX_QUEUE_PAIRS.


>>
>>
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iowrite16(i, &hw->common_cf=
g->queue_select);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 notify_off =3D ioread16(&hw=
->common_cfg->queue_notify_off);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hw->notify_addr[i] =3D (voi=
d *)((u8 *)hw->notify_base +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 notify_off * hw->notify_off_multiplier);
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 hw->lm_cfg =3D hw->mem_resource[4].addr;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 IFC_INFO(&dev->dev, "PCI capability mapping:\n"
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 "common cfg: %p\n"
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 "notify base: %p\n"
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 "isr cfg: %p\n"
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 "device cfg: %p\n"
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 "multiplier: %u\n",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 hw->common_cfg,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 hw->notify_base,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 hw->isr,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 hw->dev_cfg,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 hw->notify_off_multiplier);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>> +
>>> +static u8 ifcvf_get_status(struct ifcvf_hw *hw)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return ioread8(&hw->common_cfg->device_status);
>>> +}
>>> +
>>> +static void ifcvf_set_status(struct ifcvf_hw *hw, u8 status)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 iowrite8(status, &hw->common_cfg->device_status);
>>> +}
>>> +
>>> +static void ifcvf_reset(struct ifcvf_hw *hw)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_set_status(hw, 0);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /* flush status write */
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_get_status(hw);
>>
>>
>> Why this flush is needed?
>
> accoring to PCIE requirements, this get_status() after a set_status()=20
> is used to block the call chain, make sure the hardware has finished=20
> the write operation.
>
> It is a bad comment anyway, I will remove it.


Interesting, does this mean if we need also fix the vp_set_status for=20
kernel virtio_pci driver?


>
>>
>>
>>> +=C2=A0=C2=A0=C2=A0 hw->generation++;
>>> +}
>>> +
>>> +static void ifcvf_add_status(struct ifcvf_hw *hw, u8 status)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 if (status !=3D 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 status |=3D ifcvf_get_statu=
s(hw);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_set_status(hw, status);
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_get_status(hw);
>>> +}
>>> +
>>> +u64 ifcvf_get_features(struct ifcvf_hw *hw)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 u32 features_lo, features_hi;
>>> +=C2=A0=C2=A0=C2=A0 struct virtio_pci_common_cfg *cfg =3D hw->common_cf=
g;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 iowrite32(0, &cfg->device_feature_select);
>>> +=C2=A0=C2=A0=C2=A0 features_lo =3D ioread32(&cfg->device_feature);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 iowrite32(1, &cfg->device_feature_select);
>>> +=C2=A0=C2=A0=C2=A0 features_hi =3D ioread32(&cfg->device_feature);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return ((u64)features_hi << 32) | features_lo;
>>> +}
>>> +static int ifcvf_with_feature(struct ifcvf_hw *hw, u64 bit)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return (hw->req_features & (1ULL << bit)) !=3D 0;
>>> +}
>>> +
>>> +static void ifcvf_read_dev_config(struct ifcvf_hw *hw, u64 offset,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 void *dst, int length)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 int i;
>>> +=C2=A0=C2=A0=C2=A0 u8 *p;
>>> +=C2=A0=C2=A0=C2=A0 u8 old_gen, new_gen;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 do {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 old_gen =3D ioread8(&hw->co=
mmon_cfg->config_generation);
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 p =3D dst;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < length; i=
++)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *p+=
+ =3D ioread8((u8 *)hw->dev_cfg + offset + i);
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 new_gen =3D ioread8(&hw->co=
mmon_cfg->config_generation);
>>> +=C2=A0=C2=A0=C2=A0 } while (old_gen !=3D new_gen);
>>> +}
>>> +
>>> +void ifcvf_get_linkstatus(struct ifcvf_hw *hw, u8 *is_linkup)
>>> +{
>>
>>
>> Why not just return bollean?
> sure, can do.
>>
>>
>>> +=C2=A0=C2=A0=C2=A0 u16 status;
>>> +=C2=A0=C2=A0=C2=A0 u64 host_features;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 host_features =3D ifcvf_get_features(hw);
>>> +=C2=A0=C2=A0=C2=A0 if (ifcvf_with_feature(hw, VIRTIO_NET_F_STATUS)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ifcvf_read_dev_config(hw,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 offsetof(struct ifcvf_net_config, status),
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &status, sizeof(status));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ((status & VIRTIO_NET_S_=
LINK_UP) =3D=3D 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (*i=
s_linkup) =3D 1;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (*i=
s_linkup) =3D 0;
>>> +=C2=A0=C2=A0=C2=A0 } else
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (*is_linkup) =3D 0;
>>> +}
>>> +
>>> +static void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct virtio_pci_common_cfg *cfg =3D hw->common_cf=
g;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 iowrite32(0, &cfg->guest_feature_select);
>>> +=C2=A0=C2=A0=C2=A0 iowrite32(features & ((1ULL << 32) - 1), &cfg->gues=
t_feature);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 iowrite32(1, &cfg->guest_feature_select);
>>> +=C2=A0=C2=A0=C2=A0 iowrite32(features >> 32, &cfg->guest_feature);
>>> +}
>>> +
>>> +static int ifcvf_config_features(struct ifcvf_hw *hw)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 u64 host_features;
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *ifcvf =3D
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 container_of(hw, struct ifc=
vf_adapter, vf);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 host_features =3D ifcvf_get_features(hw);
>>> +=C2=A0=C2=A0=C2=A0 hw->req_features &=3D host_features;
>>
>>
>> Is this a must, can't device deal with this?
> I will usehw->req_features directly, thanks for point it out.
>>
>>
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_set_features(hw, hw->req_features);
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_add_status(hw, VIRTIO_CONFIG_S_FEATURES_OK);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (!(ifcvf_get_status(hw) & VIRTIO_CONFIG_S_FEATUR=
ES_OK)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC_ERR(ifcvf->dev, "Failed=
 to set FEATURES_OK status\n");
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EIO;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>> +
>>> +static void io_write64_twopart(u64 val, u32 *lo, u32 *hi)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 iowrite32(val & ((1ULL << 32) - 1), lo);
>>> +=C2=A0=C2=A0=C2=A0 iowrite32(val >> 32, hi);
>>> +}
>>> +
>>> +static int ifcvf_hw_enable(struct ifcvf_hw *hw)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct virtio_pci_common_cfg *cfg;
>>> +=C2=A0=C2=A0=C2=A0 u8 *lm_cfg;
>>> +=C2=A0=C2=A0=C2=A0 u32 i;
>>> +=C2=A0=C2=A0=C2=A0 struct ifcvf_adapter *ifcvf =3D
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 container_of(hw, struct ifc=
vf_adapter, vf);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 cfg =3D hw->common_cfg;
>>> +=C2=A0=C2=A0=C2=A0 lm_cfg =3D hw->lm_cfg;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
>>> +=C2=A0=C2=A0=C2=A0 if (ioread16(&cfg->msix_config) =3D=3D VIRTIO_MSI_N=
O_VECTOR) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC_ERR(ifcvf->dev, "No msi=
x vector for device config.\n");
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < hw->nr_vring; i++) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iowrite16(i, &cfg->queue_se=
lect);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 io_write64_twopart(hw->vrin=
g[i].desc, &cfg->queue_desc_lo,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &cfg->queue_desc_hi);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 io_write64_twopart(hw->vrin=
g[i].avail, &cfg->queue_avail_lo,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &cfg->queue_avail_hi);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 io_write64_twopart(hw->vrin=
g[i].used, &cfg->queue_used_lo,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &cfg->queue_used_hi);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iowrite16(hw->vring[i].size=
, &cfg->queue_size);
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *(u32 *)(lm_cfg + IFCVF_LM_=
RING_STATE_OFFSET +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 (i / 2) * IFCVF_LM_CFG_SIZE + (i % 2) * 4) =3D
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (u3=
2)hw->vring[i].last_avail_idx |
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ((u=
32)hw->vring[i].last_used_idx << 16);
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iowrite16(i + IFCVF_MSI_QUE=
UE_OFF, &cfg->queue_msix_vector);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ioread16(&cfg->queue_ms=
ix_vector) =3D=3D
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 VIRTIO_MSI_NO_VECTOR) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IFC=
_ERR(ifcvf->dev,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 "No msix vector for queue %u.\n", i);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
urn -1;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iowrite16(1, &cfg->queue_en=
able);
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>> +
>>> +static void ifcvf_hw_disable(struct ifcvf_hw *hw)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 u32 i;
>>> +=C2=A0=C2=A0=C2=A0 struct virtio_pci_common_cfg *cfg;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 cfg =3D hw->common_cfg;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->msix_config);
>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < hw->nr_vring; i++) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iowrite16(i, &cfg->queue_se=
lect);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iowrite16(0, &cfg->queue_en=
able);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iowrite16(VIRTIO_MSI_NO_VEC=
TOR, &cfg->queue_msix_vector);
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +}
>>> +
>>> +int ifcvf_start_hw(struct ifcvf_hw *hw)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_reset(hw);
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_add_status(hw, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (ifcvf_config_features(hw) < 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (ifcvf_hw_enable(hw) < 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER_OK);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>> +
>>> +void ifcvf_stop_hw(struct ifcvf_hw *hw)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_hw_disable(hw);
>>> +=C2=A0=C2=A0=C2=A0 ifcvf_reset(hw);
>>> +}
>>> +
>>> +void ifcvf_enable_logging_vf(struct ifcvf_hw *hw, u64 log_base, u64=20
>>> log_size)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 u8 *lm_cfg;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 lm_cfg =3D hw->lm_cfg;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 *(u32 *)(lm_cfg + IFCVF_LM_BASE_ADDR_LOW) =3D
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 log_base & IFCVF_32_BIT_MAS=
K;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 *(u32 *)(lm_cfg + IFCVF_LM_BASE_ADDR_HIGH) =3D
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (log_base >> 32) & IFCVF_32=
_BIT_MASK;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 *(u32 *)(lm_cfg + IFCVF_LM_END_ADDR_LOW) =3D
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (log_base + log_size) & IFC=
VF_32_BIT_MASK;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 *(u32 *)(lm_cfg + IFCVF_LM_END_ADDR_HIGH) =3D
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ((log_base + log_size) >> 3=
2) & IFCVF_32_BIT_MASK;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 *(u32 *)(lm_cfg + IFCVF_LM_LOGGING_CTRL) =3D IFCVF_=
LM_ENABLE_VF;
>>> +}
>>
>>
>> Is the device using iova or gpa for the logging?
> gpa, I will remove all LM related functions since we plan to support=20
> LM in next version driver.


Ok, that's why vIOMMU is not fully supported in the case. So we need

1) Filter out _F_IOMMU_PLATFORM for vhost-mdev

2) Can keep it for virtio-mdev

But one more question is: how device know which kinds of address it is=20
used? Or I guess the device doesn't know the only problem is IOVA->GPA=20
conversion in the case of vIOMMU. If this is true, maybe we can=20
introduce API to sync dirty pages and do the conversion there instead of=20
using share memory as the log as what current vhost did.


>>
>>
>>> +
>>> +void ifcvf_disable_logging(struct ifcvf_hw *hw)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 u8 *lm_cfg;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 lm_cfg =3D hw->lm_cfg;
>>> +=C2=A0=C2=A0=C2=A0 *(u32 *)(lm_cfg + IFCVF_LM_LOGGING_CTRL) =3D IFCVF_=
LM_DISABLE;
>>> +}
>>> +
>>> +void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid)
>>> +{
>>> +
>>> +=C2=A0=C2=A0=C2=A0 iowrite16(qid, hw->notify_addr[qid]);
>>> +}
>>> +
>>> +u8 ifcvf_get_notify_region(struct ifcvf_hw *hw)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return hw->notify_bar;
>>> +}
>>> +
>>> +u64 ifcvf_get_queue_notify_off(struct ifcvf_hw *hw, int qid)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return (u8 *)hw->notify_addr[qid] -
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (u8 *)hw->mem_resource[hw->=
notify_bar].addr;
>>> +}
>>> diff --git a/drivers/vhost/ifcvf/ifcvf_base.h=20
>>> b/drivers/vhost/ifcvf/ifcvf_base.h
>>> new file mode 100644
>>> index 000000000000..1ab1a1c40f24
>>> --- /dev/null
>>> +++ b/drivers/vhost/ifcvf/ifcvf_base.h
>>> @@ -0,0 +1,137 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>> +/*
>>> + * Copyright (C) 2019 Intel Corporation.
>>> + */
>>> +
>>> +#ifndef _IFCVF_H_
>>> +#define _IFCVF_H_
>>> +
>>> +#include <linux/virtio_mdev.h>
>>> +#include <linux/pci.h>
>>> +#include <linux/pci_regs.h>
>>> +#include <uapi/linux/virtio_net.h>
>>> +#include <uapi/linux/virtio_config.h>
>>> +#include <uapi/linux/virtio_pci.h>
>>> +
>>> +#define IFCVF_VENDOR_ID=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0x1AF4
>>> +#define IFCVF_DEVICE_ID=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0x1041
>>> +#define IFCVF_SUBSYS_VENDOR_ID=C2=A0 0x8086
>>> +#define IFCVF_SUBSYS_DEVICE_ID=C2=A0 0x001A
>>> +
>>> +/*
>>> + * Some ifcvf feature bits (currently bits 28 through 31) are
>>> + * reserved for the transport being used (eg. ifcvf_ring), the
>>> + * rest are per-device feature bits.
>>> + */
>>> +#define IFCVF_TRANSPORT_F_START 28
>>> +#define IFCVF_TRANSPORT_F_END=C2=A0=C2=A0 34
>>> +
>>> +#define IFC_SUPPORTED_FEATURES \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ((1ULL << VIRTIO_NET_F_MAC)=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << VIRTIO_F_ANY=
_LAYOUT)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
| \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << VIRTIO_F_VER=
SION_1) | \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << VHOST_F_LOG_=
ALL)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << VIRTIO_NET_F=
_GUEST_ANNOUNCE)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << VIRTIO_NET_F=
_CTRL_VQ)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 | \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << VIRTIO_NET_F=
_STATUS)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
| \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << VIRTIO_NET_F=
_MRG_RXBUF)) /* not fully supported */
>>> +
>>> +#define IFCVF_MAX_QUEUE_PAIRS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 1
>>> +#define IFCVF_MAX_QUEUES=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2
>>> +
>>> +#define IFCVF_QUEUE_ALIGNMENT=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 PAGE_SIZE
>>> +
>>> +#define IFCVF_MSI_CONFIG_OFF=C2=A0=C2=A0=C2=A0 0
>>> +#define IFCVF_MSI_QUEUE_OFF=C2=A0=C2=A0=C2=A0 1
>>> +#define IFCVF_PCI_MAX_RESOURCE=C2=A0=C2=A0=C2=A0 6
>>> +
>>> +/* 46 bit CPU physical address, avoid overlap */
>>> +#define LM_IOVA 0x400000000000
>>> +
>>> +#define IFCVF_LM_CFG_SIZE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x=
40
>>> +#define IFCVF_LM_RING_STATE_OFFSET=C2=A0=C2=A0=C2=A0 0x20
>>> +
>>> +#define IFCVF_LM_LOGGING_CTRL=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0x0
>>> +
>>> +#define IFCVF_LM_BASE_ADDR_LOW=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0x10
>>> +#define IFCVF_LM_BASE_ADDR_HIGH=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0x14
>>> +#define IFCVF_LM_END_ADDR_LOW=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0x18
>>> +#define IFCVF_LM_END_ADDR_HIGH=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0x1c
>>> +
>>> +#define IFCVF_LM_DISABLE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x0
>>> +#define IFCVF_LM_ENABLE_VF=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=
x1
>>> +#define IFCVF_LM_ENABLE_PF=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=
x3
>>> +
>>> +#define IFCVF_32_BIT_MASK=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x=
ffffffff
>>> +
>>> +#define IFC_ERR(dev, fmt, ...)=C2=A0=C2=A0=C2=A0 dev_err(dev, fmt, ##_=
_VA_ARGS__)
>>> +#define IFC_INFO(dev, fmt, ...)=C2=A0=C2=A0=C2=A0 dev_info(dev, fmt, #=
#__VA_ARGS__)
>>> +
>>> +struct ifcvf_net_config {
>>> +=C2=A0=C2=A0=C2=A0 u8=C2=A0=C2=A0=C2=A0 mac[6];
>>> +=C2=A0=C2=A0=C2=A0 u16=C2=A0=C2=A0 status;
>>> +=C2=A0=C2=A0=C2=A0 u16=C2=A0=C2=A0 max_virtqueue_pairs;
>>> +} __packed;
>>> +
>>> +struct ifcvf_pci_mem_resource {
>>> +=C2=A0=C2=A0=C2=A0 u64=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 phys_addr; /**< P=
hysical address, 0 if not resource. */
>>> +=C2=A0=C2=A0=C2=A0 u64=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 len;=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 /**< Length of the resource. */
>>> +=C2=A0=C2=A0=C2=A0 u8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *addr;=C2=A0=
=C2=A0=C2=A0=C2=A0 /**< Virtual address, NULL when not mapped. */
>>> +};
>>> +
>>> +struct vring_info {
>>> +=C2=A0=C2=A0=C2=A0 u64 desc;
>>> +=C2=A0=C2=A0=C2=A0 u64 avail;
>>> +=C2=A0=C2=A0=C2=A0 u64 used;
>>> +=C2=A0=C2=A0=C2=A0 u16 size;
>>> +=C2=A0=C2=A0=C2=A0 u16 last_avail_idx;
>>> +=C2=A0=C2=A0=C2=A0 u16 last_used_idx;
>>> +=C2=A0=C2=A0=C2=A0 bool ready;
>>> +=C2=A0=C2=A0=C2=A0 char msix_name[256];
>>> +=C2=A0=C2=A0=C2=A0 struct virtio_mdev_callback cb;
>>> +};
>>> +
>>> +struct ifcvf_hw {
>>> +=C2=A0=C2=A0=C2=A0 u8=C2=A0=C2=A0=C2=A0 *isr;
>>> +=C2=A0=C2=A0=C2=A0 u8=C2=A0=C2=A0=C2=A0 notify_bar;
>>> +=C2=A0=C2=A0=C2=A0 u8=C2=A0=C2=A0=C2=A0 *lm_cfg;
>>> +=C2=A0=C2=A0=C2=A0 u8=C2=A0=C2=A0=C2=A0 status;
>>> +=C2=A0=C2=A0=C2=A0 u8=C2=A0=C2=A0=C2=A0 nr_vring;
>>
>>
>> Is the the number of queue currently used?
> Do you mean nr_vring? Yes it is used in hardware enable / disable=20
> functions.
>>
>>
>>> +=C2=A0=C2=A0=C2=A0 u16=C2=A0=C2=A0=C2=A0 *notify_base;
>>> +=C2=A0=C2=A0=C2=A0 u16=C2=A0=C2=A0=C2=A0 *notify_addr[IFCVF_MAX_QUEUE_=
PAIRS * 2];
>>> +=C2=A0=C2=A0=C2=A0 u32=C2=A0=C2=A0=C2=A0 generation;
>>> +=C2=A0=C2=A0=C2=A0 u32=C2=A0=C2=A0=C2=A0 notify_off_multiplier;
>>> +=C2=A0=C2=A0=C2=A0 u64=C2=A0=C2=A0=C2=A0 req_features;
>>> +=C2=A0=C2=A0=C2=A0 struct=C2=A0=C2=A0=C2=A0 virtio_pci_common_cfg *com=
mon_cfg;
>>> +=C2=A0=C2=A0=C2=A0 struct=C2=A0=C2=A0=C2=A0 ifcvf_net_config *dev_cfg;
>>> +=C2=A0=C2=A0=C2=A0 struct=C2=A0=C2=A0=C2=A0 vring_info vring[IFCVF_MAX=
_QUEUE_PAIRS * 2];
>>> +=C2=A0=C2=A0=C2=A0 struct=C2=A0=C2=A0=C2=A0 ifcvf_pci_mem_resource=20
>>> mem_resource[IFCVF_PCI_MAX_RESOURCE];
>>> +};
>>> +
>>> +#define IFC_PRIVATE_TO_VF(adapter) \
>>> +=C2=A0=C2=A0=C2=A0 (&((struct ifcvf_adapter *)adapter)->vf)
>>> +
>>> +#define IFCVF_MAX_INTR (IFCVF_MAX_QUEUE_PAIRS * 2 + 1)
>>
>>
>> The extra one means the config interrupt?
> Yes.


Ok, when we support control vq, it should be changed to 2*N + 2.

Thanks


>>
>>
>>> +
>>> +struct ifcvf_adapter {
>>> +=C2=A0=C2=A0=C2=A0 struct=C2=A0=C2=A0=C2=A0 device *dev;
>>> +=C2=A0=C2=A0=C2=A0 struct=C2=A0=C2=A0=C2=A0 mutex mdev_lock;
>>
>>
>> Not used in the patch, move to next one?
> Sure, these not used ones will be moved to small patches where they=20
> are used in v1 patchset.
>>
>>
>>> +=C2=A0=C2=A0=C2=A0 int=C2=A0=C2=A0=C2=A0 mdev_count;
>>
>>
>> Not used.
>>
>>
>>> +=C2=A0=C2=A0=C2=A0 struct=C2=A0=C2=A0=C2=A0 list_head dma_maps;
>>
>>
>> This is not used.
>>
>> Thanks
>>
>>
>>> +=C2=A0=C2=A0=C2=A0 int=C2=A0=C2=A0=C2=A0 vectors;
>>> +=C2=A0=C2=A0=C2=A0 struct=C2=A0=C2=A0=C2=A0 ifcvf_hw vf;
>>> +};
>>> +
>>> +int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev);
>>> +u64 ifcvf_get_features(struct ifcvf_hw *hw);
>>> +int ifcvf_start_hw(struct ifcvf_hw *hw);
>>> +void ifcvf_stop_hw(struct ifcvf_hw *hw);
>>> +void ifcvf_enable_logging(struct ifcvf_hw *hw, u64 log_base, u64=20
>>> log_size);
>>> +void ifcvf_enable_logging_vf(struct ifcvf_hw *hw, u64 log_base, u64=20
>>> log_size);
>>> +void ifcvf_disable_logging(struct ifcvf_hw *hw);
>>> +void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid);
>>> +void ifcvf_get_linkstatus(struct ifcvf_hw *hw, u8 *is_linkup);
>>> +u8 ifcvf_get_notify_region(struct ifcvf_hw *hw);
>>> +u64 ifcvf_get_queue_notify_off(struct ifcvf_hw *hw, int qid);
>>> +
>>> +#endif /* _IFCVF_H_ */

