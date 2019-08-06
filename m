Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827DD83815
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387851AbfHFRkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:40:31 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44174 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387841AbfHFRkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:40:31 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so38127511plr.11
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TK0wYamS2JXS88Z21zoenyvzAjfhaTnLP7+GE6cMP2A=;
        b=Qka49AaclSf9VS34zXoQQrT+4NEDWVUBG3yHP+E2di/ouu00OJHJsMkRo8cwj4E5Bs
         lAPQ2iDfY+TtgacIC56SVaYGWM9zon4xiCcRu1OICe4TVnpvXI+ez1uPl/AvFTV+2ipX
         Ws9cOZeuT1wCH1hMgSu5kY8Mv82zaXSPQEoap3xxzhkmCasoYTjmAj7BMmxYASbRAiJ7
         ajG027b+jzwSO8v1jdUl3IQPEKZLbWJ2mJ05HkMkjW5nqtJ4Dws51Pmw8AE/4se/sTsg
         vtnBG0mU2bP8rhyRniqPoT7758n/iHnBttFM9MqnwgkD671RCtg15A8PzTwB4syDIr1c
         Y3cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TK0wYamS2JXS88Z21zoenyvzAjfhaTnLP7+GE6cMP2A=;
        b=px12yaU2a6JzDzdD/OljR6zt9t7OWqr5rPki9EcyJJ127LlwtSqkFWumB6KOrxy/4p
         l0VJV2OvGLDnOA/mzMNqNugZIIWxyWlx+EOVCStEysYmI10gXoUXU8Z69HR+aEnt6Di2
         PeGfMTzKo3zxSPX743EAMT3nub+Za9vHsf3ljH5U+JGSUOdPK9XnR0kA9YPdhXMEl/SD
         3obLorQuPJJQL9k3FSNKiPdGPyI6N+2tQNmRQ31fntBH4THlnhX2n3ggh7lNsWstHn+p
         vhKO438S7dKb67vUFkvinyyI8fIWX0PdBBQleuPJbHSp75iWehSBB2Y2nFlBaTFsonGX
         lgOw==
X-Gm-Message-State: APjAAAXYtmNSCmO681JLqM+4AA3c3YCypcwAjguKdkgqrBqoAvkOrJZz
        uyxDNWI1tD/RUgZkV4Qg+GfVKuw3mqw=
X-Google-Smtp-Source: APXvYqw7HuUzAWWJdoWDtzfIxafMzF+HPf4uHNN2obGC2Oxp9nxwgiCQbrgNWIkZUc7oHCJAHSf7EQ==
X-Received: by 2002:a17:902:d892:: with SMTP id b18mr3981657plz.165.1565113230076;
        Tue, 06 Aug 2019 10:40:30 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id r1sm81905684pgv.70.2019.08.06.10.40.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 10:40:29 -0700 (PDT)
Date:   Tue, 6 Aug 2019 10:40:28 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v4 1/3] selftests/bpf: test_progs: switch to
 open_memstream
Message-ID: <20190806174028.GB23939@mini-arch>
References: <20190806170901.142264-1-sdf@google.com>
 <20190806170901.142264-2-sdf@google.com>
 <CAEf4BzYU6xfcPrHzz0p6dWL3_VM2mD9pKy3T-NfnuDUrd4RMDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYU6xfcPrHzz0p6dWL3_VM2mD9pKy3T-NfnuDUrd4RMDQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/06, Andrii Nakryiko wrote:
