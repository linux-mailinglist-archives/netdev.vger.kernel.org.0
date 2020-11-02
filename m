Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6A22A2520
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 08:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgKBHXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 02:23:08 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:55017 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgKBHXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 02:23:07 -0500
Received: by mail-il1-f198.google.com with SMTP id u129so4229530ilc.21
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 23:23:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=2UyDQv8E1XspZMV78KNBT26cn2GGMd5ig6Tf1UtogOA=;
        b=ghz8GZFf5bt4k/LsLuFNlIkdy6CE1G8MX7r7JH3b8MIEEGT30Xlp2IUruyRfE/re+B
         ZZBk3/Xbg7MTiUuoEleWfhn2HviEj8fiytBlpTo1m+x2XWTZxbUwZ/34y3kqzfT/DlaU
         bF+np/f/XTZN0SWLqenCUQWohXSt5qc2LZQFDK7TAMDST12RHzkjXpFje1x6sip0Rjz3
         1kJ7a8swiZ9QqXzOOEkkL4QWfVx8TnAJrooELY/F6/f1dOaMq1JGanUvvjf75MUqcM6v
         mZetgb0yAzvjlScYvYfRzufrr5Ps5+iWjuRgdM+7NHiIKVB5AAlx4CqlJsHx8fWGS8D3
         fQpQ==
X-Gm-Message-State: AOAM533rEjnm9kiu4SJfp2izMLzB6n4sVradSgeu/UDM4wHc9q9tYd2o
        EdyH/DGlUrVYi8neSpMsb/SzRPvpZVPBmOH+hDYQbO5kfefB
X-Google-Smtp-Source: ABdhPJzoH6khlFDroSU93HRb6B6g52wrE97mFnt2Q9goMzm28lI51hfnapLFiKFwAngMuOSXVqXOIRpT7cO7j9OBDoweJQcqSYxf
MIME-Version: 1.0
X-Received: by 2002:a6b:e613:: with SMTP id g19mr9732302ioh.17.1604301787015;
 Sun, 01 Nov 2020 23:23:07 -0800 (PST)
Date:   Sun, 01 Nov 2020 23:23:07 -0800
In-Reply-To: <000000000000f1a42205b2528067@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000020b31905b31a9edc@google.com>
Subject: Re: KASAN: slab-out-of-bounds Write in xfrm_attr_cpy32
From:   syzbot <syzbot+c43831072e7df506a646@syzkaller.appspotmail.com>
To:     0x7f454c46@gmail.com, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        dima@arista.com, hdanton@sina.com, herbert@gondor.apana.org.au,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, songliubraving@fb.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 5106f4a8acff480e244300bc5097c0ad7048c3a2
Author: Dmitry Safonov <dima@arista.com>
Date:   Mon Sep 21 14:36:55 2020 +0000

    xfrm/compat: Add 32=>64-bit messages translator

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16cefa8a500000
start commit:   3cea11cd Linux 5.10-rc2
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15cefa8a500000
console output: https://syzkaller.appspot.com/x/log.txt?x=11cefa8a500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61033507391c77ff
dashboard link: https://syzkaller.appspot.com/bug?extid=c43831072e7df506a646
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1388676c500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=158f642c500000

Reported-by: syzbot+c43831072e7df506a646@syzkaller.appspotmail.com
Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
