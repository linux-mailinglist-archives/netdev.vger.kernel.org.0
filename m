Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85021350D3D
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 05:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbhDADjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 23:39:41 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:40798 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbhDADjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 23:39:06 -0400
Received: by mail-io1-f72.google.com with SMTP id e18so2992515iot.7
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 20:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=y0jAq5S9GiYMY36r36rGvrhgs2PgZlLJSzcOUpx10aI=;
        b=pISfU+iAaulhWxadnsrAT1SYpbG4kX3vvHL55jYCuu57hc6Rxd+qs6qaOCG7AweFcI
         VpeeoSUMtQdqG6rIk6OAPNDcZ+jzHoYT8Iu49K6vK9lxv8WBoN5HGXl+hV9LgYCpfvbc
         fdIbe/bAeI7hRasXS4mcuWmH5Ht8cyNRt3TRsYQSgBrvgnfrcopJk/fiD/a//UXfgS+b
         a1Z9jJUGvaMia7U/jBXeq8xnV/FgYjNiQfsatx13sEYcrUfDcQ6SyP4dzUuLn3HDOudu
         Uq9u3HWefilbY1vbPfvtmQegKk3gR3prHWnsieWuQj5Do4txf4b6vH+7T8SOgTSMVVir
         uAZA==
X-Gm-Message-State: AOAM530uHGi1xgfgjzNsaZlPDJE+r263x4rptb8PBI5T1t+PlNNJ4vLW
        BCfwHpnP1CgCIDdKV+k82yHfznMR6Mwkwcb4qRBbtt2KuMT3
X-Google-Smtp-Source: ABdhPJwzE7eMfw19r1VuuSvTtkhe67TPWs/rerGhe9Jm/clMO1VZfFxpEvlHGpoSYRqwFXicx9bTkonPXQ0pNzLMdY1wAwRSdeeF
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2603:: with SMTP id m3mr5782480jat.64.1617248345919;
 Wed, 31 Mar 2021 20:39:05 -0700 (PDT)
Date:   Wed, 31 Mar 2021 20:39:05 -0700
In-Reply-To: <00000000000046e0e905afcff205@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002c193805bee0f97c@google.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in bpf_trace_run2
From:   syzbot <syzbot+845923d2172947529b58@syzkaller.appspotmail.com>
To:     andrii@kernel.org, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, coreteam@netfilter.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu, kafai@fb.com,
        kpsingh@chromium.org, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mathieu.desnoyers@efficios.com, mchehab@kernel.org,
        mchehab@s-opensource.com, mingo@kernel.org, mingo@redhat.com,
        mmullins@mmlx.us, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        peterz@infradead.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit befe6d946551d65cddbd32b9cb0170b0249fd5ed
Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
Date:   Wed Nov 18 14:34:05 2020 +0000

    tracepoint: Do not fail unregistering a probe due to memory failure

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=123358a1d00000
start commit:   70b97111 bpf: Use hlist_add_head_rcu when linking to local..
git tree:       bpf-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e0ca96a9b6ee858
dashboard link: https://syzkaller.appspot.com/bug?extid=845923d2172947529b58
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10193f3b900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168c729b900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: tracepoint: Do not fail unregistering a probe due to memory failure

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
