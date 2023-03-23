Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97A66C5D04
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCWDDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjCWDDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:03:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0CA20576
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679540544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V1/q/ATjsfc/6alZ9skuNHGyOSWC2q/7g+svCIqwPXA=;
        b=Y2Kt1gp7ytHDE7Hd2iJj68fRa18H28cDkyoUNi8jy3g4kNAR05QmJrl9TXR4dbO3+pe59N
        I5VomsRxTWxjPuoT/Dz3OHthiAWWL2mu7b6OGyrz4HGAoDBx6x66jnNS6zAcbhbpJMGC1u
        SQdj3HNoRHxNOc757AzL49ddvlofjnw=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-JSuca7YLOPiXF2-HL-vhcg-1; Wed, 22 Mar 2023 23:02:22 -0400
X-MC-Unique: JSuca7YLOPiXF2-HL-vhcg-1
Received: by mail-oo1-f71.google.com with SMTP id q190-20020a4a4bc7000000b0053b854160a1so985678ooa.4
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679540542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V1/q/ATjsfc/6alZ9skuNHGyOSWC2q/7g+svCIqwPXA=;
        b=vOhSmaNPACvYL8PAjw2fssQop8OXiNmsICgQ9M7pol0fw5sC7siBi2xllyFxtW+Qeu
         jhvQpbUz3CvpFPV1akyPX+5H6qzcenw+N669qlXdzarjtlPF0raVhbTzugcwGQi96Bnj
         wViXJX8XqfGvgvlHkxDjuTlQlL4opbZrHZC8cWScMQYlDYu+N0SMNHgC2ytNvjlsquMv
         4HATL0It+o0inM0hHzUFze2hWRX+M+gWvWB+PQpGHg2twZSLmhE3pS2Fz4y4a5BU3QnR
         tgnPZnmGNpcRf/weXQZ0Lfy3phfZurFEKC2YGUoK4U4Ig38+peBwx0FS3bOg4Xvmi8iC
         16YA==
X-Gm-Message-State: AO0yUKX5VNvCE89mtU2CLOBlY0eyVSTKgWBF1sFtSaQfX12vK0KJ91tO
        0xVe9V/2YS1AjWP41hpfmfeZ96dHIS7f8x2JMTIdmojWgBoOE5lBFwiAbZw4K6AnaBT3EoPHUsy
        5qePHGIg1TMPku0J6rwIbN2DvBUxvYQcP
X-Received: by 2002:a54:400a:0:b0:384:27f0:bd0a with SMTP id x10-20020a54400a000000b0038427f0bd0amr1632037oie.9.1679540542227;
        Wed, 22 Mar 2023 20:02:22 -0700 (PDT)
X-Google-Smtp-Source: AK7set8KGY7ymo8deUihSS/JSlAOb5tzZYOZLT+Km6uuakG63U+Wxly37yoFJagU90whn6RDzKuaNOE/YjnljkXMXVA=
X-Received: by 2002:a54:400a:0:b0:384:27f0:bd0a with SMTP id
 x10-20020a54400a000000b0038427f0bd0amr1632024oie.9.1679540541948; Wed, 22 Mar
 2023 20:02:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230321154228.182769-1-sgarzare@redhat.com> <20230321154228.182769-4-sgarzare@redhat.com>
In-Reply-To: <20230321154228.182769-4-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 11:02:11 +0800
Message-ID: <CACGkMEsnh9atkXwqn7gx0uKfPLLuph9ROh_0GvaUTXQfv01hkw@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] vringh: replace kmap_atomic() with kmap_local_page()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 11:42=E2=80=AFPM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
>
> kmap_atomic() is deprecated in favor of kmap_local_page() since commit
> f3ba3c710ac5 ("mm/highmem: Provide kmap_local*").
>
> With kmap_local_page() the mappings are per thread, CPU local, can take
> page-faults, and can be called from any context (including interrupts).
> Furthermore, the tasks can be preempted and, when they are scheduled to
> run again, the kernel virtual addresses are restored and still valid.
>
> kmap_atomic() is implemented like a kmap_local_page() which also disables
> page-faults and preemption (the latter only for !PREEMPT_RT kernels,
> otherwise it only disables migration).
>
> The code within the mappings/un-mappings in getu16_iotlb() and
> putu16_iotlb() don't depend on the above-mentioned side effects of
> kmap_atomic(), so that mere replacements of the old API with the new one
> is all that is required (i.e., there is no need to explicitly add calls
> to pagefault_disable() and/or preempt_disable()).
>
> This commit reuses a "boiler plate" commit message from Fabio, who has
> already did this change in several places.
>
> Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>
> Notes:
>     v3:
>     - credited Fabio for the commit message
>     - added reference to the commit that deprecated kmap_atomic() [Jason]
>     v2:
>     - added this patch since checkpatch.pl complained about deprecation
>       of kmap_atomic() touched by next patch
>
>  drivers/vhost/vringh.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index a1e27da54481..0ba3ef809e48 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1220,10 +1220,10 @@ static inline int getu16_iotlb(const struct vring=
h *vrh,
>         if (ret < 0)
>                 return ret;
>
> -       kaddr =3D kmap_atomic(iov.bv_page);
> +       kaddr =3D kmap_local_page(iov.bv_page);
>         from =3D kaddr + iov.bv_offset;
>         *val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
> -       kunmap_atomic(kaddr);
> +       kunmap_local(kaddr);
>
>         return 0;
>  }
> @@ -1241,10 +1241,10 @@ static inline int putu16_iotlb(const struct vring=
h *vrh,
>         if (ret < 0)
>                 return ret;
>
> -       kaddr =3D kmap_atomic(iov.bv_page);
> +       kaddr =3D kmap_local_page(iov.bv_page);
>         to =3D kaddr + iov.bv_offset;
>         WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
> -       kunmap_atomic(kaddr);
> +       kunmap_local(kaddr);
>
>         return 0;
>  }
> --
> 2.39.2
>

