Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A0A5A929E
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbiIAJCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiIAJBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:01:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269A212BC2F
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 02:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662022841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8mt67aF+6co4O3ixWvunn6QiNw9LDIbjyfyYr/fh0ZY=;
        b=c+/fTIpNLeR7YhfphaF5fIXLH6sCuapXX8TRQ1FTPKyIELjEMthJw0nNJ39JdIbQmgJ3dc
        QuZqP9Q9bWj75WhlhWkNAx3h6VwGz+qz5SdU8M+Lxdd/vvqU+saroOZ0rNyY7rYIE28TYp
        8gSZF2MfjtpZgHGH9sCMb7M37BtNYFk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-546-hAnlPJs-PWOGzOjHj4zDZQ-1; Thu, 01 Sep 2022 05:00:39 -0400
X-MC-Unique: hAnlPJs-PWOGzOjHj4zDZQ-1
Received: by mail-qk1-f197.google.com with SMTP id s9-20020a05620a254900b006b54dd4d6deso13698398qko.3
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 02:00:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=8mt67aF+6co4O3ixWvunn6QiNw9LDIbjyfyYr/fh0ZY=;
        b=gEhXsAgP6H+5oScdwSS579Jywv4WN0BGGmDkF0Jiq0PhzMPz3kTagSw02bYg1dOhuu
         SuFHcCx82xp8EdGk573i5r2gsF0w2SHUwOh7ICWt77tHwF2cpmzoadKZ3FP5BW16ScpR
         8YyhtM99DERGh4bpvL00Z5KOPDYWvRFjD0m3ujpZJI2arHPedwBqbUJI2WO2wgoScBh6
         Y9lxvNYvHGezQF6QcUdcKr11w0hx7UcbGYsYOJQR2GJalnGE0M5b1NRXnBxSzHCKVt6v
         g6z24FI1L20002Ebd/9zBe+uRoKlel0F8wez8oQs6/qBzLX+CJLJw9zSm21jElSDNRE7
         tF9g==
X-Gm-Message-State: ACgBeo36InAHZk5im5xi+geW5Yu2oqRePg0RmnA9KBANxEGFWUuURpN3
        +nLVfFyzWQp2Sbj4asOVflzplw5i8ip59TQ37Zxvadcz5P/sUJAaF/3pBTkFn2AgCd0k6NVFu6A
        7nKKS8oAq6RwitkxMsO4HRcfZHXD2QzAi
X-Received: by 2002:a05:622a:15c3:b0:344:7c48:bfb2 with SMTP id d3-20020a05622a15c300b003447c48bfb2mr22660914qty.370.1662022839490;
        Thu, 01 Sep 2022 02:00:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6JniwzUbUHGWnENjDhen1GCDMSpZDyCOvT0FUaBOPK2wQyDY0m971rfQdjcLbJ80DkWju9fbvsYnge8l7FCVE=
X-Received: by 2002:a05:622a:15c3:b0:344:7c48:bfb2 with SMTP id
 d3-20020a05622a15c300b003447c48bfb2mr22660890qty.370.1662022839181; Thu, 01
 Sep 2022 02:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn> <20220901055434.824-4-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220901055434.824-4-qtxuning1999@sjtu.edu.cn>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 1 Sep 2022 11:00:03 +0200
Message-ID: <CAJaqyWdSNVyWeHyeZgzhczL0+bcvYShwJEfzHpjmy45cSSre3Q@mail.gmail.com>
Subject: Re: [RFC v3 3/7] vsock: batch buffers in tx
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 1, 2022 at 7:55 AM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> Vsock uses buffers in order, and for tx driver doesn't have to
> know the length of the buffer. So we can do a batch for vsock if
> in order negotiated, only write one used ring for a batch of buffers
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/vhost/vsock.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 368330417bde..e08fbbb5439e 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -497,7 +497,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>         struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
>                                                  dev);
>         struct virtio_vsock_pkt *pkt;
> -       int head, pkts = 0, total_len = 0;
> +       int head, pkts = 0, total_len = 0, add = 0;
>         unsigned int out, in;
>         bool added = false;
>
> @@ -551,10 +551,18 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>                 else
>                         virtio_transport_free_pkt(pkt);
>
> -               vhost_add_used(vq, head, 0);
> +               if (!vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
> +                       vhost_add_used(vq, head, 0);
> +               } else {
> +                       vq->heads[add].id = head;
> +                       vq->heads[add++].len = 0;

Knowing that the descriptors are used in order we can save a few
memory writes to the vq->heads[] array. vhost.c is checking for the
feature in_order anyway.

Thanks!

> +               }
>                 added = true;
>         } while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
>
> +       /* If in order feature negotiaged, we can do a batch to increase performance */
> +       if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER) && added)
> +               vhost_add_used_n(vq, vq->heads, add);
>  no_more_replies:
>         if (added)
>                 vhost_signal(&vsock->dev, vq);
> --
> 2.17.1
>

