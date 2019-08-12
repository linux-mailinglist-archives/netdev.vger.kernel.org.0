Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBFE38AA6E
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 00:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfHLWcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 18:32:01 -0400
Received: from mail-ot1-f72.google.com ([209.85.210.72]:34770 "EHLO
        mail-ot1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfHLWcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 18:32:01 -0400
Received: by mail-ot1-f72.google.com with SMTP id a26so13191529otl.1
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 15:32:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=64I6Vg7GG8+qFEb4faWzZMot279mVpkPc+JNG+pcnJo=;
        b=Z1ESqZnyw4RdKbRdwC1a2AOPBgRh4jUTWxj3ZvJLYR+XqpXbO1OgwUHjDg6lExBPS3
         X4YjJRGGJ+Kkv+rq9oA4pJSa8WxR8R+tCWP1ZfbszBV8e2VTL++imBpyJmyGLfdSBKLv
         Hjp0ZfPMkvrWRPR2kKD5OqHypEcsftdAVr6oCO4aJv6YQKbwYi4u0gDHgp3ZDE7cMDoA
         Hy4GhwotebKc0ng/RlvG7HYmJT7uja7FMVWKH4m/Pc7YWDtGF0AT+zENScofoaL3Ud1A
         Zk/p37zaYh2yUEOK/jGMn3jgXuhYIW5tbWjCT70vCgoZEARxqt/vHrZUdJspmCL0dTnD
         +VHg==
X-Gm-Message-State: APjAAAXVmedqvRkDnoTdKaXAwdd3kv3M5nLtLxkacy6Qq8ZW1LSbySbX
        hCKp/sq/COBYOrOx39gzFBKJi6y3kDmc11GffzV8zM42px5R
X-Google-Smtp-Source: APXvYqxooASJlXu0RjqkCDVSMGmPqhOI1O1zfvCN3iXdvSrbaT+4RNgiVLCziOWr2XABL3qA2ywAcxce+Zmu66HFfJhZMK10foWY
MIME-Version: 1.0
X-Received: by 2002:a5e:924d:: with SMTP id z13mr1743448iop.247.1565649120561;
 Mon, 12 Aug 2019 15:32:00 -0700 (PDT)
Date:   Mon, 12 Aug 2019 15:32:00 -0700
In-Reply-To: <000000000000492086058fad2979@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ac9048058ff3176e@google.com>
Subject: Re: BUG: corrupted list in rxrpc_local_processor
From:   syzbot <syzbot+193e29e9387ea5837f1d@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, davem@davemloft.net, dhowells@redhat.com,
        dirk.vandermerwe@netronome.com, edumazet@google.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        john.hurley@netronome.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 427545b3046326cd7b4dbbd7869f08737df2ad2b
Author: Jakub Kicinski <jakub.kicinski@netronome.com>
Date:   Tue Jul 9 02:53:12 2019 +0000

     nfp: tls: count TSO segments separately for the TLS offload

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11d04eee600000
start commit:   125b7e09 net: tc35815: Explicitly check NET_IP_ALIGN is no..
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13d04eee600000
console output: https://syzkaller.appspot.com/x/log.txt?x=15d04eee600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
dashboard link: https://syzkaller.appspot.com/bug?extid=193e29e9387ea5837f1d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159d4eba600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ba194a600000

Reported-by: syzbot+193e29e9387ea5837f1d@syzkaller.appspotmail.com
Fixes: 427545b30463 ("nfp: tls: count TSO segments separately for the TLS  
offload")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
