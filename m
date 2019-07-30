Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5DF67A1A6
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 09:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbfG3HNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 03:13:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:45201 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfG3HNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 03:13:01 -0400
Received: by mail-io1-f69.google.com with SMTP id e20so69977825ioe.12
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 00:13:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5NJsWs5rO4lIuS0ZgiXWXMUnUDOFAKxFplPhTBI+bqM=;
        b=N07hk9zQYHFdTr+kUkQgX7vvAobTV878grBu5gY9/wkKVli3cRKvBd7hw5xjjJ5+va
         rABQZmEEoV58KVkvdlseZQeQpAzoexzlgMhbMGj6ZV02GZgQn/Mq40zJDGhG5XpBc8hG
         srv0C80qzw15d5C38eYBbTMy6FSbzc+CInUdqGH9EFRFvFSIbLUqD7+hft0ZF5qk9zks
         uj1VieQf6WylOOS+ozwH8tZfXECUxysOFxZgZoDC1ssUOqkSwzOmj8zkZUQ6HpK7wNeq
         sgIRaryPpUiLe4gAtVikyMsxAqiYtGsN5wwFVd9iL+ITrkHdn1rYk2X78CpHO4CytoqM
         lfxg==
X-Gm-Message-State: APjAAAV9wKtyRHXdOrNqRWh3MAYE5MiDFk45Rx05iGQIYx76nVWDObos
        62GNQ2IpPWgg+8tvpB3RxMhA6Y5p96S/Pqj8PGOAn3xzCIfe
X-Google-Smtp-Source: APXvYqw5SXLkTuBMD92g5AbsXWj+a5igK5Vc68j3TXyjLS+D+UvsTA9bxtT6u0WCZTYI0I29O9xwwLMF8YW79WjQUXBUs5hDeJu+
MIME-Version: 1.0
X-Received: by 2002:a05:6638:201:: with SMTP id e1mr36980524jaq.45.1564470780934;
 Tue, 30 Jul 2019 00:13:00 -0700 (PDT)
Date:   Tue, 30 Jul 2019 00:13:00 -0700
In-Reply-To: <000000000000df9d48058e9228cd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000028c26d058ee0bd1a@google.com>
Subject: Re: KASAN: use-after-free Read in psi_task_change
From:   syzbot <syzbot+f17ba6f9b8d9cc0498d0@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10f4840c600000
start commit:   bed38c3e Merge tag 'powerpc-5.3-2' of git://git.kernel.org..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12f4840c600000
console output: https://syzkaller.appspot.com/x/log.txt?x=14f4840c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9aec8cb13b5f7389
dashboard link: https://syzkaller.appspot.com/bug?extid=f17ba6f9b8d9cc0498d0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10dc7b34600000

Reported-by: syzbot+f17ba6f9b8d9cc0498d0@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
