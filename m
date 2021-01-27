Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C8830675D
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhA0W5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 17:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbhA0Wz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 17:55:29 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E116C061574;
        Wed, 27 Jan 2021 14:24:55 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id g7so2329707iln.2;
        Wed, 27 Jan 2021 14:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=6AZ5gVqyxhNX7n24kIVcA9NdK4AhKXH76fFkmKApVaA=;
        b=f/hhdkJRoQShMo7uvCBvZn5GZGB4wsKALxsIa9iyVY6xbydJFVZZSQaoNHBIwXknqz
         GizvAV0u4AIKk13ia8lepC7LdI9zmD332syZVMq93GkHnBmU4ItSu+NAvNK830Qbvvi3
         1oqYqKw+G3ccaTrTt7Pv/KbHHsBiWtYWtxUrGfyv1gmMHZU/gGnmY/hrt/YCRYCEVYxy
         4DfuA/yBD+TyjDcQ+NzsGfP7AXUE4u++BY+8LpGE8PAkF3q/deQLz+W1EBeVlhPt3E6S
         U6XkVnmB3qGftVmaF+zzs8PgaSxgSDm7X1s+5rVmbJprc1zcOLthyj6zBilGLp1W415f
         ygwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=6AZ5gVqyxhNX7n24kIVcA9NdK4AhKXH76fFkmKApVaA=;
        b=j5uPoysu6G8X+BscPZ5MwM5YShtMlUrVRi5DMSqK5E/sDaWq7vYvkP0q5cQ0hN66c7
         kvCMcsWTglTtV4l6gLnPstSwdeCeiBjuYHki2tsY64e9aZxF957koiYarChFVBwi2htf
         jfdNH/GUqBGv6mrntViXuCpNAFn/kURsu2JtB/PNsoi3cyqaPsMyTl97Ka8v9BpPq1J9
         Hey1zBhIZW9jftDXxZhyLHwpaArVLug4oS+MPhkwrHQHd1NggJ9ezOdoB1IbFZ3u92sb
         MUF6f+xpaIIYE0EYM2jPvOoyqjUEuks1e2GHrnA2S1474Y7sMaJQD/QyM0NVhb5GBEe3
         wIVA==
X-Gm-Message-State: AOAM532yHMfRJ+Xa8mjmqHEhoy7DBFKJq0Ct60qPrKcIB7x/6W1RAwgo
        cFxOLuj21Wdy/sviyvTg0WA=
X-Google-Smtp-Source: ABdhPJyMbkdKC7UCs19QCIVhxLY5snSraGGgPcyRLe8fzkoo7Vu25V+9qT7c6HgBvEeRSJStpcNECA==
X-Received: by 2002:a05:6e02:1545:: with SMTP id j5mr10511543ilu.296.1611786295045;
        Wed, 27 Jan 2021 14:24:55 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id f13sm1584980iog.18.2021.01.27.14.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 14:24:54 -0800 (PST)
Date:   Wed, 27 Jan 2021 14:24:47 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <6011e82feb2_a0fd920881@john-XPS-13-9370.notmuch>
In-Reply-To: <20210125124516.3098129-6-liuhangbin@gmail.com>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210125124516.3098129-6-liuhangbin@gmail.com>
Subject: RE: [PATCHv17 bpf-next 5/6] selftests/bpf: Add verifier tests for bpf
 arg ARG_CONST_MAP_PTR_OR_NULL
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> Use helper bpf_redirect_map() and bpf_redirect_map_multi() to test bpf
> arg ARG_CONST_MAP_PTR and ARG_CONST_MAP_PTR_OR_NULL. Make sure the
> map arg could be verified correctly when it is NULL or valid map
> pointer.
> =

> Add devmap and devmap_hash in struct bpf_test due to bpf_redirect_{map,=

> map_multi} limit.
> =

> Test result:
>  ]# ./test_verifier 713 716
>  #713/p ARG_CONST_MAP_PTR: null pointer OK
>  #714/p ARG_CONST_MAP_PTR: valid map pointer OK
>  #715/p ARG_CONST_MAP_PTR_OR_NULL: null pointer for ex_map OK
>  #716/p ARG_CONST_MAP_PTR_OR_NULL: valid map pointer for ex_map OK
>  Summary: 4 PASSED, 0 SKIPPED, 0 FAILED
> =

> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/bpf/test_verifier.c   | 22 +++++-
>  .../testing/selftests/bpf/verifier/map_ptr.c  | 70 +++++++++++++++++++=

>  2 files changed, 91 insertions(+), 1 deletion(-)
> =


[...]

> +{
> +	"ARG_CONST_MAP_PTR_OR_NULL: null pointer for ex_map",
> +	.insns =3D {
> +		BPF_MOV64_IMM(BPF_REG_1, 0),
> +		/* bpf_redirect_map_multi arg1 (in_map) */
> +		BPF_LD_MAP_FD(BPF_REG_1, 0),
> +		/* bpf_redirect_map_multi arg2 (ex_map) */
> +		BPF_MOV64_IMM(BPF_REG_2, 0),
> +		/* bpf_redirect_map_multi arg3 (flags) */
> +		BPF_MOV64_IMM(BPF_REG_3, 0),
> +		BPF_EMIT_CALL(BPF_FUNC_redirect_map_multi),
> +		BPF_EXIT_INSN(),
> +	},
> +	.fixup_map_devmap =3D { 1 },
> +	.result =3D ACCEPT,
> +	.prog_type =3D BPF_PROG_TYPE_XDP,
> +	.retval =3D 4,

Do we need one more case where this is map_or_null? In above
ex_map will be scalar tnum_const=3D0 and be exactly a null. This
will push verifier here,

  meta->map_ptr =3D register_is_null(reg) ? NULL : reg->map_ptr;

In the below case it is known to be not null.

Is it also interesting to have a case where register_is_null(reg)
check fails and reg->map_ptr is set, but may be null.

> +},
> +{
> +	"ARG_CONST_MAP_PTR_OR_NULL: valid map pointer for ex_map",
> +	.insns =3D {
> +		BPF_MOV64_IMM(BPF_REG_1, 0),
> +		/* bpf_redirect_map_multi arg1 (in_map) */
> +		BPF_LD_MAP_FD(BPF_REG_1, 0),
> +		/* bpf_redirect_map_multi arg2 (ex_map) */
> +		BPF_LD_MAP_FD(BPF_REG_2, 1),
> +		/* bpf_redirect_map_multi arg3 (flags) */
> +		BPF_MOV64_IMM(BPF_REG_3, 0),
> +		BPF_EMIT_CALL(BPF_FUNC_redirect_map_multi),
> +		BPF_EXIT_INSN(),
> +	},
> +	.fixup_map_devmap =3D { 1 },
> +	.fixup_map_devmap_hash =3D { 3 },
> +	.result =3D ACCEPT,
> +	.prog_type =3D BPF_PROG_TYPE_XDP,
> +	.retval =3D 4,
> +},
> -- =

> 2.26.2
> =



