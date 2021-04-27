Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B301636CDF8
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239035AbhD0VvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbhD0VvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 17:51:01 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242D5C061574;
        Tue, 27 Apr 2021 14:50:18 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id g38so71220518ybi.12;
        Tue, 27 Apr 2021 14:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g9u9+UZZXu61nHsym3WFJrZ91luyL2S/2PTOn2aKe2o=;
        b=SacFMlfXwnEbI1DaTRgfhVljUAX949v+WV3jsUkM9UkOAybmnFV2iLydJp9RzaFCJr
         3JdcBYWHgPWGKdAfxmfMMktY+bIaVMVYONC8HGq8xC9yRHaYVWcc0qL37oSMnd8ox+iP
         s4jxsynoEuFtGtaCVa0vT2m/t2kwPOrZGcBJvpQc/Gqs140Hq5Q8am70CUgsqWUly4UG
         g4nc2kf8GKF0ozysxv0eUDq5lfBRiCNqKDfEhjxXt5qdGiibt0nN9DLP6sj98ok10ilP
         nHcBZkmK+d1tzNAh2TYJxP8tkkWnvrpoCzm6OaMBUtzhzBrrUN9DEjCzvFgX/afXEE3c
         +NhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g9u9+UZZXu61nHsym3WFJrZ91luyL2S/2PTOn2aKe2o=;
        b=P+nnUPbGQhZXhiVJqqazH2reQesQsW7K04hp23R4ZRF6VuU9zTirsmfqJIlo/bhwi3
         7EcqvdGx8F1F76Y3YsvGE08WvKpXrUQJ1rXO38Jv/8fB56OUb9qYLKW2PbnI0Nn5Hmf/
         AFMxRluHwDS3Pc0kYb1VniN4s52NsI+Jp/rV6hwRlMJ4mQi/Gc3Ph9u37Ug7ovJiR73L
         qXbWYySQlUbSN/XmkCKgE04D+DzLnWmlX+Ru8KY2pWONAOH8P7YJdLc/GyJhOhIXV9PQ
         w03k8CTfXgjYa9elE9JVjum6A6K7GjiFf3+jTIEbkTEBmH+I+sx2Sq5SLaHum7GY1nES
         t4Yg==
X-Gm-Message-State: AOAM53247jVIuyHblX5FWAr2z3G7lwE4KL6Y1yULsmQ1DHha65J32pcY
        h/9R3pmCIE9gl/OURbp7OplkUnqXPxgU0o6tW60=
X-Google-Smtp-Source: ABdhPJzeQTpODDIu/1gBVv5BHHKC2IFL8QJcvJqqmkhLgAmqeDZjx0ygWW0pUxyT7Kqy3npH/Q3FUQPunGrFAxoqAb4=
X-Received: by 2002:a05:6902:1144:: with SMTP id p4mr35420016ybu.510.1619560217266;
 Tue, 27 Apr 2021 14:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210423150600.498490-1-memxor@gmail.com> <20210423150600.498490-4-memxor@gmail.com>
In-Reply-To: <20210423150600.498490-4-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Apr 2021 14:50:06 -0700
Message-ID: <CAEf4BzbV6FGaXCMc8aQjN8iA=Lv7pC_gQDNpDO_EBv3XbrJ5oA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/3] libbpf: add selftests for TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 8:06 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This adds some basic tests for the low level bpf_tc_* API.
>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  .../testing/selftests/bpf/prog_tests/tc_bpf.c | 204 ++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 ++
>  2 files changed, 216 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c
>

[...]

> +
> +void test_tc_bpf(void)
> +{
> +       struct bpf_tc_ctx *ctx_ing =3D NULL, *ctx_eg =3D NULL;
> +       struct test_tc_bpf *skel =3D NULL;
> +       int cls_fd, ret;
> +
> +       skel =3D test_tc_bpf__open_and_load();
> +       if (!ASSERT_NEQ(skel, NULL, "test_tc_bpf skeleton"))
> +               goto end;
> +
> +       cls_fd =3D bpf_program__fd(skel->progs.cls);
> +
> +       ctx_ing =3D bpf_tc_ctx_init(LO_IFINDEX, BPF_TC_INGRESS, NULL);
> +       if (!ASSERT_NEQ(ctx_ing, NULL, "bpf_tc_ctx_init(BPF_TC_INGRESS)")=
)

please use ASSERT_OK_PTR() and ASSERT_ERR_PTR() for pointer checks.
They handle both NULL/non-NULL cases and ERR_PTR() errors.

> +               goto end;
> +
> +       ctx_eg =3D bpf_tc_ctx_init(LO_IFINDEX, BPF_TC_EGRESS, NULL);
> +       if (!ASSERT_NEQ(ctx_eg, NULL, "bpf_tc_ctx_init(BPF_TC_EGRESS)"))
> +               goto end;
> +
> +       ret =3D test_tc_internal(ctx_ing, cls_fd, BPF_TC_INGRESS);
> +       if (!ASSERT_EQ(ret, 0, "test_tc_internal ingress"))
> +               goto end;
> +
> +       ret =3D test_tc_internal(ctx_eg, cls_fd, BPF_TC_EGRESS);
> +       if (!ASSERT_EQ(ret, 0, "test_tc_internal egress"))
> +               goto end;
> +
> +       ret =3D test_tc_invalid(ctx_ing, cls_fd);
> +       if (!ASSERT_EQ(ret, 0, "test_tc_invalid"))
> +               goto end;
> +
> +end:
> +       bpf_tc_ctx_destroy(ctx_eg);
> +       bpf_tc_ctx_destroy(ctx_ing);
> +       test_tc_bpf__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_tc_bpf.c b/tools/test=
ing/selftests/bpf/progs/test_tc_bpf.c
> new file mode 100644
> index 000000000000..18a3a7ed924a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_tc_bpf.c
> @@ -0,0 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +/* Dummy prog to test TC-BPF API */
> +
> +SEC("classifier")
> +int cls(struct __sk_buff *skb)
> +{
> +       return 0;
> +}
> --
> 2.30.2
>
