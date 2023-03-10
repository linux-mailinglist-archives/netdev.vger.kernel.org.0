Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A3D6B3C79
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 11:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjCJKjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 05:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCJKjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 05:39:48 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6666525A
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 02:39:19 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id z6-20020a056602080600b007407df88db0so2308011iow.23
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 02:39:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678444713;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9TOw2H2TDDn1VQzhH7iezPzkkf4u+p1oMfgUm2gH4s=;
        b=C04xX5YsqE8H/o74FQQsiCIcwCldeetvNaH7F1pB3l1JWI3mBGTjuba4zTSfKhjT90
         76EKyvQ/dgLkBjKSXCUDLqZjRmaA3cGOviaWJy93exN2nFgGMnDABPDs1g4uO7rQZ0eK
         VTf5wt4BPtrTyyzYmwiXOZd5HRNO/eoaYHRNeGdxCUVQvuLW4rJHqJVyly/P50o2GLOf
         zIlj8Jr2I60R/ySL0R6sjgd5RrT8F5LN4qWiRWbMZJRA4Jjzb8HgHPJ8hm3VT1rzFIPp
         KfTsHiRWPgJ/C0XRx4/Ar/4rzs26D+mBSc4yRp3aNBWX6cFL/ZQiWStGUZwdFoj4wHzz
         eCJg==
X-Gm-Message-State: AO0yUKVhL4IobNpBzJrRucnb7+k+u+rLTuUIt7gMhuAvrYslA6fYlGSA
        6K7IPIUY9KWiw4MWuzEUl6P88kkyXZY8gW+IUZc0l4a5qyiT
X-Google-Smtp-Source: AK7set+htPHZBwSnCPyxLzhw6W23I2DyI4HLTP7zAHq5sRfVPF1UZQaLGMrJBIiXiB0u1/lW2y1kYlG57pPce5E1sMnez9QH28a6
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:d4a:b0:310:a24c:4231 with SMTP id
 h10-20020a056e020d4a00b00310a24c4231mr11305536ilj.6.1678444712894; Fri, 10
 Mar 2023 02:38:32 -0800 (PST)
Date:   Fri, 10 Mar 2023 02:38:32 -0800
In-Reply-To: <00000000000015ac7905e97ebaed@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e32a7905f6895c83@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in rdma_close
From:   syzbot <syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, dan.carpenter@oracle.com,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
