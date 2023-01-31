Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6EF682105
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 01:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjAaAuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 19:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjAaAuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 19:50:07 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92994206AA;
        Mon, 30 Jan 2023 16:50:05 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id p26so25961666ejx.13;
        Mon, 30 Jan 2023 16:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NnKj2aLdM32Qoihlom2cgtRGZ6PATefqnqoDcKWvAE4=;
        b=HikrjOogNuwR4zLiktbxxsXjhjzZAJrajy0F4e7npz9Y66frjtK4FdIV1dqRO8fWq6
         HlRnQTmw4Gh0bej2TwRCeyzk9pNbq0DJ593eBa4kjwEwI12oLBfmeH7/YVmsqffdZ6xV
         45iXR6/zuCdJ/OXzMJ4tnxDZZ22070FFyH5lyAzKQUb5nBQmSjPgdN57+JQz9CwsziHH
         WMXMd/rYiqpHONwZOGFW3/ttm1EVDYhuleqJ4RFPrz61yAGI8qatEciHazfOOzQlsBJ3
         dzEUcX2xHxQM++uv/Og4dli4gZgMAFSAXuLTC50CNF5/qHQ0uWLav9xBTZ0H7vHKAX4n
         GxEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NnKj2aLdM32Qoihlom2cgtRGZ6PATefqnqoDcKWvAE4=;
        b=gtKmnWW+z979sCiqh6tqCksUURdoO9Bh9r/1yiiys1dwISdSE8QBk05uES/Nxr0rWc
         OA7NpJ9LXeQWcXYcrk6zG4ZxUJgU//NIX5gAIaA/3H/swkp94uTM3VwOYbreVQ9vqkEC
         /NmtBaCGm81Va7ZemUrPkYeVJhE2mYfjjU2EpataPmSgEZsNeXRa5+UJy4DZCHgSwOzs
         YT1k6CiAf7uftoPSzzGssysvQjvioCcOJppkE11oIIYy+sue6Tv0wWiZhZEoHYMRsXCG
         XI/G+kJZM7F/LMrbvOOuNvHxbk7ux4Tnt61WZVcoL3M3YUCN1ZxZfBVNYN/L/OQS6IWy
         rRHA==
X-Gm-Message-State: AO0yUKV9Ut4nAI3/2KKkPCNWd1JI7HrDQsi0IYmqeQpYgQZYv1YFsOyi
        t2ynVS65RXLA8leffYNsvw8VmV4Pz4W+N19Dm4gdgsdA
X-Google-Smtp-Source: AK7set8rONj+RngwjnMwPSCQtI8fm6oMehIf2Yn4p+Vc9eELMlTbp1kZsDAHjY9z9MgWcwo0sx2tlFbHN3resgKZxqY=
X-Received: by 2002:a17:906:7194:b0:884:d15e:10ff with SMTP id
 h20-20020a170906719400b00884d15e10ffmr2254839ejk.265.1675126203895; Mon, 30
 Jan 2023 16:50:03 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com> <20230127191703.3864860-6-joannelkoong@gmail.com>
