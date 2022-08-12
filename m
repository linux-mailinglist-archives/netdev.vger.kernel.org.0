Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FC1591694
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 23:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbiHLVEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 17:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbiHLVEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 17:04:43 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9616FB4409
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 14:04:42 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id w7-20020a5d9607000000b0067c6030dfb8so1224262iol.10
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 14:04:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=CqAP7/erwabYfZcEqDajpmAewsF59PsJ5bWHrsgdEGI=;
        b=FEJgCaUZgSYPUIxJ4YiZrstuGY56pyKzKsegXdqtCDjkQMXp11t8alX+hloc/1/gWP
         VDGHlQMCdnXyopJwUNMdCeMtzCw3mA5U2/LOCAJ4Oo9932CA5LMiVMPXhwSo+PLLweX2
         riadRkIE5PsdqR/Jr3LV7E2SCEajATIFKzAjKD+1eDsyQz5KaTFj/yQxaQHEfb7uAbzO
         ZNVX3e0m5jd02mMKG+vSMykLEOft30OCmid5mwMJtraPDq8mvFyIQs+GzTgf7BTe126H
         e3iJvZo6c+cjqOxfW6eL4yjdJf+RabpUgS6hY0mI5901GpC/3FK/EIVA8i81pgsD6YYJ
         3Dhg==
X-Gm-Message-State: ACgBeo1GWaYyzehwkGdr0ies00msuKtseyC1TmiGSNOvj2hpWJW9i0tL
        LG2tEV1zs1qc7V9sjWhH1Rfpqb7Lu0gbUQPUHPnbDYWqkUSo
X-Google-Smtp-Source: AA6agR41mVj/xh13nLXVSDnRQYc6cKY6oZWjSheQQKcb41XlCnsB5BUVCRbV9DspI9xzhbrPfISPofF6+HlqRCpSmqjyrUoK1J2R
MIME-Version: 1.0
X-Received: by 2002:a05:6638:270e:b0:343:6da4:6738 with SMTP id
 m14-20020a056638270e00b003436da46738mr1318672jav.263.1660338281929; Fri, 12
 Aug 2022 14:04:41 -0700 (PDT)
Date:   Fri, 12 Aug 2022 14:04:41 -0700
In-Reply-To: <20220812140439.6bb2bb17@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000080646c05e611a198@google.com>
Subject: Re: [syzbot] memory leak in netlink_policy_dump_add_policy
From:   syzbot <syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, 12 Aug 2022 10:04:26 -0700 syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    4e23eeebb2e5 Merge tag 'bitmap-6.0-rc1' of https://github...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=165f4f6a080000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3a433c7a2539f51c
>> dashboard link: https://syzkaller.appspot.com/bug?extid=dc54d9ba8153b216cae0
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1443be71080000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e5918e080000
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com
>
> Let's see if attaching a patch works...
>
> #syz test

want 2 args (repo, branch), got 1

