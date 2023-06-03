Return-Path: <netdev+bounces-7642-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEF45720EBC
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 10:22:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BEE21C20F18
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFBAC12B;
	Sat,  3 Jun 2023 08:22:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D898BFF
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 08:22:30 +0000 (UTC)
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF81299;
	Sat,  3 Jun 2023 01:22:28 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id a1e0cc1a2514c-7841f18f9f7so750588241.0;
        Sat, 03 Jun 2023 01:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685780548; x=1688372548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j8g2hnOGOg2sxpTnLUbSGzAiSvvgwyqIgGFTiGWjGU0=;
        b=rk5jL5mSq6M2gxVyXs4AUO7B65MmZArJzj3wGRXaSqEsGRuwpHAWF2E9/hMFbKk3c8
         e4J5pa9SUHMps06XsQ+RxYXPuzuni8NHeYDSYI2xO/UQ49l2A5gS6/4jG3OFwBMYmE81
         y79noa98hW4pqR2rjBCeCl8nPDi012PX9gVFQNQGk1UXVr4m4XmDvNUqYULKwOFf6Xar
         2DBh/N6PETCeNBD9+r0VjTjxasPJFUVqVKsrvMFAPkd/Fs7Sx8Pn6rEs/ZTuD7nZ0HIY
         mfIQvZWI3I+JzOEx6t22cO64rgX3pncWQqcG2P/ECJzu0HB3GMWlTtGYLcMlUX/oO4Mc
         Bpnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685780548; x=1688372548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j8g2hnOGOg2sxpTnLUbSGzAiSvvgwyqIgGFTiGWjGU0=;
        b=RRKZ4/6zYB4JdsufrgTPGIPqUlUFPeNDjmjItfl49H8xQA1i+mH98Mduh/ZBj8t/57
         ef2sAfzd/23oZpPZps+FTR9F3RlhbMAT5IfAcxc6KDJTu8GmlrWtVFOyZwvNzBqzejZ7
         xer1a5jEdEvK0hW8+RDRNagCYmLSP+bgL/rWMkfwBbWLkUvi7aHRqgCnGm5l6o6EoIcV
         nAhdWCQQPiH1Ph1I6SRKrSekVPJ/BCVggfnmOPDDjvkjfRMmP4DXtZ0UR8Uie17Uueag
         BXIrHR0kwWGZAvpsZHuvEXgqOqjT2XZeLV+28av0/4bNmc5tp5fRDyNN8f0Gx8Ep+qfP
         OiQQ==
X-Gm-Message-State: AC+VfDwwaAQ8NRkA7U1br8JHDNtz3ovjgFSmQWrBbbyH7LQUxK+6G7CK
	1m3wwduG2mWBj7y5FRxCYe2Ny4A1Qm0EmcjklE8=
X-Google-Smtp-Source: ACHHUZ5ZX5Rv93vS+T0aa4l7PxWVuS+bIALakx92H3qwe7964NQXeeZKVsd/UNfQ8dr18rTvPckahEu218QkzqjD+rk=
X-Received: by 2002:a1f:6017:0:b0:461:479d:745d with SMTP id
 u23-20020a1f6017000000b00461479d745dmr985295vkb.8.1685780547644; Sat, 03 Jun
 2023 01:22:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602163044.1820619-1-leitao@debian.org>
In-Reply-To: <20230602163044.1820619-1-leitao@debian.org>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sat, 3 Jun 2023 10:21:50 +0200
Message-ID: <CAF=yD-Kk9mVWPZN50NUu8uGwEbySNS-WzvJ=1HTTcVsA6OOuvA@mail.gmail.com>
Subject: Re: [PATCH net-next v5] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
To: Breno Leitao <leitao@debian.org>
Cc: Remi Denis-Courmont <courmisch@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexander Aring <alex.aring@gmail.com>, Stefan Schmidt <stefan@datenfreihafen.org>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, David Ahern <dsahern@kernel.org>, 
	Matthieu Baerts <matthieu.baerts@tessares.net>, Mat Martineau <martineau@kernel.org>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, axboe@kernel.dk, 
	asml.silence@gmail.com, leit@fb.com, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, dccp@vger.kernel.org, linux-wpan@vger.kernel.org, 
	mptcp@lists.linux.dev, linux-sctp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 6:31=E2=80=AFPM Breno Leitao <leitao@debian.org> wro=
