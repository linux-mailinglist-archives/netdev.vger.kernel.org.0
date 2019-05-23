Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C6E284E5
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731192AbfEWR1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:27:15 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43431 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730957AbfEWR1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:27:15 -0400
Received: by mail-qt1-f194.google.com with SMTP id g17so1614876qtq.10;
        Thu, 23 May 2019 10:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TqPNIQV81Fx52FbEQQovh1n28JKFcLxe0c7FwLU1GsM=;
        b=eMTGZDArJCg0sDzunB9THn28VA9ypu+NLKr+DdZqHHdwuyjVbZglGpV9OjMhi7yTpn
         BINASj6tgVoBz1an90WaxhGCMjPhYT9nBZqaayETsuSfCNi+V9ZeCT2KARisgRgD+v/c
         T2Ick9SZf6gPx65NjY4Z9tQTu0MWo/ZyHYOmh2+jYS1WFQ/VejgW8sqNa2ZjPDQdQPPc
         pdOa2iHgw02WEmbR8vQPs8EhLoAgr4j41xCvkNhUHzfl4R3Rqg67b2uwmL7ogeO06ja/
         50m61V/22kXB0+v46Kk/T1TiDsHtuEisVeP22mWAjhi2Vyi+Fc6VhxJdAsjYMmsri45S
         vEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TqPNIQV81Fx52FbEQQovh1n28JKFcLxe0c7FwLU1GsM=;
        b=TLOwtuMGJsQEZby0z8JBdlBvvPnuM+E+oDRTkAcVSMwN9PwTG29joJpQH9Go0+ibYT
         i6faYZUjXP7J0xsKdxW4BNIiG8wHOZ33xXUYe/Yfk1Jrx+PsweX8EGOJYMjF62EZiXjy
         ZbCdVKqa4oO9ldrEJegwO3PuROVfDWrJYQF6fMpApATz4gta+NfJUeCC6Uqut39KSN78
         2aMZY5nKeDrG/w6pEl3K0CdynKxGDGia7SWELuUy08gH5BPtn3pqAXBcsRbKyR1dDUnB
         PZLZjacvNGNSKL0w7ejU/dNgnMo9w/SxxR43zCO0YK7MeRrR6/qJGNWsqs7xZRH3SkEp
         GvcQ==
X-Gm-Message-State: APjAAAVqLIrH+T5KBlQzbyOQQnzgDyiU9sRWhDrNEkABmNhTXqthWnkW
        xb/ftQaD+gnaRbyluEjwnAEO3vuih3TDvrqxjj167BVZnpc=
X-Google-Smtp-Source: APXvYqxQLmRaIPOp0XneiR/Zxk8JUSVAw1ocpR9kopvIDwAAlp1P9EDlrztvXiVMepnJ3isHEOAsNFtoEB6esEYzP5U=
X-Received: by 2002:a0c:d917:: with SMTP id p23mr63716226qvj.162.1558632429964;
 Thu, 23 May 2019 10:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190522195053.4017624-1-andriin@fb.com> <20190522195053.4017624-11-andriin@fb.com>
 <20190522172553.6f057e51@cakuba.netronome.com> <CAEf4BzZ36rcVuKabefWD-CaJ-BUECiYM_=3mzNAi3XMAR=49fQ@mail.gmail.com>
 <20190522182328.7c8621ec@cakuba.netronome.com> <CAEf4BzaOAxKRNQasQtvAyLnvKtRLCpAcBq2q651PKG6b6r5Ktw@mail.gmail.com>
 <20190523092700.00c1cdaf@cakuba.netronome.com>
In-Reply-To: <20190523092700.00c1cdaf@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 23 May 2019 10:26:57 -0700
Message-ID: <CAEf4BzbH700V1TcvcVufKD8v9PBZRoDDgZXs7JWbWccSDaGtZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/12] bpftool: add C output format option to btf
 dump subcommand
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 9:27 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 22 May 2019 21:43:43 -0700, Andrii Nakryiko wrote:
> > On Wed, May 22, 2019 at 6:23 PM Jakub Kicinski wrote:
> > > On Wed, 22 May 2019 17:58:23 -0700, Andrii Nakryiko wrote:
> > > > On Wed, May 22, 2019 at 5:25 PM Jakub Kicinski wrote:
> > > > > On Wed, 22 May 2019 12:50:51 -0700, Andrii Nakryiko wrote:
> > > > > > + * Copyright (C) 2019 Facebook
> > > > > > + */
> > > > > >
> > > > > >  #include <errno.h>
> > > > > >  #include <fcntl.h>
> > > > > > @@ -340,11 +347,48 @@ static int dump_btf_raw(const struct btf *btf,
> > > > > >       return 0;
> > > > > >  }
> > > > > >
> > > > > > +static void btf_dump_printf(void *ctx, const char *fmt, va_list args)
> > > > > > +{
> > > > > > +     vfprintf(stdout, fmt, args);
> > > > > > +}
> > > > > > +
> > > > > > +static int dump_btf_c(const struct btf *btf,
> > > > > > +                   __u32 *root_type_ids, int root_type_cnt)
> > > > >
> > > > > Please break the line after static int.
> > > >
> > > > I don't mind, but it seems that prevalent formatting for such cases
> > > > (at least in bpftool code base) is aligning arguments and not break
> > > > static <return type> into separate line:
> > > >
> > > > // multi-line function definitions with static on the same line
> > > > $ rg '^static \w+.*\([^\)]*$' | wc -l
> > > > 45
> > > > // multi-line function definitions with static on separate line
> > > > $ rg '^static \w+[^\(\{;]*$' | wc -l
> > > > 12
> > > >
> > > > So I don't mind changing, but which one is canonical way of formatting?
> > >
> > > Not really, just my preference :)
> >
> > I'll stick to majority :) I feel like it's also a preferred style in
> > libbpf, so I'd rather converge to that.
>
> Majority is often wrong or at least lazy.  But yeah, this is a waste of
> time.  Do whatever.  You also use inline keyword in C files in your
> libbpf patches..  I think kernel style rules should apply.

