Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF32BE85FF
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 11:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbfJ2Knt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 06:43:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60404 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728719AbfJ2Knt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 06:43:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572345827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8QKaEOxWqH0XbEXmeRTfx0XwaFmBJ9rzCJkgjIkFVeU=;
        b=Tt+d8fz9rBLzEKRtR2jEWVJHoh/7v2uHuNhB644495Cp9YRg71PX4FOwIyi9ufLDFcaHQP
        QpRb9aqbbLnz0e4iLRNMXTuxUirp7L2rgm5ZOVZSC5NwZaryLYOytLKZGw1DagJczBz15/
        U5tdiNyMiwqjUDDfuxlLFtw7re22sZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-f_q__00gOjOwW2LVCQTfjw-1; Tue, 29 Oct 2019 06:43:43 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B317E1005500;
        Tue, 29 Oct 2019 10:43:39 +0000 (UTC)
Received: from [10.72.12.223] (ovpn-12-223.pek2.redhat.com [10.72.12.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 902D960BF1;
        Tue, 29 Oct 2019 10:42:12 +0000 (UTC)
Subject: Re: [PATCH V5 4/6] mdev: introduce virtio device and its device ops
To:     Zhu Lingshan <lingshan.zhu@linux.intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
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
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
References: <20191023130752.18980-1-jasowang@redhat.com>
 <20191023130752.18980-5-jasowang@redhat.com>
 <df1eb77c-d159-da11-bb8f-df2c19089ac6@linux.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <14410ac9-cc01-185a-5dcf-7f6c78aefd65@redhat.com>
Date:   Tue, 29 Oct 2019 18:42:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <df1eb77c-d159-da11-bb8f-df2c19089ac6@linux.intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: f_q__00gOjOwW2LVCQTfjw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/29 =E4=B8=8B=E5=8D=883:42, Zhu Lingshan wrote:
>>
>> +=C2=A0=C2=A0=C2=A0 void (*set_status)(struct mdev_device *mdev, u8 stat=
us);
>
> Hi Jason
>
> Is it possible to make set_status() return an u8 or bool, because this
> may fail in real hardware. Without a returned code, I am not sure=C2=A0
> whether it is a good idea to set the status | NEED_RESET when fail.
>
> Thanks,
> BR
> Zhu Lingshan=20


Hi:


It's possible but I'm not sure whether any user will care about it. E.g
see virtio_add_status():

void virtio_add_status(struct virtio_device *dev, unsigned int status)
{
=C2=A0=C2=A0=C2=A0 might_sleep();
=C2=A0=C2=A0=C2=A0 dev->config->set_status(dev, dev->config->get_status(dev=
) | status);
}
EXPORT_SYMBOL_GPL(virtio_add_status);

And I believe how it work should be:

virtio_add_status(xyz);

status =3D virtio_get_status();

if (!(status & xyz))

=C2=A0=C2=A0=C2=A0 error;

Thanks



