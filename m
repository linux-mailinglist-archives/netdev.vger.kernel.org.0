Return-Path: <netdev+bounces-7388-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF9771FF9D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:43:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B8141C2094E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2FFA10947;
	Fri,  2 Jun 2023 10:43:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E038466
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:43:25 +0000 (UTC)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB18E59
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 03:43:04 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7776dd75224so87013739f.2
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 03:43:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685702556; x=1688294556;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9TOw2H2TDDn1VQzhH7iezPzkkf4u+p1oMfgUm2gH4s=;
        b=Pp7oXuGYV8G7+N4gEIl3wBcITbQ7QbkACmPoPo/P0PWF4nUnNDigNMBh9ELRVxlb4A
         i3KnXx38lsqstzzQ7szs5qGKN3kOtmFaWW2eQ8dbCpkfSteAySYNhVN7uqhCPPaNyMT1
         y04uxtNRVIkd1HaPoqJ8Yvu712AubNo3EXeERxm+w8CYAsB29v0nkqY96YyDZ22/cQGY
         Z2pFgNf1LgT0aNNEEuhI0+4JW663lv8wo1m+qFYubvXI7pJ12t8XdyShNgFTH3PgfE8T
         R8P4aj/yQJBrowNC+sXqFlUouTgbv8VBhPjrGZAzlBsBwC1PhWgFvUThZ35tZEgCYEO4
         4jRg==
X-Gm-Message-State: AC+VfDyqpDKWIrOIH9RGKzU//rKq/mwoALyUsik+iqwaSc06zqa3ppP4
	VdP4z9e1ldRrzcQ5Fgd+NGXiyHVVPXHBOI97lcnQrzPy/rFT
X-Google-Smtp-Source: ACHHUZ5g81UbT0rdYhiZsxkJQRZusYNFheAl9Q2G8/fz5X7oyogzCbJ3gEEO9e7RVn0nSDYkK4N6utNhjlOH6ehZj7UVEKz1AfvE
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5e:a814:0:b0:774:7cc5:6682 with SMTP id
 c20-20020a5ea814000000b007747cc56682mr799847ioa.3.1685702556762; Fri, 02 Jun
 2023 03:42:36 -0700 (PDT)
Date: Fri, 02 Jun 2023 03:42:36 -0700
In-Reply-To: <00000000000015ac7905e97ebaed@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000017cc6205fd233643@google.com>
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

