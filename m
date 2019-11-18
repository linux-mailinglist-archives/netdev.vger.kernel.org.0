Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5A810030E
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 11:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfKRK5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 05:57:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49507 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726833AbfKRK5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 05:57:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574074644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RiF+p1hy9Kr+uofiPsIUHftIM+sRWQxv7Wn5qjHLaOI=;
        b=Fw167ABsbhuEy2H3pSTLlYg0N69c1p1JBTO04Xh1+8dqBHXhN8Vz+UGDasFAZR/0hsZghW
        JEinxV5o00BD0Lg1SlLbLGRgd89kYCNNBw9tXtJlBqop8wcXZUAgkGGDIEu2n7rVSchJA0
        47Rwz4uq+vt7b1f58jfAJRLz5Pxf1ZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-hr9bWVrxM529z-fYzESVsg-1; Mon, 18 Nov 2019 05:57:22 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0BD618B9FC1;
        Mon, 18 Nov 2019 10:57:17 +0000 (UTC)
Received: from [10.72.12.65] (ovpn-12-65.pek2.redhat.com [10.72.12.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADA2D3AA1;
        Mon, 18 Nov 2019 10:56:53 +0000 (UTC)
Subject: Re: [PATCH V12 5/6] virtio: introduce a mdev based transport
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        gregkh@linuxfoundation.org, jgg@mellanox.com
References: <20191118061703.8669-1-jasowang@redhat.com>
 <20191118061703.8669-6-jasowang@redhat.com>
 <20191118054339-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a59bf414-aefb-954c-86ea-b970513171bf@redhat.com>
Date:   Mon, 18 Nov 2019 18:56:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191118054339-mutt-send-email-mst@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: hr9bWVrxM529z-fYzESVsg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/18 =E4=B8=8B=E5=8D=886:44, Michael S. Tsirkin wrote:
>> +static const struct mdev_virtio_class_id virtio_id_table[] =3D {
>> +=09{ MDEV_VIRTIO_CLASS_ID_VIRTIO },
>> +=09{ 0 },
>> +};
>> +
> Do we still need the class ID? It's a virtio mdev bus,
> do we need a virtio class as well?
>

If we want to have auto match between vhost-mdev driver and vhost-mdev=20
device, we need this.

Otherwise, user need to manually probe or bind driver to the device.

Thanks

