Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B6A15170E
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 09:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgBDI2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 03:28:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46292 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727097AbgBDI2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 03:28:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580804930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JipmoOe2nr0hGxD7C+f101bb7FTOHzYyEwpTEYgv7tg=;
        b=fcqkr51i4XIx1miBuekqjS7AzBreBOE17Z77lH4I447ZVrALMhWuJCSZQ5m2dH+dZ8m/zd
        kqWBHzIjzPUUhw94RinUWbgv0cp8DwLCS9/4widvBxm+g2+DA+IHo4qTdz0KHvhpA4W3Zi
        pFgG0KTIXgg4dZ6ehlPHl+S9uHcfZQ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-Dqa5HkEuOly10_ZneL--TQ-1; Tue, 04 Feb 2020 03:28:48 -0500
X-MC-Unique: Dqa5HkEuOly10_ZneL--TQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBA80800D54;
        Tue,  4 Feb 2020 08:28:45 +0000 (UTC)
Received: from [10.72.12.170] (ovpn-12-170.pek2.redhat.com [10.72.12.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B4F290F49;
        Tue,  4 Feb 2020 08:28:28 +0000 (UTC)
Subject: Re: [PATCH 5/5] vdpasim: vDPA device simulator
To:     Zhu Lingshan <lingshan.zhu@linux.intel.com>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cca7901b-51dd-4f4b-5c30-c42577ad5194@redhat.com>
Date:   Tue, 4 Feb 2020 16:28:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1b86d188-0666-f6ab-e3b3-bec1cfbd0c76@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/4 =E4=B8=8B=E5=8D=884:21, Zhu Lingshan wrote:
>> +static const struct dma_map_ops vdpasim_dma_ops =3D {
>> +=C2=A0=C2=A0=C2=A0 .map_page =3D vdpasim_map_page,
>> +=C2=A0=C2=A0=C2=A0 .unmap_page =3D vdpasim_unmap_page,
>> +=C2=A0=C2=A0=C2=A0 .alloc =3D vdpasim_alloc_coherent,
>> +=C2=A0=C2=A0=C2=A0 .free =3D vdpasim_free_coherent,
>> +};
>> +
>
> Hey Jason,
>
> IMHO, it would be nice if dma_ops of the parent device could be=20
> re-used. vdpa_device is expecting to represent a physical device=20
> except this simulator, however, there are not enough information in=20
> vdpa_device.dev to indicating which kind physical device it attached=20
> to. Namely get_arch_dma_ops(struct bus type) can not work on=20
> vdpa_device.dev. Then it seems device drivers need to implement a wrap=20
> of dma_ops of parent devices. Can this work be done in the vdpa=20
> framework since it looks like a common task? Can=20
> "vd_dev->vdev.dev.parent =3D vdpa->dev->parent;" in virtio_vdpa_probe()=
=20
> do the work?
>
> Thanks,
> BR
> Zhu Lingshan=20


Good catch.

I think we can.

Thanks

