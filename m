Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B3F3A21F
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 23:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfFHVRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 17:17:01 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199]:42624 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbfFHVRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 17:17:01 -0400
Received: by mail-it1-f199.google.com with SMTP id k14so1095658ita.7
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 14:17:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=pUXnTCGmDRM9Fiu3UMhwQKrlTPjkftTdr4gBjp4i6Ps=;
        b=p7TGNoQhFVTUlM3+LeXrsbE+N5Hx2X5fR5NjbZqz6QJSWh1bO+f1u60t5d7Sfqs8lB
         h1+XB4NAKVld26zTjvcjFNITBIqnNiZjO3aJhTs2mrqnbMZs40tJ+J0lTWb4TS01xnCC
         qOXXRjUEtuF8Yrm15TXIAa0zyWXXBGiEQMTia7kv6HP39c134EZe8lgUlzAhdGr/fI/z
         y8f/hHpFHi11Kkl8WXPXWc+2a+pUUS/SbPRhE7FBKhEjilOJpcDDeuZKDWE7LjRZpM9o
         7gqmJwl0QegOtqVcVDSp3oQBQuiipaKYgfoHm4BTgCveZovPmS+xXM7SEHf/eW8or++f
         AjNQ==
X-Gm-Message-State: APjAAAXcDva3K6J4ckqFIALCbrAjO1gvklEZzQ2mY5wx9qAriNI7UXWj
        FhBHwb+mZ/zqyy0i70PRxm2gV6OOzdGFx4l5qhAHl/0H2pr4
X-Google-Smtp-Source: APXvYqyc2nXveQl5DBuQDOiIyH/k1sTlPNyXQsmCmi+humPK9XlBkbhTw6PRCCBbfDhnuV5GcSPLM1WROKpXmdcxP8xM3qragnxh
MIME-Version: 1.0
X-Received: by 2002:a24:2b8f:: with SMTP id h137mr8306276ita.162.1560028620312;
 Sat, 08 Jun 2019 14:17:00 -0700 (PDT)
Date:   Sat, 08 Jun 2019 14:17:00 -0700
In-Reply-To: <000000000000a802e6058ad4bc53@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c0d84e058ad677aa@google.com>
Subject: Re: general protection fault in mm_update_next_owner
From:   syzbot <syzbot+f625baafb9a1c4bfc3f6@syzkaller.appspotmail.com>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        andrea.parri@amarulasolutions.com, ast@kernel.org,
        avagin@gmail.com, daniel@iogearbox.net, dbueso@suse.de,
        ebiederm@xmission.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oleg@redhat.com, prsood@codeaurora.org,
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e978e1a00000
start commit:   38e406f6 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17e978e1a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13e978e1a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=60564cb52ab29d5b
dashboard link: https://syzkaller.appspot.com/bug?extid=f625baafb9a1c4bfc3f6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1193d81ea00000

Reported-by: syzbot+f625baafb9a1c4bfc3f6@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
