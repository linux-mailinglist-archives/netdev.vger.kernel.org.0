Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C690473DCE
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 08:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhLNHwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 02:52:08 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:57134 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbhLNHwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 02:52:08 -0500
Received: by mail-il1-f200.google.com with SMTP id e2-20020a056e020b2200b002a4303742d6so15517282ilu.23
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 23:52:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lcHNNorG/LTmBnlLDr9pzEUJIluh5yB8GkJuX9RkX+M=;
        b=asv6XtLJWfrPP/MNyhrY6WvjNV1+ZzOtA8JmOviGkMB7o+sKIcbxGcbv7sFm73/wZX
         0S2cgTD6/9NpIJLYOOVXPe+uEfQ/NOp00NZarcTWH5bIznuu60wG1gO4CUMPau7WCtXB
         UsrcXYGbJtOtNhqrdWcu6B5diyE6i0zr5NJmMThiAc0GrBGU0CMKyLEGeqeFpKx/aAGt
         9fx7V5X4xvv1hEBiY7eQwsE/fEIMXy/0iT94d53K6/cdUJSKSyMnYjunvgHPkUe7dzAT
         Y/2zLj4E2FK2QvURa6G0J8eslsxYDw6a14omGXmtsIhK/THQlnKeWYnIrsEHdd4NpTOp
         0Iqg==
X-Gm-Message-State: AOAM532XkRLfF5dTCdQHUOaipkLkhpFK8Q2t656zZengZNck/oOZooiA
        DtnEZ+Ia9w1mR7iPKfocr4Ie9Z6z3Z6H/DmIMRBFs6CGFyaL
X-Google-Smtp-Source: ABdhPJwEb1jTTeln0/hF9lmMGIcFScozwQkTLG1gNHZuRcdvk+Do/KhhsRDbFnAX4Ve38aA1BAOAnDnAqmfbzVWtD9j1MFlBzJa9
MIME-Version: 1.0
X-Received: by 2002:a02:84eb:: with SMTP id f98mr1928730jai.743.1639468327923;
 Mon, 13 Dec 2021 23:52:07 -0800 (PST)
Date:   Mon, 13 Dec 2021 23:52:07 -0800
In-Reply-To: <0000000000005639cd05ce3a6d4d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004e75ca05d316779f@google.com>
Subject: Re: [syzbot] BUG: corrupted list in netif_napi_add
From:   syzbot <syzbot+62e474dd92a35e3060d8@syzkaller.appspotmail.com>
To:     alexandr.lobakin@intel.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        dvyukov@google.com, edumazet@google.com, hawk@kernel.org,
        hdanton@sina.com, jesse.brandeburg@intel.com, joamaki@gmail.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, maximmi@nvidia.com,
        netdev@vger.kernel.org, pabeni@redhat.com, saeedm@nvidia.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        toke@toke.dk, vladbu@nvidia.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 0315a075f1343966ea2d9a085666a88a69ea6a3d
Author: Alexander Lobakin <alexandr.lobakin@intel.com>
Date:   Wed Nov 10 19:56:05 2021 +0000

    net: fix premature exit from NAPI state polling in napi_disable()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=138dffbeb00000
start commit:   911e3a46fb38 net: phy: Fix unsigned comparison with less t..
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=d36d2402e8523638
dashboard link: https://syzkaller.appspot.com/bug?extid=62e474dd92a35e3060d8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141592f2b00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: net: fix premature exit from NAPI state polling in napi_disable()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
