Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6360F53D30C
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 23:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349403AbiFCVAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 17:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347807AbiFCVAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 17:00:41 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C277736B69;
        Fri,  3 Jun 2022 14:00:39 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id a15so14416936lfb.9;
        Fri, 03 Jun 2022 14:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7vuBbGTJG9XyQ2hkN38VoUkDCRQU7FLRfD6VazyQ9e8=;
        b=EZfMblws9jrtGLlPpbot8VwUPrSLIJR3vusDZ5YEoeWai083T/RYB+PAAVZ5iK1rK0
         i+xQnql6xOdglKJ9CCN43flpf1sLkdScOzLbe3/ofHM9RxBtKkuNJIcg0eWPvJ3qyZbm
         kUAVHk3PU8e82wTQXE2vZ6/8TEGfhjrL9lsY+79zDireskqZvjt6NfDlMIonItOnndVc
         SwzACf8W3LiW4yxaUZlHQ3N7iGk9U9/sCKRBr6SjjmrAntcRK3v4tiC4kk/ns6lqGREp
         9fKLQ8bdCxxnpoE2kCIy+XqiythG7n2A+9H/xUv/pDZEnlFHTpfY0AQ40WAl9XC6u91g
         dVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7vuBbGTJG9XyQ2hkN38VoUkDCRQU7FLRfD6VazyQ9e8=;
        b=HbFi03C4Qbp1c3bAIwKjBPCTF8A0AFB1YvydsxleL9ZD5UNN/cU/KLuEhewqcP2iJZ
         EWNDtjk39amJKb9QVcn1mudokDB3IwLycioKY4SRZma+E979xruFjMbjiqCNGNGy7OP8
         D52t753AnG3YeWVsBWttElMq8M4id510rPybo7vDTZKRp0QAs4gzlI1/EliZG5N4oIdp
         jIjMJ9DDYJSaCdHExdlsRd9dj4qtN3hrTLcxQz0iVBCSDvwpdu4SOd+77UelXMAplVPw
         BCXaUdwbjWCtTnBo/8Tk0yO6cFWMmwT2FQW2ZR9fD3FnzUDYPQS22cIZQMYtAw04gXCE
         cLNg==
X-Gm-Message-State: AOAM531pXGfCE3zk6h44iBwi2pAFvTOQ1lQZeAlS3OpGRVplTrKpiNo4
        UiMXoIWZSLMc85hBy/FttnpmQAc3abpD8hHcEcAr4NU8Eag=
X-Google-Smtp-Source: ABdhPJwwv5tAZsa2U/Q7K0Z63U8x4HktOiZq7l88YZ13u2Po193LrFxraLoqyVswaljEYj8B4FZz4nd2KLWv+cc5tTw=
X-Received: by 2002:ac2:44b3:0:b0:478:ea0b:ddff with SMTP id
 c19-20020ac244b3000000b00478ea0bddffmr8079131lfm.97.1654290038103; Fri, 03
 Jun 2022 14:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220602143748.673971-1-roberto.sassu@huawei.com>
