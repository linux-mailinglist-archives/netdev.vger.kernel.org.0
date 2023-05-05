Return-Path: <netdev+bounces-545-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 995CF6F80E3
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 12:37:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C63B6280FD2
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4903C4C7F;
	Fri,  5 May 2023 10:37:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF05156CD
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 10:37:39 +0000 (UTC)
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62F6F4
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 03:37:37 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-3330afe3d2fso65065ab.1
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 03:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683283057; x=1685875057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wlVvS1v7N/COSWgkkDH9X2UEC2lG92A8iSjKf25mMI=;
        b=XSlwE98p2kAwpjEeJx68OQtPMW7TbCflWFyrALwVMXLNfOqSO0/nGdGMX/2sUEzh/N
         VQRIUvDHe2G5r6leZDY6kHSyUfXxdaabOivZeFT8Gzgp54ryrT3DAKg/aVw/0BnrP05u
         jjVexGnlq0cMPgsUT5zJmhuANwvKB9IfFkQzFeO9jziLeRIpGD3++sptt5DSLkuYqb9q
         bU9EQ79beGjnWlFwMh3R1xoEK3gaCQIa1RdPyvet55L/6JQdYVfhpOczXp5It+RztYYP
         F0GfcT9spxgaYY5K1a8O62ya/pYMTSlIdGu3zb1m6X7aoiwpDw6nkwmyE8m/P6SexMz9
         qTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683283057; x=1685875057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6wlVvS1v7N/COSWgkkDH9X2UEC2lG92A8iSjKf25mMI=;
        b=jMS12UdYTOa7dhoSMFMWzNYKu+aeZ1TIXTaRIrxq48C4wJRgeOX+SomErtwQUGQM07
         8j8jTlIfIxM6c1rFNq6u1dAgeYmqx60YzaxUk6ZIfqX/5FdPXHm0xnv3E1Z2ClBcAgMA
         1eueJQDxy4xzDtlb9VLmj4phWEr0QkOeoyTBT8YHtXpRTlsaTWrx0XxsgFUy64BN1Enb
         kxR1uIrNBsBerVUQIes/S32e+6LH+cuxCQVvEHJo0B4F/sgT04C2bxvPo1phuwW0Jrss
         kZHxi/WhM0zKrww5+0mxl83qZ53JwR0GUlO96xSvzpjF2XJ0DrlrZGMv37o2RrbnVVO8
         uhZg==
X-Gm-Message-State: AC+VfDyXVkK6FABmFssJePetecRRdSIGXhZwzmTnILyC/ocOo6mvug8f
	2L8FmzMO+ruI1F3vxQR9PpAaQGZ9hd7NaWQWzcyCgw==
X-Google-Smtp-Source: ACHHUZ6YRsexopUfQEOI3fgm6au97dvlIEZZXNJCDB87P5n1x7pvcMSdlRGPtHW+QZYFZvZ4gAggef3EWs32hucpXfQ=
X-Received: by 2002:a05:6e02:1b0d:b0:331:948c:86f3 with SMTP id
 i13-20020a056e021b0d00b00331948c86f3mr106180ilv.19.1683283056873; Fri, 05 May
 2023 03:37:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202305051706416319733@zte.com.cn>
In-Reply-To: <202305051706416319733@zte.com.cn>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 5 May 2023 12:37:25 +0200
Message-ID: <CANn89iK8c5S3P8s9mfoaa9J=Pt1zXyjdRPPMp8nFV1eqYZovDQ@mail.gmail.com>
Subject: Re: [PATCH] net: socket: Use fdget() and fdput()
To: ye.xingchen@zte.com.cn
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 5, 2023 at 11:06=E2=80=AFAM <ye.xingchen@zte.com.cn> wrote:
>
> From: Ye Xingchen <ye.xingchen@zte.com.cn>
>
> By using the fdget function, the socket object, can be quickly obtained
> from the process's file descriptor table without the need to obtain the
> file descriptor first before passing it as a parameter to the fget
> function.
>

net-next is currently closed.

There are good reasons we have sockfd_lookup() and sockfd_lookup_light(),
you probably should take a deeper look at the difference between them.



> Signed-off-by: Ye Xingchen <ye.xingchen@zte.com.cn>
> ---
>  net/socket.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/net/socket.c b/net/socket.c
> index a7b4b37d86df..84daba774432 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -528,19 +528,18 @@ EXPORT_SYMBOL(sock_from_file);
>
>  struct socket *sockfd_lookup(int fd, int *err)
>  {
> -       struct file *file;
> +       struct fd f =3D fdget(fd);
>         struct socket *sock;
>
> -       file =3D fget(fd);
> -       if (!file) {
> +       if (!f.file) {
>                 *err =3D -EBADF;
>                 return NULL;
>         }
>
> -       sock =3D sock_from_file(file);
> +       sock =3D sock_from_file(f.file);
>         if (!sock) {
>                 *err =3D -ENOTSOCK;
> -               fput(file);
> +               fdput(f);
>         }
>         return sock;
>  }
> --
> 2.25.1

