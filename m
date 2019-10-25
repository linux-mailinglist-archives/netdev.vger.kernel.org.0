Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B6BE4253
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 06:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfJYEUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 00:20:02 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:38659 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfJYEUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 00:20:02 -0400
Received: by mail-il1-f200.google.com with SMTP id f6so1135665ilg.5
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 21:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=NF2elsax11pXsnm+smX3VLKpwTuafbnzKYyInM/Zfhg=;
        b=T/8zewNsAGQfv5cfO0zFCTBvhNlKMALHkSDP69epjdo7mpog5Dzr/9n90cuQFqsnxY
         I1fO8EsE0BrJyUstE0w2ogW/KIrq3rTgNn1GL1jAqE1hERtXTPZaY6xJ5rIZWdgqbase
         d8UUmlcEARVfGoZcYidmyn8enPFvKaJNialRNnY+ehUNNG0xUWth9FzZAATGbP/46L3a
         6IE8KbGsFKYE1DS9LOspGkF5bYYn5TbMLiLutq6CtBzE2kG+p7A+YZDz0hUVqBE/pcK7
         JpVcMYiMgAykoHtoXYPf3EbVgu44bAuwrLQ7jvDqa+1TPXYoSdCvrG2zHrA3syDikuih
         81bw==
X-Gm-Message-State: APjAAAWDltDH62GeFPR/onyIbkcS7ue6MRMZljRdGN5J9LdmcnnfCQnD
        YWXGvfqNmm8vrDYq+aLIs8f4h24Uke6oZnMSF+UW343rxOqF
X-Google-Smtp-Source: APXvYqxBLtXLb+ZNhposnuPP5R6TbEk6pDsIDIYFbKqUpk/R085DA7b4q4kzLVLphPbJ9kNcvFRhZFz7kEFExK0XH5h0eLU1wAlT
MIME-Version: 1.0
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr1924578ilq.296.1571977201370;
 Thu, 24 Oct 2019 21:20:01 -0700 (PDT)
Date:   Thu, 24 Oct 2019 21:20:01 -0700
In-Reply-To: <00000000000074bc3105958042ef@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aecf020595b4762f@google.com>
Subject: Re: KASAN: use-after-free Read in nf_ct_deliver_cached_events
From:   syzbot <syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, dhowells@redhat.com,
        fw@strlen.de, kadlec@netfilter.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit 2341e0775747864b684abe8627f3d45b167f2940
Author: David Howells <dhowells@redhat.com>
Date:   Thu Jun 9 22:02:51 2016 +0000

     rxrpc: Simplify connect() implementation and simplify sendmsg() op

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12f869df600000
start commit:   12d61c69 Add linux-next specific files for 20191024
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11f869df600000
console output: https://syzkaller.appspot.com/x/log.txt?x=16f869df600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afb75fd8c9fd5ed8
dashboard link: https://syzkaller.appspot.com/bug?extid=c7aabc9fe93e7f3637ba
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10938e18e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147caa97600000

Reported-by: syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com
Fixes: 2341e0775747 ("rxrpc: Simplify connect() implementation and simplify  
sendmsg() op")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
