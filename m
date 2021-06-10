Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D4C3A262B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 10:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhFJIGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 04:06:04 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:34327 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJIGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 04:06:03 -0400
Received: by mail-io1-f70.google.com with SMTP id z8-20020a5e92480000b02904ae394676efso12923735iop.1
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 01:04:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=EXuC5hR+DxXmhBYFDXYIPj2wRbgENSDGNStCsBqTJu0=;
        b=pCUOqtgfcYX0PAVFzUkua0fFVuuFs9tJZyVCSDf0VZR89hm6Sea9/A/M2c6ywIbxNW
         AtbiSfWGJEy79ykn7l0G6t05wjvOLREJjEWZhU1AIbbYRSwE25OhStbSt1u0bfho13P9
         Kygcw5LCC6TrpdwBJEppfTVPrRzh76n9tfrXghrlN4vOWtVxFPKzVMCxVf5hceuBGjkX
         I9iHI/FpgKZL9yN0gJxfz9tpaHYmgihRlHRZMkweI/HWaByjtx3oxF21Y3i8V6Tsb8vD
         DsGIm1eyNS3RQRUj/xHpBcWR0bfV00XZJkPni2PbybJtMiUtTV9oam5Ldj3t+Pb25bXj
         rSlg==
X-Gm-Message-State: AOAM530qxBQlhKb6agrbUzWzKDahPUNqxACKw1Bjv5s9yKxkxg3TnEl3
        Ldd47hMIGP/Fn+sKPA2hyoS19j+MJrVC3R99fdyXZBfUMt9K
X-Google-Smtp-Source: ABdhPJxRRi/1I5TNhoQba1+i+apRY6ysQAyvYPwt9CP8LLzEVHGx0ECuewSq/IOcrMT0gR4jj+XFBdzrofOIP0eVpO+iJSk1UUPl
MIME-Version: 1.0
X-Received: by 2002:a92:640d:: with SMTP id y13mr3083856ilb.158.1623312247492;
 Thu, 10 Jun 2021 01:04:07 -0700 (PDT)
Date:   Thu, 10 Jun 2021 01:04:07 -0700
In-Reply-To: <0000000000003842c805c44e7951@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000df175a05c464d5b7@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in blk_mq_exit_sched
From:   syzbot <syzbot+77ba3d171a25c56756ea@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, coreteam@netfilter.org, davem@davemloft.net,
        dsahern@kernel.org, fw@strlen.de, hch@lst.de,
        john.garry@huawei.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Apr 21 07:51:08 2021 +0000

    netfilter: arp_tables: pass table pointer via nf_hook_ops

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14e76d88300000
start commit:   a1f92694 Add linux-next specific files for 20210518
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16e76d88300000
console output: https://syzkaller.appspot.com/x/log.txt?x=12e76d88300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d612e75ffd53a6d3
dashboard link: https://syzkaller.appspot.com/bug?extid=77ba3d171a25c56756ea
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c901ebd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1406b797d00000

Reported-by: syzbot+77ba3d171a25c56756ea@syzkaller.appspotmail.com
Fixes: f9006acc8dfe ("netfilter: arp_tables: pass table pointer via nf_hook_ops")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
