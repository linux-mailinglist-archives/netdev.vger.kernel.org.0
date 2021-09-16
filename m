Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0BF40D38A
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 08:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbhIPG6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 02:58:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234689AbhIPG6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 02:58:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631775437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8RB13z4WWFvpQhPAtaErfMzrxHDfvjm55tbgAkFGFds=;
        b=RPDMLxyqcYP+JCyK4R7W8cZ/kl8CDkdoFY7RgwTGxojG/BfA9oVyP6RHxxd43yS2hWIGUp
        5gCNg2pdrFZ/IJpzkWimBlgVdA+/i2E09oo6LSzIssv8V9YsdbyJxJkf6URTTGx1intGsA
        7QyJQwyPV03nR/fBjy75ksaOXB6GVMg=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-CuyCqwqeO6ilYI2gLPjuCQ-1; Thu, 16 Sep 2021 02:57:15 -0400
X-MC-Unique: CuyCqwqeO6ilYI2gLPjuCQ-1
Received: by mail-yb1-f198.google.com with SMTP id q18-20020a252a12000000b005b263fcc92eso8167548ybq.8
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 23:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8RB13z4WWFvpQhPAtaErfMzrxHDfvjm55tbgAkFGFds=;
        b=yPUDukUCF12DmuNR005Xcy7VAv3eYBftfMvkVVA3okzq95ykYVsZ1Oz9Uzs9iLHLJe
         Ed+U5OuBJmm9B1GitZaTOTNyngTiC6CZYXhSY0Uj7zpwxUTSm4HUyDZ+mHk2Qt+2FPbY
         dVuqfoyIl9D71f8RSbYNa9y/Zpnu4+Wuicabq1j6qcfMiDRc/hsJxdeUvyHE8Uyba2Ft
         x6e6J0hsAqZlNYe97E5J3eRvXmPltNMZVxT56bY1A/nnS4C40NcUQErn7GIBsBHbGOZt
         fTQJ1WHOfoSM2un5Zl9C4/tsFtLzkodqLenJOfq0k+0LWwyLAuwRzM2e/abykY4uqEAS
         EvtQ==
X-Gm-Message-State: AOAM532YVwGNr/Ib4fe3vGJWzhyTC4iP0Ue4MQyN70k2Bwy+rvhQtBLX
        IgRa9W2NVm6GR2+FiULx6TJmvFwsuaafU+pov8HQKWX8pGIhNwWf5DOKBDXfs0jUr34ZB+7aDv+
        qcsmnpt5PhPcQCNTJykekOIC2Z5TGL3rB
X-Received: by 2002:a25:bb8b:: with SMTP id y11mr5374071ybg.384.1631775434453;
        Wed, 15 Sep 2021 23:57:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLucYeWhnPNQkeQVqS3EcyyweAYtvQL9fa++UxRdE70ZRSeCy7mhVRsSSA5lCGz3A636eqomK45lUsdY3V5KU=
X-Received: by 2002:a25:bb8b:: with SMTP id y11mr5374044ybg.384.1631775434181;
 Wed, 15 Sep 2021 23:57:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210913140229.24797-1-omosnace@redhat.com> <CAHC9VhRw-S+zZUFz5QFFLMBATjo+YbPAiR21jX6p7cT0T+MVLA@mail.gmail.com>
 <CAHC9VhQyejnmLn0NHQiWzikHs8ZdzAUdZ2WqNxgGM6xhJ4mvMQ@mail.gmail.com>
In-Reply-To: <CAHC9VhQyejnmLn0NHQiWzikHs8ZdzAUdZ2WqNxgGM6xhJ4mvMQ@mail.gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Thu, 16 Sep 2021 08:57:02 +0200
Message-ID: <CAFqZXNsLZE18YugJYDzxUwjY36Gt2iX=KYtuuu-erY_+_mmvqg@mail.gmail.com>
Subject: Re: [PATCH v4] lockdown,selinux: fix wrong subject in some SELinux
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
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        X86 ML <x86@kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        linux-cxl@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        linux-serial@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 4:59 AM Paul Moore <paul@paul-moore.com> wrote:
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

Thanks!

-- 
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

