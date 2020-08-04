Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488EE23BF97
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 21:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgHDTKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 15:10:08 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:45947 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgHDTKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 15:10:08 -0400
Received: by mail-il1-f198.google.com with SMTP id 65so9839347ilb.12
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 12:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8DGWtpZeXz6g3gc4QGhBE15iscZLRy4QscvcEIUaaf0=;
        b=nS15CgmRMD5vcwp3z9CAEUTl/IexmhBV8ie95xltwMBSIFt6Vhlwz2glA7LY3Cb07K
         TBS98RlV+lMkMY2i6xLw6kZFndTZTUPUlpY1EueV1wwIUHG+UJmihen1QrYW4GDsXNrx
         N7dIHAc3jamcIfv6100M2Sav3mL59caK7CDvdd14TjzpgICG4x3rDbwWeilb8Kmw2SmL
         2N6dSpDUkwFlmmCz5KxuZHid4q7CyAwy8YJz0uwnB6JdIoOPvkhRyGIw7lzaSPmbnx/E
         JN/A2cdk2ySfdhChJ4bcM3FC7ovE6W3DvI8RPjctDXc5T3RKYBNDctKmUEUknxTKL0e+
         GLSg==
X-Gm-Message-State: AOAM532dm14A+0dPQc9vKQV3GxnVc8E0Yk6QgWb9fpOa7FCV55pETltJ
        gxaEDEXvHi+60BTJeuTNDtKPrDCFQy3ZXTTNvOG4vlcGYM3T
X-Google-Smtp-Source: ABdhPJzIGgmU9Wneouek0XdGIUbP14uLYINaBLupAaVxNQzLpFgOJpeyfs/OdYUytzp5So9OVrIgzT55MOsTBG1WFe6X7kkZah6p
MIME-Version: 1.0
X-Received: by 2002:a6b:700d:: with SMTP id l13mr6590268ioc.135.1596568207215;
 Tue, 04 Aug 2020 12:10:07 -0700 (PDT)
Date:   Tue, 04 Aug 2020 12:10:07 -0700
In-Reply-To: <00000000000055881a05ac0f0122@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9d1aa05ac12001b@google.com>
Subject: Re: WARNING: suspicious RCU usage in ovs_flow_tbl_destroy
From:   syzbot <syzbot+c0eb9e7cdde04e4eb4be@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17461dea900000
start commit:   2f631133 net: Pass NULL to skb_network_protocol() when we ..
git tree:       net-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14c61dea900000
console output: https://syzkaller.appspot.com/x/log.txt?x=10c61dea900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91a13b78c7dc258d
dashboard link: https://syzkaller.appspot.com/bug?extid=c0eb9e7cdde04e4eb4be
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172cd3d4900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11fbd342900000

Reported-by: syzbot+c0eb9e7cdde04e4eb4be@syzkaller.appspotmail.com
Fixes: 9bf24f594c6a ("net: openvswitch: make masks cache size configurable")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
