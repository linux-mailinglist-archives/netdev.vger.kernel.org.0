Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E135D17F3D4
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 10:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgCJJjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 05:39:03 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:52724 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgCJJjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 05:39:02 -0400
Received: by mail-il1-f198.google.com with SMTP id d2so9390199ilf.19
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 02:39:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Ft1PhnFnc8bw/kovbcGkfh5uu6sAnhp379YzovTXzb4=;
        b=Sf1xfxAruHC9O31nNiRjTCRr/cht7DMUs8+4woBQvKUicqq+j2nL1vZrB+CyQKTbrH
         EtjqJ1kngttbNq4lWiDvODWiWKKjetldJNUPbAWfLE2qseqr7VDvVC3syjL5Ui8Ff2fM
         WQln0/RsJMtPXjgHZnl4oQlHlxBtKlDx5hm42msDJHrzb6X7emJ3OA6nNRMScj6+Q/bC
         cUJOMBvYxiB5IecJDZmJRFgh2YsYh9gvCbhF6z5+7gY16G6aQasLkOLUbcIG1npOgUsG
         tWj/l8K6kRr6I+UJ0K5+tfe+f4x2KiMeOjz4bCdHcWrg4jQGPwnRZUq3jZd76/V39pwL
         FGjA==
X-Gm-Message-State: ANhLgQ3s8hFrbfuCTtSnxub/qPfCLH0E3JYCAP+cEnGCJoZQwn2Ft4sb
        6zsGv+jkY+6xhxBicQxJAyWiwYLNb04/R/uHKC85wG7gBYAk
X-Google-Smtp-Source: ADFU+vv409M5ysztY4mJK7k8RhSc53CkX02mkjFwyJLPk9ilHB8ccfdDU+ZKw2MzKDgbagEXleetGkGhQoVnTDE4XxZFi+izxggG
MIME-Version: 1.0
X-Received: by 2002:a92:9955:: with SMTP id p82mr6731873ili.178.1583833141776;
 Tue, 10 Mar 2020 02:39:01 -0700 (PDT)
Date:   Tue, 10 Mar 2020 02:39:01 -0700
In-Reply-To: <00000000000088452f05a07621d2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cc985b05a07ce36f@google.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
From:   syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
To:     ardb@kernel.org, davem@davemloft.net, guohanjun@huawei.com,
        keescook@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, mingo@kernel.org,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com,
        will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit fb041bb7c0a918b95c6889fc965cdc4a75b4c0ca
Author: Will Deacon <will@kernel.org>
Date:   Thu Nov 21 11:59:00 2019 +0000

    locking/refcount: Consolidate implementations of refcount_t

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=117e9e91e00000
start commit:   2c523b34 Linux 5.6-rc5
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=137e9e91e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=157e9e91e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5295e161cd85b82
dashboard link: https://syzkaller.appspot.com/bug?extid=cea71eec5d6de256d54d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164b5181e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=166dd70de00000

Reported-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
Fixes: fb041bb7c0a9 ("locking/refcount: Consolidate implementations of refcount_t")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
