Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C81652BC5
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 04:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiLUDYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 22:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbiLUDYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 22:24:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F591ADB9
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 19:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671593010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CFnvNj9hg0uk4ty9l25TpJtyYdolUCT1QyYJMfBzM80=;
        b=GNC4nU9uxmFlTsnvSW8EyvwmEo30URokeMhcfnHi2TP2FBKX1QIknUTYA0sV0fde8bhnTg
        nAyr4nNXAiUvJXfiUBgBGGJLoE82z5V9bxZvtfZMt4eMgwc6a/Upft7Vyce3M8feQGbl/p
        5oqcJk+2CGL24K64XPZ5P2LMMx4M1FA=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-169-BUS5x3QXMhq_bfWrBhRqMQ-1; Tue, 20 Dec 2022 22:23:21 -0500
X-MC-Unique: BUS5x3QXMhq_bfWrBhRqMQ-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-1447ffe6046so6263565fac.3
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 19:23:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CFnvNj9hg0uk4ty9l25TpJtyYdolUCT1QyYJMfBzM80=;
        b=44/4Ah1riKO/+81UNb5W6ERc2san51lRqkhoS0/2NYWIoY4kbHtASAYoA8ZEk/kxXt
         B3KOeReTD3Jiqk3VjV833F4Cdb+Cd2Pt/2r48h1Il7WQ9i00QbTFPh525vKOyInAtxYd
         fms9z+28MRa1fiasnivVrK6VFW+O5F33moITnEjRIQulZ9AD6Kz0NsOffRK+hG6s0Ig7
         Fb7TvuLpNpZsnxj6HeTlmdco9jTi+uJx8Klb3ARBd/0A0Q2HXkSWCahyrYlCSkWZl3OY
         qJ0ufZ8gngybQvV2x6MGM+VdVrJM70cG/p2RPa7BovME53zfJhOvKvnDvpMChIkpsPHH
         +1bw==
X-Gm-Message-State: AFqh2kqa5YJvkCQBdN8YBRX1UvmuhAHYff6KSIX3qK5pY4qRLuoBzAu/
        X+HtFNOUTFIpRC/RSurV3N5dvZpVqmdJizQhhzVVMXqwsjk3RBJykVSQ6lcckFOaa0iGv74454I
        BiDZIENSzdZ0umohnteuhkdWM6guj/zmk
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id u19-20020a056870441300b00144a97b1ae2mr5750oah.35.1671593000985;
        Tue, 20 Dec 2022 19:23:20 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvCqHucOMNWaOuq5hOMU7pwt2QCc0KdTdowmUytqZw+Vtlqfi8EU47R4djYK+989+3MChf2+uVMV3LQ50Op9xs=
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id
 u19-20020a056870441300b00144a97b1ae2mr5744oah.35.1671593000701; Tue, 20 Dec
 2022 19:23:20 -0800 (PST)
MIME-Version: 1.0
References: <20221220140205.795115-1-lulu@redhat.com>
In-Reply-To: <20221220140205.795115-1-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 21 Dec 2022 11:23:09 +0800
Message-ID: <CACGkMEuJuUrA220XgHDOruK-aHWSfJ6mTaqNVQCAcOsPEwV91A@mail.gmail.com>
Subject: Re: [PATCH] vhost_vdpa: fix the compile issue in commit 881ac7d2314f
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
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

On Tue, Dec 20, 2022 at 10:02 PM Cindy Lu <lulu@redhat.com> wrote:
>
> The input of  vhost_vdpa_iotlb_unmap() was changed in 881ac7d2314f,
> But some function was not changed while calling this function.
> Add this change
>
> Cc: stable@vger.kernel.org
> Fixes: 881ac7d2314f ("vhost_vdpa: fix the crash in unmap a large memory")

Is this commit merged into Linus tree?

Btw, Michael, I'd expect there's a respin of the patch so maybe Cindy
can squash the fix into the new version?

Thanks

> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 46ce35bea705..ec32f785dfde 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -66,8 +66,8 @@ static DEFINE_IDA(vhost_vdpa_ida);
>  static dev_t vhost_vdpa_major;
>
>  static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
> -                                  struct vhost_iotlb *iotlb,
> -                                  u64 start, u64 last);
> +                                  struct vhost_iotlb *iotlb, u64 start,
> +                                  u64 last, u32 asid);
>
>  static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
>  {
> @@ -139,7 +139,7 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
>                 return -EINVAL;
>
>         hlist_del(&as->hash_link);
> -       vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
> +       vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1, asid);
>         kfree(as);
>
>         return 0;
> --
> 2.34.3
>

