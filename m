Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7314E69B747
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 02:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjBRBEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 20:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjBRBEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 20:04:07 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E710C3BD80;
        Fri, 17 Feb 2023 17:04:05 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id eg30so10434423edb.7;
        Fri, 17 Feb 2023 17:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ztFJ4TFZOEmVhqka+SB7tM/zoG3ah7M5fnT/MchjCbs=;
        b=e/RsCVXki7NrOqtxpigzgBb9yA2DZohOJtudZ2f3yIlvQMhaf+UxWIsjv2JZjPRc+E
         ygTMATCqqax7R2qLWrX+v0NIbt9POHoqmuyfS+CU2EUpedNgTC0O/X35zAzuxUxyHsh8
         ZolmWbaHcS4Amr/5ozsTDj0ZwnwGFcr3/1QnzNzdyF6gcchY4uKLH8djsj0P/uEGdPQt
         Y8nU5S1lHKXSLec4L7ZFFGYqtnSD1kU0wL1kBBsQAhKhliMAUoW/9LcvcwgZtyKJZLVU
         INuFQxdICuPv8aWOiw2WszqkMdx3T5zQfEXy9KNESMmoDskUu5aDxSIplvuN+0Ol7MvA
         etLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ztFJ4TFZOEmVhqka+SB7tM/zoG3ah7M5fnT/MchjCbs=;
        b=eCD6mz4L6hRDPuOqGQ/pRDrqDJVnOcOGflagOPZ/08KRhHKzeFtXPhdR8SY0V3gUou
         1m/Dh2aWumY9zo574v8C6kid9urbAC7eYeI3pCbbgzXPMU3pDsHp8vCvIXr99swJGF6H
         DRoB2kDJQoBpykHu31VmO/obWSoPLiU84PkOj6nhI0D2ODHNWIHYkKyC9NPIbXyK5aXp
         a6WI8vRJIpxd0gadaoBHDmRXtONct5NKt6UW4BfOsCY9FSxYZTRqIFjCze/a4IYGTeV6
         RzqYdWHwlumYs0mFEqNDkWl8F3SOAVdtwvFcmFRKrWSzOvNva3hsmisQmvj4Zexl9/FA
         PQDA==
X-Gm-Message-State: AO0yUKWtqMkuD7mEugbnmok/wBBbAI9Rgl50VmO31aZBkIFQiqhE1851
        DR2Vyr310HDR6BIn2vUUrkReTram1Yi97l0LoEHpz1KmEQU=
X-Google-Smtp-Source: AK7set+z+a/nzMH5IpZVFxpBpesJxtNyVbLnaCGvaqvypg8/bCoFIr6Y5tutkmvNJBrgPXPw2aj5L2MLQem3uYeL+bQ=
X-Received: by 2002:a05:6402:2811:b0:4ac:ce81:9c1d with SMTP id
 h17-20020a056402281100b004acce819c1dmr5435996ede.0.1676682244370; Fri, 17 Feb
 2023 17:04:04 -0800 (PST)
MIME-Version: 1.0
References: <20230216225524.1192789-1-joannelkoong@gmail.com>
In-Reply-To: <20230216225524.1192789-1-joannelkoong@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Feb 2023 17:03:52 -0800
Message-ID: <CAEf4BzbdigzwouNNBxm+UkJxxjMEcBP5coezAjsLfm11hRYOYw@mail.gmail.com>
Subject: Re: [PATCH v10 bpf-next 0/9] Add skb + xdp dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, martin.lau@kernel.org, andrii@kernel.org,
        memxor@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, kernel-team@fb.com
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

On Thu, Feb 16, 2023 at 2:56 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> This patchset is the 2nd in the dynptr series. The 1st can be found here [0].
>
> This patchset adds skb and xdp type dynptrs, which have two main benefits for
> packet parsing:
>     * allowing operations on sizes that are not statically known at
>       compile-time (eg variable-sized accesses).
>     * more ergonomic and less brittle iteration through data (eg does not need
>       manual if checking for being within bounds of data_end)
>
> When comparing the differences in runtime for packet parsing without dynptrs
> vs. with dynptrs, there is no noticeable difference. Patch 9 contains more
> details as well as examples of how to use skb and xdp dynptrs.
>
> [0]
> https://lore.kernel.org/bpf/20220523210712.3641569-1-joannelkoong@gmail.com/
>
> --

Looks good to me overall, but s390x CI fails, please take a look at [0]

  [0] https://github.com/kernel-patches/bpf/actions/runs/4207628899/jobs/7303067297

