Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C1BED056
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 20:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfKBTJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 15:09:22 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41637 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfKBTJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 15:09:22 -0400
Received: by mail-qt1-f194.google.com with SMTP id o3so17733235qtj.8;
        Sat, 02 Nov 2019 12:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ik7pnpm5nkHdWTpbP2HcYzUbAmJ4gt8ds7mxPNBfj2g=;
        b=huRz+3kc+635yRg2VBPj+9xx97HIER9/dZeWt105UIBW7k7QLyDb1RowXiEKBIHAot
         QW88eWqFLa5gODmyr1c2VXSB57Ql0wW6d3zViGeCS/UDEQrMJJoeEk6UNiqOQ3GlpvUd
         cIgAj17PjPm+q0pXOp8BSgeZSHOq6v99m5nWiJwpmd5s1UPDeM1OP1M3/hHQXsn8DwBy
         ooLzNgefrok4teg++hIazp/xMN8/D9tpqmknH5OegWBu+IWMSF8YGAeD6mryF/r6mbdV
         E5zmMEdr6inSseQdl0OmlNwoE+LGcv/SjlGwJ4haxkDeIbhqUuQawfsFCglwm1yhv14r
         a7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ik7pnpm5nkHdWTpbP2HcYzUbAmJ4gt8ds7mxPNBfj2g=;
        b=A2cJbo+6Xz7FPKtND0SvTJPrwTQc/OiMKAZnNCmV9lC/mLdbti3bcYu7sP4/Q1k8GA
         60/C6vKpJ4br5KDIiQaKBtPrTS/T4yVFY3zhfIxVpuamTvW9ZdJhJ/h0hUUkcP6hhrGB
         YEBeQOkG0vBRu7UWQUQMpM6W2/iZJl7CbKrA/gsUqxbwVHzzaS8yVmPL6CzV2+DuEcp4
         9VKslCaZ9EW4qfBfuDENut8lVTrli3ezBDMeMXi4tGg//wHTXMenQhpD026fe2wC9sOi
         mMGjHd+ZP18/DjnT52vortb3NEbhDsdXLZezoDrjcimy24M7Roc36lrfSZ31h92YheGB
         34pw==
X-Gm-Message-State: APjAAAVSzc2UgtDUvIHmf14Z2Il5zPXXYRm3Dci2KwabQoqELIhJxvWE
        Po2FL8hZ3F9hRayA6EvPY4c718qO2eY1eSf3PFwXfg==
X-Google-Smtp-Source: APXvYqyYGUJ/RTFf4o9GIINA8q/Yufla00xUzacAT2wrIS/vsetiFVDmbmq0lreUl4hHsYBDojYWcWr2/ZxDN8XWwSg=
X-Received: by 2002:a05:6214:90f:: with SMTP id dj15mr14236665qvb.224.1572721761089;
 Sat, 02 Nov 2019 12:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <157269297658.394725.10672376245672095901.stgit@toke.dk>
In-Reply-To: <157269297658.394725.10672376245672095901.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 2 Nov 2019 12:09:09 -0700
Message-ID: <CAEf4BzYXhoaiH5x9YZ99ABUMngsjBVRAYJBm+oMbnAHnpn-18g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 0/5] libbpf: Support automatic pinning of maps
 using 'pinning' BTF attribute
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 2, 2019 at 4:09 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> This series adds support to libbpf for reading 'pinning' settings from BT=
F-based
> map definitions. It introduces a new open option which can set the pinnin=
g path;
> if no path is set, /sys/fs/bpf is used as the default. Callers can custom=
ise the
> pinning between open and load by setting the pin path per map, and still =
get the
> automatic reuse feature.
>
> The semantics of the pinning is similar to the iproute2 "PIN_GLOBAL" sett=
ing,
> and the eventual goal is to move the iproute2 implementation to be based =
on
> libbpf and the functions introduced in this series.
>
> Changelog:
>
> v6:
>   - Fix leak of struct bpf_object in selftest
>   - Make struct bpf_map arg const in bpf_map__is_pinned() and bpf_map__ge=
t_pin_path()
>
> v5:
>   - Don't pin maps with pinning set, but with a value of LIBBPF_PIN_NONE
>   - Add a few more selftests:
>     - Should not pin map with pinning set, but value LIBBPF_PIN_NONE
>     - Should fail to load a map with an invalid pinning value
>     - Should fail to re-use maps with parameter mismatch
>   - Alphabetise libbpf.map
>   - Whitespace and typo fixes
>
> v4:
>   - Don't check key_type_id and value_type_id when checking for map reuse
>     compatibility.
>   - Move building of map->pin_path into init_user_btf_map()
>   - Get rid of 'pinning' attribute in struct bpf_map
>   - Make sure we also create parent directory on auto-pin (new patch 3).
>   - Abort the selftest on error instead of attempting to continue.
>   - Support unpinning all pinned maps with bpf_object__unpin_maps(obj, NU=
LL)
>   - Support pinning at map->pin_path with bpf_object__pin_maps(obj, NULL)
>   - Make re-pinning a map at the same path a noop
>   - Rename the open option to pin_root_path
>   - Add a bunch more self-tests for pin_maps(NULL) and unpin_maps(NULL)
>   - Fix a couple of smaller nits
>
> v3:
>   - Drop bpf_object__pin_maps_opts() and just use an open option to custo=
mise
>     the pin path; also don't touch bpf_object__{un,}pin_maps()
>   - Integrate pinning and reuse into bpf_object__create_maps() instead of=
 having
>     multiple loops though the map structure
>   - Make errors in map reuse and pinning fatal to the load procedure
>   - Add selftest to exercise pinning feature
>   - Rebase series to latest bpf-next
>
> v2:
>   - Drop patch that adds mounting of bpffs
>   - Only support a single value of the pinning attribute
>   - Add patch to fixup error handling in reuse_fd()
>   - Implement the full automatic pinning and map reuse logic on load
>
> ---
>
> Toke H=C3=B8iland-J=C3=B8rgensen (5):
>       libbpf: Fix error handling in bpf_map__reuse_fd()
>       libbpf: Store map pin path and status in struct bpf_map
>       libbpf: Move directory creation into _pin() functions
>       libbpf: Add auto-pinning of maps when loading BPF objects
>       selftests: Add tests for automatic map pinning
>
>

For the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf_helpers.h                        |    6
>  tools/lib/bpf/libbpf.c                             |  385 ++++++++++++++=
++----
>  tools/lib/bpf/libbpf.h                             |   21 +
>  tools/lib/bpf/libbpf.map                           |    3
>  tools/testing/selftests/bpf/prog_tests/pinning.c   |  210 +++++++++++
>  tools/testing/selftests/bpf/progs/test_pinning.c   |   31 ++
>  .../selftests/bpf/progs/test_pinning_invalid.c     |   16 +
>  7 files changed, 591 insertions(+), 81 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/pinning.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_pinning.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_pinning_invali=
d.c
>
