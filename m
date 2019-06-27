Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F18B58101
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfF0K6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:58:01 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:41573 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfF0K6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:58:01 -0400
Received: by mail-io1-f71.google.com with SMTP id x17so2168615iog.8
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 03:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Qd5yz8D6nzHy8/WHIsu0XvDmoEeh/tbWUaUPsfPoLfU=;
        b=m7ElU3Cl6LVlg/NKTOICrDdRRXC/c/0O5/SO1VJSxmplVQJsRDduInswEav7cSXyj6
         WHiimd0wi2mZDZRCPtPmS2vHEoKgvFKhc7inU2BBXlS6e8rcH3mg7R0mTzJ7AnKM7UML
         03x7DVXjoBS/R9eLwwdcWEENNCE3PL/WHe3G7C+q5IMT0FlpozJyXpFDDN5hWFYw0Eeo
         luiK9g7vKmcsczc8ILXhSqlBNCwaaiRP7u3N/QOxvrS2xmDSoetAjftLEDWbe5FqBNdL
         IwtH9Kz+yRnwAuCGQ0uw7yRcpU+kV/iuiWblDl+Ib7uDNlkZ6+DbtT/mkuYiTxhQUDmt
         FhSg==
X-Gm-Message-State: APjAAAVsTx3vjB5At51jvKj44J7V51zu8j0Tzi9qFW7VM27Rp77iJ5AC
        d98pnLd2MbF8EYKMcSebdrEp27vvWqKD4n0uxCMZOlmKV/Gi
X-Google-Smtp-Source: APXvYqyFMB8ZqB5Hvwd/r6Qq21rENIAh6D36I89aMJ9OWo9sekU/qTEYVyqcJaSJdsoL2uLgqaaGvev7HQgFP9ZgljJSrVVi095A
MIME-Version: 1.0
X-Received: by 2002:a6b:bec7:: with SMTP id o190mr3664415iof.158.1561633080591;
 Thu, 27 Jun 2019 03:58:00 -0700 (PDT)
Date:   Thu, 27 Jun 2019 03:58:00 -0700
In-Reply-To: <00000000000008f38a058bd500b9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000009ccbc058c4c09bf@google.com>
Subject: Re: BUG: unable to handle kernel paging request in cpuacct_account_field
From:   syzbot <syzbot+a952f743523593b39174@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, fweisbec@gmail.com,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, netdev@vger.kernel.org, peterz@infradead.org,
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13dd1b79a00000
start commit:   abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=103d1b79a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17dd1b79a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e5c77f8090a3b96b
dashboard link: https://syzkaller.appspot.com/bug?extid=a952f743523593b39174
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1372abc6a00000

Reported-by: syzbot+a952f743523593b39174@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
