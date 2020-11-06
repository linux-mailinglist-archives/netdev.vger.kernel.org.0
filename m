Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8292A9FCC
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgKFWRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbgKFWRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 17:17:20 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1723C0613CF;
        Fri,  6 Nov 2020 14:17:20 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id i186so2450484ybc.11;
        Fri, 06 Nov 2020 14:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BuHpNhzxvw2WFqEUK/54/hD/DX70sNQS5NUVcIFbbAo=;
        b=LsstrjiecEpMOJjjzwElg2nTg68PwGKac60+GQv/tyt2R+RgFO3mM7cdiHHa5M6r90
         VBABpDDxQKRGYXp2T0mJ6TiK6XamT/xEa3wT/uCPA7kjyLWm8Bt1jr6GFLShpdrfghJQ
         17oSKmARMnZ33vgG+jFyesjWeYF3KIvrnhkucmhIXIPh3X0h/yV/fbjAlVqWICVn9IPx
         Y+lsXISUtfYFPo/q+pcBOTqnMDlkFOMbv5y3etHnidB6zYXm2iq7QEisC/jM7zqliWZj
         KSl5dSNmpbbQHqKccCt4GoE7nxXvyDplnPqo7qQx5YCBm3SSTMHyhKtlO4k/C+pYpVT+
         CrJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BuHpNhzxvw2WFqEUK/54/hD/DX70sNQS5NUVcIFbbAo=;
        b=rRys6csGj9X7eUW52QDmv/faQC4o8TxhY5fhvgJepdLKYovXWZndAI5KKU3rq8m95H
         JpQSurHUO1z0Z8iNokepu412IKYRDYFJjJLdhKu1sdxyUGw1pDTsMFzm+JNbyYNRQM67
         9gIDU1izqol2biCOeijtllcQHZKxvPZ5n2AuM/E8W0BoNbCgqhCQfa39k5Im2kaQI9Ly
         GcSrY7lcr/3QA8wXdmUF2Rc6rLvIoJy/oGYNaBpE9fdWzInwT2MuMToz4Th7/U/D7d79
         rvBSA/sBvjMuBwsvHx1xfBSkZXY9VLhA3SHjLxG66sMrVQx34DBjtm4MuRd5fHtZ9v0a
         wCdQ==
X-Gm-Message-State: AOAM533VuDMCVT4LMhhgyufRRbqGC35hkhhbvyDqCb0REovqx+B+pORE
        14wOodAjZ2q9LyxEW28WgFKYVONE5fqvD1PqeM8=
X-Google-Smtp-Source: ABdhPJxJ/6NjlcnECYnJecO7o0NfmGXRWsLH+WqzTOokZKn9lSHmII8MhfGZfp+zdGWnrAYm9FXCnGSStqp4FsIENKQ=
X-Received: by 2002:a25:bdc7:: with SMTP id g7mr6321822ybk.260.1604701039978;
 Fri, 06 Nov 2020 14:17:19 -0800 (PST)
MIME-Version: 1.0
References: <20201106055111.3972047-1-andrii@kernel.org> <20201106055111.3972047-5-andrii@kernel.org>
 <20201106064358.GA697514@kroah.com>
In-Reply-To: <20201106064358.GA697514@kroah.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Nov 2020 14:17:08 -0800
Message-ID: <CAEf4BzZ7PA0JTM2thWUFHrEh6+UkJo0UUxhpk=cAq0oN2xn=nw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] bpf: load and verify kernel module BTFs
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 10:44 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Nov 05, 2020 at 09:51:09PM -0800, Andrii Nakryiko wrote:
> > Add kernel module listener that will load/validate and unload module BTF.
> > Module BTFs gets ID generated for them, which makes it possible to iterate
> > them with existing BTF iteration API. They are given their respective module's
> > names, which will get reported through GET_OBJ_INFO API. They are also marked
> > as in-kernel BTFs for tooling to distinguish them from user-provided BTFs.
> >
> > Also, similarly to vmlinux BTF, kernel module BTFs are exposed through
> > sysfs as /sys/kernel/btf/<module-name>. This is convenient for user-space
> > tools to inspect module BTF contents and dump their types with existing tools:
> >
> > [vmuser@archvm bpf]$ ls -la /sys/kernel/btf
> > total 0
> > drwxr-xr-x  2 root root       0 Nov  4 19:46 .
> > drwxr-xr-x 13 root root       0 Nov  4 19:46 ..
> >
> > ...
> >
> > -r--r--r--  1 root root     888 Nov  4 19:46 irqbypass
> > -r--r--r--  1 root root  100225 Nov  4 19:46 kvm
> > -r--r--r--  1 root root   35401 Nov  4 19:46 kvm_intel
> > -r--r--r--  1 root root     120 Nov  4 19:46 pcspkr
> > -r--r--r--  1 root root     399 Nov  4 19:46 serio_raw
> > -r--r--r--  1 root root 4094095 Nov  4 19:46 vmlinux
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  Documentation/ABI/testing/sysfs-kernel-btf |   8 +
> >  include/linux/bpf.h                        |   2 +
> >  include/linux/module.h                     |   4 +
> >  kernel/bpf/btf.c                           | 193 +++++++++++++++++++++
> >  kernel/bpf/sysfs_btf.c                     |   2 +-
> >  kernel/module.c                            |  32 ++++
> >  6 files changed, 240 insertions(+), 1 deletion(-)
> >

[...]

> > +             if (IS_ENABLED(CONFIG_SYSFS)) {
> > +                     struct bin_attribute *attr;
> > +
> > +                     attr = kzalloc(sizeof(*attr), GFP_KERNEL);
> > +                     if (!attr) {
> > +                             WARN(1, "failed to register module [%s] BTF in sysfs\n", mod->name);
>
> kzalloc() will print errors on its own, no need to do this again.  Also,
> for systems with panic-on-warn, you just crashed them, not nice :(

ah, pr_warn() is what I probably wanted here instead of WARN. I'll
just drop this, if kzalloc will log a warning anyways.

>
> > +                             goto out;
> > +                     }
> > +
> > +                     attr->attr.name = btf->name;
> > +                     attr->attr.mode = 0444;
> > +                     attr->size = btf->data_size;
> > +                     attr->private = btf;
> > +                     attr->read = btf_module_read;
> > +
> > +                     err = sysfs_create_bin_file(btf_kobj, attr);
>
> You forgot to call sysfs_bin_attr_init() to initialize your binary sysfs
> attribute.  You'll only notice if you turn lockdep on.

Good catch, fixed. Also added CONFIG_DEBUG_LOCK_ALLOC to my config.

>
>
> > +                     if (err) {
> > +                             kfree(attr);
> > +                             WARN(1, "failed to register module [%s] BTF in sysfs: %d\n",
> > +                                  mod->name, err);
>
> Again, just report the error and move on, don't crash systems.
>

Right, fixed.

> Other than these minor things, looks good to me, nice work!
>

Thanks!

> thanks,
>
> greg k-h
