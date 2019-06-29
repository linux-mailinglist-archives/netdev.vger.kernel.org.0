Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBDA5AD74
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 23:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfF2VLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 17:11:01 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:37256 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfF2VLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 17:11:01 -0400
Received: by mail-io1-f72.google.com with SMTP id j18so10840288ioj.4
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 14:11:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=iI+vf7XGdxN/YYPP07HgU1JapV/In43CoBtMmVlU0zc=;
        b=uYEWrQfn5vFrKz5ej3qtwlcmVnnT6NiEQ8+OcS28xGlXN0HQne4XJ5XnM/VMuKkHqr
         wWxCiMCdDMWslXaW/T6j8SXgDLWywL0Pkn8fjAbmJT84AlIlG9K2JyUr72UILhBbKehd
         IlloVSLOEsxjeihXJyzjHzpeTyB+7wXuXBZ6tXe1B2HT3XF7KnLyOLgoNFLUXDAVTirA
         AszYWWeHqZzsxkGZWoI2cC3XNpTNWT8oGNTYU/2glP3nCyfoOb4Dx5doihmtGy03qHuG
         iUfUyHZU3JQzNKeqmULbO7s1/2LLi3rEvkn4NHaTndv3GBtQW0m7DXzzIy22yu94XLN3
         Pzew==
X-Gm-Message-State: APjAAAWCHCb/RyLOtO/pR3f6hdME9/Fict3PTLsg/2EODB6p3O2bPqmv
        cAZYa5iA/DVhs8h4MeD6OrFRkR6HQMsRL+QGJPooze5LmXOV
X-Google-Smtp-Source: APXvYqxUrjoo3PnWRqtB9E0kVCAY8bEvzzwxgHzzPwfKIzGqVN9E4ibJvNZEVz7+4oUptRKrbedzide4XQN2Mi9uNOkrx1Kx7s+W
MIME-Version: 1.0
X-Received: by 2002:a5d:9ec4:: with SMTP id a4mr14785908ioe.125.1561842660304;
 Sat, 29 Jun 2019 14:11:00 -0700 (PDT)
Date:   Sat, 29 Jun 2019 14:11:00 -0700
In-Reply-To: <000000000000d028b30588fed102@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f66c6e058c7cd4e0@google.com>
Subject: Re: KASAN: use-after-free Write in xfrm_hash_rebuild
From:   syzbot <syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com>
To:     davem@davemloft.net, fw@strlen.de, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 1548bc4e0512700cf757192c106b3a20ab639223
Author: Florian Westphal <fw@strlen.de>
Date:   Fri Jan 4 13:17:02 2019 +0000

     xfrm: policy: delete inexact policies from inexact list on hash rebuild

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1734cba9a00000
start commit:   249155c2 Merge branch 'parisc-5.2-4' of git://git.kernel.o..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14b4cba9a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10b4cba9a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a31528e58cc12e2
dashboard link: https://syzkaller.appspot.com/bug?extid=0165480d4ef07360eeda
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cf37c3a00000

Reported-by: syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com
Fixes: 1548bc4e0512 ("xfrm: policy: delete inexact policies from inexact  
list on hash rebuild")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
