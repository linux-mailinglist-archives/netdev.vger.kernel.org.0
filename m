Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4BB175806
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 11:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCBKMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 05:12:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47018 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726874AbgCBKME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 05:12:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583143924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LaXbm6o9ACOSIA/4eITRQbVMVOSyHXSsuYyUe3P7gC8=;
        b=DjH8Tx/rc/l4gxwtVKxkUJsiM2i+M6Hq/81Fd2pCN3f0CwxeXGTtf0Kh6ZXM+AmfH+9H7j
        IiUE3//l0tmHMZXkKUj1WTEnCxfge7pH5NRW5EPdM4S42BnlfBBvRs10j1IR/FRkOb30bf
        ZFJyQnC0mTua/Wd369ADHmtq8ryD2xk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-EQ3uyBrOPh6CslwoUKnREg-1; Mon, 02 Mar 2020 05:12:02 -0500
X-MC-Unique: EQ3uyBrOPh6CslwoUKnREg-1
Received: by mail-wr1-f70.google.com with SMTP id m13so5593242wrw.3
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 02:12:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LaXbm6o9ACOSIA/4eITRQbVMVOSyHXSsuYyUe3P7gC8=;
        b=t95TyDEbX0fsK4kUNZk3oVJB1tyywqAKcsvnXXkq2wxSyq1zD/hugFGfD32aEF7XqA
         5McxGjVgHQmykkn0t8PSZM1iI0g6yGtwQd/Oi23I15of6/pvTDjkiaBuXUbLuO7sjhml
         mzw+92goNn1+80BNby5qefMgl20tnC7Sm73FIwIV52luqsvLgTeR8Vc5kUITMZyhP83a
         cPDQser2KVuKj7g/cju0m8bLRN4ZbtyH+QvxHiwLoa+6ZGuz3bUMY6K+BMu5i/i+sqvu
         fzfniFV+eJzZvnCJJ68KQpY9U+IAdotsN8HWd08Crqy36rG8ulwMjoDlEb99JjK/dcls
         7OiQ==
X-Gm-Message-State: ANhLgQ0u3TAcsN7wviQ95rfwlZAS4mpKPtqsd8hBdUyqqwgyroQwymNx
        Ozl75L/QZPiSiAq3R6qmVlD/E8GnxGQpZSqGlLMp33j9lVq3i6rLz0teJurGaNSD9KzNbTJYDVY
        IM+AsNL69ZJ2bkgcO
X-Received: by 2002:a5d:5411:: with SMTP id g17mr2130086wrv.4.1583143921174;
        Mon, 02 Mar 2020 02:12:01 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtczJDy8x17jZMxyB+m7H9GwlALs0hqXR1gDMRMeSn/R/xAKgrk+S6RchUXVJBR4SQZ6hYmYQ==
X-Received: by 2002:a5d:5411:: with SMTP id g17mr2130064wrv.4.1583143920907;
        Mon, 02 Mar 2020 02:12:00 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t124sm16657264wmg.13.2020.03.02.02.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 02:11:59 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6942D180362; Mon,  2 Mar 2020 11:11:59 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel abstraction
In-Reply-To: <20200228223948.360936-1-andriin@fb.com>
References: <20200228223948.360936-1-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 02 Mar 2020 11:11:59 +0100
Message-ID: <87mu8zt6a8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> This patch series adds bpf_link abstraction, analogous to libbpf's already
> existing bpf_link abstraction. This formalizes and makes more uniform existing
> bpf_link-like BPF program link (attachment) types (raw tracepoint and tracing
> links), which are FD-based objects that are automatically detached when last
> file reference is closed. These types of BPF program links are switched to
> using bpf_link framework.
>
> FD-based bpf_link approach provides great safety guarantees, by ensuring there
> is not going to be an abandoned BPF program attached, if user process suddenly
> exits or forgets to clean up after itself. This is especially important in
> production environment and is what all the recent new BPF link types followed.
>
> One of the previously existing  inconveniences of FD-based approach, though,
> was the scenario in which user process wants to install BPF link and exit, but
> let attached BPF program run. Now, with bpf_link abstraction in place, it's
> easy to support pinning links in BPF FS, which is done as part of the same
> patch #1. This allows FD-based BPF program links to survive exit of a user
> process and original file descriptor being closed, by creating an file entry
> in BPF FS. This provides great safety by default, with simple way to opt out
> for cases where it's needed.

While being able to pin the fds returned by bpf_raw_tracepoint_open()
certainly helps, I still feel like this is the wrong abstraction for
freplace(): When I'm building a program using freplace to put in new
functions (say, an XDP multi-prog dispatcher :)), I really want the
'new' functions (i.e., the freplace'd bpf_progs) to share their lifetime
with the calling BPF program. I.e., I want to be able to do something
like:

prog_fd = sys_bpf(BPF_PROG_LOAD, ...); // dispatcher
func_fd = sys_bpf(BPF_PROG_LOAD, ...); // replacement func
err = sys_bpf(BPF_PROG_REPLACE_FUNC, prog_fd, btf_id, func_fd); // does *not* return an fd

That last call should make the ref-counting be in the prog_fd -> func_fd
direction, so that when prog_fd is released, it will do
bpf_prog_put(func_fd). There could be an additional call like
sys_bpf(BPF_PROG_REPLACE_FUNC_DETACH, prog_fd, btf_id) for explicit
detach as well, of course.

With such an API, lifecycle management for an XDP program keeps being
obvious: There's an fd for the root program attached to the interface,
and that's it. When that is released the whole thing disappears. Whereas
with the bpf_raw_tracepoint_open() API, the userspace program suddenly
has to make sure all the component function FDs are pinned, which seems
cumbersome and error-prone...

I'll try to propose patches for what this could look like; I think it
could co-exist with this bpf_link abstraction, though, so no need to
hold up this series...

-Toke

