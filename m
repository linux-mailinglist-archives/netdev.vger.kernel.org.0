Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237565BB4D
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfGAMOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:14:01 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:40885 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbfGAMOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:14:01 -0400
Received: by mail-io1-f72.google.com with SMTP id v11so14934600iop.7
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 05:14:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=NWf6zAXmXdVI9wmyrTa+FuCFWEZ41w0HLTqj15sQqqk=;
        b=UEz4I2gYG508RNzXLG3n56o26rQQXq2pSHPt4BAO5JhyAwmjg3Xs166caqZ/eY/NF5
         YJSYq8+s6lG4B9aasAG3gFFe1UmrnzVmXpip8j3Om62KekXzPf/q7xEW6YI38Kgy4pW4
         rsz6ZjDsdFG1FKkgZ52LrXy6+FRAAQ9F0EP2HWeqKrI1AQVgPmBDfgyVaSNcktj7XbH+
         6GVdPiEtYM4nuH1HlJAGXaxJwwbaNNpozRms5JTxyQvfEfRxbrAR+i8ASxCClsxlHX2z
         /z5TzjPRgs83ytktLiFHJsgiTTy18iraZR8UiTOgmczQXcq2vWG5qg06qkjipI4f1aEg
         UiKw==
X-Gm-Message-State: APjAAAWXjnUG5lQHptKuymEavOJ9ToxoSBB2WedY1f2Y7fgl192B6hwe
        zMtaLZZ1Gj8FRUPGNkkb+R4V5XEP6FKislgiSDY9nqukYr04
X-Google-Smtp-Source: APXvYqymMtF4Sb3QSuurBcHYsH3E8Req+IEh12sC9+1vRDayQ+vOG5A9GROOa0/UnLqUgLp/5wtZGfRSO49p8UhKW1mNXVSK9KiL
MIME-Version: 1.0
X-Received: by 2002:a5d:8497:: with SMTP id t23mr25182314iom.298.1561983240729;
 Mon, 01 Jul 2019 05:14:00 -0700 (PDT)
Date:   Mon, 01 Jul 2019 05:14:00 -0700
In-Reply-To: <000000000000a5d3cb058c9a64f0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000357fba058c9d906d@google.com>
Subject: Re: kernel panic: corrupted stack end in dput
From:   syzbot <syzbot+d88a977731a9888db7ba@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17f7f4d5a00000
start commit:   7b75e49d net: dsa: mv88e6xxx: wait after reset deactivation
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=140ff4d5a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=100ff4d5a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7c31a94f66cc0aa
dashboard link: https://syzkaller.appspot.com/bug?extid=d88a977731a9888db7ba
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130f49bda00000

Reported-by: syzbot+d88a977731a9888db7ba@syzkaller.appspotmail.com
Fixes: e9db4ef6bf4c ("bpf: sockhash fix omitted bucket lock in sock_close")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
