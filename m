Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E607131A
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 09:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388423AbfGWHjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 03:39:08 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40372 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfGWHjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 03:39:08 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so79758578iom.7
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 00:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tM6ZfP29yHIXHkq5iTMeXQ4AjIL/XiZWUkv0a/I2jO4=;
        b=usbj8W35wjkWL0ZjAlNlOpJnA68U6AiUa2rQqc18HYqg/292MErMPXrVu08j64WLeQ
         0w/jTSSPy0WoIa1kquvmlS805CgCn/VEtUT7IrJmyzU18EllsyifJC7GjO7DcfmHvBvR
         1lyf1QQErv083xXVI6aqrUjw1695bMtzgRStNHuET/KnHMiXJnskh/TmNxT6IawrQ+EA
         TvKJRpwMnvXZIcBT5iMCnNwriaUgwmZ36nWR+ZeyE3vz2HWijcT5QBjh0ZbBFjG2YQqK
         UQW35jMAn/z+QawL1iqDcnfIDVcdW9nW1bK0w8F4SG8Eq6M2KAJD+fHb+ywbhzEI/nMR
         8nYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tM6ZfP29yHIXHkq5iTMeXQ4AjIL/XiZWUkv0a/I2jO4=;
        b=N1SBZoVPx3OfInR8MXw1/X7tf/CgwzMtxc78TVa8fEdlVP0+GxSMkaDFEZPDHR3db/
         WzlgQDy9mHlzq6eLZgFfGJtjsiRvFTqAt4p5m4l2ww56zVTNLVIa+BtTqVUB+iEXdDxm
         SzooVOfMxTO+z7Gd/6TBcn9zL3gV1hCHNVjSPbf3lEmGLgeUXvgK/W0dI6ma6dXTw5gj
         qxZzQiOmUZG0qQEBgxQ+ZpaiXNfoZyZTRbqncWvHV38Sz43jGslZVbF4zrVyHQ6mKW3b
         HCxH1IWPmZyW7lu/by9I97g4ZidUaRfaBwIC9/WHgj59xzm/AVRb8n+XO0KLFyjCkuvc
         9TIA==
X-Gm-Message-State: APjAAAV4kPgWYPhgA3ELURMXHbMBvaTuvvhVzeJ0zmbfU48XtokY/9O2
        kw9rgXczgPgk4crarrkJ2MiCtMq0LadKYMAA/qTfow==
X-Google-Smtp-Source: APXvYqxknPLPiOAbuB7jqVAi6mu/Fl77yhGj6yGal1fmI4tdBfWn6NaR9DX5QN1Ija5E6QkqejVNYiWatG5/H9GGpW4=
X-Received: by 2002:a5e:de0d:: with SMTP id e13mr45601420iok.144.1563867546989;
 Tue, 23 Jul 2019 00:39:06 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000001a51c4058ddcb1b6@google.com>
In-Reply-To: <0000000000001a51c4058ddcb1b6@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 23 Jul 2019 09:38:56 +0200
Message-ID: <CACT4Y+ZGwKP+f4esJdx60AywO9b3Y5Bxb4zLtH6EEkaHpP6Zag@mail.gmail.com>
Subject: Re: kernel panic: stack is corrupted in pointer
To:     syzbot <syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>
Cc:     David Airlie <airlied@linux.ie>, alexander.deucher@amd.com,
        amd-gfx@lists.freedesktop.org, Alexei Starovoitov <ast@kernel.org>,
        christian.koenig@amd.com, Daniel Borkmann <daniel@iogearbox.net>,
        david1.zhou@amd.com, DRI <dri-devel@lists.freedesktop.org>,
        leo.liu@amd.com, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 10:58 AM syzbot
<syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    1438cde7 Add linux-next specific files for 20190716
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13988058600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3430a151e1452331
> dashboard link: https://syzkaller.appspot.com/bug?extid=79f5f028005a77ecb6bb
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111fc8afa00000

From the repro it looks like the same bpf stack overflow bug. +John
We need to dup them onto some canonical report for this bug, or this
becomes unmanageable.

#syz dup: kernel panic: corrupted stack end in dput

> The bug was bisected to:
>
> commit 96a5d8d4915f3e241ebb48d5decdd110ab9c7dcf
> Author: Leo Liu <leo.liu@amd.com>
> Date:   Fri Jul 13 15:26:28 2018 +0000
>
>      drm/amdgpu: Make sure IB tests flushed after IP resume
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14a46200600000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=16a46200600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12a46200600000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com
> Fixes: 96a5d8d4915f ("drm/amdgpu: Make sure IB tests flushed after IP
> resume")
>
> Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in:
> pointer+0x702/0x750 lib/vsprintf.c:2187
> Shutting down cpus with NMI
> Kernel Offset: disabled
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
