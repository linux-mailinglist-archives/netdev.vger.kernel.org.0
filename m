Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569CF15252E
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 04:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgBEDOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 22:14:31 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37645 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727714AbgBEDOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 22:14:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580872469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fkacgs1jrvXkTMH7lk8Z4tp9p1PLEK8Yl3rboqahklw=;
        b=G22icPb5DWFZSEeaM9QNbdRgczVdka1QvP7DzBryyar9KOTTt9naxnAxxkXhz28EJ7RS4Y
        onq4eq+zwpCD5s1Eh2LWpRHa/bcAPMR3cc/Htpsjrl26Ocw2APSugrrSZYsw8muDERh4cl
        zsb7lOeHJED3fNpClUrIsKWf4pN0J40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-hLQ79f0CMWWDZK02RejDGw-1; Tue, 04 Feb 2020 22:14:27 -0500
X-MC-Unique: hLQ79f0CMWWDZK02RejDGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDABA1137841;
        Wed,  5 Feb 2020 03:14:24 +0000 (UTC)
Received: from [10.72.13.188] (ovpn-13-188.pek2.redhat.com [10.72.13.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E38BF5D9E2;
        Wed,  5 Feb 2020 03:14:05 +0000 (UTC)
Subject: Re: [PATCH 5/5] vdpasim: vDPA device simulator
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Zhu Lingshan <lingshan.zhu@linux.intel.com>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jakub.kicinski@netronome.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-6-jasowang@redhat.com>
 <1b86d188-0666-f6ab-e3b3-bec1cfbd0c76@linux.intel.com>
 <cca7901b-51dd-4f4b-5c30-c42577ad5194@redhat.com>
 <20200204125204.GS23346@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <920de1cf-a4ee-2d02-a30b-741bfed18ffb@redhat.com>
Date:   Wed, 5 Feb 2020 11:14:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200204125204.GS23346@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/4 =E4=B8=8B=E5=8D=888:52, Jason Gunthorpe wrote:
> On Tue, Feb 04, 2020 at 04:28:27PM +0800, Jason Wang wrote:
>> On 2020/2/4 =E4=B8=8B=E5=8D=884:21, Zhu Lingshan wrote:
>>>> +static const struct dma_map_ops vdpasim_dma_ops =3D {
>>>> +=C2=A0=C2=A0=C2=A0 .map_page =3D vdpasim_map_page,
>>>> +=C2=A0=C2=A0=C2=A0 .unmap_page =3D vdpasim_unmap_page,
>>>> +=C2=A0=C2=A0=C2=A0 .alloc =3D vdpasim_alloc_coherent,
>>>> +=C2=A0=C2=A0=C2=A0 .free =3D vdpasim_free_coherent,
>>>> +};
>>>> +
>>> Hey Jason,
>>>
>>> IMHO, it would be nice if dma_ops of the parent device could be re-us=
ed.
>>> vdpa_device is expecting to represent a physical device except this
>>> simulator, however, there are not enough information in vdpa_device.d=
ev
>>> to indicating which kind physical device it attached to. Namely
>>> get_arch_dma_ops(struct bus type) can not work on vdpa_device.dev. Th=
en
>>> it seems device drivers need to implement a wrap of dma_ops of parent
>>> devices. Can this work be done in the vdpa framework since it looks l=
ike
>>> a common task? Can "vd_dev->vdev.dev.parent =3D vdpa->dev->parent;" i=
n
>>> virtio_vdpa_probe() do the work?
>>>
>>> Thanks,
>>> BR
>>> Zhu Lingshan
>>
>> Good catch.
>>
>> I think we can.
> IMHO you need to specify some 'dma_device', not try and play tricks
> with dma_ops, or assuming the parent is always the device used for
> dma.
>
> Jason


Right, this is what in my mind and discussed in the vhost-vdpa thread.

Will go this way.

Thanks


