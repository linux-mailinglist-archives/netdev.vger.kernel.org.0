Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65DB108574
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 00:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfKXXFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 18:05:02 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:49460 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfKXXFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 18:05:02 -0500
Received: by mail-il1-f199.google.com with SMTP id c2so12184484ilj.16
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 15:05:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=9mvzd7fUp8HPwHRxMhxwkoAC5BApeXYD4JfBSm6Tu7E=;
        b=FZUI8Su/R3wUEO8A174kNcyHZ/Nwzmy/WrjB3cUWEEIPleVe+PuqjHABTVjh7Wb5aW
         PACoPUG5rvlRUmSYYI+4kRdVXJD69EuhC+9vuyzY1kjuZqdBNGLpCprQ1Qgt2Us/fquV
         U6ECJtIg/KJzzk07x6Ce44/PxIRjzGGiOZO1/k+/zlZ1syQ+Pd0UiYkbZxb+6HD4q72R
         PYvaxIpBqGbXWIapsYscxrQ2k17goW/8Zgt8mQMeZ9SQjHlFVK1Km2Phu5Y1dfuo0/xp
         E7q903CwJ/q3qNFK26pcCff72UCv2p2ORUex1s54XaCy0HdgTZlSag5Mkdh5NR1KJ6rV
         zIkw==
X-Gm-Message-State: APjAAAUM/Qp7HXm6AvY8/PZGlja5ws8k/6/CzMQLt0hwXBDWpZHOit1i
        Kr7I1YF7mErBF4+sgxk6YESWZHtQSJI6RbzuMo6V7pnk5BO8
X-Google-Smtp-Source: APXvYqxYdNfz5GYWLNzmDfSQ+/s3z/yI52/HmVxwGcXxgu/73KYY+2OwEOZgsW534ki9gWV9TGl9Da+9VLUkYzNmNkZJKEOy5QEO
MIME-Version: 1.0
X-Received: by 2002:a92:45cb:: with SMTP id z72mr16071673ilj.101.1574636701349;
 Sun, 24 Nov 2019 15:05:01 -0800 (PST)
Date:   Sun, 24 Nov 2019 15:05:01 -0800
In-Reply-To: <0000000000002b532a056ebcb3eb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003c0b2105981fad65@google.com>
Subject: Re: WARNING: suspicious RCU usage in pid_task
From:   syzbot <syzbot+c2d4c3ae3fd90bbaf059@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, ast@kernel.org, davem@davemloft.net,
        dhowells@redhat.com, dsahern@gmail.com, dvyukov@google.com,
        ebiederm@xmission.com, gs051095@gmail.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oleg@redhat.com, pasha.tatashin@oracle.com, riel@redhat.com,
        rppt@linux.vnet.ibm.com, syzkaller-bugs@googlegroups.com,
        wangkefeng.wang@huawei.com, weiyongjun1@huawei.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 23fb93a4d3f118a900790066d03368a296dce0d6
Author: David Ahern <dsahern@gmail.com>
Date:   Wed Apr 18 00:33:23 2018 +0000

     net/ipv6: Cleanup exception and cache route handling

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1295147ae00000
start commit:   6f0d349d Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1195147ae00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1695147ae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a63be0c83e84d370
dashboard link: https://syzkaller.appspot.com/bug?extid=c2d4c3ae3fd90bbaf059
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f0a814400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ce574c400000

Reported-by: syzbot+c2d4c3ae3fd90bbaf059@syzkaller.appspotmail.com
Fixes: 23fb93a4d3f1 ("net/ipv6: Cleanup exception and cache route handling")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
