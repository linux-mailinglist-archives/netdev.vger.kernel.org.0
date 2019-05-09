Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89321893C
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 13:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfEILs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 07:48:28 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46689 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfEILs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 07:48:27 -0400
Received: by mail-qk1-f194.google.com with SMTP id a132so1134265qkb.13
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 04:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HLi5v2fUqq6HS4cjBMmojehwWDeRlzvcfwL2kRg/gr0=;
        b=UKrdHzHwuPYA2bpGaDBxJQnnqhjtP/ZoIhIs9aPIsp8ghw7PA/Mol/Umzjm5DQTR2I
         3J+RsgdT10fyiaOeIk0uzlkW+btvUHbQQt1fMAKgQtWTD/DeIQff1Z1FlhwJtDHIwPKe
         2HcwaZPO3h3aBrUVvuM9G0evxMKs1gGWYQiz6G6EZBeVaVibouCOgT+ZOYPfZjGonb/a
         ig9p62/gxDdTYnbdP4PXvBdN7pKe7EDePyV6xWivqAxbcWA3hGOcFWWtGBiwPU2SEoDi
         VlLp4F9Bb5IEA9K3Ydhw40Ov7IaocqMfy21N1KCMQUEThkiTwgkrApp1lxQfxqC9YN97
         wW3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HLi5v2fUqq6HS4cjBMmojehwWDeRlzvcfwL2kRg/gr0=;
        b=GUOR1nWvC3vIRsWUWzfH9xtKCka700tHDbG3n/EAhPsQctl9c9+Q0uJyM0ltkiKgOX
         5t8yOXVsiqYO/tg8X/qXQBzJdwgZoaacKBma35N6UrpE4Q+kQfpz803AtgmQ4D6ejdHT
         WxdU15oIWeI+vDUAol5v6oxJp7lpYUEgfy3Yky56rTnZWFEE8DNooYVcWUSVo8DOp/Ls
         g+R7dtnc3Erm4dL2oZ6hP4rGReF2AmDPD2VTQMcHZThiM9IWU6UdWiN4uvwOkYsyDDU/
         iHKUS1WRUPE6LTnQz0ELCHw3XKw4upcUjOV0YdpKypKo03TDUaulk7bWuv36me3NdsvU
         s0nA==
X-Gm-Message-State: APjAAAU7nNDUqZPe7e20LYPa6OqKuGx/oB6D1lXA4cyG5Bb8A/BjaaGl
        Eao1rm+F2RjvacQsz09sdVsJBGBkoHN6QO2bTOGNwceU
X-Google-Smtp-Source: APXvYqzviPNUZvTGhyc56S4ldoFMc1q3ysHhnRpuCJDLsbXOaB7DsJkqgNXuvQtZETh+YNF32p2kmd8v8nmod2EWS7s=
X-Received: by 2002:a37:5f41:: with SMTP id t62mr2886494qkb.141.1557402506769;
 Thu, 09 May 2019 04:48:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190508225016.2375828-1-jonathan.lemon@gmail.com>
In-Reply-To: <20190508225016.2375828-1-jonathan.lemon@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 9 May 2019 13:48:13 +0200
Message-ID: <CAJ+HfNj4NgGQkJOEivuxuohA_+Fa98yD8EmY4acHQqymdUBA4g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an xskmap
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 May 2019 at 01:07, Jonathan Lemon <jonathan.lemon@gmail.com> wrot=
e:
>
> Currently, the AF_XDP code uses a separate map in order to
> determine if an xsk is bound to a queue.  Instead of doing this,
> have bpf_map_lookup_elem() return a boolean indicating whether
> there is a valid entry at the map index.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  kernel/bpf/verifier.c                             |  6 +++++-
>  kernel/bpf/xskmap.c                               |  2 +-
>  .../selftests/bpf/verifier/prevent_map_lookup.c   | 15 ---------------
>  3 files changed, 6 insertions(+), 17 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 7b05e8938d5c..a8b8ff9ecd90 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2761,10 +2761,14 @@ static int check_map_func_compatibility(struct bp=
f_verifier_env *env,
>          * appear.
>          */
>         case BPF_MAP_TYPE_CPUMAP:
> -       case BPF_MAP_TYPE_XSKMAP:
>                 if (func_id !=3D BPF_FUNC_redirect_map)
>                         goto error;
>                 break;
> +       case BPF_MAP_TYPE_XSKMAP:
> +               if (func_id !=3D BPF_FUNC_redirect_map &&
> +                   func_id !=3D BPF_FUNC_map_lookup_elem)
> +                       goto error;
> +               break;
>         case BPF_MAP_TYPE_ARRAY_OF_MAPS:
>         case BPF_MAP_TYPE_HASH_OF_MAPS:
>                 if (func_id !=3D BPF_FUNC_map_lookup_elem)
> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> index 686d244e798d..f6e49237979c 100644
> --- a/kernel/bpf/xskmap.c
> +++ b/kernel/bpf/xskmap.c
> @@ -154,7 +154,7 @@ void __xsk_map_flush(struct bpf_map *map)
>
>  static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
>  {
> -       return ERR_PTR(-EOPNOTSUPP);
> +       return !!__xsk_map_lookup_elem(map, *(u32 *)key);
>  }
>

Hmm, enabling lookups has some concerns, so we took the easy path;
simply disallowing it. Lookups (and returning a socket/fd) from
userspace might be expensive; allocating a new fd, and such, and on
the BPF side there's no XDP socket object (yet!).

Your patch makes the lookup return something else than a fd or socket.
The broader question is, inserting a socket fd and getting back a bool
-- is that ok from a semantic perspective? It's a kind of weird map.
Are there any other maps that behave in this way? It certainly makes
the XDP code easier, and you get somewhat better introspection into
the XSKMAP.

(bpf-next is closed, btw... :-))



Bj=C3=B6rn

>  static int xsk_map_update_elem(struct bpf_map *map, void *key, void *val=
ue,
> diff --git a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c b/=
tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
> index bbdba990fefb..da7a4b37cb98 100644
> --- a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
> +++ b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
> @@ -28,21 +28,6 @@
>         .errstr =3D "cannot pass map_type 18 into func bpf_map_lookup_ele=
m",
>         .prog_type =3D BPF_PROG_TYPE_SOCK_OPS,
>  },
> -{
> -       "prevent map lookup in xskmap",
> -       .insns =3D {
> -       BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
> -       BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> -       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> -       BPF_LD_MAP_FD(BPF_REG_1, 0),
> -       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_ele=
m),
> -       BPF_EXIT_INSN(),
> -       },
> -       .fixup_map_xskmap =3D { 3 },
> -       .result =3D REJECT,
> -       .errstr =3D "cannot pass map_type 17 into func bpf_map_lookup_ele=
m",
> -       .prog_type =3D BPF_PROG_TYPE_XDP,
> -},
>  {
>         "prevent map lookup in stack trace",
>         .insns =3D {
> --
> 2.17.1
>
