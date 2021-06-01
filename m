Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441D2397B60
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 22:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbhFAUtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 16:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbhFAUtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 16:49:06 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD26BC06175F
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 13:47:23 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w21so81855edv.3
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 13:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tTNIBzYtON70L8W0i/P9C9vefa2RWt2U+aq2jjrO0Nw=;
        b=a7qjHsKTaqa3sWrWdZ5Gh9wO8wYHYyLL1wPg/UcCE7WulKyadI3xcZi7iFuzK0u1Ce
         IkSY1GVr6EEc8j3nyeg4ebI1UMrBkZhJ4VQc/fi9aoa2EltyNevU04GfDQ5ppE1IbA8B
         o/MByBqkj1YE9ylhArUoRCj0NUDDOzKmyG/jCGVAasz7umc4Dr4Pd/t6Eyy7zlYWliQq
         4ArqLMbKLawihtbRZaRj6YUhJNMF+wo/VNZBxG78x6i56+dgCU1YWPsuNdHxjOGUGzvK
         bHh6Y91IphMkFIda1nqGEdYuSLZ6RDd4IGBJvo9dx8WnU2kK8sOcCJ9N7gn+NW/tjSkf
         aJhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tTNIBzYtON70L8W0i/P9C9vefa2RWt2U+aq2jjrO0Nw=;
        b=W/EQnjYCVTxVupylCyIOPMaXNJyLk/UDRywpIzo5j9ykhKlcLd5DyNafu1K0PXG98/
         Ges3AaxZnfs/nVK+ii56cBQVfppWYhHNglPAqbPGW3X+2Pps4jB450HIQHe5hkI2l7pI
         0n1QI2nl0UrArE8brI+SNyC2qy9fNoFDRUkl6W3FGZKoo0tjzt28A7i5zqxy8/RueO+/
         AyNdh8C0Qgv5zJHLT+Abw9lok0JWJ6qoJpUwUM6SMSuh/CdXMRv2A419A26tFvPuCv3E
         EAvZXiryLv+ZdKgQy4PTie9bS9AlgcoPe3YER+dJIwRK7YavO1jyYMqGI4eMIe/vprdf
         Lksw==
X-Gm-Message-State: AOAM5329/4wOSSNxBzI3uyL74CiE9RORKPb2ABvJFySkJHfDuiSrxmCC
        ilk9igmKseIBo4p8A1yYeww6Tipy+VqI1ozydeRk
X-Google-Smtp-Source: ABdhPJwU7tcZXG/Pm25o7D7/1VUxLtr+XnMQYQgFFvc5bxqJe1U1fscpsf+4cHErKF2itcPOfxYxe2ICVSz4Nvu1ZGs=
X-Received: by 2002:aa7:d84e:: with SMTP id f14mr21519965eds.12.1622580442071;
 Tue, 01 Jun 2021 13:47:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210517092006.803332-1-omosnace@redhat.com> <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net> <CAHC9VhR-kYmMA8gsqkiL5=poN9FoL-uCyx1YOLCoG2hRiUBYug@mail.gmail.com>
 <c7c2d7e1-e253-dce0-d35c-392192e4926e@iogearbox.net> <CAHC9VhS1XRZjKcTFgH1+n5uA-CeT+9BeSP5jvT2+RE5ougLpUg@mail.gmail.com>
 <2e541bdc-ae21-9a07-7ac7-6c6a4dda09e8@iogearbox.net>
