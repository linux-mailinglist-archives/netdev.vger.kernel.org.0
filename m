Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90A059D294
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 09:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241219AbiHWHts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 03:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240751AbiHWHtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 03:49:46 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379CD647FC;
        Tue, 23 Aug 2022 00:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=lvhKkD2SiUkfZrNaCvWY8hjl/Esl8oJlHMjWqxYStSY=;
        t=1661240985; x=1662450585; b=e3ajiB9UuWhwvUZf2oagZ3VDm0wG6qLP9k0LFyjW+SwHTaQ
        ZKaK5B+YVYqDeuF4d9u52th/lisjf1F/Z29R7tzSbNv/YxVVHM72lakUfP/8kdK9S4OAmQT6P1iF+
        y516VjUKpDAnzIwf2VSnIplPFtxY3WQ0HdlYlhzENt6HqI44Sn/f1E6ZbI+JJeTakgi+jO0jRo1oc
        T3KkolcBihB10NPgBmGYMEnplQJ4JS1LRa/2Dqi/unEEZ3hr9B0+8DEI18HFgZz19jMcV99ISokOW
        l8grC4YaPqSVgETaB+Sa0BqxwPfAQrYbWV21V2cdrU3uLPuA5rtiws/mhSV2PswQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oQOfF-00FIlL-17;
        Tue, 23 Aug 2022 09:49:33 +0200
Message-ID: <9e81fbb3b994b1228e6cfb1c550fe35e11508adb.camel@sipsolutions.net>
Subject: Re: [syzbot] upstream boot error: stack segment fault in __alloc_skb
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+b8a1f71feb027c4e2f06@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org
Date:   Tue, 23 Aug 2022 09:49:32 +0200
In-Reply-To: <20220822172703.4d96f5b5@kernel.org>
References: <0000000000002282c605e6b6c0e1@google.com>
         <20220822172703.4d96f5b5@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Does mac80211 hwsim size something in the family based on user input=20
> or such?

Hmm, maybe, but certainly not in this path?

> > mac80211_hwsim: initializing netlink
> > stack segment: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc1-syzkaller-00017-g3c=
c40a443a04 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 07/22/2022
> > RIP: 0010:__kmalloc_node_track_caller+0x17a/0x3f0 mm/slub.c:4955
> > Code: 00 48 c1 e8 3a 44 39 f0 0f 85 24 01 00 00 49 8b 3c 24 40 f6 c7 0f=
 0f 85 73 02 00 00 45 84 c0 0f 84 6c 02 00 00 41 8b 44 24 28 <48> 8b 5c 05 =
00 48 8d 4a 08 48 89 e8 65 48 0f c7 0f 0f 94 c0 a8 01
> > RSP: 0000:ffffc90000067858 EFLAGS: 00010202
> > RAX: 0000000000000800 RBX: 0000000000082cc0 RCX: 0000000000000000
> > RDX: 0000000000003088 RSI: 0000000000082cc0 RDI: 000000000003d960
> > RBP: ffff000000000000 R08: dffffc0000000001 R09: fffffbfff1c4ade6
> > R10: fffffbfff1c4ade6 R11: 1ffffffff1c4ade5 R12: ffff888012042140
> > R13: 0000000000082cc0 R14: 00000000ffffffff R15: 0000000000001000
> > FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffff88823ffff000 CR3: 000000000ca8e000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  kmalloc_reserve net/core/skbuff.c:358 [inline]
> >  __alloc_skb+0x11d/0x620 net/core/skbuff.c:430
> >  alloc_skb include/linux/skbuff.h:1257 [inline]
> >  nlmsg_new include/net/netlink.h:953 [inline]
> >  ctrl_build_mcgrp_msg net/netlink/genetlink.c:997 [inline]
> >  genl_ctrl_event+0x16f/0xc40 net/netlink/genetlink.c:1083
> >  genl_register_family+0x10df/0x1390 net/netlink/genetlink.c:432
> >  hwsim_init_netlink+0x21/0x9b drivers/net/wireless/mac80211_hwsim.c:497=
2
> >  init_mac80211_hwsim+0x185/0xa08 drivers/net/wireless/mac80211_hwsim.c:=
5285

It's just calling genl_register_family(), basically?

init_mac80211_hwsim() shouldn't have much of a stack frame,
neither does genl_register_family() nor any of the other functions here?

Strange.

But wait, this was reported against rc1, and we had a TON of syzbot
failures on rc1 because of the virtio patches - I was previously told to
mostly disregard them.

johannes

