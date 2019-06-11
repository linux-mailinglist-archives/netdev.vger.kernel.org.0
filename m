Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B0E3C4A0
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391296AbfFKHAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:00:22 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:53186 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391234AbfFKHAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 03:00:22 -0400
Received: by mail-it1-f196.google.com with SMTP id l21so3140572ita.2
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 00:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vI5acHmkA6nTEYfV591ATb0I6pQPEbOKaKN82hg7RCM=;
        b=LCGuTjO2TxUrUxb2CuUCMlbw+aT+V48pldHb/E8/HyXyhAcJadkKRTydOYZaLbyaYO
         UFtSG+6oLe+7212hqKM3zKI58XosqcuQN5yr4MZTfClkV+lP9X7WQ/TXCkIwp6yJyjYQ
         UYYS+sSWMxLJRYXgoadzaDdOX6wf0CZSQJTjNdkoB9ahn/djzXI9gOhXuteD/YeX64dQ
         kxqaZKYtwHJQb9V6J8l+PKkw8OWqZtUF+CpghawnAHXjJ4dMpEi47ZhScw6UcIjjTkLw
         Ir++FWv/LC5oeZcD0gs7t5aN3QQ4bQIAvrA1jbE5wf551c9FBya6Q1MR/VSJ8vNZZ7Uw
         RBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vI5acHmkA6nTEYfV591ATb0I6pQPEbOKaKN82hg7RCM=;
        b=JA6o1E2fcdcxUb/Kh7U0h2Fh2lN/3t9gqc/zsWfzjcR50rPaMhR5STf+QNVk4R6U3C
         CwwD6UnAdf17EKRTO/OzZ4QNX8AKhU3XVAfYvrRSqfb2s4BWKt0PiM7DZppBksQ5usX1
         CzlsR2eAOxLqeaL1n/5GWeXNwVQofDJc5y/PIg8ClzD0W0D/vBjdXwbKNXx4mv5jVDiN
         YHLJayyt4Pj5XQ6xF5H0Hq+8dnWY8DtEF6ncUZzhdnYG46efqTCkmLcVnFCnFITgUlWf
         X9YoKqGTS1O47PO+hloy/OMpBqACJKw74aGNG+Xj9RxBxL4xC+hZGoF5rdPb969+D73o
         jvYA==
X-Gm-Message-State: APjAAAWDYei3JjSWXZymqVMCp+MioJ1tWOxR9zQ4PWxvoRqAlL4HLo+k
        SntPvAkLbZOWr3Kz6EQvPOxEl1XmgcHOmX6p9r4yUQ==
X-Google-Smtp-Source: APXvYqw5L3QgsGUT/uUiUEEf1cTR2kRkCU5zFtdPavouBPiFq6joDoKrg25++85Cx9Pi97zf+dP+doMtRgFU6BvEKSk=
X-Received: by 2002:a24:9083:: with SMTP id x125mr17320288itd.76.1560236421302;
 Tue, 11 Jun 2019 00:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c0d84e058ad677aa@google.com> <87ftoh6si4.fsf@xmission.com>
In-Reply-To: <87ftoh6si4.fsf@xmission.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 11 Jun 2019 09:00:09 +0200
Message-ID: <CACT4Y+btAivG8iYQFM=Qy_qMoE0SFNhx-ngjN=1hgf7UGrNViw@mail.gmail.com>
Subject: Re: general protection fault in mm_update_next_owner
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     syzbot <syzbot+f625baafb9a1c4bfc3f6@syzkaller.appspotmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Alexei Starovoitov <ast@kernel.org>, avagin@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>, dbueso@suse.de,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        prsood@codeaurora.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 11:27 PM Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> syzbot <syzbot+f625baafb9a1c4bfc3f6@syzkaller.appspotmail.com> writes:
>
> > syzbot has bisected this bug to:
> >
> > commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
> > Author: John Fastabend <john.fastabend@gmail.com>
> > Date:   Sat Jun 30 13:17:47 2018 +0000
> >
> >     bpf: sockhash fix omitted bucket lock in sock_close
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e978e1a00000
> > start commit:   38e406f6 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> > git tree:       net
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=17e978e1a00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13e978e1a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=60564cb52ab29d5b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=f625baafb9a1c4bfc3f6
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1193d81ea00000
> >
> > Reported-by: syzbot+f625baafb9a1c4bfc3f6@syzkaller.appspotmail.com
> > Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")
> >
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>
> How is mm_update_next_owner connected to bpf?


There seems to be a nasty bug in bpf that causes assorted crashes
throughout the kernel for some time. I've seen a bunch of reproducers
that do something with bpf and then cause a random crash. The more
unpleasant ones are the bugs without reproducers, because for these we
don't have a way to link them back to the bpf bug but they are still
hanging there without good explanation, e.g. maybe a part of one-off
crashes in moderation:
https://syzkaller.appspot.com/upstream#moderation2

Such bugs are nice to fix asap to not produce more and more random
crash reports.

Hillf, did you understand the mechanics of this bug and memory
corruption? A good question is why this was unnoticed by KASAN. If we
could make it catch it at the point of occurrence, then it would be a
single bug report clearly attributed to bpf rather then dozens of
assorted crashes.
