Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5564736D066
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 03:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbhD1B4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 21:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhD1B4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 21:56:41 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3137C061574;
        Tue, 27 Apr 2021 18:55:57 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c3so23884647pfo.3;
        Tue, 27 Apr 2021 18:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=59c4W/S/XuyHQHK1wMDg6Ud8sL/jG58LvVCrwBenDIc=;
        b=LesNKzJxJy3f3TOmBqHhz/IMFip4uhvO+NxUW1vGNVed7Bho290OEnSv3NF/1MzJ7P
         4TlWZ9Fc+rFfc9ZFEB/N/BhyrY/Qt40CVWl6s6a8PbBNjdKjJG7ZfZqRQm2GaCnzvd2q
         foAJGGiHDiE3YqVWbCn2ZHM6DTE3tom9bKbeIa5v7JP84FvpJonuWFe/5e2MCTIIt4DK
         uAN5qVHSs39YZ+BPEVlC9Tq+VQCjkmBgkY/XDV5b2EXih/JiVDqKUyQ0sOQ+iU5DyWS3
         9k+ISmCKE+sKj4m3Iq97GgfsIMtBlVkikwAEYg4QPAzoTLE7g6+bpUu3zDWy2Y0lJVjA
         gePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=59c4W/S/XuyHQHK1wMDg6Ud8sL/jG58LvVCrwBenDIc=;
        b=rJJ8JnFwSRqSH5Z9UYQPbEYaHkwJa8O1loCVUZnD2CXL2e9sc2PxlHIAr5xPtke/16
         SW2zvBO/GythQW9lHMkRQSoYXd6cDHs++KRfZPJV8UGk3MZR514B0jbufXTknGevrH4R
         2c8xCveMkJV0vhqX5P4byA46r23sy9Rk4/1+UxGMjCZ6JdjAAtldafbvX+9xq0Lxwnsr
         oLq/ug65FXCvCSCNs5L49TL3MSrBHWbDJxtk5/Hkyb3qELY21Xs2UbL9475PLkEekk5O
         uL9tmBgQ/KcOTbb3KgqWNUOVOJh+1FVee1PUBMQ+d1oN5G+RYpERSAeu0Jw5ipWHX3zy
         VJXA==
X-Gm-Message-State: AOAM533ay4BC1VFqDJoO0gS30io/+tgAUGKoim7ay0wwmUD+pcZRUV2O
        dxzZe1zzlGPn0x5wP4V7jC4=
X-Google-Smtp-Source: ABdhPJyP24Z/88/an6+tHJIHj/qHNPMnle6P85T5jy0pTnZPxcS2dDDyW7MSWbKLyZuKoR6QA6+0Ag==
X-Received: by 2002:a65:6a52:: with SMTP id o18mr5329540pgu.17.1619574957228;
        Tue, 27 Apr 2021 18:55:57 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2e71])
        by smtp.gmail.com with ESMTPSA id lx15sm3131873pjb.56.2021.04.27.18.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 18:55:56 -0700 (PDT)
Date:   Tue, 27 Apr 2021 18:55:54 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 10/16] bpf: Add bpf_btf_find_by_name_kind()
 helper.
Message-ID: <20210428015554.j7cffimb6lnv3ir7@ast-mbp.dhcp.thefacebook.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-11-alexei.starovoitov@gmail.com>
 <CAEf4BzYkzzN=ZD2X1bOg8U39Whbe6oTPuUEMOpACw6NPEW69NA@mail.gmail.com>
 <20210427033707.fu7hsm6xi5ayx6he@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaPDF8h9t1xqMo-hKqp=J_bE1OtWXh+jugZxV597qjdaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaPDF8h9t1xqMo-hKqp=J_bE1OtWXh+jugZxV597qjdaw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 10:45:38AM -0700, Andrii Nakryiko wrote:
> > >
> > > > + *             If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
> > > > + *     Return
> > > > + *             Returns btf_id and btf_obj_fd in lower and upper 32 bits.
> > >
> > > Mention that for vmlinux BTF btf_obj_fd will be zero? Also who "owns"
> > > the FD? If the BPF program doesn't close it, when are they going to be
> > > cleaned up?
> >
> > just like bpf_sys_bpf. Who owns returned FD? The program that called
> > the helper, of course.
> 
> "program" as in the user-space process that did bpf_prog_test_run(),
> right? In the cover letter you mentioned that BPF_PROG_TYPE_SYSCALL
> might be called on syscall entry in the future, for that case there is
> no clear "owning" process, so would be curious to see how that problem
> gets solved.

well, there is always an owner process. When syscall progs is attached
to syscall such FDs will be in the process that doing syscall.
It's kinda 'random', but that's the job of the prog to make 'non random'.
If it's doing syscalls that will install FDs it should have a reason
to do so. Likely there will be limitations on what bpf helpers such syscall
prog can do if it's attached to this or that syscall.
Currently it's test_run only.

I'm not sure whether you're hinting that it all should be FD-less or I'm
putting a question in your mouth, but I've considered doing that and
figured that it's an overkill. It's possible to convert .*bpf.* do deal
with FDs and with some other temporary handle. Instead of map_fd the
loader prog would create a map and get a handle back that it will use
later in prog_load, etc.
But amount of refactoring looks excessive.
The generated loader prog should be correct by construction and
clean up after itself instead of burdening the kernel cleaning
those extra handles.
