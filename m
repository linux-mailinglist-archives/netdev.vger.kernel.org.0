Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18BBE71DA8
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391057AbfGWR02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:26:28 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37654 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732675AbfGWR02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 13:26:28 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so19481262pfa.4;
        Tue, 23 Jul 2019 10:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=CNtl/XMCYybIEW7V6humgr0dogonmzHoWy1jDSG8h7g=;
        b=U/Rf3sgbh+knlezhXqPSn2tPDhd3yZ9PXhVp0K+yE5NDA0zMH7psYw6WXrRHPR2fCh
         NlQQm28kaTVbrFrhkEv2zHbF574VVME4p3W87tdiK95o/4PAfTP7dr6vDDT6sOWKNvSh
         dy/y0EdSlUOJtG533ff4d54r0QuyNmRxxpyn1hXMxQMuBikt+ssREESIzAN3LjGCreGT
         WhQCCxo/YD9v7AvUypFkTjXyZ15Bc5+HJwnPhMf/Vd47t8D9XJe1czhgtCD69V1oUQ03
         IZbT5xrGjjILlUwCdOuXHarut2lZl0+qPYIcVK3rsCC7I5AOwPKyuG90eTkkQtDp4I6D
         LWNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=CNtl/XMCYybIEW7V6humgr0dogonmzHoWy1jDSG8h7g=;
        b=j95LISudY+UiE1pjbWTTSFi1y2RiJHFqkfQlQGntXUmK29/9OSVfIbQLqaZCR1q9cp
         oAwdQs6ToEs+iv+7+WCWl9oDVIYt6C0umgp8X9sN+LHjuRfBjPZ9bu5291Sm5DHxnaIB
         0RIG1SATZPQYy/fP41NtETVVX4O0q+PEGJhh7kuKPIOHV46azZDImU/c+cDqJpsvFyEf
         MZRrG/Y8YDTUIC2aSC8lyiTtSfaaahTu3flxBoao/XEy6ODimo8zZGuG5XKcBsiKvtlq
         0fMGlqj8O4hIpbKHnewrQuazDPiS+h08qVPOF/rKxgoIbvmzZ6GqBiXGk2FUmiiJ+mPG
         o3DQ==
X-Gm-Message-State: APjAAAVZuITbhFfCfYyXSur90SGbxCf27wEoZj8xEehlBkiuEGS30DRV
        QXvoqlfX89RvldXVfT9noNc=
X-Google-Smtp-Source: APXvYqwDFV8uoDquBgYpuTfkRCO820VbI0AwMpyMP4jOSlXX6JwuDGiKvL0EalNZrSWTzbAetJwdcg==
X-Received: by 2002:a65:4509:: with SMTP id n9mr24190793pgq.133.1563902787447;
        Tue, 23 Jul 2019 10:26:27 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 21sm35183142pfj.76.2019.07.23.10.26.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 10:26:26 -0700 (PDT)
Date:   Tue, 23 Jul 2019 10:26:18 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>
Cc:     David Airlie <airlied@linux.ie>, alexander.deucher@amd.com,
        amd-gfx@lists.freedesktop.org, Alexei Starovoitov <ast@kernel.org>,
        christian.koenig@amd.com, Daniel Borkmann <daniel@iogearbox.net>,
        david1.zhou@amd.com, DRI <dri-devel@lists.freedesktop.org>,
        leo.liu@amd.com, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Message-ID: <5d37433a832d_3aba2ae4f6ec05bc3a@john-XPS-13-9370.notmuch>
In-Reply-To: <CACT4Y+ZGwKP+f4esJdx60AywO9b3Y5Bxb4zLtH6EEkaHpP6Zag@mail.gmail.com>
References: <0000000000001a51c4058ddcb1b6@google.com>
 <CACT4Y+ZGwKP+f4esJdx60AywO9b3Y5Bxb4zLtH6EEkaHpP6Zag@mail.gmail.com>
Subject: Re: kernel panic: stack is corrupted in pointer
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Vyukov wrote:
> On Wed, Jul 17, 2019 at 10:58 AM syzbot
> <syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    1438cde7 Add linux-next specific files for 20190716
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13988058600000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3430a151e1452331
> > dashboard link: https://syzkaller.appspot.com/bug?extid=79f5f028005a77ecb6bb
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111fc8afa00000
> 
> From the repro it looks like the same bpf stack overflow bug. +John
> We need to dup them onto some canonical report for this bug, or this
> becomes unmanageable.

Fixes in bpf tree should fix this. Hopefully, we will squash this once fixes
percolate up.

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

> 
> #syz dup: kernel panic: corrupted stack end in dput
> 
> > The bug was bisected to:
> >
> > commit 96a5d8d4915f3e241ebb48d5decdd110ab9c7dcf
> > Author: Leo Liu <leo.liu@amd.com>
> > Date:   Fri Jul 13 15:26:28 2018 +0000
> >
> >      drm/amdgpu: Make sure IB tests flushed after IP resume
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14a46200600000
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=16a46200600000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12a46200600000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com
> > Fixes: 96a5d8d4915f ("drm/amdgpu: Make sure IB tests flushed after IP
> > resume")
> >
> > Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in:
> > pointer+0x702/0x750 lib/vsprintf.c:2187
> > Shutting down cpus with NMI
> > Kernel Offset: disabled
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > syzbot can test patches for this bug, for details see:
> > https://goo.gl/tpsmEJ#testing-patches


