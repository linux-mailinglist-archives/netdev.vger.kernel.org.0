Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A8857DAE4
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 09:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbiGVHNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 03:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbiGVHNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 03:13:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 147E6936B6
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 00:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658474011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wsed93BuNRJkapkugRn/nwfX0SXje/qBsJN6NO73XG0=;
        b=MNDQAfaYHkNKs7tYIXDcOGsJD4bhTq+QIXxxHQ8ymmGVFEIY/KZ6aObsf/HpCEAXQ3LIRw
        8PpMeDNo40Bg3DRt1UHzr8pm81MgsyezbVAoD/+bMmWXeOUW2MibHxKWf3oeM7puXcwrkv
        WETPMN6hZj4kvtzFaeIK9Jxt17yNFw0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-1pF837IPO5yvnBecm56vPA-1; Fri, 22 Jul 2022 03:13:24 -0400
X-MC-Unique: 1pF837IPO5yvnBecm56vPA-1
Received: by mail-qv1-f69.google.com with SMTP id q3-20020ad45743000000b004735457f428so2518397qvx.23
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 00:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wsed93BuNRJkapkugRn/nwfX0SXje/qBsJN6NO73XG0=;
        b=NXKt0/Pwn6JSQoPFcgjMWZlh9Hg5M82gfLC/OwMUi9IfEqA7OztyY65u8MGlV8rpAP
         b+PO2nMQNUB85KtolH0kGX4knKhDA9KOqNd3TwGz4Q8squksDD81/yHqB+WBF+Ip2gJK
         CUmMoPPpiCKIi6ustD64mPm1ied7BiRkojzpCf+UHspJhhKjAPivhJ56kBb//NbaJnS1
         put1UDxgNAMHv2wtqaJ9v/J7zbDu83NWZxY989/a9tuXP1GyIM1fJPOtQqYIJThOxZld
         PqIApCDCOZx02cIFkKbpYgIDgEvEKs77GwByTr+CoX8USYEEZAnnMXedzbKzFXuuyL1W
         dwvw==
X-Gm-Message-State: AJIora/4Zayo3kOju807SRXpUYMzMjuFolwiAqoZ2R+A3y9HSQLczYgj
        mBvWYq8pyihyynf1IF5WBX6YHyE1W8YRpv94bWbpGRqiVieTU2J3UDfKRIGpZcpmbkVrsSY0I42
        A/UGj9UI16DGFQyDN5nDg1KvR5uD6UEnI
X-Received: by 2002:a0c:be91:0:b0:474:1d6:b1a4 with SMTP id n17-20020a0cbe91000000b0047401d6b1a4mr1734955qvi.108.1658474003804;
        Fri, 22 Jul 2022 00:13:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tEcyOOrz8ulXALLU3lOqBWBPAhsUJqLPMU34S78oArx1JQGAQejfV6MMkgWmFYInqi0IgRkgNkqkYPfZYae8I=
X-Received: by 2002:a0c:be91:0:b0:474:1d6:b1a4 with SMTP id
 n17-20020a0cbe91000000b0047401d6b1a4mr1734938qvi.108.1658474003579; Fri, 22
 Jul 2022 00:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn> <20220721084341.24183-4-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220721084341.24183-4-qtxuning1999@sjtu.edu.cn>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 22 Jul 2022 09:12:47 +0200
Message-ID: <CAJaqyWfgUqdP6mkOUdouvQSst=qc7MOTaigC-EiTg9-gojHqzg@mail.gmail.com>
Subject: Re: [RFC 3/5] vhost_test: batch used buffer
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 10:44 AM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> Only add to used ring when a batch a buffer have all been used.  And if
> in order feature negotiated, add randomness to the used buffer's order,
> test the ability of vhost to reorder batched buffer.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/vhost/test.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index bc8e7fb1e..1c9c40c11 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -43,6 +43,9 @@ struct vhost_test {
>  static void handle_vq(struct vhost_test *n)
>  {
>         struct vhost_virtqueue *vq = &n->vqs[VHOST_TEST_VQ];
> +       struct vring_used_elem *heads = kmalloc(sizeof(*heads)
> +                       * vq->num, GFP_KERNEL);
> +       int batch_idx = 0;
>         unsigned out, in;
>         int head;
>         size_t len, total_len = 0;
> @@ -84,11 +87,21 @@ static void handle_vq(struct vhost_test *n)
>                         vq_err(vq, "Unexpected 0 len for TX\n");
>                         break;
>                 }
> -               vhost_add_used_and_signal(&n->dev, vq, head, 0);
> +               heads[batch_idx].id = cpu_to_vhost32(vq, head);
> +               heads[batch_idx++].len = cpu_to_vhost32(vq, len);
>                 total_len += len;
>                 if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
>                         break;
>         }
> +       if (batch_idx) {
> +               if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER) && batch_idx >= 2) {

Maybe to add a module parameter to test this? Instead of trusting in
feature negotiation, "unorder_used=1" or something like that.

vhost.c:vhost_add_used_and_signal_n should support receiving buffers
in order or out of order whether F_IN_ORDER is negotiated or not.

Thanks!

> +                       vhost_add_used_and_signal_n(&n->dev, vq, &heads[batch_idx / 2],
> +                                                   batch_idx - batch_idx / 2);
> +                       vhost_add_used_and_signal_n(&n->dev, vq, heads, batch_idx / 2);
> +               } else {
> +                       vhost_add_used_and_signal_n(&n->dev, vq, heads, batch_idx);
> +               }
> +       }
>
>         mutex_unlock(&vq->mutex);
>  }
> --
> 2.17.1
>

