Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903755541CA
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 06:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356618AbiFVEhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 00:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356032AbiFVEhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 00:37:09 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B854835279
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 21:37:08 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id h5-20020a056e021b8500b002d8f50441a2so7322547ili.13
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 21:37:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WGUUiAN9wgqgmgaLmxz5/QjWUxqb/iZbav0ddG9/qxM=;
        b=Yeu5c7j2Y6uSO5PohNVi6eLW2KlaVsdBU3L2Edl6dyiWfh7EUnz7KosmaxzeDli5R7
         XUHfdYg08BwvcQdLrW6hAbKnV6IbVuB0RBbqLskI3K9wEWw9E3qU5zrQFvxlcKg/teNy
         kdvRq5svoMrdiJ96PJ60nws08nuSg0tYDm07lHaA2KYxMrBjdmVg5ttZDdhP/ZZJp1oR
         Xaffps1k9Xo25ylNEzynxUd9HFYfyFHkMyLBsLP/ho2PMtxt75GG0omYzlGaHsD/6XWx
         AL1gbWw13BkPXmio1Xb4DGKxZ1LnB0egNAP9HpCB9qkLdpJOuUNn6Ueuc7sVBiStnOga
         1RGw==
X-Gm-Message-State: AJIora+5wogByImP7GbPEalxSBxiS2tnnFlJaLapWvTKTV+0mJvKmW5y
        h19K4VQdeJmd8L4v7AokwaaHnII6r9FUQzp45EFwxJfFIXoR
X-Google-Smtp-Source: AGRyM1vc7sXZh7aauZkM8JZvEZJZDVt5NW8TEBYvuQNC9WLxqRQPwVvkC8owL79Qzjil/e5YVyFYVXe55idtE2rXbP9w6urOkpEW
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3488:b0:332:2973:be80 with SMTP id
 t8-20020a056638348800b003322973be80mr1048880jal.6.1655872628113; Tue, 21 Jun
 2022 21:37:08 -0700 (PDT)
Date:   Tue, 21 Jun 2022 21:37:08 -0700
In-Reply-To: <000000000000cf2ece05def394c8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cacae905e201e3be@google.com>
Subject: Re: [syzbot] INFO: task hung in hci_dev_do_open (2)
From:   syzbot <syzbot+e68a3899a8927b14f863@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, hdanton@sina.com,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, luiz.von.dentz@intel.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit d0b137062b2de75b264b84143d21c98abc5f5ad2
Author: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Date:   Wed Oct 27 23:58:59 2021 +0000

    Bluetooth: hci_sync: Rework init stages

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1376c63ff00000
start commit:   38a288f5941e Add linux-next specific files for 20220506
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10f6c63ff00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1776c63ff00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6f4fbf50aa82985b
dashboard link: https://syzkaller.appspot.com/bug?extid=e68a3899a8927b14f863
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111555fef00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1629b3eaf00000

Reported-by: syzbot+e68a3899a8927b14f863@syzkaller.appspotmail.com
Fixes: d0b137062b2d ("Bluetooth: hci_sync: Rework init stages")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
