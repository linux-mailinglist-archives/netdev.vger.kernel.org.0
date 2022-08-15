Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8A259332E
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 18:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiHOQ0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 12:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239307AbiHOQZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 12:25:45 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DAB1CFDE
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 09:24:56 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id c185so9074446oia.7
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 09:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=7ou0ECd+4fAETC6hUkJMnLd+W0E7PsRe0P5UWcQigd4=;
        b=r+RpI+fMnzNHCFytU8UQ6nqIGDekSiKjvnTfzmwojHh6GqRmNJHdQWc6O9nDgRuDwk
         Ga4Ox1wL7y+uei52ve+yaSwaRkPBWWK8kqCr1An7bmrmYToxs6UCkJZV80xos3sHRGSk
         1vb+TaKwN50PHglyQ3nYnXzvU/XY9FJHBOhzferuzdGK9MfLCapVAOf5z0fZO3+BFEoi
         RMggn+oUSSpJEGUoJClAZTewxIpvaALlukAXUMyVSpgfCQf+c5s7lwpf1GKxNuG6zxsC
         +n+gmU13vGpz5lSoxFz0KKCz9uOA1nyVoeMWst3sc5wUYv+Xc3HsNEJYy8Eb10zYNlRW
         sBwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=7ou0ECd+4fAETC6hUkJMnLd+W0E7PsRe0P5UWcQigd4=;
        b=zY4zcksqH0Bijy/yRskYeQ0Mb4omL3KqaZB57HmAsiPWkXC7jUn5evwU/vpRfALvy0
         3tVJh5lw1oMEQEz/ksB0uIXvMjmlezwrt3WYdwVpb5pGYhhx3NkT3btWmqn3FXoWBIgF
         XUBz4J9lJ9XzC7it/MvRFfVz3PN3SR3mtdhn//yHIfgD/GmoWtREDlMwqhmyjXgz0m/D
         RKGza4zJCQ0zvZaUIcBbE46joYD/jERKNPizZ4eeDNWcZQxvu/p9GioMq68B6U8u0JiT
         XkFj5CdOAyFLOB5Dkal6moAgWi1aNQaLq6I85n5POM9p4FclVgh1jhtxASV4Jxx7jD0M
         eUUA==
X-Gm-Message-State: ACgBeo1wsQR78zCNha1FY9ljtTiwmX7p4PADYpgKAPFWPb/fsA75Aw9Y
        DtYr2HffXiy+sUGXM1hf11P91zKdIx1Qe8Lj4YvL
X-Google-Smtp-Source: AA6agR7KPHU1UFRQrkzLWmW555Jup4By1WQs4vqqr4MrHP0gT04wxxp0WpKGu1ttrDKgzeH3Ubo1pUQ7WuULUJjuKuQ=
X-Received: by 2002:aca:b7d5:0:b0:343:c478:91c6 with SMTP id
 h204-20020acab7d5000000b00343c47891c6mr5194559oif.136.1660580695486; Mon, 15
 Aug 2022 09:24:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220801180146.1157914-1-fred@cloudflare.com> <87les7cq03.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhRpUxyxkPaTz1scGeRm+i4KviQQA7WismOX2q5agzC+DQ@mail.gmail.com>
 <87wnbia7jh.fsf@email.froward.int.ebiederm.org> <CAHC9VhS3udhEecVYVvHm=tuqiPGh034-xPqXYtFjBk23+p-Szg@mail.gmail.com>
 <20220814155508.GA7991@mail.hallyn.com> <CAHC9VhRSCXCM51xpOT95G_WVi=UQ44gNV=uvvG23p8wn16uYSA@mail.gmail.com>
 <20220815154102.GA20944@mail.hallyn.com>
In-Reply-To: <20220815154102.GA20944@mail.hallyn.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 15 Aug 2022 12:24:44 -0400
Message-ID: <CAHC9VhTj9BHxa=NmnoOdT-iJ-o_cZP4RbWZ7kvA7VY_viN_hvw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
To:     "Serge E. Hallyn" <serge@hallyn.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, brauner@kernel.org,
        casey@schaufler-ca.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 11:41 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> On Sun, Aug 14, 2022 at 10:32:51PM -0400, Paul Moore wrote:
