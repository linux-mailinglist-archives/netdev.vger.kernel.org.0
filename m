Return-Path: <netdev+bounces-500-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F0EC6F7D32
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:45:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B8711C216E3
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 06:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87ECF1C2B;
	Fri,  5 May 2023 06:45:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5E2ED1
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 06:45:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E649C83C1
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 23:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683269143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKpAY5tib+SQpvOchvtEiIJtmEfRPK050PpqPwR0jHc=;
	b=E/gmzDGQb7hGYt6db/K4LxrH/AXze2JSpgv3P59uV4RgeW5bz4MF39MM35WTVZwgo3audw
	6y/cbFfdsO+rhUm5yhRojZh5Akds0Ya4NmXNnXefYo82LA+bNMuA46YL3WOcX6dknIrUlC
	wPuWb3xehBdH4u4iAf6wKXpqKKAIRIs=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-t2H4zE4fOriRhWKnFTNx3A-1; Fri, 05 May 2023 02:45:41 -0400
X-MC-Unique: t2H4zE4fOriRhWKnFTNx3A-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4f13ecb8f01so741794e87.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 23:45:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683269140; x=1685861140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tKpAY5tib+SQpvOchvtEiIJtmEfRPK050PpqPwR0jHc=;
        b=fbZaUKy39dXgiO9TL8jXdeqbAhY86jlkhYW7Fs/+hi8izN1/1v9u8qNr04CXYIrajf
         e8Nk/LVW8cy6VJh1zQaen47QK0Gu3T0yH7IZj48R47DVHKcITlYNEpNr0FKqnQmwzg7s
         hxTL/ATH9bvBppzTX1axbxlRURnACvj6lQ50ttIxc0FIQ0LkVT9STIIycAPgh7svbvmh
         s0uy9osA+TRZT0NkUOyUhDWyIKepi57R98LlMslLPQ3MWSXzAmvkPPWmItdLOetOElNo
         4HcbvKpVnvIJ/bH2rKhvER0bsYfa/CG7BPNqZUC9m/SCDGRwxBo2IGdG+pzRaIoe3gAU
         0TlA==
X-Gm-Message-State: AC+VfDzlVtk5H6hbjn+YTPjg7ZDYKzpu/xeOGD8GfkLIrnd1jPeI/to8
	u1Sv6vk7iwv8P7wBz3h6ZRK2eQ2goCAyQ0XZZ6avbXGTeobYRnxo9bbeXxuvp8EKwIOnNpO9zUy
	Xb+QAyb1dn6n0/yFizN6Kqn35skWRamIH
X-Received: by 2002:ac2:442a:0:b0:4dd:afd7:8f1 with SMTP id w10-20020ac2442a000000b004ddafd708f1mr243040lfl.52.1683269139921;
        Thu, 04 May 2023 23:45:39 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5P/6Ery2ecRIgtV5T5zf4Jc/nCqTDngMKXH4mXgZ7mTAePFoMVTxdzE82a2WU80aozee42X8+tx+80IrXPk0s=
X-Received: by 2002:ac2:442a:0:b0:4dd:afd7:8f1 with SMTP id
 w10-20020ac2442a000000b004ddafd708f1mr243034lfl.52.1683269139638; Thu, 04 May
 2023 23:45:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202305051424047152799@zte.com.cn>
In-Reply-To: <202305051424047152799@zte.com.cn>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 5 May 2023 14:45:28 +0800
Message-ID: <CACGkMEsmf3PgxmhgRCsPZe7fRWHDXQ=TtYu5Tgx1=_Ymyvi-pA@mail.gmail.com>
Subject: Re: [PATCH] vhost_net: Use fdget() and fdput()
To: ye.xingchen@zte.com.cn
Cc: mst@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 5, 2023 at 2:24=E2=80=AFPM <ye.xingchen@zte.com.cn> wrote:
>
> From: Ye Xingchen <ye.xingchen@zte.com.cn>
>
> convert the fget()/fput() uses to fdget()/fdput().

What's the advantages of this?

Thanks

>
> Signed-off-by: Ye Xingchen <ye.xingchen@zte.com.cn>
> ---
>  drivers/vhost/net.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index ae2273196b0c..5b3fe4805182 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1466,17 +1466,17 @@ static struct ptr_ring *get_tap_ptr_ring(struct f=
ile *file)
>
>  static struct socket *get_tap_socket(int fd)
>  {
> -       struct file *file =3D fget(fd);
> +       struct fd f =3D fdget(fd);
>         struct socket *sock;
>
> -       if (!file)
> +       if (!f.file)
>                 return ERR_PTR(-EBADF);
> -       sock =3D tun_get_socket(file);
> +       sock =3D tun_get_socket(f.file);
>         if (!IS_ERR(sock))
>                 return sock;
> -       sock =3D tap_get_socket(file);
> +       sock =3D tap_get_socket(f.file);
>         if (IS_ERR(sock))
> -               fput(file);
> +               fdput(f);
>         return sock;
>  }
>
> --
> 2.25.1
>


