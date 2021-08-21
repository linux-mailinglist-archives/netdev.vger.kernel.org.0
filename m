Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930E53F3815
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 04:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239457AbhHUC3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 22:29:46 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:41920 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbhHUC3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 22:29:45 -0400
Received: by mail-io1-f72.google.com with SMTP id s22-20020a5e98160000b02905afde383110so6531790ioj.8
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 19:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=iHf8LUR6Ovn1Eydbqz2P3rlkkwnXm6QsDeIBC7GD3Qg=;
        b=jgGRKZs/zUjkI+bQ7qGe4k99OsVnwomZHh/9SjbQ0OGrX9+kOvGpJVN7ArNuBZPv5C
         UHEAsRDQYopn5isAldWOu1un8sHhDrVvqGxlWzI/tVsIXPeLSJ8DWbf3v4rZzMU6s+FN
         ta3FvDUsMD6bqA0eadSL/fDA9GMA2eR8n3BXkJB9jP2FwbL1AR2/X6QEB1/MnvmdWrzM
         U6c56utSASamX8ZZEv58x9dE2xKd5fNojdqVsznHR09DPSeIes3B2av8ACsfA7S8NKPN
         ZO2DscYLe12ApDUrXrd8Kmk77OruDHigJ6qDmRlk7VEuIwjzYtjNLY+ZGseipRGUb6hw
         tHsg==
X-Gm-Message-State: AOAM531WqUXeqW8PvVZVzhOlrXX/ym5eQnNQn7167Zw4H/fvgOgCR+AA
        BnfGk2rwrBDbXRp9gKfqNFQNndPkGEhTTNxdUF9ECu4jB53e
X-Google-Smtp-Source: ABdhPJzK0a8DAE41lfsQEjn583iPFBrbzLkXnZnYep9X4S+LuDPXekPfSUKswjhPhf9qYgtRx0WLpEqRtx7gWnRPEARQrCKJT9xa
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:5c8:: with SMTP id l8mr16040022ils.282.1629512946491;
 Fri, 20 Aug 2021 19:29:06 -0700 (PDT)
Date:   Fri, 20 Aug 2021 19:29:06 -0700
In-Reply-To: <00000000000000410c05c8e29289@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000552aaf05ca088c20@google.com>
Subject: Re: [syzbot] KASAN: invalid-free in bdev_free_inode (2)
From:   syzbot <syzbot+5fa698422954b6b9307b@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, balbi@kernel.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        lorenzo@google.com, manish.narani@xilinx.com, maze@google.com,
        netdev@vger.kernel.org, phind.uet@gmail.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 63d152149b2d0860ccf8c4e6596b6175b2b7ace6
Author: Lorenzo Colitti <lorenzo@google.com>
Date:   Wed Jan 13 23:42:22 2021 +0000

    usb: gadget: u_ether: support configuring interface names.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=155abcc1300000
start commit:   d3432bf10f17 net: Support filtering interfaces on no master
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=175abcc1300000
console output: https://syzkaller.appspot.com/x/log.txt?x=135abcc1300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8075b2614f3db143
dashboard link: https://syzkaller.appspot.com/bug?extid=5fa698422954b6b9307b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174ebaf6300000

Reported-by: syzbot+5fa698422954b6b9307b@syzkaller.appspotmail.com
Fixes: 63d152149b2d ("usb: gadget: u_ether: support configuring interface names.")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
