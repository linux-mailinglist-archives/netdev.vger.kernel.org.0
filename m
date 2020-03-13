Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8071851C2
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 23:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgCMWnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 18:43:25 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40957 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgCMWnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 18:43:22 -0400
Received: by mail-oi1-f196.google.com with SMTP id y71so11179271oia.7
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 15:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MFjCvufz4qYwDEr+hp+Lr4gi77q6/a3rGxqdBQ0RGh0=;
        b=hXcW2YUeO7771pgMZQkpwWmDZERH1p2Fm3PKienj099vaUMe3Qcl+GfrrGnyRTugmy
         hOnPmmf61cOuY/9YM1n1YJDgIF/bzZkQ/SKe2ooZAlXOFVBwIbdf8NnqTwiRIUPwuyDu
         gq3dsr7QjFlNCbKk0FVRt2dnIYW73J+gylAUjLTdaMQSAQ/34Wi3jetakzQOmExGLLbw
         8OEa3IZy8OX7Im6ZIDSkOYCwptISjIO0eg7A4GLNypa3yVBcCLvJb7t8YlEPeGHfRL5j
         ldPvDbHUiWlCrcDekAFVZa0WqguFkec5Hxe/880sV0TtxrYvDnRso7ck3UIuBr42iaBG
         4qsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MFjCvufz4qYwDEr+hp+Lr4gi77q6/a3rGxqdBQ0RGh0=;
        b=QyBnEDmn5Y2J+zjpeas9boIO3apo0o9OHcLlqKWvi0oKdevImNdsHjeaNgUAllIKl/
         n4A3/I18xyVPQ3gmLqe3Zb4lqHEif/MF5taAbKE5BjikAgRTl6WiiBkCuwx5cK42hMF3
         esaKMmohwoC13ABRnklqyma+Eo4xuGtbJCUwhgaJiAOBQ5x2ZpMTY1lhnrrkfGQbfZno
         uAC2/CXtgP6gu0BJ7GBX2PARvCm1L/Eo97TDufCLO6VY8E67aB7VFVNtMQuc5FYruTFC
         AFG7HxvuR4xZY3wNi1UujYcEetM43zDeXqD2LqHS3hnte+9xwOA+ziqpjZ+Crb0a9a38
         u9JA==
X-Gm-Message-State: ANhLgQ3eKGSBw6HAedN94ElX7kRdcTuadJ8Rwsv6d7uO100Q7rr3X37F
        Xrruen/4u05mjhHWArveosDe9Ox8/DLxIUQ7dsIDMQ==
X-Google-Smtp-Source: ADFU+vu+OfEsMq89LMh75rmdjIo6Q7EXHa3Lgmr7926DPHs9q0A+YwV4vMORWl7jzo+TXKve5DGWJy0n+ni2SxD6TA0=
X-Received: by 2002:aca:5155:: with SMTP id f82mr9178692oib.103.1584139399757;
 Fri, 13 Mar 2020 15:43:19 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000041c6c205a08225dc@google.com> <20200312182826.GG79873@mtj.duckdns.org>
 <CAHS8izPySSO07dHi3OZ_1uXjmMCGnNMWey+o-qwFM7GnD7oSHw@mail.gmail.com>
In-Reply-To: <CAHS8izPySSO07dHi3OZ_1uXjmMCGnNMWey+o-qwFM7GnD7oSHw@mail.gmail.com>
From:   Mina Almasry <almasrymina@google.com>
Date:   Fri, 13 Mar 2020 15:43:08 -0700
Message-ID: <CAHS8izMpBXsv_fvy5Qw8CcjBivpfgec+r39+aFScgNDtUTdSqA@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in cgroup_file_notify
To:     Tejun Heo <tj@kernel.org>, Giuseppe Scrivano <gscrivan@redhat.com>
Cc:     syzbot <syzbot+cac0c4e204952cf449b1@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, andriin@fb.com,
        ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org,
        christian@brauner.io, daniel@iogearbox.net,
        Johannes Weiner <hannes@cmpxchg.org>, kafai@fb.com,
        open list <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 2:06 PM Mina Almasry <almasrymina@google.com> wrote:
>
> On Thu, Mar 12, 2020 at 11:28 AM Tejun Heo <tj@kernel.org> wrote:
> >
> > On Tue, Mar 10, 2020 at 08:55:14AM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    c99b17ac Add linux-next specific files for 20200225
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1610d70de00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=6b7ebe4bd0931c45
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=cac0c4e204952cf449b1
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1242e1fde00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1110d70de00000
> > >
> > > The bug was bisected to:
> > >
> > > commit 6863de00e5400b534cd4e3869ffbc8f94da41dfc
> > > Author: Mina Almasry <almasrymina@google.com>
> > > Date:   Thu Feb 20 03:55:30 2020 +0000
> > >
> > >     hugetlb_cgroup: add accounting for shared mappings
> >
> > Mina, can you please take a look at this?
> >
>
> Gah, I missed the original syzbot email but I just saw this. I'll take a look.
>

This was easy enough to track down, I just sent out a fix:
https://lore.kernel.org/linux-mm/20200313223920.124230-1-almasrymina@google.com

BTW, even though this was bisected to my patch, the root cause seems
to be a mistake in commit faced7e0806cf ("mm: hugetlb controller for
cgroups v2"), which is not only in linux-next but also in linus's tree
(I did not check if it's in stable). If my fix is reviewed, the patch
should be sent there as well. I'll make the same comment on the above
thread as well.
