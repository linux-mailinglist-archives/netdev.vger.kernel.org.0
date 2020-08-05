Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8370C23C293
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 02:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgHEAYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 20:24:07 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:35281 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgHEAYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 20:24:06 -0400
Received: by mail-il1-f197.google.com with SMTP id g6so16764320iln.2
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 17:24:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=YcEYobWe0gtmbwSjs0eeDwSC4BGhccPAeLKXxasmpXw=;
        b=sZiSVioT9HGQ7P61Wj++mMVvMW0Rrxsz65jR1fs0Zoa2LCf/KKZmDGSXfl4rk2rTZo
         D9ajV2BvoCTds1ml9HN17AJwS8inIC6FrnDh82gWjaSyINzkMog7cwl0Yy2vaYFxVLwE
         uCgO9cEux1PfRRofF3369wooske4Tsh0FXOaZwoB72fWhAOBmHbg6HJ2mCZKe25yB0WQ
         EL0LOS++5tjrVWvooAGhTZweqkAVL76rwVnOda1Hy9bww+4dR0VFv4bdX0tC8u8CRbOk
         XgFoGU5wzZ/nakE04pnTo5/3gg2MuGmGSZUYftAl5zzTro6+hKOkutjfVCVu04mkk013
         cLMg==
X-Gm-Message-State: AOAM530uezBT1A1W3IsyNv1FgQuJuspI1OkkHTTJfCYG3Nz2F3A7nFGb
        LGNi3LvgU0xwDzoKIrCSoP9RGplxgX+Nnk2VfVFXPQbzdbzQ
X-Google-Smtp-Source: ABdhPJwuZalmKeWO+pHiPWSqqtn5gfgs4D6jBqCQuwsKDkM2LSlSrPL+ZsNuPLhlwiwWkpFQK5ByESHxEN/Ub93XP1IFRfUCg0KC
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1649:: with SMTP id a9mr979747jat.115.1596587045563;
 Tue, 04 Aug 2020 17:24:05 -0700 (PDT)
Date:   Tue, 04 Aug 2020 17:24:05 -0700
In-Reply-To: <0000000000006d871805ac0f2416@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b4484105ac16639c@google.com>
Subject: Re: WARNING: suspicious RCU usage in ovs_flow_tbl_masks_cache_size
From:   syzbot <syzbot+f612c02823acb02ff9bc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dev@openvswitch.org, echaudro@redhat.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, pshelar@ovn.org,
        syzkaller-bugs@googlegroups.com, xiangxia.m.yue@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 9bf24f594c6acf676fb8c229f152c21bfb915ddb
Author: Eelco Chaudron <echaudro@redhat.com>
Date:   Fri Jul 31 12:21:34 2020 +0000

    net: openvswitch: make masks cache size configurable

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=110e06dc900000
start commit:   2f631133 net: Pass NULL to skb_network_protocol() when we ..
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=130e06dc900000
console output: https://syzkaller.appspot.com/x/log.txt?x=150e06dc900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91a13b78c7dc258d
dashboard link: https://syzkaller.appspot.com/bug?extid=f612c02823acb02ff9bc
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e8430a900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=123549fc900000

Reported-by: syzbot+f612c02823acb02ff9bc@syzkaller.appspotmail.com
Fixes: 9bf24f594c6a ("net: openvswitch: make masks cache size configurable")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
