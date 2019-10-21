Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FB6DE95B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfJUKWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:22:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32998 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728074AbfJUKWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 06:22:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571653325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WOCT7wly6KfhuOArDnM97rOlSlf5dicr3quLe5triaA=;
        b=YwX8sdlK51KtNkNSfj3iFY1teH25gy60xd+NFVxdg8LD50oRUsZFMqbGKegjjq4LP8524l
        59UNgMAW9Rq9ZLV+OxTGO/hNMBzUvSHkkpQuNLQ/eLdxIF03U2xHBMnLcPbpX4UnP9dHJt
        Cu4JK+L4SaHJiF8+Sf89U0fA6uvPo6w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-mVNupHU-OimsifvQ82L67A-1; Mon, 21 Oct 2019 06:22:02 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14CFC1005500;
        Mon, 21 Oct 2019 10:22:01 +0000 (UTC)
Received: from [10.72.12.22] (ovpn-12-22.pek2.redhat.com [10.72.12.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C574104F1;
        Mon, 21 Oct 2019 10:21:51 +0000 (UTC)
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
 <2d711b6b-3bdc-afaa-8110-beebd6c5a896@redhat.com>
 <32d4c431-24f2-f9f0-8573-268abc7bb71c@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0fe6eb76-85a7-a1cb-5b11-8edb01dd65c7@redhat.com>
Date:   Mon, 21 Oct 2019 18:21:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <32d4c431-24f2-f9f0-8573-268abc7bb71c@intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: mVNupHU-OimsifvQ82L67A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/21 =E4=B8=8B=E5=8D=885:57, Zhu, Lingshan wrote:
>
> On 10/16/2019 4:45 PM, Jason Wang wrote:
>>
>> On 2019/10/16 =E4=B8=8A=E5=8D=889:30, Zhu Lingshan wrote:
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
>>
>>
>> Let's avoid using VHOST_F_LOG_ALL, using the get_mdev_features()=20
>> instead.
> Thanks, I will remove VHOST_F_LOG_ALL
>>
>>
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
>>
>>
>> Why not having VIRTIO_F_IOMMU_PLATFORM and VIRTIO_F_ORDER_PLATFORM?
>
> I will add VIRTIO_F_ORDER_PLATFORM, for VIRTIO_F_IOMMU_PLATFORM, if we=20
> add this bit, QEMU may enable viommu, can cause troubles in LM


Qemu has mature support of vIOMMU support for VFIO device, it can shadow=20
IO page tables and setup them through DMA ioctl of vfio containers. Any=20
issue you saw here?

Btw, to test them quickly, you can implement set_config/get_config and=20
test them through virtio-mdev/kernel drivers as well.

Thanks


> (through we don't support LM in this version driver)
>
> Thanks,
> BR
> Zhu Lingshan
>>
>> Thanks
>>

