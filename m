Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D0763CAE
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfGIUWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:22:01 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:39717 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfGIUWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 16:22:01 -0400
Received: by mail-io1-f70.google.com with SMTP id y13so179768iol.6
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 13:22:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=gNp6IGzQMQGefwcCXwihte4j+oJMtUnlDKJXuaM+cUk=;
        b=DOSNm22XkZaOJTELJFbBndwx++L0dsiVM5RfSyfYg0j/3RASfe9fBOl/sZLYTTcO+Z
         CBBEwy3WBIOh07EiY5t2EZsuic2uhIobzfJxYB4goILOJ6gVahHMKru9014Sj9Z3h7JF
         RsiOUJ+PRKKz6rlc4VBCf7c7e6JPYhZfQkMl+9zwusdHQQiRxkJILikzYxltZ9bs5OFx
         fO837Z0Bzwv32/ig3yGhEjBZ5cAJ+QIsZrMoihrf9JSP43jDW8jWaupBf3pU7TMbHZUL
         L6HYHu4ymOrPamxRAKxHn02W8r21QWBIxYVtzPfe+okhuLPReDEQQCsf8PHqrnJ4WZ0C
         9lCQ==
X-Gm-Message-State: APjAAAWeR8gJKhSmvTyB/JcmhPWTi1lO+3tJyPzdho3KqwjlF2KHPHPc
        xb8uiHIiV6PPAVqnIWlBU8d5szyOWL9xezByAh1ud5UqWI7M
X-Google-Smtp-Source: APXvYqwFgwJAcUPiL5NbtuCyvSACDdRE25Si64mrNjVzIA9vXUAmOPuBWXTLl+KgXo65r6gDEueAVIzpruHAb52RcugMcVs1Xph6
MIME-Version: 1.0
X-Received: by 2002:a6b:6409:: with SMTP id t9mr9378524iog.270.1562703720611;
 Tue, 09 Jul 2019 13:22:00 -0700 (PDT)
Date:   Tue, 09 Jul 2019 13:22:00 -0700
In-Reply-To: <0000000000000595ea058d411c35@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000280332058d45509c@google.com>
Subject: Re: WARNING: refcount bug in nr_insert_socket
From:   syzbot <syzbot+ec1fd464d849d91c3665@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit c8c8218ec5af5d2598381883acbefbf604e56b5e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jun 27 21:30:58 2019 +0000

     netrom: fix a memory leak in nr_rx_frame()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1677f227a00000
start commit:   4608a726 Add linux-next specific files for 20190709
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1577f227a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1177f227a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a02e36d356a9a17
dashboard link: https://syzkaller.appspot.com/bug?extid=ec1fd464d849d91c3665
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b47be8600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15172e7ba00000

Reported-by: syzbot+ec1fd464d849d91c3665@syzkaller.appspotmail.com
Fixes: c8c8218ec5af ("netrom: fix a memory leak in nr_rx_frame()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
