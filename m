Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEE13FC4D8
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240567AbhHaJJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 05:09:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240562AbhHaJJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 05:09:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630400901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lCeb7MSVHIA6AQvPBMrpCMcewt6C5Hp/EtiNe37zzes=;
        b=i78ERYluR7U0MnuTP2c4SZEJQw7R6xWSZDUwo4svsbS6EryWz5d+nIPKIJiQUDQX0ymwl7
        FLIdYiafRUopCaU+8HyBNyaK0RpRKTUrC5UWRc/xdpGtZi45V79V/2xVc8rtt8vYPpQCAX
        /JHJ/d2wvU5eeyrVLdiQqDEP55QwoNg=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-H6CDJUOBNUW2jwBfmb5-Yw-1; Tue, 31 Aug 2021 05:08:20 -0400
X-MC-Unique: H6CDJUOBNUW2jwBfmb5-Yw-1
Received: by mail-yb1-f197.google.com with SMTP id z6-20020a257e06000000b0059bad6decfbso2069852ybc.16
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 02:08:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lCeb7MSVHIA6AQvPBMrpCMcewt6C5Hp/EtiNe37zzes=;
        b=RVUC4UtSTMaj1DCiNmWa3OwWKn2SC6bHSeHl74AgTi0jAa9Szq3JMeGtwDHoO1JTXR
         OcY4tzMeev4y33PDSaENISBSa1w8GiqSm5H440SMDIq3Hb5h6N3s+quiw7H+7+KaaZI7
         KndpFmGK1LM8I6ThH8BRrK7GKchvz2R5gZ3v9Db0umAUzHaGqQL0+GQzsPgiQRRrEDdC
         3eelArOX4Zr403qIdOONcZsceXtV8xkkz8gapvApNYosS6G0Eyz3VOVkaPKRzPM9cwFr
         1xqV/7wm/g7YjoJySKI9VJyXDUM3btWyyVA1gA0Wb3TkjiSNdqilYx10VVwpXoM7Nogv
         gkBQ==
X-Gm-Message-State: AOAM533DxTwIaJjTLceUj8EeSKVlE39Gu+yuKqCnpEs2HadttYBtBfc6
        eZQip4KYA3+IBWAesLoi43aBTrXzG+IfG82QD2wo1/FwlstHdijcVaw/ydzA/Zhen7mJZfC605C
        IWkvxFVawoyTdaMbW32KoADnyoLY2WiV/
X-Received: by 2002:a25:c184:: with SMTP id r126mr28651646ybf.123.1630400899631;
        Tue, 31 Aug 2021 02:08:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4ZNnqHdPHd1KpwqFLFV6AFeVHb5LZ7Jb5RG2vtJXhk7vybNwPbdTc2aQhHuASLbfSbAuaEwPm90oIL61rhUM=
X-Received: by 2002:a25:c184:: with SMTP id r126mr28651621ybf.123.1630400899378;
 Tue, 31 Aug 2021 02:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210616085118.1141101-1-omosnace@redhat.com> <CAHC9VhSr2KpeBXuyoHR3_hs+qczFUaBx0oCSMfBBA5UNYU+0KA@mail.gmail.com>