I'll remove inlines.

>
> > > In my experience having the return type on a separate line if its
> > > longer than a few chars is the simplest rule for consistent and good
> > > looking code.
> > >
> > > > > > +     d = btf_dump__new(btf, NULL, NULL, btf_dump_printf);
> > > > > > +     if (IS_ERR(d))
> > > > > > +             return PTR_ERR(d);
> > > > > > +
> > > > > > +     if (root_type_cnt) {
> > > > > > +             for (i = 0; i < root_type_cnt; i++) {
> > > > > > +                     err = btf_dump__dump_type(d, root_type_ids[i]);
> > > > > > +                     if (err)
> > > > > > +                             goto done;
> > > > > > +             }
> > > > > > +     } else {
> > > > > > +             int cnt = btf__get_nr_types(btf);
> > > > > > +
> > > > > > +             for (id = 1; id <= cnt; id++) {
> > > > > > +                     err = btf_dump__dump_type(d, id);
> > > > > > +                     if (err)
> > > > > > +                             goto done;
> > > > > > +             }
> > > > > > +     }
> > > > > > +
> > > > > > +done:
> > > > > > +     btf_dump__free(d);
> > > > > > +     return err;
> > > > >
> > > > > What do we do for JSON output?
> > > >
> > > > Still dump C syntax. What do you propose? Error out if json enabled?
> > >
> > > I wonder.  Letting it just print C is going to confuse anything that
> > > just feeds the output into a JSON parser.  I'd err on the side of
> > > returning an error, we can always relax that later if we find a use
> > > case of returning C syntax via JSON.
> >
> > Ok, I'll emit error (seems like pr_err automatically handles JSON
> > output, which is very nice).
>
> Thanks
>
> > > > > >       if (!btf) {
> > > > > >               err = btf__get_from_id(btf_id, &btf);
> > > > > >               if (err) {
> > > > > > @@ -444,7 +498,10 @@ static int do_dump(int argc, char **argv)
> > > > > >               }
> > > > > >       }
> > > > > >
> > > > > > -     dump_btf_raw(btf, root_type_ids, root_type_cnt);
> > > > > > +     if (dump_c)
> > > > > > +             dump_btf_c(btf, root_type_ids, root_type_cnt);
> > > > > > +     else
> > > > > > +             dump_btf_raw(btf, root_type_ids, root_type_cnt);
> > > > > >
> > > > > >  done:
> > > > > >       close(fd);
> > > > > > @@ -460,7 +517,7 @@ static int do_help(int argc, char **argv)
> > > > > >       }
> > > > > >
> > > > > >       fprintf(stderr,
> > > > > > -             "Usage: %s btf dump BTF_SRC\n"
> > > > > > +             "Usage: %s btf dump BTF_SRC [c]\n"
> > > > >
> > > > > bpftool generally uses <key value> formats.  So perhaps we could do
> > > > > something like "[format raw|c]" here for consistency, defaulting to raw?
> > > >
> > > > That's not true for options, though. I see that at cgroup, prog, and
> > > > some map subcommands (haven't checked all other) just accept a list of
> > > > options without extra identifying key.
> > >
> > > Yeah, we weren't 100% enforcing this rule and it's a bit messy now :/
> >
> > Unless you feel very strongly about this, it seems ok to me to allow
> > "boolean options" (similarly to boolean --flag args) as a stand-alone
> > set of tags. bpftool invocations are already very verbose, no need to
> > add to that. Plus it also makes bash-completion simpler, it's always
> > good not to complicate bash script unnecessarily :)
>
> It's more of a question if we're going to have more formats.  If not
> then c as keyword is probably fine (although its worryingly short).
> If we start adding more then a key value would be better.  Let's take a
> gamble and if we add 2 more output types I'll say "I told you so"? :)

Ok, that's fair :) There were talks about emitting Go, so it's not
unimaginable that we'll have another format. I'll switch that to
`format [c|raw]`.
