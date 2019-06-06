Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D49937736
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbfFFOzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:55:01 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:51778 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728974AbfFFOzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 10:55:01 -0400
Received: by mail-it1-f198.google.com with SMTP id w80so173503itc.1
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 07:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=R8TcDtdRwn0wi82EAl1Zo57LJuPK69T+qkxhIovalQk=;
        b=AXl2d9gDIJKCtyl1BXI8pUjsbYdVDYU/RWGb4I4LENg703f95+T/Oicl2sL9ko75LM
         iE6gXtQxCglxmPM7OqYitFX4QelcoS5ZnwLoJ8JIPlKlp8rAI9qur8+sXLi0A21UEN9n
         t/ZTe59+xSd0BbHgAs2sxLbkB7/T8Egm6wIWLad2K8WLtCtXDpfNBum5g4dcCfO4WIEk
         1Iq5mxDHUL8IHdkDE0MUdOPYfZUZfEm9cVComRtB45Q9FhfjVCu4MWyziuSNG1HQU5os
         qtTeBVfsDsgF9xHZNw6r74tQ/0qs1wg0FVUeilPH2J1oQzFNgLCOazxN4YQstHzXoxXY
         N1ig==
X-Gm-Message-State: APjAAAVlNsZFfXkAA9jtjOYgAyktpRA00uxlr692goZmRGFmh035okBx
        nlG8+KuPLdvX7azyZ7DsfFx0IDNQ2/MPXC8mEuxseoP0Gu2b
X-Google-Smtp-Source: APXvYqx6hNO688f1nGb9aDJ5teyR9hvYnxbn79yt4+3zppAhrpmNEdwnM+sH6zml00TrbrVYYjMr1hhagZN6LsUkZFoxkm5OAoeB
MIME-Version: 1.0
X-Received: by 2002:a6b:7a42:: with SMTP id k2mr21307120iop.214.1559832900696;
 Thu, 06 Jun 2019 07:55:00 -0700 (PDT)
Date:   Thu, 06 Jun 2019 07:55:00 -0700
In-Reply-To: <000000000000454279058aa80535@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f48306058aa8e5cb@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in usage_accumulate
From:   syzbot <syzbot+b0d730107e2ca6cb952f@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        dvyukov@google.com, john.fastabend@gmail.com,
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=111ccbbaa00000
start commit:   156c0591 Merge tag 'linux-kselftest-5.2-rc4' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=131ccbbaa00000
console output: https://syzkaller.appspot.com/x/log.txt?x=151ccbbaa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=60564cb52ab29d5b
dashboard link: https://syzkaller.appspot.com/bug?extid=b0d730107e2ca6cb952f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a8fb61a00000

Reported-by: syzbot+b0d730107e2ca6cb952f@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
