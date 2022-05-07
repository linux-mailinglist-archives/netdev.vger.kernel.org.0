Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734FD51E37C
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 04:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445301AbiEGCOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 22:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356890AbiEGCOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 22:14:45 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A78A5D5E5
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 19:11:00 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id e12so15741298ybc.11
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 19:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=itsR4Qnb5CY1C4lLHhq2Z/2hRzKO93xK159/Nn3j0l8=;
        b=IgvyelVtFw4qC5gxQTTXZMNVjTN1XUEcRkdzNhprXMolFBQflhmeqTtId3C7DF1C9v
         2piEU6MZSI+ocY29SlzUCTpdkAEXtMnYVWX0J3qbbsheRFzX3wcV+T+xHs+OGTq+ZCIu
         V00DkMIg6orRwSTctvZW687CO2q+EojK1G6uXRp7YqOkU23po70HQax7xv9AnXgCjVkv
         ABAKbKJDS6qSILVAcMUO+63QIMVwL+QM6FFMTcu56YD9DA/igYinUOb8USMHA0/ABW06
         2aq4glL9mMsOPP9hza73lsXJe4acK7SxSMnZz8knu/AMty3RWzb3BKPucV3Qec4Or0Nu
         Tcog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=itsR4Qnb5CY1C4lLHhq2Z/2hRzKO93xK159/Nn3j0l8=;
        b=iRQR/CRM24P59RIwjL1bt80aQm0kAk6s7rtGeYaoVnpBp+dwkVDRt+3A4K+G8yZZ5I
         EvUnOobcBQZO0Jg4pf2j+cqFqyc9nvxJQaFH8JOC0s0CQ7j60TlD0FqYKyDgNBMb08VH
         4Zyb0/s4xFmhkM5zTBdV8acKqRUW3IJhOXYMVDzaeeFjZzuP9iga93lfYXGILp0kTmGg
         SwjmxDWIS3tSV8wIDVKv4pDzwPdm3tOi+TLT5lVIZV15Fr51k9FGktC/9vpNpSb1BZqG
         ZKngdMZqxB5DoqFioXwHz5TUeDYuqYtAfiJ7YaPrwjBumpa/99zVGUeKKfIK3k2fgr0H
         v0xQ==
X-Gm-Message-State: AOAM53200XFaH/x8SA1tPuP3EvEXIIc8aBVsuP/9N43EOXQAcaU4y5fw
        zWfZ1xfiUpMVR898q9EUwytpJZXdacSFFwEYaf57Qgp3PW9s42MO
X-Google-Smtp-Source: ABdhPJyDfjPnYm5Ic6ebAdSzlbXkHUiy5oC/YF1K41ILWPXGtyEOvJK60gJGvAc/mjWRUolr2b0eY3Jmed8kmSIW63c=
X-Received: by 2002:a25:2a49:0:b0:648:f2b4:cd3d with SMTP id
 q70-20020a252a49000000b00648f2b4cd3dmr5055025ybq.231.1651889459134; Fri, 06
 May 2022 19:10:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-13-eric.dumazet@gmail.com> <20220506153414.72f26ee3@kernel.org>
 <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com> <20220506185405.527a79d4@kernel.org>
In-Reply-To: <20220506185405.527a79d4@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 6 May 2022 19:10:48 -0700
Message-ID: <CANn89iKQtn0a-Etk-tBrwafbe6dkBz=d3=bkwd8j8_Ed+kiCPQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Kees Cook <keescook@chromium.org>
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

