Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEFA194E6A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 02:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgC0B2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 21:28:06 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:40073 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgC0B2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 21:28:06 -0400
Received: by mail-il1-f198.google.com with SMTP id g79so7358829ild.7
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 18:28:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=fpOoO95ghuCLLCEIiKHNf1Vn4Rzo9M55/w0gJcRUpiM=;
        b=Ia3vvDujJk41Hn7+meQw0m9VSzwgMGbYemEfB9sZLas/8Wes0L5En7yzBHb17BMEww
         SFZSfrl6YfiDFZ+LcDIHDkwUqOT0UfvGuN6DjSKMUDraibUe5Df9I3VlZ06o9QcnaX0O
         B8l8G4dExzW9zxR5hVeMnW1b9XBS6i8OiEaQX3p08wDVjrgQb/ml1Z3YOpetaNcSrx3D
         gzCnU4Uurq+obC9FoESZk+hlO2Ymg0vadZUyMCH4xFh1mrQposum2Ib5cgZ8vS/msgqP
         DOYD4GozFvyDPldJp3WI67DledaNo9ucOkq5I4eMtGH/U0cjz4Hc0hrJEFKR8MJeJdGk
         D2OA==
X-Gm-Message-State: ANhLgQ1ov48gTkqx7qwYyQNt56Z7ODhYJPAKriPpkzhmUilcI+K6XZ1z
        WaPlydugCSW796CoOue2qgnMqU0K868ou27wQ1a9XOaJMYaz
X-Google-Smtp-Source: ADFU+vvuj9CdqnaKA39zoipe43VtYnqnycnu6XYDRVQ3pQdtkCj1GJ/YWcoFF34sHC9pd58juZJvz3MqwN724aP7IdgdRuetL7J1
MIME-Version: 1.0
X-Received: by 2002:a92:9107:: with SMTP id t7mr11623063ild.140.1585272483961;
 Thu, 26 Mar 2020 18:28:03 -0700 (PDT)
Date:   Thu, 26 Mar 2020 18:28:03 -0700
In-Reply-To: <00000000000047770d05a1c70ecb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004760b805a1cc03fc@google.com>
Subject: Re: KASAN: null-ptr-deref Write in blk_mq_map_swqueue
From:   syzbot <syzbot+313d95e8a7a49263f88d@syzkaller.appspotmail.com>
To:     a@unstable.cc, axboe@kernel.dk, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, dongli.zhang@oracle.com,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 768134d4f48109b90f4248feecbeeb7d684e410c
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Nov 11 03:30:53 2019 +0000

    io_uring: don't do flush cancel under inflight_lock

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14233ef5e00000
start commit:   1b649e0b Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16233ef5e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12233ef5e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=27392dd2975fd692
dashboard link: https://syzkaller.appspot.com/bug?extid=313d95e8a7a49263f88d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13850447e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119a26f5e00000

Reported-by: syzbot+313d95e8a7a49263f88d@syzkaller.appspotmail.com
Fixes: 768134d4f481 ("io_uring: don't do flush cancel under inflight_lock")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
