Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24AB65F13B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 17:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbjAEQcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 11:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjAEQcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 11:32:22 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E2DC3C
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 08:32:21 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id i14-20020a056e020d8e00b003034b93bd07so23220968ilj.14
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 08:32:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H9UZRTW63lyBpIsMbIymTiTuR3DtdqS+1wAO4zv1bzA=;
        b=5a+SAomLhq8wxNSPtnCddITD/h29OWUk4y4byqy0WZfrJV1Qy+sc57Oon7twuh0iiU
         auS5ulD3MBZKYnJ/PrqPl+BPyM6pXCBt7ReEKQbGAvrVfQJc/8awqG7w55BZuYhGC7Mk
         E5cvEeNwH4UxplSwkDTmpTNtCuPzA99zVusKit8mCGTmIyjcP9foxT8nke6+AaCTpxFT
         RCYSpnlN1BOfPQK540NU5HUW/+DsHlTN36Zjm9MWIw4ExhEbAE2ZKgze8apnS9SBxyF3
         AKk5RDpzPm/RUsmuAyd0kXuPER2oc+WkdM1s249a/upuTDEyRFbDFzDfiTFcRT2P63Qe
         zTfg==
X-Gm-Message-State: AFqh2kocyX7TEZYd43kB633UVyKzBAMfPu8eY416Q0McGqVJVR6ybhpz
        eaFo1MI0cxAqAmjL2FthKZUDyNDJilHTz7OFJ3ODEDZW0i2a
X-Google-Smtp-Source: AMrXdXtlM6VyGycOdbOg1yBWuqAd36l5/buD3Qu67mKOwbzYX00LMjt9rBA8FAKiKO2tQKi11yNFO+ng8L9YtxCkwUfDzFU7Yk1X
MIME-Version: 1.0
X-Received: by 2002:a6b:4a06:0:b0:6bf:e923:388b with SMTP id
 w6-20020a6b4a06000000b006bfe923388bmr4098019iob.105.1672936341080; Thu, 05
 Jan 2023 08:32:21 -0800 (PST)
Date:   Thu, 05 Jan 2023 08:32:21 -0800
In-Reply-To: <594704.1672934598@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000057916a05f186d851@google.com>
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

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5529 } 2650 jiffies s: 2809 root: 0x0/T
rcu: blocking rcu_node structures (internal RCU debug):


Tested on:

commit:         a5852d90 rxrpc: Move client call connection to the I/O..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/
console output: https://syzkaller.appspot.com/x/log.txt?x=13297ee6480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=90282e312d5fd612
dashboard link: https://syzkaller.appspot.com/bug?extid=c22650d2844392afdcfd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