On Fri, May 6, 2022 at 6:54 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 6 May 2022 17:32:43 -0700 Eric Dumazet wrote:
> > On Fri, May 6, 2022 at 3:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Fri,  6 May 2022 08:30:48 -0700 Eric Dumazet wrote:
> > > > From: Coco Li <lixiaoyan@google.com>
> > > >
> > > > mlx5 supports LSOv2.
> > > >
> > > > IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> > > > with JUMBO TLV for big packets.
> > > >
> > > > We need to ignore/skip this HBH header when populating TX descripto=
r.
> > > >
> > > > Note that ipv6_has_hopopt_jumbo() only recognizes very specific pac=
ket
> > > > layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only=
.
> > > >
> > > > v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()
> > > > v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=3Dy
> > >
> > > In file included from ../include/linux/string.h:253,
> > >                  from ../arch/x86/include/asm/page_32.h:22,
> > >                  from ../arch/x86/include/asm/page.h:14,
> > >                  from ../arch/x86/include/asm/processor.h:19,
> > >                  from ../arch/x86/include/asm/timex.h:5,
> > >                  from ../include/linux/timex.h:65,
> > >                  from ../include/linux/time32.h:13,
> > >                  from ../include/linux/time.h:60,
> > >                  from ../include/linux/skbuff.h:15,
> > >                  from ../include/linux/tcp.h:17,
> > >                  from ../drivers/net/ethernet/mellanox/mlx5/core/en_t=
x.c:33:
> > > In function =E2=80=98fortify_memcpy_chk=E2=80=99,
> > >     inlined from =E2=80=98mlx5e_insert_vlan=E2=80=99 at ../drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tx.c:104:2,
> > >     inlined from =E2=80=98mlx5e_sq_xmit_wqe=E2=80=99 at ../drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tx.c:404:5:
> > > ../include/linux/fortify-string.h:328:25: warning: call to =E2=80=98_=
_write_overflow_field=E2=80=99 declared with attribute warning: detected wr=
ite beyond size of field (1st parameter); maybe use struct_group()? [-Wattr=
ibute-warning]
> > >   328 |                         __write_overflow_field(p_size_field, =
size);
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
> > > In function =E2=80=98fortify_memcpy_chk=E2=80=99,
> > >     inlined from =E2=80=98mlx5e_sq_xmit_wqe=E2=80=99 at ../drivers/ne=
t/ethernet/mellanox/mlx5/core/en_tx.c:408:5:
> > > ../include/linux/fortify-string.h:328:25: warning: call to =E2=80=98_=
_write_overflow_field=E2=80=99 declared with attribute warning: detected wr=
ite beyond size of field (1st parameter); maybe use struct_group()? [-Wattr=
ibute-warning]
> > >   328 |                         __write_overflow_field(p_size_field, =
size);
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
> > > In function =E2=80=98fortify_memcpy_chk=E2=80=99,
> > >     inlined from =E2=80=98mlx5i_sq_xmit=E2=80=99 at ../drivers/net/et=
hernet/mellanox/mlx5/core/en_tx.c:962:4:
> > > ../include/linux/fortify-string.h:328:25: warning: call to =E2=80=98_=
_write_overflow_field=E2=80=99 declared with attribute warning: detected wr=
ite beyond size of field (1st parameter); maybe use struct_group()? [-Wattr=
ibute-warning]
> > >   328 |                         __write_overflow_field(p_size_field, =
size);
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
> >
> > I guess these warnings show up before this BIG TCP patch ?
> >
> > I do not see any struct_group() being used in mlx5
> >
> > May I ask which compiler is used here, and what CONFIG_ option needs to=
 be set ?
> >
> > Thanks.
>
> Without our patches drivers/net/ethernet/mellanox/mlx5/core/ builds
> cleanly. Gotta be the new W=3D1 filed overflow warnings, let's bother
> Kees.

Note that inline_hdr.start is a 2 byte array.

Obviously mlx5 driver copies more than 2 bytes of inlined headers.

mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs)
is called already with attr->ihs > 2

So it should already complain ?

static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 =
ihs)
{
   struct vlan_ethhdr *vhdr =3D (struct vlan_ethhdr *)start;
   int cpy1_sz =3D 2 * ETH_ALEN;
   int cpy2_sz =3D ihs - cpy1_sz;

    memcpy(&vhdr->addrs, skb->data, cpy1_sz);
    vhdr->h_vlan_proto =3D skb->vlan_proto;
    vhdr->h_vlan_TCI =3D cpu_to_be16(skb_vlan_tag_get(skb));
    memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz,
cpy2_sz);  // Here, more than 2 bytes are copied already
}
