Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9738351F6A0
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbiEIIMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238830AbiEIIJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:09:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9E8C14AC93
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 01:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652083343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L0dEJhPvtpVY9vKuKdRWMDwwctVUgQ9NezFDM8exNt8=;
        b=XgsuxuTjKne3T607Lnero9XT4mvkjVMjgFkR7/sf8VwsIV3xk+pDFkmWQxPxR0MAg7md+c
        ueppxXX28RPsvDTtMNVrLuTuopszfMCsz4kCnfufbveYMGDjd2R2UlYmLeA6ZDQSGhcJGe
        WLHryY6cxHy13B2WdkszL+EVbV33GA8=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-kNlrX3gMMbSYAV1PvVF-Xw-1; Mon, 09 May 2022 04:02:20 -0400
X-MC-Unique: kNlrX3gMMbSYAV1PvVF-Xw-1
Received: by mail-lf1-f71.google.com with SMTP id h15-20020ac24daf000000b00472586ed83dso5496614lfe.22
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 01:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0dEJhPvtpVY9vKuKdRWMDwwctVUgQ9NezFDM8exNt8=;
        b=JZcbH6H/bHWmw1BI14jRDR2zT9FBIStUKJ9OR5daZt/VsHYC/db8QVSXzw0QMk5c1f
         xd4JbiTc+yq35RqWrhsfg15EGVCE/I2Rd/7SIQT1khhMAzqEJPa3e/jWioQFwCzNmPs1
         JQIQ7oeEcQg0XgRg1VcmenU7lem7pWSBz7jEzQWDeUzmYGqVOli60mb5721HQ234SwuL
         avttNtKyg7v1azrglmkqvOJJXXEazsxZ6WibJfE4DQquBEo0LAlHNq1s+R5mOoDeaTfa
         oBgov47t+W9zK8r45C/FbMfkYSDKedkQ1CWM5gx5uNtkPwiekfYTnAwHyxi6eLMjxMRF
         lrRg==
X-Gm-Message-State: AOAM531nB/NmcPXt/Daa3U9GxeZwq4FDLSpio04BVpBG5iSVQ6RnPTmT
        CoVzAbDDlrz7dTjO6gbgzB0JxP8iDwEtxXz20Z7yRhud9quvbbzrpBJJtOOaLlYWO4iyzURIlmX
        M9hQa3SQIHLL1eZWzbYnp5vX+zijqg9p/
X-Received: by 2002:a05:651c:89:b0:250:87c9:d4e6 with SMTP id 9-20020a05651c008900b0025087c9d4e6mr9955097ljq.315.1652083338955;
        Mon, 09 May 2022 01:02:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+R1VfoIPFwnxs6fui5BsHA9rC2X2yYYrOq5wpGklCNwM4/hEwSYAJG1Ghk78Cjqu1eMIefFsXW/FXguj6+c8=
X-Received: by 2002:a05:651c:89:b0:250:87c9:d4e6 with SMTP id
 9-20020a05651c008900b0025087c9d4e6mr9955078ljq.315.1652083338682; Mon, 09 May
 2022 01:02:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220509071426.155941-1-lulu@redhat.com>
