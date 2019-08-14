Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 308728DE0A
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfHNTrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:47:40 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35413 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728394AbfHNTrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 15:47:40 -0400
Received: by mail-qk1-f196.google.com with SMTP id r21so84147qke.2;
        Wed, 14 Aug 2019 12:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V2ltZ2eIPqMpNkygV2JwHqpiEgCcB7eRr0XagT3oAd8=;
        b=uaNLov5B9gOWHGp03T5gUCrG1v01mAv8Mr+mlPlukih1HsZc6emtw1f3DYxfilfVX0
         GhK4iPiXGo7tVhqiV1xhsp+Al0eQr2axIFvASXoFZ5bdzhaHxBUVZLwvVtsZnrQ+Uw32
         kytVFAZ4/8hiMyYHb0syqhfAJ36BvBOA0xDckbKTn7xN9eVZ1AktAeBfPr6N+7Hy4Eip
         YyVhnFMPY2Z1tQu9FuSSWtBiPX53TMvHT6H7WVZbctD3LFs3nGVFvPAfkjRsKsgvCUon
         YiUFmOPSt2UKmFBf+rJ5W29MxE7uVJ/alijnUQY4ZVfGX/bEPgYgkaFMLPj6Cw5BTT/c
         8qdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V2ltZ2eIPqMpNkygV2JwHqpiEgCcB7eRr0XagT3oAd8=;
        b=njrCk75jN8F/PsnXyqeaxpAXr1YgTjoJgYn0tfXzvk4FOA8/jrBk2F9neKOzHD2pRt
         dA3W/asldEXv3R1t6eBySh6VwRqV0EWHW8Z/66GpdIsh4zD85h1KqnHFYjPBl7YI9IHT
         6NQEW34AVHzaRCbUExX+RyG+tKdgJv8ycMx89uhtEUVGvcnA4PP0m0bmjGHyVsNaiBXz
         yjnSUuYPPqT6XBIXC9nH1XvpEnCizTkbl7zVwlNvXULmIc6YMGCd7LJBeCpVCv5bvV87
         ALQl6SUuSqgsDvci72DwQ914o4UlWeCt1I9r9a7imXcveDwVQPOXObWA35q3kjHwlJcR
         jRMA==
X-Gm-Message-State: APjAAAXPjHfb2FP2U3FW7szFuvmHGfVhuXW0ZD+70Jg6CqetLio+Hbjz
        jGpDRcW+WUVJQ1VwmULP0s0IaLOw9AgvUf+LhFY=
X-Google-Smtp-Source: APXvYqznv2p20xwAt1gkQakbEI0QhBjxncGpIaXr8GCLaf/L+xsuv5W/wEWIXPKDlfzDjATYZSv3o0n7N7x8xU+3Nxs=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr1010268qke.449.1565812058330;
 Wed, 14 Aug 2019 12:47:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190814164742.208909-1-sdf@google.com> <20190814164742.208909-4-sdf@google.com>
