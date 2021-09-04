Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC5C400A61
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 10:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbhIDIYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 04:24:13 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49739 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbhIDIYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 04:24:12 -0400
Received: by mail-io1-f70.google.com with SMTP id k6-20020a6b3c060000b0290568c2302268so1066753iob.16
        for <netdev@vger.kernel.org>; Sat, 04 Sep 2021 01:23:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=M3toUYP73wjtZjjuGZaluiFGnzByzbicamvbzl2GU/w=;
        b=sb/PWi9OErz2RWd+4lDkUZCYoCQ5H5ZWRgJSdV76xyJg7D3xXyuG3ClQ/9pehBi+Oc
         Vv81Rj6t9WaEaZwHlbQtb5Y1wx89W25uTy6nLoYtl+BjHdbTLZDM7zBbEk9DIHDKfPtD
         1nu5WjFRbiI7gOSr0cICSNcijJevz/4W3uGRwyvihnHOqY9gNzswWqkrQZ5E13zutUVs
         eyhtLu51KiqW+J9eHg8+5YrOA1fYO/RM2UcDkTr6IAjKwGWQJs/Ar2WSmTieHh6czeOH
         m4Ukqke8kwkN+pmcyA+0RbM2xyH7h8c04JvBdsq7ibn2cJj6ROhKbksGP1IdaJSw4OIL
         6cPQ==
X-Gm-Message-State: AOAM531MFiOpT8las/PIEzd5SNHFXp9KGF/6zJ9MhWux2fPgeNMCIr2o
        KdsryjxIbU/wcaEb90smqnu77VP44tS0o4R6L3GmZDHzhE9z
X-Google-Smtp-Source: ABdhPJz3nU0+9fHDM9jpojjeZT6ijTGdbtoJlUBtgSHEtb4+BB6TZlWcNDnkyxKIOI/Pw8b3cTxJ3iM9/EBYgvrmkdZYQKhrS7Y4
MIME-Version: 1.0
X-Received: by 2002:a92:d282:: with SMTP id p2mr1977515ilp.259.1630743791386;
 Sat, 04 Sep 2021 01:23:11 -0700 (PDT)
Date:   Sat, 04 Sep 2021 01:23:11 -0700
In-Reply-To: <0000000000003166f105cb201ea6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000067c79605cb2720bb@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in hash_netport_create
From:   syzbot <syzbot+3f5904753c2388727c6c@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=113125f5300000
start commit:   a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=133125f5300000
console output: https://syzkaller.appspot.com/x/log.txt?x=153125f5300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1ac29107aeb2a552
dashboard link: https://syzkaller.appspot.com/bug?extid=3f5904753c2388727c6c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14581b33300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13579a69300000

Reported-by: syzbot+3f5904753c2388727c6c@syzkaller.appspotmail.com
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
