Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C0C3831E
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 05:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfFGDZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 23:25:01 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:38683 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFGDZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 23:25:01 -0400
Received: by mail-io1-f69.google.com with SMTP id h4so608755iol.5
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 20:25:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=e6etfNurQQo9Va6VpYHCA2sien54nXIZ+EIMOWfPhpg=;
        b=dzKNnw4guZIfm/m5g3R3EbqkOP4rHQ2A0o7hU7qvTiZnEYdERCsTMCt4FpkCk6FISj
         pQ/JsYicMPi+vbGHtm7212t6qc8/pGm79jJb1ryyh62KOy2Cx8wg/3uS/oIsG7rNLyFf
         baH/Aav5LhN2tGJqoBo/ColfV5gzdnvn+2P9ZAhyRvejrNiVvMJyg5HMKSEBgqlGySie
         rzG1qXXlUAkvHHEWjhyIgbw8pCyfbqQE4kOKmcUX+HqEAES5j6Pvko+1fx8h1CWFQgEz
         N1fiiQFdEMXXLIIhcodh1BC7Iwnnq1m/7XpbZMKO5gUWHyKovbq1t2bYjQDU7d9XuRGL
         oYdA==
X-Gm-Message-State: APjAAAWVDMeD697+FQHe0SOoAwg9XVRkZwyOwWxdAbRa39Ae+Xebux/f
        pJqXGzIFwo+2sKE2c3gKNx6DYblJKNhwdRdViLq/A/w4x5xf
X-Google-Smtp-Source: APXvYqye5xa1Ca/EaWr+y6R3z3/VH0PShIIRB83YYxYRr5VL2+2o8N9WKQzv8UUonOlR9ZG4NAHpnj7r5bzEM/0sAQVJZSzGAe01
MIME-Version: 1.0
X-Received: by 2002:a24:f807:: with SMTP id a7mr2825641ith.166.1559877900241;
 Thu, 06 Jun 2019 20:25:00 -0700 (PDT)
Date:   Thu, 06 Jun 2019 20:25:00 -0700
In-Reply-To: <0000000000006b30f30587a5b569@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002314b3058ab3605c@google.com>
Subject: Re: general protection fault in ip6_dst_lookup_tail (2)
From:   syzbot <syzbot+58d8f704b86e4e3fb4d3@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, dsahern@gmail.com, dvyukov@google.com,
        edumazet@google.com, kafai@fb.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit f40b6ae2b612446dc970d7b51eeec47bd1619f82
Author: David Ahern <dsahern@gmail.com>
Date:   Thu May 23 03:27:55 2019 +0000

     ipv6: Move pcpu cached routes to fib6_nh

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13c969a6a00000
start commit:   07c3bbdb samples: bpf: print a warning about headers_install
git tree:       bpf-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=102969a6a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17c969a6a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7b54c66298f8420
dashboard link: https://syzkaller.appspot.com/bug?extid=58d8f704b86e4e3fb4d3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117f50e1a00000

Reported-by: syzbot+58d8f704b86e4e3fb4d3@syzkaller.appspotmail.com
Fixes: f40b6ae2b612 ("ipv6: Move pcpu cached routes to fib6_nh")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
