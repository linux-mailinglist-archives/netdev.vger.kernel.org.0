Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197732CAF26
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 22:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgLAVuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 16:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgLAVub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:50:31 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB46EC0613D4;
        Tue,  1 Dec 2020 13:49:51 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id g15so3286840ybq.6;
        Tue, 01 Dec 2020 13:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RaCVmkv7D2O6owNmtehDhtbJyGEkbcUpfIsJlr7djA4=;
        b=p9bgjX63Em+eAmX3GGx9cKR04ioX/pKtwB6+cv9+nkHX0iHsrTrlnyXh40lt2cq23l
         DGYklL7o43QHAoiVXiHAASiXmmhWVpwlt7qjRAp0NdEo9mbWfkL3Ud7BJ9gM4Z3Joava
         sCt7eGgEflYiwMI22pfwdA2eXRtoWr5L3xLQ+ZikK/bmCYdHFYcvx3JTBUN1y2rb9GFH
         R5WnkiNhdF432BM1vm94PfaeEB0qEWCJQ0rJwrIVHReRr5aOZmBdzCWpqgikwjLZxEMj
         btkijihmoZgvx/TYiCzKf123kimMFSdYRrobyPyEZUTehF27bWpT5GIXv/cMqUtdO0WS
         dNmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RaCVmkv7D2O6owNmtehDhtbJyGEkbcUpfIsJlr7djA4=;
        b=PFdPRl5cQOBaz0n0W7GaUEaDerE7Zl7s8dctCOK6VUWzinUQ1rsmYRfSLXcfViT8LA
         FDvlHva9EmlMgWLowcDw+tYqlExz6OMJOcOU3lGT7nvln8u5SIOypv0iEDj2bf4b1bbS
         ojRsavNHrch0epLxCuZdmd+GuB7PCvLQazUyV9NbKajGzAjskeoDEVj3lJmXJVv0tH0/
         BiC/G3EImjS55Rb4LqBEMLaTIVumRIoQgaYrjJc01Izix5sK6M7dvdQhNuoFFLKJ6tOr
         2YJdv7/oaFbRHChI9eouAogF5572WYkkkKN+8f4CT1v2SwZ+gzbvWwVNb/ta+toOkE26
         6bJA==
X-Gm-Message-State: AOAM530RiGRAJOmYVULYH3UjIGcNCj+mhTUB2GmC9D2vUqzRZHDjeENj
        r+s9UgEZ0Evi1Q0PQDS680mHtCSPkopZoXFAY90=
X-Google-Smtp-Source: ABdhPJzIcdi9bcdamP3zXEfrJVBZbKYAW356wDhzcLDAryfFP9Ttp1dPMGQe5b+pwiWW3aV1Os2EF8dkHwrhZrOTXxA=
X-Received: by 2002:a25:2845:: with SMTP id o66mr8029028ybo.260.1606859391074;
 Tue, 01 Dec 2020 13:49:51 -0800 (PST)
MIME-Version: 1.0
References: <20201201034709.2918694-1-andrii@kernel.org> <CAADnVQLCrXZtrHKCZgLpDvy1F-Q1gubJuhiiHs6a1Z5ZPM9CwQ@mail.gmail.com>
In-Reply-To: <CAADnVQLCrXZtrHKCZgLpDvy1F-Q1gubJuhiiHs6a1Z5ZPM9CwQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Dec 2020 13:49:40 -0800
Message-ID: <CAEf4BzZAS71B6AQk2WCLA3d_vtsyYrA5bYT4YF0Wz7H=0XP8Fw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/7] libbpf: add support for kernel module BTF
 CO-RE relocations
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 1, 2020 at 1:30 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Nov 30, 2020 at 7:49 PM Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > Implement libbpf support for performing CO-RE relocations against types in
> > kernel module BTFs, in addition to existing vmlinux BTF support.
> >
> > This is a first step towards fully supporting kernel module BTFs. Subsequent
> > patch sets will expand kernel and libbpf sides to allow using other
> > BTF-powered capabilities (fentry/fexit, struct_ops, ksym externs, etc). For
> > CO-RE relocations support, though, no extra kernel changes are necessary.
> >
> > This patch set also sets up a convenient and fully-controlled custom kernel
> > module (called "bpf_testmod"), that is a predictable playground for all the
> > BPF selftests, that rely on module BTFs.
> >
> > v2->v3:
> >   - fix subtle uninitialized variable use in BTF ID iteration code;
>
> While testing this patch I've hit this:

Right, I ran into that while testing the second patch set
(fexit/fentry one), and fixed in patch "bpf: keep module's
btf_data_size intact after load". But I've mistakenly added it to the
second patch set, not to this one, my bad. I'll move it into this one.
Or maybe I should just combine those two now for easier logistics?

[...]
