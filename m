Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2715B234A
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiIHQOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiIHQOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:14:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4725E9019;
        Thu,  8 Sep 2022 09:13:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12D01B82194;
        Thu,  8 Sep 2022 16:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94CDC43470;
        Thu,  8 Sep 2022 16:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662653624;
        bh=B7XrbI01vmCZl/liBk15t2qf0rg7zB2mEM+/1MsxyIk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RKblNx1zeWRvN7J11OUtJ/11QvfYs7cLAJ1ANSDpmTBOh7pqu6GAPGgRJZ4uWHHle
         B8quTr2ESvfVBhPqAAo8CD0l7W4zjtTt9WrU1Knv96q2m0njWDRIj2DmBdHkgAVcTK
         NyXrFTI+X+dnMTTK5+h2hz1WaiDeSYL3D0ZTB8c10BXkLdkO71xfDpCX3h2vEtH3wZ
         BAn15nVoR5q8lxDwnt7eXP/2I62aHp5KQjy0SOky7MZG/SMpVoUG2hHxF7uKlVPjx0
         OtDOdPtRVMdzwqUf73w4F4C48lBaKT10LixDMsTfG5sDCc9K+dCYzJzLkjUZp2aR0f
         FhSD0tvuPacnw==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-127d10b4f19so19877743fac.9;
        Thu, 08 Sep 2022 09:13:44 -0700 (PDT)
X-Gm-Message-State: ACgBeo0zzhuhh6M++GNsNzot0Ua4vvysFvPF9g8HaQFxAa5Q+mKpYJvX
        q/CpSZF9Ep6KhU3mxiiDcKRDuk9/Pu312Pxw52U=
X-Google-Smtp-Source: AA6agR6zWBzv8NjivdRmS3k6VAcz/zm/btbHaYCYXD35FaSFXYhE06H34G+LdOpl17eIWJaPNU3AZY5dbBHVJs9wWNw=
X-Received: by 2002:aca:3016:0:b0:345:9d47:5e11 with SMTP id
 w22-20020aca3016000000b003459d475e11mr1738615oiw.31.1662653623925; Thu, 08
 Sep 2022 09:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <813a5161a71911378dfac8770ec890428e4998aa.1662623574.git.lorenzo@kernel.org>
In-Reply-To: <813a5161a71911378dfac8770ec890428e4998aa.1662623574.git.lorenzo@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Thu, 8 Sep 2022 09:13:33 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7bR2cZzDGXhE0v2qkFH-a+1Sn1pSZ8kNzWW6qyWVYEEg@mail.gmail.com>
Message-ID: <CAPhsuW7bR2cZzDGXhE0v2qkFH-a+1Sn1pSZ8kNzWW6qyWVYEEg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: fix ct status check in bpf_nf selftests
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 8, 2022 at 1:06 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Check properly the connection tracking entry status configured running
> bpf_ct_change_status kfunc.
> Remove unnecessary IPS_CONFIRMED status configuration since it is
> already done during entry allocation.
>
> Fixes: 6eb7fba007a7 ("selftests/bpf: Add tests for new nf_conntrack kfuncs")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Song Liu <song@kernel.org>

> ---
> Change since v1:
> - rely on nf_conntrack_common.h definitions for ct status in bpf_nf.c
> ---
>  tools/testing/selftests/bpf/prog_tests/bpf_nf.c | 5 +++--
>  tools/testing/selftests/bpf/progs/test_bpf_nf.c | 8 +++++---
>  2 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> index 544bf90ac2a7..cdaf6a7d6fd1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <test_progs.h>
>  #include <network_helpers.h>
> +#include <linux/netfilter/nf_conntrack_common.h>
>  #include "test_bpf_nf.skel.h"
>  #include "test_bpf_nf_fail.skel.h"
>
> @@ -111,8 +112,8 @@ static void test_bpf_nf_ct(int mode)
>         /* allow some tolerance for test_delta_timeout value to avoid races. */
>         ASSERT_GT(skel->bss->test_delta_timeout, 8, "Test for min ct timeout update");
>         ASSERT_LE(skel->bss->test_delta_timeout, 10, "Test for max ct timeout update");
> -       /* expected status is IPS_SEEN_REPLY */
> -       ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update ");
> +       ASSERT_EQ(skel->bss->test_status, IPS_CONFIRMED | IPS_SEEN_REPLY,
> +                 "Test for ct status update ");
>         ASSERT_EQ(skel->data->test_exist_lookup, 0, "Test existing connection lookup");
>         ASSERT_EQ(skel->bss->test_exist_lookup_mark, 43, "Test existing connection lookup ctmark");
>  end:
> diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> index 2722441850cc..a3b9d32d1555 100644
> --- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> +++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> @@ -143,7 +143,6 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
>                 struct nf_conn *ct_ins;
>
>                 bpf_ct_set_timeout(ct, 10000);
> -               bpf_ct_set_status(ct, IPS_CONFIRMED);
>
>                 ct_ins = bpf_ct_insert_entry(ct);
>                 if (ct_ins) {
> @@ -156,8 +155,11 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
>                                 bpf_ct_change_timeout(ct_lk, 10000);
>                                 test_delta_timeout = ct_lk->timeout - bpf_jiffies64();
>                                 test_delta_timeout /= CONFIG_HZ;
> -                               test_status = IPS_SEEN_REPLY;
> -                               bpf_ct_change_status(ct_lk, IPS_SEEN_REPLY);
> +
> +                               bpf_ct_change_status(ct_lk,
> +                                                    IPS_CONFIRMED | IPS_SEEN_REPLY);
> +                               test_status = ct_lk->status;
> +
>                                 bpf_ct_release(ct_lk);
>                                 test_succ_lookup = 0;
>                         }
> --
> 2.37.3
>
