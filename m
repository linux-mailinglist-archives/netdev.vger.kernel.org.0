Return-Path: <netdev+bounces-11481-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D71473345A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA7CC2817A7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A48AD1775C;
	Fri, 16 Jun 2023 15:09:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D9079E5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 15:09:46 +0000 (UTC)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5B93ABA
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:09:30 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-77a0fd9d2eeso65471939f.0
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686928169; x=1689520169;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Imb23EaY07Gm7MJa4Np4kGVuIs1+xNQBFZQNfFls+gM=;
        b=GofT4vwnF+t5Uw9pgN2cX2BjEbF8BV4FBoX1Bdj4cW6dLhWCtzpHAu2hQMKztB/eIG
         eM+qAJvfM5gMCWzLHrUwPB6w+73vgDWYXn9y7VmKoMdTlFcWnAM0Tje/HMXcOBIGs4ON
         9RUAhOO6oEsdeTdrUnaADdg+eNRS6S/5SH6lWgSxrio81Q32jeDmDXq9jAAvo99GALfV
         smAuMm1SZEQQcJIk2oVSUb12Uu/RrPjmDp2FXn1YzQC2A/c7yJnTC4CkPVfa1DtTXyub
         EB7l/iRLEcHFCY0CqtaO1uZX5AWF+mxj5Vt8sksLhRAwOhrVAAcYERilzGjhWmOI3hf2
         jvtQ==
X-Gm-Message-State: AC+VfDy5tuN3HJxVXA/Kfu4X9nEwwQwqGm/4Vrx44JGqRxGBRp7eRG4a
	lHqNPXOKsGL5aTWn6PFUl7AR9x4RAATh4KBcpvVSp70FMqSx
X-Google-Smtp-Source: ACHHUZ74+dXyvXDTGc+FFJWwCq4aB7E4QHdfr+P5b8tR/ce1Zt3HbjyX4nIZUMIKXW6jGatIamaZTBC88weu2rXjtpNJxD+nybqE
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:a119:0:b0:423:13e1:8092 with SMTP id
 f25-20020a02a119000000b0042313e18092mr696867jag.5.1686928169697; Fri, 16 Jun
 2023 08:09:29 -0700 (PDT)
Date: Fri, 16 Jun 2023 08:09:29 -0700
In-Reply-To: <00000000000098289005dc17b71b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000051087405fe4092cc@google.com>
Subject: Re: [syzbot] [bluetooth?] possible deadlock in sco_conn_del
From: syzbot <syzbot+b825d87fe2d043e3e652@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, fgheet255t@gmail.com, 
	hdanton@sina.com, johan.hedberg@gmail.com, josephsih@chromium.org, 
	kuba@kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lrh2000@pku.edu.cn, luiz.dentz@gmail.com, 
	luiz.von.dentz@intel.com, marcel@holtmann.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com, yinghsu@chromium.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzbot suspects this issue was fixed by commit:

commit a2ac591cb4d83e1f2d4b4adb3c14b2c79764650a
Author: Ruihan Li <lrh2000@pku.edu.cn>
Date:   Wed May 3 13:39:36 2023 +0000

    Bluetooth: Fix UAF in hci_conn_hash_flush again

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13755717280000
start commit:   e4cf7c25bae5 Merge tag 'kbuild-fixes-v6.2' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=555d27e379d75ff1
dashboard link: https://syzkaller.appspot.com/bug?extid=b825d87fe2d043e3e652
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10052058480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1190687c480000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Bluetooth: Fix UAF in hci_conn_hash_flush again

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