In-Reply-To: <20220509071426.155941-1-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 9 May 2022 16:02:06 +0800
Message-ID: <CACGkMEuPoXp7kC1yVoTJ8jpgV8c+0=LcPbuZdzxm8D3v6jAmbQ@mail.gmail.com>
Subject: Re: [PATCH v1] vdpa: Do not count the pages that were already pinned
 in the vhost-vDPA
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 3:15 PM Cindy Lu <lulu@redhat.com> wrote:
>
> We count pinned_vm as follow in vhost-vDPA
>
>         lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>         if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
>                 ret = -ENOMEM;
>                 goto unlock;
>         }
> This means if we have two vDPA devices for the same VM the pages would be counted twice
> So we add a tree to save the page that counted and we will not count it again
>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vhost/vdpa.c     | 79 ++++++++++++++++++++++++++++++++++++++--
>  include/linux/mm_types.h |  2 +
>  2 files changed, 78 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 05f5fd2af58f..48cb5c8264b5 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -24,6 +24,9 @@
>  #include <linux/vhost.h>
>
>  #include "vhost.h"
> +#include <linux/rbtree.h>
> +#include <linux/interval_tree.h>
> +#include <linux/interval_tree_generic.h>
>
>  enum {
>         VHOST_VDPA_BACKEND_FEATURES =
> @@ -505,6 +508,50 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>         mutex_unlock(&d->mutex);
>         return r;
>  }
> +int vhost_vdpa_add_range_ctx(struct rb_root_cached *root, u64 start, u64 last)
> +{
> +       struct interval_tree_node *new_node;
> +
> +       if (last < start)
> +               return -EFAULT;
> +
> +       /* If the range being mapped is [0, ULONG_MAX], split it into two entries
> +        * otherwise its size would overflow u64.
> +        */
> +       if (start == 0 && last == ULONG_MAX) {
> +               u64 mid = last / 2;
> +
> +               vhost_vdpa_add_range_ctx(root, start, mid);
> +               start = mid + 1;
> +       }
> +
> +       new_node = kmalloc(sizeof(struct interval_tree_node), GFP_ATOMIC);
> +       if (!new_node)
> +               return -ENOMEM;
> +
> +       new_node->start = start;
> +       new_node->last = last;
> +
> +       interval_tree_insert(new_node, root);
> +
> +       return 0;
> +}
> +
> +void vhost_vdpa_del_range(struct rb_root_cached *root, u64 start, u64 last)
> +{
> +       struct interval_tree_node *new_node;
> +
> +       while ((new_node = interval_tree_iter_first(root, start, last))) {
> +               interval_tree_remove(new_node, root);
> +               kfree(new_node);
> +       }
> +}
> +
> +struct interval_tree_node *vhost_vdpa_search_range(struct rb_root_cached *root,
> +                                                  u64 start, u64 last)
> +{
> +       return interval_tree_iter_first(root, start, last);
> +}
>
>  static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>  {
> @@ -513,6 +560,7 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>         struct vhost_iotlb_map *map;
>         struct page *page;
>         unsigned long pfn, pinned;
> +       struct interval_tree_node *new_node = NULL;
>
>         while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
>                 pinned = PFN_DOWN(map->size);
> @@ -523,7 +571,18 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>                                 set_page_dirty_lock(page);
>                         unpin_user_page(page);
>                 }
> -               atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
> +
> +               new_node = vhost_vdpa_search_range(&dev->mm->root_for_vdpa,
> +                                                  map->start,
> +                                                  map->start + map->size - 1);
> +
> +               if (new_node) {
> +                       vhost_vdpa_del_range(&dev->mm->root_for_vdpa,
> +                                            map->start,
> +                                            map->start + map->size - 1);
> +                       atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
> +               }
> +
>                 vhost_iotlb_map_free(iotlb, map);
>         }
>  }
> @@ -591,6 +650,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
>         struct vdpa_device *vdpa = v->vdpa;
>         const struct vdpa_config_ops *ops = vdpa->config;
>         int r = 0;
> +       struct interval_tree_node *new_node = NULL;
>
>         r = vhost_iotlb_add_range_ctx(dev->iotlb, iova, iova + size - 1,
>                                       pa, perm, opaque);
> @@ -611,9 +671,22 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
>                 return r;
>         }
>
> -       if (!vdpa->use_va)
> -               atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
> +       if (!vdpa->use_va) {
> +               new_node = vhost_vdpa_search_range(&dev->mm->root_for_vdpa,
> +                                                  iova, iova + size - 1);
> +
> +               if (new_node == 0) {
> +                       r = vhost_vdpa_add_range_ctx(&dev->mm->root_for_vdpa,
> +                                                    iova, iova + size - 1);
> +                       if (r) {
> +                               vhost_iotlb_del_range(dev->iotlb, iova,
> +                                                     iova + size - 1);
> +                               return r;
> +                       }
>
> +                       atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
> +               }

This seems not sufficient, consider:

vhost-vDPA-A: add [A, B)
vhost-vDPA-B: add [A, C) (C>B)

We lose the accounting for [B, C)?

> +       }
>         return 0;
>  }
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 5140e5feb486..46eaa6d0560b 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -634,6 +634,8 @@ struct mm_struct {
>  #ifdef CONFIG_IOMMU_SUPPORT
>                 u32 pasid;
>  #endif
> +               struct rb_root_cached root_for_vdpa;
> +

Let's avoid touching mm_structure unless it's a must.

We can allocate something like vhost_mm if needed during SET_OWNER.

Thanks

>         } __randomize_layout;
>
>         /*
> --
> 2.34.1
>

