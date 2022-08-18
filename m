Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D06597E81
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 08:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243565AbiHRGSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 02:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243333AbiHRGSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 02:18:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960115F9A9
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 23:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660803519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0NAawQ9XBYnysJg3OwdeE4npc8jcs/ow05KJCd8jCZk=;
        b=dyT7TP049tBceHakkiUgJVhigd9y7vFTfM/VZFdQq725cZBCw4B2OcHZbt3tqw7WeqNFyW
        VO/5fTQ7CFpIq2oCoucpHU9nY0bBiF0IMPTQrYTR6GDddTrC8Dl9Jci5JSc9m4HikGfGlG
        PboDdqyEX04PbWZ9bzO6ewXkIc4pep8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-144-0N4UGYh9PaOL1sqwvCmmBg-1; Thu, 18 Aug 2022 02:18:38 -0400
X-MC-Unique: 0N4UGYh9PaOL1sqwvCmmBg-1
Received: by mail-qt1-f200.google.com with SMTP id s2-20020ac85cc2000000b00342f8ad1f40so513833qta.12
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 23:18:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0NAawQ9XBYnysJg3OwdeE4npc8jcs/ow05KJCd8jCZk=;
        b=TSPYvaJhZFNLVZP/Scki8TOViWoG5d7I5J9Notlq9v+cJz8KDyVEWObeixTPZWfiYr
         bJ9oGGCC1+2AZ4QWLsjyETr7EgSxxg50VqxXSkWj6EFEaOTZCEUn68Z8Q2F4DLZWZOCP
         LxCqmOCJ6kIUTbK6Qdqllt8IrdY8dDRDR6nEOFS1Io63G9Wasy5+mQrauT6UHaXfCNFP
         nNxEgBwNBKHfFkFoQejXnTO9wPIjlUl9BanUWlamdtNYCW+XSzJ33jP2IbjntmpXerpr
         MmLK7Eh8cAZMZB+Z0YAJxsDHnzo9ndVaTI8HUKzdsYsFDy0fgfEEjBNqXOvoKeKbxLdW
         67AQ==
X-Gm-Message-State: ACgBeo1fs30y+Pa0iakI9+e0GDJC1MG0clh1WWf4t4LdIMwSF/TICrPz
        nTkJgklpfwZwcpiABsdIi9WyzhTVjdpSH1OMubO/M+50wLOq8Kogz5NGkdO8C6dnpsbWyfS8QkF
        sbhV+Di9cjjYVLe6TCj0eBUZ7YBrEio75
X-Received: by 2002:ad4:5bc7:0:b0:48b:e9ed:47a8 with SMTP id t7-20020ad45bc7000000b0048be9ed47a8mr1226314qvt.108.1660803517637;
        Wed, 17 Aug 2022 23:18:37 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7i9tzI1gIYnxOQajZ5xPDocGxVzPwJg4mYMy5d4vyh7LD7T4c/zanv9nEMIkZnzlA6roXFACDL2aVIZunCvdQ=
X-Received: by 2002:ad4:5bc7:0:b0:48b:e9ed:47a8 with SMTP id
 t7-20020ad45bc7000000b0048be9ed47a8mr1226308qvt.108.1660803517434; Wed, 17
 Aug 2022 23:18:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn> <20220817135718.2553-3-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220817135718.2553-3-qtxuning1999@sjtu.edu.cn>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 18 Aug 2022 08:18:01 +0200
Message-ID: <CAJaqyWdTjREaPLHLfo8ZyHoA3u5PpdX_=5-iTZOfa9fGpLMnfw@mail.gmail.com>
Subject: Re: [RFC v2 2/7] vhost_test: batch used buffer
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

On Wed, Aug 17, 2022 at 3:58 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> Only add to used ring when a batch of buffer have all been used.  And if
> in order feature negotiated, only add the last used descriptor for a
> batch of buffer.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/vhost/test.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index bc8e7fb1e635..57cdb3a3edf6 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -43,6 +43,9 @@ struct vhost_test {
>  static void handle_vq(struct vhost_test *n)
>  {
>         struct vhost_virtqueue *vq = &n->vqs[VHOST_TEST_VQ];
> +       struct vring_used_elem *heads = kmalloc(sizeof(*heads)
> +                       * vq->num, GFP_KERNEL);

It seems to me we can use kmalloc_array here.

Thanks!

> +       int batch_idx = 0;
>         unsigned out, in;
>         int head;
>         size_t len, total_len = 0;
> @@ -84,11 +87,14 @@ static void handle_vq(struct vhost_test *n)
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
> +       if (batch_idx)
> +               vhost_add_used_and_signal_n(&n->dev, vq, heads, batch_idx);
>
>         mutex_unlock(&vq->mutex);
>  }
> --
> 2.17.1
>

