Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109FF51E69E
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 13:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiEGLXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 07:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiEGLXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 07:23:06 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1474141F86
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 04:19:18 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id r11so16991151ybg.6
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 04:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T6MapXFEJ/fT4MdHkAMG0qd6Y1FG2YpfLqeiPc1kRec=;
        b=oTw0q8u3+wMbvi1Khz96bxuANDSHLIfKB7bkla2kFYPpzKdwFJ/hc9xlueFd74YEMc
         AjDy49blw5LDUa/U8mapG0LuK+Rmr05abrceae2kApXUecLzH2bGx13Y+JNfhickwAHe
         A4LjOy6MdP3R8omfPelW9xyRmfjot5VezGjqer4fYsYHAumqJfwTWoTAGkmBtXRwm0uw
         EvQ8xGIX49Tl2gD64Y1rV/JW0TFbfaND1lurfwuGWssIVHnpAc1USUZgtrrXi3LCiF+I
         D5jzGDHVpbxD9XnBJJtwLwNrSgxQLuxdFsfPW5/6yPuawMGB7pO9VxCVkREHvjW5zTfM
         rGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T6MapXFEJ/fT4MdHkAMG0qd6Y1FG2YpfLqeiPc1kRec=;
        b=yuAm0+oxkfJhdVHqAwrMo3pXgpVz8lb1JOLqO3s+hvFYwKW4yeLOtUq1AYBss6yGij
         vpGjAGP9SuIPXs9ZDjkacuVRQQH8ouQxKVOcdPTHsf9CYWjQXZCRvNMgxSsiNjiM8Wxy
         6ZjSiwpIGPPoPkTxHgxuW2MjvoykZcVSRYPoECuJizLGNU/LNDvddmzWH1KBgJMINgMU
         ZSHhzh2InVn0yIvess73TDO0WyijuCKOcI4nxord83Wbt78Kwrngu3B+dOS1nh6pkPP9
         /HMTSaMbM45vCu9byXWl9imveJPfMjpgTy5ccsqfIe1KgsOH9DAfnK1OyU8FLsDNHX5N
         jpag==
X-Gm-Message-State: AOAM530xuI94rzwvTgIowrx2lyslwLSf71Qw1CU4KhpozKI2rymnWNjl
        9O/0N6zZiojqs4CA5OYLsGRcAYixJD58A07Nd/wWmw==
X-Google-Smtp-Source: ABdhPJxk0cN5+U2mrfF9w8An2ZBIqQyj4zvzGuy+JIWiN8xCdytha3KTT7Ipqx0rnqz4Vu11IoEXK3jemLGPO80VVRk=
X-Received: by 2002:a25:3157:0:b0:649:b216:bb4e with SMTP id
 x84-20020a253157000000b00649b216bb4emr5882604ybx.387.1651922356947; Sat, 07
 May 2022 04:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-13-eric.dumazet@gmail.com> <20220506153414.72f26ee3@kernel.org>
 <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com>
 <20220506185405.527a79d4@kernel.org> <202205070026.11B94DF@keescook>
