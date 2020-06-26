Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA5C20BCDE
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgFZWpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgFZWpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:45:15 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF06AC03E979;
        Fri, 26 Jun 2020 15:45:15 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 145so7803203qke.9;
        Fri, 26 Jun 2020 15:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JOWRcyY9gvpW3nOyF3LW36rst3A+5ICBETxqyuINX4E=;
        b=SK1wqZuj+ij/rBmmw0cHun4LNs56Aeq/otCXRr258jB+ek7yfkAbQYMa5YuveAPKli
         6DSEXqdj61CHuitAIFRKL65UEug11WMXW6UyCDKJEQ6aujX1zIjZ9dBLU/lrK3FfXena
         4IRoBp3e3HRApMcZ9CqYp8+fKi45/mSs4KORhRGrCgRPFDg+92OB7kzJuY7q1WvrTFqE
         0E2DYhxbKB6SIb/4eHpUzVNtBnJbeFTRPHGMUL0ewv80FUZ6YRJOmr6Hp8prhdtz660c
         LvBB+bdwpvv2+1O8fyMrCWxu145oD21S0Euw0wITFONuB9RCaWUDVP7E+mkTJfNPF1Zu
         mMFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JOWRcyY9gvpW3nOyF3LW36rst3A+5ICBETxqyuINX4E=;
        b=MSscgeHWwGCHux3Lx+SsQnYNF4E/F3rMi1/5P/ldOgwKdzYUAwauM/Vw4bbMc4wv8Z
         RVsXdn+CPa5dnwuratqn+r8KF30U43tXbLhYAWp+J48NFBNdeB56x6r7YyaS5bB+Wxj7
         ICsvXwH9iGtBwo9sTF2o9u/x3MgZ4sy81dQj03bFawVT6QJ0+XEekAev0AZxgR9mH6cB
         /XOya8U2lwrPY0FHM6/+o4fy8cUSPrmd1kpUC1661LPTXKpqhXz/HoIakyKc3ggEKrE5
         8edjI5dC3D+DH1wUN13OQx+16E13yoZXJd7VA8oGKZICX49/seBUngiTWbPMpJwozyLt
         ilKQ==
X-Gm-Message-State: AOAM5318QkrLKO4RPkUVZbde6XxybMtXjg1JKxvqVQ0I3rLyRmwCQvdB
        Sn1/WSt7/xZVykxiLgoYOtd2EIbQFElP+5gWu4M=
X-Google-Smtp-Source: ABdhPJxSmGUWdD4CBVH4cuMnLOH/6F6O147csKqvSDbL2ts9nUQw7/M9UBCOc2YWtVA3s8GATIUQhqLIyJZb7znTEWI=
X-Received: by 2002:a37:270e:: with SMTP id n14mr4369946qkn.92.1593211514964;
 Fri, 26 Jun 2020 15:45:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200626175501.1459961-1-kafai@fb.com> <20200626175545.1462191-1-kafai@fb.com>
In-Reply-To: <20200626175545.1462191-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 15:45:04 -0700
Message-ID: <CAEf4BzZ3Jb296zJ7bfsntk7v5fkynrBcKncGQgrSHJ2zqifgsA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/10] bpf: selftests: Restore netns after each test
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Networking <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 10:56 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> It is common for networking tests creating its netns and making its own
> setting under this new netns (e.g. changing tcp sysctl).  If the test
> forgot to restore to the original netns, it would affect the
> result of other tests.
>
> This patch saves the original netns at the beginning and then restores it
> after every test.  Since the restore "setns()" is not expensive, it does it
> on all tests without tracking if a test has created a new netns or not.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  tools/testing/selftests/bpf/test_progs.c | 21 +++++++++++++++++++++
>  tools/testing/selftests/bpf/test_progs.h |  2 ++
>  2 files changed, 23 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index 54fa5fa688ce..b521ce366381 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -121,6 +121,24 @@ static void reset_affinity() {
>         }
>  }
>
> +static void save_netns(void)
> +{
> +       env.saved_netns_fd = open("/proc/self/ns/net", O_RDONLY);
> +       if (env.saved_netns_fd == -1) {
> +               perror("open(/proc/self/ns/net)");
> +               exit(-1);
> +       }
> +}
> +
> +static void restore_netns(void)
> +{
> +       if (setns(env.saved_netns_fd, CLONE_NEWNET) == -1) {
> +               stdio_restore();
> +               perror("setns(CLONE_NEWNS)");
> +               exit(-1);
> +       }
> +}
> +
>  void test__end_subtest()
>  {
>         struct prog_test_def *test = env.test;
> @@ -643,6 +661,7 @@ int main(int argc, char **argv)
>                 return -1;
>         }
>
> +       save_netns();

you should probably do this also after each sub-test in test__end_subtest()?

Otherwise everything looks good.

>         stdio_hijack();
>         for (i = 0; i < prog_test_cnt; i++) {
>                 struct prog_test_def *test = &prog_test_defs[i];
> @@ -673,6 +692,7 @@ int main(int argc, char **argv)
>                         test->error_cnt ? "FAIL" : "OK");
>
>                 reset_affinity();
> +               restore_netns();
>                 if (test->need_cgroup_cleanup)
>                         cleanup_cgroup_environment();
>         }
> @@ -686,6 +706,7 @@ int main(int argc, char **argv)
>         free_str_set(&env.subtest_selector.blacklist);
>         free_str_set(&env.subtest_selector.whitelist);
>         free(env.subtest_selector.num_set);
> +       close(env.saved_netns_fd);
>
>         return env.fail_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
>  }
> diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> index f4503c926aca..b80924603918 100644
> --- a/tools/testing/selftests/bpf/test_progs.h
> +++ b/tools/testing/selftests/bpf/test_progs.h
> @@ -78,6 +78,8 @@ struct test_env {
>         int sub_succ_cnt; /* successful sub-tests */
>         int fail_cnt; /* total failed tests + sub-tests */
>         int skip_cnt; /* skipped tests */
> +
> +       int saved_netns_fd;
>  };
>
>  extern struct test_env env;
> --
> 2.24.1
>
