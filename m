Return-Path: <netdev+bounces-10559-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7BBD72F0E3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 02:20:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD9F3281273
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 00:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA2B194;
	Wed, 14 Jun 2023 00:20:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0544160
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:20:26 +0000 (UTC)
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F4E127
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:20:25 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-33d34e7c905so68844025ab.2
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686702024; x=1689294024;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vPZJuew65UVR5FFQsxCbQqGDSX7P8C2GTOs6C/LbA5k=;
        b=dx3+VQZIjJFlqmKch/tALZkcZqFvcK9PYjC30mctkJhe7YXI/MnhoOus9uUZThWW2h
         3PK4eAAPyRZu5VaSNMghdJ0x9IERQxas41e8lA9lm+RnGvB9aSJfDbOhZfqMzBR5oXMs
         +vQljldAqoWk0I+BXPxHfpk5vzkVaDnmochMXzgmL1fBeHqzBsL8eIdLvDdFT+6N6UF+
         yPo2CIBFSrmdrUpqBrXj7vXLdZbSkz4KwwThuA/7QoDCFSZl8AAW3YG1nsl6IpZwRa+k
         ce7bGH3M+KBuISk3gfunbmzrJ47zSDN1MfCLe3QTjqu4NNsIG2NQxvaXVbwNhykocgvZ
         PnlQ==
X-Gm-Message-State: AC+VfDzUmo2gm9IVzkuwMu5EDwA4r19SPAfJYDBF/CF0IZreRC99sbJe
	mfSVrF9eT5+EmBqKjCh9HzrgtRPzbOS6ebcAAn6ekuVGJJ7l
X-Google-Smtp-Source: ACHHUZ5vfao69TzkXMKSqLdZVZkQjhmYJLPV9X2girde6yyBqzjp7nQ2/UjzqGlW9LrxZhB3uLFSTTG2d/SigJlwdS0tZP7hRA/U
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c98f:0:b0:33b:1445:e9cc with SMTP id
 y15-20020a92c98f000000b0033b1445e9ccmr6377594iln.1.1686702024743; Tue, 13 Jun
 2023 17:20:24 -0700 (PDT)
Date: Tue, 13 Jun 2023 17:20:24 -0700
In-Reply-To: <1394611.1686700788@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006e58b05fe0beb6c@google.com>
Subject: Re: [syzbot] [net?] KASAN: stack-out-of-bounds Read in skb_splice_from_iter
From: syzbot <syzbot+d8486855ef44506fd675@syzkaller.appspotmail.com>
To: bpf@vger.kernel.org, davem@davemloft.net, dhowells@redhat.com, 
	dsahern@kernel.org, edumazet@google.com, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+d8486855ef44506fd675@syzkaller.appspotmail.com

Tested on:

commit:         a9c47697 Merge branch 'tools-ynl-gen-improvements-for-..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=145cfc8b280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=d8486855ef44506fd675
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14ed8d2d280000

Note: testing is done by a robot and is best-effort only.

