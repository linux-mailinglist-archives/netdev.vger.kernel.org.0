Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D7981FE2
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbfHEPMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:12:41 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34660 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728952AbfHEPMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 11:12:41 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so33678938pgc.1
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 08:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ut9SyAz9j3bPzo743Ce9ZAZaLnIVIv3122HDbgDu9aQ=;
        b=plFj+inST0l3DGGataitH0pcBmfVASmDsgn+cqk8aoxAG1ZVj1Y7mjDrnfZ80LSfqr
         a6ExQwF9bZbmu8LR0UUMFCiRuDe3kfoGPAcPLgYpKOaFwYtf9y/+8zGRn0jWyu69YvXP
         szPpqDy+5GgHTwVBeT9Rz88bYfjTE4BgoW6JvxD0sTYoxhrISSo6mSC913E1id9NAlP7
         Q3zGVYPhyM7FpBIHV1UyE1jZ5QP7Ff/aVOOzrmNM6FuDXQuRjmV5L0yjewEQru1MXJsU
         eLpBJXRI4BD+k0RU/cOWtvXIzKae7UIgO+ahtX5D+9FMDLLTtdCTpAxJwxWmLxeJ5/6F
         UraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ut9SyAz9j3bPzo743Ce9ZAZaLnIVIv3122HDbgDu9aQ=;
        b=tx/7oX6OrBSwUjx5BwYRIDgx0bCyxylIKNtPgrXBwfXyc9kq1F09OltEHwV623vDrl
         ICSeyEACxa0poUQLxsuQsL3JHzyZzHAnloxxdCc8BMZLHVNKfZnDJrZoC7lvDeMXTGfV
         16Cw6PKk84pwIKWo71dPyM5hwWj1wVCg/ZHGZ1FR5XQq5e1haDWu43broUsPQW8YfVNO
         WEzny0YmcesQDhuMtSkE6USYMOJCeDDzHw1YCxheFkXMyO5Puh+EB73rLYIpSAuwSExc
         kzblE/Y0omOcsVGavLgozRtUdFbOPYYTE9KfpeqTTU+feUSVejuJIDkpx7vYldgIySJl
         dZFw==
X-Gm-Message-State: APjAAAV+9xV9DpMhgLW1F2qjl+UlQyjJTeOjDQr+/1INVlsMguOAeyug
        BjcsbeWkb81HAq1zIeeBZu8=
X-Google-Smtp-Source: APXvYqxfiWwxW7uIj+EM3xtDV83FPbWyLAFZRWCRdVrRS+3pYUJhdJtsCriapHNXDlMYHVnR6NMlnw==
X-Received: by 2002:aa7:9210:: with SMTP id 16mr75593145pfo.11.1565017960464;
        Mon, 05 Aug 2019 08:12:40 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id w22sm89558260pfi.175.2019.08.05.08.12.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 08:12:39 -0700 (PDT)
Date:   Mon, 5 Aug 2019 08:12:38 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: test_progs: switch to
 open_memstream
Message-ID: <20190805151238.GD4544@mini-arch>
References: <20190802171710.11456-1-sdf@google.com>
 <20190802171710.11456-2-sdf@google.com>
 <80957794-de90-b09b-89ef-6094d6357d9e@fb.com>
 <20190802201456.GB4544@mini-arch>
 <CAEf4BzYV31v6ch-k+ZCQr1RaBuGComt9C0dQjFV1Es42qXz-8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYV31v6ch-k+ZCQr1RaBuGComt9C0dQjFV1Es42qXz-8Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02, Andrii Nakryiko wrote:
