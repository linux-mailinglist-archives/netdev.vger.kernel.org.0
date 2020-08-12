Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9442242397
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 03:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgHLBHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 21:07:06 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:48043 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgHLBHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 21:07:06 -0400
Received: by mail-il1-f200.google.com with SMTP id e12so620158ile.14
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 18:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=X3NiX6nVSgp11EpijWT3pX7H1MOgqhCnBt3mOeEwKPI=;
        b=BceFQ7lfdPZYLfUgizqntNUUfSKI64ZQuz6CJiqRXe57oe4EqcZrWFirG7G4jonfZ9
         xYURVbOqSeIxRSXtFrgSUe4Kmfk730eMKbDBOEW8OoSH43nP9FLoiI+C6i+4K08jesgY
         gzbCtqHYRlI691zKgC4a2oRjwG6zfAxXGghTqJCOHW56Xt1TQbmd4r9dygMWbV14SZgV
         LxHT/ud/o3BWfO9XwVJWU+ECAUxMCL33xV9Me3Ky4hEp3YkunXpO0fw/g9L6Gwu9+lf4
         YWl9EGQhQX6is9Mly44clrIgGBVuqHzEXqWqVX9FgX0gvGVCfgltraAQlmAsGm5ErDMD
         8IdQ==
X-Gm-Message-State: AOAM530fTfKYjkeLhQoiVaJg5hiyH/S2W6W1GodcIXcpyidnxpwCtOT9
        lK3ZGHySGpjbPpVONpaLXksUJA6oz13Os+Gr4qo0Od4I/UgU
X-Google-Smtp-Source: ABdhPJzflhizS6nniBWRSpW8mHijAZdmSAeiEp/VNDrTlrQJdIKYs08rqIEDvlb4OOzwu63y0W80MTCFDtmUkUL4JXTKE6e0ZT1S
MIME-Version: 1.0
X-Received: by 2002:a92:bbc6:: with SMTP id x67mr26231257ilk.235.1597194425363;
 Tue, 11 Aug 2020 18:07:05 -0700 (PDT)
Date:   Tue, 11 Aug 2020 18:07:05 -0700
In-Reply-To: <000000000000b6b450059870d703@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c72d405aca3ce17@google.com>
Subject: Re: KASAN: global-out-of-bounds Read in precalculate_color
From:   syzbot <syzbot+02d9172bf4c43104cd70@syzkaller.appspotmail.com>
To:     a.darwish@linutronix.de, akpm@linux-foundation.org,
        bsegall@google.com, changbin.du@intel.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        dietmar.eggemann@arm.com, dvyukov@google.com, elver@google.com,
        ericvh@gmail.com, hverkuil-cisco@xs4all.nl, jpa@git.mail.kapsi.fi,
        juri.lelli@redhat.com, kasan-dev@googlegroups.com,
        keescook@chromium.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sparse@vger.kernel.org, luc.vanoostenryck@gmail.com,
        lucho@ionkov.net, mark.rutland@arm.com, masahiroy@kernel.org,
        mchehab@kernel.org, mgorman@suse.de, mhiramat@kernel.org,
        michal.lkml@markovi.net, miguel.ojeda.sandonis@gmail.com,
        mingo@redhat.com, netdev@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rminnich@sandia.gov, rostedt@goodmis.org,
        rppt@kernel.org, samitolvanen@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        v9fs-developer@lists.sourceforge.net, vincent.guittot@linaro.org,
        viro@zeniv.linux.org.uk, vivek.kasireddy@intel.com,
        will@kernel.org, yepeilin.cs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit dfd402a4c4baae42398ce9180ff424d589b8bffc
Author: Marco Elver <elver@google.com>
Date:   Thu Nov 14 18:02:54 2019 +0000

    kcsan: Add Kernel Concurrency Sanitizer infrastructure

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13eb65d6900000
start commit:   46cf053e Linux 5.5-rc3
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9d672709340e35
dashboard link: https://syzkaller.appspot.com/bug?extid=02d9172bf4c43104cd70
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147e5ac1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b49e71e00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: kcsan: Add Kernel Concurrency Sanitizer infrastructure

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
