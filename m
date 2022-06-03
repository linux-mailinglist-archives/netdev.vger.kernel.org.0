Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF8C53D301
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 22:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349405AbiFCU7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 16:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349393AbiFCU7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 16:59:19 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82351326ED;
        Fri,  3 Jun 2022 13:59:18 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a2so14442105lfc.2;
        Fri, 03 Jun 2022 13:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Zf/s0SaSFVL72JcWqaZKf9ZOwnX1mZbPqtqk2pqScU=;
        b=ADBCskZMWKUbjdRTEV2bGjHRulbSZREXira6B6GNOMQihTDUT0ZRLDs39beahjIBUf
         s8QP6Q0+KA5xzDay1mRycX0IH6u1ZdurFwuCCsWGyEdRVaW1dbt8TGvi0EoPEmCdg6Nd
         dzgwxB+HUCWQQ8Q5HuTVscTe+trZ8p+BffAWBGwba8zfsZhtZwj7fWPBfvskLWyjJHwZ
         MM2b9ha8w1TvdR808xgOqvO4UFPJAQWSw9wLvmc0fZhpyPX3RlO4L3V2p+yg3LcvVDih
         BlgvO/xtZXzP+bzZXNmpA3Dw38ZzdulCw1wzzQkMChdEBGU7Pxi+rpQbxWsdi022uWVx
         tHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Zf/s0SaSFVL72JcWqaZKf9ZOwnX1mZbPqtqk2pqScU=;
        b=BRPwpqIJPX7aOCX87qxe/KPLpAh4dXD1Sgz69cUkJRKsOxgzFcPFask3QeDGalVF0g
         LfmZ63ntOT+fkyc5UZ8C4d++JR4qeTTV+07yKYv7uQaLH9kixudFXUDZjQnM+yB3Mu/j
         lWPgcVwCVnRv/9HajUQyl367LQYLqvQnTs26rnN7wXLqBzLtar0FbpAOUFlRNPmEMar3
         E+6NqwNigsInUlwj1vdp0Xu9W2KNVvdT4YB1vbPI6Pw8l1RA54+EUoOi/wCw2w/hAMis
         2tw87xta5gwsQ0X+Mha3QIh/j28PcPiPgArcHKDAt3cdCV5X+l0fUP4UEk0QunzkRaOp
         lnnQ==
X-Gm-Message-State: AOAM5311dCkSmNs0LbNZc6QaWf8EhvPCihiVV4ILijyzNiK7oU4OwOKz
        2IcYXUVxMdaRZ+1rBpn/RUFxjVHGxh91H29JgMs=
X-Google-Smtp-Source: ABdhPJy2ZVutoWAswlobXgUkWxpN9yC7TOyDeVmYheWIFGxyZGSAJnDevuzJHhMc0piXTBVrW5iU1WB2vrZSC9aAwXk=
X-Received: by 2002:a05:6512:1398:b0:448:bda0:99f2 with SMTP id
 p24-20020a056512139800b00448bda099f2mr54702811lfa.681.1654289956759; Fri, 03
 Jun 2022 13:59:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220602143748.673971-1-roberto.sassu@huawei.com> <20220602143748.673971-10-roberto.sassu@huawei.com>
In-Reply-To: <20220602143748.673971-10-roberto.sassu@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 13:59:05 -0700
Message-ID: <CAEf4BzaTK_oh0MwzcxCx8Ls21gXe9SORTjXnu6KqPqFHT71WsA@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] selftests/bpf: Add map access tests
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

On Thu, Jun 2, 2022 at 7:39 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> Add some tests to ensure that read-like operations can be performed on a
> write-protected map, and that write-like operations fail with a read file
> descriptor.
>
> Do the tests programmatically, with the new functions
> bpf_map_get_fd_by_id_flags() and bpf_obj_get_flags(), added to libbpf, and
> with the bpftool binary.
>
> Also ensure that map search by name works when there is a write-protected
> map. Before, iteration over existing maps stopped due to not being able
> to get a file descriptor with full permissions.
>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  .../bpf/prog_tests/test_map_check_access.c    | 264 ++++++++++++++++++
>  .../selftests/bpf/progs/map_check_access.c    |  65 +++++
>  2 files changed, 329 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_map_check_access.c
>  create mode 100644 tools/testing/selftests/bpf/progs/map_check_access.c

general convention (not universally followed, unfortunately) is
opposite, progs/test_<something>.c and prog_tests/<something>.c. This
allows to not have weird test_test_<something> naming pattern

>
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_map_check_access.c b/tools/testing/selftests/bpf/prog_tests/test_map_check_access.c
> new file mode 100644
> index 000000000000..20ccadcdf10f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/test_map_check_access.c
> @@ -0,0 +1,264 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
> + *
> + * Author: Roberto Sassu <roberto.sassu@huawei.com>
> + */
> +
> +#include <test_progs.h>
> +
> +#include "map_check_access.skel.h"
> +
> +#define PINNED_MAP_PATH "/sys/fs/bpf/test_map_check_access_map"
> +#define BPFTOOL_PATH "./tools/build/bpftool/bpftool"
> +
> +enum check_types { CHECK_NONE, CHECK_PINNED, CHECK_METADATA };
> +
> +static int populate_argv(char *argv[], int max_args, char *cmdline)
> +{
> +       char *arg;
> +       int i = 0;
> +
> +       argv[i++] = BPFTOOL_PATH;
> +
> +       while ((arg = strsep(&cmdline, " "))) {
> +               if (i == max_args - 1)
> +                       break;
> +
> +               argv[i++] = arg;
> +       }
> +
> +       argv[i] = NULL;
> +       return i;
> +}
> +
> +static void restore_cmdline(char *argv[], int num_args)
> +{
> +       int i;
> +
> +       for (i = 1; i < num_args - 1; i++)
> +               argv[i][strlen(argv[i])] = ' ';
> +}

