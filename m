Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF36180B1F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgCJWCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:02:46 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45737 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgCJWCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:02:45 -0400
Received: by mail-ot1-f66.google.com with SMTP id f21so14750047otp.12;
        Tue, 10 Mar 2020 15:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SF/rLdHGOUkZmCUHks4hnv/hgG7mXzY0mjAu3eORSKc=;
        b=dP0qwPIoqktkEhRgFZTVTTWxkcFRfYDGvzuin4BmCyx1dFeyQ0uOwyb4eBHicOUILm
         DI3VMZq1rLcTrvMuznKSlRjP7zuiHhlLoneeAP2Ukbu89NsY5cjbW5zupm8KmYjnPOQC
         PhyMikcYH7oAz4FvqHke97OV+X/SBipPp1vmICbL+MLCxrA9ighbLPrG6XKNtMJfpKKl
         OSmo7GIymlx5q2EcDMB1TCAheYxf6xqD7Pwng4RkPs8Zy8Esc+4aTjqft250RJeGUwcz
         VTG6cyYyRJg83R8lsAHOiWf8xK6gxrrkg9NP8zaiqd+XvIp5Gx+JaBnF6WdRX6NPXNaV
         GR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SF/rLdHGOUkZmCUHks4hnv/hgG7mXzY0mjAu3eORSKc=;
        b=iXpcxP4ZtSotvmhH/6V4tv86MDBDMbyVRa/Ba1KXgGsOpqOnqGdreHTqHNeatAH6rq
         bZ1kopUp8iVJZB4QAeRn8yH3sRz0pZsb8kOc/SYjnnzwlhZvS+MKdyAjoVdFAV5GfnfO
         OsJ/O9/gB78doGEf4IbMgYvoLG2cV2pQR8MWVEqmtZLHZqs1tFztXJQTjAtXWuOwj2Dg
         Q7P3TFes+TrYTsaAErv9oA2901HFn7bPb0QFK7500ARDAyWtRhU0gJFYRuziztj2qY+J
         adoKVca45bvadmAoobycWjft+zsGMAb6vqHUqKJKt6hzESyhpoWr4hxgzv/fgp0xCLZK
         9DpA==
X-Gm-Message-State: ANhLgQ0YU7H26zFqEucBI5rcekY3iS+ECKQjEVp40FvfASAFGq5W1R4p
        o/Mth7S576Sm87n4zYtg+6iypyPUK5gbz+Ryl7k=
X-Google-Smtp-Source: ADFU+vueS+uiLnK7xdhsPHDa9dL2BYINp7cvAGX4mf8Z/DEw5HjuYJXCQGm60Z4IpnUSa5E1ExpmM2OF+ASb4BYIOrM=
X-Received: by 2002:a9d:4702:: with SMTP id a2mr18202147otf.319.1583877763719;
 Tue, 10 Mar 2020 15:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000034513e05a05cfc23@google.com> <CAM_iQpVgQ+Mc16CVds-ywp6YHEbwbGtJwqoQXBFbrMTOUZS0YQ@mail.gmail.com>
 <635ab023-d180-7ddf-a280-78080040512c@gmail.com>
In-Reply-To: <635ab023-d180-7ddf-a280-78080040512c@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 10 Mar 2020 15:02:32 -0700
Message-ID: <CAM_iQpUwkLeOtbxeQ6uPA6Zm6t2Xdm08rvKOX8yJ-UCckKq9Eg@mail.gmail.com>
Subject: Re: KASAN: invalid-free in tcf_exts_destroy
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     syzbot <syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 1:36 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 3/10/20 11:33 AM, Cong Wang wrote:
> > On Sun, Mar 8, 2020 at 12:35 PM syzbot
> > <syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com> wrote:
> >>
> >> Hello,
> >>
> >> syzbot found the following crash on:
> >>
> >> HEAD commit:    c2003765 Merge tag 'io_uring-5.6-2020-03-07' of git://git...
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=10cd2ae3e00000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=4527d1e2fb19fd5c
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=dcc34d54d68ef7d2d53d
> >> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >> userspace arch: i386
> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1561b01de00000
> >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15aad2f9e00000
> >>
> >> The bug was bisected to:
> >>
> >> commit 599be01ee567b61f4471ee8078870847d0a11e8e
> >> Author: Cong Wang <xiyou.wangcong@gmail.com>
> >> Date:   Mon Feb 3 05:14:35 2020 +0000
> >>
> >>     net_sched: fix an OOB access in cls_tcindex
> >>
> >> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a275fde00000
> >> final crash:    https://syzkaller.appspot.com/x/report.txt?x=12a275fde00000
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=14a275fde00000
> >>
> >> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >> Reported-by: syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com
> >> Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")
> >>
> >> IPVS: ftp: loaded support on port[0] = 21
> >> ==================================================================
> >> BUG: KASAN: double-free or invalid-free in tcf_exts_destroy+0x62/0xc0 net/sched/cls_api.c:3002
> >>
> >> CPU: 1 PID: 9507 Comm: syz-executor467 Not tainted 5.6.0-rc4-syzkaller #0
> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >> Call Trace:
> >>  __dump_stack lib/dump_stack.c:77 [inline]
> >>  dump_stack+0x188/0x20d lib/dump_stack.c:118
> >>  print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
> >>  kasan_report_invalid_free+0x61/0xa0 mm/kasan/report.c:468
> >>  __kasan_slab_free+0x129/0x140 mm/kasan/common.c:455
> >>  __cache_free mm/slab.c:3426 [inline]
> >>  kfree+0x109/0x2b0 mm/slab.c:3757
> >>  tcf_exts_destroy+0x62/0xc0 net/sched/cls_api.c:3002
> >>  tcf_exts_change+0xf4/0x150 net/sched/cls_api.c:3059
> >>  tcindex_set_parms+0xed8/0x1a00 net/sched/cls_tcindex.c:456
> >
> > Looks like a consequence of "slab-out-of-bounds Write in tcindex_set_parms".
> >
> > Thanks.
> >
>
> I have a dozen more syzbot reports involving net/sched code, do you want
> me to release them right now ?

I have no problem with this, at least I can close them as dup etc.. Please
go ahead.

Thanks.
