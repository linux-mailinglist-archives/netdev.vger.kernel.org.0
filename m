Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9B7433D07
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 19:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhJSRL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 13:11:29 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:36837 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhJSRL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 13:11:26 -0400
Received: by mail-il1-f199.google.com with SMTP id c17-20020a92c791000000b0025929f440f0so10602591ilk.3
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:09:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rcp90Jycu8Zrw+AkGD2yNkS0oA6YUsleSOyH/uwUAPI=;
        b=rovC1/0fkUgLg2AYW9YjqjXMFcvnspIKD+1wfQLoKfqIOnHySJizjjufZBUP7mdGsz
         RowGWvGxWLDIN7JW+YEAjURy5tcSa2hUY38uVkthbl4oYBJmLoLPkKWQ4CXkPAK7iZTP
         TjpGRQUisGXgBVfv26U8f6xcmj02Ly414wy1J1EBXMUGAm234Zoz4tbMoOq/Y0eQ09O6
         +XENLcXmXrMLeLZ+ejyWO6s1SVJxju+W6tunToWjM7ZdifYI0NDEW+D/BIO9Q0S+NJ9P
         EBfDLIJtjohsy7ahjDW9MfCfUXKrWMPfzU5rOg3VTaaCXm1ZC5GmIvr/THo6YBJGflrB
         9Rew==
X-Gm-Message-State: AOAM532zGx5E4hHM95o877t/iHf4mzsaXa1oTOsO0r9BD4aU52TJLifG
        EtG/qPi9e19XyIeUPnc54AlbRhf1UOrd16Gx54BotHwi7gbN
X-Google-Smtp-Source: ABdhPJz5oWnGZhBKSmLq/ZFBEeB1xmILbveWmW93eY56Q5lQV4BTx0LgwgOxqR5ByYO9WNkp6QGlx3AVqX7ABhzla8Dajhiij5VX
MIME-Version: 1.0
X-Received: by 2002:a6b:ee0d:: with SMTP id i13mr19679964ioh.166.1634663353642;
 Tue, 19 Oct 2021 10:09:13 -0700 (PDT)
Date:   Tue, 19 Oct 2021 10:09:13 -0700
In-Reply-To: <0000000000007e727005c284bc8e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008578d105ceb7b82e@google.com>
Subject: Re: [syzbot] possible deadlock in perf_event_ctx_lock_nested (2)
From:   syzbot <syzbot+4b71bb3365e7d5228913@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        andrii@kernel.org, ast@kernel.org, bigeasy@linutronix.de,
        bpf@vger.kernel.org, bristot@redhat.com, bsegall@google.com,
        daniel@iogearbox.net, dietmar.eggemann@arm.com, gor@linux.ibm.com,
        jgross@suse.com, john.fastabend@gmail.com, jolsa@redhat.com,
        juri.lelli@redhat.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mgorman@suse.de, mingo@redhat.com,
        namhyung@kernel.org, namit@vmware.com, netdev@vger.kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, vincent.guittot@linaro.org,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 8850cb663b5cda04d33f9cfbc38889d73d3c8e24
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Tue Sep 21 20:16:02 2021 +0000

    sched: Simplify wake_up_*idle*()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=166a8c90b00000
start commit:   60e8840126bd Add linux-next specific files for 20211018
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=156a8c90b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=116a8c90b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4bd44cafcda7632e
dashboard link: https://syzkaller.appspot.com/bug?extid=4b71bb3365e7d5228913
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11eccf58b00000

Reported-by: syzbot+4b71bb3365e7d5228913@syzkaller.appspotmail.com
Fixes: 8850cb663b5c ("sched: Simplify wake_up_*idle*()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