te:
>
> Most of the ioctls to net protocols operates directly on userspace
> argument (arg). Usually doing get_user()/put_user() directly in the
> ioctl callback.  This is not flexible, because it is hard to reuse these
> functions without passing userspace buffers.
>
> Change the "struct proto" ioctls to avoid touching userspace memory and
> operate on kernel buffers, i.e., all protocol's ioctl callbacks is
> adapted to operate on a kernel memory other than on userspace (so, no
> more {put,get}_user() and friends being called in the ioctl callback).
>
> This changes the "struct proto" ioctl format in the following way:
>
>     int                     (*ioctl)(struct sock *sk, int cmd,
> -                                        unsigned long arg);
> +                                        int *karg);
>
> So, the "karg" argument, which is passed to the ioctl callback, is a
> pointer allocated to kernel space memory (inside a function wrapper).
> This buffer (karg) may contain input argument (copied from userspace in
> a prep function) and it might return a value/buffer, which is copied
> back to userspace if necessary. There is not one-size-fits-all format
> (that is I am using 'may' above), but basically, there are three type of
> ioctls:
>
> 1) Do not read from userspace, returns a result to userspace
> 2) Read an input parameter from userspace, and does not return anything
>   to userspace
> 3) Read an input from userspace, and return a buffer to userspace.
>
> The default case (1) (where no input parameter is given, and an "int" is
> returned to userspace) encompasses more than 90% of the cases, but there
> are two other exceptions. Here is a list of exceptions:
>
> * Protocol RAW:
>    * cmd =3D SIOCGETVIFCNT:
>      * input and output =3D struct sioc_vif_req
>    * cmd =3D SIOCGETSGCNT
>      * input and output =3D struct sioc_sg_req
>    * Explanation: for the SIOCGETVIFCNT case, userspace passes the input
>      argument, which is struct sioc_vif_req. Then the callback populates
>      the struct, which is copied back to userspace.
>
> * Protocol RAW6:
>    * cmd =3D SIOCGETMIFCNT_IN6
>      * input and output =3D struct sioc_mif_req6
>    * cmd =3D SIOCGETSGCNT_IN6
>      * input and output =3D struct sioc_sg_req6
>
> * Protocol PHONET:
>   * cmd =3D=3D SIOCPNADDRESOURCE | SIOCPNDELRESOURCE
>      * input int (4 bytes)
>   * Nothing is copied back to userspace.
>
> For the exception cases, functions sock_sk_ioctl_inout() will
> copy the userspace input, and copy it back to kernel space.
>
> The wrapper that prepare the buffer and put the buffer back to user is
> sk_ioctl(), so, instead of calling sk->sk_prot->ioctl(), the callee now
> calls sk_ioctl(), which will handle all cases.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Please check the checkpatch output

https://patchwork.hopto.org/static/nipa/753609/13265673/checkpatch/stdout

> +static inline int phonet_sk_ioctl(struct sock *sk, unsigned int cmd, voi=
d __user *arg)
> +{
> +       int karg;
> +
> +       switch (cmd) {
> +       case SIOCPNADDRESOURCE:
> +       case SIOCPNDELRESOURCE:
> +               if (get_user(karg, (int __user *)arg))
> +                       return -EFAULT;
> +
> +               return sk->sk_prot->ioctl(sk, cmd, &karg);
> +       }
> +       /* A positive return value means that the ioctl was not processed=
 */
> +       return 1;
> +}
>  #endif

> +/* A wrapper around sock ioctls, which copies the data from userspace
> + * (depending on the protocol/ioctl), and copies back the result to user=
space.
> + * The main motivation for this function is to pass kernel memory to the
> + * protocol ioctl callbacks, instead of userspace memory.
> + */
> +int sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
> +{
> +       int rc =3D 1;
> +
> +       if (sk_is_ipmr(sk))
> +               rc =3D ipmr_sk_ioctl(sk, cmd, arg);
> +       else if (sk_is_icmpv6(sk))
> +               rc =3D ip6mr_sk_ioctl(sk, cmd, arg);
> +       else if (sk_is_phonet(sk))
> +               rc =3D phonet_sk_ioctl(sk, cmd, arg);

Does this handle all phonet ioctl cases correctly?

Notably pn_socket_ioctl has a SIOCPNGETOBJECT that reads and writes a u16.

