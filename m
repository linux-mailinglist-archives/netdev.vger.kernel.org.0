Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAC52979E8
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 02:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756169AbgJXAVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 20:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756159AbgJXAVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 20:21:32 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED5CC0613CE;
        Fri, 23 Oct 2020 17:21:31 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id s89so2609179ybi.12;
        Fri, 23 Oct 2020 17:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0Jsu8JegTWNMP2ZCcQXmxGDaWEXGegtl9u5H7TqMuOI=;
        b=WRaMRdHRkLCifvvDL94bJ+qqob/LH/6Hj4/ipG8RPocz0M/45y1tbPAgohDTo6s5OQ
         lnxATvgwDxu41IXlL7uhFCrR0TWtLkWiitSR4heoWpAue+fBwGKMpMw8SiEc7FMJ94tb
         l6xKXNpBjZ5QI4WHUuo8w2rWyjG4x3oul7IFbFPVMwv3h7+uMrp7+HxK2kazY88Jy88x
         GA6WB91JOoECccFwVgL0RxAPtFt/fT1y1wY05E8R1gvFNGBSbBUMRMKJIBwrfm9jM5ch
         UlYFcZ4lcUFugYWL1O48tdXH1pyOx1BB7Ib4LkMAccwQehltAr86K72uRs7H9AHfrrcA
         MbVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0Jsu8JegTWNMP2ZCcQXmxGDaWEXGegtl9u5H7TqMuOI=;
        b=XjaLWM1XgWNiXg6EkapBQzX+kk9FBsbS2drzvVgFs1tL5KsCcVamjc8GZQ72vWvp/f
         IoQyEVs/oUdlXp5AbsWBglMN1bfR838tdzok5ShnNTcIiE+JVoyoulcOU3q7erGTG4n6
         Yv3RgJxZbhQlYKuT9ExpolfuigLpm1QcPt9oksj73+VnfkQtYoHaSpT1qfb/Nr2Gf9Vt
         7psu6V0Xj+VcpiUPjsMv928MP5NtK/4ZS2Q/saMbfVOlY0gSDnrFJkTwdx4EiVZ39q7w
         UQrVW2KheYOqRIaCOlzFGd1Dcz5zaGdyye3Sf4TASJ/fVox1r/ll7bAteY9YZ1OALlg7
         OqzA==
X-Gm-Message-State: AOAM532MYGLmUxpih/Z6LSPz8Fb0EYobR9tDSDRWhHJBE6zMS7dUjKO+
        SGJjOVNh/k6moNVXwJDv3XD5PH92bBJsICpveqyUT9Y1UL4=
X-Google-Smtp-Source: ABdhPJwfnh+0jFXkwRSt+k7l4xItkp58TaqfczDrYYubsomnG7+fVtyewlcs8m/O1T/YryT9H2uFFgejAdTGnBWheyw=
X-Received: by 2002:a25:c001:: with SMTP id c1mr6702705ybf.27.1603498891057;
 Fri, 23 Oct 2020 17:21:31 -0700 (PDT)
MIME-Version: 1.0
References: <20201023033855.3894509-1-haliu@redhat.com> <20201023033855.3894509-4-haliu@redhat.com>
In-Reply-To: <20201023033855.3894509-4-haliu@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Oct 2020 17:21:20 -0700
Message-ID: <CAEf4BzbPW8itEQjR=DsjJbtoUFWjiC1WC7F=9x_u4ddSAkZPhg@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 3/5] lib: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 8:39 PM Hangbin Liu <haliu@redhat.com> wrote:
>
> This patch converts iproute2 to use libbpf for loading and attaching
> BPF programs when it is available, which is started by Toke's
> implementation[1]. With libbpf iproute2 could correctly process BTF
> information and support the new-style BTF-defined maps, while keeping
> compatibility with the old internal map definition syntax.
>
> The old iproute2 bpf code is kept and will be used if no suitable libbpf
> is available. When using libbpf, wrapper code in bpf_legacy.c ensures tha=
t
> iproute2 will still understand the old map definition format, including
> populating map-in-map and tail call maps before load.
>
> In bpf_libbpf.c, we init iproute2 ctx and elf info first to check the
> legacy bytes. When handling the legacy maps, for map-in-maps, we create
> them manually and re-use the fd as they are associated with id/inner_id.
> For pin maps, we only set the pin path and let libbp load to handle it.
> For tail calls, we find it first and update the element after prog load.

I never implemented tail call map initialization using the same
approach as declarative map-in-map support in libbpf, because no one
asked and/or showed a use case. But all the pieces are there, and if
there's interest, we should probably support that in libbpf as well.

>
> Other maps/progs will be loaded by libbpf directly.
>
> Note: ip/ipvrf.c is not convert to use libbpf as it only encodes a few
> instructions and load directly.
>
> [1] https://lore.kernel.org/bpf/20190820114706.18546-1-toke@redhat.com/
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Hangbin Liu <haliu@redhat.com>
> ---
>  include/bpf_util.h |  11 ++
>  lib/Makefile       |   4 +
>  lib/bpf_legacy.c   | 178 ++++++++++++++++++++++++
>  lib/bpf_libbpf.c   | 338 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 531 insertions(+)
>  create mode 100644 lib/bpf_libbpf.c
>

[...]

> +
> +static int load_bpf_object(struct bpf_cfg_in *cfg)
> +{
> +       struct bpf_program *p, *prog =3D NULL;
> +       struct bpf_object *obj;
> +       char root_path[PATH_MAX];
> +       struct bpf_map *map;
> +       int prog_fd, ret =3D 0;
> +
> +       ret =3D iproute2_get_root_path(root_path, PATH_MAX);
> +       if (ret)
> +               return ret;
> +
> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, open_opts,
> +                       .relaxed_maps =3D true,
> +                       .pin_root_path =3D root_path,
> +       );
> +
> +       obj =3D bpf_object__open_file(cfg->object, &open_opts);
> +       if (IS_ERR_OR_NULL(obj))

libbpf defines libbpf_get_error() to check that the returned pointer
is not encoding error, you shouldn't need to define your IS_ERR
macros.

> +               return -ENOENT;
> +

[...]
