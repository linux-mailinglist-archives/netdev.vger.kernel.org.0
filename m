Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC57773A9
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfGZVpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:45:50 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35981 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfGZVpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:45:50 -0400
Received: by mail-qt1-f196.google.com with SMTP id z4so54135424qtc.3;
        Fri, 26 Jul 2019 14:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uy3Ny8MrQoDKgotFKQPn/uhcJnkrRa/HrTqOLAbwRcs=;
        b=fhZf51HZ7GBdbADb0SkcGKgJNvoA+CnIQzqa7rbPnx06NiX01+DljYFi/+5FJPx7/e
         awoPxLA/1ROY6aI3DOfLRVoX3/fj0DI6S2UhEkuS1MyyHTyAfI7tsey0ioJrOAiwNR8Q
         apoPsHy2tOrw81IbMKETT5nOPsr8ScxAE39T7CBTmT9ee7F50Q8AVKdJGE019mLAjB/z
         FKm+xmz1kMbdqgvNQDKuCreeuxvMTHgGIQSsbg0SebB+okGto2FVZjVohCwAoH+AdI7p
         TVcLhgaXTKeY93z1f0pnD+SFDLLLA1rmwiI5nj8FebE335jdOJqjvqF9c0lFiLWqBddZ
         nO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uy3Ny8MrQoDKgotFKQPn/uhcJnkrRa/HrTqOLAbwRcs=;
        b=sqGyDiApgTh4bQKOe2QkwBcgC3fpbyUNOg6/cgfll8dLgKsl5gM1NA5AW8VnmzTgIl
         umVYF88MhaDLWYkQNggIgiP6jyURItmQa8D3vcizlwuGVn2zXluct+RLpaxhQq1wk71e
         hN0XHE2XUSWl89RBLyNfA5toa//NHzXLkSNPN/yPgpvzJ9q52FC56mVt1mcD/I4bOXrH
         1dgTgygDKon2LJFqKkLgaAACqA+6jhtyv55hYzkcZwik+suFYuloshk3Thjc2cck9xZ8
         4qUZM0YGlGMYOk5MLbPa+9z0jMSjxGibn9yf+uDHFWx9tV4ZJqe9raWVEEcgaySWKNPX
         NpRQ==
X-Gm-Message-State: APjAAAUbbEDWmqfpGpuWMRsbuQSLE2+O7aUuTiNKMkprfYdEksSN2L5v
        5aXDVnSNWyFpJ1teb0Uwy3wgZ4hHhiXIbFWuyII=
X-Google-Smtp-Source: APXvYqxf+Xgu1FPDBEkEoC0QE7YVaAyM4ne9JpCZWCrpOhQZTTx44lnDzfDPnrbfr1Lru1D3KinKOaCVrb/QslRuO70=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr66906905qta.171.1564177549203;
 Fri, 26 Jul 2019 14:45:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190726203747.1124677-1-andriin@fb.com> <20190726203747.1124677-4-andriin@fb.com>
 <20190726212547.GB24397@mini-arch>
In-Reply-To: <20190726212547.GB24397@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jul 2019 14:45:38 -0700
Message-ID: <CAEf4BzZRhHTo+vUFkmLnjPxTL8oi6Fi0zrhvhA6JbY_afU3_Nw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/9] selftests/bpf: add test selectors by number
 and name to test_progs
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 2:25 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 07/26, Andrii Nakryiko wrote:
> > Add ability to specify either test number or test name substring to
> > narrow down a set of test to run.
> >
> > Usage:
> > sudo ./test_progs -n 1
> > sudo ./test_progs -t attach_probe
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/testing/selftests/bpf/test_progs.c | 43 +++++++++++++++++++++---
> >  1 file changed, 39 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > index eea88ba59225..6e04b9f83777 100644
> > --- a/tools/testing/selftests/bpf/test_progs.c
> > +++ b/tools/testing/selftests/bpf/test_progs.c
> > @@ -4,6 +4,7 @@

[...]

> >
> >  static error_t parse_arg(int key, char *arg, struct argp_state *state)
> >  {
> >       struct test_env *env = state->input;
> >
> >       switch (key) {
> [..]
> > +     case ARG_TEST_NUM: {
> > +             int test_num;
> > +
> > +             errno = 0;
> > +             test_num = strtol(arg, NULL, 10);
> > +             if (errno)
> > +                     return -errno;
> > +             env->test_num_selector = test_num;
> > +             break;
> > +     }
> Do you think it's really useful? I agree about running by name (I

Special request from Alexei :) But in one of the follow up patches, I
extended this to allow to specify arbitrary subset of tests, e.g.:
1,2,5-10,7-8. So in that regard, it's more powerful than selecting by
name and gives you ultimate freedom.

> usually used grep -v in the Makefile :-), but I'm not sure about running
> by number.
>
> Or is the idea is that you can just copy-paste this number from the
> test_progs output to rerun the tests? In this case, why not copy-paste
> the name instead?

Both were simple to support, I didn't want to dictate one right way to
do this :)

>
> > +     case ARG_TEST_NAME:
> > +             env->test_name_selector = arg;
> > +             break;
> >       case ARG_VERIFIER_STATS:
> >               env->verifier_stats = true;
> >               break;
> > @@ -223,7 +248,7 @@ int main(int argc, char **argv)
> >               .parser = parse_arg,
> >               .doc = argp_program_doc,
> >       };
> > -     const struct prog_test_def *def;
> > +     struct prog_test_def *test;
> >       int err, i;
> >
> >       err = argp_parse(&argp, argc, argv, 0, NULL, &env);
> > @@ -237,8 +262,18 @@ int main(int argc, char **argv)
> >       verifier_stats = env.verifier_stats;
> >
> >       for (i = 0; i < ARRAY_SIZE(prog_test_defs); i++) {
> > -             def = &prog_test_defs[i];
> > -             def->run_test();
> > +             test = &prog_test_defs[i];
> > +
> > +             test->test_num = i + 1;
> > +
> > +             if (env.test_num_selector >= 0 &&
> > +                 test->test_num != env.test_num_selector)
> > +                     continue;
> > +             if (env.test_name_selector &&
> > +                 !strstr(test->test_name, env.test_name_selector))
> > +                     continue;
> > +
> > +             test->run_test();
> >       }
> >
> >       printf("Summary: %d PASSED, %d FAILED\n", pass_cnt, error_cnt);
> > --
> > 2.17.1
> >
