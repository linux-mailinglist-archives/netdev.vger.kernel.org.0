Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B56C9F578E
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389849AbfKHTYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:24:10 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:54927 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732046AbfKHSxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:53:01 -0500
Received: by mail-il1-f198.google.com with SMTP id t67so7793787ill.21
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 10:53:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Sl9ZT+3VnhHk9C9hUuWzxJC0ZnzOKIM3/flYfXRQH6Y=;
        b=Fd8L8bYvaLSyAtYxu4+OIKafC9cj39IHbr7wFgbigaPY4ryD7YhH2lK/KOg2Wznikn
         j32oPS7ouTgh151tVk07GZGim2ozbwNb42aIHoUup+rpR62aPlfX+2RO56pbgQpSV+ux
         S+Zs/qNsVahzDmXUj+sojmtGaulGGiZ0fs+TfsitnHJ522alZxUFHQpge+40jQlXt0l5
         VlycpncREnkpYT9lHd9G8voj61+XF/jQYOTDwZGkV+AMXoIDzT+KKddXNjpj6WJIsRjF
         JHWotuNWiprBjnUo5KXYzKiwMl0G60ZjhzHDuwcIyX6bFCzXAWZKKPa7tcBaWyZnhXSo
         a3UA==
X-Gm-Message-State: APjAAAV80FPyv3CcF8rJR9dUQxKpIcLvEpkY2vV6y3rudhAYTb8knnpC
        8ymuSc1F4t81lMLCiNt6KMKSQ0GapEqYOuEsHvjqFsddURkF
X-Google-Smtp-Source: APXvYqzQP9CYRfTlLHLsV6QBEQYBhPgI8bypq0U9hHsKzSMeEB/CVu4ed4IzOfkvt3dGwLP0hHzE142Gz/VsIc1tEwnjoCJ+zd1h
MIME-Version: 1.0
X-Received: by 2002:a02:c4cf:: with SMTP id h15mr12593320jaj.112.1573239180629;
 Fri, 08 Nov 2019 10:53:00 -0800 (PST)
Date:   Fri, 08 Nov 2019 10:53:00 -0800
In-Reply-To: <0000000000005e2bf90570bbe2ab@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000821d620596da4ad0@google.com>
Subject: Re: KASAN: use-after-free Read in ep_scan_ready_list
From:   syzbot <syzbot+78b902c73c69102cb767@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net,
        dominique.martinet@cea.fr, ericvh@gmail.com, jiangyiwen@huwei.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tomasbortoli@gmail.com,
        v9fs-developer@lists.sourceforge.net, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 430ac66eb4c5b5c4eb846b78ebf65747510b30f1
Author: Tomas Bortoli <tomasbortoli@gmail.com>
Date:   Fri Jul 20 09:27:30 2018 +0000

     net/9p/trans_fd.c: fix race-condition by flushing workqueue before the  
kfree()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=167fa19ae00000
start commit:   1e09177a Merge tag 'mips_fixes_4.18_3' of git://git.kernel..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=25856fac4e580aa7
dashboard link: https://syzkaller.appspot.com/bug?extid=78b902c73c69102cb767
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=135660c8400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: net/9p/trans_fd.c: fix race-condition by flushing workqueue  
before the kfree()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