In-Reply-To: <CAHC9VhSr2KpeBXuyoHR3_hs+qczFUaBx0oCSMfBBA5UNYU+0KA@mail.gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Tue, 31 Aug 2021 11:08:08 +0200
Message-ID: <CAFqZXNvJtMOfLk-SLt2S2qt=+-x8fm9jS3NKxFoT0_5d2=8Ckg@mail.gmail.com>
Subject: Re: [PATCH v3] lockdown,selinux: fix wrong subject in some SELinux
 lockdown checks
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-efi@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-serial@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kexec@lists.infradead.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 5:40 AM Paul Moore <paul@paul-moore.com> wrote:
> On Wed, Jun 16, 2021 at 4:51 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> >
> > Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
> > lockdown") added an implementation of the locked_down LSM hook to
> > SELinux, with the aim to restrict which domains are allowed to perform
> > operations that would breach lockdown.
> >
> > However, in several places the security_locked_down() hook is called in
> > situations where the current task isn't doing any action that would
> > directly breach lockdown, leading to SELinux checks that are basically
> > bogus.
> >
> > To fix this, add an explicit struct cred pointer argument to
> > security_lockdown() and define NULL as a special value to pass instead
> > of current_cred() in such situations. LSMs that take the subject
> > credentials into account can then fall back to some default or ignore
> > such calls altogether. In the SELinux lockdown hook implementation, use
> > SECINITSID_KERNEL in case the cred argument is NULL.
> >
> > Most of the callers are updated to pass current_cred() as the cred
> > pointer, thus maintaining the same behavior. The following callers are
> > modified to pass NULL as the cred pointer instead:
> > 1. arch/powerpc/xmon/xmon.c
> >      Seems to be some interactive debugging facility. It appears that
> >      the lockdown hook is called from interrupt context here, so it
> >      should be more appropriate to request a global lockdown decision.
> > 2. fs/tracefs/inode.c:tracefs_create_file()
> >      Here the call is used to prevent creating new tracefs entries when
> >      the kernel is locked down. Assumes that locking down is one-way -
> >      i.e. if the hook returns non-zero once, it will never return zero
> >      again, thus no point in creating these files. Also, the hook is
> >      often called by a module's init function when it is loaded by
> >      userspace, where it doesn't make much sense to do a check against
> >      the current task's creds, since the task itself doesn't actually
> >      use the tracing functionality (i.e. doesn't breach lockdown), just
> >      indirectly makes some new tracepoints available to whoever is
> >      authorized to use them.
> > 3. net/xfrm/xfrm_user.c:copy_to_user_*()
> >      Here a cryptographic secret is redacted based on the value returned
> >      from the hook. There are two possible actions that may lead here:
> >      a) A netlink message XFRM_MSG_GETSA with NLM_F_DUMP set - here the
> >         task context is relevant, since the dumped data is sent back to
> >         the current task.
> >      b) When adding/deleting/updating an SA via XFRM_MSG_xxxSA, the
> >         dumped SA is broadcasted to tasks subscribed to XFRM events -
> >         here the current task context is not relevant as it doesn't
> >         represent the tasks that could potentially see the secret.
> >      It doesn't seem worth it to try to keep using the current task's
> >      context in the a) case, since the eventual data leak can be
> >      circumvented anyway via b), plus there is no way for the task to
> >      indicate that it doesn't care about the actual key value, so the
> >      check could generate a lot of "false alert" denials with SELinux.
> >      Thus, let's pass NULL instead of current_cred() here faute de
> >      mieux.
> >
> > Improvements-suggested-by: Casey Schaufler <casey@schaufler-ca.com>
> > Improvements-suggested-by: Paul Moore <paul@paul-moore.com>
> > Fixes: 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
>
> This seems reasonable to me, but before I merge it into the SELinux
> tree I think it would be good to get some ACKs from the relevant
> subsystem folks.  I don't believe we ever saw a response to the last
> question for the PPC folks, did we?

Can we move this forward somehow, please?

Quoting the yet-unanswered question from the v2 thread for convenience:

