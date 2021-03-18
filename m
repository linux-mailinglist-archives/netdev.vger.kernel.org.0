Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2516C340956
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 16:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhCRPy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 11:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbhCRPyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 11:54:20 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D2FC06175F
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 08:54:20 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id g185so2455505qkf.6
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 08:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J+EfAqBWMuldZhFLKTK7DYwRmCCO76h3wFXCCWaZSMc=;
        b=JAuMzMkBbITRNY13aACDLIk/k+iuZNwnY+TuVS/VkWrpwiwiZnjIqAqXg+sgD6k0rD
         2683zQhrba+zznwFVhN9TrfJ2tXM27aBcej6YTISwW5enO4MpUM/7/vUSZLCc/eilbKY
         de8krjIAoXdrlFD7hjXponAFXD9uzSZQ848crh8XQfUyaA7GE/p44upKGkaYGQID7gjQ
         TGu3nqOZmibsYwtW4nkpKaMz1xaGTssKbFmUcf+q/G9q1Acnpjk726Z+krAWQQ7qI1tE
         /FFn9w3c8gJi84/60Z/hO18B5j9iNY799t13VZZHHC7ydIZvKIyuqgIX3IRpPo6ahMIi
         Auyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J+EfAqBWMuldZhFLKTK7DYwRmCCO76h3wFXCCWaZSMc=;
        b=ADpqHJs+PTswLjy8KFZVa7wBu4fNVoV6HU2zJmudWP8au2caLlNLkiNfWGbSwCayx8
         kQIu8wap6PGvy7LySkL1T7KKu8zvQNboia8t7vzvEzJqeDvBjUDyvmNGWUq8iOjKChE1
         vDylq7X63UDX9HHTe2fgtIMgOO8xojJGdS4tG0X3Kcwy7uh9zMgnERl1fr2rxKsqreab
         5HbEoLFji2aAR1oV+DgQY8TOJOHazo8hzYsiUznDWWi0jEshNcXZ6+niPay2cQQ6Gf+9
         Zn0mnCjAynU5EJH3JfczXeR+eS5YzYNQxtUyyCvDUktKETDjeMpNffXgwUfQwR0sxEea
         +5BQ==
X-Gm-Message-State: AOAM533atyQzbGgC9VZN0BdsfVvwMte7D2he8xW/fQC8vc0LrmpUwA7C
        3/SjT8voE150WGJ83+70mpysJmN+6Ztc/Bx+k8JLbw==
X-Google-Smtp-Source: ABdhPJxFh76WWb8+3I2ntXhBqRjTSAc+1WcZgiaZ7ifnOH2xeqOLOi44Fqrc0Z0eZNzc0q7qHi5UZ42ezkHaQtthL9A=
X-Received: by 2002:a05:620a:410f:: with SMTP id j15mr5028891qko.424.1616082859168;
 Thu, 18 Mar 2021 08:54:19 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000096cdaa05bd32d46f@google.com> <CACT4Y+ZjdOaX_X530p+vPbG4mbtUuFsJ1v-gD24T4DnFUqcudA@mail.gmail.com>
 <CACT4Y+ZjVS+nOxtEByF5-djuhbCYLSDdZ7V04qJ0edpQR0514A@mail.gmail.com>
 <CACT4Y+YXifnCtEvLu3ps8JLCK9CBLzEuUAozfNR9v1hsGWspOg@mail.gmail.com>
 <ed89390a-91e1-320a-fae5-27b7f3a20424@codethink.co.uk> <CACT4Y+a1pQ96UWEB3pAnbxPZ+6jW2tqSzkTMqJ+XSbZsKLHgAw@mail.gmail.com>
 <bf2e19a3-3e3a-0eb1-ae37-4cc3b1a7af42@codethink.co.uk> <CACT4Y+ZVaxQAnpy_bMGwviZMskD-fy1KgY7pbrjcCRXr24eu2Q@mail.gmail.com>
 <8372d8e5-af6e-c851-a0ac-733e269102ce@codethink.co.uk>
