Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB6AEE778A
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 18:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404160AbfJ1RXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 13:23:19 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35762 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404154AbfJ1RXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 13:23:19 -0400
Received: by mail-pf1-f193.google.com with SMTP id d13so6274333pfq.2
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 10:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UflXfL3dwhO51RWNtr30ZieO/LUtszv77VC5R3Td5p4=;
        b=djoanQkiGA3fqiuTCeMp3PS0KDhFi1gk6EjakgwdacK8Hqk8l3UxxOnnkSpDAvM+ZD
         tljXKBoM/Gl5mK8Ort4gG8L54R4wqn5HKR5qrEPSHNovOdL1GqR6CBgB+WEjAyr1smkG
         RXSyvwASJ+KQCGxGJmBSvJC4ZdCK0PsvSUOtqtl8COFWH3EG9a15NN1IeB2tqZBWko/0
         cQ1SPDIoC3nO8FtJaVzKO5dDuENqFfiOk5axnAjDEMM1O6mD1sHR5yxBwMUg1RqPnrZP
         fvkc7EbqnRJoVLNXND4vGBALh7PmRcbUeD9eQNcbz7HfnHCjag9qCo5s31LIMqZfHIAX
         CUsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UflXfL3dwhO51RWNtr30ZieO/LUtszv77VC5R3Td5p4=;
        b=GWo9MiT1bwwsXWjTmEeKGdHa2c6JfmPp4Mb/syHQZZksZDFOfseE73ZWiQ0BZXufYx
         3zOxt3gHLT4BVRVIvmkPh3ZbVc1G2oabXL72Rks9OmISuaxdn/hfIdMzhZQ4OAxP7fUC
         p/mPnlRvmm5hypByZFq4J/WZG+SYaRwuRqdZxTQ85C0faDeMZq70qoz1xhg6i7140PPR
         30ZUoj3dRtjEzl8L6CZnq0Q/GQNH+8NMwUhyB6teNTfF0vQYtX4j7T7Dm+HOH5K/+OfB
         BMbjvzwnz5qcnMv26uUk6JygUdwt/0ksaO74PWwuRLEXwIyUbLEfpwFdsMtfDVgk42OB
         U0Og==
X-Gm-Message-State: APjAAAUF8SwN0pOECdSPMA3lL8buwjgADKi7NQ7x3oNNjUVG1otX32H+
        tQffTIH+52AXhdVQt+a2gE+XmmZ9R9LUMV1oaxKiTw==
X-Google-Smtp-Source: APXvYqytcmgUBglTw+96rAxyA8UoLZEEWQtQv6S5qGrK/cGa88KPzT32foKerAZ8x0LkY9vPTs4Gdwj3wPvVn1QVv48=
X-Received: by 2002:a17:90a:6509:: with SMTP id i9mr449000pjj.47.1572283397935;
 Mon, 28 Oct 2019 10:23:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571844200.git.andreyknvl@google.com> <beeae42e313ef57b4630cc9f36e2e78ad42fd5b7.1571844200.git.andreyknvl@google.com>
 <20191023152216.796aeafd832ba5351d86d3ca@linux-foundation.org>
