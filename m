Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715DF4EC7E1
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344931AbiC3PL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbiC3PL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:11:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F11DC12D9;
        Wed, 30 Mar 2022 08:10:11 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso179021pjb.0;
        Wed, 30 Mar 2022 08:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=08ZIHe97hKgGRNdhJ3R+mGHQwESozHQxKj/yR7DOnYQ=;
        b=VJdlu3DeKaZO46DZkkPim+IaxaPHUMkxQ7iuq1DAzFEGWYwU0ZxytSHx8OCbtmaLZI
         K7XDgwSqM41nIol2+X1HQP5EFP1xUXlSprMWFTL7X8pZw2N1VqDhXRyrHIy/xld+E5yl
         RTeSsiO4ADu82oRmLPv4WkQvBw7xaG74f+cR4+pXbaFfe91Ev2P7hAwSW9jeOupD502U
         OSdEEufKFk126p62wPX8fMfJQCA9K9lIhXViKlOVAhtEYwkXNHcVK2+gcP/0UwnROsCA
         61q4KCS32nfkt03YhJ/nKUH7XFsHE29hwg5IYSXbyc2fmiZrbgalLUGevzUfAl541O2i
         dm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=08ZIHe97hKgGRNdhJ3R+mGHQwESozHQxKj/yR7DOnYQ=;
        b=mANR1m0JmiA6MM/ylTV+76NB9a1+Swyj1Hvj3KWxGYu8A57nrFWIEmC6AzP4WuBW3V
         Sopjxl5gssniuhw5zCQvtlEs7i8jkXUKdFsKnsrYIRZAHATsKgaNkO9zefRihURHLY+z
         fo6w04f9pMNZDQ0n3mgAYz9E7jGXxlN30zXcjntsVoVm+2NxKvl2YYUiffMgwFX5Qb/T
         MSGa/dNMifu1cFSIqvc9sFw80UYvre4AGkAKdbFaEOsRlONBc9QLUDy2F/TaZhyTZ2Tq
         DRDPwpynkG0oKloytytz3WJ7EOawehix9ot3xfVBFj6kYC6GojsONxLDbA6wbPyXZrml
         uDuA==
X-Gm-Message-State: AOAM531aGMGK2TVqAioiW81PjDOZBdD+orx6mnklKjugx5QoCIcKLuJP
        l6kdsk/CmSSafSIla+eMYXyVF/Ow1fhDce6bFKI=
X-Google-Smtp-Source: ABdhPJwP5RzxHCh+RFfoMVtH/7zzE16gLS6dgmc1BQAsyXd7m+QzB3RvQajZXh01DqjXpZHNSwJ8QX186doxHFmKaPg=
X-Received: by 2002:a17:902:e80e:b0:154:1e0a:ca3f with SMTP id
 u14-20020a170902e80e00b001541e0aca3fmr88223plg.64.1648653010597; Wed, 30 Mar
 2022 08:10:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220329234924.39053-1-alexei.starovoitov@gmail.com>
 <20220329184123.59cfad63@kernel.org> <CAADnVQJNS_U97aqaNxtAhuvZCK6oiDA-tDoAEyDMYnCBbfaZkg@mail.gmail.com>
 <20220330135217.b6d0433831f2b3fa420458ae@kernel.org> <20220330181539.c1d289f010cf46e873c16b6c@kernel.org>
In-Reply-To: <20220330181539.c1d289f010cf46e873c16b6c@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 30 Mar 2022 08:09:59 -0700
Message-ID: <CAADnVQJvzYn3Yw4-exrvUUTFijq0yEJruLkxfzutEgJUVtUj3g@mail.gmail.com>
Subject: Re: pull-request: bpf 2022-03-29
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 2:15 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> On Wed, 30 Mar 2022 13:52:17 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> > On Tue, 29 Mar 2022 18:51:22 -0700
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > > On Tue, Mar 29, 2022 at 6:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > >
> > > > On Tue, 29 Mar 2022 16:49:24 -0700 Alexei Starovoitov wrote:
> > > > > Hi David, hi Jakub,
> > > > >
> > > > > The following pull-request contains BPF updates for your *net* tree.
> > > > >
> > > > > We've added 16 non-merge commits during the last 1 day(s) which contain
> > > > > a total of 24 files changed, 354 insertions(+), 187 deletions(-).
> > > > >
> > > > > The main changes are:
> > > > >
> > > > > 1) x86 specific bits of fprobe/rethook, from Masami and Peter.
> > > > >
> > > > > 2) ice/xsk fixes, from Maciej and Magnus.
> > > > >
> > > > > 3) Various small fixes, from Andrii, Yonghong, Geliang and others.
> > > >
> > > > There are some new sparse warnings here that look semi-legit.
> > > > As in harmless but not erroneous.
> > >
> > > Both are new warnings and not due to these patches, right?
> > >
> > > > kernel/trace/rethook.c:68:9: error: incompatible types in comparison expression (different address spaces):
> > > > kernel/trace/rethook.c:68:9:    void ( [noderef] __rcu * )( ... )
> > > > kernel/trace/rethook.c:68:9:    void ( * )( ... )
> > > >
> > > > 66 void rethook_free(struct rethook *rh)
> > > > 67 {
> > > > 68         rcu_assign_pointer(rh->handler, NULL);
> > > > 69
> > > > 70         call_rcu(&rh->rcu, rethook_free_rcu);
> > > > 71 }
> > > >
> > > > Looks like this should be a WRITE_ONCE() ?
> > >
> > > Masami, please take a look.
> >
> > Yeah, I think we should make this rcu pointer (and read side must use rcu_dereference())
> > because this rh->handler becomes the key to disable this rethook.
> > Let me fix that.
>
> Sorry, please ignore this. Since the handler pointed by rh->handler never
> be removed (unless removed by modules, but this will not happen while
> the rethook is running), YES, WRITE_ONCE() is enough.
> Please add below.
>
> From 92c9c784458f03900823360981812220ce3c7bf3 Mon Sep 17 00:00:00 2001
> From: Masami Hiramatsu <mhiramat@kernel.org>
> Date: Wed, 30 Mar 2022 18:13:42 +0900
> Subject: [PATCH] rethook: Fix to use WRITE_ONCE() for rethook::handler
>
> Since the function pointered by rethook::handler never be removed when
> the rethook is alive, it doesn't need to use rcu_assign_pointer() to
> update it. Just use WRITE_ONCE().
>
> Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>

Could you please send it as a proper patch so it registers in patchwork?

> ---
>  kernel/trace/rethook.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
> index ab463a4d2b23..b56833700d23 100644
> --- a/kernel/trace/rethook.c
> +++ b/kernel/trace/rethook.c
> @@ -65,7 +65,7 @@ static void rethook_free_rcu(struct rcu_head *head)
>   */
>  void rethook_free(struct rethook *rh)
>  {
> -       rcu_assign_pointer(rh->handler, NULL);
> +       WRITE_ONCE(rh->handler, NULL);
>
>         call_rcu(&rh->rcu, rethook_free_rcu);
>  }
> --
> 2.25.1
> --
> Masami Hiramatsu <mhiramat@kernel.org>
