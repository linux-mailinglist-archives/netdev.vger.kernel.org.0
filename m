Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEB15293B9
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344501AbiEPWnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiEPWnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:43:49 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169B2D55;
        Mon, 16 May 2022 15:43:48 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id d3so11516114ilr.10;
        Mon, 16 May 2022 15:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DtkAHaBfvpLeewqHIadY9qnpq18gjeld0itQ23Cwil8=;
        b=HjuZhCIXYlaDIIfu06PAuU4MH3TEmrVTYICjkCezfb91ufGMax2DcAz+18fUWZfUsT
         xLOzI+G2tJVTjX7AU3dZ2Rdvs2MXu/3mCvMayFXuLN81SoM32g8FVO+jI0895I3nTbd8
         fQsEuu0vpPLY+cIvz6e5W/Ll47y6xAMMX6i330mY/FwtcyR96NMU9p4TzN7BXlyVbNDe
         dcRe5y7UfvyE3xuGCIzL68YY/u753vmkUzQzKOd+S1Y4nt4UYgwa2XN0ALyc7PPqlI/3
         WO9g5ciz+TOUeWk0ORkFXzcrVGPmBi3/d9hOMv0ztj8EQJWKM7l1YCLbO9Wpd7VUvkY5
         hr6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DtkAHaBfvpLeewqHIadY9qnpq18gjeld0itQ23Cwil8=;
        b=OBqTjNBN5AWmoXnApzL4F20wT9S/IPu7jiRwHlrt/iWJpWXZc6mb8KaAhzahfuc+wP
         t/E3pVVY+UCGis3aQ/Bt5wGt7r5CYu6IU89LBgBUNpD7dF+i3j32YiaPNe5dP3+XECan
         9ajFtpQcri5Om0mBVTZezDYsPUn2eHULkHCRbS1z3y+si79QuIxPFl/1v5EqtQeaSTu+
         eHYA8YqtWS55ORW3PjpnFL8VNQfABwIJJdOdejjOYTD8uVa2gZv1U8yuWKKEFBG7s44R
         cPk6EOXVSbshbGYmFPqxLD4ETdOnN69XSJqmDxc/G64SwBPGOp4V0cn4o6uE99GUrOe8
         4oDA==
X-Gm-Message-State: AOAM530JAWzwqPF873LP+M0LlV0IJqc5APqAJm6uuBR5/378eBRLbd4a
        PYkaIG39t7V1y0sH6YPV1dNwL067b2lhPjIQQbn7/7Yn
X-Google-Smtp-Source: ABdhPJw89tcTh5etslrD0BFLbgYaeiiJXOpVG0xwZPBUaWa9G0ykOj0vx964VmDsIuegAktEXXYCxCWcyVj2I2eLVjU=
X-Received: by 2002:a05:6e02:1b82:b0:2cf:199f:3b4b with SMTP id
 h2-20020a056e021b8200b002cf199f3b4bmr10385669ili.71.1652741027438; Mon, 16
 May 2022 15:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com> <20220513224827.662254-4-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220513224827.662254-4-mathew.j.martineau@linux.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 May 2022 15:43:36 -0700
Message-ID: <CAEf4Bzbn8DSwxt7WdWhNmfAP_NU8gmnJmFzSzO2kt=ZNSt1gUQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/7] selftests/bpf: add MPTCP test base
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliang.tang@suse.com>
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

On Fri, May 13, 2022 at 3:48 PM Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
> From: Nicolas Rybowski <nicolas.rybowski@tessares.net>
>
> This patch adds a base for MPTCP specific tests.
>
> It is currently limited to the is_mptcp field in case of plain TCP
> connection because there is no easy way to get the subflow sk from a msk
> in userspace. This implies that we cannot lookup the sk_storage attached
> to the subflow sk in the sockops program.
>
> v4:
>  - add copyright 2022 (Andrii)
>  - use ASSERT_* instead of CHECK_FAIL (Andrii)
>  - drop SEC("version") (Andrii)
>  - use is_mptcp in tcp_sock, instead of bpf_tcp_sock (Martin & Andrii)
>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Co-developed-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  MAINTAINERS                                   |   1 +
>  tools/testing/selftests/bpf/bpf_tcp_helpers.h |   1 +
>  tools/testing/selftests/bpf/config            |   1 +
>  tools/testing/selftests/bpf/network_helpers.c |  43 ++++--
>  tools/testing/selftests/bpf/network_helpers.h |   4 +
>  .../testing/selftests/bpf/prog_tests/mptcp.c  | 136 ++++++++++++++++++
>  .../testing/selftests/bpf/progs/mptcp_sock.c  |  53 +++++++
>  7 files changed, 231 insertions(+), 8 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
>  create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c
>

Seems like bpf_core_field_exists() works fine for your use case and CI
is green. See some selftest-specific issues below, though.

[...]

> +static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
> +{
> +       int client_fd, prog_fd, map_fd, err;
> +       struct bpf_program *prog;
> +       struct bpf_object *obj;
> +       struct bpf_map *map;
> +
> +       obj = bpf_object__open("./mptcp_sock.o");
> +       if (libbpf_get_error(obj))
> +               return -EIO;
> +
> +       err = bpf_object__load(obj);
> +       if (!ASSERT_OK(err, "bpf_object__load"))
> +               goto out;
> +
> +       prog = bpf_object__find_program_by_name(obj, "_sockops");

can you please use BPF skeleton instead of doing these lookups by
name? See other tests that are including .skel.h headers for example

> +       if (!ASSERT_OK_PTR(prog, "bpf_object__find_program_by_name")) {
> +               err = -EIO;
> +               goto out;
> +       }
> +

[...]

> +void test_base(void)
> +{
> +       int server_fd, cgroup_fd;
> +
> +       cgroup_fd = test__join_cgroup("/mptcp");
> +       if (CHECK_FAIL(cgroup_fd < 0))
> +               return;
> +
> +       /* without MPTCP */
> +       server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
> +       if (CHECK_FAIL(server_fd < 0))
> +               goto with_mptcp;
> +
> +       CHECK_FAIL(run_test(cgroup_fd, server_fd, false));

please don't add new uses of CHECK_FAIL()

> +
> +       close(server_fd);
> +

[...]