> > On Sun, Aug 14, 2022 at 11:55 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> > > On Mon, Aug 08, 2022 at 03:16:16PM -0400, Paul Moore wrote:
> > > > On Mon, Aug 8, 2022 at 2:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > > > Paul Moore <paul@paul-moore.com> writes:
> > > > > > On Mon, Aug 1, 2022 at 10:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > > > >> Frederick Lawler <fred@cloudflare.com> writes:
> > > > > >>
> > > > > >> > While creating a LSM BPF MAC policy to block user namespace creation, we
> > > > > >> > used the LSM cred_prepare hook because that is the closest hook to prevent
> > > > > >> > a call to create_user_ns().
> > > > > >>
> > > > > >> Re-nack for all of the same reasons.
> > > > > >> AKA This can only break the users of the user namespace.
> > > > > >>
> > > > > >> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > > >>
> > > > > >> You aren't fixing what your problem you are papering over it by denying
> > > > > >> access to the user namespace.
> > > > > >>
> > > > > >> Nack Nack Nack.
> > > > > >>
> > > > > >> Stop.
> > > > > >>
> > > > > >> Go back to the drawing board.
> > > > > >>
> > > > > >> Do not pass go.
> > > > > >>
> > > > > >> Do not collect $200.
> > > > > >
> > > > > > If you want us to take your comments seriously Eric, you need to
> > > > > > provide the list with some constructive feedback that would allow
> > > > > > Frederick to move forward with a solution to the use case that has
> > > > > > been proposed.  You response above may be many things, but it is
> > > > > > certainly not that.
> > > > >
> > > > > I did provide constructive feedback.  My feedback to his problem
> > > > > was to address the real problem of bugs in the kernel.
> > > >
> > > > We've heard from several people who have use cases which require
> > > > adding LSM-level access controls and observability to user namespace
> > > > creation.  This is the problem we are trying to solve here; if you do
> > > > not like the approach proposed in this patchset please suggest another
> > > > implementation that allows LSMs visibility into user namespace
> > > > creation.
> > >
> > > Regarding the observability - can someone concisely lay out why just
> > > auditing userns creation would not suffice?  Userspace could decide
> > > what to report based on whether the creating user_ns == /proc/1/ns/user...
> >
> > One of the selling points of the BPF LSM is that it allows for various
> > different ways of reporting and logging beyond audit.  However, even
> > if it was limited to just audit I believe that provides some useful
> > justification as auditing fork()/clone() isn't quite the same and
> > could be difficult to do at scale in some configurations.  I haven't
> > personally added a BPF LSM program to the kernel so I can't speak to
> > the details on what is possible, but I'm sure others on the To/CC line
> > could help provide more information if that is important to you.
> >
> > > Regarding limiting the tweaking of otherwise-privileged code by
> > > unprivileged users, i wonder whether we could instead add smarts to
> > > ns_capable().
> >
> > The existing security_capable() hook is eventually called by ns_capable():
> >
> >   ns_capable()
> >     ns_capable_common()
> >       security_capable(const struct cred *cred,
> >                        struct user_namespace *ns,
> >                        int cap,
> >                        unsigned int opts);
> >
> > ... I'm not sure what additional smarts would be useful here?
>
> Oh - i wasn't necessarily thinking of an LSM.  I was picturing a
> sysctl next to unprivileged_userns_clone.  But you're right, looks
> like an LSM could already do this.  Of course, there's an issue early
> on in that the root user in the new namespace couldn't setuid, so
> the uid mapping is still limited.  So this idea probably isn't worth
> the characters we've typed about it so far, sorry.

No harm, no foul.  This thread has already reached record lows with
respect to usefulness-vs-characters ratio, a few more isn't going to
hurt anything ;)

> > [side note: SELinux does actually distinguish between capability
> > checks in the initial user namespace vs child namespaces]
> >
> > > Point being, uid mapping would still work, but we'd
> > > break the "privileged against resources you own" part of user
> > > namespaces.  I would want it to default to allow, but then when a
> > > 0-day is found which requires reaching ns_capable() code, admins
> > > could easily prevent exploitation until reboot from a fixed kernel.
> >
> > That assumes that everything you care about is behind a capability
> > check, which is probably going to be correct in a lot of the cases,
> > but I think it would be a mistake to assume that is always going to be
> > true.
>
> I might be thinking wrongly, but if it's not behind a capability check,
> then it seems to me it's not an exploit that can only be reached by
> becoming root in a user namespace, which means disabling user namespace
> creation by unprivileged users will not stop the attack.

I was primarily thinking about two things: subj/obj relationships
which are really not addressed with capability checks, and unrelated
problems which aren't the fault of the user namespace but could be
somehow made easier through some of the unique situations offered by
user namespaces.  There are exploits that often require chaining
together multiple "things" to trigger the necessary flaw, and
sometimes the most immediate way to stop such an attack is to apply
additional controls to one of these intermediate steps.  Frekerick's
work puts the necessary infrastructure in place so we can do that with
user namespaces.

-- 
paul-moore.com
