Return-Path: <netdev+bounces-10664-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A56C72F9F9
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:03:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BC661C20C55
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4870C6138;
	Wed, 14 Jun 2023 10:02:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370E56AA6
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:02:50 +0000 (UTC)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F8A1B2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:02:46 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-77a55f64dbaso685222739f.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:02:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686736965; x=1689328965;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tbry3CeL1KYS7HLNoeY59keftn8OoKLWsLCuyU0Tezc=;
        b=GN5GMe5XzVxAm1aITxmBflibq99AAFm3dPdJI4KcU9/H7JH4PYXHVHfYV/M2oYClJC
         e3yRHKO+spHLcciqBKLcgmkMewA+N8929uBhylZ27w1zel0hcKspPHvf6v9kqlaC4RiE
         sHt2etD97fyssFcdxfqTWNwFMx92BGX4nQPR93rlLIv+yhsPhCg5fCGPddq0PN6XUgbD
         waIkUURYkJlyfO6E0tMyMRIb6lmIgmfpZ8bR/vskDYHTffCGtRfV3TTeO6TySQO5UMOW
         zAKzOirgoxDmcljdNyVojtArAtGcRf9ilmWqcwtlMfXajjJAfyf7Dsu0qKeDP2ZMMxwb
         54VA==
X-Gm-Message-State: AC+VfDyK5j6ttgJjnPgIeOSakk0szfNeTLyAa7Ie0KgUR6EtE7C6R/tS
	a2qJnlmbpIgcwWHhKTq4OlqfBjJJ6jXHX1GuqF9TOzKeXO/s
X-Google-Smtp-Source: ACHHUZ5Cw2CSNno0VjcZXjl9srSP0mRFQ395P6uRj7Vr62OPy1ip/51NqUWt88NtV6lhr1nJJCp3EN/Z1xAkIeeMORU86TioNMQK
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a6b:a18:0:b0:77a:e8e3:2c02 with SMTP id
 z24-20020a6b0a18000000b0077ae8e32c02mr5113965ioi.2.1686736965646; Wed, 14 Jun
 2023 03:02:45 -0700 (PDT)
Date: Wed, 14 Jun 2023 03:02:45 -0700
In-Reply-To: <1423848.1686733230@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aac23605fe140d6b@google.com>
Subject: Re: [syzbot] [fs?] general protection fault in splice_to_socket
From: syzbot <syzbot+f9e28a23426ac3b24f20@syzkaller.appspotmail.com>
To: brauner@kernel.org, dhowells@redhat.com, kuba@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+f9e28a23426ac3b24f20@syzkaller.appspotmail.com

Tested on:

commit:         2bddad9e ethtool: ioctl: account for sopass diff in se..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=12d9c93b280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=f9e28a23426ac3b24f20
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12c4f0d9280000

Note: testing is done by a robot and is best-effort only.

