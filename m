Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A77B4165A9
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 21:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242851AbhIWTJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 15:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242845AbhIWTJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 15:09:27 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852A8C0613CF
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 12:07:54 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id dj4so26760722edb.5
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 12:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wPA6Pkqk/8ab9RW5HZw193jEL/3tz5PDXJBPjTVJtdU=;
        b=t1rPCUcoa8HEEbAcar5GeFzOJfqI7UfROKcFgIGMv00KZqB4bGNj1yz/Io6IQtZ9+Z
         NusuDSgjdkYMBVPbv2Vf3ap3Dbmry0u8fptJLN2cjl3LD0YJiwSIuBvYwnbH0rpaioQF
         s88qN4rAhn2A6bjocX70mp+3vXylM59wSuZYYWLOfUKeLAaAxF3Zwk8fzDO06/nV0A9+
         HsVgP4O9uIzFx80rDBeCkIGHcNp1EPBKoNORwSEOCOnT2lOJA5lLnJNU7gfbyJ+41Gti
         zD8XRqIUaiJOWJBUAoo8PMoRjsXYVqkGOPgNVTuehmVHE3E5VSK+CrreHU4ugQScViDj
         7cjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wPA6Pkqk/8ab9RW5HZw193jEL/3tz5PDXJBPjTVJtdU=;
        b=sgRfXy0K40PT+QeXjY8IkuLEYOIPGpiNAv+Zjqr8dEWdhAr4nmqs7QlR4+a9toy9HW
         YldJ8yoSq9fy1vO1Acf8HOHahVA0ybfgLiE6ZIzHgcT86nrvdUMFtx7QGuChWx0KnT0z
         62icCQ1C6QrXvlkj3b0QGKUaxANJw17y3L49NN9AKS5a/fr2ZarOIj8VrGEcH6l8fa1N
         gHTdggja9nN4CdSKkVo510lvk1IKZQMBo2yNseRp/ACDaRHUZzTw+U14Mae1ZQAL24yK
         RwJqHrlX1tVfgYopNG7Z64QjJ6zzmu4eJcuwMB6K6MyRmfrWrnXZjAtc5H2RyvuM3niQ
         xbDA==
X-Gm-Message-State: AOAM530OxLfFnw57PdndJDSyKQw+bnJJfQJTf9kzaP6v4sRm7hFOSptD
        +rG1PXf2OgjkKxkYQX/24tLvTbDXvqiGzYJae9u8
X-Google-Smtp-Source: ABdhPJyHqn4EAltoJO7dd9O2Dz9oZ7VSNs98CCkrk2Tu48ZH4l2ycuGj+3CiT1FgWeVjeG1GWQpOD1Ti5aR3sTkLnrk=
X-Received: by 2002:a50:cf48:: with SMTP id d8mr377146edk.293.1632424072663;
 Thu, 23 Sep 2021 12:07:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210913140229.24797-1-omosnace@redhat.com> <CAHC9VhRw-S+zZUFz5QFFLMBATjo+YbPAiR21jX6p7cT0T+MVLA@mail.gmail.com>
 <CAHC9VhQyejnmLn0NHQiWzikHs8ZdzAUdZ2WqNxgGM6xhJ4mvMQ@mail.gmail.com>
