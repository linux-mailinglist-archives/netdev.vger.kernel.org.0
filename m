Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89AAB167606
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 09:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731999AbgBUIGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 03:06:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23372 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731861AbgBUIGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 03:06:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582272408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nZPMKkDRpIygusMljWBR/rOUYIWd4dKR+JmAgMAgsbA=;
        b=Z2GvPJvRkWsfuiiAD27KB6TojxSjhRQp9S9Av5hbeOWTA4eru/Ntys8T8U3ZjjGUVGKFyo
        LK4BLomJMkfe1UkZOHpR15hsVBTaTZVlHPXsg0kARuVsP4OXebVj1B5visGXu4zEsUj1Hb
        3Lks0tO/7IUluBqN0C2ELNogBuAfwuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-db6s2tGWP_mUlg7iG2WDtg-1; Fri, 21 Feb 2020 03:06:47 -0500
X-MC-Unique: db6s2tGWP_mUlg7iG2WDtg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 247D0107ACCA;
        Fri, 21 Feb 2020 08:06:44 +0000 (UTC)
Received: from [10.72.13.208] (ovpn-13-208.pek2.redhat.com [10.72.13.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A64978B740;
        Fri, 21 Feb 2020 08:06:25 +0000 (UTC)
Subject: Re: [PATCH V4 4/5] virtio: introduce a vDPA based transport
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
References: <20200220061141.29390-1-jasowang@redhat.com>
 <20200220061141.29390-5-jasowang@redhat.com>
 <20200220151914.GW23930@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d6d910bb-8431-7e95-8808-9ed2d6ec9211@redhat.com>
Date:   Fri, 21 Feb 2020 16:06:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200220151914.GW23930@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/20 =E4=B8=8B=E5=8D=8811:19, Jason Gunthorpe wrote:
> On Thu, Feb 20, 2020 at 02:11:40PM +0800, Jason Wang wrote:
>> +static int virtio_vdpa_probe(struct vdpa_device *vdpa)
>> +{
>> +	const struct vdpa_config_ops *ops =3D vdpa->config;
>> +	struct virtio_vdpa_device *vd_dev;
>> +	int ret =3D -EINVAL;
>> +
>> +	vd_dev =3D kzalloc(sizeof(*vd_dev), GFP_KERNEL);
>> +	if (!vd_dev)
>> +		return -ENOMEM;
>> +
>> +	vd_dev->vdev.dev.parent =3D vdpa_get_dma_dev(vdpa);
>> +	vd_dev->vdev.dev.release =3D virtio_vdpa_release_dev;
>> +	vd_dev->vdev.config =3D &virtio_vdpa_config_ops;
>> +	vd_dev->vdpa =3D vdpa;
>> +	INIT_LIST_HEAD(&vd_dev->virtqueues);
>> +	spin_lock_init(&vd_dev->lock);
>> +
>> +	vd_dev->vdev.id.device =3D ops->get_device_id(vdpa);
>> +	if (vd_dev->vdev.id.device =3D=3D 0)
>> +		goto err;
>> +
>> +	vd_dev->vdev.id.vendor =3D ops->get_vendor_id(vdpa);
>> +	ret =3D register_virtio_device(&vd_dev->vdev);
>> +	if (ret)
>> +		goto err;
> This error unwind is wrong. register_virtio_device() does
> device_initialize() as it's first action. After that point error
> unwind must be done with put_device() - particularly calling
> kfree(vd_dev) after doing dev_set_name() leaks memory.


Exactly.


>
> Looks like about half of the register_virtio_device() users did this
> right, the others not. Perhaps you should fix them too...
>
> Jason


Will do.

Thanks


>

