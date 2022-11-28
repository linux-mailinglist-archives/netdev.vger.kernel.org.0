Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3305563A658
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiK1Ksk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiK1Ksi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:48:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0DE20C
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 02:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669632460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cS8myjO3Qx4B0wnXMirQSBOMzDu+QNBoBdPAnQnrxLs=;
        b=cIpaeRZn/qEpgsYGvj+WRY2bWYCCQSQSeGOabSHboTpQsb7/aVeu34U0z63AtrTNxMVXHt
        hhBfYyexyvQeC1I94XVCYOmGhmzQClaO92+9MHhhi2U316Lk2BoT/+NhCsiMcJTeXn4wdw
        DBhukTGeqDBC5WCAk7O0X646+6dacVg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-547-kQUyZIvTNIOoVMlsVpMb8w-1; Mon, 28 Nov 2022 05:47:39 -0500
X-MC-Unique: kQUyZIvTNIOoVMlsVpMb8w-1
Received: by mail-wr1-f69.google.com with SMTP id r23-20020adfa157000000b00241bcae980cso1748855wrr.7
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 02:47:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cS8myjO3Qx4B0wnXMirQSBOMzDu+QNBoBdPAnQnrxLs=;
        b=4aI7NSBoEU6gvMc3cU5/YP9XsHlXxkYgo8EqOqYG1IrBtMaxqzXplVjjRHbM450VD1
         WDTPXSbGp5jsRBLNc9nCeu+SyrFDZbFyUfcjvF5qxon4vRm4mYMh6ZnkZd/lI+l+Owkt
         ZvEX2bu00YY02p7DTo2tiF3xlGuOOV4LjVXgIopJ+lGBOBMfFEjPexJul+yE0nUkBzNG
         9Fpl8YrjHdl6fthhIYznGGklbG1y9iCAa2BmeayiXho0d2/pkusIY+YBJOI+n/XwjfuO
         f6D+0qwbrWbnFNZqPusV4I9rw6rMts7aEi3T4EqUb4ajkbdLAcFfvJ6Zt1z1neXhlVJU
         w2mQ==
X-Gm-Message-State: ANoB5pkgECmMaZgC1EXR1L3IiAjt1p6lH2Y7phr8VPQl3cVnIkF1mgpp
        1F6+gZkbAly90XkiCyygleNJjyoq/stPqc/cnj5z2TqZiIiQucNqYU084vJRsjnNpZcSN8Sfr45
        uQq0LKZviS3xlCXf/
X-Received: by 2002:a5d:5f04:0:b0:241:e9a6:fb3 with SMTP id cl4-20020a5d5f04000000b00241e9a60fb3mr15849620wrb.462.1669632457561;
        Mon, 28 Nov 2022 02:47:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6Uw75GgmZfAJrCZl1x3MbiuyHCdl4XOGtfUzuURjcUCzIxRCl9LYisU8M4TEltPVhmHNqRIw==
X-Received: by 2002:a5d:5f04:0:b0:241:e9a6:fb3 with SMTP id cl4-20020a5d5f04000000b00241e9a60fb3mr15849610wrb.462.1669632457346;
        Mon, 28 Nov 2022 02:47:37 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id h9-20020adffd49000000b002383fc96509sm10468040wrs.47.2022.11.28.02.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 02:47:36 -0800 (PST)
