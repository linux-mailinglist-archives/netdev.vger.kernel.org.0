Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 250EA11EB46
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 20:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbfLMTvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 14:51:50 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46739 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbfLMTvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 14:51:50 -0500
Received: by mail-qt1-f194.google.com with SMTP id 38so3189218qtb.13
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 11:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netflix.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RcocnBgthkpbK/m8uz5lL4Etu89gMRTjWvFTOte2r2c=;
        b=itDZNQlHPhHUrHqVid9ZEL0BBIhzfoYb+mAnZJJEhu2kbVcTJwANnDhQQ2vtWotOfg
         GuDvebWKQEIA+A5n+auB+OzFLNBHhSec5TBo4mBEwZ5Lwtyw2G4oUiVdU0dDIURlM+5J
         hSoDs0DqyA/KAgt/Ube70t5A/PU6LV01m7bEI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RcocnBgthkpbK/m8uz5lL4Etu89gMRTjWvFTOte2r2c=;
        b=EtcmWynIkgDglX0oTrQeMX8JAtu6sR3j/X8GjKotTkNZ+5BBYvijqBwMhaOIibZWZi
         SnmKHEuC9FYaSsY7gxJo6WoB5yTiAx+2r+2auhSYdEUht6jiGNTri8P7vK+juFk3zFj+
         z8Zn3Yqd7JpIwkZ71KmDK+uVCqri6KsPT9BjcAwtVXNGEDJYUIzRa/O4coymy1NMkBpe
         2r1JhMpWY506mFdgCYKA08exy54eREIlvdPpJlh4S5cWCMSF3S92uRqx1qz5xF3T7DeQ
         fdlAQIwfdOn9a6zWaO6v31b6cJUK98kqf8+b2IoDXoqqTbUK+5UaRp6zaGu2FX84WnGW
         prVA==
X-Gm-Message-State: APjAAAWIZSkBnsj39tFNo7MjXQQ8bLrx8Nnv4vSV/of7y8Xyl9Rvb/Z6
        FloK3gTZ6s1hLzoO/bnPg3YKCEqKG/3DXpdJayDmXQ==
X-Google-Smtp-Source: APXvYqzykKfxjJE3Fx4RtcLW6QEH5ZxzYS0hScq/NEmLrnIUP+d6AApkHTcBQbyzzoCSMUgoB+AcM5H1ZItGDJ6F/io=
X-Received: by 2002:aed:3ee5:: with SMTP id o34mr14102843qtf.164.1576266709314;
 Fri, 13 Dec 2019 11:51:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574162990.git.ethercflow@gmail.com> <e8b1281b7405eb4b6c1f094169e6efd2c8cc95da.1574162990.git.ethercflow@gmail.com>
 <20191123031826.j2dj7mzto57ml6pr@ast-mbp.dhcp.thefacebook.com>
 <20191123045151.GH26530@ZenIV.linux.org.uk> <20191123051919.dsw7v6jyad4j4ilc@ast-mbp.dhcp.thefacebook.com>
 <20191123053514.GJ26530@ZenIV.linux.org.uk> <20191123060448.7crcqwkfmbq3gsze@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191123060448.7crcqwkfmbq3gsze@ast-mbp.dhcp.thefacebook.com>
From:   Brendan Gregg <bgregg@netflix.com>
Date:   Fri, 13 Dec 2019 11:51:23 -0800
Message-ID: <CAJN39ogBTyXB2-3OHiJ-oQfBd75_axxvOLoABfXLopH_VsG6gw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v10 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Wenbo Zhang <ethercflow@gmail.com>, bpf@vger.kernel.org,
        ast@kernel.org.com, Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 10:05 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Nov 23, 2019 at 05:35:14AM +0000, Al Viro wrote:
> > On Fri, Nov 22, 2019 at 09:19:21PM -0800, Alexei Starovoitov wrote:
> >
> > > hard to tell. It will be run out of bpf prog that attaches to kprobe or
> > > tracepoint. What is the concern about locking?
> > > d_path() doesn't take any locks and doesn't depend on any locks. Above 'if'
> > > checks that plain d_path() is used and not some specilized callback with
> > > unknown logic.
> >
> > It sure as hell does.  It might end up taking rename_lock and/or mount_lock
> > spinlock components.  It'll try not to, but if the first pass ends up with
> > seqlock mismatch, it will just grab the spinlock the second time around.
>
> ohh. got it. I missed _or_lock() part in there.
> The need_seqretry() logic is tricky. afaics there is no way for the checks
> outside of prepend_path() to prevent spin_lock to happen. And adding a flag to
> prepend_path() to return early if retry is needed is too ugly. So this helper
> won't be safe to be run out of kprobe. But if we allow it for tracepoints only
> it should be ok. I think. There are no tracepoints in inner guts of vfs and I
> don't think they will ever be. So running in tracepoint->bpf_prog->d_path we
> will be sure that rename_lock+mount_lock can be safely spinlocked. Am I missing
> something?

It seems rather restrictive to only allow tracepoints (especially
without VFS tracepoints), although I'll use it to improve my syscall
tracepoint tools, so I'd be happy to see this merged even with that
restriction.

Just a thought: if *buffer is in BPF memory, can prepend_path() check
it's memory location and not try to grab the lock based on that? This
would be to avoid adding a flag.

>
> > > > with this number; quite possibly never before that function had been called
> > > > _and_ not once after it has returned.
> > >
> > > Right. TOCTOU is not a concern here. It's tracing. It's ok for full path to be
> > > 'one time deal'.
> >
> > It might very well be a full path of something completely unrelated to what
> > the syscall ends up operating upon.  It's not that the file might've been
> > moved; it might be a different file.  IOW, results of that tracing might be
> > misleading.
>
> That is correct. Tracing is fine with such limitation. Still better than probe_read.
>

+1

Tracing is observability tools and we document these caveats, and this
won't be the first time I've published tools where the printed path
may not be the one you think (e.g., the case of hard links.)

Brendan

-- 
Brendan Gregg, Senior Performance Architect, Netflix