In-Reply-To: <20230127191703.3864860-6-joannelkoong@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Jan 2023 16:49:52 -0800
Message-ID: <CAEf4BzbAQ-+wfCzWFr=QWDQFFoBcdwrkDodO8A17b8rTX4ObHw@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 5/5] selftests/bpf: tests for using dynptrs to
 parse skb and xdp buffers
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        memxor@gmail.com, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 11:18 AM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> Test skb and xdp dynptr functionality in the following ways:
>
> 1) progs/test_cls_redirect_dynptr.c
>    * Rewrite "progs/test_cls_redirect.c" test to use dynptrs to parse
>      skb data
>
>    * This is a great example of how dynptrs can be used to simplify a
>      lot of the parsing logic for non-statically known values.
>
>      When measuring the user + system time between the original version
>      vs. using dynptrs, and averaging the time for 10 runs (using
>      "time ./test_progs -t cls_redirect"):
>          original version: 0.092 sec
>          with dynptrs: 0.078 sec
>
> 2) progs/test_xdp_dynptr.c
>    * Rewrite "progs/test_xdp.c" test to use dynptrs to parse xdp data
>
>      When measuring the user + system time between the original version
>      vs. using dynptrs, and averaging the time for 10 runs (using
>      "time ./test_progs -t xdp_attach"):
>          original version: 0.118 sec
>          with dynptrs: 0.094 sec
>
> 3) progs/test_l4lb_noinline_dynptr.c
>    * Rewrite "progs/test_l4lb_noinline.c" test to use dynptrs to parse
>      skb data
>
>      When measuring the user + system time between the original version
>      vs. using dynptrs, and averaging the time for 10 runs (using
>      "time ./test_progs -t l4lb_all"):
>          original version: 0.062 sec
>          with dynptrs: 0.081 sec
>
>      For number of processed verifier instructions:
>          original version: 6268 insns
>          with dynptrs: 2588 insns
>
> 4) progs/test_parse_tcp_hdr_opt_dynptr.c
>    * Add sample code for parsing tcp hdr opt lookup using dynptrs.
>      This logic is lifted from a real-world use case of packet parsing
>      in katran [0], a layer 4 load balancer. The original version
>      "progs/test_parse_tcp_hdr_opt.c" (not using dynptrs) is included
>      here as well, for comparison.
>
>      When measuring the user + system time between the original version
>      vs. using dynptrs, and averaging the time for 10 runs (using
>      "time ./test_progs -t parse_tcp_hdr_opt"):
>          original version: 0.031 sec
>          with dynptrs: 0.045 sec
>
> 5) progs/dynptr_success.c
>    * Add test case "test_skb_readonly" for testing attempts at writes /
>      data slices on a prog type with read-only skb ctx.
>
> 6) progs/dynptr_fail.c
>    * Add test cases "skb_invalid_data_slice{1,2}" and
>      "xdp_invalid_data_slice" for testing that helpers that modify the
>      underlying packet buffer automatically invalidate the associated
>      data slice.
>    * Add test cases "skb_invalid_ctx" and "xdp_invalid_ctx" for testing
>      that prog types that do not support bpf_dynptr_from_skb/xdp don't
>      have access to the API.
>    * Add test case "skb_invalid_write" for testing that writes to a
>      read-only data slice are rejected by the verifier.
>
> [0]
> https://github.com/facebookincubator/katran/blob/main/katran/lib/bpf/pckt_parsing.h
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/cls_redirect.c   |  25 +
>  .../testing/selftests/bpf/prog_tests/dynptr.c |  63 +-
>  .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +
>  .../bpf/prog_tests/parse_tcp_hdr_opt.c        |  93 ++
>  .../selftests/bpf/prog_tests/xdp_attach.c     |  11 +-
>  .../testing/selftests/bpf/progs/dynptr_fail.c | 124 +++
>  .../selftests/bpf/progs/dynptr_success.c      |  28 +
>  .../bpf/progs/test_cls_redirect_dynptr.c      | 973 ++++++++++++++++++
>  .../bpf/progs/test_l4lb_noinline_dynptr.c     | 474 +++++++++
>  .../bpf/progs/test_parse_tcp_hdr_opt.c        | 119 +++
>  .../bpf/progs/test_parse_tcp_hdr_opt_dynptr.c | 112 ++
>  .../selftests/bpf/progs/test_xdp_dynptr.c     | 237 +++++
>  .../selftests/bpf/test_tcp_hdr_options.h      |   1 +
>  13 files changed, 2248 insertions(+), 14 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_dynptr.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt_dynptr.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_dynptr.c
>

[...]

> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
> index 062fbc8c8e5e..28c453bbb84a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
> @@ -4,11 +4,10 @@
>  #define IFINDEX_LO 1
>  #define XDP_FLAGS_REPLACE              (1U << 4)
>
> -void serial_test_xdp_attach(void)
> +static void serial_test_xdp_attach(const char *file)
>  {
>         __u32 duration = 0, id1, id2, id0 = 0, len;
>         struct bpf_object *obj1, *obj2, *obj3;
> -       const char *file = "./test_xdp.bpf.o";
>         struct bpf_prog_info info = {};
>         int err, fd1, fd2, fd3;
>         LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
> @@ -85,3 +84,11 @@ void serial_test_xdp_attach(void)
>  out_1:
>         bpf_object__close(obj1);
>  }
> +
> +void test_xdp_attach(void)

this test was marked as serial (it starts with "serial_test_"), so we
probably want to preserve that? Just keep this as
"serial_test_xdp_attach" and rename above serial_test_xdp_attach to
something like "subtest_xdp_attach" (this name doesn't matter to
test_progs runner).

> +{
> +       if (test__start_subtest("xdp_attach"))
> +               serial_test_xdp_attach("./test_xdp.bpf.o");
> +       if (test__start_subtest("xdp_attach_dynptr"))
> +               serial_test_xdp_attach("./test_xdp_dynptr.bpf.o");
> +}

[...]
