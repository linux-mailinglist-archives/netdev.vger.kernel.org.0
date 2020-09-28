Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3EB27B369
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgI1Rie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbgI1Rid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 13:38:33 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EBCC061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 10:38:33 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id f15so2124079ilj.2
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 10:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ix6rK5nNILFR//2VX1TEkWq4PG6CyVnNoZXDdGJ11pM=;
        b=R8gQX/LHqO1lVOmGFk21X1rfpqmGmVuxlAKCKTYa6pR0Xiy9zeaexSY6TzD6VxInAo
         eDTIoQCs2OvpfrcaUZvriRTjXcB2n3LlCKnErCDzXNT12KWfaTrXwQlpXjWGXE8FElKd
         7QRpSfeBkGQ6o7XUtb0nFHNj9EuduDUuHIrDuuC3VTeqxPubhyuIky/TtK+IqMuT8dud
         od0OXtSIiMt+eKz6SYKe6faM1WikhxNnVZLWvcuQ1AR1rpZjuyd2zSBYbLVZDLovCQ6b
         H3NcSS+JDjXI2YNlPphcov67u6Yo3k2+vzvS/QCkRLPgnhYdkwGgXHy6q2ARZd6MYel2
         jlUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ix6rK5nNILFR//2VX1TEkWq4PG6CyVnNoZXDdGJ11pM=;
        b=sW9VH+vmqkOnz1yhBDxiZySMQWOgr6AYeLu5G1abSdfO+a+XOBnsHswhxu19NTANLK
         GqdgnZXVeHOjEgaWuUrCbnjyxz8Qi6mY9vIUUBYZwW+/+dDDOtPQOdfAX8PfuSuztb39
         HAE/soCwq03PsHCzJDd7Lzx//t665wxn22uj4GJRz5/V7025/8wWDdmcmUYMbXpYLTyf
         mJi5sxstDewFMKnQVPP8txeXmg5GHz4Uu0Xbz9VJlx9+4wfFtOhhhqv5FyI4yTjxSwn0
         I8cFUNRxpzXDXpZuzbgM/bdqgqL3XlJPWUufJ43Uod4eK4pJSFd6DEinqVOMsZFrF6S1
         X3vw==
X-Gm-Message-State: AOAM5335eTmtOSR60s6aEP9ZYndDShKBDquuGz0KfvugqftwPQClxT8R
        LsgEzmJcL24Y2rAlFySzvQ3Tmtuynm3EkrH0X5s=
X-Google-Smtp-Source: ABdhPJyrQjN7kAO4Emc4j3F6+McdApSerz9RKwhDqLVIAtAQSSjmAxhvT1WFhz+kvg7UtfWdxwzBKuVg6RohEK7FG88=
X-Received: by 2002:a92:4a0c:: with SMTP id m12mr2262647ilf.238.1601314712934;
 Mon, 28 Sep 2020 10:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200923035624.7307-1-xiyou.wangcong@gmail.com>
 <20200923035624.7307-2-xiyou.wangcong@gmail.com> <877dsh98wq.fsf@buslov.dev>
 <CAM_iQpXy4GuHidnLAL+euBaNaJGju6KFXBZ67WS_Pws58sD6+g@mail.gmail.com>
 <8736358wu0.fsf@buslov.dev> <3a0677de763a6a993123fd4f01000f7e78ace353.camel@redhat.com>
In-Reply-To: <3a0677de763a6a993123fd4f01000f7e78ace353.camel@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 28 Sep 2020 10:38:21 -0700
Message-ID: <CAM_iQpV8xRiwNzMYMDi6dBNLeW5TcyOWtd9Y4qwszQpiVoP_Zw@mail.gmail.com>
Subject: Re: [Patch net 1/2] net_sched: defer tcf_idr_insert() in tcf_action_init_1()
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Vlad Buslov <vlad@buslov.dev>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 3:14 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> hello,
>
> On Fri, 2020-09-25 at 22:45 +0300, Vlad Buslov wrote:
> > On Fri 25 Sep 2020 at 22:22, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > On Fri, Sep 25, 2020 at 8:24 AM Vlad Buslov <vlad@buslov.dev> wrote:
> > > > > +     if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
> > > > > +         !rcu_access_pointer(a->goto_chain)) {
> > > > > +             tcf_action_destroy_1(a, bind);
> > > > > +             NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
> > > > > +             return ERR_PTR(-EINVAL);
> > > > > +     }
> > > >
> > > > I don't think calling tcf_action_destoy_1() is enough here. Since you
> > > > moved this block before assigning cookie and releasing the module, you
> > > > also need to release them manually in addition to destroying the action
> > > > instance.
> > > >
> > >
> > > tcf_action_destoy_1() eventually calls free_tcf() which frees cookie and
> > > tcf_action_destroy() which releases module refcnt.
> > >
> > > What am I missing here?
> > >
> > > Thanks.
> >
> > The memory referenced by the function local pointer "cookie" hasn't been
> > assigned yet to the a->act_cookie because in your patch you moved
> > goto_chain validation code before the cookie change. That means that if
> > user overwrites existing action, then action old a->act_cookie will be
> > freed by tcf_action_destroy_1() but new cookie that was allocated by
> > nla_memdup_cookie() will leak.

Yes, good catch!


>
> maybe we can just delete this if (TC_ACT_EXT_CMP(...)) { ... }
> statement, instead of moving it? Each TC action already does the check
> for NULL "goto chains" with a_o->init() -> tcf_action_check_ctrlact(),
> so this if () statement looks dead code to me _ I probably forgot to
> remove it after all actions were converted to validate the control
> action inside their .init() function.

Good point, I think you are right, I will send a patch to remove it.

Thanks!
