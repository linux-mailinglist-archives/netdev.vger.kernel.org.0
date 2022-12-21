Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DE365350A
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 18:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiLURZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 12:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiLURZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 12:25:23 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EBCDB
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 09:25:22 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id y5-20020a056e021be500b0030bc4f23f0aso3262602ilv.3
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 09:25:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q0PUte3sp9HDP/rACJdC0oj7M7IRvP+PhijoBn0zNu0=;
        b=QagjMSaaD+ulNLG7lbDTZBDCyNQW/dXshAYiVihu7kOlnV9sZ4doEh34Y/biK1pO2p
         Gthzs7nf5R+YLaSmwg8RF+9A5z+rbcHt4yXSQEnu/GtXeP3+7eg3BRVh0nzGDT2SrBGr
         xQJCXXc11weJgcb+/095wAfpEPk4i0bi5iMID1BG32HUo++bpyQudas2Gcl+QX7SYrmN
         JZTETGcaaNC0y1I8Pjnq65uIfs/9iqCGOob+wnQ1bQUwyJj3O71IRJaHPtCZ659Ro8ZU
         R9ksqwIeov8nWD+crRO2j1GpkaZm8cpIfxc5khFXW4MP0z66VZsWpo6QWvwbbwro0BeL
         pRbg==
X-Gm-Message-State: AFqh2kph/aYhja9/CVf/RH4gihIPJyj0WQP6PNo17z9SBBNOTseetKIZ
        MaMLI+1FIqibJcLQMlqeF+nPbVMDUpe4rEOItebfWrQjKT+r
X-Google-Smtp-Source: AMrXdXsJehSdKjkHzU33PVwaMqMzUvTgJcf2FavR2Y4GV/4Lqa5OVT1WC0yLmD75g3ymPsmopaki4ZDR8PfMiH0l+ozm3+QZk+gh
MIME-Version: 1.0
X-Received: by 2002:a92:2c07:0:b0:302:fe4d:3b9f with SMTP id
 t7-20020a922c07000000b00302fe4d3b9fmr238387ile.54.1671643521685; Wed, 21 Dec
 2022 09:25:21 -0800 (PST)
Date:   Wed, 21 Dec 2022 09:25:21 -0800
In-Reply-To: <2062619.1671641039@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004d21ce05f059d6be@google.com>
Subject: Re: [syzbot] kernel BUG in rxrpc_put_peer
From:   syzbot <syzbot+c22650d2844392afdcfd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: rcu detected stall in corrupted

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5786 } 2640 jiffies s: 2805 root: 0x0/T
rcu: blocking rcu_node structures (internal RCU debug):


Tested on:

commit:         97f46a2a afs: Fix lost servers_outstanding count
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/
console output: https://syzkaller.appspot.com/x/log.txt?x=16357637880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
dashboard link: https://syzkaller.appspot.com/bug?extid=c22650d2844392afdcfd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
