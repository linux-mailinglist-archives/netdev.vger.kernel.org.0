Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B468153C9C
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 02:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbgBFB3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 20:29:04 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:36191 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgBFB3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 20:29:04 -0500
Received: by mail-io1-f69.google.com with SMTP id d13so2883441ioc.3
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 17:29:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=klRVBdr46Gl8WIF/3JqDp9paxXMagfLFmZ3zT/aOfAA=;
        b=K3xn42jj/lEJQam5s0n7t5bssjToXgxoN7F45/bRAekWGCiTW7N6Xg1ouvOntgzk6e
         ZfTlNBsaatIM3GJ/r6X4NWXjAQdkwNz8jXJhSRod4W3dO9aRwWHaJWTNQs9OETBTqunH
         WaDo2AuIPTHrObNLP4Hhi72ts1KXWAwynDwvd2W81BqTyXHhti2sTsPmjEWj1j9VDo0y
         qFUhsyyc8Sn07CWitTVn9RcPYrmM2Fh5HlyANHvrNACqRQjkTMD3H2M0FoGzsfCOQNX+
         rYXR5UprCrAgJTzFKNbHqDCTM+vpHmiq2hvh8+vlW77h4Amuouj+p02qt+igQKxOCwZs
         5MQA==
X-Gm-Message-State: APjAAAV4xHXL/pqq9G+LmdC0WPL1nJKRGGjfCYe3Pswey4F1NVt/M97N
        rMOoMN9xC51E5AV4AbBtn/J+BYrvA0w9cc9AzIwx7PXBGUe8
X-Google-Smtp-Source: APXvYqyWzNDAJ3ZpISUwsx17tVrhy9Z/G8ZUJfNIMmI6YX1SRk5jCpKRGWJGMzRGbI8uNNHSqXoSH+2xK2x4wJjiLsGtYiFdEy2t
MIME-Version: 1.0
X-Received: by 2002:a92:1bd9:: with SMTP id f86mr1114630ill.18.1580952541990;
 Wed, 05 Feb 2020 17:29:01 -0800 (PST)
Date:   Wed, 05 Feb 2020 17:29:01 -0800
In-Reply-To: <000000000000f0baeb059db8b055@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ac1561059dde321a@google.com>
Subject: Re: inconsistent lock state in rxrpc_put_client_connection_id
From:   syzbot <syzbot+d82f3ac8d87e7ccbb2c9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 5273a191dca65a675dc0bcf3909e59c6933e2831
Author: David Howells <dhowells@redhat.com>
Date:   Thu Jan 30 21:50:36 2020 +0000

    rxrpc: Fix NULL pointer deref due to call->conn being cleared on disconnect

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=173d9dbee00000
start commit:   6992ca0d Merge branch 'parisc-5.6-1' of git://git.kernel.o..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14bd9dbee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10bd9dbee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f22d38d7f9a488a8
dashboard link: https://syzkaller.appspot.com/bug?extid=d82f3ac8d87e7ccbb2c9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14317dbee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=145a44f6e00000

Reported-by: syzbot+d82f3ac8d87e7ccbb2c9@syzkaller.appspotmail.com
Fixes: 5273a191dca6 ("rxrpc: Fix NULL pointer deref due to call->conn being cleared on disconnect")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
