Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7995A927F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 10:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbiIAI4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 04:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiIAI4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 04:56:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81717131DFD
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 01:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662022576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wlt+f7gBjVGkc0zcQ2pNtyBrX9IrrQuzBjMRXWCKVdg=;
        b=Cmpm/rfqf5o2169JdnYIidR7jNgbYmful1YbSCZFNtAFM+/8otHwfwJGWGaupARiD+6oyt
        qXmBobrMWIZ4uXYb49VEK5dfJJ+mtShowzcJEZDMBh8HR/J/cNC7I5hK0nyKxs0CdKfP/l
        nvUnuViQ2pMejaRJYMLZedVuUjMC3sQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-633-oUJUkYOtM1Cq4MICfSVV-A-1; Thu, 01 Sep 2022 04:56:15 -0400
X-MC-Unique: oUJUkYOtM1Cq4MICfSVV-A-1
Received: by mail-qk1-f200.google.com with SMTP id br15-20020a05620a460f00b006bc58c26501so13699323qkb.0
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 01:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Wlt+f7gBjVGkc0zcQ2pNtyBrX9IrrQuzBjMRXWCKVdg=;
        b=7hTISNakkCCCLKm7nD6H0Z8xXXPELNiCODkaNxQMw9yr4WhYDcwyux+o5SouF7alA0
         dA5ZajfNfTFmC6wO9tj/hYysaG/eEAF+zzF/fWxVTKSueQiFX40oxtlY8aWs7M5wFXWI
         tOZH3V82gkZ2MjQsvNMTq9JbKvzitLDqZqQvskBFR6AqwNd4AC5opOMMMO8ejcxYn9b3
         br6Ufe1lMlC5BAJeP+oVfUBvgUqtu4AeNzJgxMKuPph/9SdjapwDAewiTnXxS+/RM0Wb
         WQr9BrxoRDKYvYP/LWlCoazlfdEi7btMQKJ5DBvqvWuDzDk6jq6gtJSy8Y/gtdYhfRgO
         bfNg==
X-Gm-Message-State: ACgBeo3whpEQxGQkMUvMOf9yS9Nn/YtazkOHu2PsxMipKeqXFmeZqIJ8
        vjGkmoDt6ZPvSbLMZM2KyZT7+YwEOf/6hlpYgrOvsumUkqOI/Bntt80sCjUUliv9g1D9XtoDKYC
        svNvocJr02YI/xFMEyqDXxiAIT5w2Aquz
X-Received: by 2002:a05:622a:4204:b0:344:e16c:e597 with SMTP id cp4-20020a05622a420400b00344e16ce597mr22689197qtb.592.1662022574905;
        Thu, 01 Sep 2022 01:56:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5u2YDUEtCaIjrrUX8nL8zujU37Phr2hYBocVlhEmZWrU4E4NS/pqAa1UdI+qmflN4UtxuwF42IFeJEHEE3Luc=
X-Received: by 2002:a05:622a:4204:b0:344:e16c:e597 with SMTP id
 cp4-20020a05622a420400b00344e16ce597mr22689189qtb.592.1662022574715; Thu, 01
 Sep 2022 01:56:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn> <20220901055434.824-2-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220901055434.824-2-qtxuning1999@sjtu.edu.cn>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 1 Sep 2022 10:55:38 +0200
Message-ID: <CAJaqyWchvGKvtjFg_YkioGYtxSp6MmNVdhPvyRLHuz1aWrtgGA@mail.gmail.com>
Subject: Re: [RFC v3 1/7] vhost: expose used buffers
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 1, 2022 at 7:55 AM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> Follow VIRTIO 1.1 spec, only writing out a single used ring for a batch
> of descriptors.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/vhost/vhost.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826cff0..26862c8bf751 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2376,10 +2376,20 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>         vring_used_elem_t __user *used;
>         u16 old, new;
>         int start;
> +       int copy_n = count;
>
> +       /**
> +        * If in order feature negotiated, devices can notify the use of a batch of buffers to
> +        * the driver by only writing out a single used ring entry with the id corresponding
> +        * to the head entry of the descriptor chain describing the last buffer in the batch.
> +        */
> +       if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
> +               copy_n = 1;
> +               heads = &heads[count - 1];
> +       }
>         start = vq->last_used_idx & (vq->num - 1);
>         used = vq->used->ring + start;
> -       if (vhost_put_used(vq, heads, start, count)) {
> +       if (vhost_put_used(vq, heads, start, copy_n)) {
>                 vq_err(vq, "Failed to write used");
>                 return -EFAULT;
>         }
> @@ -2388,7 +2398,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>                 smp_wmb();
>                 /* Log used ring entry write. */
>                 log_used(vq, ((void __user *)used - (void __user *)vq->used),
> -                        count * sizeof *used);
> +                        copy_n * sizeof(*used));

log_used reports to the VMM the modified memory by the device. It
iterates over used descriptors translating them to do so.

We need to either report here all the descriptors or to modify
log_used so it reports all the batch with in_order feature. The latter
has an extra advantage: no need to report these non-existent writes to
the used ring of the skipped buffers. Although it probably does not
make a difference in performance.

With the current code, we could iterate the heads[] array too, calling
. However, I think it would be a waste. More on that later.

Thanks!

>         }
>         old = vq->last_used_idx;
>         new = (vq->last_used_idx += count);
> @@ -2410,7 +2420,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
>
>         start = vq->last_used_idx & (vq->num - 1);
>         n = vq->num - start;
> -       if (n < count) {
> +       if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>                 r = __vhost_add_used_n(vq, heads, n);
>                 if (r < 0)
>                         return r;
> --
> 2.17.1
>

