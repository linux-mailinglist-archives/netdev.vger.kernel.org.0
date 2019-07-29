Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5F8782DA
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 02:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfG2AiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 20:38:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:34301 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfG2AiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 20:38:01 -0400
Received: by mail-io1-f69.google.com with SMTP id u84so65936482iod.1
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 17:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=P/bfC/9DYsjpqYrAz/GLNeevsKIsGM5ry8dJO/L9Ihk=;
        b=eeDv5r8aFUxR7BAnjfVs8KMIqbcyo8ja6AX1PqCwO1jVbkgnLxOI8jQU8i5tsS1+/N
         km86yDd9b+N1SmLrUTP83gsC9DV/lhIGRJuOiG5/vPo1NbK+Go98vpm2oh4Iuk3bc4/e
         wREF6g3C+Ry5NmbbqQQZGD7eutmA8j3Dl1yg1eJbg3yRu8lZVHDjo/ZMiYMHUZy1e4Mg
         IHomWFhtXiHmRqcIhki5xOIw0qesYeVZSzHhs9Sn4orU8pUuERjFyDhfDzGPkplHIOel
         k153tpdRaf/YtwqePMshwsiK5XS/K5vdssNKgG/NY5tx2lH20XMKBQKeZ8Wg+nU4DblA
         apCQ==
X-Gm-Message-State: APjAAAUFS28uj3qRnLVihP+yENuUPvhIvS0/5c5JPX8UfEsDc9frieSB
        tkqNiDBVBsgkMVUOyGfykPg8OycsORuixDJrdaHY59Om0jAD
X-Google-Smtp-Source: APXvYqwVilF5qTRSsaLkhL6POlQdbplmHCUtbsaCjcw6sv9rHxSg5wY2IEL+f/ULWS/npxF51AhFcSpVnuGNfy6+mXTXpQgpNXm3
MIME-Version: 1.0
X-Received: by 2002:a05:6638:40c:: with SMTP id q12mr81494815jap.17.1564360680847;
 Sun, 28 Jul 2019 17:38:00 -0700 (PDT)
Date:   Sun, 28 Jul 2019 17:38:00 -0700
In-Reply-To: <000000000000c75fb7058ba0c0e4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aec4ec058ec71a3d@google.com>
Subject: Re: memory leak in bio_copy_user_iov
From:   syzbot <syzbot+03e5c8ebd22cc6c3a8cb@syzkaller.appspotmail.com>
To:     agk@redhat.com, axboe@kernel.dk, coreteam@netfilter.org,
        davem@davemloft.net, dm-devel@redhat.com, hdanton@sina.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        shli@kernel.org, snitzer@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 664820265d70a759dceca87b6eb200cd2b93cda8
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Thu Feb 18 20:44:39 2016 +0000

     dm: do not return target from dm_get_live_table_for_ioctl()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13f4eb64600000
start commit:   0011572c Merge branch 'for-5.2-fixes' of git://git.kernel...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=100ceb64600000
console output: https://syzkaller.appspot.com/x/log.txt?x=17f4eb64600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb38d33cd06d8d48
dashboard link: https://syzkaller.appspot.com/bug?extid=03e5c8ebd22cc6c3a8cb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13244221a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117b2432a00000

Reported-by: syzbot+03e5c8ebd22cc6c3a8cb@syzkaller.appspotmail.com
Fixes: 664820265d70 ("dm: do not return target from  
dm_get_live_table_for_ioctl()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