In-Reply-To: <2e541bdc-ae21-9a07-7ac7-6c6a4dda09e8@iogearbox.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 1 Jun 2021 16:47:10 -0400
Message-ID: <CAHC9VhT464vr9sWxqY3PRB4DAccz=LvRMLgWBsSViWMR0JJvOQ@mail.gmail.com>
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, jolsa@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 4:24 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 5/29/21 8:48 PM, Paul Moore wrote:
> [...]
> > Daniel's patch side steps that worry by just doing the lockdown
> > permission check when the BPF program is loaded, but that isn't a
> > great solution if the policy changes afterward.  I was hoping there
> > might be some way to perform the permission check as needed, but the
> > more I look the more that appears to be difficult, if not impossible
> > (once again, corrections are welcome).
>
> Your observation is correct, will try to clarify below a bit.
>
> > I'm now wondering if the right solution here is to make use of the LSM
> > notifier mechanism.  I'm not yet entirely sure if this would work from
> > a BPF perspective, but I could envision the BPF subsystem registering
> > a LSM notification callback via register_blocking_lsm_notifier(), see
> > if Infiniband code as an example, and then when the LSM(s) policy
> > changes the BPF subsystem would get a notification and it could
> > revalidate the existing BPF programs and take block/remove/whatever
> > the offending BPF programs.  This obviously requires a few things
> > which I'm not sure are easily done, or even possible:
> >
> > 1. Somehow the BPF programs would need to be "marked" at
> > load/verification time with respect to their lockdown requirements so
> > that decisions can be made later.  Perhaps a flag in bpf_prog_aux?
> >
> > 2. While it looks like it should be possible to iterate over all of
> > the loaded BPF programs in the LSM notifier callback via
> > idr_for_each(prog_idr, ...), it is not clear to me if it is possible
> > to safely remove, or somehow disable, BPF programs once they have been
> > loaded.  Hopefully the BPF folks can help answer that question.
> >
> > 3. Disabling of BPF programs might be preferable to removing them
> > entirely on LSM policy changes as it would be possible to make the
> > lockdown state less restrictive at a future point in time, allowing
> > for the BPF program to be executed again.  Once again, not sure if
> > this is even possible.
>
> Part of why this gets really complex/impossible is that BPF programs in
> the kernel are reference counted from various sides, be it that there
> are references from user space to them (fd from application, BPF fs, or
> BPF links), hooks where they are attached to as well as tail call maps
> where one BPF prog calls into another. There is currently also no global
> infra of some sort where you could piggy back to atomically keep track of
> all the references in a list or such. And the other thing is that BPF progs
> have no ownership that is tied to a specific task after they have been
> loaded. Meaning, once they are loaded into the kernel by an application
> and attached to a specific hook, they can remain there potentially until
> reboot of the node, so lifecycle of the user space application != lifecycle
> of the BPF program.

I don't think the disjoint lifecycle or lack of task ownership is a
deal breaker from a LSM perspective as the LSMs can stash whatever
info they need in the security pointer during the program allocation
hook, e.g. selinux_bpf_prog_alloc() saves the security domain which
allocates/loads the BPF program.

The thing I'm worried about would be the case where a LSM policy
change requires that an existing BPF program be removed or disabled.
I'm guessing based on the refcounting that there is not presently a
clean way to remove a BPF program from the system, but is this
something we could resolve?  If we can't safely remove a BPF program
from the system, can we replace/swap it with an empty/NULL BPF
program?

> It's maybe best to compare this aspect to kernel modules in the sense that
> you have an application that loads it into the kernel (insmod, etc, where
> you could also enforce lockdown signature check), but after that, they can
> be managed by other entities as well (implicitly refcounted from kernel,
> removed by other applications, etc).

Well, I guess we could consider BPF programs as out-of-tree kernel
modules that potentially do very odd and dangerous things, e.g.
performing access control checks *inside* access control checks ...
but yeah, I get your point at a basic level, I just think that
comparing BPF programs to kernel modules is a not-so-great comparison
in general.

> My understanding of the lockdown settings are that users have options
> to select/enforce a lockdown level of CONFIG_LOCK_DOWN_KERNEL_FORCE_{INTEGRITY,
> CONFIDENTIALITY} at compilation time, they have a lockdown={integrity|
> confidentiality} boot-time parameter, /sys/kernel/security/lockdown,
> and then more fine-grained policy via 59438b46471a ("security,lockdown,selinux:
> implement SELinux lockdown"). Once you have set a global policy level,
> you cannot revert back to a less strict mode.

I don't recall there being anything in the SELinux lockdown support
that prevents a newly loaded policy from allowing a change in the
lockdown level, either stricter or more permissive, for a given
domain.  Looking quickly at the code, that still seems to be the case.

The SELinux lockdown access controls function independently of the
global build and runtime lockdown configuration.

> So the SELinux policy is
> specifically tied around tasks to further restrict applications in respect
> to the global policy.

As a reminder, there is no guarantee that both the SELinux and
lockdown LSM are both loaded and active at runtime, it is possible
that only SELinux is active.  If SELinux is the only LSM enforcing
lockdown access controls, there is no global lockdown setting, it is
determined per-domain.

> I presume that would mean for those users that majority
> of tasks have the confidentiality option set via SELinux with just a few
> necessary using the integrity global policy. So overall the enforcing
> option when BPF program is loaded is the only really sensible option to
> me given only there we have the valid current task where such policy can
> be enforced.

--
paul moore
www.paul-moore.com
