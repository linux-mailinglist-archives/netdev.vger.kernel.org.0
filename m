Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C7733B1C5
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCOLw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhCOLwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:52:16 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0017FC061574
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:52:15 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id t4so31295250qkp.1
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=32TvfxSkzYWhVmQkeQkwenaCMad2tF6b4G0jVDrs/a4=;
        b=ALfTs7zBGQzj2IMrYgNcHtnpLmGTXDRfaQxZeu/odl7eyYeCFi0V4NJ2x+y2LuA/uz
         ph/729wVQpd0FYg5hUL/S5JpkzzIIbXewyEbvTpYCTaOondRqIV/FlqJJHPMNzO38S0Q
         uJIkZ/5XeFOaFuwSu0wnZUFE2kxWowkZVUzuVr6UYgHHX97qT7+D5GZ74lpqhG97Y0Iu
         QuRRiUBPJqd3xTswAwvv0dz/KN7xZuyVta1zyH76bJzIgh6+tWMhlBeBOyQEjnQz6oGu
         Lfa9LATToyUKerCBNO7M5foMGA1o0zbY18S+cyGiuV4dLDY5SS1PphobALB7tG2TshM+
         ifrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=32TvfxSkzYWhVmQkeQkwenaCMad2tF6b4G0jVDrs/a4=;
        b=mfsgbzxxcyyn4MEJzx01axast2o7Gd4IC9ltHGKBx+IW/JMsC4GUUKaOo4pu1+nFgY
         c20EN0QELsqZiZDVSMzJ362NEcWA6NKR1rIDkA/SnXZWbSFCCBiVJ0HxxtKL6W6rr07A
         Pq0t6QPk04ML8jtfcJdaNYBDtqW/i5kkGBDJaG72DrrqYqHD60nPZIRwqLx0ETMVnK8X
         AjTLjAd9WJ5x3Vm00x43Q4bS/kzGNYDMWNSyNOkyOiN7oVpfMg1zkf/Id9M6WURhiwRr
         1vGIZSuZlw1eKWhQk7eunuY4Bno8lb14it0aXyA+bralHBXhpO6ptqsA+YXPMdzamndJ
         vG8g==
X-Gm-Message-State: AOAM533++M8RTd3MFnsBKQH/US65htSVJNrlGXe6kpOErvE46Y5sAjZV
        z5R0RlkfRG0yKgcnxOHg9pHQGlt+cy6/18b+7nNmMw==
X-Google-Smtp-Source: ABdhPJyTiP3VZRD2+BkeloNDqEutijd0tcaoS2gge3f4Ric1U/h+BWCA5c0B+z0nk79PDPEdKLh0VUeNxtwNGc7korU=
X-Received: by 2002:a05:620a:981:: with SMTP id x1mr23826304qkx.501.1615809134984;
 Mon, 15 Mar 2021 04:52:14 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000096cdaa05bd32d46f@google.com> <CACT4Y+ZjdOaX_X530p+vPbG4mbtUuFsJ1v-gD24T4DnFUqcudA@mail.gmail.com>
 <CACT4Y+ZjVS+nOxtEByF5-djuhbCYLSDdZ7V04qJ0edpQR0514A@mail.gmail.com>
 <CACT4Y+YXifnCtEvLu3ps8JLCK9CBLzEuUAozfNR9v1hsGWspOg@mail.gmail.com> <ed89390a-91e1-320a-fae5-27b7f3a20424@codethink.co.uk>
In-Reply-To: <ed89390a-91e1-320a-fae5-27b7f3a20424@codethink.co.uk>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 15 Mar 2021 12:52:03 +0100
Message-ID: <CACT4Y+a1pQ96UWEB3pAnbxPZ+6jW2tqSzkTMqJ+XSbZsKLHgAw@mail.gmail.com>
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

On Mon, Mar 15, 2021 at 12:30 PM Ben Dooks <ben.dooks@codethink.co.uk> wrote:
>
> On 14/03/2021 11:03, Dmitry Vyukov wrote:
> > On Sun, Mar 14, 2021 at 11:01 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> >>> On Wed, Mar 10, 2021 at 7:28 PM syzbot
> >>> <syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com> wrote:
> >>>>
> >>>> Hello,
> >>>>
> >>>> syzbot found the following issue on:
> >>>>
> >>>> HEAD commit:    0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
> >>>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> >>>> console output: https://syzkaller.appspot.com/x/log.txt?x=122c343ad00000
> >>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e3c595255fb2d136
> >>>> dashboard link: https://syzkaller.appspot.com/bug?extid=c23c5421600e9b454849
> >>>> userspace arch: riscv64
> >>>>
> >>>> Unfortunately, I don't have any reproducer for this issue yet.
> >>>>
> >>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >>>> Reported-by: syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com
> >>>
> >>> +riscv maintainers
> >>>
> >>> Another case of put_user crashing.
> >>
> >> There are 58 crashes in sock_ioctl already. Somehow there is a very
> >> significant skew towards crashing with this "user memory without
> >> uaccess routines" in schedule_tail and sock_ioctl of all places in the
> >> kernel that use put_user... This looks very strange... Any ideas
> >> what's special about these 2 locations?
> >
> > I could imagine if such a crash happens after a previous stack
> > overflow and now task data structures are corrupted. But f_getown does
> > not look like a function that consumes way more than other kernel
> > syscalls...
>
> The last crash I looked at suggested somehow put_user got re-entered
> with the user protection turned back on. Either there is a path through
> one of the kernel handlers where this happens or there's something
> weird going on with qemu.

Is there any kind of tracking/reporting that would help to localize
it? I could re-reproduce with that code.

> I'll be trying to get this run up on real hardware this week, the nvme
> with my debian install died last week so I have to go and re-install
> the machine to get development work done on it.
>
> --
> Ben Dooks                               http://www.codethink.co.uk/
> Senior Engineer                         Codethink - Providing Genius
>
> https://www.codethink.co.uk/privacy.html
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/ed89390a-91e1-320a-fae5-27b7f3a20424%40codethink.co.uk.
