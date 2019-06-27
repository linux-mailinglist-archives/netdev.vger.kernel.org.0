Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0387857B47
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 07:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfF0FYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 01:24:01 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:43053 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfF0FYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 01:24:01 -0400
Received: by mail-io1-f69.google.com with SMTP id y5so1276228ioj.10
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 22:24:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=KTLmlahqBmrHOIj7RbeMjFFVBD1WODkDi1wf0mxjsj4=;
        b=gVrja3ZvX2xLkqpNxPruzBdU29QqT4hh8viPNtQKldHEIk1sU1hPB3Mb3ToUlI648p
         R40YXKFGNsCmD5uzonDCadJ5V8/rwWaEj2Mz55DlIARORX5X6fiE16tny+aXWKaIpwNA
         BsP6+kD+SLxHPEqT4qi1s0iADFQxGxGeT2VBVabn4jyRYbZaP4Kfw4+OvuKxRu5ZNIiT
         CRT+iUNEqdRBpUsAEwVUeEmqiQuGMSNXcd/jKb3pdVM1n7XR3pMc3NHzqvEK9vS8wDl0
         C4q/VmNFsLTfGQbtEgpQwVavu1ZJ334+ucdrzDrFTo69CEu/JrpIa8fdYYNyovRYjovW
         OfcA==
X-Gm-Message-State: APjAAAUuaps7+eieTJjSKq/hn2C35XHlIj/14MkMGecDHyEfMxgx6zqG
        SVyLcLz6mRZPBaJHN7eKD0IvezWi8CpQUCa3t4vXTqRoA9Ac
X-Google-Smtp-Source: APXvYqwLxdaO1aqZn3NAO+28gDuNAkuDRNZ+nL2ivt8eHB6WZ7wyMTxoDYSySR2w00lCL6SEaEgSn6JyDAFAnddEBIqaHiFZN5Vh
MIME-Version: 1.0
X-Received: by 2002:a02:7121:: with SMTP id n33mr2217019jac.19.1561613040861;
 Wed, 26 Jun 2019 22:24:00 -0700 (PDT)
Date:   Wed, 26 Jun 2019 22:24:00 -0700
In-Reply-To: <000000000000d7bcbb058c3758a1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000093c88d058c475e46@google.com>
Subject: Re: BUG: unable to handle kernel paging request in tls_prots
From:   syzbot <syzbot+4207c7f3a443366d8aa2@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, john.fastabend@gmail.com,
        kafai@fb.com, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=148e8665a00000
start commit:   904d88d7 qmi_wwan: Fix out-of-bounds read
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=168e8665a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=128e8665a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=137ec2016ea3870d
dashboard link: https://syzkaller.appspot.com/bug?extid=4207c7f3a443366d8aa2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15576c71a00000

Reported-by: syzbot+4207c7f3a443366d8aa2@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
