Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4CF1C18B5
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbgEAOtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:49:07 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:33772 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730537AbgEAOtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 10:49:04 -0400
Received: by mail-il1-f200.google.com with SMTP id l18so5036132ilg.0
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 07:49:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Jh5jVpDHfQplZhcaNyu6KjtSKvR1Mtv8UVWG8cYmvgs=;
        b=YrnfeEwXjHBIsmjkwiKrVj3DMj/cFWoFERFARCtkZFWtZPSK+w3oLGwGz7so5Y2az9
         F5pzdAUcxQbiBTl5H8hlbwXN6L+/VHO2gAmLQoLH3i+JlYJ07u6Xu7ujFBo19maWyfI9
         mHtyIaWr01CH1sMJsxulThqiAfKV22kAhEtr9J7ndIWt6SsLaaQbWoHw7O08SwVGCnxJ
         MGN/AieNRZcmnubSO2nMUWVbgoZZ0QPUHMN3uII7PX8dcyi+dxlYJCEL9oTEpVVxRDpj
         AXT1w9fEiwmhnUjx2qBLUTLwnG6UNMFC9ynryIX53tK4T7gkbvfz1zgQM+ZiZl4OgVxb
         Nbmg==
X-Gm-Message-State: AGi0PuZQVdZNIm/dHNhe4wLzpVIWruWGdoVmm7A35p8BHyA6hhORPaLD
        eDC7C6HY4eY+W2nSaBNpVh1GcY4txy+liO4Lumtq+Eg8+oL4
X-Google-Smtp-Source: APiQypLK1R32YygzKw6o+zrjKt0GIokFgX8oowRX0+5I/s/40LhWT/hwtwkehxiJ47ijw4bdIgcKya/AdAIK2f7+ZiLlGEbjeIlX
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr3777413ilj.149.1588344543764;
 Fri, 01 May 2020 07:49:03 -0700 (PDT)
Date:   Fri, 01 May 2020 07:49:03 -0700
In-Reply-To: <00000000000052913105a4943655@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004fe61505a49748ee@google.com>
Subject: Re: KASAN: use-after-free Read in inet_diag_bc_sk
From:   syzbot <syzbot+13bef047dbfffa5cd1af@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, khlebnikov@yandex-team.ru,
        kpsingh@chromium.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org, zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit b1f3e43dbfacfcd95296b0f80f84b186add9ef54
Author: Dmitry Yakunin <zeil@yandex-team.ru>
Date:   Thu Apr 30 15:51:15 2020 +0000

    inet_diag: add support for cgroup filter

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=106b15f8100000
start commit:   37ecb5b8 hinic: Use kmemdup instead of kzalloc and memcpy
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=126b15f8100000
console output: https://syzkaller.appspot.com/x/log.txt?x=146b15f8100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b1494ce3fbc02154
dashboard link: https://syzkaller.appspot.com/bug?extid=13bef047dbfffa5cd1af
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12296e60100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=150c6f02100000

Reported-by: syzbot+13bef047dbfffa5cd1af@syzkaller.appspotmail.com
Fixes: b1f3e43dbfac ("inet_diag: add support for cgroup filter")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
