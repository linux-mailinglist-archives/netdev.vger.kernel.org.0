Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C072837A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbfEWQ1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:27:07 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33132 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730913AbfEWQ1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:27:06 -0400
Received: by mail-qk1-f193.google.com with SMTP id p18so4200156qkk.0
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 09:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=+BHvPvg9wxYFnwvNTSzxgrkbl64Nq/obBbwrTAiGAmo=;
        b=PMPEm3cdbSbFnwdzM4WoZQc5Wh5+S9GtkS7pV35RFuwT/cme9bXcFJCLqJooqwn2b2
         4okbuItYRJAZugDPHs2D6ZhZI9wKmGbbIZC34ls9iWUL/ZEpnsBr304A5EABzHVQJnBA
         C/GeU26opZBdQ3haW3rrk19OGz6XUNHW6W/w46CQzGnTAsZPOIS69+7xXR6ed8bkbTF6
         FsoOdZzyjRjm5hZ8fKoawogy81UKlzyBl2fB8ui0OML6JMj57p/E9RIyRz4ts1lt+Hca
         8fKN6SKrIo7t28xuCbsrCPde0t25zhuDFwdgI2p8zp5jO3Xi9ioSd/67D+QsvQlGfZZH
         3SqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+BHvPvg9wxYFnwvNTSzxgrkbl64Nq/obBbwrTAiGAmo=;
        b=Eesrjwsp1f5uJNeVctZeFSG/Xh7vHXGhWser4TckmPBWuX4hzp2oywe4csgQNrTuYx
         /wODJ7sBP+k3VUYFDesuSg9U1Y1Qtue+j5BCkVX5TBMlk5F12VX7V7ToN+ozn9gjwwLt
         VAeh2dCbz/M9+o/BHs1gz2XV5ZVFCaBPj7VWQBa5KWfp1JB06hFQOZgsuz0fYJQJrfn6
         LAfxmhzytzsFlospAhdteXgCkt5LhW6hUxQakJQ2alCdRnN5Oq+BJLRkYqWsgUhfADc5
         2f6XSfbhaMlSOEjqrhSCi3ahBbaIPOvUqscBHw49LpD4rglR3t2nnqZ3WXqxSfU9WacT
         l3yw==
X-Gm-Message-State: APjAAAX+KVAK80dnID6pCEDtxTctm63E/1YX6VaTthPFxZ3NFVWIDHAM
        9ogtuKqzQ2t9dGM6VShn7ZDoJCHKvjs=
X-Google-Smtp-Source: APXvYqyHVWnLxW2/LPniB3mpATf22VUTTwatVFJzVPTg9QhlykO9yHa2vv8OCtRdK8WyRK7uMpkXRw==
X-Received: by 2002:a37:c409:: with SMTP id d9mr35683282qki.125.1558628825760;
        Thu, 23 May 2019 09:27:05 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l40sm17901238qtc.32.2019.05.23.09.27.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 23 May 2019 09:27:05 -0700 (PDT)
Date:   Thu, 23 May 2019 09:27:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 10/12] bpftool: add C output format option to
 btf dump subcommand
Message-ID: <20190523092700.00c1cdaf@cakuba.netronome.com>
In-Reply-To: <CAEf4BzaOAxKRNQasQtvAyLnvKtRLCpAcBq2q651PKG6b6r5Ktw@mail.gmail.com>
References: <20190522195053.4017624-1-andriin@fb.com>
        <20190522195053.4017624-11-andriin@fb.com>
        <20190522172553.6f057e51@cakuba.netronome.com>
        <CAEf4BzZ36rcVuKabefWD-CaJ-BUECiYM_=3mzNAi3XMAR=49fQ@mail.gmail.com>
        <20190522182328.7c8621ec@cakuba.netronome.com>
        <CAEf4BzaOAxKRNQasQtvAyLnvKtRLCpAcBq2q651PKG6b6r5Ktw@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 21:43:43 -0700, Andrii Nakryiko wrote:
