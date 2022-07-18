Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4F0578C4E
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbiGRVBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiGRVBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:01:16 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BDA31DCB;
        Mon, 18 Jul 2022 14:01:15 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id j22so23598658ejs.2;
        Mon, 18 Jul 2022 14:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=9JKC69ZgKxvEAiR9jfUcMboRX5UUbUaTHt8/AYNH2iU=;
        b=Q5ZX+0Ir7yfQayyrfLWCW5z3mC5EADyfcN6MvQHrLtz6K8IOfWCa0yhWTskhALWXZP
         F7bM+gPPi/t1FIcIrJZe3jDuXfvDBKSdJUrOSx3SZCh6yVaLlpepVhkH63dJha/npcGv
         hxprjSIMJqOuhJBANig6mSBhrnFfZl/xjJ9EVnllwpN/rNHAYoBeNmtwTFrkNJq4oed8
         gzsvsVKunCep6nbY6PYJPHSRfpb/sdhxqDEpOJyKko1BXkTlnw5GcpGZfnl4HWwiykPh
         JT9Fa3ToYzIDRuOb3NQmJZQAT1CfR43SPvzWXuIvVUmc/778xE10FjW9gF5acOE8KF7o
         shIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=9JKC69ZgKxvEAiR9jfUcMboRX5UUbUaTHt8/AYNH2iU=;
        b=hMzQyTJUCz/s9iUSOnY/4a1bgA5SrW9FhaB34aW+j3OQiCxIKyemcRbKzBrUHlt1bE
         SMNfL5v/+tdIh1LmK82MynZUeJd6TlzUKuQdSioDcMY1nfBKGyFf0MJBlF41oHDQ5x9/
         9lwnEKhp2HdqsFbPS9hVulyttK9u1Vob6W4Sc4k+dJ+MPENiqKcdIv23Ls9G6iBt8NBZ
         OQHsPEbRatiLXFMnKCRueA3RO64sEDxocCo+UhnY8OqmOIjYpQoCT02kvDowlVAE3ER0
         +fRilkqiWQgIKe+dhU8cvrpsgRG62LdSvDU/yjuIDbvoHlLx1P9MM6Am0mGhx779IRiX
         s67A==
X-Gm-Message-State: AJIora+3sNAIWJrHDQ1scj7bAGhp1/UCWMMrpCbLC+9CRzLfvyXuPFrj
        3Yqy2LaAATqxhSjNl/JVvTh6VOSZ7COKdYJ1tsE=
X-Google-Smtp-Source: AGRyM1s9jd0rj28RTzjMiTDsu+XS7RpA+HYRxtnjZa49iDkWruhQJP4cy0PkxwOAeF6i6B+rqrlCWO5wcq3a3zHUmkQ=
X-Received: by 2002:a17:907:3f07:b0:72b:54b2:f57f with SMTP id
 hq7-20020a1709073f0700b0072b54b2f57fmr26915014ejc.502.1658178073581; Mon, 18
 Jul 2022 14:01:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220711083220.2175036-1-asavkov@redhat.com> <20220711083220.2175036-4-asavkov@redhat.com>
 <CAPhsuW7xTRpLf1kyj5ejH0fV_aHCMQjUwn-uhWeNytXedh4+TQ@mail.gmail.com>
 <CAADnVQ+ju04JAqyEbA_7oVj9uBAuL-fUP1FBr_OTygGf915RfQ@mail.gmail.com>
 <Ys7JL9Ih3546Eynf@wtfbox.lan> <CAADnVQ+6aN5nMwaTjoa9ddnT6rakgwb9oPhtdWSsgyaHP8kZ6Q@mail.gmail.com>
 <YtFjCSR8YiK8E13J@samus.usersys.redhat.com>
In-Reply-To: <YtFjCSR8YiK8E13J@samus.usersys.redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 18 Jul 2022 14:01:02 -0700
Message-ID: <CAADnVQLjJK+9Jf+14WNp4O9q+s88eB-FF8pA_5TRziYVKoJxUQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 3/4] bpf: add bpf_panic() helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, dvacek@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 5:52 AM Artem Savkov <asavkov@redhat.com> wrote:
>
> On Wed, Jul 13, 2022 at 03:20:22PM -0700, Alexei Starovoitov wrote:
> > On Wed, Jul 13, 2022 at 6:31 AM Artem Savkov <asavkov@redhat.com> wrote:
> > >
> > > On Tue, Jul 12, 2022 at 11:08:54AM -0700, Alexei Starovoitov wrote:
> > > > On Tue, Jul 12, 2022 at 10:53 AM Song Liu <song@kernel.org> wrote:
> > > > >
> > > > > >
> > > > > > +BPF_CALL_1(bpf_panic, const char *, msg)
> > > > > > +{
> > > > > > +       panic(msg);
> > > > >
> > > > > I think we should also check
> > > > >
> > > > >    capable(CAP_SYS_BOOT) && destructive_ebpf_enabled()
> > > > >
> > > > > here. Or at least, destructive_ebpf_enabled(). Otherwise, we
> > > > > may trigger panic after the sysctl is disabled.
> > > > >
> > > > > In general, I don't think sysctl is a good API, as it is global, and
> > > > > the user can easily forget to turn it back off. If possible, I would
> > > > > rather avoid adding new BPF related sysctls.
> > > >
> > > > +1. New syscal isn't warranted here.
> > > > Just CAP_SYS_BOOT would be enough here.
> > >
> > > Point taken, I'll remove sysctl knob in any further versions.
> > >
> > > > Also full blown panic() seems unnecessary.
> > > > If the motivation is to get a memory dump then crash_kexec() helper
> > > > would be more suitable.
> > > > If the goal is to reboot the system then the wrapper of sys_reboot()
> > > > is better.
> > > > Unfortunately the cover letter lacks these details.
> > >
> > > The main goal is to get the memory dump, so crash_kexec() should be enough.
> > > However panic() is a bit more versatile and it's consequences are configurable
> > > to some extent. Are there any downsides to using it?
> >
> > versatile? In what sense? That it does a lot more than kexec?
> > That's a disadvantage.
> > We should provide bpf with minimal building blocks and let
> > bpf program decide what to do.
> > If dmesg (that is part of panic) is useful it should be its
> > own kfunc.
> > If halt is necessary -> separate kfunc as well.
> > reboot -> another kfunc.
> >
> > Also panic() is not guaranteed to do kexec and just
> > panic is not what you stated is the goal of the helper.
>
> Alright, if the aim is to provide the smallest building blocks then
> crash_kexec() is a better choice.
>
> > >
> > > > Why this destructive action cannot be delegated to user space?
> > >
> > > Going through userspace adds delays and makes it impossible to hit "exactly
> > > the right moment" thus making it unusable in most cases.
> >
> > What would be an example of that?
> > kexec is not instant either.
>
> With kexec at least the thread it got called in is in a proper state. I
> guess it is possible to achieve this by signalling userspace to do
> kexec/panic and then block the thread somehow but that won't work in a
> single-cpu case. Or am I missing something?

Something like this.
We can extend bpf_send_signal to send a signal to pid 1
or another user agent.
It's still not clear to me why you want that memory dump.
