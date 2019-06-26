Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF7F5662C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfFZKEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:04:02 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:42984 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZKEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:04:01 -0400
Received: by mail-io1-f70.google.com with SMTP id f22so1968220ioj.9
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 03:04:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=exl153K25/taUt9Rsw73TloMA0hiX8bAhHaTEHW6ZTA=;
        b=mRdr1sYW+3Vnlr4aEaloi4HCMPMdqb06h5OHRTDKximFlHTkX7GfNxmp98Kz+Uqrx+
         Ns+C4Y84cIRDb6cqYuwiToPMueRN+27Nf5FUJWBCMzluCaQHMcNX4sm9qupxrkk9hWOJ
         K1ZWTlL7rJuYGdsAugpySpaLSEPnHMk97Jsd4cxk4k2xxDb0na77MTNVogrhxKI7Dnp5
         tNXBfWec5Rx1PMKgHCfZyGUNe9jKw6iguxu0pQGUFjhfiwz/PX+1UYVlCC9ES0OLTk+P
         2txt6qdJzpObKn3lhgDj3ocvlij1B6sq9YV9p1w069qeJWRlIyi3+iDXWDEwrm8J3TSw
         eF5A==
X-Gm-Message-State: APjAAAWxEzn8rXVJhiWii4kgzaz3hc2DHjeihL+Brryf/gZJ2LOeWqlQ
        DbOCo01NiEcNX7hjEbQFaMl2uRq7ILvUopfaETnqAVyZo6jC
X-Google-Smtp-Source: APXvYqwjUE5ldaZ0lVaY4C4RiUyQfnHzMpnYbDfKVDsrYcE6TyIzmVuSJ2rh9klHqtLrh4mmTHyypSXUrkxrJ2dOclLlmSpALX3c
MIME-Version: 1.0
X-Received: by 2002:a6b:bf01:: with SMTP id p1mr3795081iof.181.1561543441017;
 Wed, 26 Jun 2019 03:04:01 -0700 (PDT)
Date:   Wed, 26 Jun 2019 03:04:01 -0700
In-Reply-To: <0000000000000c4e3e058bd5008d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001a739d058c372a77@google.com>
Subject: Re: KASAN: use-after-free Write in validate_chain
From:   syzbot <syzbot+55c548ad445cef6063ab@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1555b795a00000
start commit:   abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1755b795a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1355b795a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28ec3437a5394ee0
dashboard link: https://syzkaller.appspot.com/bug?extid=55c548ad445cef6063ab
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=128ce13aa00000

Reported-by: syzbot+55c548ad445cef6063ab@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