> On Wed, May 22, 2019 at 6:23 PM Jakub Kicinski wrote:
> > On Wed, 22 May 2019 17:58:23 -0700, Andrii Nakryiko wrote:  
> > > On Wed, May 22, 2019 at 5:25 PM Jakub Kicinski wrote:  
> > > > On Wed, 22 May 2019 12:50:51 -0700, Andrii Nakryiko wrote:  
> > > > > + * Copyright (C) 2019 Facebook
> > > > > + */
> > > > >
> > > > >  #include <errno.h>
> > > > >  #include <fcntl.h>
> > > > > @@ -340,11 +347,48 @@ static int dump_btf_raw(const struct btf *btf,
> > > > >       return 0;
> > > > >  }
> > > > >
> > > > > +static void btf_dump_printf(void *ctx, const char *fmt, va_list args)
> > > > > +{
> > > > > +     vfprintf(stdout, fmt, args);
> > > > > +}
> > > > > +
> > > > > +static int dump_btf_c(const struct btf *btf,
> > > > > +                   __u32 *root_type_ids, int root_type_cnt)  
> > > >
> > > > Please break the line after static int.  
> > >
> > > I don't mind, but it seems that prevalent formatting for such cases
> > > (at least in bpftool code base) is aligning arguments and not break
> > > static <return type> into separate line:
> > >
> > > // multi-line function definitions with static on the same line
> > > $ rg '^static \w+.*\([^\)]*$' | wc -l
> > > 45
> > > // multi-line function definitions with static on separate line
> > > $ rg '^static \w+[^\(\{;]*$' | wc -l
> > > 12
> > >
> > > So I don't mind changing, but which one is canonical way of formatting?  
> >
> > Not really, just my preference :)  
> 
> I'll stick to majority :) I feel like it's also a preferred style in
> libbpf, so I'd rather converge to that.

Majority is often wrong or at least lazy.  But yeah, this is a waste of
time.  Do whatever.  You also use inline keyword in C files in your
libbpf patches..  I think kernel style rules should apply.

> > In my experience having the return type on a separate line if its
> > longer than a few chars is the simplest rule for consistent and good
> > looking code.
> >  
> > > > > +     d = btf_dump__new(btf, NULL, NULL, btf_dump_printf);
> > > > > +     if (IS_ERR(d))
> > > > > +             return PTR_ERR(d);
> > > > > +
> > > > > +     if (root_type_cnt) {
> > > > > +             for (i = 0; i < root_type_cnt; i++) {
> > > > > +                     err = btf_dump__dump_type(d, root_type_ids[i]);
> > > > > +                     if (err)
> > > > > +                             goto done;
> > > > > +             }
> > > > > +     } else {
> > > > > +             int cnt = btf__get_nr_types(btf);
> > > > > +
> > > > > +             for (id = 1; id <= cnt; id++) {
> > > > > +                     err = btf_dump__dump_type(d, id);
> > > > > +                     if (err)
> > > > > +                             goto done;
> > > > > +             }
> > > > > +     }
> > > > > +
> > > > > +done:
> > > > > +     btf_dump__free(d);
> > > > > +     return err;  
> > > >
> > > > What do we do for JSON output?  
> > >
> > > Still dump C syntax. What do you propose? Error out if json enabled?  
> >
> > I wonder.  Letting it just print C is going to confuse anything that
> > just feeds the output into a JSON parser.  I'd err on the side of
> > returning an error, we can always relax that later if we find a use
> > case of returning C syntax via JSON.  
> 
> Ok, I'll emit error (seems like pr_err automatically handles JSON
> output, which is very nice).

Thanks

> > > > >       if (!btf) {
> > > > >               err = btf__get_from_id(btf_id, &btf);
> > > > >               if (err) {
> > > > > @@ -444,7 +498,10 @@ static int do_dump(int argc, char **argv)
> > > > >               }
> > > > >       }
> > > > >
> > > > > -     dump_btf_raw(btf, root_type_ids, root_type_cnt);
> > > > > +     if (dump_c)
> > > > > +             dump_btf_c(btf, root_type_ids, root_type_cnt);
> > > > > +     else
> > > > > +             dump_btf_raw(btf, root_type_ids, root_type_cnt);
> > > > >
> > > > >  done:
> > > > >       close(fd);
> > > > > @@ -460,7 +517,7 @@ static int do_help(int argc, char **argv)
> > > > >       }
> > > > >
> > > > >       fprintf(stderr,
> > > > > -             "Usage: %s btf dump BTF_SRC\n"
> > > > > +             "Usage: %s btf dump BTF_SRC [c]\n"  
> > > >
> > > > bpftool generally uses <key value> formats.  So perhaps we could do
> > > > something like "[format raw|c]" here for consistency, defaulting to raw?  
> > >
> > > That's not true for options, though. I see that at cgroup, prog, and
> > > some map subcommands (haven't checked all other) just accept a list of
> > > options without extra identifying key.  
> >
> > Yeah, we weren't 100% enforcing this rule and it's a bit messy now :/  
> 
> Unless you feel very strongly about this, it seems ok to me to allow
> "boolean options" (similarly to boolean --flag args) as a stand-alone
> set of tags. bpftool invocations are already very verbose, no need to
> add to that. Plus it also makes bash-completion simpler, it's always
> good not to complicate bash script unnecessarily :)

It's more of a question if we're going to have more formats.  If not
then c as keyword is probably fine (although its worryingly short).
If we start adding more then a key value would be better.  Let's take a
gamble and if we add 2 more output types I'll say "I told you so"? :)
