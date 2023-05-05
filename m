Return-Path: <netdev+bounces-546-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B15266F80EA
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 12:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 114E1280FB6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE316156F3;
	Fri,  5 May 2023 10:40:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEE21FAB
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 10:40:46 +0000 (UTC)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3521A1DE
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 03:40:45 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-760ebd1bc25so98471339f.0
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 03:40:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683283244; x=1685875244;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9TOw2H2TDDn1VQzhH7iezPzkkf4u+p1oMfgUm2gH4s=;
        b=C/Mky6SKs6Ofl5s3GR7ePAjJdCbxUONc1bUturRMT+EGMTIPCOaIKA5EvynfNZbBfF
         IVTRoPOSb1FRydznEO9bWCZ3X9zoUzwS+s6eGnbqAhCY51P32di3apbPV5YsKuPaIOvr
         GbH3PTrf+aaz6hZNK2jaII57xf7qwzGFYPNuliDC1AMqWxW51Um+TVZ2EyHPkF+WMPQE
         xZJuOdOsMHTEpYeyIFPQS90DqV2OR0PYlCIeyQujSa/GN5ExY2YQ5w01V/5UuZAePt/I
         sLY+YfOgLc8c1kaTrt86jOd1YNpj9+Fh/ViDNZMMNqRYYq6hBW9/NU0HlocU28DsPAPN
         Lbvg==
X-Gm-Message-State: AC+VfDwJdvMP5tHH18Ft0CfPV0eB1Q5nvK1FroP3EpKV/afxBZiCPJRj
	oy20bLpt558EHzIipOG1vT1LJxs8FxcJMw4DQrdMGIJ9c1ay
X-Google-Smtp-Source: ACHHUZ5xOG3XGCx93dAYKbJBrOdkpF4bz1D74zAPToSCxvNwuTdypA21a6QfnU9ZY2IJzVNvRPtVJwEW4o1w9mz95YJTvmVXCpaE
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:290f:0:b0:416:1d9f:9887 with SMTP id
 p15-20020a02290f000000b004161d9f9887mr374342jap.3.1683283244809; Fri, 05 May
 2023 03:40:44 -0700 (PDT)
Date: Fri, 05 May 2023 03:40:44 -0700
In-Reply-To: <00000000000015ac7905e97ebaed@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd060905faefeb19@google.com>
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
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
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

