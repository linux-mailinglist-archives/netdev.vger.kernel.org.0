Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F01F2A86A0
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731897AbgKETBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731644AbgKETB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 14:01:27 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25889C0613CF;
        Thu,  5 Nov 2020 11:01:27 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id i186so2242439ybc.11;
        Thu, 05 Nov 2020 11:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pUnL/CYasanNGQGKwZYF4l9ptvaitgiceIreKhvBBAY=;
        b=QtTuIKsXrgSuBdYaU4RcAXdV7dt1s4/ingmc5bhmC3KhpAa2njlYIZNMMfMQ0iD8sc
         kWiX+r2HVhKw62YROoUd4du3KFmprfu2CLJCivH95HxcVnnLfPt0/QUQG3T7jCeZQziB
         DN2dUrUijG6TUKdhOXeHR8FT91YnIY7d/QybBA+gMhROtjWqYwlgKhxm/+7rRMOwBj6c
         pzCATAcAb6our+BnZOXI/EFFXIMXB/XMHzOSqfIEx0JStsLKC/0lkQCKhir8P/amz/tV
         sRkmSlonym4lnCrqiR+5kyOJ70Quv5Pue1rO3E8O+vaUa62K+EEuMsjM5MJw5nf6/vGv
         ObFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pUnL/CYasanNGQGKwZYF4l9ptvaitgiceIreKhvBBAY=;
        b=Kpv3IcDVysIgGjStojvgOrefSrnlDtp4Yd8w8f0Hd2EGCrihVAUdHosjiTRchsq9GE
         BsDT5cKax9VQK1+o7odcEQXaeOHML/OnpdZtIAOZAsXCvFcyxsIihHdY59sJ+HOZ1u+p
         veeSH/jm7JgVi7EhYyZRge1OjZNXocu50bh8vi1ktJy5zbODLa6J2lLt9XIQ+XeextKp
         KcUnULb4cyPMWuIsIamyuwpZefb74rqWcNoylyxUZd3uTx0AMxhyCplxsdaKsUhWF5ar
         m9T2y65bpaHrLzH0bEsnk0T7LpTQ2la1NRN/BMjWK5AD7lr+N5z04H183PqiTJwFcXDh
         tr8A==
X-Gm-Message-State: AOAM533JOBMUMIKXcxYiU2d39qOrw62sCuOlarPHKGETopTsFRcaQWHl
        qioY0ODhA7NH+kuM6W0oNvnu3jMM3ZgVhKpdPos=
X-Google-Smtp-Source: ABdhPJyQIN+4ekCQeixYIYktOAkmsTPODuFumaWBVbkgLGTkD6eow815f7IPD11BieHj9nOA9/iGJOf2SiILiPuJPG8=
X-Received: by 2002:a25:da4e:: with SMTP id n75mr5580573ybf.425.1604602886337;
 Thu, 05 Nov 2020 11:01:26 -0800 (PST)
MIME-Version: 1.0
References: <20201105045140.2589346-1-andrii@kernel.org> <20201105045140.2589346-5-andrii@kernel.org>
 <20201105083925.68433e51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20201105164616.GA1201462@kroah.com>
In-Reply-To: <20201105164616.GA1201462@kroah.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Nov 2020 11:01:15 -0800
Message-ID: <CAEf4Bza6CGgJO6eOSU66mj-usbaGuFgZhRz1i+mFjg_f75Jn5A@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 4/5] bpf: load and verify kernel module BTFs
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jessica Yu <jeyu@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 8:45 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Nov 05, 2020 at 08:39:25AM -0800, Jakub Kicinski wrote:
> > On Wed, 4 Nov 2020 20:51:39 -0800 Andrii Nakryiko wrote:
> > > Add kernel module listener that will load/validate and unload module BTF.
> > > Module BTFs gets ID generated for them, which makes it possible to iterate
> > > them with existing BTF iteration API. They are given their respective module's
> > > names, which will get reported through GET_OBJ_INFO API. They are also marked
> > > as in-kernel BTFs for tooling to distinguish them from user-provided BTFs.
> > >
> > > Also, similarly to vmlinux BTF, kernel module BTFs are exposed through
> > > sysfs as /sys/kernel/btf/<module-name>. This is convenient for user-space
> > > tools to inspect module BTF contents and dump their types with existing tools:
> >
> > Is there any precedent for creating per-module files under a new
> > sysfs directory structure? My intuition would be that these files
> > belong under /sys/module/
>
> Ick, why?  What's wrong with them under btf?  The module core code
> "owns" the /sys/modules/ tree.  If you want others to mess with that, it
> will get tricky.
>
>
> > Also the CC list on these patches is quite narrow. You should have
> > at least CCed the module maintainer. Adding some folks now.
> >
> > > [vmuser@archvm bpf]$ ls -la /sys/kernel/btf
> > > total 0
> > > drwxr-xr-x  2 root root       0 Nov  4 19:46 .
> > > drwxr-xr-x 13 root root       0 Nov  4 19:46 ..
> > >
> > > ...
> > >
> > > -r--r--r--  1 root root     888 Nov  4 19:46 irqbypass
> > > -r--r--r--  1 root root  100225 Nov  4 19:46 kvm
> > > -r--r--r--  1 root root   35401 Nov  4 19:46 kvm_intel
> > > -r--r--r--  1 root root     120 Nov  4 19:46 pcspkr
> > > -r--r--r--  1 root root     399 Nov  4 19:46 serio_raw
> > > -r--r--r--  1 root root 4094095 Nov  4 19:46 vmlinux
> > >
> > > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > > ---
> > >  include/linux/bpf.h    |   2 +
> > >  include/linux/module.h |   4 +
> > >  kernel/bpf/btf.c       | 193 +++++++++++++++++++++++++++++++++++++++++
> > >  kernel/bpf/sysfs_btf.c |   2 +-
> > >  kernel/module.c        |  32 +++++++
> > >  5 files changed, 232 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 2fffd30e13ac..3cb89cd7177b 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -36,9 +36,11 @@ struct seq_operations;
> > >  struct bpf_iter_aux_info;
> > >  struct bpf_local_storage;
> > >  struct bpf_local_storage_map;
> > > +struct kobject;
> > >
> > >  extern struct idr btf_idr;
> > >  extern spinlock_t btf_idr_lock;
> > > +extern struct kobject *btf_kobj;
>
> I don't see any Documentation/ABI/ updates for the sysfs changes here,
> did I miss it?
>

Nope, my bad, completely forgot to add it. Last time I touched sysfs
was quite a while ago, I forgot about adding ABI description. Will add
in the next version.

> thanks,
>
> greg k-h