> > > The callers migrated to the new hook, passing NULL as cred:
> > > 1. arch/powerpc/xmon/xmon.c
[...]
> >
> > This definitely sounds like kernel_t based on the description above.
>
> Here I'm a little concerned that the hook might be called from some
> unusual interrupt, which is not masked by spin_lock_irqsave()... We
> ran into this with PMI (Platform Management Interrupt) before, see
> commit 5ae5fbd21079 ("powerpc/perf: Fix handling of privilege level
> checks in perf interrupt context"). While I can't see anything that
> would suggest something like this happening here, the whole thing is
> so foreign to me that I'm wary of making assumptions :)
>
> @Michael/PPC devs, can you confirm to us that xmon_is_locked_down() is
> only called from normal syscall/interrupt context (as opposed to
> something tricky like PMI)?

I strongly suspect the answer will be just "Of course it is, why would
you even ask such a silly question?", but please let's have it on
record so we can finally get this patch merged...


> > ---
> >
> > v3:
> > - add the cred argument to security_locked_down() and adapt all callers
> > - keep using current_cred() in BPF, as the hook calls have been shifted
> >   to program load time (commit ff40e51043af ("bpf, lockdown, audit: Fix
> >   buggy SELinux lockdown permission checks"))
> > - in SELinux, don't ignore hook calls where cred == NULL, but use
> >   SECINITSID_KERNEL as the subject instead
> > - update explanations in the commit message
> >
> > v2: https://lore.kernel.org/lkml/20210517092006.803332-1-omosnace@redhat.com/
> > - change to a single hook based on suggestions by Casey Schaufler
> >
> > v1: https://lore.kernel.org/lkml/20210507114048.138933-1-omosnace@redhat.com/
> >
> >  arch/powerpc/xmon/xmon.c             |  4 ++--
> >  arch/x86/kernel/ioport.c             |  4 ++--
> >  arch/x86/kernel/msr.c                |  4 ++--
> >  arch/x86/mm/testmmiotrace.c          |  2 +-
> >  drivers/acpi/acpi_configfs.c         |  2 +-
> >  drivers/acpi/custom_method.c         |  2 +-
> >  drivers/acpi/osl.c                   |  3 ++-
> >  drivers/acpi/tables.c                |  2 +-
> >  drivers/char/mem.c                   |  2 +-
> >  drivers/cxl/mem.c                    |  2 +-
> >  drivers/firmware/efi/efi.c           |  2 +-
> >  drivers/firmware/efi/test/efi_test.c |  2 +-
> >  drivers/pci/pci-sysfs.c              |  6 +++---
> >  drivers/pci/proc.c                   |  6 +++---
> >  drivers/pci/syscall.c                |  2 +-
> >  drivers/pcmcia/cistpl.c              |  2 +-
> >  drivers/tty/serial/serial_core.c     |  2 +-
> >  fs/debugfs/file.c                    |  2 +-
> >  fs/debugfs/inode.c                   |  2 +-
> >  fs/proc/kcore.c                      |  2 +-
> >  fs/tracefs/inode.c                   |  2 +-
> >  include/linux/lsm_hook_defs.h        |  2 +-
> >  include/linux/lsm_hooks.h            |  1 +
> >  include/linux/security.h             |  4 ++--
> >  kernel/bpf/helpers.c                 | 10 ++++++----
> >  kernel/events/core.c                 |  2 +-
> >  kernel/kexec.c                       |  2 +-
> >  kernel/kexec_file.c                  |  2 +-
> >  kernel/module.c                      |  2 +-
> >  kernel/params.c                      |  2 +-
> >  kernel/power/hibernate.c             |  3 ++-
> >  kernel/trace/bpf_trace.c             | 20 ++++++++++++--------
> >  kernel/trace/ftrace.c                |  4 ++--
> >  kernel/trace/ring_buffer.c           |  2 +-
> >  kernel/trace/trace.c                 | 10 +++++-----
> >  kernel/trace/trace_events.c          |  2 +-
> >  kernel/trace/trace_events_hist.c     |  4 ++--
> >  kernel/trace/trace_events_synth.c    |  2 +-
> >  kernel/trace/trace_events_trigger.c  |  2 +-
> >  kernel/trace/trace_kprobe.c          |  6 +++---
> >  kernel/trace/trace_printk.c          |  2 +-
> >  kernel/trace/trace_stack.c           |  2 +-
> >  kernel/trace/trace_stat.c            |  2 +-
> >  kernel/trace/trace_uprobe.c          |  4 ++--
> >  net/xfrm/xfrm_user.c                 | 11 +++++++++--
> >  security/lockdown/lockdown.c         |  3 ++-
> >  security/security.c                  |  4 ++--
> >  security/selinux/hooks.c             |  7 +++++--
> >  48 files changed, 97 insertions(+), 77 deletions(-)
>
> --
> paul moore
> www.paul-moore.com
>

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc

