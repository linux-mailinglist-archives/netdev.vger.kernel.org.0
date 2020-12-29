Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C600F2E6F40
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 10:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgL2JNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 04:13:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725986AbgL2JNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 04:13:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609233094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V4ZbLL6gLiqu8bhAJp7vBUQdf9XdTVKfkKmlq8ZgHmE=;
        b=IHuOJTBMUM0P5glrFzUgS/Un5YjLcjSPCfP+bUkAMfWIjQS8C+dcAgVutSPnzI8FJQEB/J
        aUgWt1KIN+Y1InHXaZriCtvfFw9+iL96EQ4cpQPrk3WHL8ixg38y36C5uNfBIPr+KEBzkM
        L0wavAsq5pNuQpDxeNFrrYHkFyBFsuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-52sI5t4GNvatqdItb3kogA-1; Tue, 29 Dec 2020 04:11:30 -0500
X-MC-Unique: 52sI5t4GNvatqdItb3kogA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CACA8800D55;
        Tue, 29 Dec 2020 09:11:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AAA35D9DC;
        Tue, 29 Dec 2020 09:11:27 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 138524BB40;
        Tue, 29 Dec 2020 09:11:26 +0000 (UTC)
Date:   Tue, 29 Dec 2020 04:11:08 -0500 (EST)
From:   Jason Wang <jasowang@redhat.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Message-ID: <1356137727.40748805.1609233068675.JavaMail.zimbra@redhat.com>
In-Reply-To: <CACycT3soQoX5avZiFBLEGBuJpdni6-UxdhAPGpWHBWVf+dEySg@mail.gmail.com>
References: <20201222145221.711-1-xieyongji@bytedance.com> <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com> <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com> <CACycT3uwXBYvRbKDWdN3oCekv+o6_Lc=-KTrxejD=fr-zgibGw@mail.gmail.com> <2b24398c-e6d9-14ec-2c0d-c303d528e377@redhat.com> <CACycT3uDV43ecScrMh1QVpStuwDETHykJzzY=pkmZjP2Dd2kvg@mail.gmail.com> <e77c97c5-6bdc-cdd0-62c0-6ff75f6dbdff@redhat.com> <CACycT3soQoX5avZiFBLEGBuJpdni6-UxdhAPGpWHBWVf+dEySg@mail.gmail.com>
Subject: Re: [RFC v2 09/13] vduse: Add support for processing vhost iotlb
 message
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.9]
Thread-Topic: vduse: Add support for processing vhost iotlb message
Thread-Index: OBugpafsf525DDt1uUEs5wc+oTZ2vg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> On Mon, Dec 28, 2020 at 4:43 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > On 2020/12/28 =E4=B8=8B=E5=8D=884:14, Yongji Xie wrote:
> > >> I see. So all the above two questions are because VHOST_IOTLB_INVALI=
DATE
> > >> is expected to be synchronous. This need to be solved by tweaking th=
e
> > >> current VDUSE API or we can re-visit to go with descriptors relaying
> > >> first.
> > >>
> > > Actually all vdpa related operations are synchronous in current
> > > implementation. The ops.set_map/dma_map/dma_unmap should not return
> > > until the VDUSE_UPDATE_IOTLB/VDUSE_INVALIDATE_IOTLB message is replie=
d
> > > by userspace. Could it solve this problem?
> >
> >
> >   I was thinking whether or not we need to generate IOTLB_INVALIDATE
> > message to VDUSE during dma_unmap (vduse_dev_unmap_page).
> >
> > If we don't, we're probably fine.
> >
>=20
> It seems not feasible. This message will be also used in the
> virtio-vdpa case to notify userspace to unmap some pages during
> consistent dma unmapping. Maybe we can document it to make sure the
> users can handle the message correctly.

Just to make sure I understand your point.

Do you mean you plan to notify the unmap of 1) streaming DMA or 2)
coherent DMA?

For 1) you probably need a workqueue to do that since dma unmap can
be done in irq or bh context. And if usrspace does't do the unmap, it
can still access the bounce buffer (if you don't zap pte)?

Thanks


>=20
> Thanks,
> Yongji
>=20
>=20

