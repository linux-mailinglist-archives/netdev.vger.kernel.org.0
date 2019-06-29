Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B1B5A81F
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 04:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfF2CKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 22:10:03 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:40393 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfF2CKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 22:10:01 -0400
Received: by mail-io1-f71.google.com with SMTP id v11so8671233iop.7
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 19:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=84uQch8ytJ1lCabOHF26kS1aihVf0OWc3QTgyNOP9t0=;
        b=W76FR+NtYBBR7YNGHHvkld0PRecGphQwvYOEkT1IRm/rDgfREChNLXozxiIHtG8GvF
         cOUdCPIbnYeWn6Kb1qpV3cDLZFFUqrJ9hu3Unw1Swp4nsjpCPTNbOI085FzJeikdOiZS
         LGAp/4VXtD16vObRwF5tA7nJzOT8XOsemlSME0ZfVBy0XKbjYzuU0Jq+yzGXauMEZ3Ap
         auqNKqMnil68SOxnl284g3fwciwitCuF44GkzDptf37qZoTFQmwxTXYi0SkZ2B88mVhR
         ODS+6IWPjgKsD3iax+VfB0ldXP3M+eWnDpxbbaKe7Om/cTJVP4W6NTxnkctWwnr/MNjz
         aqYA==
X-Gm-Message-State: APjAAAVzOZuVnwHSNneoyT3cFTFuGM4FOdme57QhfaBLDkUGvtC3n4Nb
        BCINRm54qmRPsVupD1PKccUiuNBazCk7V8PGOnDLOGIW50Gq
X-Google-Smtp-Source: APXvYqwIj/ChdaSSPt20gSuvnjyqICrd1EGtQL3DgiudeFG0KMFP8BQKEBHpsTMm2Iudrae9YgBrLN5/PZRaKtNbeTFEr1JIeBQt
MIME-Version: 1.0
X-Received: by 2002:a5d:94d7:: with SMTP id y23mr12337354ior.296.1561774200691;
 Fri, 28 Jun 2019 19:10:00 -0700 (PDT)
Date:   Fri, 28 Jun 2019 19:10:00 -0700
In-Reply-To: <00000000000017c9e2058baf4825@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000073a232058c6ce410@google.com>
Subject: Re: BUG: unable to handle kernel paging request in __do_softirq
From:   syzbot <syzbot+0b224895cb9454584de1@syzkaller.appspotmail.com>
To:     ast@kernel.org, bp@alien8.de, bpf@vger.kernel.org,
        daniel@iogearbox.net, dvyukov@google.com, hpa@zytor.com,
        jacob.jun.pan@linux.intel.com, john.fastabend@gmail.com,
        konrad.wilk@oracle.com, len.brown@intel.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, puwen@hygon.cn, rppt@linux.vnet.ibm.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit e9db4ef6bf4ca9894bb324c76e01b8f1a16b2650
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Sat Jun 30 13:17:47 2018 +0000

     bpf: sockhash fix omitted bucket lock in sock_close

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16aac819a00000
start commit:   29f785ff Merge branch 'fixes' of git://git.kernel.org/pub/..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15aac819a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11aac819a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e5c77f8090a3b96b
dashboard link: https://syzkaller.appspot.com/bug?extid=0b224895cb9454584de1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1076d132a00000

Reported-by: syzbot+0b224895cb9454584de1@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