Date:   Mon, 28 Nov 2022 11:47:30 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Cindy Lu <lulu@redhat.com>
Cc:     jasowang@redhat.com, mst@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] vhost_vdpa: fix the crash in unmap a large memory
Message-ID: <20221128104730.6igmyh6jz7voymdp@sgarzare-redhat>
References: <20221125022317.2157263-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221125022317.2157263-1-lulu@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 10:23:17AM +0800, Cindy Lu wrote:
>While testing in vIOMMU, sometimes guest will unmap very large memory,
>which will cause the crash. To fix this,Move the iommu_unmap to
>vhost_vdpa_pa_unmap/vhost_vdpa_va_unmap and only unmap the memory
>that saved in iotlb.
>
>Call Trace:
>[  647.820144] ------------[ cut here ]------------
>[  647.820848] kernel BUG at drivers/iommu/intel/iommu.c:1174!
>[  647.821486] invalid opcode: 0000 [#1] PREEMPT SMP PTI
>[  647.822082] CPU: 10 PID: 1181 Comm: qemu-system-x86 Not tainted 6.0.0-rc1home_lulu_2452_lulu7_vhost+ #62
>[  647.823139] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.15.0-29-g6a62e0cb0dfe-prebuilt.qem4
>[  647.824365] RIP: 0010:domain_unmap+0x48/0x110
>[  647.825424] Code: 48 89 fb 8d 4c f6 1e 39 c1 0f 4f c8 83 e9 0c 83 f9 3f 7f 18 48 89 e8 48 d3 e8 48 85 c0 75 59
>[  647.828064] RSP: 0018:ffffae5340c0bbf0 EFLAGS: 00010202
>[  647.828973] RAX: 0000000000000001 RBX: ffff921793d10540 RCX: 000000000000001b
>[  647.830083] RDX: 00000000080000ff RSI: 0000000000000001 RDI: ffff921793d10540
>[  647.831214] RBP: 0000000007fc0100 R08: ffffae5340c0bcd0 R09: 0000000000000003
>[  647.832388] R10: 0000007fc0100000 R11: 0000000000100000 R12: 00000000080000ff
>[  647.833668] R13: ffffae5340c0bcd0 R14: ffff921793d10590 R15: 0000008000100000
>[  647.834782] FS:  00007f772ec90640(0000) GS:ffff921ce7a80000(0000) knlGS:0000000000000000
>[  647.836004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[  647.836990] CR2: 00007f02c27a3a20 CR3: 0000000101b0c006 CR4: 0000000000372ee0
>[  647.838107] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>[  647.839283] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>[  647.840666] Call Trace:
>[  647.841437]  <TASK>
>[  647.842107]  intel_iommu_unmap_pages+0x93/0x140
>[  647.843112]  __iommu_unmap+0x91/0x1b0
>[  647.844003]  iommu_unmap+0x6a/0x95
>[  647.844885]  vhost_vdpa_unmap+0x1de/0x1f0 [vhost_vdpa]
>[  647.845985]  vhost_vdpa_process_iotlb_msg+0xf0/0x90b [vhost_vdpa]
>[  647.847235]  ? _raw_spin_unlock+0x15/0x30
>[  647.848181]  ? _copy_from_iter+0x8c/0x580
>[  647.849137]  vhost_chr_write_iter+0xb3/0x430 [vhost]
>[  647.850126]  vfs_write+0x1e4/0x3a0
>[  647.850897]  ksys_write+0x53/0xd0
>[  647.851688]  do_syscall_64+0x3a/0x90
>[  647.852508]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>[  647.853457] RIP: 0033:0x7f7734ef9f4f
>[  647.854408] Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 29 76 f8 ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c8
>[  647.857217] RSP: 002b:00007f772ec8f040 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
>[  647.858486] RAX: ffffffffffffffda RBX: 00000000fef00000 RCX: 00007f7734ef9f4f
>[  647.859713] RDX: 0000000000000048 RSI: 00007f772ec8f090 RDI: 0000000000000010
>[  647.860942] RBP: 00007f772ec8f1a0 R08: 0000000000000000 R09: 0000000000000000
>[  647.862206] R10: 0000000000000001 R11: 0000000000000293 R12: 0000000000000010
>[  647.863446] R13: 0000000000000002 R14: 0000000000000000 R15: ffffffff01100000
>[  647.864692]  </TASK>
>[  647.865458] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs v]
>[  647.874688] ---[ end trace 0000000000000000 ]---

I think you can remove the part below this line.

 From here:

>[  647.876013] RIP: 0010:domain_unmap+0x48/0x110
>[  647.878306] Code: 48 89 fb 8d 4c f6 1e 39 c1 0f 4f c8 83 e9 0c 83 f9 3f 7f 18 48 89 e8 48 d3 e8 48 85 c0 75 59
>[  647.884581] RSP: 0018:ffffae5340c0bbf0 EFLAGS: 00010202
>[  647.886308] RAX: 0000000000000001 RBX: ffff921793d10540 RCX: 000000000000001b
>[  647.888775] RDX: 00000000080000ff RSI: 0000000000000001 RDI: ffff921793d10540
>[  647.890295] RBP: 0000000007fc0100 R08: ffffae5340c0bcd0 R09: 0000000000000003
>[  647.891660] R10: 0000007fc0100000 R11: 0000000000100000 R12: 00000000080000ff
>[  647.893019] R13: ffffae5340c0bcd0 R14: ffff921793d10590 R15: 0000008000100000
>[  647.894506] FS:  00007f772ec90640(0000) GS:ffff921ce7a80000(0000) knlGS:0000000000000000
>[  647.895963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[  647.897348] CR2: 00007f02c27a3a20 CR3: 0000000101b0c006 CR4: 0000000000372ee0
>[  647.898719] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

To here.

And maybe I would also remove the timestamps; in the end they are not 
useful for this fix and they crowd this trace.

>
>Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
>Signed-off-by: Cindy Lu <lulu@redhat.com>
>---
> drivers/vhost/vdpa.c | 10 ++++++++--
> 1 file changed, 8 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>index 166044642fd5..e5a07751bf45 100644
>--- a/drivers/vhost/vdpa.c
>+++ b/drivers/vhost/vdpa.c
>@@ -692,6 +692,8 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v,
> 	struct vhost_iotlb_map *map;
> 	struct page *page;
> 	unsigned long pfn, pinned;
>+	struct vdpa_device *vdpa = v->vdpa;
>+	const struct vdpa_config_ops *ops = vdpa->config;
>
> 	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
> 		pinned = PFN_DOWN(map->size);
>@@ -703,6 +705,8 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v,
> 			unpin_user_page(page);
> 		}
> 		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
>+		if ((ops->dma_map == NULL) && (ops->set_map == NULL))
>+			iommu_unmap(v->domain, map->start, map->size);
> 		vhost_iotlb_map_free(iotlb, map);
> 	}
> }
>@@ -713,11 +717,15 @@ static void vhost_vdpa_va_unmap(struct vhost_vdpa *v,
> {
> 	struct vhost_iotlb_map *map;
> 	struct vdpa_map_file *map_file;
>+	struct vdpa_device *vdpa = v->vdpa;
>+	const struct vdpa_config_ops *ops = vdpa->config;
>
> 	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
> 		map_file = (struct vdpa_map_file *)map->opaque;
> 		fput(map_file->file);
> 		kfree(map_file);
>+		if (ops->set_map == NULL)

Should we check that `dma_map` is also NULL as in the previous hunk?

Thanks,
Stefano

>+			iommu_unmap(v->domain, map->start, map->size);
> 		vhost_iotlb_map_free(iotlb, map);
> 	}
> }
>@@ -805,8 +813,6 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
> 	} else if (ops->set_map) {
> 		if (!v->in_batch)
> 			ops->set_map(vdpa, asid, iotlb);
>-	} else {
>-		iommu_unmap(v->domain, iova, size);
> 	}
>
> 	/* If we are in the middle of batch processing, delay the free
>-- 
>2.34.3
>

