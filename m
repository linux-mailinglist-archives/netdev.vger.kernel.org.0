Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FB562398A
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbiKJCF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiKJCFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:05:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B968F2E6A6
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668045848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XUbS7kkdkTb1FJ8Puq8bD35jK/Y5vjFwMtJetj4Fh+E=;
        b=b9ZHeFrwtaYfBsjd+AGJ6z/80xTerLxGkGz1QzwL1abrgLzBqE7zMlkmkioKxIXFbXwfSZ
        FBrHT24f/r1Bta5PxiA+qQUFqktqA5N8ofPbG1R1ktAzqe8t9lCKYTB12i4Ej95aAOcciX
        qkmCfQVRx7f8OZnBy9YTrVk0tOrlnjI=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-274-_ZvSXuB1Nje1HVCFEhncAw-1; Wed, 09 Nov 2022 21:04:07 -0500
X-MC-Unique: _ZvSXuB1Nje1HVCFEhncAw-1
Received: by mail-ot1-f71.google.com with SMTP id e19-20020a9d0193000000b0066754f1a8efso369034ote.7
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 18:04:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XUbS7kkdkTb1FJ8Puq8bD35jK/Y5vjFwMtJetj4Fh+E=;
        b=pgS8jrVZu3Qyl/SP9Ez/dHmdE1wTrP4/+mdJdNrGtb48Q9cJqVuDde7ELHkGSiT8SU
         CM13drMZ9hFgZDTlB8HH7da22KuvrmP9pdAFFCbpEyqiwl3HVx8t45VOz6wVqfZR6bZV
         nY6UjShfTTSWQ3ch9+Rphl3lhJs+i4jjiEXvxF7bDjzSpFsNgv8jJOlqcw2QfUk1SIAo
         NFvMV99PbGyfl9lx4aIVcollCESUjA2jtY13NsvID7DSs0ndKsNov2lRupY+50+BmrNN
         JCVhmSoZCYiPMsXaJsGJrDVENMWK8hDlWs5A92Xr1PNtU92KQugpNyFk0qJu5pRsxoSG
         ZU/Q==
X-Gm-Message-State: ACrzQf2s0ya7RUNkO9+6Rr0+3kq0aEb0FL5mPFnXatYUyTj7H8+lztlB
        e/3wyqSZFvr/1yMIRwP6qCE2z0PfDNPfDbo3QuzhWok2vgBZJgJQhjTS8TaW4pClu/cxmsHtbQ4
        f3Y2r3djS7TclpoknZb5lAIP3cY/ATeDo
X-Received: by 2002:a9d:604f:0:b0:66c:64d6:1bb4 with SMTP id v15-20020a9d604f000000b0066c64d61bb4mr984594otj.201.1668045842957;
        Wed, 09 Nov 2022 18:04:02 -0800 (PST)
X-Google-Smtp-Source: AMsMyM45UkiwIqipZjueepL0FmRYOH9f819x2rJtJU36H2CB7TpfTuSLZCNIGl3lRKPzdZ9V6etpqCxhc4a3+nN7pxg=
X-Received: by 2002:a9d:604f:0:b0:66c:64d6:1bb4 with SMTP id
 v15-20020a9d604f000000b0066c64d61bb4mr984589otj.201.1668045842684; Wed, 09
 Nov 2022 18:04:02 -0800 (PST)
MIME-Version: 1.0
References: <20221109154213.146789-1-sgarzare@redhat.com>
In-Reply-To: <20221109154213.146789-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Nov 2022 10:03:50 +0800
Message-ID: <CACGkMEu8qVjDwBmsow17ct6QtgPd-Bch7Z7jKiHveicGPVrrvg@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: fix potential memory leak during the release
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 9, 2022 at 11:42 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> Before commit 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
> we call vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1) during the
> release to free all the resources allocated when processing user IOTLB
> messages through vhost_vdpa_process_iotlb_update().
> That commit changed the handling of IOTLB a bit, and we accidentally
> removed some code called during the release.
>
> We partially fixed with commit 037d4305569a ("vhost-vdpa: call
> vhost_vdpa_cleanup during the release") but a potential memory leak is
> still there as showed by kmemleak if the application does not send
> VHOST_IOTLB_INVALIDATE or crashes:
>
>   unreferenced object 0xffff888007fbaa30 (size 16):
>     comm "blkio-bench", pid 914, jiffies 4294993521 (age 885.500s)
>     hex dump (first 16 bytes):
>       40 73 41 07 80 88 ff ff 00 00 00 00 00 00 00 00  @sA.............
>     backtrace:
>       [<0000000087736d2a>] kmem_cache_alloc_trace+0x142/0x1c0
>       [<0000000060740f50>] vhost_vdpa_process_iotlb_msg+0x68c/0x901 [vhost_vdpa]
>       [<0000000083e8e205>] vhost_chr_write_iter+0xc0/0x4a0 [vhost]
>       [<000000008f2f414a>] vhost_vdpa_chr_write_iter+0x18/0x20 [vhost_vdpa]
>       [<00000000de1cd4a0>] vfs_write+0x216/0x4b0
>       [<00000000a2850200>] ksys_write+0x71/0xf0
>       [<00000000de8e720b>] __x64_sys_write+0x19/0x20
>       [<0000000018b12cbb>] do_syscall_64+0x3f/0x90
>       [<00000000986ec465>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Let's fix calling vhost_vdpa_iotlb_unmap() on the whole range in
> vhost_vdpa_remove_as(). We move that call before vhost_dev_cleanup()
> since we need a valid v->vdev.mm in vhost_vdpa_pa_unmap().
> vhost_iotlb_reset() call can be removed, since vhost_vdpa_iotlb_unmap()
> on the whole range removes all the entries.
>
> The kmemleak log reported was observed with a vDPA device that has `use_va`
> set to true (e.g. VDUSE). This patch has been tested with both types of
> devices.
>
> Fixes: 037d4305569a ("vhost-vdpa: call vhost_vdpa_cleanup during the release")
> Fixes: 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vhost/vdpa.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 166044642fd5..b08e07fc7d1f 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -65,6 +65,10 @@ static DEFINE_IDA(vhost_vdpa_ida);
>
>  static dev_t vhost_vdpa_major;
>
> +static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
> +                                  struct vhost_iotlb *iotlb,
> +                                  u64 start, u64 last);
> +
>  static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
>  {
>         struct vhost_vdpa_as *as = container_of(iotlb, struct
> @@ -135,7 +139,7 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
>                 return -EINVAL;
>
>         hlist_del(&as->hash_link);
> -       vhost_iotlb_reset(&as->iotlb);
> +       vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
>         kfree(as);
>
>         return 0;
> @@ -1162,14 +1166,14 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
>         struct vhost_vdpa_as *as;
>         u32 asid;
>
> -       vhost_dev_cleanup(&v->vdev);
> -       kfree(v->vdev.vqs);
> -
>         for (asid = 0; asid < v->vdpa->nas; asid++) {
>                 as = asid_to_as(v, asid);
>                 if (as)
>                         vhost_vdpa_remove_as(v, asid);
>         }
> +
> +       vhost_dev_cleanup(&v->vdev);
> +       kfree(v->vdev.vqs);
>  }
>
>  static int vhost_vdpa_open(struct inode *inode, struct file *filep)
> --
> 2.38.1
>