In-Reply-To: <8372d8e5-af6e-c851-a0ac-733e269102ce@codethink.co.uk>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 18 Mar 2021 16:54:07 +0100
Message-ID: <CACT4Y+aDY38_to=UN9YtAr2aBrSaEqs0jfd9R--Qxdw8=jEt3w@mail.gmail.com>
Subject: Re: [syzbot] BUG: unable to handle kernel access to user memory in sock_ioctl
To:     Ben Dooks <ben.dooks@codethink.co.uk>
Cc:     syzbot <syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-riscv <linux-riscv@lists.infradead.org>, andrii@kernel.org,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 4:35 PM Ben Dooks <ben.dooks@codethink.co.uk> wrote:
>
> On 18/03/2021 15:18, Dmitry Vyukov wrote:
> > On Mon, Mar 15, 2021 at 3:41 PM Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> >>
> >> On 15/03/2021 11:52, Dmitry Vyukov wrote:
> >>> On Mon, Mar 15, 2021 at 12:30 PM Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> >>>>
> >>>> On 14/03/2021 11:03, Dmitry Vyukov wrote:
> >>>>> On Sun, Mar 14, 2021 at 11:01 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> >>>>>>> On Wed, Mar 10, 2021 at 7:28 PM syzbot
> >>>>>>> <syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com> wrote:
> >>>>>>>>
> >>>>>>>> Hello,
> >>>>>>>>
> >>>>>>>> syzbot found the following issue on:
> >>>>>>>>
> >>>>>>>> HEAD commit:    0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
> >>>>>>>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> >>>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=122c343ad00000
> >>>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e3c595255fb2d136
> >>>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=c23c5421600e9b454849
> >>>>>>>> userspace arch: riscv64
> >>>>>>>>
> >>>>>>>> Unfortunately, I don't have any reproducer for this issue yet.
> >>>>>>>>
> >>>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >>>>>>>> Reported-by: syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com
> >>>>>>>
> >>>>>>> +riscv maintainers
> >>>>>>>
> >>>>>>> Another case of put_user crashing.
> >>>>>>
> >>>>>> There are 58 crashes in sock_ioctl already. Somehow there is a very
> >>>>>> significant skew towards crashing with this "user memory without
> >>>>>> uaccess routines" in schedule_tail and sock_ioctl of all places in the
> >>>>>> kernel that use put_user... This looks very strange... Any ideas
> >>>>>> what's special about these 2 locations?
> >>>>>
> >>>>> I could imagine if such a crash happens after a previous stack
> >>>>> overflow and now task data structures are corrupted. But f_getown does
> >>>>> not look like a function that consumes way more than other kernel
> >>>>> syscalls...
> >>>>
> >>>> The last crash I looked at suggested somehow put_user got re-entered
> >>>> with the user protection turned back on. Either there is a path through
> >>>> one of the kernel handlers where this happens or there's something
> >>>> weird going on with qemu.
> >>>
> >>> Is there any kind of tracking/reporting that would help to localize
> >>> it? I could re-reproduce with that code.
> >>
> >> I'm not sure. I will have a go at debugging on qemu today just to make
> >> sure I can reproduce here before I have to go into the office and fix
> >> my Icicle board for real hardware tests.
> >>
> >> I think my first plan post reproduction is to stuff some trace points
> >> into the fault handlers to see if we can get a idea of faults being
> >> processed, etc.
> >>
> >> Maybe also add a check in the fault handler to see if the fault was
> >> in a fixable region and post an error if that happens / maybe retry
> >> the instruction with the relevant SR_SUM flag set.
> >>
> >> Hopefully tomorrow I can get a run on real hardware to confirm.
> >> Would have been better if the Unmatched board I ordered last year
> >> would turn up.
> >
> > In retrospect it's obvious what's common between these 2 locations:
> > they both call a function inside of put_user.
> >
> > #syz dup:
> > BUG: unable to handle kernel access to user memory in schedule_tail
>
> I think so. I've posted a patch that you can test, which should force
> the flags to be saved over switch_to(). I think the sanitisers are just
> making it easier to see.
>
> There is a seperate issue of passing complicated things to put_user()
> as for security, the function may be executed with the user-space
> protections turned off. I plan to raise this on the kernel list later
> once I've done some more testing.

Thanks for quick debugging and the fix. This is the top crasher on the
syzbot instance, so this will unblock real testing.
I think I will trust your testing. syzbot instance is now on
riscv/fixes branch, so it will pick it up as soon as it's in that tree
(hopefully soon) and will do as exhaustive testing as possible :)