> On Fri, Aug 2, 2019 at 1:14 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 08/02, Andrii Nakryiko wrote:
> > > On 8/2/19 10:17 AM, Stanislav Fomichev wrote:
> > > > Use open_memstream to override stdout during test execution.
> > > > The copy of the original stdout is held in env.stdout and used
> > > > to print subtest info and dump failed log.
> > >
> > > I really like the idea. I didn't know about open_memstream, it's awesome. Thanks!
> > One possible downside of using open_memstream is that it's glibc
> > specific. I probably need to wrap it in #ifdef __GLIBC__ to make
> > it work with other libcs and just print everything as it was before :-(.
> > I'm not sure we care though.
> 
> Given this is selftests/bpf, it is probably OK.
> 
> >
> > > > test_{v,}printf are now simple wrappers around stdout and will be
> > > > removed in the next patch.
> > > >
> > > > Cc: Andrii Nakryiko <andriin@fb.com>
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  tools/testing/selftests/bpf/test_progs.c | 100 ++++++++++-------------
> > > >  tools/testing/selftests/bpf/test_progs.h |   2 +-
> > > >  2 files changed, 46 insertions(+), 56 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > > > index db00196c8315..00d1565d01a3 100644
> > > > --- a/tools/testing/selftests/bpf/test_progs.c
> > > > +++ b/tools/testing/selftests/bpf/test_progs.c
> > > > @@ -40,14 +40,22 @@ static bool should_run(struct test_selector *sel, int num, const char *name)
> > > >
> > > >  static void dump_test_log(const struct prog_test_def *test, bool failed)
> > > >  {
> > > > -   if (env.verbose || test->force_log || failed) {
> > > > -           if (env.log_cnt) {
> > > > -                   fprintf(stdout, "%s", env.log_buf);
> > > > -                   if (env.log_buf[env.log_cnt - 1] != '\n')
> > > > -                           fprintf(stdout, "\n");
> > > > +   if (stdout == env.stdout)
> > > > +           return;
> > > > +
> > > > +   fflush(stdout); /* exports env.log_buf & env.log_cap */
> > > > +
> > > > +   if (env.log_cap && (env.verbose || test->force_log || failed)) {
> > > > +           int len = strlen(env.log_buf);
> > >
> > > env.log_cap is not really a capacity, it's actual number of bytes (without terminating zero), so there is no need to do strlen and it's probably better to rename env.log_cap into env.log_cnt.
> > I'll rename it to log_size to match open_memstream args.
> > We probably still need to do strlen because open_memstream can allocate
> > bigger buffer to hold the data.
> 
> If I read man page correctly, env.log_cnt will be exactly the value
> that strlen will return - number of actual bytes written (omitting
> terminal zero), not number of pre-allocated bytes, thus I'm saying
> that strlen is redundant. Please take a look again.
Yeah, you're right, I've played with it a bit and it does return the
length of the data, not the (possibly bigger) size of the buffer.
Will fix in a v3 and use log_cnt.

> >
> > > > +
> > > > +           if (len) {
> > > > +                   fprintf(env.stdout, "%s", env.log_buf);
> > > > +                   if (env.log_buf[len - 1] != '\n')
> > > > +                           fprintf(env.stdout, "\n");
> > > > +
> > > > +                   fseeko(stdout, 0, SEEK_SET);
> > > Same bug as I already fixed with env.log_cnt = 0 being inside this if. You want to do seek always, not just when you print output log.
> > SG, will move to where we currently clear log_cnt, thanks!
> >
> > > >  /* rewind */
> > > >             }
> > > >     }
> > > > -   env.log_cnt = 0;
> > > >  }
> > > >
> > > >  void test__end_subtest()
> > > > @@ -62,7 +70,7 @@ void test__end_subtest()
> > > >
> > > >     dump_test_log(test, sub_error_cnt);
> > > >
> > > > -   printf("#%d/%d %s:%s\n",
> > > > +   fprintf(env.stdout, "#%d/%d %s:%s\n",
> > > >            test->test_num, test->subtest_num,
> > > >            test->subtest_name, sub_error_cnt ? "FAIL" : "OK");
> > > >  }
> > > > @@ -100,53 +108,7 @@ void test__force_log() {
> > > >
> > > >  void test__vprintf(const char *fmt, va_list args)
> > > >  {
> > > > -   size_t rem_sz;
> > > > -   int ret = 0;
> > > > -
> > > > -   if (env.verbose || (env.test && env.test->force_log)) {
> > > > -           vfprintf(stderr, fmt, args);
> > > > -           return;
> > > > -   }
> > > > -
> > > > -try_again:
> > > > -   rem_sz = env.log_cap - env.log_cnt;
> > > > -   if (rem_sz) {
> > > > -           va_list ap;
> > > > -
> > > > -           va_copy(ap, args);
> > > > -           /* we reserved extra byte for \0 at the end */
> > > > -           ret = vsnprintf(env.log_buf + env.log_cnt, rem_sz + 1, fmt, ap);
> > > > -           va_end(ap);
> > > > -
> > > > -           if (ret < 0) {
> > > > -                   env.log_buf[env.log_cnt] = '\0';
> > > > -                   fprintf(stderr, "failed to log w/ fmt '%s'\n", fmt);
> > > > -                   return;
> > > > -           }
> > > > -   }
> > > > -
> > > > -   if (!rem_sz || ret > rem_sz) {
> > > > -           size_t new_sz = env.log_cap * 3 / 2;
> > > > -           char *new_buf;
> > > > -
> > > > -           if (new_sz < 4096)
> > > > -                   new_sz = 4096;
> > > > -           if (new_sz < ret + env.log_cnt)
> > > > -                   new_sz = ret + env.log_cnt;
> > > > -
> > > > -           /* +1 for guaranteed space for terminating \0 */
> > > > -           new_buf = realloc(env.log_buf, new_sz + 1);
> > > > -           if (!new_buf) {
> > > > -                   fprintf(stderr, "failed to realloc log buffer: %d\n",
> > > > -                           errno);
> > > > -                   return;
> > > > -           }
> > > > -           env.log_buf = new_buf;
> > > > -           env.log_cap = new_sz;
> > > > -           goto try_again;
> > > > -   }
> > > > -
> > > > -   env.log_cnt += ret;
> > > > +   vprintf(fmt, args);
> > > >  }
> > > >
> > > >  void test__printf(const char *fmt, ...)
> > > > @@ -477,6 +439,32 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
> > > >     return 0;
> > > >  }
> > > >
> > > > +static void stdout_hijack(void)
> > > > +{
> > > > +   if (env.verbose || (env.test && env.test->force_log)) {
> > > > +           /* nothing to do, output to stdout by default */
> > > > +           return;
> > > > +   }
> > > > +
> > > > +   /* stdout -> buffer */
> > > > +   fflush(stdout);
> > > > +   stdout = open_memstream(&env.log_buf, &env.log_cap);
> > > Check errors and restore original stdout if something went wrong? (And emit some warning to stderr).
> > Good point, will do.
> >
> > > > +}
> > > > +
> > > > +static void stdout_restore(void)
> > > > +{
> > > > +   if (stdout == env.stdout)
> > > > +           return;
> > > > +
> > > > +   fclose(stdout);
> > > > +   free(env.log_buf);
> > > > +
> > > > +   env.log_buf = NULL;
> > > > +   env.log_cap = 0;
> > > > +
> > > > +   stdout = env.stdout;
> > > > +}
> > > > +
> > > >  int main(int argc, char **argv)
> > > >  {
> > > >     static const struct argp argp = {
> > > > @@ -495,6 +483,7 @@ int main(int argc, char **argv)
> > > >     srand(time(NULL));
> > > >
> > > >     env.jit_enabled = is_jit_enabled();
> > > > +   env.stdout = stdout;
> > > >
> > > >     for (i = 0; i < prog_test_cnt; i++) {
> > > >             struct prog_test_def *test = &prog_test_defs[i];
> > > > @@ -508,6 +497,7 @@ int main(int argc, char **argv)
> > > >                             test->test_num, test->test_name))
> > > >                     continue;
> > > >
> > > > +           stdout_hijack();
> > > Why do you do this for every test? Just do once before all the tests and restore after?
> > We can do that, my thinking was to limit the area of hijacking :-)
> 
> But why? We actually want to hijack stdout/stderr for entire duration
> of all the tests. If test_progs needs some "infrastructural" mandatory
> output, we have env.stdout/env.stderr for that.
Oh, I agree, I've done just that for v2 that's already out.
I was just trying to justify my initial thinking :-)

> > But that would work as well, less allocations per test, I guess. Will
> > do.
> >
> > > >             test->run_test();
> > > >             /* ensure last sub-test is finalized properly */
> > > >             if (test->subtest_name)
> > > > @@ -522,6 +512,7 @@ int main(int argc, char **argv)
> > > >                     env.succ_cnt++;
> > > >
> > > >             dump_test_log(test, test->error_cnt);
> > > > +           stdout_restore();
> > > >
> > > >             printf("#%d %s:%s\n", test->test_num, test->test_name,
> > > >                    test->error_cnt ? "FAIL" : "OK");
> > > > @@ -529,7 +520,6 @@ int main(int argc, char **argv)
> > > >     printf("Summary: %d/%d PASSED, %d FAILED\n",
> > > >            env.succ_cnt, env.sub_succ_cnt, env.fail_cnt);
> > > >
> > > > -   free(env.log_buf);
> > > >     free(env.test_selector.num_set);
> > > >     free(env.subtest_selector.num_set);
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> > > > index afd14962456f..9fd89078494f 100644
> > > > --- a/tools/testing/selftests/bpf/test_progs.h
> > > > +++ b/tools/testing/selftests/bpf/test_progs.h
> > > > @@ -56,8 +56,8 @@ struct test_env {
> > > >     bool jit_enabled;
> > > >
> > > >     struct prog_test_def *test;
> > > > +   FILE *stdout;
> > > >     char *log_buf;
> > > > -   size_t log_cnt;
> > > >     size_t log_cap;
> > > So it's actually log_cnt that's assigned on fflush for memstream, according to man page, so probably keep log_cnt, delete log_cap.
> > Ack. See above, will rename to log_size, let me know if you disagree.
> >
> > > >     int succ_cnt; /* successful tests */
