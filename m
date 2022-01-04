Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46462483AFE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiADDdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiADDdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:33:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA06EC061761;
        Mon,  3 Jan 2022 19:33:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A51A1B81097;
        Tue,  4 Jan 2022 03:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1D7C36AEF;
        Tue,  4 Jan 2022 03:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641267228;
        bh=6SCDZh3zSQ7jJbrqsOakjy6Lp1xDZYIsZFe+yuDkfzM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dm4KN4izsID68V739IeMXBf7k3h3xE53KJ0is4a5QS9cHPPCwbvRyLC3LTnwrpXUt
         +m7YziUkMBHfWlTHWd3QKPVM/xnrXa9qK4Cxkq6bf3V9tXe3T75trM5lPuNS0wihKq
         +7Jiz2mgyJOsNUKWwcQlFqb4CCr3NjI1gL3Q2MFTCGDkznAjpoihitH/pvhDUatgza
         DHl+b/ko4GMEGEhLwv4bUu9tSx2XuJ0edQXK+NJdX/Zi6gqgocHUdaxeERdcMYcO0k
         Sn20HLmTjOdZKPifpNbV9iWNIDPKrl/usiOixPsOYLXNjAuKKWe67LeAaybi4cd4bZ
         5k/cAmSGXOLCw==
Date:   Mon, 3 Jan 2022 19:33:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, saeedm@nvidia.com,
        sachinp <sachinp@linux.vnet.ibm.com>
Subject: Re: [5.16.0-rc7] net-next build broken on powerpc
Message-ID: <20220103193346.048331ac@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <7c03768d-d948-c935-a7ab-b1f963ac7eed@linux.vnet.ibm.com>
References: <7c03768d-d948-c935-a7ab-b1f963ac7eed@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jan 2022 19:10:01 +0530 Abdul Haleem wrote:
> Greeting's
>=20
> Today's netdev/net-next kernel 5.16.0-rc7 failed to build on my powerpc b=
ox with below error
>=20
>  =C2=A0 CC [M]=C2=A0 drivers/net/ethernet/mellanox/mlx5/core/en_main.o
> In file included from ./arch/powerpc/include/generated/asm/rwonce.h:1,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 from ./include/linux/compiler.h:266,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 from ./arch/powerpc/include/asm/cmpxchg.h:6,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 from ./arch/powerpc/include/asm/atomic.h:11,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 from ./include/linux/atomic.h:7,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 from ./include/linux/refcount.h:95,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 from ./include/net/act_api.h:9,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 from ./include/net/tc_act/tc_gact.h:5,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 from drivers/net/ethernet/mellanox/mlx5/core/en_ma=
in.c:33:
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c: In function =E2=80=98m=
lx5e_alloc_rq=E2=80=99:
> ./include/linux/rcupdate.h:412:36: error: dereferencing pointer to incomp=
lete type =E2=80=98struct bpf_prog=E2=80=99
>  =C2=A0#define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~~~
> ./include/asm-generic/rwonce.h:55:33: note: in definition of macro =E2=80=
=98__WRITE_ONCE=E2=80=99
>  =C2=A0 *(volatile typeof(x) *)&(x) =3D (val);=C2=A0=C2=A0=C2=A0 \
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~~
> ./include/linux/rcupdate.h:854:3: note: in expansion of macro =E2=80=98WR=
ITE_ONCE=E2=80=99
>  =C2=A0=C2=A0 WRITE_ONCE(p, RCU_INITIALIZER(v)); \
>  =C2=A0=C2=A0 ^~~~~~~~~~
> ./include/linux/rcupdate.h:854:17: note: in expansion of macro =E2=80=98R=
CU_INITIALIZER=E2=80=99
>  =C2=A0=C2=A0 WRITE_ONCE(p, RCU_INITIALIZER(v)); \
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ^~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c:569:2: note: in expansi=
on of macro =E2=80=98RCU_INIT_POINTER=E2=80=99
>  =C2=A0 RCU_INIT_POINTER(rq->xdp_prog, params->xdp_prog);
>  =C2=A0 ^~~~~~~~~~~~~~~~
> make[5]: *** [scripts/Makefile.build:287: drivers/net/ethernet/mellanox/m=
lx5/core/en_main.o] Error 1
>=20

I can repro a powerpc build failure with ice, but I don't see anything
wrong in mlx5 in an allmodconfig. The config you attached is invalid:

.config:709:warning: symbol value 'm' invalid for HOTPLUG_PCI_SHPC
.config:892:warning: symbol value 'm' invalid for NF_CT_PROTO_GRE
.config:919:warning: symbol value 'm' invalid for NF_NAT_REDIRECT
.config:922:warning: symbol value 'm' invalid for NF_TABLES_INET
.config:1099:warning: symbol value 'm' invalid for NF_TABLES_IPV4
.config:1104:warning: symbol value 'm' invalid for NF_TABLES_ARP
.config:1146:warning: symbol value 'm' invalid for NF_TABLES_IPV6
.config:1537:warning: symbol value 'm' invalid for NET_DEVLINK
.config:2721:warning: symbol value 'm' invalid for ISDN_CAPI
.config:3066:warning: symbol value 'm' invalid for HW_RANDOM_TPM
.config:3589:warning: symbol value 'm' invalid for LIRC
.config:5356:warning: symbol value 'm' invalid for FS_ENCRYPTION

I'll send a fix based on your error messages, it does look like
en_main.c should include filter.h.
