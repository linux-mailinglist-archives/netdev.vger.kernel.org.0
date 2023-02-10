Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E842691CF7
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjBJKhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbjBJKgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:36:48 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D7270723
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:36:37 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id b10-20020a5ea70a000000b0071a96a509a7so3190873iod.22
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:36:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1+xVltypcnxAkvWPCQxFM0n2XimN1lwperOL1Mtxsc=;
        b=jqYi79rJB1Y6A5v21mKw4z7tsHIhkFOW0PQjA7Jbih3jIG0+HtJ5wCW+EIgUtbuUc7
         yCociY2TCn5LJPExUsw2jIDiyGaAH7oWXSx8xaLxJMOp5Pgh8q/jHbs1bYci0/8Ho5Vx
         L/M0Rr++RLwU57bxZBF/TGxWh/FPMRnIsg+fpZpgXQVH+UAFox1i/VkBX0dOCumwuXYr
         qdck6EPQr53ghBV47TAfUaq/RusjEoHc2OybmDZ0Yz6TxlWrmgQ86HZK/xjvm+WYM3gw
         LAmC6LjrBkowkWrIY6b1CDMpllbf/GHG/LYeF0/dS1rzbaE2FtweNjm36D2LmM8b9vLO
         a8Vg==
X-Gm-Message-State: AO0yUKWgH6htqCIpdMgoSWt9tSfOYT8LzOWUblQ/3P9Fm3F+xnOJEe/D
        X3NmV7hcEZws0wF5mx4zkto9zFkr09BTVTU1BrZNE2FcM/NF
X-Google-Smtp-Source: AK7set8RPGGTXi5zLTnyjKswbEgN7LWwYzgzA5VGCB+OqcXXhMpBY6wGX14MoheR8H5OO5X6bCqt5kKFvh74/+6PMpEY5/Lis7ba
MIME-Version: 1.0
X-Received: by 2002:a6b:cf12:0:b0:713:f12d:40ba with SMTP id
 o18-20020a6bcf12000000b00713f12d40bamr7429931ioa.72.1676025396365; Fri, 10
 Feb 2023 02:36:36 -0800 (PST)
Date:   Fri, 10 Feb 2023 02:36:36 -0800
In-Reply-To: <00000000000015ac7905e97ebaed@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000062913f05f45612ae@google.com>
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
