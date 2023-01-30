Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A274C6815EA
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbjA3QEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbjA3QEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:04:20 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9572018B1D
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:04:19 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id i14-20020a056e020d8e00b003034b93bd07so7631304ilj.14
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZ6fwlL9CLfD/ZLTd4A9jeogS/MbrZVfZRRqCUVSY0w=;
        b=pRT1jrh/7f7A8ROEUG2nMlHvtFexkpxez/36j0ukJY2PrZLb0S6btJbuvWV2946nFd
         YZeUKXOMH17AN0fqHUd7pNRDdimcUSf4cxZlNCTtWfKCC+OhJ05cUFiNRhB+sXYr2fQz
         I67/B2I2kXmpvO//NMkJPIeFxW0RafQ9QJPtdQ0LQPH+0TTKlqTggXz5oKEepNiRvsIv
         PvDba/Tf1RgqQd8L2EXTb82Zm0+99ZBiF8MHObbJW675lSEdU0FahPt5t5GaVNACjJcq
         BELx2r+tlCwFYGcWRvrSoSB7yjqx5YobxFc1gbkzEoHNG3if9k5Hwwo4Jj0l6n7G+pUU
         zJcQ==
X-Gm-Message-State: AO0yUKUD8wBDhJ6bahq/fva4RXNPZ8xRdi/qYzLD1WeWmyGsQZoUVsTk
        21gfphKJPc3Pm2AhI2Un33SaG2EwgCOVlT3L5P8dF0shmCiL
X-Google-Smtp-Source: AK7set/5YeZxLCX5Z2pfifdN9ZEJzOFnavh/kL/NAgpnd4AsOrtdJgTr8eI2LvenarbAzK9jtMOxekaTR3trvPZlncoVX/3XkEzV
MIME-Version: 1.0
X-Received: by 2002:a92:200f:0:b0:310:c4b0:3608 with SMTP id
 j15-20020a92200f000000b00310c4b03608mr1716968ile.93.1675094658947; Mon, 30
 Jan 2023 08:04:18 -0800 (PST)
Date:   Mon, 30 Jan 2023 08:04:18 -0800
In-Reply-To: <000000000000ba030f05a87330b6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001ca15605f37d5ec6@google.com>
Subject: Re: [syzbot] WARNING in ath9k_hif_usb_alloc_urbs/usb_submit_urb
From:   syzbot <syzbot+d625c772c7814faabef9@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, bxb5544@psu.edu, davem@davemloft.net,
        edumazet@google.com, gregkh@linuxfoundation.org,
        ingrassia@epigenesys.com, khoroshilov@ispras.ru, kuba@kernel.org,
        kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, pchelkin@ispras.ru,
        quic_kvalo@quicinc.com, syzkaller-bugs@googlegroups.com,
        toke@toke.dk
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 16ef02bad239f11f322df8425d302be62f0443ce
Author: Fedor Pchelkin <pchelkin@ispras.ru>
Date:   Sat Oct 8 21:15:32 2022 +0000

    wifi: ath9k: verify the expected usb_endpoints are present

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=153e9c11480000
start commit:   55be6084c8e0 Merge tag 'timers-core-2022-10-05' of git://g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=df75278aabf0681a
dashboard link: https://syzkaller.appspot.com/bug?extid=d625c772c7814faabef9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=138d8cc2880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b2dc3c880000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: wifi: ath9k: verify the expected usb_endpoints are present

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