In-Reply-To: <202205070026.11B94DF@keescook>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 7 May 2022 04:19:06 -0700
Message-ID: <CANn89iLS_2cshtuXPyNUGDPaic=sJiYfvTb_wNLgWrZRyBxZ_g@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
To:     Kees Cook <keescook@chromium.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 7, 2022 at 12:46 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, May 06, 2022 at 06:54:05PM -0700, Jakub Kicinski wrote:
> > On Fri, 6 May 2022 17:32:43 -0700 Eric Dumazet wrote:
> > > On Fri, May 6, 2022 at 3:34 PM Jakub Kicinski <kuba@kernel.org> wrote=
:
> > > > In function =E2=80=98fortify_memcpy_chk=E2=80=99,
> > > >     inlined from =E2=80=98mlx5e_sq_xmit_wqe=E2=80=99 at ../drivers/=
net/ethernet/mellanox/mlx5/core/en_tx.c:408:5:
> > > > ../include/linux/fortify-string.h:328:25: warning: call to =E2=80=
=98__write_overflow_field=E2=80=99 declared with attribute warning: detecte=
d write beyond size of field (1st parameter); maybe use struct_group()? [-W=
attribute-warning]
> > > >   328 |                         __write_overflow_field(p_size_field=
, size);
> > > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~
>
> Ah, my old friend, inline_hdr.start. Looks a lot like another one I fixed
> earlier in ad5185735f7d ("net/mlx5e: Avoid field-overflowing memcpy()"):
>
>         if (attr->ihs) {
>                 if (skb_vlan_tag_present(skb)) {
>                         eseg->inline_hdr.sz |=3D cpu_to_be16(attr->ihs + =
VLAN_HLEN);
>                         mlx5e_insert_vlan(eseg->inline_hdr.start, skb, at=
tr->ihs);
>                         stats->added_vlan_packets++;
>                 } else {
>                         eseg->inline_hdr.sz |=3D cpu_to_be16(attr->ihs);
>                         memcpy(eseg->inline_hdr.start, skb->data, attr->i=
hs);
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^
>                 }
>                 dseg +=3D wqe_attr->ds_cnt_inl;
>
> This is actually two regions, 2 bytes in eseg and everything else in
> dseg. Splitting the memcpy() will work:
>
>         memcpy(eseg->inline_hdr.start, skb->data, sizeof(eseg->inline_hdr=
.start));
>         memcpy(dseg, skb->data + sizeof(eseg->inline_hdr.start), ihs - si=
zeof(eseg->inline_hdr.start));
>
> But this begs the question, what is validating that ihs -2 is equal to
> wqe_attr->ds_cnt_inl * sizeof(*desg) ?
>
> And how is wqe bounds checked?

Look at the definition of struct mlx5i_tx_wqe

Then mlx5i_sq_calc_wqe_attr() computes the number of ds_cnt  (16 bytes
granularity)
units needed.

Then look at mlx5e_txqsq_get_next_pi()

I doubt a compiler can infer that the driver is correct.

Basically this is variable length structure, quite common in NIC
world, given number of dma descriptor can vary from 1 to XX,
and variable size of headers. (Typically, fast NIC want to get the
headers inlined in TX descriptor)


>
>
> > > > In function =E2=80=98fortify_memcpy_chk=E2=80=99,
> > > >     inlined from =E2=80=98mlx5i_sq_xmit=E2=80=99 at ../drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c:962:4:
> > > > ../include/linux/fortify-string.h:328:25: warning: call to =E2=80=
=98__write_overflow_field=E2=80=99 declared with attribute warning: detecte=
d write beyond size of field (1st parameter); maybe use struct_group()? [-W=
attribute-warning]
> > > >   328 |                         __write_overflow_field(p_size_field=
, size);
> > > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~
>
> And moar inline_hdr.start:
>
>         if (attr.ihs) {
>                 memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
>                 eseg->inline_hdr.sz =3D cpu_to_be16(attr.ihs);
>                 dseg +=3D wqe_attr.ds_cnt_inl;
>         }
>
> again, a split:
>
>         memcpy(eseg->inline_hdr.start, skb->data, sizeof(eseg->inline_hdr=
.start));
>         eseg->inline_hdr.sz =3D cpu_to_be16(attr.ihs);
>         memcpy(dseg, skb->data + sizeof(eseg->inline_hdr.start), ihs - si=
zeof(eseg->inline_hdr.start));
>         dseg +=3D wqe_attr.ds_cnt_inl;
>
> And the same bounds questions come up.
>
> It'd be really nice to get some kind of generalized "copy out of
> skb->data with bounds checking that may likely all get reduced to
> constant checks".


NIC drivers send millions of packets per second.
We can not really afford copying each component of a frame one byte at a ti=
me.

The memcpy() here can typically copy IPv6 header (40 bytes) + TCP
header (up to 60 bytes), plus more headers if encapsulation is added.

Thanks.
