Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B59659755
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 11:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiL3Keh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 05:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiL3Kef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 05:34:35 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163591581B
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 02:34:35 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id l13-20020a056e021c0d00b003034e24b866so13427899ilh.22
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 02:34:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1+xVltypcnxAkvWPCQxFM0n2XimN1lwperOL1Mtxsc=;
        b=hPHY166fmfNWMndYyO++T4Ys/QzKlrzYalwlRcUOK/8oG8eASqx5SJp3YybdjObMH5
         kVr6HxFVgEeWsC4ouxalNf5v5ewjoBs6ntnLXU66h8THFEGP4ztT7nJLUztAF0y8N9iy
         VZ0wTEOpmjjvJBOXaUetPX+uspxP654uB9e6cwScBW1A4DktQkbbz4WZEys9Dnx+wThi
         hPHES5agErn9TZtKdB94X1/YWmUfglHCGIC1bMWbyJkaf3pdb4j3jtkv6p4Gyrb0JW3a
         ZX1tmzt4LYOBEYyH9T/mcFeUT3cpDCtGlHx4LSdokDQNrSHTaIpFw3ZPdXmWG/87bG6k
         aDUA==
X-Gm-Message-State: AFqh2kr4eKriUNWl1JrvUU8ZkFWYuqZ1YKsAJzFbtWpUeAQiqAqqBiA3
        A/+zsFvWhKL+951VgOKg3sG2D34AH8H4tewmaXPb+bSAccI1
X-Google-Smtp-Source: AMrXdXuCVhfuhDVOVDBO2QEW3ZsUFRaZINtASNymA6eBjtRAhCOlpvlwUqMjxK5NbcRex/8HxlW2bK/0gq0OxTMGvKNDTLJeZwSu
MIME-Version: 1.0
X-Received: by 2002:a5e:cb44:0:b0:6df:b793:35ac with SMTP id
 h4-20020a5ecb44000000b006dfb79335acmr2257037iok.33.1672396474461; Fri, 30 Dec
 2022 02:34:34 -0800 (PST)
Date:   Fri, 30 Dec 2022 02:34:34 -0800
In-Reply-To: <00000000000015ac7905e97ebaed@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c8b66105f1092536@google.com>
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
