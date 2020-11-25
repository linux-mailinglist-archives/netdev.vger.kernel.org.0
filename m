Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5F52C3B05
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 09:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgKYIXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 03:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbgKYIXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 03:23:14 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D879FC0613D4;
        Wed, 25 Nov 2020 00:23:14 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id s63so1756408pgc.8;
        Wed, 25 Nov 2020 00:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ts1Mh07u5awC1TeyjU+cdYdGlksf+EcTMCYSsc8xf5I=;
        b=hZAL6/BxWW0dwNxvZxz+DzHbhIBzLxLgpKrsWCJQ1rx4qPfw0jaR7rN8XmJn4JTG7c
         GwdFnNWAU7dpLNZuUjaRuSm6WKImbDQlaEEuv7hSJV5vIf21rdFHHaULOGJFz+r6kowL
         9H5VPifppJ5y62ftq1u7tznfjXm4kcZt1T6LrXy8x9LwfwlWqzZZ6Z3q9fNU88D9TKvz
         0YNumyqfqLGFTkqOt3zmSGgES//SKclh61g5aTO+u0A2q4qY/Z8gvS2jkai6TjXB2999
         TGH0C+COzN0bDc59AAE6auOlbhPg+17I4mlBfGOs2qM2jwE6gRQPiCosZEKkvh6EgUdi
         tlyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ts1Mh07u5awC1TeyjU+cdYdGlksf+EcTMCYSsc8xf5I=;
        b=aYKTj7yPdPpD0l4/DtVztg6ostR43rwn5TxaxS0C/HFEkyEQszXxsHPX/+R+athNGT
         SL+RmayaRTeb/JAi8Ej1eg5iA9BGr8vHm/0MxXVAY1rnNLkl7vOYWADNflpUj4NLJdr5
         ZR72n28Lk0I6a87U+WlW0QeC70BsK/aE9xClF9iAwDquXddqPRClRogRNCNkTF2KsWVr
         PcKyn2WjKaY9vXRtyg9efz+j5Qt8hOspawC/uZCavEKWHGEkcCnBOdLQti8rgBDFuGoS
         jf/6C+n++bYEUXIehvX0/89/GpqIa6ueFUltNIVfxDFagX2olKtssPxYN+BX9tPplSUx
         Lz0g==
X-Gm-Message-State: AOAM530gifYzddudQoFjSvXb1KhXEwmANVJCVXTn+YzPAHoV89d6r5ex
        54+I3cpwvevO5H2xLA6vTbGL+vP1+V5WdC82s4jnJy5LcCabZ+b3c88=
X-Google-Smtp-Source: ABdhPJzwhdGKOfLWTswWfon2nDs149P7OR+bPfGlr16P29Zw+8KfkPp/qAJ5xV4kRVMzIvYapGKnqXiq3v58+PEXL5Q=
X-Received: by 2002:aa7:9521:0:b029:18b:b43:6cc with SMTP id
 c1-20020aa795210000b029018b0b4306ccmr1574651pfp.73.1606292594503; Wed, 25 Nov
 2020 00:23:14 -0800 (PST)
MIME-Version: 1.0
References: <20201119083024.119566-1-bjorn.topel@gmail.com> <20201119083024.119566-11-bjorn.topel@gmail.com>
In-Reply-To: <20201119083024.119566-11-bjorn.topel@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 25 Nov 2020 09:23:03 +0100
Message-ID: <CAJ8uoz3HfjurV9BdCzscKyhRgHK_rTq4_Vqj2aupsVGHN8-HVg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 10/10] samples/bpf: add option to set the
 busy-poll budget
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 9:33 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Support for the SO_BUSY_POLL_BUDGET setsockopt, via the batching
> option ('b').
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  samples/bpf/xdpsock_user.c | 5 +++++
>  1 file changed, 5 insertions(+)

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index cb1eaee8a32b..deba623e9003 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -1479,6 +1479,11 @@ static void apply_setsockopt(struct xsk_socket_inf=
o *xsk)
>         if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL=
,
>                        (void *)&sock_opt, sizeof(sock_opt)) < 0)
>                 exit_with_error(errno);
> +
> +       sock_opt =3D opt_batch_size;
> +       if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL=
_BUDGET,
> +                      (void *)&sock_opt, sizeof(sock_opt)) < 0)
> +               exit_with_error(errno);
>  }
>
>  int main(int argc, char **argv)
> --
> 2.27.0
>
