Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9ED5812B2
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 14:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239040AbiGZMC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 08:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239036AbiGZMCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 08:02:55 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D90F3342E;
        Tue, 26 Jul 2022 05:02:54 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id 66so10633566vse.4;
        Tue, 26 Jul 2022 05:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KtaXkWhGacXoZCpMy7nyfriLMatRzT4A6igO1RBUHPo=;
        b=RbjF1rdPTyO2tw9Yz+mkfpmrUfTHxX4BSGAYDyIu8eDnstEazKhSJWG1VfMkaiWvw6
         65PgKI6Ce6BOZu4MwbbN7pyFMgXyv3rN8YP5KYvr06r85CqajjrAeJLEZo/xBozzt+vy
         nFLlEeVewTk7we8Rm+kqwadez/wBkpKI8rtlvaMxI9os9TRuzUQteaDxUB1xoZ+ISDu7
         BCKMKBjtSyiMoeGC0zNja2EPc12+sdgNwdVJjsyLFP9w7+XVDo4/Q9CKQaC1ZNkMa6BA
         JZLXAL5cTLwZkX7PdoYsWW4D0VgIsPV3wezdeMdKyCJCfRioqQFdFoCjxE8D+bzLIZUr
         4LXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KtaXkWhGacXoZCpMy7nyfriLMatRzT4A6igO1RBUHPo=;
        b=IK3YwmGr3vvmxhgZKJeYzRhotReKVwt7EEaLQHB1/jRpK4ho6O632IuLqx35I9vG4p
         NXBi0J4qXLwF73dwxBU+Jy20y+68C7AVd+CpJtZVYOivQSe5GjavVAY4VzMo59Y0/Ivd
         1EbWPvUgSJ8bEX0GRPRJ7r0Mj2gIUmxOI4SAdo5lZzbsosm6cjrYRrJvpS8IW52RhjcX
         udRgE3DVJ9lytIxdSbP7zirX0CNnO7fuSgyLxczYaXjlGXdcoXT6Z9zYg9TOF7WLwpaw
         gLgnJ9jcXTHJvXmfTVXNd58IeggYqTQVjdWmTqL+EtQbEu6hNQY6D77oXTuGdAoLVcoH
         Xe1A==
X-Gm-Message-State: AJIora+cHVxQXgVmXA2j9Corc1RCOyVj/Qo2WDQf4AoYWTE/8IAFZCpG
        CEsuQyBKqxg4yjxQGLiV6eAehinbGqVq2jwZ/pU=
X-Google-Smtp-Source: AGRyM1ufus2ahum67DnRC7F3xxb3xz3gr3Y+e9Qm4V9dLcVGJNH0Tu8+ofs5fhLcN9Ex2YVcvGyk8j+5LIP2gpBwIYU=
X-Received: by 2002:a67:c886:0:b0:358:539d:e1a4 with SMTP id
 v6-20020a67c886000000b00358539de1a4mr3391706vsk.78.1658836972979; Tue, 26 Jul
 2022 05:02:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220721172808.585539-1-fred@cloudflare.com> <877d45kri4.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <877d45kri4.fsf@email.froward.int.ebiederm.org>
From:   Djalal Harouni <tixxdz@gmail.com>
Date:   Tue, 26 Jul 2022 14:02:26 +0200
Message-ID: <CAEiveUdPhEPAk7Y0ZXjPsD=Vb5hn453CHzS9aG-tkyRa8bf_eg@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce security_create_user_ns()
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Frederick Lawler <fred@cloudflare.com>,
        KP Singh <kpsingh@kernel.org>, revest@chromium.org,
        jackmanb@chromium.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john fastabend <john.fastabend@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        stephen.smalley.work@gmail.com, Eric Paris <eparis@parisplace.org>,
        Shuah Khan <shuah@kernel.org>, brauner@kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, bpf@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com
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

Hi Eric,

On Fri, Jul 22, 2022 at 7:07 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Frederick Lawler <fred@cloudflare.com> writes:
>
> > While creating a LSM BPF MAC policy to block user namespace creation, we
> > used the LSM cred_prepare hook because that is the closest hook to prevent
> > a call to create_user_ns().
>
> That description is wrong.  Your goal his is not to limit access to
> the user namespace.  Your goal is to reduce the attack surface of the
> kernel by not allowing some processes access to a user namespace.
>
> You have already said that you don't have concerns about the
> fundamentals of the user namespace, and what it enables only that
> it allows access to exploitable code.
>
> Achieving the protection you seek requires talking and thinking clearly
> about the goal.
>

We have valid use cases not specifically related to the attack surface,
but go into the middle from bpf observability to enforcement. As we want
to track namespace creation, changes, nesting and per task creds context
depending on the nature of the workload.

Obvious example is nesting as we want to track namespace creations
not necessarily user namespace but all to report hierarchies to dashboards,
then from kubernetes namespace view, we would like some applications to
setup namespaces privileged or not, but deny other apps creation of nested
pidns, userns, etc, it depends on users how they setup their kubernetes
namespaces and labels...

