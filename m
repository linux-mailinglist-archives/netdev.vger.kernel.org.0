Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3D4141695
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 09:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgARIgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 03:36:02 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:51492 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgARIgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 03:36:02 -0500
Received: by mail-io1-f72.google.com with SMTP id t18so16556222iob.18
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 00:36:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=f6arYuzOgRiNLirbokwAadEyI3EtpDczyp+p4b7vfMk=;
        b=UgqbMF4vDoHEgwMK9M1RQcb502UITituwmq2nNwZj6QJ/8tQXMc2yXs8t9Z25DJEKH
         6XBtFsgbUDSYON8z4a0SImYTjNmzlarcEMFV/jcEvuqj0a+Xc5aUVQfOJ5Dteh0H7vtE
         ZOjJ7TmadD/M6xSjvoQi4A6HoctvD5S9lAdu+IQlH6VysFwAn56o8MfYggafOA8CcPHb
         aJePfNGh7MvzQ880mbh8tZUugd4wizzUtJDOcf34iTvfhPtLXgRT3N96VRyjfHsPXXmh
         QToPPKfq4EFQ9pWFTUCeIrX1c9nUzbkxB+jWfBCLMiF5uK5rLk95tqIvPaSmX9HY2O3f
         FDAg==
X-Gm-Message-State: APjAAAWwZYiJ3NZCs+sHMwJqDqGRw8fbJV3LSbUG4ce4R9R4+HZCsDe/
        TkNmHT8+fzi45tYrODgPgtJmo1lYXIACY4s7ZxLr2+DY8Kaj
X-Google-Smtp-Source: APXvYqxpKnt5Q1gviMC5prN5JTg6U+mpzrK7koY1nSdpvBADtfR8n77cXbnKp9w6a0f/yM6V1iVvJQS62W2YH/DmuX9np5aG08ox
MIME-Version: 1.0
X-Received: by 2002:a6b:7201:: with SMTP id n1mr29961612ioc.37.1579336561855;
 Sat, 18 Jan 2020 00:36:01 -0800 (PST)
Date:   Sat, 18 Jan 2020 00:36:01 -0800
In-Reply-To: <000000000000b9c312059c656759@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c01359059c65f22e@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ipmac_list
From:   syzbot <syzbot+190d63957b22ef673ea5@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de,
        jakub.kicinski@netronome.com, jeremy@azazel.net,
        johannes.berg@intel.com, john.hurley@netronome.com,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, simon.horman@netronome.com,
        syzkaller-bugs@googlegroups.com, willemb@google.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit ed246cee09b9865145a2e1e34f63ec0e31dd83a5
Author: John Hurley <john.hurley@netronome.com>
Date:   Sun Jul 7 14:01:55 2019 +0000

    net: core: move pop MPLS functionality from OvS to core helper

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=127260f1e00000
start commit:   ab7541c3 Merge tag 'fuse-fixes-5.5-rc7' of git://git.kerne..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=117260f1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=167260f1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=190d63957b22ef673ea5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fe12a5e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1138dfaee00000

Reported-by: syzbot+190d63957b22ef673ea5@syzkaller.appspotmail.com
Fixes: ed246cee09b9 ("net: core: move pop MPLS functionality from OvS to core helper")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
