Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10362669453
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 11:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240730AbjAMKiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 05:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjAMKh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 05:37:29 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB0876ECF
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 02:35:33 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id y5-20020a056e021be500b0030bc4f23f0aso15620562ilv.3
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 02:35:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1+xVltypcnxAkvWPCQxFM0n2XimN1lwperOL1Mtxsc=;
        b=wX0rnGmAYGSmgEVOlxoKvQkMb4q72WrNwlPmrfq4/eUYyFTuj/GmBinXuKGVjTJ3Rj
         wW7ek5ATZ3aV70h7aXHbVMC86eSS2TAYzmBGwcb1Qu+OBaeN4fneYG25gVRHzXZVWJz5
         rBwEE71IZd4LH62ysENzZ952smY8GhdpLoFI/3/nmkjEiEyYqRIBBaNl4wBkdDSDT0qC
         8YRR/7f66XnxqRl8J0wasBDa9Mn/rdOQmBlKG2bSRHYJkp/RD7mHC2Y85D3gBDefyjsq
         Fu2p4ODujpfDEZMa/NP6E1WCsbS9CObvSme58zjRv27fmmbqucwC2csZvtyqWDdu4VWI
         wIvg==
X-Gm-Message-State: AFqh2krrIKE0KYriMbK5ALzoUTav3KBbrcDIsr49/fLD5ywxFgeBJb41
        QVitgH1gS8FrLbG74vUigwc2FmiWasaW5wd9mtW3ivzze2v5
X-Google-Smtp-Source: AMrXdXueeOIjbgfJsuBkstMAC9Xwe+1dbnbo484X5eHTUi4XAlHe/5Z1A3bZDcjhLu3OpLSqti+aeZx4FW67RwpWMZUBFutdcV5B
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:789:b0:30d:a9e6:785c with SMTP id
 q9-20020a056e02078900b0030da9e6785cmr2630943ils.213.1673606132313; Fri, 13
 Jan 2023 02:35:32 -0800 (PST)
Date:   Fri, 13 Jan 2023 02:35:32 -0800
In-Reply-To: <00000000000015ac7905e97ebaed@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000002b67005f222cbba@google.com>
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