In-Reply-To: <20191023152216.796aeafd832ba5351d86d3ca@linux-foundation.org>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 28 Oct 2019 18:23:06 +0100
Message-ID: <CAAeHK+w1SB7Z7ndB3nocO3vKwBhPrr6GFZa6EYeApyppx7gYYw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] kcov: remote coverage support
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     USB list <linux-usb@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 12:22 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Wed, 23 Oct 2019 17:24:29 +0200 Andrey Konovalov <andreyknvl@google.com> wrote:
>
> > This patch adds background thread coverage collection ability to kcov.
> >
> > With KCOV_ENABLE coverage is collected only for syscalls that are issued
> > from the current process. With KCOV_REMOTE_ENABLE it's possible to collect
> > coverage for arbitrary parts of the kernel code, provided that those parts
> > are annotated with kcov_remote_start()/kcov_remote_stop().
> >
> > This allows to collect coverage from two types of kernel background
> > threads: the global ones, that are spawned during kernel boot and are
> > always running (e.g. USB hub_event()); and the local ones, that are
> > spawned when a user interacts with some kernel interface (e.g. vhost
> > workers).
> >
> > To enable collecting coverage from a global background thread, a unique
> > global handle must be assigned and passed to the corresponding
> > kcov_remote_start() call. Then a userspace process can pass a list of such
> > handles to the KCOV_REMOTE_ENABLE ioctl in the handles array field of the
> > kcov_remote_arg struct. This will attach the used kcov device to the code
> > sections, that are referenced by those handles.
> >
> > Since there might be many local background threads spawned from different
> > userspace processes, we can't use a single global handle per annotation.
> > Instead, the userspace process passes a non-zero handle through the
> > common_handle field of the kcov_remote_arg struct. This common handle gets
> > saved to the kcov_handle field in the current task_struct and needs to be
> > passed to the newly spawned threads via custom annotations. Those threads
> > should in turn be annotated with kcov_remote_start()/kcov_remote_stop().
> >
> > Internally kcov stores handles as u64 integers. The top byte of a handle
> > is used to denote the id of a subsystem that this handle belongs to, and
> > the lower 4 bytes are used to denote a handle id within that subsystem.
> > A reserved value 0 is used as a subsystem id for common handles as they
> > don't belong to a particular subsystem. The bytes 4-7 are currently
> > reserved and must be zero. In the future the number of bytes used for the
> > subsystem or handle ids might be increased.
> >
> > When a particular userspace proccess collects coverage by via a common
> > handle, kcov will collect coverage for each code section that is annotated
> > to use the common handle obtained as kcov_handle from the current
> > task_struct. However non common handles allow to collect coverage
> > selectively from different subsystems.
> >
> > ...
> >
> > +static struct kcov_remote *kcov_remote_add(struct kcov *kcov, u64 handle)
> > +{
> > +     struct kcov_remote *remote;
> > +
> > +     if (kcov_remote_find(handle))
> > +             return ERR_PTR(-EEXIST);
> > +     remote = kmalloc(sizeof(*remote), GFP_ATOMIC);
> > +     if (!remote)
> > +             return ERR_PTR(-ENOMEM);
> > +     remote->handle = handle;
> > +     remote->kcov = kcov;
> > +     hash_add(kcov_remote_map, &remote->hnode, handle);
> > +     return remote;
> > +}
> > +
> >
> > ...
> >
> > +             spin_lock(&kcov_remote_lock);
> > +             for (i = 0; i < remote_arg->num_handles; i++) {
> > +                     kcov_debug("handle %llx\n", remote_arg->handles[i]);
> > +                     if (!kcov_check_handle(remote_arg->handles[i],
> > +                                             false, true, false)) {
> > +                             spin_unlock(&kcov_remote_lock);
> > +                             kcov_disable(t, kcov);
> > +                             return -EINVAL;
> > +                     }
> > +                     remote = kcov_remote_add(kcov, remote_arg->handles[i]);
> > +                     if (IS_ERR(remote)) {
> > +                             spin_unlock(&kcov_remote_lock);
> > +                             kcov_disable(t, kcov);
> > +                             return PTR_ERR(remote);
> > +                     }
> > +             }
>
> It's worrisome that this code can perform up to 65536 GFP_ATOMIC
> allocations without coming up for air.  The possibility of ENOMEM or of
> causing collateral problems is significant.  It doesn't look too hard
> to change this to use GFP_KERNEL?

Looking at this again: it seems easy to get rid of locking
kcov_remote_lock when doing kmalloc, but a bit harder to get rid of
kcov->lock. Andrew, would it be OK to just change the max number of
GFP_ATOMIC allocations to 256?

>
> > +u64 kcov_common_handle(void)
> > +{
> > +     return current->kcov_handle;
> > +}
>
> I don't immediately understand what this "common handle" thing is all about.
> Code is rather lacking in this sort of high-level commentary?
>
>
