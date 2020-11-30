Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816AA2C84B1
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 14:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgK3NIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 08:08:55 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:41251 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgK3NIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 08:08:54 -0500
Received: by mail-io1-f72.google.com with SMTP id w28so7159459iox.8
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 05:08:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rRssb1RG/kVfj9BXppmJh4PLBuJGRMgyZUW2mrbT0Iw=;
        b=Nz6mJM51ZSk1gI2KY1dc20g0hl4lynEpvinNImU05niSDW2eHFeHFHPvcr1VDHghSh
         2mTzmt58/vGddrlzQqh76TrsDHKgOVGaUBWgbT1YC7sEpPpKOW2xQRfFukbVZue+5nEi
         y4lmmcFxfbcFNVfKyldTC4PZp4R4AJNCJTB5nPtbV7LuIlh5BbZkBfsTHLW2XUoR9VdA
         JbRMjAfPpSa/Iq3Sn9Sk1CTiIK58g9VviAbT4jz1TpHqOd+R0Glg6R1K5bR+w8G/8Q8s
         glqIGS9DD6oiYyxne7gaQUk8OFE//D3bX3JR70ogn5uRL+S8cueL/tNSyUt29n2xKD97
         BPjQ==
X-Gm-Message-State: AOAM530TiVSb+7o7peBnYArbR5TWO610W4dGxgPaK1CIOYXhBvmfcXUL
        gdjmj4JB13qPyVkFPG4Y/LkAAwHvr9rXMWNL7NLXkhAyqlAO
X-Google-Smtp-Source: ABdhPJxSLN0kD1nuaHczO+upJ1xtHcOKFyWTuZsa4dIoHVU2hsy50Y7Bd4ZokCuo5JbAIXbX7jV7haKv9+Np8H71t9simuiO+6wS
MIME-Version: 1.0
X-Received: by 2002:a02:cd87:: with SMTP id l7mr2834400jap.117.1606741692313;
 Mon, 30 Nov 2020 05:08:12 -0800 (PST)
Date:   Mon, 30 Nov 2020 05:08:12 -0800
In-Reply-To: <000000000000b8a70905b54ef5ca@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d0f2fb05b552b3f3@google.com>
Subject: Re: KASAN: use-after-free Write in kernfs_path_from_node_locked
From:   syzbot <syzbot+19e6dd9943972fa1c58a@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, axelrasmussen@google.com,
        davem@davemloft.net, dsahern@kernel.org,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, liuhangbin@gmail.com,
        netdev@vger.kernel.org, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com, tj@kernel.org, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 0f818c4bc1f3dc0d6d0ea916e0ab30cf5e75f4c0
Author: Axel Rasmussen <axelrasmussen@google.com>
Date:   Tue Nov 24 05:37:42 2020 +0000

    mm: mmap_lock: add tracepoints around lock acquisition

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1626291d500000
start commit:   6174f052 Add linux-next specific files for 20201127
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1526291d500000
console output: https://syzkaller.appspot.com/x/log.txt?x=1126291d500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79c69cf2521bef9c
dashboard link: https://syzkaller.appspot.com/bug?extid=19e6dd9943972fa1c58a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c3351d500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c28809500000

Reported-by: syzbot+19e6dd9943972fa1c58a@syzkaller.appspotmail.com
Fixes: 0f818c4bc1f3 ("mm: mmap_lock: add tracepoints around lock acquisition")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
