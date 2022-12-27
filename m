Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290E1656774
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 07:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiL0GFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 01:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiL0GFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 01:05:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5018E3893
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 22:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672121057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JtwK0TmUyPB3eYskZMtg0oNP152qeukFtzmu8szThS4=;
        b=DqQ5gJ6sIs5GYY/AZHOdgEBHaWkP39q7GptckzO1WSf/WxUV/D4qSaA4x0ljizwVE2xJbz
        aFR+WCXSC90XE6CSwhHG64F/1V47+51EPNtI0M0+dW0xLxVAfLdqS0gJ3UwCnY3SvIDP2K
        EULs09MemSx8UPK6diBI7YiMYpWCeY0=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-19-sXYuciVvOs-39YZpdutvQw-1; Tue, 27 Dec 2022 01:04:15 -0500
X-MC-Unique: sXYuciVvOs-39YZpdutvQw-1
Received: by mail-oo1-f70.google.com with SMTP id w18-20020a4a6d52000000b0049f209d84bbso5714122oof.7
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 22:04:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JtwK0TmUyPB3eYskZMtg0oNP152qeukFtzmu8szThS4=;
        b=tY0kOxgshryn4oneMumaAnX6CSsu14rCoKETONRBWPWsC3kAPaTWl4qiUc/+cnLEf5
         6EGvKLPD8BL5K6jr/tuYD7cYbcpBlK1tGXBgF6sL+DK+smrS7sAYSB1g7bdor6SRarKt
         5laVU0mIIjZk/CXjxZclvwEFtLuzkBnhE4+uSjb/ZlK4AhcLbxbClNtKFDeK8augqHoP
         acE0A669lMc4/QxYg1LSX0uIeAyp2QIViXU+/7/GJmDbKG8B0l3A3cJiauaAL0vu+E/9
         97hk5LYJB2T5G/aTsxw1oS6kNWHIEuQcpcH8oowWP8KDeBVsBiABm7Qu6Nlo+W7RPjhi
         S5BQ==
X-Gm-Message-State: AFqh2kqO3CRDraArMlp0TU4UjuhY5LNgf+uyFvt4wBBJv9EBpFFQYxRP
        BVaT+AMCBFN/dyS/VV1mQpLDOdGCIRFcNuYvP9K09EIr82M5NP9I9bBa06Vy0tkhB6DAFk2PIcb
        NtDyRIuh/tZc000ssOhUIh0sneeqijB40
X-Received: by 2002:aca:1111:0:b0:35e:7a42:7ab5 with SMTP id 17-20020aca1111000000b0035e7a427ab5mr1074626oir.280.1672121054826;
        Mon, 26 Dec 2022 22:04:14 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtdg06zg3ogBEVD5FhVYBrkQ3mVFEJUcvWP+Qa87KA4giCLeV4ft04uckoxPDm96o/QYr3l3GA1xlty9lfuvl8=
X-Received: by 2002:aca:1111:0:b0:35e:7a42:7ab5 with SMTP id
 17-20020aca1111000000b0035e7a427ab5mr1074622oir.280.1672121054572; Mon, 26
 Dec 2022 22:04:14 -0800 (PST)
MIME-Version: 1.0
References: <20221227022528.609839-1-mie@igel.co.jp> <20221227022528.609839-3-mie@igel.co.jp>
In-Reply-To: <20221227022528.609839-3-mie@igel.co.jp>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 27 Dec 2022 14:04:03 +0800
Message-ID: <CACGkMEtAaYpuZtS0gx_m931nFzcvqSNK9BhvUZH_tZXTzjgQCg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] vringh: remove vringh_iov and unite to vringh_kiov
To:     Shunsuke Mie <mie@igel.co.jp>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
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

On Tue, Dec 27, 2022 at 10:25 AM Shunsuke Mie <mie@igel.co.jp> wrote:
>
> struct vringh_iov is defined to hold userland addresses. However, to use
> common function, __vring_iov, finally the vringh_iov converts to the
> vringh_kiov with simple cast. It includes compile time check code to make
> sure it can be cast correctly.
>
> To simplify the code, this patch removes the struct vringh_iov and unifies
> APIs to struct vringh_kiov.
>
> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>

While at this, I wonder if we need to go further, that is, switch to
using an iov iterator instead of a vringh customized one.

Thanks

