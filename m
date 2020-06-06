Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FB71F06DF
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 16:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgFFODF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 10:03:05 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:37634 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgFFODE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 10:03:04 -0400
Received: by mail-il1-f198.google.com with SMTP id n2so8501559ilq.4
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 07:03:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=LJZAuGgzfSnkvHTmE00Iff6jeeP1gMLsIve5vPXs9J8=;
        b=QG/Yf3o6D1wGX0X3lWV+P8jm9s7RF+281SaN6uvLlaWFiNxBP/lDZfAX7vdRx0cqVg
         BycHtUuF+VByfDI24USRwsi9BuauISGcuHrN+CMIOTrwVIGOVcD6J/opFGJo6zvFLRYW
         Vmp5O7aIOnyHYgSpEwCHS4z1jARjLBsATLdyQGN+Dit5ODYLWFzPvpG6QjV40NHrUuTl
         /2Ws8Vd5VViRceudoiF134vzZmIKLuSMjbuLyEzHKvmghPCsYA15uGi+0Nk09dMr6xOM
         Sh9WwokuZJrrSZnsGjwasMDDHzPTsk7amGizRpGqXoE34eviyp/JLlE0U/00fmwS62Do
         +N8g==
X-Gm-Message-State: AOAM530ZYzUhtS/X+/6rTIkSQY3xVswnW8PRueleoLRwyK3aILuOGvdd
        kh8+FpwXMwBeqnLLCH+924Jkpz6ALqOzQxyqciZcaaqYjXmg
X-Google-Smtp-Source: ABdhPJzqn+ZSrIp0x1Uvpzv2NUn6zmkiotwyelbnzRpg0vI/I0Hdz20BOyamVd6Xl18toENqbikwZsxqDbgImYnWA1pkJU5UCXOc
MIME-Version: 1.0
X-Received: by 2002:a02:998b:: with SMTP id a11mr13290455jal.117.1591452183421;
 Sat, 06 Jun 2020 07:03:03 -0700 (PDT)
Date:   Sat, 06 Jun 2020 07:03:03 -0700
In-Reply-To: <000000000000c54420059e4f08ff@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011eb1705a76ad69d@google.com>
Subject: Re: WARNING in dev_change_net_namespace
From:   syzbot <syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@gmail.com,
        ebiederm@xmission.com, edumazet@google.com, eric.dumazet@gmail.com,
        hawk@kernel.org, jiri@mellanox.com, johannes.berg@intel.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        saiprakash.ranjan@codeaurora.org, songliubraving@fb.com,
        suzuki.poulose@arm.com, syzkaller-bugs@googlegroups.com,
        will@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 13dc4d836179444f0ca90188cfccd23f9cd9ff05
Author: Will Deacon <will@kernel.org>
Date:   Tue Apr 21 14:29:18 2020 +0000

    arm64: cpufeature: Remove redundant call to id_aa64pfr0_32bit_el0()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=109aa3b1100000
start commit:   7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=129aa3b1100000
console output: https://syzkaller.appspot.com/x/log.txt?x=149aa3b1100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be4578b3f1083656
dashboard link: https://syzkaller.appspot.com/bug?extid=830c6dbfc71edc4f0b8f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12032832100000

Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
Fixes: 13dc4d836179 ("arm64: cpufeature: Remove redundant call to id_aa64pfr0_32bit_el0()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