In-Reply-To: <20190814164742.208909-4-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Aug 2019 12:47:27 -0700
Message-ID: <CAEf4BzYNQSQKrDXHvMnFZY+uapU7uou1MnE_YY-QjoBCN3qLrA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] selftests/bpf: test_progs: remove global
 fail/success counts
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 9:48 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Now that we have a global per-test/per-environment state, there
> is no longer the need to have global fail/success counters
> (and there is no need to save/get the diff before/after the
> test).
>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../selftests/bpf/prog_tests/bpf_obj_id.c     |  2 +-
>  .../bpf/prog_tests/bpf_verif_scale.c          | 10 +---
>  .../selftests/bpf/prog_tests/flow_dissector.c |  2 +-
>  .../bpf/prog_tests/get_stack_raw_tp.c         |  2 +-
>  .../selftests/bpf/prog_tests/global_data.c    | 10 ++--
>  .../selftests/bpf/prog_tests/l4lb_all.c       |  4 +-
>  .../selftests/bpf/prog_tests/map_lock.c       |  8 +--
>  .../selftests/bpf/prog_tests/pkt_access.c     |  2 +-
>  .../selftests/bpf/prog_tests/pkt_md_access.c  |  2 +-
>  .../bpf/prog_tests/queue_stack_map.c          |  4 +-
>  .../bpf/prog_tests/reference_tracking.c       |  2 +-
>  .../selftests/bpf/prog_tests/spinlock.c       |  2 +-
>  .../selftests/bpf/prog_tests/stacktrace_map.c |  2 +-
>  .../bpf/prog_tests/stacktrace_map_raw_tp.c    |  2 +-
>  .../bpf/prog_tests/task_fd_query_rawtp.c      |  2 +-
>  .../bpf/prog_tests/task_fd_query_tp.c         |  2 +-
>  .../selftests/bpf/prog_tests/tcp_estats.c     |  2 +-
>  tools/testing/selftests/bpf/prog_tests/xdp.c  |  2 +-
>  .../bpf/prog_tests/xdp_adjust_tail.c          |  2 +-
>  .../selftests/bpf/prog_tests/xdp_noinline.c   |  4 +-
>  tools/testing/selftests/bpf/test_progs.c      | 55 ++++++++-----------
>  tools/testing/selftests/bpf/test_progs.h      | 26 +++++++--
>  22 files changed, 75 insertions(+), 74 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
> index fb5840a62548..f57e0c625de3 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
> @@ -49,7 +49,7 @@ void test_bpf_obj_id(void)
>                  * to load.
>                  */
>                 if (err)
> -                       error_cnt++;
> +                       test__fail();
>                 assert(!err);
>
>                 /* Insert a magic value to the map */
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> index 1a1eae356f81..217988243077 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
> @@ -28,8 +28,6 @@ static int check_load(const char *file, enum bpf_prog_type type)
>         attr.prog_flags = BPF_F_TEST_RND_HI32;
>         err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
>         bpf_object__close(obj);
> -       if (err)
> -               error_cnt++;
>         return err;
>  }
>
> @@ -105,12 +103,8 @@ void test_bpf_verif_scale(void)
>                         continue;
>
>                 err = check_load(test->file, test->attach_type);
> -               if (test->fails) { /* expected to fail */
> -                       if (err)
> -                               error_cnt--;
> -                       else
> -                               error_cnt++;
> -               }
> +               if (err && !test->fails)
> +                       test__fail();
>         }
>
>         if (env.verifier_stats)
> diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> index 6892b88ae065..e9d882c05ded 100644
> --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> @@ -453,7 +453,7 @@ void test_flow_dissector(void)
>         err = bpf_flow_load(&obj, "./bpf_flow.o", "flow_dissector",
>                             "jmp_table", "last_dissection", &prog_fd, &keys_fd);
>         if (err) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
> index 3d59b3c841fe..afc60f62e2a8 100644
> --- a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
> @@ -137,7 +137,7 @@ void test_get_stack_raw_tp(void)
>
>         goto close_prog_noerr;
>  close_prog:
> -       error_cnt++;
> +       test__fail();
>  close_prog_noerr:
>         if (!IS_ERR_OR_NULL(link))
>                 bpf_link__destroy(link);
> diff --git a/tools/testing/selftests/bpf/prog_tests/global_data.c b/tools/testing/selftests/bpf/prog_tests/global_data.c
> index d011079fb0bf..db13bfee6bb9 100644
> --- a/tools/testing/selftests/bpf/prog_tests/global_data.c
> +++ b/tools/testing/selftests/bpf/prog_tests/global_data.c
> @@ -8,7 +8,7 @@ static void test_global_data_number(struct bpf_object *obj, __u32 duration)
>
>         map_fd = bpf_find_map(__func__, obj, "result_number");
>         if (map_fd < 0) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> @@ -45,7 +45,7 @@ static void test_global_data_string(struct bpf_object *obj, __u32 duration)
>
>         map_fd = bpf_find_map(__func__, obj, "result_string");
>         if (map_fd < 0) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> @@ -82,7 +82,7 @@ static void test_global_data_struct(struct bpf_object *obj, __u32 duration)
>
>         map_fd = bpf_find_map(__func__, obj, "result_struct");
>         if (map_fd < 0) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> @@ -113,13 +113,13 @@ static void test_global_data_rdonly(struct bpf_object *obj, __u32 duration)
>
>         map = bpf_object__find_map_by_name(obj, "test_glo.rodata");
>         if (!map || !bpf_map__is_internal(map)) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
>         map_fd = bpf_map__fd(map);
>         if (map_fd < 0) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
> index 20ddca830e68..724bb40de1f8 100644
> --- a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
> +++ b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
> @@ -31,7 +31,7 @@ static void test_l4lb(const char *file)
>
>         err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
>         if (err) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> @@ -73,7 +73,7 @@ static void test_l4lb(const char *file)
>                 pkts += stats[i].pkts;
>         }
>         if (bytes != MAGIC_BYTES * NUM_ITER * 2 || pkts != NUM_ITER * 2) {
> -               error_cnt++;
> +               test__fail();
>                 printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
>         }
>  out:
> diff --git a/tools/testing/selftests/bpf/prog_tests/map_lock.c b/tools/testing/selftests/bpf/prog_tests/map_lock.c
> index ee99368c595c..12123ff1f31f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/map_lock.c
> +++ b/tools/testing/selftests/bpf/prog_tests/map_lock.c
> @@ -10,12 +10,12 @@ static void *parallel_map_access(void *arg)
>                 err = bpf_map_lookup_elem_flags(map_fd, &key, vars, BPF_F_LOCK);
>                 if (err) {
>                         printf("lookup failed\n");
> -                       error_cnt++;
> +                       test__fail();
>                         goto out;
>                 }
>                 if (vars[0] != 0) {
>                         printf("lookup #%d var[0]=%d\n", i, vars[0]);
> -                       error_cnt++;
> +                       test__fail();
>                         goto out;
>                 }
>                 rnd = vars[1];
> @@ -24,7 +24,7 @@ static void *parallel_map_access(void *arg)
>                                 continue;
>                         printf("lookup #%d var[1]=%d var[%d]=%d\n",
>                                i, rnd, j, vars[j]);
> -                       error_cnt++;
> +                       test__fail();
>                         goto out;
>                 }
>         }
> @@ -69,7 +69,7 @@ void test_map_lock(void)
>                        ret == (void *)&map_fd[i - 4]);
>         goto close_prog_noerr;
>  close_prog:
> -       error_cnt++;
> +       test__fail();
>  close_prog_noerr:
>         bpf_object__close(obj);
>  }
> diff --git a/tools/testing/selftests/bpf/prog_tests/pkt_access.c b/tools/testing/selftests/bpf/prog_tests/pkt_access.c
> index 4ecfd721a044..9ef4e4ffb379 100644
> --- a/tools/testing/selftests/bpf/prog_tests/pkt_access.c
> +++ b/tools/testing/selftests/bpf/prog_tests/pkt_access.c
> @@ -10,7 +10,7 @@ void test_pkt_access(void)
>
>         err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
>         if (err) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/pkt_md_access.c b/tools/testing/selftests/bpf/prog_tests/pkt_md_access.c
> index ac0d43435806..c354b9d21f4f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/pkt_md_access.c
> +++ b/tools/testing/selftests/bpf/prog_tests/pkt_md_access.c
> @@ -10,7 +10,7 @@ void test_pkt_md_access(void)
>
>         err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
>         if (err) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/queue_stack_map.c b/tools/testing/selftests/bpf/prog_tests/queue_stack_map.c
> index e60cd5ff1f55..48a8cd144bd1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/queue_stack_map.c
> +++ b/tools/testing/selftests/bpf/prog_tests/queue_stack_map.c
> @@ -28,7 +28,7 @@ static void test_queue_stack_map_by_type(int type)
>
>         err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
>         if (err) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> @@ -44,7 +44,7 @@ static void test_queue_stack_map_by_type(int type)
>         for (i = 0; i < MAP_SIZE; i++) {
>                 err = bpf_map_update_elem(map_in_fd, NULL, &vals[i], 0);
>                 if (err) {
> -                       error_cnt++;
> +                       test__fail();
>                         goto out;
>                 }
>         }
> diff --git a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
> index 4a4f428d1a78..f6987e3dd28c 100644
> --- a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
> +++ b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
> @@ -11,7 +11,7 @@ void test_reference_tracking(void)
>
>         obj = bpf_object__open(file);
>         if (IS_ERR(obj)) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/spinlock.c b/tools/testing/selftests/bpf/prog_tests/spinlock.c
> index 114ebe6a438e..e843336713e8 100644
> --- a/tools/testing/selftests/bpf/prog_tests/spinlock.c
> +++ b/tools/testing/selftests/bpf/prog_tests/spinlock.c
> @@ -23,7 +23,7 @@ void test_spinlock(void)
>                        ret == (void *)&prog_fd);
>         goto close_prog_noerr;
>  close_prog:
> -       error_cnt++;
> +       test__fail();
>  close_prog_noerr:
>         bpf_object__close(obj);
>  }
> diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c
> index fc539335c5b3..9dba1cc3da60 100644
> --- a/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c
> +++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c
> @@ -70,7 +70,7 @@ void test_stacktrace_map(void)
>
>         goto disable_pmu_noerr;
>  disable_pmu:
> -       error_cnt++;
> +       test__fail();
>  disable_pmu_noerr:
>         bpf_link__destroy(link);
>  close_prog:
> diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c
> index fbfa8e76cf63..4e7cf2e663f7 100644
> --- a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c
> @@ -60,7 +60,7 @@ void test_stacktrace_map_raw_tp(void)
>
>         goto close_prog_noerr;
>  close_prog:
> -       error_cnt++;
> +       test__fail();
>  close_prog_noerr:
>         if (!IS_ERR_OR_NULL(link))
>                 bpf_link__destroy(link);
> diff --git a/tools/testing/selftests/bpf/prog_tests/task_fd_query_rawtp.c b/tools/testing/selftests/bpf/prog_tests/task_fd_query_rawtp.c
> index 958a3d88de99..d9ad1aa8a026 100644
> --- a/tools/testing/selftests/bpf/prog_tests/task_fd_query_rawtp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/task_fd_query_rawtp.c
> @@ -72,7 +72,7 @@ void test_task_fd_query_rawtp(void)
>
>         goto close_prog_noerr;
>  close_prog:
> -       error_cnt++;
> +       test__fail();
>  close_prog_noerr:
>         bpf_object__close(obj);
>  }
> diff --git a/tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c b/tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c
> index f9b70e81682b..76209f2386c8 100644
> --- a/tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c
> @@ -68,7 +68,7 @@ static void test_task_fd_query_tp_core(const char *probe_name,
>  close_pmu:
>         close(pmu_fd);
>  close_prog:
> -       error_cnt++;
> +       test__fail();
>  close_prog_noerr:
>         bpf_object__close(obj);
>  }
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_estats.c b/tools/testing/selftests/bpf/prog_tests/tcp_estats.c
> index bb8759d69099..e241e5d7c71f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcp_estats.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tcp_estats.c
> @@ -11,7 +11,7 @@ void test_tcp_estats(void)
>         err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
>         CHECK(err, "", "err %d errno %d\n", err, errno);
>         if (err) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp.c b/tools/testing/selftests/bpf/prog_tests/xdp.c
> index a74167289545..7c9f89fa1d02 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp.c
> @@ -17,7 +17,7 @@ void test_xdp(void)
>
>         err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
>         if (err) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
> index 922aa0a19764..a479a3303c3b 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
> @@ -11,7 +11,7 @@ void test_xdp_adjust_tail(void)
>
>         err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
>         if (err) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
> index 15f7c272edb0..10bef9d5ab81 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
> @@ -32,7 +32,7 @@ void test_xdp_noinline(void)
>
>         err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
>         if (err) {
> -               error_cnt++;
> +               test__fail();
>                 return;
>         }
>
> @@ -74,7 +74,7 @@ void test_xdp_noinline(void)
>                 pkts += stats[i].pkts;
>         }
>         if (bytes != MAGIC_BYTES * NUM_ITER * 2 || pkts != NUM_ITER * 2) {
> -               error_cnt++;
> +               test__fail();
>                 printf("test_xdp_noinline:FAIL:stats %lld %lld\n",
>                        bytes, pkts);
>         }
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index 1993f2ce0d23..ad90e45768ce 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -8,24 +8,6 @@
>
>  /* defined in test_progs.h */
>  struct test_env env;
> -int error_cnt, pass_cnt;
> -
> -struct prog_test_def {
> -       const char *test_name;
> -       int test_num;
> -       void (*run_test)(void);
> -       bool force_log;
> -       int pass_cnt;
> -       int error_cnt;
> -       bool tested;
> -
> -       const char *subtest_name;
> -       int subtest_num;
> -
> -       /* store counts before subtest started */
> -       int old_pass_cnt;
> -       int old_error_cnt;
> -};
>
>  static bool should_run(struct test_selector *sel, int num, const char *name)
>  {
> @@ -74,14 +56,14 @@ static const char *test_status_string(bool success)
>  void test__end_subtest()
>  {
>         struct prog_test_def *test = env.test;
> -       int sub_error_cnt = error_cnt - test->old_error_cnt;
> +       int sub_fail_cnt = test->fail_cnt - test->old_fail_cnt;
>
> -       if (sub_error_cnt)
> -               env.fail_cnt++;
> +       if (sub_fail_cnt)
> +               test->fail_cnt++;
>         else
>                 env.sub_succ_cnt++;
>
> -       dump_test_log(test, sub_error_cnt);
> +       dump_test_log(test, sub_fail_cnt);
>
>         fprintf(env.stdout, "#%3d/%-3d %4s %s:%s\n",
>                 test->test_num, test->subtest_num,
> @@ -111,8 +93,8 @@ bool test__start_subtest(const char *name)
>                 return false;
>
>         test->subtest_name = name;
> -       env.test->old_pass_cnt = pass_cnt;
> -       env.test->old_error_cnt = error_cnt;
> +       env.test->old_succ_cnt = env.test->succ_cnt;
> +       env.test->old_fail_cnt = env.test->fail_cnt;
>
>         return true;
>  }
> @@ -126,6 +108,19 @@ void test__skip(void)
>         env.skip_cnt++;
>  }
>
> +void __test__fail(const char *file, int line)
> +{
> +       if (env.test->subtest_name)
> +               fprintf(stderr, "%s:%s failed at %s:%d, errno=%d\n",

Nit: let's keep <test>/<subtest> convention here as well?

Failure doesn't always set errno, this will be quite confusing
sometimes. Especially for higher-level libbpf APIs, which don't set
errno at all.
If test wants to log additional information, let it do it explicitly.

Also, _CHECK already logs error message, so this is going to be
double-verbose for typical case. I'd say let's drop these error
messages and instead slightly extend _CHECK one with line number (it
already logs func name).

> +                       env.test->test_name, env.test->subtest_name,
> +                       file, line, errno);
> +       else
> +               fprintf(stderr, "%s failed at %s:%d, errno=%d\n",
> +                       env.test->test_name, file, line, errno);
> +
> +       env.test->fail_cnt++;
> +}
> +
>  struct ipv4_packet pkt_v4 = {
>         .eth.h_proto = __bpf_constant_htons(ETH_P_IP),
>         .iph.ihl = 5,
> @@ -150,7 +145,7 @@ int bpf_find_map(const char *test, struct bpf_object *obj, const char *name)
>         map = bpf_object__find_map_by_name(obj, name);
>         if (!map) {
>                 printf("%s:FAIL:map '%s' not found\n", test, name);
> -               error_cnt++;
> +               test__fail();
>                 return -1;
>         }
>         return bpf_map__fd(map);
> @@ -509,8 +504,6 @@ int main(int argc, char **argv)
>         stdio_hijack();
>         for (i = 0; i < prog_test_cnt; i++) {
>                 struct prog_test_def *test = &prog_test_defs[i];
> -               int old_pass_cnt = pass_cnt;
> -               int old_error_cnt = error_cnt;
>
>                 env.test = test;
>                 test->test_num = i + 1;
> @@ -525,14 +518,12 @@ int main(int argc, char **argv)
>                         test__end_subtest();
>
>                 test->tested = true;
> -               test->pass_cnt = pass_cnt - old_pass_cnt;
> -               test->error_cnt = error_cnt - old_error_cnt;
> -               if (test->error_cnt)
> +               if (test->fail_cnt)
>                         env.fail_cnt++;
>                 else
>                         env.succ_cnt++;
>
> -               dump_test_log(test, test->error_cnt);
> +               dump_test_log(test, test->fail_cnt);
>
>                 fprintf(env.stdout, "#%3d     %4s %s\n",
>                         test->test_num,
> @@ -546,5 +537,5 @@ int main(int argc, char **argv)
>         free(env.test_selector.num_set);
>         free(env.subtest_selector.num_set);
>
> -       return error_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
> +       return env.fail_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
>  }
> diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> index 9defd35cb6c0..7b05921784a4 100644
> --- a/tools/testing/selftests/bpf/test_progs.h
> +++ b/tools/testing/selftests/bpf/test_progs.h
> @@ -38,7 +38,23 @@ typedef __u16 __sum16;
>  #include "trace_helpers.h"
>  #include "flow_dissector_load.h"
>
> -struct prog_test_def;
> +struct prog_test_def {
> +       const char *test_name;
> +       int test_num;
> +       void (*run_test)(void);
> +       bool force_log;
> +       bool tested;
> +
> +       const char *subtest_name;
> +       int subtest_num;
> +
> +       int succ_cnt;
> +       int fail_cnt;

So I'm neutral on this rename, I even considered it myself initially.
But keep in mind, that succ/fail in env means number of tests, while
test->succ/fail means number of assertions. We don't report total
number of failed checks anymore, so it doesn't matter, but if we ever
want to keep track of that at env level, it will be very confusing and
inconvenient.

> +
> +       /* store counts before subtest started */
> +       int old_succ_cnt;
> +       int old_fail_cnt;
> +};

Did you move it here just to access env.test->succ_cnt in _CHECK()?
Maybe add test__success() counterpart to test__fail() instead?

>
>  struct test_selector {
>         const char *name;
> @@ -67,13 +83,13 @@ struct test_env {
>         int skip_cnt; /* skipped tests */
>  };
>
> -extern int error_cnt;
> -extern int pass_cnt;
>  extern struct test_env env;
>
>  extern void test__force_log();
>  extern bool test__start_subtest(const char *name);
>  extern void test__skip(void);
> +#define test__fail() __test__fail(__FILE__, __LINE__)
> +extern void __test__fail(const char *file, int line);

Given my comment above about too verbose logging, I'd say let's keep
this simple and have just

extern void test__fail()

And let _CHECK log file:line.

>
>  #define MAGIC_BYTES 123
>
> @@ -96,11 +112,11 @@ extern struct ipv6_packet pkt_v6;
>  #define _CHECK(condition, tag, duration, format...) ({                 \
>         int __ret = !!(condition);                                      \
>         if (__ret) {                                                    \
> -               error_cnt++;                                            \
> +               test__fail();                                           \
>                 printf("%s:FAIL:%s ", __func__, tag);                   \
>                 printf(format);                                         \
>         } else {                                                        \
> -               pass_cnt++;                                             \
> +               env.test->succ_cnt++;                                   \
>                 printf("%s:PASS:%s %d nsec\n",                          \
>                        __func__, tag, duration);                        \
>         }                                                               \
> --
> 2.23.0.rc1.153.gdeed80330f-goog
>