> ---
>  drivers/vhost/vringh.c | 32 ++++++------------------------
>  include/linux/vringh.h | 45 ++++--------------------------------------
>  2 files changed, 10 insertions(+), 67 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 828c29306565..aa3cd27d2384 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -691,8 +691,8 @@ EXPORT_SYMBOL(vringh_init_user);
>   * calling vringh_iov_cleanup() to release the memory, even on error!
>   */
>  int vringh_getdesc_user(struct vringh *vrh,
> -                       struct vringh_iov *riov,
> -                       struct vringh_iov *wiov,
> +                       struct vringh_kiov *riov,
> +                       struct vringh_kiov *wiov,
>                         bool (*getrange)(struct vringh *vrh,
>                                          u64 addr, struct vringh_range *r),
>                         u16 *head)
> @@ -708,26 +708,6 @@ int vringh_getdesc_user(struct vringh *vrh,
>         if (err == vrh->vring.num)
>                 return 0;
>
> -       /* We need the layouts to be the identical for this to work */
> -       BUILD_BUG_ON(sizeof(struct vringh_kiov) != sizeof(struct vringh_iov));
> -       BUILD_BUG_ON(offsetof(struct vringh_kiov, iov) !=
> -                    offsetof(struct vringh_iov, iov));
> -       BUILD_BUG_ON(offsetof(struct vringh_kiov, i) !=
> -                    offsetof(struct vringh_iov, i));
> -       BUILD_BUG_ON(offsetof(struct vringh_kiov, used) !=
> -                    offsetof(struct vringh_iov, used));
> -       BUILD_BUG_ON(offsetof(struct vringh_kiov, max_num) !=
> -                    offsetof(struct vringh_iov, max_num));
> -       BUILD_BUG_ON(sizeof(struct iovec) != sizeof(struct kvec));
> -       BUILD_BUG_ON(offsetof(struct iovec, iov_base) !=
> -                    offsetof(struct kvec, iov_base));
> -       BUILD_BUG_ON(offsetof(struct iovec, iov_len) !=
> -                    offsetof(struct kvec, iov_len));
> -       BUILD_BUG_ON(sizeof(((struct iovec *)NULL)->iov_base)
> -                    != sizeof(((struct kvec *)NULL)->iov_base));
> -       BUILD_BUG_ON(sizeof(((struct iovec *)NULL)->iov_len)
> -                    != sizeof(((struct kvec *)NULL)->iov_len));
> -
>         *head = err;
>         err = __vringh_iov(vrh, *head, (struct vringh_kiov *)riov,
>                            (struct vringh_kiov *)wiov,
> @@ -740,14 +720,14 @@ int vringh_getdesc_user(struct vringh *vrh,
>  EXPORT_SYMBOL(vringh_getdesc_user);
>
>  /**
> - * vringh_iov_pull_user - copy bytes from vring_iov.
> + * vringh_iov_pull_user - copy bytes from vring_kiov.
>   * @riov: the riov as passed to vringh_getdesc_user() (updated as we consume)
>   * @dst: the place to copy.
>   * @len: the maximum length to copy.
>   *
>   * Returns the bytes copied <= len or a negative errno.
>   */
> -ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len)
> +ssize_t vringh_iov_pull_user(struct vringh_kiov *riov, void *dst, size_t len)
>  {
>         return vringh_iov_xfer(NULL, (struct vringh_kiov *)riov,
>                                dst, len, xfer_from_user);
> @@ -755,14 +735,14 @@ ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len)
>  EXPORT_SYMBOL(vringh_iov_pull_user);
>
>  /**
> - * vringh_iov_push_user - copy bytes into vring_iov.
> + * vringh_iov_push_user - copy bytes into vring_kiov.
>   * @wiov: the wiov as passed to vringh_getdesc_user() (updated as we consume)
>   * @src: the place to copy from.
>   * @len: the maximum length to copy.
>   *
>   * Returns the bytes copied <= len or a negative errno.
>   */
> -ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
> +ssize_t vringh_iov_push_user(struct vringh_kiov *wiov,
>                              const void *src, size_t len)
>  {
>         return vringh_iov_xfer(NULL, (struct vringh_kiov *)wiov,
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index 1991a02c6431..733d948e8123 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -79,18 +79,6 @@ struct vringh_range {
>         u64 offset;
>  };
>
> -/**
> - * struct vringh_iov - iovec mangler.
> - *
> - * Mangles iovec in place, and restores it.
> - * Remaining data is iov + i, of used - i elements.
> - */
> -struct vringh_iov {
> -       struct iovec *iov;
> -       size_t consumed; /* Within iov[i] */
> -       unsigned i, used, max_num;
> -};
> -
>  /**
>   * struct vringh_kiov - kvec mangler.
>   *
> @@ -113,44 +101,19 @@ int vringh_init_user(struct vringh *vrh, u64 features,
>                      vring_avail_t __user *avail,
>                      vring_used_t __user *used);
>
> -static inline void vringh_iov_init(struct vringh_iov *iov,
> -                                  struct iovec *iovec, unsigned num)
> -{
> -       iov->used = iov->i = 0;
> -       iov->consumed = 0;
> -       iov->max_num = num;
> -       iov->iov = iovec;
> -}
> -
> -static inline void vringh_iov_reset(struct vringh_iov *iov)
> -{
> -       iov->iov[iov->i].iov_len += iov->consumed;
> -       iov->iov[iov->i].iov_base -= iov->consumed;
> -       iov->consumed = 0;
> -       iov->i = 0;
> -}
> -
> -static inline void vringh_iov_cleanup(struct vringh_iov *iov)
> -{
> -       if (iov->max_num & VRINGH_IOV_ALLOCATED)
> -               kfree(iov->iov);
> -       iov->max_num = iov->used = iov->i = iov->consumed = 0;
> -       iov->iov = NULL;
> -}
> -
>  /* Convert a descriptor into iovecs. */
>  int vringh_getdesc_user(struct vringh *vrh,
> -                       struct vringh_iov *riov,
> -                       struct vringh_iov *wiov,
> +                       struct vringh_kiov *riov,
> +                       struct vringh_kiov *wiov,
>                         bool (*getrange)(struct vringh *vrh,
>                                          u64 addr, struct vringh_range *r),
>                         u16 *head);
>
>  /* Copy bytes from readable vsg, consuming it (and incrementing wiov->i). */
> -ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len);
> +ssize_t vringh_iov_pull_user(struct vringh_kiov *riov, void *dst, size_t len);
>
>  /* Copy bytes into writable vsg, consuming it (and incrementing wiov->i). */
> -ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
> +ssize_t vringh_iov_push_user(struct vringh_kiov *wiov,
>                              const void *src, size_t len);
>
>  /* Mark a descriptor as used. */
> --
> 2.25.1
>

