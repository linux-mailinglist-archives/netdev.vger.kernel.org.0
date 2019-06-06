Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0C336FB5
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfFFJVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:21:02 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54807 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727664AbfFFJVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:21:01 -0400
Received: by mail-io1-f72.google.com with SMTP id n8so1111720ioo.21
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 02:21:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=56G2RzBG0guHoTpwxKynlW+PNBbvgl4GPrCoRWxxM0U=;
        b=m0RFh3wQ1/IfkIcfuHgREQVo5/G25T6jFHpZp6YR7TSPoJsT/yqbsQFWYvZRq6lACa
         aVZwe3JYK6i701jG2KNS/lxP/hADA3n52qDt6448hGa1OuICYvT/+VPdMqqcMfrhhF5x
         ssAOwkb4sRsaE/8/rKAvbRH/a6FcJopvbUyOxjlBoOUaL5modPuBx46XWgoJwYESx7z5
         +V1ijQyVWYo4W48cbIq1vuexjIWrvybnFVK6R9IKQbO7G6o5yCUH9Lq9jIdeqYEjxDOK
         j3+P6Fz2KgTln5HGG4Do1FDNlI1uubAPRedipbLeKQjsdI94l2/oA8OvOpwLqDz5NW/W
         S+yA==
X-Gm-Message-State: APjAAAVmNZb95PVPfC5v1Q5ZPpHNznzu3hkZGpimL2M0WN+aojGbcY6W
        HB3JiR3NP4DXn7oI7GMdAnbESpgU5RmXjBMHAjyoHmRzDopH
X-Google-Smtp-Source: APXvYqxIJibzbNxy8GOtzypAF+Oyb4w4yoUX0G2vgElVjB5zG1mUDMCfNHgGUYHjHFguEhuY8+0K3Y3HNEzzqU8WyYf5rcCq0vxQ
MIME-Version: 1.0
X-Received: by 2002:a24:9f86:: with SMTP id c128mr22407371ite.161.1559812861164;
 Thu, 06 Jun 2019 02:21:01 -0700 (PDT)
Date:   Thu, 06 Jun 2019 02:21:01 -0700
In-Reply-To: <0000000000008ab3c0057e8b747f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008181cc058aa43b82@google.com>
Subject: Re: general protection fault in rb_erase (2)
From:   syzbot <syzbot+e8c40862180d8949d624@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1644ea92a00000
start commit:   156c0591 Merge tag 'linux-kselftest-5.2-rc4' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1544ea92a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1144ea92a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=60564cb52ab29d5b
dashboard link: https://syzkaller.appspot.com/bug?extid=e8c40862180d8949d624
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f031fea00000

Reported-by: syzbot+e8c40862180d8949d624@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
