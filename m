Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FCE6DAB91
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 12:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbjDGKiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 06:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjDGKiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 06:38:50 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C357EEF
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 03:38:48 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id c6-20020a056e020bc600b00325da077351so27305584ilu.11
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 03:38:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680863927; x=1683455927;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9TOw2H2TDDn1VQzhH7iezPzkkf4u+p1oMfgUm2gH4s=;
        b=rXPILS0TCfMYlcEQJQCin43Ifz8jyrFTkAuQfFMvjqaiBZoyAuVXt8PGOeFWMQa4QM
         KEKOMs7/z+xJclr9KyYOxZFxz6ywCSxCciEV/9yaZDmB8+hWcXR+oqx1vyLSndD0bzxI
         d08Yk4y9h7hsUJ4I6YguxZN2pH+pv+n1DkHy/oF7T3OssoSBmXDWzBoVnercxrS/I1t3
         7D93P5vldmhH7IzlGfLMz0kMXGeoBCGKsjTc/27B1GHstKsfYSSXDZ1FUgc1VwX633NB
         WI9qOwSRTKeFUW0U6funEbpmE40PS4aGNFlN/gE3GG7936GVX1Q2t2A3ddeXW40rHnUE
         mIYQ==
X-Gm-Message-State: AAQBX9cnEhTbG9sG5wcXyRSHj/mO2SuLbO8ywpXu0Wdxa5+rjHNJhlia
        VT0jNof1SD5YXVBfPmid/pC/Y35O71zTbRxDi1eb+nD2V47h
X-Google-Smtp-Source: AKy350bTIloAMOJJCWF2F+P3ocOqmsKkwIitkngIToLoISfzb+CofxA0fYn2DshSsa/5n9OaLiw4mn36VAr9CwfHsfRY+1WsVc7M
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b29:b0:310:d36c:35e6 with SMTP id
 e9-20020a056e020b2900b00310d36c35e6mr1109451ilu.3.1680863927533; Fri, 07 Apr
 2023 03:38:47 -0700 (PDT)
Date:   Fri, 07 Apr 2023 03:38:47 -0700
In-Reply-To: <00000000000015ac7905e97ebaed@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000510b2d05f8bca14b@google.com>
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