In-Reply-To: <20220602143748.673971-1-roberto.sassu@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 14:00:26 -0700
Message-ID: <CAEf4BzbL6c7V+-REL7V=dERrpyTus9+9qW8nW0UZn49Y_5x-MA@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] bpf: Per-operation map permissions
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 7:38 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> With the bpf_map security hook, an eBPF program is able to restrict access
> to a map. For example, it might allow only read accesses and deny write
> accesses.
>
> Unfortunately, permissions are not accurately specified by libbpf and
> bpftool. As a consequence, even if they are requested to perform a
> read-like operation, such as a map lookup, that operation fails even if the
> caller has the right to do so.
>
> Even worse, the iteration over existing maps stops as soon as a
> write-protected one is encountered. Maps after the write-protected one are
> not accessible, even if the user has the right to perform operations on
> them.
>
> At low level, the problem is that open_flags and file_flags, respectively
> in the bpf_map_get_fd_by_id() and bpf_obj_get(), are set to zero. The
> kernel interprets this as a request to obtain a file descriptor with full
> permissions.
>
> For some operations, like show or dump, a read file descriptor is enough.
> Those operations could be still performed even in a write-protected map.
>
> Also for searching a map by name, which requires getting the map info, a
> read file descriptor is enough. If an operation requires more permissions,
> they could still be requested later, after the search.
>
> First, solve both problems by extending libbpf with two new functions,
> bpf_map_get_fd_by_id_flags() and bpf_obj_get_flags(), which unlike their
> counterparts bpf_map_get_fd_by_id() and bpf_obj_get(), have the additional
> parameter flags to specify the needed permissions for an operation.
>
> Then, propagate the flags in bpftool from the functions implementing the
> subcommands down to the functions calling bpf_map_get_fd_by_id() and
> bpf_obj_get(), and replace the latter functions with their new variant.
> Initially, set the flags to zero, so that the current behavior does not
> change.
>
> The only exception is for map search by name, where a read-only permission
> is requested, regardless of the operation, to get the map info. In this
> case, request a new file descriptor if a write-like operation needs to be
> performed after the search.
>
> Finally, identify other read-like operations in bpftool and for those
> replace the zero value for flags with BPF_F_RDONLY.
>
> The patch set is organized as follows.
>
> Patches 1-2 introduce the two new variants of bpf_map_get_fd_by_id() and
> bpf_obj_get() in libbpf, named respectively bpf_map_get_fd_by_id_flags()
> and bpf_obj_get_flags().
>
> Patches 3-7 propagate the flags in bpftool from the functions implementing
> the subcommands to the two new libbpf functions, and always set flags to
> BPF_F_RDONLY for the map search operation.
>
> Patch 8 adjusts permissions depending on the map operation performed.
>
> Patch 9 ensures that read-only accesses to a write-protected map succeed
> and write accesses still fail. Also ensure that map search is always
> successful even if there are write-protected maps.
>
> Changelog
>
> v1:
>   - Define per-operation permissions rather than retrying access with
>     read-only permission (suggested by Daniel)
>     https://lore.kernel.org/bpf/20220530084514.10170-1-roberto.sassu@huawei.com/
>
> Roberto Sassu (9):
>   libbpf: Introduce bpf_map_get_fd_by_id_flags()
>   libbpf: Introduce bpf_obj_get_flags()
>   bpftool: Add flags parameter to open_obj_pinned_any() and
>     open_obj_pinned()
>   bpftool: Add flags parameter to *_parse_fd() functions
>   bpftool: Add flags parameter to map_parse_fds()
>   bpftool: Add flags parameter to map_parse_fd_and_info()
>   bpftool: Add flags parameter in struct_ops functions
>   bpftool: Adjust map permissions
>   selftests/bpf: Add map access tests
>
>  tools/bpf/bpftool/btf.c                       |  11 +-
>  tools/bpf/bpftool/cgroup.c                    |   4 +-
>  tools/bpf/bpftool/common.c                    |  52 ++--
>  tools/bpf/bpftool/iter.c                      |   2 +-
>  tools/bpf/bpftool/link.c                      |   9 +-
>  tools/bpf/bpftool/main.h                      |  17 +-
>  tools/bpf/bpftool/map.c                       |  24 +-
>  tools/bpf/bpftool/map_perf_ring.c             |   3 +-
>  tools/bpf/bpftool/net.c                       |   2 +-
>  tools/bpf/bpftool/prog.c                      |  12 +-
>  tools/bpf/bpftool/struct_ops.c                |  39 ++-
>  tools/lib/bpf/bpf.c                           |  16 +-
>  tools/lib/bpf/bpf.h                           |   2 +
>  tools/lib/bpf/libbpf.map                      |   2 +
>  .../bpf/prog_tests/test_map_check_access.c    | 264 ++++++++++++++++++
>  .../selftests/bpf/progs/map_check_access.c    |  65 +++++
>  16 files changed, 452 insertions(+), 72 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_map_check_access.c
>  create mode 100644 tools/testing/selftests/bpf/progs/map_check_access.c
>
> --
> 2.25.1
>

Also check CI failures ([0]).

test_test_map_check_access:PASS:skel 0 nsec
test_test_map_check_access:PASS:skel 0 nsec
test_test_map_check_access:PASS:bpf_object__find_map_by_name 0 nsec
test_test_map_check_access:PASS:bpf_obj_get_info_by_fd 0 nsec
test_test_map_check_access:PASS:bpf_map_get_fd_by_id 0 nsec
test_test_map_check_access:PASS:bpf_map_get_fd_by_id_flags 0 nsec
test_test_map_check_access:PASS:bpf_map_get_fd_by_id_flags 0 nsec
test_test_map_check_access:PASS:bpf_map_lookup_elem 0 nsec
test_test_map_check_access:PASS:bpf_map_update_elem 0 nsec
test_test_map_check_access:PASS:bpf_map_update_elem 0 nsec
test_test_map_check_access:PASS:bpf_map__pin 0 nsec
test_test_map_check_access:PASS:bpf_obj_get_flags 0 nsec
test_test_map_check_access:PASS:bpf_obj_get_flags 0 nsec
test_test_map_check_access:FAIL:bpftool map list - error: 127
#189 test_map_check_access:FAIL

  [0] https://github.com/kernel-patches/bpf/runs/6730796689?check_suite_focus=true
