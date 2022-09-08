Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7755B11C7
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 03:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiIHBEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 21:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiIHBEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 21:04:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D6B13DF5;
        Wed,  7 Sep 2022 18:04:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1155CB81F7C;
        Thu,  8 Sep 2022 01:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC175C4347C;
        Thu,  8 Sep 2022 01:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662599071;
        bh=pDKliAAXbuuHRjn1Tmw2PK6pJKiEg51Kk3HsHlIQUfk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YNNTXqSKtzq1oKkK0voUjm8ZKYC1iduun6DAdgJCwwfOLNKX8jG6cbQysIPTR87DM
         y+HMl1QEEoetsmalSv4Uay1ZK3kB18HqlVAtILAbmy6u9MNn2qL9nA0j/cplojh6sb
         8jpv6eblgFJB+qXjtJ4F7rAuRx3+O4xi+2ugVlKEclVhx6AwsIgIO9DC5ftjdaNwtO
         KR0GPf6XCpudvxzcjpmrbIAXytjpNjjXRPV5ItRZ0PViOAgqy5D6YCvnj6Zv9p6PLW
         J3bxZbWgib3PAlOH52MWGWKICf93BdtwE6KEC3WWkVSFm9RnwVY1qSOmXG/EdxviIz
         g+RqHxVawOw6w==
Received: by mail-wr1-f46.google.com with SMTP id t14so16037655wrx.8;
        Wed, 07 Sep 2022 18:04:31 -0700 (PDT)
X-Gm-Message-State: ACgBeo1Feq6zFHQkNmwrpw6bhcJ2KvHSCsRNaYXvFRsndVOoe5kMpC19
        h29mQMu5dK6dZBiT/UKkMWMjedF90pugckSRbZk=
X-Google-Smtp-Source: AA6agR6TiHrGhJmQC1WmULfwqDbYWxvDpIJUVuPL3xFAGnZeEq3rEYabuCKG1z3oIgWXoh9Pi/FO3vYTL0uf8rMPUqs=
X-Received: by 2002:a5d:6da2:0:b0:228:64cb:5333 with SMTP id
 u2-20020a5d6da2000000b0022864cb5333mr3335307wrs.428.1662599070046; Wed, 07
 Sep 2022 18:04:30 -0700 (PDT)
MIME-Version: 1.0
References: <f35b32f3303b7cb70a5e55f5fbe0bd3a1d38c9a6.1662548037.git.lorenzo@kernel.org>
In-Reply-To: <f35b32f3303b7cb70a5e55f5fbe0bd3a1d38c9a6.1662548037.git.lorenzo@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 7 Sep 2022 18:04:18 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4Vcn4GELkKWNdb+X4L+KfdtOiHqN0VijhWy+vLjvD74g@mail.gmail.com>
Message-ID: <CAPhsuW4Vcn4GELkKWNdb+X4L+KfdtOiHqN0VijhWy+vLjvD74g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix ct status check in bpf_nf selftests
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

On Wed, Sep 7, 2022 at 3:56 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Check properly the connection tracking entry status configured running
> bpf_ct_change_status kfunc.
> Remove unnecessary IPS_CONFIRMED status configuration since it is
> already done during entry allocation.
>
> Fixes: 6eb7fba007a7 ("selftests/bpf: Add tests for new nf_conntrack kfuncs")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  tools/testing/selftests/bpf/prog_tests/bpf_nf.c | 4 ++--
>  tools/testing/selftests/bpf/progs/test_bpf_nf.c | 8 +++++---
>  2 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> index 544bf90ac2a7..903d16e3abed 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> @@ -111,8 +111,8 @@ static void test_bpf_nf_ct(int mode)
>         /* allow some tolerance for test_delta_timeout value to avoid races. */
>         ASSERT_GT(skel->bss->test_delta_timeout, 8, "Test for min ct timeout update");
>         ASSERT_LE(skel->bss->test_delta_timeout, 10, "Test for max ct timeout update");
> -       /* expected status is IPS_SEEN_REPLY */
> -       ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update ");
> +       /* expected status is IPS_CONFIRMED | IPS_SEEN_REPLY */
> +       ASSERT_EQ(skel->bss->test_status, 0xa, "Test for ct status update ");

Why do we use 0xa instead of IPS_CONFIRMED | IPS_SEEN_REPLY?
To avoid dependency on the header file?

Thanks,
Song