I'm missing the point of this cmdline restoration?..

> +
> +static int _run_bpftool(char *cmdline, enum check_types check)
> +{
> +       char *argv[20];
> +       char output[1024];
> +       int ret, fd[2], num_args, child_pid, child_status;
> +
> +       num_args = populate_argv(argv, ARRAY_SIZE(argv), cmdline);
> +
> +       ret = pipe(fd);
> +       if (ret < 0)
> +               return ret;
> +

and popen() doesn't work instead of all this forking/execve sequence?

> +       child_pid = fork();
> +       if (child_pid == 0) {
> +               close(fd[0]);
> +               close(STDOUT_FILENO);
> +               close(STDERR_FILENO);
> +
> +               ret = dup2(fd[1], STDOUT_FILENO);
> +               if (ret < 0) {
> +                       close(fd[1]);
> +                       exit(errno);
> +               }
> +
> +               execv(BPFTOOL_PATH, argv);
> +               close(fd[1]);
> +               exit(errno);
> +       } else if (child_pid > 0) {
> +               close(fd[1]);
> +
> +               restore_cmdline(argv, num_args);
> +
> +               waitpid(child_pid, &child_status, 0);
> +               if (WEXITSTATUS(child_status)) {
> +                       close(fd[0]);
> +                       return WEXITSTATUS(child_status);
> +               }
> +
> +               ret = read(fd[0], output, sizeof(output) - 1);
> +
> +               close(fd[0]);
> +
> +               if (ret < 0)
> +                       return ret;
> +
> +               output[ret] = '\0';
> +               ret = 0;
> +
> +               switch (check) {
> +               case CHECK_PINNED:
> +                       if (!strstr(output, PINNED_MAP_PATH))
> +                               ret = -ENOENT;
> +                       break;
> +               case CHECK_METADATA:
> +                       if (!strstr(output, "test_var"))
> +                               ret = -ENOENT;
> +                       break;
> +               default:
> +                       break;
> +               }
> +
> +               return ret;
> +       }
> +
> +       close(fd[0]);
> +       close(fd[1]);
> +
> +       return -EINVAL;
> +}
> +
> +void test_test_map_check_access(void)
> +{
> +       struct map_check_access *skel;
> +       struct bpf_map_info info_m = { 0 };
> +       struct bpf_map *map;
> +       __u32 len = sizeof(info_m);
> +       char cmdline[1024];
> +       int ret, zero = 0, fd, duration = 0;
> +
> +       skel = map_check_access__open_and_load();
> +       if (CHECK(!skel, "skel", "open_and_load failed\n"))
> +               goto close_prog;
> +
> +       ret = map_check_access__attach(skel);
> +       if (CHECK(ret < 0, "skel", "attach failed\n"))
> +               goto close_prog;
> +

please don't use CHECK(), use ASSERT_xxx() macros instead

> +       map = bpf_object__find_map_by_name(skel->obj, "data_input");
> +       if (CHECK(!map, "bpf_object__find_map_by_name", "not found\n"))
> +               goto close_prog;
> +
> +       ret = bpf_obj_get_info_by_fd(bpf_map__fd(map), &info_m, &len);
> +       if (CHECK(ret < 0, "bpf_obj_get_info_by_fd", "error: %d\n", ret))
> +               goto close_prog;
> +
> +       fd = bpf_map_get_fd_by_id(info_m.id);
> +       if (CHECK(fd >= 0, "bpf_map_get_fd_by_id",
> +                 "should fail (map write-protected)\n"))
> +               goto close_prog;
> +

[...]

> +       snprintf(cmdline, sizeof(cmdline), "btf dump map name data_input");
> +       ret = _run_bpftool(cmdline, CHECK_NONE);
> +       if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
> +               goto close_prog;
> +
> +       snprintf(cmdline, sizeof(cmdline), "map pin name data_input %s",
> +                PINNED_MAP_PATH);
> +       ret = _run_bpftool(cmdline, CHECK_NONE);
> +       if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
> +               goto close_prog;
> +
> +       snprintf(cmdline, sizeof(cmdline), "struct_ops show name dummy_2");
> +       ret = _run_bpftool(cmdline, CHECK_NONE);

if you don't have to restore anything, you don't need snprintf()'ing,
just pass arguments as a string literal directly

> +       if (CHECK(ret, "bpftool", "%s - error: %d\n", cmdline, ret))
> +               goto close_prog;
> +
> +       snprintf(cmdline, sizeof(cmdline), "struct_ops dump name dummy_2");
> +       ret = _run_bpftool(cmdline, CHECK_NONE);
> +
> +       CHECK(ret, "_run_bpftool", "%s - error: %d\n", cmdline, ret);
> +
> +close_prog:
> +       map_check_access__destroy(skel);
> +       unlink(PINNED_MAP_PATH);
> +}

[...]
