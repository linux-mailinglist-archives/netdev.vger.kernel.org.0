Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A54FB57511
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 01:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfFZXzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 19:55:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:50894 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfFZXzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 19:55:01 -0400
Received: by mail-io1-f69.google.com with SMTP id m26so423902ioh.17
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 16:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=c5MKxKpL1LGme09OnNwDQjsqqlS3JWAbrh2sxWujAk8=;
        b=sEKri7Qs8qmtjuHQJwGgnX5iNoWk9oYaxWc7ObwN3gsh0rPEqLERROJUu7UzKNXh9D
         rqYFwjYpNIGbi5EMFWvkG7hynX5QtxsAe3woMMYD6dW9O6kn7J0jB+xakS3GTEQ2K55V
         u5DIu4klkCR1A6bHwCus3pp2W+BFurrKi9d6cJENfsC1P99OUTFP/T6eTujIXKHp+HyV
         /dVYGNCxxVKe4PxSp/Vl7SASlKtd2SD3R7be9OSkYFpDUuXfcCXihCV1vFwnXGngxZHq
         JfSlj4EI/xRV+K9dYX1pUfQFPd40m9TXsCkal62meTH4FGV5BPh4aZhQkQ7IGBXbxnlW
         O2pw==
X-Gm-Message-State: APjAAAWvyIeSyuynw2pgq0jwG6rQxkthUQQZztcedXA2YXU0YgPvi4b7
        f9v3ElTaS48zD5i7pCRK866B18Lbu/u4r/qUXwnX4LMrdpud
X-Google-Smtp-Source: APXvYqw0rSeais3gd71d3pKztVwreFghQwPf0ciLriAei8/ydZP7gcjOnDii1dtoOGd1VNJ94dAGeH2zX3nwhBEDVLqHtbiTYrsV
MIME-Version: 1.0
X-Received: by 2002:a5d:885a:: with SMTP id t26mr1029660ios.218.1561593301141;
 Wed, 26 Jun 2019 16:55:01 -0700 (PDT)
Date:   Wed, 26 Jun 2019 16:55:01 -0700
In-Reply-To: <000000000000f4f847058c387616@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ff8f15058c42c5fa@google.com>
Subject: Re: KASAN: use-after-free Read in corrupted (3)
From:   syzbot <syzbot+8a821b383523654227bf@syzkaller.appspotmail.com>
To:     aarcange@redhat.com, akpm@linux-foundation.org, ast@kernel.org,
        christian@brauner.io, daniel@iogearbox.net, ebiederm@xmission.com,
        elena.reshetova@intel.com, guro@fb.com, john.fastabend@gmail.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        luto@amacapital.net, mhocko@suse.com, mingo@kernel.org,
        namit@vmware.com, netdev@vger.kernel.org, peterz@infradead.org,
        riel@surriel.com, syzkaller-bugs@googlegroups.com, wad@chromium.org
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11bb4e3da00000
start commit:   045df37e Merge branch 'cxgb4-Reference-count-MPS-TCAM-entr..
git tree:       net-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13bb4e3da00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15bb4e3da00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dd16b8dc9d0d210c
dashboard link: https://syzkaller.appspot.com/bug?extid=8a821b383523654227bf
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1389f5b5a00000

Reported-by: syzbot+8a821b383523654227bf@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
