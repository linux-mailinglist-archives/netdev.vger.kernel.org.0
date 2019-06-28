Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BABE59C80
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfF1NFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:05:03 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:47015 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbfF1NFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 09:05:01 -0400
Received: by mail-io1-f71.google.com with SMTP id s83so6573561iod.13
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 06:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=YCxs/qt8Mwv3z7mR64kHU2i7RhK2QfF8Lu/zZDPEtsk=;
        b=Uc7s2lagDeWki2df5/wvXhNnKDS19yBhtihWU5Xio+DN0eDmdDJ8PSLjsejMtVIlTx
         XynkKanNtgfiBniFKGqEwq99QG43KXxyojpQcjk7WVCTt56lwgVurkwr+v3H6p5jVDCU
         nVDYUhvcjqBPwVSu4JZOd9Q1CTLjTKE8j2acaqHRphQGvhXunoLZU495VyjQ3cpGMbLD
         DdyhF5VPgUGoRexl8xHOTTVwnGw9FAoKblXsB5+udCHzpppnJXnOYMVm6sVpREacOJyd
         cPk9rLfyI0YrsnQAYwQG8ERN3z0ehvjeG+rUsZJ/9nG10P/ZjAgPR9AhNBUg4lw4dJqm
         Fm3w==
X-Gm-Message-State: APjAAAV9oClTOGLMTpH1U+PrOy736xF1Qf9WX04tiVid2uVdzkIAwCks
        uMEw0rkgR+76xlD+oNkY6/wb6/gsQ/TzubpQQJG3eUlERhds
X-Google-Smtp-Source: APXvYqx8GKh0Tz0N6JPHNRL9IOslCQEy3zMhF+Ww6SA10ngn8dacBYWiHU7ErPZ6cdknibLtC5lh5DRaS2I+orgfp5ZsyEQIgEVu
MIME-Version: 1.0
X-Received: by 2002:a6b:8d92:: with SMTP id p140mr10485891iod.144.1561727100535;
 Fri, 28 Jun 2019 06:05:00 -0700 (PDT)
Date:   Fri, 28 Jun 2019 06:05:00 -0700
In-Reply-To: <00000000000000ac4f058bd50039@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000104b00058c61eda4@google.com>
Subject: Re: WARNING in is_bpf_text_address
From:   syzbot <syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, ast@kernel.org, bpf@vger.kernel.org,
        bvanassche@acm.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, jakub.kicinski@netronome.com,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, longman@redhat.com, mingo@kernel.org,
        netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        xdp-newbies@vger.kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit a0b0fd53e1e67639b303b15939b9c653dbe7a8c4
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Thu Feb 14 23:00:46 2019 +0000

     locking/lockdep: Free lock classes that are no longer in use

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152f6a9da00000
start commit:   abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=172f6a9da00000
console output: https://syzkaller.appspot.com/x/log.txt?x=132f6a9da00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28ec3437a5394ee0
dashboard link: https://syzkaller.appspot.com/bug?extid=bd3bba6ff3fcea7a6ec6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ae828aa00000

Reported-by: syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com
Fixes: a0b0fd53e1e6 ("locking/lockdep: Free lock classes that are no longer  
in use")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