In-Reply-To: <CAHC9VhQyejnmLn0NHQiWzikHs8ZdzAUdZ2WqNxgGM6xhJ4mvMQ@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 23 Sep 2021 15:07:41 -0400
Message-ID: <CAHC9VhSzh90kFR8wzkmwR-YZNtHGAvYyATc2R1UDaBzZ944OFg@mail.gmail.com>
Subject: Re: [PATCH v4] lockdown,selinux: fix wrong subject in some SELinux
 lockdown checks
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-serial@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 10:59 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Mon, Sep 13, 2021 at 5:05 PM Paul Moore <paul@paul-moore.com> wrote:
> >
> > On Mon, Sep 13, 2021 at 10:02 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > >
> > > Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
> > > lockdown") added an implementation of the locked_down LSM hook to
> > > SELinux, with the aim to restrict which domains are allowed to perform
> > > operations that would breach lockdown.
> > >
> > > However, in several places the security_locked_down() hook is called in
> > > situations where the current task isn't doing any action that would
> > > directly breach lockdown, leading to SELinux checks that are basically
> > > bogus.
> > >
> > > To fix this, add an explicit struct cred pointer argument to
> > > security_lockdown() and define NULL as a special value to pass instead
> > > of current_cred() in such situations. LSMs that take the subject
> > > credentials into account can then fall back to some default or ignore
> > > such calls altogether. In the SELinux lockdown hook implementation, use
> > > SECINITSID_KERNEL in case the cred argument is NULL.
> > >
> > > Most of the callers are updated to pass current_cred() as the cred
> > > pointer, thus maintaining the same behavior. The following callers are
> > > modified to pass NULL as the cred pointer instead:
> > > 1. arch/powerpc/xmon/xmon.c
> > >      Seems to be some interactive debugging facility. It appears that
> > >      the lockdown hook is called from interrupt context here, so it
> > >      should be more appropriate to request a global lockdown decision.
> > > 2. fs/tracefs/inode.c:tracefs_create_file()
> > >      Here the call is used to prevent creating new tracefs entries when
> > >      the kernel is locked down. Assumes that locking down is one-way -
> > >      i.e. if the hook returns non-zero once, it will never return zero
> > >      again, thus no point in creating these files. Also, the hook is
> > >      often called by a module's init function when it is loaded by
> > >      userspace, where it doesn't make much sense to do a check against
> > >      the current task's creds, since the task itself doesn't actually
> > >      use the tracing functionality (i.e. doesn't breach lockdown), just
> > >      indirectly makes some new tracepoints available to whoever is
> > >      authorized to use them.
> > > 3. net/xfrm/xfrm_user.c:copy_to_user_*()
> > >      Here a cryptographic secret is redacted based on the value returned
> > >      from the hook. There are two possible actions that may lead here:
> > >      a) A netlink message XFRM_MSG_GETSA with NLM_F_DUMP set - here the
> > >         task context is relevant, since the dumped data is sent back to
> > >         the current task.
> > >      b) When adding/deleting/updating an SA via XFRM_MSG_xxxSA, the
> > >         dumped SA is broadcasted to tasks subscribed to XFRM events -
> > >         here the current task context is not relevant as it doesn't
> > >         represent the tasks that could potentially see the secret.
> > >      It doesn't seem worth it to try to keep using the current task's
> > >      context in the a) case, since the eventual data leak can be
> > >      circumvented anyway via b), plus there is no way for the task to
> > >      indicate that it doesn't care about the actual key value, so the
> > >      check could generate a lot of "false alert" denials with SELinux.
> > >      Thus, let's pass NULL instead of current_cred() here faute de
> > >      mieux.
> > >
> > > Improvements-suggested-by: Casey Schaufler <casey@schaufler-ca.com>
> > > Improvements-suggested-by: Paul Moore <paul@paul-moore.com>
> > > Fixes: 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
> > > Acked-by: Dan Williams <dan.j.williams@intel.com>         [cxl]
> > > Acked-by: Steffen Klassert <steffen.klassert@secunet.com> [xfrm]
> > > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> > > ---
> > >
> > > v4:
> > > - rebase on top of TODO
> > > - fix rebase conflicts:
> > >   * drivers/cxl/pci.c
> > >     - trivial: the lockdown reason was corrected in mainline
> > >   * kernel/bpf/helpers.c, kernel/trace/bpf_trace.c
> > >     - trivial: LOCKDOWN_BPF_READ was renamed to LOCKDOWN_BPF_READ_KERNEL
> > >       in mainline
> > >   * kernel/power/hibernate.c
> > >     - trivial: !secretmem_active() was added to the condition in
> > >       hibernation_available()
> > > - cover new security_locked_down() call in kernel/bpf/helpers.c
> > >   (LOCKDOWN_BPF_WRITE_USER in BPF_FUNC_probe_write_user case)
> > >
> > > v3: https://lore.kernel.org/lkml/20210616085118.1141101-1-omosnace@redhat.com/
> > > - add the cred argument to security_locked_down() and adapt all callers
> > > - keep using current_cred() in BPF, as the hook calls have been shifted
> > >   to program load time (commit ff40e51043af ("bpf, lockdown, audit: Fix
> > >   buggy SELinux lockdown permission checks"))
> > > - in SELinux, don't ignore hook calls where cred == NULL, but use
> > >   SECINITSID_KERNEL as the subject instead
> > > - update explanations in the commit message
> > >
> > > v2: https://lore.kernel.org/lkml/20210517092006.803332-1-omosnace@redhat.com/
> > > - change to a single hook based on suggestions by Casey Schaufler
> > >
> > > v1: https://lore.kernel.org/lkml/20210507114048.138933-1-omosnace@redhat.com/
> >
> > The changes between v3 and v4 all seem sane to me, but I'm going to
> > let this sit for a few days in hopes that we can collect a few more
> > Reviewed-bys and ACKs.  If I don't see any objections I'll merge it
> > mid-week(ish) into selinux/stable-5.15 and plan on sending it to Linus
> > after it goes through a build/test cycle.
>
> Time's up, I just merged this into selinux/stable-5.15 and I'll send
> this to Linus once it passes testing.

... and it's back out of selinux/stable-5.15 in spectacular fashion.
I'll be following up with another SELinux patch today or tomorrow.

-- 
paul moore
www.paul-moore.com
