Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC66F0530
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 19:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390761AbfKESft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 13:35:49 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36272 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390732AbfKESft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 13:35:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572978948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6u1vf6nr5+mwcuJOYapBLjHMzjo0EwtcJSPOb82z7cc=;
        b=fExVOzgjL5ux5bufjq9mwNQX8imK59BBxe25tewJ4Az8YArLBwa3pTBMQLUPYCuh78ZmHF
        30nrvMMWGaXmVVh9dRadq25jEVZCurhJPNgzAJCvJFOTqhTqiHB/yp1HFTiFRxsJHvh7Ie
        FupDpe/s9Ue+je7yjDo92RmXAGRSBIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-YSrEG9XBNoK9jG-c5jDL0Q-1; Tue, 05 Nov 2019 13:35:44 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7981477;
        Tue,  5 Nov 2019 18:35:40 +0000 (UTC)
Received: from gondolin (unknown [10.36.118.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA3DD60C88;
        Tue,  5 Nov 2019 18:35:21 +0000 (UTC)
Date:   Tue, 5 Nov 2019 19:35:18 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
Subject: Re: [PATCH V8 6/6] docs: sample driver to demonstrate how to
 implement virtio-mdev framework
Message-ID: <20191105193518.5c1179d7.cohuck@redhat.com>
In-Reply-To: <20191105093240.5135-7-jasowang@redhat.com>
References: <20191105093240.5135-1-jasowang@redhat.com>
        <20191105093240.5135-7-jasowang@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: YSrEG9XBNoK9jG-c5jDL0Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Nov 2019 17:32:40 +0800
Jason Wang <jasowang@redhat.com> wrote:

> This sample driver creates mdev device that simulate virtio net device
> over virtio mdev transport. The device is implemented through vringh
> and workqueue. A device specific dma ops is to make sure HVA is used
> directly as the IOVA. This should be sufficient for kernel virtio
> driver to work.
>=20
> Only 'virtio' type is supported right now. I plan to add 'vhost' type
> on top which requires some virtual IOMMU implemented in this sample
> driver.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  MAINTAINERS                |   1 +
>  samples/Kconfig            |   7 +
>  samples/vfio-mdev/Makefile |   1 +
>  samples/vfio-mdev/mvnet.c  | 685 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 694 insertions(+)
>  create mode 100644 samples/vfio-mdev/mvnet.c

Have not really reviewed this, but looks sane at a glance.

Acked-by: Cornelia Huck <cohuck@redhat.com>

