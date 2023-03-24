Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86FC6C7CC2
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 11:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjCXKim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 06:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjCXKik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 06:38:40 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CA9199DC
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 03:38:39 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id 9-20020a5ea509000000b0074ca36737d2so890033iog.7
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 03:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679654319;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9TOw2H2TDDn1VQzhH7iezPzkkf4u+p1oMfgUm2gH4s=;
        b=hq/m5GuzNvq25sNmpuBYrF4GPr6MIiLFLkXi53EwYcYhqJeefxp4iF9XwSODbYbUS8
         gVxRlLFzAzCD4upDCQsUimdIlVYiSLfc2m/EoCnCSFFUAg1m2kLmml4V3hy3Qdg5b5/Z
         e21TVT6en51Ho+X1G9M1e/36H/PAk3HuNi2syJJ8P9EFz+hNMvV9KWcJazjkAAaVN36o
         euIIlLjmKFY0rrGJZs5rWObWU4Y2Ro7g0mtNGTtIGnLtPgOdB2yqd/TrAMcTbnOnpmPr
         C1CWf84XuEYWfdZPSVtaQQCsyBeG9awm9U8A7ssEnzPSDSxcND4qDUa4XYRydf7MqkMf
         ZH3Q==
X-Gm-Message-State: AAQBX9fjnZv54k3mHTmpdihskKFNRY676KmCb29VglLmLRhgVPjfsLpR
        Qp5UlM3pZn4gt6U/w2qE8fYD9el+F5xToAtplhQNWmBQ1djQ
X-Google-Smtp-Source: AKy350bb9yMrtffJAvLki7tYYCcWem0k/K70GZplke3f49eMW0hXZztTj+oio5VmCMIBcoaDwalID7gbPTXUfVKbDFxheDkn0Rw2
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ec:b0:310:a24c:4231 with SMTP id
 l12-20020a056e0212ec00b00310a24c4231mr1538942iln.6.1679654318955; Fri, 24 Mar
 2023 03:38:38 -0700 (PDT)
Date:   Fri, 24 Mar 2023 03:38:38 -0700
In-Reply-To: <00000000000015ac7905e97ebaed@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006e5d105f7a2ffe8@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in rdma_close
From:   syzbot <syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, dan.carpenter@oracle.com,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
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
