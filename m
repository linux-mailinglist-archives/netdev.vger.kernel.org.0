Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0230C5554D6
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 21:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359854AbiFVTnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 15:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359108AbiFVTnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 15:43:11 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8724913DD4
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 12:43:09 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id n14-20020a056e021bae00b002d92c91da8aso3480261ili.15
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 12:43:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4OG3JNBrKZLM5Nj65eYO+3GhL5W3BfIxkELhNmo04tU=;
        b=yH34HQ+NKVjk0smRqfJg6kzKOUUtTdF/Q3duwqqfdP82cek/kk2zGefxqdXk9d4YYX
         3pD1rFOsUrvGcjipd+JO3UP16VoMTWEdO3CX6DX5VdI8wmharG0ZoDc3J0QvYoyxCTYj
         AHXLFkF6UKHui/Wo/jpeVLJMFL9ahdr2YLeU8FqG+pivm9EnqmqygZXOsgrfnQeo6BTG
         ZtjoVCVA5QWS725lq7kol/31k3Jo2XBsFCVF7opxBDKsTtBuAiVO7soZhQTmQEzQ5rmp
         1vsYevjGaQ+6f0nJaR4j2CeIo9KLMtByzoa6YJ1WMKQmhelSZDxOp1bwc/nCAM+v+bKz
         +6gQ==
X-Gm-Message-State: AJIora936BysL+tkJ3mxsZyq2GvemV8z17YVb49BkdS17c7LZtB4TN1F
        Z78pSHC9/vku1M6p+9BmxXGq4yGttlacVJWx7mjA1q/9IwNk
X-Google-Smtp-Source: AGRyM1tWX1L/At4A4DeZPe1TDB+uFjQewlzP9hHMsstdwwNphBkwnvetr+rGJG2CdxKpB9VzzNafv8p3hXEeIlPx0GLeSO17pEGo
MIME-Version: 1.0
X-Received: by 2002:a05:6638:5:b0:339:e628:b96c with SMTP id
 z5-20020a056638000500b00339e628b96cmr533882jao.203.1655926988375; Wed, 22 Jun
 2022 12:43:08 -0700 (PDT)
Date:   Wed, 22 Jun 2022 12:43:08 -0700
In-Reply-To: <000000000000113adf05e0704621@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ea8d3305e20e8bfa@google.com>
Subject: Re: [syzbot] INFO: task hung in hci_power_on
From:   syzbot <syzbot+8d7b9ced2a99394b0a50@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1674ba1ff00000
start commit:   9d004b2f4fea Merge tag 'cxl-for-5.19' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1574ba1ff00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1174ba1ff00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c367f7c347f1679
dashboard link: https://syzkaller.appspot.com/bug?extid=8d7b9ced2a99394b0a50
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103f3755f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f4cf3df00000

Reported-by: syzbot+8d7b9ced2a99394b0a50@syzkaller.appspotmail.com
Fixes: d0b137062b2d ("Bluetooth: hci_sync: Rework init stages")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
