Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9485F55C08
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbfFYXHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:07:01 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:54302 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFYXHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:07:01 -0400
Received: by mail-io1-f70.google.com with SMTP id n8so214215ioo.21
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5XO6NDSi7o9UCx31IdKa++vNGr4w4sFZNOdIzxhXeB0=;
        b=I8aiGUmKsEDJTO46gMEnlja+c49C7+Q2TLcCoXfE4SAUANXviIILFkIM3t140tmfnj
         cjnk5M9ZwAf+0WLFMsg0/IEEH/noQ4qoEOIeitK0NgQLmlf+rAL+v31a1tZqoX/36Ign
         o+BDE/77/S2/KTCE/yDsC7VL66mZzD/7suM0S4l30NYA9M/Lk9fx2eLY9cpAF1pM188O
         kunPVxaoEQmoa7YFJAt+rScPGrXhUG0CuGR6hGfKfJLS9stW9jeQuvF4PNPavd4Twu5L
         yPzoDaox/BdFgq89Gn0Ggob9h3XxDTyliXbTa4S4AD2Ylo1HcRaEUK6VxUYColqacMiN
         qHVw==
X-Gm-Message-State: APjAAAUWHTTbFOf4yITXwo4e8c05pCDMVRodul0E5KhLRWmlKbnoYW/I
        yQogCvQ5YyDBYibvKA+sbppVxLAKYCc63qJUp7H2KlUv4/GK
X-Google-Smtp-Source: APXvYqxg7Q43zU7eDdjWCJJjMc20VKLoF6D1yLiqI3SKjTQAMQ214QUyVPvfOOK+luu/cmFimcz2QkEtvpAEzFW2H5AaIqwEW1Z8
MIME-Version: 1.0
X-Received: by 2002:a5e:c00a:: with SMTP id u10mr1423993iol.24.1561504020634;
 Tue, 25 Jun 2019 16:07:00 -0700 (PDT)
Date:   Tue, 25 Jun 2019 16:07:00 -0700
In-Reply-To: <000000000000e672c6058bd7ee45@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007724d6058c2dfc24@google.com>
Subject: Re: KASAN: slab-out-of-bounds Write in validate_chain
From:   syzbot <syzbot+8893700724999566d6a9@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, ast@kernel.org, cai@lca.pw,
        crecklin@redhat.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14a4e9b5a00000
start commit:   abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16a4e9b5a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12a4e9b5a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28ec3437a5394ee0
dashboard link: https://syzkaller.appspot.com/bug?extid=8893700724999566d6a9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167098b2a00000

Reported-by: syzbot+8893700724999566d6a9@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