...
>
> 2) The second is that there is a long standing problem with code that
>    gets added to the kernel.  Many times new kernel code because it has
>    the potential to confuse suid root executables that code has been
>    made root only.  Over time that results in more and more code running
>    as root to be able to make use of the useful features of the linux
>    kernel.
>
>    One of the goals of the user namespace is to avoid more and more code
>    migrating to running as root.  To achieve that goal ordinary
>    application developers need to be able to assume that typically user
>    namespaces will be available on linux.
>
>    An assumption that ordinary applications like chromium make today.

I don't necessarily disagree with statement 2. and in a perfect world yes.
But practically as noted by Paul in his email, Linux is flexible and
speaking about kubernetes world we have multiple workload per
namespaces, and we would like a solution that we can support in the
next months.

Also these are features that some user space may use, some may not, we
will never be able to dictate to all user space applications how to do things.

From bpf side observability or bpf-lsm enforcement it allows to escalate how
to respond to the task and *make lsm and bpf (bpf-lsm) have a consistent
design* where they both follow the same path.

It is unfortunate that the security_task_alloc() [1] hook is  _late_ and can't
be used for context initialization as the credentials and even user namespace
have already been created. Strictly speaking we have a context that has
been already created and applied and we can't properly catch it !

There is no way to do that from user space as most bpf based tools
(observability and enforcement) do not and should not mess up at the
user space level with the namespace configuration of tasks (/proc...), they
are external programs to the running tasks, they do not set up the
environment. Having the hook before the namespaces and creds copying
allows to properly track this and construct the _right_ context. From lsm
and bpf-lsm this will definitely offer a better interface that is not prone to
errors.

We would like an answer here or an alternative hook that is placed before
the creation/setting of any namespace, credentials or creating new keyring.
So we can provide bpf-based transparent solutions that work.

[1] https://elixir.bootlin.com/linux/v5.18.13/source/kernel/fork.c#L2216



> My apologies if this has been addressed somewhere in the conversation
> already.  I don't see these issues addressed in the descriptions of your
> patches.
>
> Until these issues are firmly addressed and you are not proposing a
> patch that can only cause regressions in userspace applications.
>
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> >
> > The calls look something like this:
> >
> >     cred = prepare_creds()
> >         security_prepare_creds()
> >             call_int_hook(cred_prepare, ...
> >     if (cred)
> >         create_user_ns(cred)
> >
> > We noticed that error codes were not propagated from this hook and
> > introduced a patch [1] to propagate those errors.
> >
> > The discussion notes that security_prepare_creds()
> > is not appropriate for MAC policies, and instead the hook is
> > meant for LSM authors to prepare credentials for mutation. [2]
> >
> > Ultimately, we concluded that a better course of action is to introduce
> > a new security hook for LSM authors. [3]
> >
> > This patch set first introduces a new security_create_user_ns() function
> > and userns_create LSM hook, then marks the hook as sleepable in BPF.
> >
> > Links:
> > 1. https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
> > 2. https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/
> > 3. https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/
> >
> > Past discussions:
> > V2: https://lore.kernel.org/all/20220707223228.1940249-1-fred@cloudflare.com/
> > V1: https://lore.kernel.org/all/20220621233939.993579-1-fred@cloudflare.com/
> >
> > Changes since v2:
> > - Rename create_user_ns hook to userns_create
> > - Use user_namespace as an object opposed to a generic namespace object
> > - s/domB_t/domA_t in commit message
> > Changes since v1:
> > - Add selftests/bpf: Add tests verifying bpf lsm create_user_ns hook patch
> > - Add selinux: Implement create_user_ns hook patch
> > - Change function signature of security_create_user_ns() to only take
> >   struct cred
> > - Move security_create_user_ns() call after id mapping check in
> >   create_user_ns()
> > - Update documentation to reflect changes
> >
> > Frederick Lawler (4):
> >   security, lsm: Introduce security_create_user_ns()
> >   bpf-lsm: Make bpf_lsm_userns_create() sleepable
> >   selftests/bpf: Add tests verifying bpf lsm userns_create hook
> >   selinux: Implement userns_create hook
> >
> >  include/linux/lsm_hook_defs.h                 |  1 +
> >  include/linux/lsm_hooks.h                     |  4 +
> >  include/linux/security.h                      |  6 ++
> >  kernel/bpf/bpf_lsm.c                          |  1 +
> >  kernel/user_namespace.c                       |  5 ++
> >  security/security.c                           |  5 ++
> >  security/selinux/hooks.c                      |  9 ++
> >  security/selinux/include/classmap.h           |  2 +
> >  .../selftests/bpf/prog_tests/deny_namespace.c | 88 +++++++++++++++++++
> >  .../selftests/bpf/progs/test_deny_namespace.c | 39 ++++++++
> >  10 files changed, 160 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/deny_namespace.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_deny_namespace.c
> >
> > --
> > 2.30.2
>
> Eric
