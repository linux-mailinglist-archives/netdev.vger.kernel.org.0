Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DFA4015E4
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 07:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238744AbhIFF0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 01:26:14 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:38688 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbhIFF0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 01:26:13 -0400
Received: by mail-io1-f70.google.com with SMTP id n8-20020a6b7708000000b005bd491bdb6aso4410674iom.5
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 22:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ZvVDoBv3IAH8y1S0lXBguVVm08g+13BDGKyt9/bor9Y=;
        b=N8ZiAjjNT52U4mCRlOdac7sNgHsk3D3RIFm7GOiCnPVc9cwbrae35pZc3FXvVbfS1p
         1JSwr5niuixCW82n+c65eXLCOFBjxBVhBmHZDIf4xGWTXFBG96yGhxyWtLHK0K518zfe
         T3oyNVt8Ku8CAU+w5pGauWlq31RpSmzCICYCKUjVcemEpuVrbZasgUn9UgRW8xrzyaoT
         IIPwaKp3v7pGKDyEQyn2YXb9qiB9zxy4tVzq0+K5W/6tcwKRbYc+72VQLU3UeDT1OuEx
         zkjoT44p0zB3eicsBjTPMEMhb8ds3PNnjTbiH5HSxrxVHx84ZiFvCQlyrjXvokf2pCgR
         4LMA==
X-Gm-Message-State: AOAM532Eyy0Jj3BbM2Kid8iB+PmXWjqgARZXmZD8bLT+oooTdc2zAMrE
        vEI67NWVg33vSyYsTDb6QigeXAzjgaEw5jzF8+xCie/rMHMj
X-Google-Smtp-Source: ABdhPJzd449QRHh060sSTuNCXAhTIrwXmTA69htRCTu+gj5HcaUCJCrRFnuZykGCC4UYH518hB/hhMO85JbepGiR6Qh7k2AHNNjo
MIME-Version: 1.0
X-Received: by 2002:a02:294b:: with SMTP id p72mr9242294jap.0.1630905907569;
 Sun, 05 Sep 2021 22:25:07 -0700 (PDT)
Date:   Sun, 05 Sep 2021 22:25:07 -0700
In-Reply-To: <000000000000ed8c0a05cb1ff6d8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000486b8b05cb4cdf5c@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in nf_tables_newset
From:   syzbot <syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, eric.dumazet@gmail.com, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, w@1wt.eu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 16:45:49 2021 +0000

    mm: don't allow oversized kvmalloc() calls

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15f767b1300000
start commit:   a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17f767b1300000
console output: https://syzkaller.appspot.com/x/log.txt?x=13f767b1300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7860a0536ececf0c
dashboard link: https://syzkaller.appspot.com/bug?extid=cd43695a64bcd21b8596
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13281b33300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1077b4b9300000

Reported-by: syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
