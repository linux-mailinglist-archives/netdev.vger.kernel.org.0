Return-Path: <netdev+bounces-5477-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A2987118C2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 23:06:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 619652816A2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D6A2415F;
	Thu, 25 May 2023 21:06:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40451FC16;
	Thu, 25 May 2023 21:06:11 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6FF195;
	Thu, 25 May 2023 14:06:09 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96f7377c86aso200324866b.1;
        Thu, 25 May 2023 14:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685048768; x=1687640768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GMZ9C6ORzYk7XDZjlM2KmTPndlXbai+95ZyPDyvJIN8=;
        b=Yj3p0F4LD5wccerjU74CUdBg/NvEeJ5eRjpkgJe2qPWlwghc00iPYdTMTlcwWX9SaT
         fj83vCf7efPUs7uaJkbHX/LkAN8uCP+p/BQHa2TiE+XwaJUUttCMgH4H+f12xN2vExeI
         VrJ5XXk4sH1djkWRslrfa1rceNAYoVX3a1J0pTgv2P7DQGZjIw2sL1QlU1MpC6+xIyoO
         YyfZrhUlJ7AQ+45bIM+2XPNkhd7MLxUvd17a8EdkCYqHiLN+Iw6UEyJigJ+PMK/AuuT6
         AC4PaJEGRSlWn+IYxdBonPemSZ8yl5fdUx0PMcnj+daRyprTsIJi9cf4s3aTsiMM4fth
         Sy8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685048768; x=1687640768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GMZ9C6ORzYk7XDZjlM2KmTPndlXbai+95ZyPDyvJIN8=;
        b=WHMyfHRHCdl9uYn2mpGXYPnjjbFw11eaKkZ4j0jp/rf3geecbJcl+X6vxkaj+BfUKD
         aJWqRZcSyo92IEdxpBYcEt5DJAGjqHn9hEK/68921aStcd3hzwBwpzbw72X1xfQZ7k0p
         jg2f6NiBA8b3vOaXku9nyvp3uN75ikFnMlWzlbkJIj1Er8xzf2jgykGdHSZAJM+7gG1e
         hJTdgG+Psh5fO6nXnrRZRJ423y43hStkXl4+bIqpp+yriwj4oOdW1hjvsuep634dfre1
         NhyZ6BEXAe80v0Vzxq6MWkIGo+3Un1R3vwivpDxaLKu0Wjt1LQS1CQmcOH8dL4YiIixS
         5RQw==
X-Gm-Message-State: AC+VfDz9m4ZzFILFFFM421KwYJqMwXSGHH3Qy4xuWo3ksSb/zo+0U7vY
	pq6gOsE3CK+N5vMn64P+fFVUxQfckhUPfDtemkU=
X-Google-Smtp-Source: ACHHUZ6tg6hLpuFmSvTUnowWR4fD9nxwZ8KxG8/sUkzP1cEMFSVaI5oEKvd0joRXwlGUCedQZnUT3Ef/Xu2Z4YZKnSw=
X-Received: by 2002:a17:907:9289:b0:973:8198:bbfb with SMTP id
 bw9-20020a170907928900b009738198bbfbmr58388ejc.31.1685048767687; Thu, 25 May
 2023 14:06:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230525110100.8212-1-fw@strlen.de> <20230525110100.8212-3-fw@strlen.de>
In-Reply-To: <20230525110100.8212-3-fw@strlen.de>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 25 May 2023 14:05:55 -0700
Message-ID: <CAEf4Bza+4GMiP-bOGq5WvZGv2hbVNJqhc2bxgpWsbaRXak0WSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Add bpf_program__attach_netfilter_opts
 helper test
To: Florian Westphal <fw@strlen.de>
Cc: bpf@vger.kernel.org, ast@kernel.org, netdev@vger.kernel.org, dxu@dxuuu.xyz, 
	qde@naccy.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=ANY_BOUNCE_MESSAGE,BAYES_00,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	VBOUNCE_MESSAGE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 4:01=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Call bpf_program__attach_netfilter_opts() with different
