Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4354F1B37
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379534AbiDDVTu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 4 Apr 2022 17:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380276AbiDDT1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 15:27:11 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EA926AD7
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 12:25:15 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id q11-20020a056e02106b00b002ca4677e013so1838014ilj.10
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 12:25:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=kmWFJFj34/4zFHaivaN7YD9rve+XHxpxZd65FGGyjrQ=;
        b=5vl8finypkXIeyV0naUPbDB5pwWZH3TTsEOMmBkU7BamA1F39QiZFoL92mA8r4Jui8
         xLW0GOjNuE+1Xeoc/Ngo+fzYcW3Dt+y+8vbhJjpxDahAS+78Tcgj98M/MKAKvuCUa5tw
         e/Gu/5PFtvmqiUenctrbF1odtDj17AVYANYpJ6Hxn1+TC9G2waHbvF0fHioBuJirf1WI
         +dcnfWK5SrKS4gMxzXDY46r9X2MYLGo8zS9bWQKLx40cCZg+Ph5sBFoK8o0JB6YpMhiW
         CUZhtTVjnO+3rgBkOfIvw8hmPSF1cfhxfX6AowShOX1EZmZcnWQV8mwMcnD+QNU/cFVW
         nT6w==
X-Gm-Message-State: AOAM533NzfLRH2mdXfDuNcGhU7LP+o8D2EDAXYqGpCK5MyvLCRenWPaH
        QZlwALTGjZM2UEjPFhYhYwOISxYA9BvLV0mfPO2tRvs0eIAt
X-Google-Smtp-Source: ABdhPJwu0I+tkB37kU2Qzn6gi2n1zL0hp4u1Zi1zgPa4Zh1RdJP9BTUrQKrvjyQW2pqi/qB2v0WNoXpnUj34T7J5r8Tmxqtwtswv
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa7:b0:2ca:52e8:b500 with SMTP id
 l7-20020a056e021aa700b002ca52e8b500mr676538ilv.34.1649100314393; Mon, 04 Apr
 2022 12:25:14 -0700 (PDT)
Date:   Mon, 04 Apr 2022 12:25:14 -0700
In-Reply-To: <000000000000264b2a05d44bca80@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000070561105dbd91673@google.com>
Subject: Re: [syzbot] WARNING in cpuset_write_resmask
From:   syzbot <syzbot+568dc81cd20b72d4a49f@syzkaller.appspotmail.com>
To:     cgroups@vger.kernel.org, changbin.du@intel.com,
        christian.brauner@ubuntu.com, davem@davemloft.net,
        edumazet@google.com, hannes@cmpxchg.org, hkallweit1@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        lizefan.x@bytedance.com, longman@redhat.com, mkoutny@suse.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tj@kernel.org, yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit d068eebbd4822b6c14a7ea375dfe53ca5c69c776
Author: Michal Koutný <mkoutny@suse.com>
Date:   Fri Dec 17 15:48:54 2021 +0000

    cgroup/cpuset: Make child cpusets restrict parents on v1 hierarchy

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=142f17f7700000
start commit:   e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
git tree:       bpf-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
dashboard link: https://syzkaller.appspot.com/bug?extid=568dc81cd20b72d4a49f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bb97ce700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12062c8e700000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: cgroup/cpuset: Make child cpusets restrict parents on v1 hierarchy

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