> Changelog:
>
> v9 = https://lore.kernel.org/bpf/20230127191703.3864860-1-joannelkoong@gmail.com/
> v9 -> v10:
>     * Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr interface
>     * Add some more tests
>     * Split up patchset into more parts to make it easier to review
>
> v8 = https://lore.kernel.org/bpf/20230126233439.3739120-1-joannelkoong@gmail.com/
> v8 -> v9:
>     * Fix dynptr_get_type() to check non-stack dynptrs
>
> v7 = https://lore.kernel.org/bpf/20221021011510.1890852-1-joannelkoong@gmail.com/
> v7 -> v8:
>     * Change helpers to kfuncs
>     * Add 2 new patches (1/5 and 2/5)
>
> v6 = https://lore.kernel.org/bpf/20220907183129.745846-1-joannelkoong@gmail.com/
> v6 -> v7
>     * Change bpf_dynptr_data() to return read-only data slices if the skb prog
>       is read-only (Martin)
>     * Add test "skb_invalid_write" to test that writes to rd-only data slices
>       are rejected
>
> v5 = https://lore.kernel.org/bpf/20220831183224.3754305-1-joannelkoong@gmail.com/
> v5 -> v6
>     * Address kernel test robot errors by static inlining
>
> v4 = https://lore.kernel.org/bpf/20220822235649.2218031-1-joannelkoong@gmail.com/
> v4 -> v5
>     * Address kernel test robot errors for configs w/out CONFIG_NET set
>     * For data slices, return PTR_TO_MEM instead of PTR_TO_PACKET (Kumar)
>     * Split selftests into subtests (Andrii)
>     * Remove insn patching. Use rdonly and rdwr protos for dynptr skb
>       construction (Andrii)
>     * bpf_dynptr_data() returns NULL for rd-only dynptrs. There will be a
>       separate bpf_dynptr_data_rdonly() added later (Andrii and Kumar)
>
> v3 = https://lore.kernel.org/bpf/20220822193442.657638-1-joannelkoong@gmail.com/
> v3 -> v4
>     * Forgot to commit --amend the kernel test robot error fixups
>
> v2 = https://lore.kernel.org/bpf/20220811230501.2632393-1-joannelkoong@gmail.com/
> v2 -> v3
>     * Fix kernel test robot build test errors
>
> v1 = https://lore.kernel.org/bpf/20220726184706.954822-1-joannelkoong@gmail.com/
> v1 -> v2
>   * Return data slices to rd-only skb dynptrs (Martin)
>   * bpf_dynptr_write allows writes to frags for skb dynptrs, but always
>     invalidates associated data slices (Martin)
>   * Use switch casing instead of ifs (Andrii)
>   * Use 0xFD for experimental kind number in the selftest (Zvi)
>   * Put selftest conversions w/ dynptrs into new files (Alexei)
>   * Add new selftest "test_cls_redirect_dynptr.c"
>
> Joanne Koong (9):
>   bpf: Support "sk_buff" and "xdp_buff" as valid kfunc arg types
>   bpf: Refactor process_dynptr_func
>   bpf: Allow initializing dynptrs in kfuncs
>   bpf: Define no-ops for externally called bpf dynptr functions
>   bpf: Refactor verifier dynptr into get_dynptr_arg_reg
>   bpf: Add skb dynptrs
>   bpf: Add xdp dynptrs
>   bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
>   selftests/bpf: tests for using dynptrs to parse skb and xdp buffers
>
>  include/linux/bpf.h                           |  95 +-
>  include/linux/bpf_verifier.h                  |   3 -
>  include/linux/filter.h                        |  46 +
>  include/uapi/linux/bpf.h                      |  18 +-
>  kernel/bpf/btf.c                              |  22 +
>  kernel/bpf/helpers.c                          | 174 +++-
>  kernel/bpf/verifier.c                         | 365 +++++--
>  net/core/filter.c                             | 108 +-
>  tools/include/uapi/linux/bpf.h                |  18 +-
>  .../selftests/bpf/prog_tests/cls_redirect.c   |  25 +
>  .../testing/selftests/bpf/prog_tests/dynptr.c |  69 +-
>  .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +
>  .../bpf/prog_tests/parse_tcp_hdr_opt.c        |  93 ++
>  .../selftests/bpf/prog_tests/xdp_attach.c     |  11 +-
>  .../testing/selftests/bpf/progs/dynptr_fail.c | 274 ++++-
>  .../selftests/bpf/progs/dynptr_success.c      |  51 +-
>  .../bpf/progs/test_cls_redirect_dynptr.c      | 975 ++++++++++++++++++
>  .../bpf/progs/test_l4lb_noinline_dynptr.c     | 486 +++++++++
>  .../bpf/progs/test_parse_tcp_hdr_opt.c        | 119 +++
>  .../bpf/progs/test_parse_tcp_hdr_opt_dynptr.c | 118 +++
>  .../selftests/bpf/progs/test_xdp_dynptr.c     | 257 +++++
>  .../selftests/bpf/test_tcp_hdr_options.h      |   1 +
>  22 files changed, 3151 insertions(+), 179 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_dynptr.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt_dynptr.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_dynptr.c
>
> --
> 2.30.2
>
