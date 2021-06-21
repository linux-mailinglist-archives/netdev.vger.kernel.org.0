Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30603AF1F7
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhFURaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhFURaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:30:06 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA0FC06175F
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:27:51 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so18500359otu.6
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WmGjGSnaoIjbfNbK6jg4Z58leTIpBSXXFk+GdaHK+O8=;
        b=IkafJuMXU1dxFooFT/Z7CDiyPl66XkMYfmNHgkZ7Zr9ROZgxDLuuLCItaGKVG+g3ei
         StPnLiq+x2oO47VLNdr3X8f2MNhdKMSBQivdUZebRFGoy+8PcRI5KnPzwKoGXDq0vAms
         uOKTDF1aPZqzzgWio3fYUV04SFgYxLlLuiGV0yHop2Fdw9SW3u5n5BFTJBU3vnd9WFvD
         Rimi7mod+IOXsJwod9l4B5e+z9QEueios+GMwLdNvEMPmTXIUsXGBP1I7DyrZPQQLIen
         dV6MBOQTH1MFJyB6tKOmOFlqEnXysxtjprh6XkRv1/cGvUFGMFih52BaeUDAlxYnQOsP
         I4yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WmGjGSnaoIjbfNbK6jg4Z58leTIpBSXXFk+GdaHK+O8=;
        b=FYlG5gKuoIbakz04InOhNOHRBQp53i469X556Y/rb9fJm+SBqkaFvMzIbwPFZLs8D6
         Kykl85iEow2omUIpUlocgC0rzLA88mps7/ReaIXnYWbBrCeOeekPP6/8gkD/T71nGwTQ
         eU/96Nkz4hVJzOYUPEpmiUMXdzfTLXDkszxBA3czpLRBiDZNZLDINnSwGsQSh0OetM0l
         6y0YrFSS3fsCz1jWRxEc1etvF3ukpwQPl4kq16qvSlcA+Talxdjpz/scniJWinnpGJhF
         SGbJeZcqUOvsiayjFjHbCUQDbEdhkIG4aZ7UZAX3vVXbDKjBXR1r0JyEDy/91ijwGRXD
         SLHw==
X-Gm-Message-State: AOAM532ssc3nwyYkOeTeZA978QwO1G8xCypGkA46GQEL6lmvfsUGsb/9
        xFWXGGHlqg8dBmozMEU3xLgcY8H8oUky9ZQg0OUsUQ==
X-Google-Smtp-Source: ABdhPJwi8uED1KtCHcgJosUou/U3YERsHdEZWa6Y4ITdxzqfoSrQyjLejdlRZ2O4PLdCBDaz+Bchb6q7YPN7hVIoEJI=
X-Received: by 2002:a05:6830:1dd5:: with SMTP id a21mr21512580otj.180.1624296471321;
 Mon, 21 Jun 2021 10:27:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
 <20210609232501.171257-7-jiang.wang@bytedance.com> <20210618100424.wfljrnycxxguwt3d@steredhat.lan>
In-Reply-To: <20210618100424.wfljrnycxxguwt3d@steredhat.lan>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Mon, 21 Jun 2021 10:27:40 -0700
Message-ID: <CAP_N_Z-U0_XP69iNLA1Ray9EEVWyXqb2f85bL-sG2oxjM5PaMA@mail.gmail.com>
Subject: Re: [External] Re: [RFC v1 6/6] virtio/vsock: add sysfs for rx buf
 len for dgram
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        cong.wang@bytedance.com,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        =?UTF-8?B?5p+056iz?= <chaiwen.cc@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 3:04 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Wed, Jun 09, 2021 at 11:24:58PM +0000, Jiang Wang wrote:
> >Make rx buf len configurable via sysfs
> >
> >Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> >---
> > net/vmw_vsock/virtio_transport.c | 37 +++++++++++++++++++++++++++++++++++--
> > 1 file changed, 35 insertions(+), 2 deletions(-)
> >
> >diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> >index cf47aadb0c34..2e4dd9c48472 100644
> >--- a/net/vmw_vsock/virtio_transport.c
> >+++ b/net/vmw_vsock/virtio_transport.c
> >@@ -29,6 +29,14 @@ static struct virtio_vsock __rcu *the_virtio_vsock;
> > static struct virtio_vsock *the_virtio_vsock_dgram;
> > static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
> >
> >+static int rx_buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
> >+static struct kobject *kobj_ref;
> >+static ssize_t  sysfs_show(struct kobject *kobj,
> >+                      struct kobj_attribute *attr, char *buf);
> >+static ssize_t  sysfs_store(struct kobject *kobj,
> >+                      struct kobj_attribute *attr, const char *buf, size_t count);
> >+static struct kobj_attribute rxbuf_attr = __ATTR(rx_buf_value, 0660, sysfs_show, sysfs_store);
>
> Maybe better to use a 'dgram' prefix.

Sure.

> >+
> > struct virtio_vsock {
> >       struct virtio_device *vdev;
> >       struct virtqueue **vqs;
> >@@ -360,7 +368,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
> >
> > static void virtio_vsock_rx_fill(struct virtio_vsock *vsock, bool is_dgram)
> > {
> >-      int buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
> >+      int buf_len = rx_buf_len;
> >       struct virtio_vsock_pkt *pkt;
> >       struct scatterlist hdr, buf, *sgs[2];
> >       struct virtqueue *vq;
> >@@ -1003,6 +1011,22 @@ static struct virtio_driver virtio_vsock_driver = {
> >       .remove = virtio_vsock_remove,
> > };
> >
> >+static ssize_t sysfs_show(struct kobject *kobj,
> >+              struct kobj_attribute *attr, char *buf)
> >+{
> >+      return sprintf(buf, "%d", rx_buf_len);
> >+}
> >+
> >+static ssize_t sysfs_store(struct kobject *kobj,
> >+              struct kobj_attribute *attr, const char *buf, size_t count)
> >+{
> >+      if (kstrtou32(buf, 0, &rx_buf_len) < 0)
> >+              return -EINVAL;
> >+      if (rx_buf_len < 1024)
> >+              rx_buf_len = 1024;
> >+      return count;
> >+}
> >+
> > static int __init virtio_vsock_init(void)
> > {
> >       int ret;
> >@@ -1020,8 +1044,17 @@ static int __init virtio_vsock_init(void)
> >       if (ret)
> >               goto out_vci;
> >
> >-      return 0;
> >+      kobj_ref = kobject_create_and_add("vsock", kernel_kobj);
>
> So, IIUC, the path will be /sys/vsock/rx_buf_value?
>
> I'm not sure if we need to add a `virtio` subdir (e.g.
> /sys/vsock/virtio/dgram_rx_buf_size)

I agree adding a virtio is better in case vmware or hyperv will
also have some settings.

> Thanks,
> Stefano
>
> >
> >+      /*Creating sysfs file for etx_value*/
> >+      ret = sysfs_create_file(kobj_ref, &rxbuf_attr.attr);
> >+      if (ret)
> >+              goto out_sysfs;
> >+
> >+      return 0;
> >+out_sysfs:
> >+      kobject_put(kobj_ref);
> >+      sysfs_remove_file(kernel_kobj, &rxbuf_attr.attr);
> > out_vci:
> >       vsock_core_unregister(&virtio_transport.transport);
> > out_wq:
> >--
> >2.11.0
> >
>