> On Tue, Aug 6, 2019 at 10:19 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Use open_memstream to override stdout during test execution.
> > The copy of the original stdout is held in env.stdout and used
> > to print subtest info and dump failed log.
> >
> > test_{v,}printf are now simple wrappers around stdout and will be
> > removed in the next patch.
> >
> > v4:
> > * one field per line for stdout/stderr (Andrii Nakryiko)
> >
> > v3:
> > * don't do strlen over log_buf, log_cnt has it already (Andrii Nakryiko)
> >
> > v2:
> > * add ifdef __GLIBC__ around open_memstream (maybe pointless since
> >   we already depend on glibc for argp_parse)
> > * hijack stderr as well (Andrii Nakryiko)
> > * don't hijack for every test, do it once (Andrii Nakryiko)
> > * log_cap -> log_size (Andrii Nakryiko)
> > * do fseeko in a proper place (Andrii Nakryiko)
> > * check open_memstream returned value (Andrii Nakryiko)
> >
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/testing/selftests/bpf/test_progs.c | 115 ++++++++++++-----------
> >  tools/testing/selftests/bpf/test_progs.h |   3 +-
> >  2 files changed, 62 insertions(+), 56 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > index db00196c8315..9556439c607c 100644
> > --- a/tools/testing/selftests/bpf/test_progs.c
> > +++ b/tools/testing/selftests/bpf/test_progs.c
> > @@ -40,14 +40,20 @@ static bool should_run(struct test_selector *sel, int num, const char *name)
> >
> >  static void dump_test_log(const struct prog_test_def *test, bool failed)
> >  {
> > +       if (stdout == env.stdout)
> > +               return;
> > +
> > +       fflush(stdout); /* exports env.log_buf & env.log_cnt */
> > +
> >         if (env.verbose || test->force_log || failed) {
> >                 if (env.log_cnt) {
> > -                       fprintf(stdout, "%s", env.log_buf);
> > +                       fprintf(env.stdout, "%s", env.log_buf);
> >                         if (env.log_buf[env.log_cnt - 1] != '\n')
> > -                               fprintf(stdout, "\n");
> > +                               fprintf(env.stdout, "\n");
> >                 }
> >         }
> > -       env.log_cnt = 0;
> > +
> > +       fseeko(stdout, 0, SEEK_SET); /* rewind */
> >  }
> >
> >  void test__end_subtest()
> > @@ -62,7 +68,7 @@ void test__end_subtest()
> >
> >         dump_test_log(test, sub_error_cnt);
> >
> > -       printf("#%d/%d %s:%s\n",
> > +       fprintf(env.stdout, "#%d/%d %s:%s\n",
> >                test->test_num, test->subtest_num,
> >                test->subtest_name, sub_error_cnt ? "FAIL" : "OK");
> >  }
> > @@ -79,7 +85,8 @@ bool test__start_subtest(const char *name)
> >         test->subtest_num++;
> >
> >         if (!name || !name[0]) {
> > -               fprintf(stderr, "Subtest #%d didn't provide sub-test name!\n",
> > +               fprintf(env.stderr,
> > +                       "Subtest #%d didn't provide sub-test name!\n",
> >                         test->subtest_num);
> >                 return false;
> >         }
> > @@ -100,53 +107,7 @@ void test__force_log() {
> >
> >  void test__vprintf(const char *fmt, va_list args)
> >  {
> > -       size_t rem_sz;
> > -       int ret = 0;
> > -
> > -       if (env.verbose || (env.test && env.test->force_log)) {
> > -               vfprintf(stderr, fmt, args);
> > -               return;
> > -       }
> > -
> > -try_again:
> > -       rem_sz = env.log_cap - env.log_cnt;
> > -       if (rem_sz) {
> > -               va_list ap;
> > -
> > -               va_copy(ap, args);
> > -               /* we reserved extra byte for \0 at the end */
> > -               ret = vsnprintf(env.log_buf + env.log_cnt, rem_sz + 1, fmt, ap);
> > -               va_end(ap);
> > -
> > -               if (ret < 0) {
> > -                       env.log_buf[env.log_cnt] = '\0';
> > -                       fprintf(stderr, "failed to log w/ fmt '%s'\n", fmt);
> > -                       return;
> > -               }
> > -       }
> > -
> > -       if (!rem_sz || ret > rem_sz) {
> > -               size_t new_sz = env.log_cap * 3 / 2;
> > -               char *new_buf;
> > -
> > -               if (new_sz < 4096)
> > -                       new_sz = 4096;
> > -               if (new_sz < ret + env.log_cnt)
> > -                       new_sz = ret + env.log_cnt;
> > -
> > -               /* +1 for guaranteed space for terminating \0 */
> > -               new_buf = realloc(env.log_buf, new_sz + 1);
> > -               if (!new_buf) {
> > -                       fprintf(stderr, "failed to realloc log buffer: %d\n",
> > -                               errno);
> > -                       return;
> > -               }
> > -               env.log_buf = new_buf;
> > -               env.log_cap = new_sz;
> > -               goto try_again;
> > -       }
> > -
> > -       env.log_cnt += ret;
> > +       vprintf(fmt, args);
> >  }
> >
> >  void test__printf(const char *fmt, ...)
> > @@ -477,6 +438,48 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
> >         return 0;
> >  }
> >
> > +static void stdio_hijack(void)
> > +{
> > +#ifdef __GLIBC__
> > +       if (env.verbose || (env.test && env.test->force_log)) {
> 
> I just also realized that you don't need `(env.test &&
> env.test->force_log)` test. We hijack stdout/stderr before env.test is
> even set, so this does nothing anyways. Plus, force_log can be set in
> the middle of test/sub-test, yet we hijack stdout just once (or even
> if per-test), so it's still going to be "racy". Let's buffer output
> (unless it's env.verbose, which is important to not buffer because
> some tests will have huge output, when failing, so this allows to
> bypass using tons of memory for those, when debugging) and dump at the
> end.
Makes sense, will drop this test and resubmit along with a fix for '-v'
that Alexei discovered. Thanks!

> > +               /* nothing to do, output to stdout by default */
> > +               return;
> > +       }
> > +
> > +       /* stdout and stderr -> buffer */
> > +       fflush(stdout);
> > +
> > +       env.stdout = stdout;
> > +       env.stderr = stderr;
> > +
> > +       stdout = open_memstream(&env.log_buf, &env.log_cnt);
> > +       if (!stdout) {
> > +               stdout = env.stdout;
> > +               perror("open_memstream");
> > +               return;
> > +       }
> > +
> > +       stderr = stdout;
> > +#endif
> > +}
> > +
> > +static void stdio_restore(void)
> > +{
> > +#ifdef __GLIBC__
> > +       if (stdout == env.stdout)
> > +               return;
> > +
> > +       fclose(stdout);
> > +       free(env.log_buf);
> > +
> > +       env.log_buf = NULL;
> > +       env.log_cnt = 0;
> > +
> > +       stdout = env.stdout;
> > +       stderr = env.stderr;
> > +#endif
> > +}
> > +
> >  int main(int argc, char **argv)
> >  {
> >         static const struct argp argp = {
> > @@ -496,6 +499,7 @@ int main(int argc, char **argv)
> >
> >         env.jit_enabled = is_jit_enabled();
> >
> > +       stdio_hijack();
> >         for (i = 0; i < prog_test_cnt; i++) {
> >                 struct prog_test_def *test = &prog_test_defs[i];
> >                 int old_pass_cnt = pass_cnt;
> > @@ -523,13 +527,14 @@ int main(int argc, char **argv)
> >
> >                 dump_test_log(test, test->error_cnt);
> >
> > -               printf("#%d %s:%s\n", test->test_num, test->test_name,
> > -                      test->error_cnt ? "FAIL" : "OK");
> > +               fprintf(env.stdout, "#%d %s:%s\n",
> > +                       test->test_num, test->test_name,
> > +                       test->error_cnt ? "FAIL" : "OK");
> >         }
> > +       stdio_restore();
> >         printf("Summary: %d/%d PASSED, %d FAILED\n",
> >                env.succ_cnt, env.sub_succ_cnt, env.fail_cnt);
> >
> > -       free(env.log_buf);
> >         free(env.test_selector.num_set);
> >         free(env.subtest_selector.num_set);
> >
> > diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> > index afd14962456f..541f9eab5eed 100644
> > --- a/tools/testing/selftests/bpf/test_progs.h
> > +++ b/tools/testing/selftests/bpf/test_progs.h
> > @@ -56,9 +56,10 @@ struct test_env {
> >         bool jit_enabled;
> >
> >         struct prog_test_def *test;
> > +       FILE *stdout;
> > +       FILE *stderr;
> >         char *log_buf;
> >         size_t log_cnt;
> > -       size_t log_cap;
> >
> >         int succ_cnt; /* successful tests */
> >         int sub_succ_cnt; /* successful sub-tests */
> > --
> > 2.22.0.770.g0f2c4a37fd-goog
> >
