Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392441CD4A
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfENQzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 12:55:45 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40828 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfENQzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 12:55:45 -0400
Received: by mail-lj1-f195.google.com with SMTP id d15so14985696ljc.7;
        Tue, 14 May 2019 09:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6sxKLfUh0DEiZngzXK9ZQcZ11Dr5kqpAhvPY359O2Uw=;
        b=obbQ4/dYvGIfLSHAjMg4vzOyVxCOq86OAHLgKGAm+UMFbaRXxMH544a1oNbeM5zChy
         c/zrT9fUDmQAoGPLUC/Z8AjZ1JLkEn8axGnSct5Cq810X34oL02ZMzDl07ouKU6eZHdC
         TKDxpSqTOIxbWhTI9k0idfQOZWxl9dabU5mJrXWXGMU6CafS82fwNbfK6l22tCriPftC
         UuZAbm81oVyQDQLCn/azCz9oq3lAGqX07HO5gG7PmaLcl6BfK3sFJDMoNVhTbYEMiIU+
         pCPeDJicJteqmKAialdCRCyhV18SUrkqYYKILdrzI8jQoIhAGOlX+8Ronm8HYyBwn255
         /Lqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6sxKLfUh0DEiZngzXK9ZQcZ11Dr5kqpAhvPY359O2Uw=;
        b=a1VOmL34aLPp/lo5UkhmqXVlQcS9P59ik8HOPazqizO9/5oHq5b9baMTIW2WNheTGC
         8wkVVF/1WiVXJm9cmtUrze8HH5OFSd+2QB14Sk0R45GRfjOI6ZU/1jeTu9BV8UD5LqcD
         z5/ZHxt1RPbutbR6mIxpaxPD+AHrhN9F+yuEpFlzl6XyQkyvivIl863yoXxalZhJ1/iU
         4qBoY6hvgXh53sPrErnjWnQyxJ6mElNvGzqJGWFwBAe1utmcAo3X7OR1FtVBIqh3v9lK
         7GNhbtXo9SfyXj5Y+LHdQIFyIXC/9n85HOVzPT+Js6k8NDrfuOfuBZNiD1zJ/HaIqUg1
         f+Rw==
X-Gm-Message-State: APjAAAXEcLLK7/beTxfef/Z/wS3jJihVzrjvXwelpLeKBSqAs+RV8WmD
        yhv0P7jdCaGJ+Z2ilpWUfgRtNTHEe+AR2v79G0PWOw==
X-Google-Smtp-Source: APXvYqyJdlNlg6AHl3P3AH1z90uYLaUQ6Ro9fbpNXcbwttUuYJP1tMSSoSXUTv0E6h+hl5E9dXjCVw8vQyp1CVL3Ug8=
X-Received: by 2002:a2e:84ce:: with SMTP id q14mr17889699ljh.80.1557852943040;
 Tue, 14 May 2019 09:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190508171845.201303-1-sdf@google.com> <20190508175644.e4k5o6o3cgn6k5lx@ast-mbp>
 <20190508181223.GH1247@mini-arch> <20190513185724.GB24057@mini-arch>
In-Reply-To: <20190513185724.GB24057@mini-arch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 May 2019 09:55:31 -0700
Message-ID: <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 11:57 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 05/08, Stanislav Fomichev wrote:
> > On 05/08, Alexei Starovoitov wrote:
> > > On Wed, May 08, 2019 at 10:18:41AM -0700, Stanislav Fomichev wrote:
> > > > Right now we are not using rcu api correctly: we pass __rcu pointers
> > > > to bpf_prog_array_xyz routines but don't use rcu_dereference on them
> > > > (see bpf_prog_array_delete_safe and bpf_prog_array_copy in particular).
> > > > Instead of sprinkling rcu_dereferences, let's just get rid of those
> > > > __rcu annotations and move rcu handling to a higher level.
> > > >
> > > > It looks like all those routines are called from the rcu update
> > > > side and we can use simple rcu_dereference_protected to get a
> > > > reference that is valid as long as we hold a mutex (i.e. no other
> > > > updater can change the pointer, no need for rcu read section and
> > > > there should not be a use-after-free problem).
> > > >
> > > > To be fair, there is currently no issue with the existing approach
> > > > since the calls are mutex-protected, pointer values don't change,
> > > > __rcu annotations are ignored. But it's still nice to use proper api.
> > > >
> > > > The series fixes the following sparse warnings:
> > >
> > > Absolutely not.
> > > please fix it properly.
> > > Removing annotations is not a fix.
> > I'm fixing it properly by removing the annotations and moving lifetime
> > management to the upper layer. See commits 2-4 where I fix the users, the
> > first patch is just the "preparation".
> >
> > The users are supposed to do:
> >
> > mutex_lock(&x);
> > p = rcu_dereference_protected(prog_array, lockdep_is_held(&x))
> > // ...
> > // call bpf_prog_array helpers while mutex guarantees that
> > // the object referenced by p is valid (i.e. no need for bpf_prog_array
> > // helpers to care about rcu lifetime)
> > // ...
> > mutex_unlock(&x);
> >
> > What am I missing here?
>
> Just to give you my perspective on why current api with __rcu annotations
> is working, but not optimal (even if used from the rcu read section).
>
> Sample code:
>
>         struct bpf_prog_array __rcu *progs = <comes from somewhere>;
>         int n;
>
>         rcu_read_lock();
>         n = bpf_prog_array_length(progs);
>         if (n > 0) {
>           // do something with __rcu progs
>           do_something(progs);
>         }
>         rcu_read_unlock();
>
> Since progs is __rcu annotated, do_something() would need to do
> rcu_dereference again and it might get a different value compared to
> whatever bpf_prog_array_free got while doing its dereference.

correct and I believe the code deals with it fine.
cnt could be different between two calls.

> A better way is not to deal with rcu inside those helpers and let
> higher layers do that:
>
>         struct bpf_prog_array __rcu *progs = <comes from somewhere>;
>         struct bpf_prog_array *p;
>         int n;
>
>         rcu_read_lock();
>         p = rcu_dereference(p);
>         n = bpf_prog_array_length(p);
>         if (n > 0) {
>           do_something(p); // do_something sees the same p as bpf_prog_array_length
>         }
>         rcu_read_unlock();
>
> What do you think?

I'm not sure that generically applicable.
Which piece of code do you have in mind for such refactoring?
