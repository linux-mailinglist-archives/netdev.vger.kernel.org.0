Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0648DDDB
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfHNTW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:22:57 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42465 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbfHNTW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 15:22:57 -0400
Received: by mail-qt1-f195.google.com with SMTP id t12so22823893qtp.9;
        Wed, 14 Aug 2019 12:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FdjoHE4taOBR0jCzn/MF7g5quTsurfrYzPaBv3Zz6nc=;
        b=dZtqGBXQqHpkiZK/MLwzhUi/vkVxbCbhDJjTF0WeKdU8hb2JFSZyJwNdM2GkPVhrFp
         NOzF5SU7bVm5Q2fZPaM4ynrRyUDZJL2KhSE4k0zkkf2WKgzT2lboavn9V13li80VtL9A
         43oO4y8T8H+K2gU5snp63Qz48sMch9uznC2jO8tUHwvW+zeYN33EmiVHIUg5Htx1Up4I
         67p+aPtb8ws7xnIP4kjVNiMrAQKNdLxju6L0k8LmCeF8uDbQ8R7+vGG72/V1aCWEse1u
         7ZJNiP+Ww/vKua0Rd0J5JtHq0fEvkGFEgD/xxZs/s5EEGpH36L9lpEFd78YL7E7Fb9Yh
         xRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FdjoHE4taOBR0jCzn/MF7g5quTsurfrYzPaBv3Zz6nc=;
        b=mK/3QB3kZ79+EluznsuECvxNMsFKzY6bhnwyg/uQDutsN4lrgXL+Avsqfiv5jN2+Kh
         sU43HidpOTDhFYL4uZaX7x/sx9Kr1tMhfHHY1HIrbhH9tTgF4TxjvK2x1s0Tj9sqlGWh
         tz7fYAl+pjvXTuRqPc37rn+BA73ighelnc9V4IoKwq/Xjq6XLVV4vc3VjAQyEA4HXeoA
         ywrwztwoEw1xaQV7MJon+RDN2ozzJiPWE0IGFvm2sipjjesDXmd1hZfAwuRWt9NO/N5I
         RCSqoO/qPZW3evuLfWPB0ipq9DnTDlP3u40XVBQClcnFNwnpYD0Y4xL8ViK24zv5DW6B
         d7Gw==
X-Gm-Message-State: APjAAAXYDMbQsJJHSmz/klgKCQJIATA4IQifZ53VNHaz9/igOCWtMkbd
        LSZzc1+Wd0R8zEX6r+bGmpByE3dTaJfVLQaDiy0=
X-Google-Smtp-Source: APXvYqyFo7HXqHcICHQOvrm+ByLMYBOipRDTyBwtFAcVd+P1q3J57Rsn+pPq9pVKVDXthVrv96IvgeuN7yaTzfQJhUI=
X-Received: by 2002:ac8:488a:: with SMTP id i10mr832791qtq.93.1565810576242;
 Wed, 14 Aug 2019 12:22:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190814164742.208909-1-sdf@google.com> <20190814164742.208909-3-sdf@google.com>
In-Reply-To: <20190814164742.208909-3-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Aug 2019 12:22:45 -0700
Message-ID: <CAEf4BzZR12JgbSvBqS7LMZjLcsneVDfFL9XyZdi3gtneyA9X9g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] selftests/bpf: test_progs: test__skip
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
> Export test__skip() to indicate skipped tests and use it in
> test_send_signal_nmi().
>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

For completeness, we should probably also support test__skip_subtest()
eventually, but it's fine until we don't have a use case.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/prog_tests/send_signal.c | 1 +
>  tools/testing/selftests/bpf/test_progs.c             | 9 +++++++--
>  tools/testing/selftests/bpf/test_progs.h             | 2 ++
>  3 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> index 1575f0a1f586..40c2c5efdd3e 100644
> --- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
> +++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> @@ -204,6 +204,7 @@ static int test_send_signal_nmi(void)
>                 if (errno == ENOENT) {
>                         printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n",
>                                __func__);
> +                       test__skip();
>                         return 0;
>                 }
>                 /* Let the test fail with a more informative message */
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index 1a7a2a0c0a11..1993f2ce0d23 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -121,6 +121,11 @@ void test__force_log() {
>         env.test->force_log = true;
>  }
>
> +void test__skip(void)
> +{
> +       env.skip_cnt++;
> +}
> +
>  struct ipv4_packet pkt_v4 = {
>         .eth.h_proto = __bpf_constant_htons(ETH_P_IP),
>         .iph.ihl = 5,
> @@ -535,8 +540,8 @@ int main(int argc, char **argv)
>                         test->test_name);
>         }
>         stdio_restore();
> -       printf("Summary: %d/%d PASSED, %d FAILED\n",
> -              env.succ_cnt, env.sub_succ_cnt, env.fail_cnt);
> +       printf("Summary: %d/%d PASSED, %d SKIPPED, %d FAILED\n",
> +              env.succ_cnt, env.sub_succ_cnt, env.skip_cnt, env.fail_cnt);
>
>         free(env.test_selector.num_set);
>         free(env.subtest_selector.num_set);
> diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> index 37d427f5a1e5..9defd35cb6c0 100644
> --- a/tools/testing/selftests/bpf/test_progs.h
> +++ b/tools/testing/selftests/bpf/test_progs.h
> @@ -64,6 +64,7 @@ struct test_env {
>         int succ_cnt; /* successful tests */
>         int sub_succ_cnt; /* successful sub-tests */
>         int fail_cnt; /* total failed tests + sub-tests */
> +       int skip_cnt; /* skipped tests */
>  };
>
>  extern int error_cnt;
> @@ -72,6 +73,7 @@ extern struct test_env env;
>
>  extern void test__force_log();
>  extern bool test__start_subtest(const char *name);
> +extern void test__skip(void);
>
>  #define MAGIC_BYTES 123
>
> --
> 2.23.0.rc1.153.gdeed80330f-goog
>
