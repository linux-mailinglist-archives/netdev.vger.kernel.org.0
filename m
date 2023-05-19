Return-Path: <netdev+bounces-3869-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A48070953E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 12:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F36BD1C211E0
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 334277472;
	Fri, 19 May 2023 10:41:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E895698
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:41:21 +0000 (UTC)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E014198C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 03:40:56 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-76c56492fa0so488613539f.2
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 03:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684492849; x=1687084849;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9TOw2H2TDDn1VQzhH7iezPzkkf4u+p1oMfgUm2gH4s=;
        b=MDsW8LUPWqOAuz5kmNU3VMQOMME+EbH61GNRSA7jK6WDknouD1BfMcpibCv5yC29IJ
         7RDdiQ9WTjeIo6Q7kFV9mW9LUFfhYPpeovkDlFUpa8I92vntiGvn60393EcU/GHS14zx
         18OrzV9Q5NPKJHJAmYwXBAI4UOZE2aSr40rCw5ZsQP2KT7aWY1jOSkHwFMaGcMMQO4s7
         jCokwbSTarIZfQiDo6cFEnUshqHyRPW+SBV1+g0l1HnrOEMqGPjkYBkdYJS2H8ba18yH
         /Ed8TZqqxED4DT1PNPJmva4zaQwgv4jwXC9fELURpqmcXSdDeOKxp07zSdVN+vRS3ZgO
         wytw==
X-Gm-Message-State: AC+VfDzuButPlhCRrXW6bsu00FuyK5TNq54wwueAgWU8n98ZUHqQmKkZ
	ns9HG11XC498zdRab4E+xvxULHzD+31hnItL8DjiG6AP5Ouv
X-Google-Smtp-Source: ACHHUZ4QMAvvAu11HMro1lpXhxQH2y2TZ7K+U96VwnPLzFF6dbDXZjO027mQ4I6oDWKNp85qzxW9oChkbPZmi5LOXlg+QU7yItqI
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5d:8e07:0:b0:76c:7d5f:3690 with SMTP id
 e7-20020a5d8e07000000b0076c7d5f3690mr687473iod.1.1684492849358; Fri, 19 May
 2023 03:40:49 -0700 (PDT)
Date: Fri, 19 May 2023 03:40:49 -0700
In-Reply-To: <00000000000015ac7905e97ebaed@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e9b0a705fc098d91@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in rdma_close
From: syzbot <syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com>
To: asmadeus@codewreck.org, dan.carpenter@oracle.com, davem@davemloft.net, 
	edumazet@google.com, ericvh@gmail.com, kuba@kernel.org, leon@kernel.org, 
	linux-kernel@vger.kernel.org, linux_oss@crudebyte.com, lucho@ionkov.net, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com, 
	v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This bug is marked as fixed by commit:
9p: client_create/destroy: only call trans_mod->close after create

But I can't find it in the tested trees[1] for more than 90 days.
Is it a correct commit? Please update it by replying:

#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with
the same signature are ignored.

Kernel: Linux
Dashboard link: https://syzkaller.appspot.com/bug?extid=67d13108d855f451cafc

---
[1] I expect the commit to be present in:

1. for-kernelci branch of
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git

2. master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

3. master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

4. main branch of
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git

The full list of 10 trees can be found at
https://syzkaller.appspot.com/upstream/repos

