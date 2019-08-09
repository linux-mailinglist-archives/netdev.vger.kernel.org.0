Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D9D88203
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437346AbfHISJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:09:02 -0400
Received: from mail-ot1-f69.google.com ([209.85.210.69]:55601 "EHLO
        mail-ot1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437214AbfHISJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:09:01 -0400
Received: by mail-ot1-f69.google.com with SMTP id p7so70365694otk.22
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 11:09:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=V25+XUIaKi6XUm0H56UptnIU5DSM67dQfXdundGFO4c=;
        b=HjzVOb9UIl+45rhF/3XOA8W+2OBtp5QGJm4jAKX9f/lwEZGXREUycWFGSgnWlLZ1Xm
         tqgi/LMVh7HARTWPhkY2Umy40O6a+qVyCxuGrzZLYIL6uSoLS4P1EK5mDzL3h2n35Qlv
         wLED1ewLU2ugqpfajE+ZRgaRVmv0l0vxUBIH/1/l0FRToPqRQtsEK9OGrzeGX0ICzFht
         L1s8jzQX2lYJFXBIRWt/ldBOaEca61WvnsLDrgx+rOYdTu7JS53lxU8oZHFHaTMQjdG9
         O/8S0lyEL0nXDNuHT88YCCVL8khI3sR8YP9ImZyjlFWDb6qgwNdeXdLj/jXvbjapUu9l
         pzWw==
X-Gm-Message-State: APjAAAXSjRl9aevgrlwmux8a7yIXAm2/W5J0XsgsB1uJUdQyYy1Y1XGX
        AThU6cUByK8yvY9xci2+AusZty4qktaXdCHGn3KtCpkP9bKF
X-Google-Smtp-Source: APXvYqxIodrbP/4N+EQhfOL74zP7r1vRk2mIoqLfGEyOIGZ+MQRSRuTeM4nmX6vaBwiaKnSNp8mU1E6XaJuPIgpRx/CcNuiRkERU
MIME-Version: 1.0
X-Received: by 2002:a5d:80c3:: with SMTP id h3mr23172856ior.167.1565374140994;
 Fri, 09 Aug 2019 11:09:00 -0700 (PDT)
Date:   Fri, 09 Aug 2019 11:09:00 -0700
In-Reply-To: <0000000000008cf14e058fad0c41@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009d5bbf058fb3116b@google.com>
Subject: Re: KASAN: null-ptr-deref Write in rxrpc_unuse_local
From:   syzbot <syzbot+20dee719a2e090427b5f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 5c2833938bf50d502586e16b9dad1e3cf88fda6f
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jul 31 15:26:05 2019 +0000

     rxrpc: Fix local endpoint refcounting

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1519a11c600000
start commit:   87b983f5 Add linux-next specific files for 20190809
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1719a11c600000
console output: https://syzkaller.appspot.com/x/log.txt?x=1319a11c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28eea330e11df0eb
dashboard link: https://syzkaller.appspot.com/bug?extid=20dee719a2e090427b5f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ceae36600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ebc40e600000

Reported-by: syzbot+20dee719a2e090427b5f@syzkaller.appspotmail.com
Fixes: 5c2833938bf5 ("rxrpc: Fix local endpoint refcounting")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
