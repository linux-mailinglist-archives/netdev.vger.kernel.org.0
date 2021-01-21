Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11322FE39A
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 08:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbhAUHQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 02:16:36 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:33230 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbhAUHOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 02:14:52 -0500
Received: by mail-io1-f69.google.com with SMTP id m3so1891964ioy.0
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 23:14:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xo9ghie0HmQTCVFE6esqYP8OmOHWlrtIq/GxNkUwj5U=;
        b=YGmjRUPT626pgA+RTs7khLY5HtQ38I09OAGLutz9G6tg8DEdrBg4XmuUhuhi7iFIdx
         vQvWey+f3dcRQsKCB2E5FAvBOUMGG64/ekjUtl0LgZV3T5NGuSHRzGkAEEvyDJmwNRpI
         L2A2I8oGPAcq0TacZD8YgDs+B4fgZabSzUWZaTYTYPAqb5MAbjQs02LmNMOj10nPq8Pm
         LBocbl/Cx/A+Be5qm5K4CpGGTxCh0kTVtLbxbe2frHSTlfUK4E+OxmbZNLd7noes33dx
         pGyWl+mX4Jm7DNe4Ji96OWTreBSY4kNIszhd8XmRm6JchQ4a2+kwcdOJCDsgR4B5rq7H
         F84Q==
X-Gm-Message-State: AOAM5312nTaIEO65Vh3UbNOzqc6HdN/CwsX/RecphIANOyXcZwqBs+Iu
        p/1JMQHIduvaJrDBTSsWgbTeP6zjWdrHKwo6EvDkPLdv/Jkk
X-Google-Smtp-Source: ABdhPJzDLnqdQook2ZXZb3CUnas5dN6lgKAj1/BZrrphe7tOta2u+ZsyZ5hzlDABjpjcMMegIBs85pqV27tUbqqi6hEb5rGPe9sv
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1985:: with SMTP id g5mr10839151ilf.257.1611213251877;
 Wed, 20 Jan 2021 23:14:11 -0800 (PST)
Date:   Wed, 20 Jan 2021 23:14:11 -0800
In-Reply-To: <000000000000c8dd4a05b828d04c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000891f4605b963d113@google.com>
Subject: Re: KASAN: vmalloc-out-of-bounds Read in bpf_trace_run7
From:   syzbot <syzbot+fad5d91c7158ce568634@syzkaller.appspotmail.com>
To:     andrii@kernel.org, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 8b401f9ed2441ad9e219953927a842d24ed051fc
Author: Yonghong Song <yhs@fb.com>
Date:   Thu May 23 21:47:45 2019 +0000

    bpf: implement bpf_send_signal() helper

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=123408e7500000
start commit:   7d68e382 bpf: Permit size-0 datasec
git tree:       bpf-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=113408e7500000
console output: https://syzkaller.appspot.com/x/log.txt?x=163408e7500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0c7843b8af99dff
dashboard link: https://syzkaller.appspot.com/bug?extid=fad5d91c7158ce568634
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1224daa4d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13dfabd0d00000

Reported-by: syzbot+fad5d91c7158ce568634@syzkaller.appspotmail.com
Fixes: 8b401f9ed244 ("bpf: implement bpf_send_signal() helper")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
