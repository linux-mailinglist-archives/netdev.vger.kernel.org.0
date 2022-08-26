Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29835A23C7
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244935AbiHZJLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245618AbiHZJLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:11:07 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395CBCD527
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 02:11:04 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q81so694642iod.9
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 02:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9WfR61mwlG7xEw+rTgThfNinRNgyKs7+mef9MefL6PA=;
        b=EhvIqLiC9BX9tHc9a+BQqpydsPIjtHyKBmBx0sofnPbgUlRgpWlCGxWIpp5JbnuFup
         2kZoVj99EcwjkfBHBUZg2oipu8wdizJwB4NoGLsfzUAFh/Tk2zvveA8DFExtjEyQ8Dc/
         /pVtcCgigmLtsj7Cwo14GVv+Ocdqf7No5PvDs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9WfR61mwlG7xEw+rTgThfNinRNgyKs7+mef9MefL6PA=;
        b=wFlNYC/wQTXDG2A4Fl9JD3WxOuoSk/Aanpti+aeMLc2xQUIqUTY+gl1w2VfD/9iknF
         nZCVB6n2aZOWj220en3zQB2V8BwMzDIaDBH6VFfflfBvXl/u0+QYiOFFWqrU32T11naj
         AwrJYSGQmUBumPKCIbT09eVZSXVqn4zK+bFeYmF4m7bpKyRX6nOv0YrgPiTfH+lU18AW
         Qx08Izl0xqEvmb3KdoI6P/WY5vkfuXoxpUGD9mK6qwsnjAsIKxKK45m1LLOrblH47lAc
         S99voElFwB1XoQTvG2DgobFRmpSj31epUAYVUh5oA2sVyNfG4BwLEH/rAKLt5/YaR18F
         KtFw==
X-Gm-Message-State: ACgBeo2qFGCmBge9R/ajHM4x7YyEJ09YG1ZZsCKVSc5/KNR57klKaVqL
        +8eOGGETso1u5hFm95EQAzJTddHF3ZXpdgltZqOm9g==
X-Google-Smtp-Source: AA6agR6HH6H4gQKe9WI6NZj2d6w2XPDgEj2DZxqfhfzNbm4v9sn+/Pw662xyRmYU8yITLrnZeY2UhvE0P3+pTftDpXg=
X-Received: by 2002:a05:6638:1244:b0:34a:1104:afa with SMTP id
 o4-20020a056638124400b0034a11040afamr3321877jas.244.1661505063405; Fri, 26
 Aug 2022 02:11:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org> <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
 <871qte8wy3.fsf@email.froward.int.ebiederm.org> <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org> <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org> <20220818140521.GA1000@mail.hallyn.com>
 <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
 <20220819144537.GA16552@mail.hallyn.com> <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
 <875yigp4tp.fsf@email.froward.int.ebiederm.org> <CAHC9VhTN09ZabnQnsmbSjKgb8spx7_hkh4Z+mq5ArQmfPcVqAg@mail.gmail.com>
In-Reply-To: <CAHC9VhTN09ZabnQnsmbSjKgb8spx7_hkh4Z+mq5ArQmfPcVqAg@mail.gmail.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Fri, 26 Aug 2022 10:10:51 +0100
Message-ID: <CALrw=nHRFC-Ws2j-MJAs50oznfRC5fG3a3opmYRkxQCtK61EEg@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org,
        Christian Brauner <brauner@kernel.org>, casey@schaufler-ca.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com, tixxdz@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 8:19 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Thu, Aug 25, 2022 at 2:15 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > Paul Moore <paul@paul-moore.com> writes:
> > > On Fri, Aug 19, 2022 at 10:45 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> > >>  I am hoping we can come up with
> > >> "something better" to address people's needs, make everyone happy, and
> > >> bring forth world peace.  Which would stack just fine with what's here
> > >> for defense in depth.
> > >>
> > >> You may well not be interested in further work, and that's fine.  I need
> > >> to set aside a few days to think on this.
> > >
> > > I'm happy to continue the discussion as long as it's constructive; I
> > > think we all are.  My gut feeling is that Frederick's approach falls
> > > closest to the sweet spot of "workable without being overly offensive"
> > > (*cough*), but if you've got an additional approach in mind, or an
> > > alternative approach that solves the same use case problems, I think
> > > we'd all love to hear about it.
> >
> > I would love to actually hear the problems people are trying to solve so
> > that we can have a sensible conversation about the trade offs.
>
> Here are several taken from the previous threads, it's surely not a
> complete list, but it should give you a good idea:
>
> https://lore.kernel.org/linux-security-module/CAHC9VhQnPAsmjmKo-e84XDJ1wmaOFkTKPjjztsOa9Yrq+AeAQA@mail.gmail.com/
>
> > As best I can tell without more information people want to use
> > the creation of a user namespace as a signal that the code is
> > attempting an exploit.
>
> Some use cases are like that, there are several other use cases that
> go beyond this; see all of our previous discussions on this
> topic/patchset.  As has been mentioned before, there are use cases
> that require improved observability, access control, or both.
>
> > As such let me propose instead of returning an error code which will let
> > the exploit continue, have the security hook return a bool.  With true
> > meaning the code can continue and on false it will trigger using SIGSYS
> > to terminate the program like seccomp does.
>
> Having the kernel forcibly exit the process isn't something that most
> LSMs would likely want.  I suppose we could modify the hook/caller so
> that *if* an LSM wanted to return SIGSYS the system would kill the
> process, but I would want that to be something in addition to
> returning an error code like LSMs normally do (e.g. EACCES).

I would also add here that seccomp allows more flexibility than just
delivering SIGSYS to a violating application. We can program seccomp
bpf to:
  * deliver a signal
  * return a CUSTOM error code (and BTW somehow this does not trigger
any requirements to change userapi or document in manpages: in my toy
example in [1] I'm delivering ENETDOWN from a uname(2) system call,
which is not documented in the man pages, but totally valid from a
seccomp usage perspective)
  * do-nothing, but log the action

So I would say the seccomp reference supports the current approach
more than the alternative approach of delivering SIGSYS as technically
an LSM implementation of the hook (at least in-kernel one) can chose
to deliver a signal to a task via kernel-api, but BPF-LSM (and others)
can deliver custom error codes and log the actions as well.

Ignat

> --
> paul-moore.com

[1]: https://blog.cloudflare.com/sandboxing-in-linux-with-zero-lines-of-code/
