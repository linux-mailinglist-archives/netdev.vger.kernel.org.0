Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A765B83786
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732615AbfHFRB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:01:28 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40178 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730505AbfHFRB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:01:28 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so38052434pla.7
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N0WMWmlltUCAfn94gx9u/cPNFJoC4aZ+kEnNI7ES6AM=;
        b=HhL9dmkaEYsoC9Qxm77tHafP5jKKjc0uJZuI/1kRCwOXQ8Snbi4H4ryQWtkcYXLSHt
         fryy90Cmv2ACU30O3UqrVLz+sFbwhqQJ0aPjEFfmRpgGOWV4RbYFbpy7RVoEl6nJsy6p
         w6r0vK+h2q6JZ35Us2N362uMMXWtJFwJ+vbOMwS+X7JsK1S7ZzC4HvJbEVZtwsa5WWst
         U6Qd7AQnzdsImj8er6+MBTR1GHfghjsmPQBxjnnv8Ps73LmWdEa0IqZGo8Gdk8adJEYt
         NkVRG1RWxRzc0SCH5pviFFTv4lT+ZIlHavKzVZdIwUNNADtaJMN+umqwg/jPRZHzydca
         n9EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N0WMWmlltUCAfn94gx9u/cPNFJoC4aZ+kEnNI7ES6AM=;
        b=d+29bMPUE+Dqt5BCAdpkyGNUKDAVrNk1GSOBuTqLvE56OCdNJ45ov/bHNKP4kIu4DE
         62elnLosKUm8M2JYLwBD8Bf7V4PwIh8wXMdwpVD3+OzTHPYOqInnqyuJiYd6hAeaKho7
         YkR5MJPwDR5EOpG5vwgAYFGM0Z/ezLh1uJdCU/mURurYjUTh4/JN/vz8Vn8jwYUz+SzD
         oZ3MO737GPF6xpADWMRe16d9VOuNeOOxqRQkkzTsqMcxRu+uv4y97LrVksuSxyFiBIeZ
         xDr7nZpYgfESmMe8wBKC/ZUhX1z8cliBg0M/2ASmcWL/cE6SnVoIuIsOAmllTPlhMQy0
         qH3A==
X-Gm-Message-State: APjAAAXpymr8Psf7oJbRWH5HtIdGbVWETI9wbmxlbV4Z7zPalCaWkbdo
        zbJhC2+Qe8Kzz8wiWGLE1xCPfQ==
X-Google-Smtp-Source: APXvYqxT2SHMZtzy7foAsVyyOWSXdDqWbKhnRL2jQMcFYuGTWmqhd4yBOmLVNYNgFIrc6Qtd2aQJZw==
X-Received: by 2002:a17:902:76c6:: with SMTP id j6mr4143554plt.102.1565110887594;
        Tue, 06 Aug 2019 10:01:27 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id d14sm106554018pfo.154.2019.08.06.10.01.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 10:01:26 -0700 (PDT)
Date:   Tue, 6 Aug 2019 10:01:26 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v3 1/3] selftests/bpf: test_progs: switch to
 open_memstream
Message-ID: <20190806170126.GA23939@mini-arch>
References: <20190805154055.197664-1-sdf@google.com>
 <20190805154055.197664-2-sdf@google.com>
 <CAEf4BzYmhLU1E4gFg8cGcx0_JOF_qW21zoFAYOTq0v1_TnkJEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYmhLU1E4gFg8cGcx0_JOF_qW21zoFAYOTq0v1_TnkJEA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/06, Andrii Nakryiko wrote:
> On Mon, Aug 5, 2019 at 8:41 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Use open_memstream to override stdout during test execution.
> > The copy of the original stdout is held in env.stdout and used
> > to print subtest info and dump failed log.
> >
> > test_{v,}printf are now simple wrappers around stdout and will be
> > removed in the next patch.
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
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> 
> Thanks a lot, this looks very good. Just please let's do one field per
> line in structs (see below).
Sure, no problem, will respin v4 with a fix shortly. Thanks for review!

> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> 
> >  tools/testing/selftests/bpf/test_progs.c | 115 ++++++++++++-----------
> >  tools/testing/selftests/bpf/test_progs.h |   2 +-
> >  2 files changed, 61 insertions(+), 56 deletions(-)
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
> > index afd14962456f..4c00fc79ac5f 100644
> > --- a/tools/testing/selftests/bpf/test_progs.h
> > +++ b/tools/testing/selftests/bpf/test_progs.h
> > @@ -56,9 +56,9 @@ struct test_env {
> >         bool jit_enabled;
> >
> >         struct prog_test_def *test;
> > +       FILE *stdout, *stderr;
> 
> Please, let's not do this in structs: one field per line.
> 
> >         char *log_buf;
> >         size_t log_cnt;
> > -       size_t log_cap;
> >
> >         int succ_cnt; /* successful tests */
> >         int sub_succ_cnt; /* successful sub-tests */
> > --
> > 2.22.0.770.g0f2c4a37fd-goog
> >
