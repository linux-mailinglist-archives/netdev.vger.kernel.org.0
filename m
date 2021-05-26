Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77380391671
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhEZLqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:46:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60801 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232829AbhEZLqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 07:46:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622029517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5Uw+/IY4PFLhc9QD0XQTD8Vq22Bv9V1A42B8cw/tcfQ=;
        b=PV4ISET/MSGNoR/qinkk7kLUo05DbFd2wCawswmA/6OoQbDcBLBD8iWLorabdZbPb6XZLe
        9JVBO7DR4iE5KnBFOBDs6a0uNyZFPkYMNiCpbQ8xXo8IMd36F7fLgCGBxmywPFXuLJbGLY
        dKx66nnHCQY5wyWFFMoH58/tD6iwHNY=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-MKZMMzKDMOuLcW9mcC-SEQ-1; Wed, 26 May 2021 07:45:15 -0400
X-MC-Unique: MKZMMzKDMOuLcW9mcC-SEQ-1
Received: by mail-yb1-f197.google.com with SMTP id d89-20020a25a3620000b02904dc8d0450c6so1377301ybi.2
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 04:45:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Uw+/IY4PFLhc9QD0XQTD8Vq22Bv9V1A42B8cw/tcfQ=;
        b=TH2n4n3gcyENcQapajr5Ankbf5un0z5zSPgbAdOsJywsRBPOvS/5CGnOqQY38qgjWy
         lstzTCh8xArACuN7IAC9r/40pfyOOVsAbIM5JFit1L+TEjhfd4k04LRjmytbTQ9Ie1ob
         cGhUBSI5n+cMedzIiVEvdAaSbgh4aqB/0+QhCBonktg6FUKZwVcoD+C+F3QAxu18uSxZ
         zL9yIGxs1bghEHz/AD4luj3Hz5Xt5zsu7Z0RWS/T5WTgsr9MUgFOHg7MvRF0wUGlbXfF
         HipqDU7gSsyLazSuo3xMtgWCPCd1PBqVqoTvI1Kka3WTUSWDuagxydDzTc2EXuIYoEhF
         0ZCQ==
X-Gm-Message-State: AOAM533IX3nIzkYRy4zxPJW70y2tQoI4H/VyEJLVrCsuSeFtaQCfZwa6
        BVuInu6Bw+R8Sc4C6mUt3/cbYoOHb1/Jy9bNc/VZ/cayV4AGUfdTSdOmotg4kOzfdyX9McNSbc5
        i5bjvuKZpn0fKFDkV3+d2nKVh8/zlIRwA
X-Received: by 2002:a25:f50e:: with SMTP id a14mr48352356ybe.172.1622029514557;
        Wed, 26 May 2021 04:45:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7JX0t9Q+MjZUdNuGYqNNwFWjv7mwlUzB5zjT5J9a7c3DzGoUhB3CdgL/OZI5wwTVrJZE9FoOnkmowu6kRXnk=
X-Received: by 2002:a25:f50e:: with SMTP id a14mr48352333ybe.172.1622029514339;
 Wed, 26 May 2021 04:45:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210517092006.803332-1-omosnace@redhat.com> <87o8d9k4ln.fsf@mpe.ellerman.id.au>
In-Reply-To: <87o8d9k4ln.fsf@mpe.ellerman.id.au>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Wed, 26 May 2021 13:44:59 +0200
Message-ID: <CAFqZXNtUvrGxT6UMy81WfMsfZsydGN5k-VGFBq8yjDWN5ARAWw@mail.gmail.com>
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, network dev <netdev@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 1:00 PM Michael Ellerman <mpe@ellerman.id.au> wrote:
> Ondrej Mosnacek <omosnace@redhat.com> writes:
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
> > Since in most of these situations converting the callers such that
> > security_locked_down() is called in a context where the current task
> > would be meaningful for SELinux is impossible or very non-trivial (and
> > could lead to TOCTOU issues for the classic Lockdown LSM
> > implementation), fix this by modifying the hook to accept a struct cred
> > pointer as argument, where NULL will be interpreted as a request for a
> > "global", task-independent lockdown decision only. Then modify SELinux
> > to ignore calls with cred == NULL.
> >
> > Since most callers will just want to pass current_cred() as the cred
> > parameter, rename the hook to security_cred_locked_down() and provide
> > the original security_locked_down() function as a simple wrapper around
> > the new hook.
> >
> > The callers migrated to the new hook, passing NULL as cred:
> > 1. arch/powerpc/xmon/xmon.c
> >      Here the hook seems to be called from non-task context and is only
> >      used for redacting some sensitive values from output sent to
> >      userspace.
>
> It's hard to follow but it actually disables interactive use of xmon
> entirely if lockdown is in confidentiality mode, and disables
> modifications of the kernel in integrity mode.
>
> But that's not really that important, the patch looks fine.
>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

Thanks, Michael!

James/Paul, is there anything blocking this patch from being merged?
Especially the BPF case is causing real trouble for people and the
only workaround is to broadly allow lockdown::confidentiality in the
policy.

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

