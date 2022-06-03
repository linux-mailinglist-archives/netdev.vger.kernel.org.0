Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3C853D373
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 00:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344689AbiFCWDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 18:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiFCWDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 18:03:35 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13842EA06;
        Fri,  3 Jun 2022 15:03:33 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id a2so8494927lfg.5;
        Fri, 03 Jun 2022 15:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a1myc0lWVIRaBDDSeIG8FJr0r1IURo36xvXnX0UOjLg=;
        b=MtKblfTyGYADGkfglOzDTK7c9UOQgDfAObBS7PiDzB+ZWeCwOEc5l1AXTtx6BoFaGl
         T+ULggabm9w080WxyI6g9PcHoYEImSFnK/gSkUKUMYEDrVm9AjtdVuNVn3lZcKmxl2cQ
         y1fqnOe9iGDaDhl9F+V1ab5H5jgDCJnbaWKUaQeCpFYD1Gj7RWr98v0gjBB6mwAl2UfN
         +gtaasxGFBldHRWBOgqPco/cf+t/6dc/h2cGRer9TIFgdJUZJKfFMAeyz2FVuzMliGou
         0aj3AhOzzXoBXnrSaTOgh6gUlVoeZG5OjBDNQFc0sm09ZLNsf6TAOkeCpp0x1DDVpwrc
         VoLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a1myc0lWVIRaBDDSeIG8FJr0r1IURo36xvXnX0UOjLg=;
        b=aOyvVdnGnRrGRF+mjshpy3G3Fox60FxouGixqCc1UpcvK4kssMtre3dmKvcV96OyIj
         9tM3kOPo8LmG3vf1AKNf93413eA9mfrWtFHptuBEDt280FmEjn82TCQwqQIZjWMNgizM
         AH9aC1DHSMq3IB5FPNncAC+N8pvWgoF2Ffd7RFwjH5B6JhXC9vMtUrdd9Qq00XUjjYaR
         y8tCPpo6arU8+NrKXdDc/0AO1/IBWBMH//5S1iJaQoUWlVDm6exPAzBBf4WlHBOf/us5
         F7hPcx5wGpRGxj3GBwPL0rALdyh/5jIpkFXpbdfmqm+k+lCqTPIAzK57KgVOHpYpgVqD
         mFwg==
X-Gm-Message-State: AOAM530n0GqCKrzG4NXhTgptEssKV/2oPbKABenQZU0SZTwKRpVUW6XJ
        JFTFrlCDLhkNAOimv/w7imsIsqPl1nu6Y3o0qWk=
X-Google-Smtp-Source: ABdhPJwiQyqMY5Xc8IsTPi8IbW6Vqgt3//gTGqFpKJUV93+QJDn2qNIMN60999JWGQZKDNJ1SrosRseCUIB6klciVkc=
X-Received: by 2002:a05:6512:1398:b0:448:bda0:99f2 with SMTP id
 p24-20020a056512139800b00448bda099f2mr54822718lfa.681.1654293812032; Fri, 03
 Jun 2022 15:03:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220603154028.24904-1-toke@redhat.com> <20220603154028.24904-2-toke@redhat.com>
In-Reply-To: <20220603154028.24904-2-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 15:03:20 -0700
Message-ID: <CAEf4Bzak82RbCYethEN7u05UKkmY=DqCiX=oHAFnHocb4fEG6w@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: Add selftest for calling global
 functions from freplace
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 3, 2022 at 8:42 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Add a selftest that calls a global function with a context object paramet=
er
> from an freplace function to check that the program context type is
> correctly converted to the freplace target when fetching the context type
> from the kernel BTF.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 13 ++++++++++
>  .../bpf/progs/freplace_global_func.c          | 24 +++++++++++++++++++
>  2 files changed, 37 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/freplace_global_fun=
c.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/too=
ls/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> index d9aad15e0d24..6e86a1d92e97 100644
> --- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> @@ -395,6 +395,17 @@ static void test_func_map_prog_compatibility(void)
>                                      "./test_attach_probe.o");
>  }
>
> +static void test_func_replace_global_func(void)
> +{
> +       const char *prog_name[] =3D {
> +               "freplace/test_pkt_access",
> +       };

empty line between variables and statements

> +       test_fexit_bpf2bpf_common("./freplace_global_func.o",
> +                                 "./test_pkt_access.o",
> +                                 ARRAY_SIZE(prog_name),
> +                                 prog_name, false, NULL);
> +}
> +
>  /* NOTE: affect other tests, must run in serial mode */
>  void serial_test_fexit_bpf2bpf(void)
>  {
> @@ -416,4 +427,6 @@ void serial_test_fexit_bpf2bpf(void)
>                 test_func_replace_multi();
>         if (test__start_subtest("fmod_ret_freplace"))
>                 test_fmod_ret_freplace();
> +       if (test__start_subtest("func_replace_global_func"))
> +               test_func_replace_global_func();
>  }
> diff --git a/tools/testing/selftests/bpf/progs/freplace_global_func.c b/t=
ools/testing/selftests/bpf/progs/freplace_global_func.c
> new file mode 100644
> index 000000000000..d9f8276229cc
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/freplace_global_func.c
> @@ -0,0 +1,24 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019 Facebook */
> +#include <linux/stddef.h>
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +#include <bpf/bpf_tracing.h>
> +
> +__attribute__ ((noinline))

__noinline

> +int test_ctx_global_func(struct __sk_buff *skb)
> +{
> +       volatile int retval =3D 1;
> +       return retval;

just curious, why volatile instead of direct `return 1;`? Also, empty
line between variable and return.

> +}
> +
> +__u64 test_pkt_access_global_func =3D 0;

nit: it's a variable, please put it at the top before functions, or at
the very least add empty line between it and SEC()

> +SEC("freplace/test_pkt_access")
> +int new_test_pkt_access(struct __sk_buff *skb)
> +{
> +       test_pkt_access_global_func =3D test_ctx_global_func(skb);
> +       return -1;
> +}
> +
> +char _license[] SEC("license") =3D "GPL";
> --
> 2.36.1
>
