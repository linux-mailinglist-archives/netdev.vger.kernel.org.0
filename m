Return-Path: <netdev+bounces-1683-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FBA16FECD5
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C344281199
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA4B1B8F2;
	Thu, 11 May 2023 07:31:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5B881F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:31:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB7D35A0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683790296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5V0/1s5ImrAvwwVL+7JYFZ+EKAgRU5k+UcpUCxvavT4=;
	b=QM2aIJ4cDLqPDMnaFveD925vZIJWfK3igvYhpuUb3rJgXsYoU7+L3d+TC/Yoj8oFTUTIoz
	WNP+owQFKzwvg6YvYZaL3Fu2QZnr8uV/pmrsuWgHvwmDFUWz25GTjWPjbn5j/48p68WlJu
	QOtxBC5cStUZhKq4VzhJ3HGA4qVToWE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-c8T97LnHNqWBfekA2-t1_w-1; Thu, 11 May 2023 03:31:34 -0400
X-MC-Unique: c8T97LnHNqWBfekA2-t1_w-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2ac7f9e64ecso41628401fa.3
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683790293; x=1686382293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5V0/1s5ImrAvwwVL+7JYFZ+EKAgRU5k+UcpUCxvavT4=;
        b=le302gfyvg4M6HRx2oleAK+Luqk3QRaLaG92Cyc/31N5xTgFOz2hzCG2JEwDAGBEhs
         A2PZXclIBSsv+um2FQrsjWyr98G9bs24+Ous3tvRsB8mC6tQ2rWHvObc+mdcDzLt/AMC
         86FRe9fmqh5u95rxkyY7Sc7Wn6lxW5vkowX0etO8uWzVhMTpgcTFUB010zHBV1cCxHCC
         Ch7qnJttpc3MG78AzknseSI05zWX/HFJU2A64pmnFmisVk3eiWdW0vt7m3fl1jc+cBkd
         MylpR8GbGWMhi+jDVnc3CAIHk7KlY+D+BeDIH9PLw620Da2svuA72GSOM+OnX0vQj8b1
         waOw==
X-Gm-Message-State: AC+VfDyz+SAulInXCIpKIC17qCYa+Z54HNw6feBZZIcTPH9C1tsGyzLR
	r5bxXPWmTIrA/Ji/0G7fXhLSUoLrjwtL+Gxu0p/mqLc+l3jAqytRL9knmL4nAwVzGLL0bDdeAlq
	xV7FcKoiDTZnEl0cZctQrnk8G3IkXQ3qD
X-Received: by 2002:ac2:5398:0:b0:4f1:3ca4:926f with SMTP id g24-20020ac25398000000b004f13ca4926fmr2305162lfh.21.1683790293478;
        Thu, 11 May 2023 00:31:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Wbc1XZdl4sGlowrfd/KP1k6He8tT2ctNUXs3FHeEquzBLM1HwcZ4pHvc+WQU60ovxrcq99qQ+d/QbDRRb6OU=
X-Received: by 2002:ac2:5398:0:b0:4f1:3ca4:926f with SMTP id
 g24-20020ac25398000000b004f13ca4926fmr2305152lfh.21.1683790293117; Thu, 11
 May 2023 00:31:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230424204411.24888-1-asmetanin@yandex-team.ru>
In-Reply-To: <20230424204411.24888-1-asmetanin@yandex-team.ru>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 11 May 2023 15:31:22 +0800
Message-ID: <CACGkMEsqXoXPLAxuzs-2wAvouwnqe_Q7Z9A=EROoqfjHgD849A@mail.gmail.com>
Subject: Re: [PATCH v2] vhost_net: revert upend_idx only on retriable error
To: Andrey Smetanin <asmetanin@yandex-team.ru>
Cc: mst@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Apr 25, 2023 at 4:44=E2=80=AFAM Andrey Smetanin
<asmetanin@yandex-team.ru> wrote:
>
> Fix possible virtqueue used buffers leak and corresponding stuck
> in case of temporary -EIO from sendmsg() which is produced by
> tun driver while backend device is not up.
>
> In case of no-retriable error and zcopy do not revert upend_idx
> to pass packet data (that is update used_idx in corresponding
> vhost_zerocopy_signal_used()) as if packet data has been
> transferred successfully.
>
> v2: set vq->heads[ubuf->desc].len equal to VHOST_DMA_DONE_LEN
> in case of fake successful transmit.
>
> Signed-off-by: Andrey Smetanin <asmetanin@yandex-team.ru>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vhost/net.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 20265393aee7..0791fbdb3975 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -934,13 +934,18 @@ static void handle_tx_zerocopy(struct vhost_net *ne=
t, struct socket *sock)
>
>                 err =3D sock->ops->sendmsg(sock, &msg, len);
>                 if (unlikely(err < 0)) {
> +                       bool retry =3D err =3D=3D -EAGAIN || err =3D=3D -=
ENOMEM || err =3D=3D -ENOBUFS;
> +
>                         if (zcopy_used) {
>                                 if (vq->heads[ubuf->desc].len =3D=3D VHOS=
T_DMA_IN_PROGRESS)
>                                         vhost_net_ubuf_put(ubufs);
> -                               nvq->upend_idx =3D ((unsigned)nvq->upend_=
idx - 1)
> -                                       % UIO_MAXIOV;
> +                               if (retry)
> +                                       nvq->upend_idx =3D ((unsigned)nvq=
->upend_idx - 1)
> +                                               % UIO_MAXIOV;
> +                               else
> +                                       vq->heads[ubuf->desc].len =3D VHO=
ST_DMA_DONE_LEN;
>                         }
> -                       if (err =3D=3D -EAGAIN || err =3D=3D -ENOMEM || e=
rr =3D=3D -ENOBUFS) {
> +                       if (retry) {
>                                 vhost_discard_vq_desc(vq, 1);
>                                 vhost_net_enable_vq(net, vq);
>                                 break;
> --
> 2.25.1
>