> protocol/hook/priority combinations.
>
> Test fails if supposedly-illegal attachments work
> (e.g., bogus protocol family, illegal priority and so on)
> or if a should-work attachment fails.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  .../bpf/prog_tests/netfilter_basic.c          | 87 +++++++++++++++++++
>  .../bpf/progs/test_netfilter_link_attach.c    | 14 +++
>  2 files changed, 101 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/netfilter_basi=
c.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_netfilter_link=
_attach.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/netfilter_basic.c b/t=
ools/testing/selftests/bpf/prog_tests/netfilter_basic.c
> new file mode 100644
> index 000000000000..a64b5feaaca4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/netfilter_basic.c
> @@ -0,0 +1,87 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#include <netinet/in.h>
> +#include <linux/netfilter.h>
> +
> +#include "test_progs.h"
> +#include "test_netfilter_link_attach.skel.h"
> +
> +struct nf_hook_options {
> +       __u32 pf;
> +       __u32 hooknum;
> +       __s32 priority;
> +       __u32 flags;
> +
> +       bool expect_success;
> +};
> +
> +struct nf_hook_options nf_hook_attach_tests[] =3D {
> +       {  },
> +       { .pf =3D NFPROTO_NUMPROTO, },
> +       { .pf =3D NFPROTO_IPV4, .hooknum =3D 42, },
> +       { .pf =3D NFPROTO_IPV4, .priority =3D INT_MIN },
> +       { .pf =3D NFPROTO_IPV4, .priority =3D INT_MAX },
> +       { .pf =3D NFPROTO_IPV4, .flags =3D UINT_MAX },
> +
> +       { .pf =3D NFPROTO_INET, .priority =3D 1, },
> +
> +       { .pf =3D NFPROTO_IPV4, .priority =3D -10000, .expect_success =3D=
 true },
> +       { .pf =3D NFPROTO_IPV6, .priority =3D 10001, .expect_success =3D =
true },
> +};
> +
> +static void __test_netfilter_link_attach(struct bpf_program *prog)
> +{
> +       LIBBPF_OPTS(bpf_netfilter_opts, opts);
> +       int i;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(nf_hook_attach_tests); i++) {
> +               struct bpf_link *link;
> +
> +#define X(opts, m, i)  opts.m =3D nf_hook_attach_tests[(i)].m
> +               X(opts, pf, i);
> +               X(opts, hooknum, i);
> +               X(opts, priority, i);
> +               X(opts, flags, i);
> +#undef X
> +               link =3D bpf_program__attach_netfilter_opts(prog, &opts);
> +               if (nf_hook_attach_tests[i].expect_success) {
> +                       struct bpf_link *link2;
> +
> +                       if (!ASSERT_OK_PTR(link, "program attach successf=
ul"))
> +                               continue;
> +
> +                       link2 =3D bpf_program__attach_netfilter_opts(prog=
, &opts);
> +                       ASSERT_NULL(link2, "attach program with same pf/h=
ook/priority");

we have ASSERT_ERR_PTR(), which semantically is a bit more explicit,
let's use it here and below for !expect_success case

> +
> +                       if (!ASSERT_EQ(bpf_link__destroy(link), 0, "link =
destroy"))

ASSERT_OK()

> +                               break;
> +
> +                       link2 =3D bpf_program__attach_netfilter_opts(prog=
, &opts);
> +                       if (!ASSERT_OK_PTR(link2, "program reattach succe=
ssful"))
> +                               continue;
> +                       if (!ASSERT_EQ(bpf_link__destroy(link2), 0, "link=
 destroy"))

same, ASSERT_OK()

> +                               break;
> +               } else {
> +                       ASSERT_NULL(link, "program load failure");
> +               }
> +       }
> +}
> +
> +static void test_netfilter_link_attach(void)
> +{
> +       struct test_netfilter_link_attach *skel;
> +
> +       skel =3D test_netfilter_link_attach__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "test_netfilter_link_attach__open_and_lo=
ad"))
> +               goto out;
> +
> +       __test_netfilter_link_attach(skel->progs.nf_link_attach_test);

nit: I'd just inline that function here instead of having
double-underscored helper function

> +out:
> +       test_netfilter_link_attach__destroy(skel);
> +}
> +
> +void test_netfilter_basic(void)
> +{
> +       if (test__start_subtest("netfilter link attach"))
> +               test_netfilter_link_attach();

Do you plan to add more subtests? If not, then this should be just a
test. Single subtest per test doesn't make much sense. Alternatively
(and perhaps better) is to treat each combination in
nf_hook_attach_tests as its own subtest.

> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_netfilter_link_attach=
.c b/tools/testing/selftests/bpf/progs/test_netfilter_link_attach.c
> new file mode 100644
> index 000000000000..03a475160abe
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_netfilter_link_attach.c
> @@ -0,0 +1,14 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +#define NF_ACCEPT 1
> +
> +SEC("netfilter")
> +int nf_link_attach_test(struct bpf_nf_ctx *ctx)
> +{
> +       return NF_ACCEPT;
> +}
> +
> +char _license[] SEC("license") =3D "GPL";
> --
> 2.39.3
>

