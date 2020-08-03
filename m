Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF98423AB5C
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 19:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgHCRIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 13:08:07 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:54871 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgHCRIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 13:08:07 -0400
Received: by mail-il1-f198.google.com with SMTP id a17so6265786ilb.21
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 10:08:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Uagz7c3ZVrQ4AmBTqTiRjiEhG5PZlj6ITpIEOjqwLlk=;
        b=B4EmXSNa8lMYbvXln17VNBYX9C4Hc7lX/wA9W0VSng9yBwsWZlaUAaz9VQ85m7wStj
         aSSBBUG9LVh99YEjw7qwO1fFoPtK2XdUTG7IAospx+m+u5hyjHt1GcaIYQn+EExOa+zp
         gO0r4A8ZRRmqKopiyreoA03yAizQG4lsdsXW0eWSup3a+Xjr0s3EKoQBw5egesHDJeCn
         J18tmtJs6NY5htPz6XLJqkzO1DnNYFm4zArySfmK5UfzJKnMRJs5oOGcaeDgEUOx3qEJ
         q4dRWazSsVI3cNra0fd4QdatgHgEalIl0AsXD3Kssrx1f0Uo2phMZKGbIp/ZjBl3mLJP
         p62g==
X-Gm-Message-State: AOAM531d58MFYSdfJJOGST42XgpG2TCDIgRAMvZtOgwMQbcY+FNTQXwr
        YPtM3AUFM9yiwzwLfUKenh265Ds6NPw7hYtzE6UTWBiR/LJI
X-Google-Smtp-Source: ABdhPJwUoO2AGC6UR45bmv6qFFKyJ8ndp7XrS1e6QhsHYtzpbvYwfQUycvap8dTkeAspF89iKUlUGDNf8nhiIGlpOp1dgS5vlqxA
MIME-Version: 1.0
X-Received: by 2002:a6b:bb43:: with SMTP id l64mr795486iof.191.1596474486108;
 Mon, 03 Aug 2020 10:08:06 -0700 (PDT)
Date:   Mon, 03 Aug 2020 10:08:06 -0700
In-Reply-To: <000000000000adea7f05abeb19cf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a335a405abfc2e1e@google.com>
Subject: Re: KASAN: use-after-free Read in hci_chan_del
From:   syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, eric@anholt.net,
        gregkh@linuxfoundation.org, johan.hedberg@gmail.com,
        kaber@trash.net, kadlec@blackhole.kfki.hu, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 166beccd47e11e4d27477e8ca1d7eda47cf3b2da
Author: Eric Anholt <eric@anholt.net>
Date:   Mon Oct 3 18:52:06 2016 +0000

    staging/vchi: Convert to current get_user_pages() arguments.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=178321a4900000
start commit:   5a30a789 Merge tag 'x86-urgent-2020-08-02' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=144321a4900000
console output: https://syzkaller.appspot.com/x/log.txt?x=104321a4900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=305a91e025a73e4fd6ce
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=127dd914900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=122a94ec900000

Reported-by: syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com
Fixes: 166beccd47e1 ("staging/vchi: Convert to current get_user_pages() arguments.")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
