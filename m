Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482A667E1C2
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjA0Kgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjA0Kgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:36:37 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CEA79630
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:36:31 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id j7-20020a056e02014700b00310d217f518so80419ilr.2
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:36:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1+xVltypcnxAkvWPCQxFM0n2XimN1lwperOL1Mtxsc=;
        b=Vt4t+KMvI6+cPpfD/9YVJuyrIN9zBH4D0ZX4lg1M1H5tU45p9eBJYXky2919oa1Jgq
         MumOVLJScwbjPKMeH7Aw0omsiQ2shWCJRruEEt77mRBJU4t4NofipRs1gbOg0bgBrQkm
         8YoUVj8UO5vv7ofouYCEKgX3A9hILF1HO/0nLA2rT+nc8Snvtd3nbV9Z0WizoEfkc/99
         G30ptCK8/kM6VKnJz6DRq9tAtRZpyttzfuthZeoBA8dxuMzJWTnMQlBXc+8HOndRfDpz
         9VxJTD7zVC+bigxd5apHG64jLwR9RCGOA3Aom3ooA0nu15fPIPDKwsDWMbV/6fHMCqmT
         3L7A==
X-Gm-Message-State: AO0yUKWCjLm0sBFQRNqUntQHicnykunnK63xSj0tff3HyyjPVJ0WLuYS
        qmRmfKbHNAlYLDSxYCLNwMjVCazlQfqUYwRdPQwVNF+T2mRF
X-Google-Smtp-Source: AK7set/LRjnKN3c3QPuyatvHLLG5RJKQV+J+jrRWeqchw7/XkjSPAx+OlYIsIezViEiSxTHqMMHTc0HR/QmM25RqTNZHS3j2E2Q8
MIME-Version: 1.0
X-Received: by 2002:a92:8e4d:0:b0:310:c52c:81ff with SMTP id
 k13-20020a928e4d000000b00310c52c81ffmr294320ilh.50.1674815791087; Fri, 27 Jan
 2023 02:36:31 -0800 (PST)
Date:   Fri, 27 Jan 2023 02:36:31 -0800
In-Reply-To: <00000000000015ac7905e97ebaed@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004acbb005f33c7013@google.com>
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
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
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

4. master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git

The full list of 10 trees can be found at
https://syzkaller.appspot.com/upstream/repos
