Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C3F57341B
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 12:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbiGMK0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 06:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbiGMK0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 06:26:31 -0400
Received: from sender-of-o51.zoho.in (sender-of-o51.zoho.in [103.117.158.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A6BFA1FF;
        Wed, 13 Jul 2022 03:26:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1657707964; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=dUgWn6/KIJX2uGvOjKROALW0iiHiD8tCXA0L4icng/TKqj/7bpqhHJa7QI5xp0d3h1s22rhFulBLPelldSz4YymxMmz6FftgVx6jVstojkwn0aehXhsUkLQzjy7DC608xwM0PaXapNN2oC+0y/3siWYd8AF/m2AcDDAlPsymGXM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1657707964; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=GlzuiTICO7ytWAr2jHwzvgyOA9t02wlMJZBcRQKp8PY=; 
        b=OpbOTL3276v1TzE/gLTSppD2GwgQ+k+4yjq6QTFe/7f4c4yISyK3E5friaaDwT0ZsicT3ViBavTKj5iz5TpTw9/uU3b82Rdinas7YbykJthqXpvyiRAvlcTT4cJ/a6WrPFuhNoFJFk0nzHmXYVNtsBSfh7mSMqEsrN7hx+PGHl0=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1657707964;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=GlzuiTICO7ytWAr2jHwzvgyOA9t02wlMJZBcRQKp8PY=;
        b=biYNvDHoEHCzNoZFmTtDRuK4Pxk30Q+JOrqskLnp1ThwCPx84KH6mhzRUSmM1sLO
        2B4i/+YjDmecmNgurJlr0wTOvexksPDeh3j06+tb57+k+4VUSfuIiAz3Ka47hgH49N7
        mZ7eFk+f8NcUO7l9IDnDeuAizOOZIAZhY38b1Was=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1657707954217735.5614916678297; Wed, 13 Jul 2022 15:55:54 +0530 (IST)
Date:   Wed, 13 Jul 2022 15:55:54 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "syzbot" <syzbot+7a942657a255a9d9b18a@syzkaller.appspotmail.com>
Cc:     "davem" <davem@davemloft.net>,
        "johannes" <johannes@sipsolutions.net>, "kuba" <kuba@kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "netdev" <netdev@vger.kernel.org>,
        "syzkaller-bugs" <syzkaller-bugs@googlegroups.com>
Message-ID: <181f7180015.1ea4d3b3328398.7889962633178976958@siddh.me>
In-Reply-To: <000000000000a4271f05e3ac1ff8@google.com>
References: <000000000000a4271f05e3ac1ff8@google.com>
Subject: Re: [syzbot] memory leak in cfg80211_inform_single_bss_frame_data
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot didn't give full log (did it crash?), so trying again.

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

On Wed, 13 Jul 2022 14:38:08 +0530  syzbot <syzbot+7a942657a255a9d9b18a@syzkaller.appspotmail.com> wrote
 > Hello,
 > 
 > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
 > memory leak in regulatory_init_db
 > 
 > BUG: memory leak
 > unreferenced object 0xffff8881450dc880 (size 64):
 >   comm "swapper/0", pid 1, jiffies 4294937974 (age 80.900s)
 >   hex dump (first 32 bytes):
 >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 >     ff ff ff ff 00 00 00 00 00 00 00 00 30 30 00 00  ............00..
 >   backtrace:
 >     [<ffffffff86ff026b>] kmalloc include/linux/slab.h:600 [inline]
 >     [<ffffffff86ff026b>] kzalloc include/linux/slab.h:733 [inline]
 >     [<ffffffff86ff026b>] regulatory_hint_core net/wireless/reg.c:3216 [inline]
 >     [<ffffffff86ff026b>] regulatory_init_db+0x22f/0x2de net/wireless/reg.c:4277
 >     [<ffffffff81000fe3>] do_one_initcall+0x63/0x2e0 init/main.c:1295
 >     [<ffffffff86f4eb10>] do_initcall_level init/main.c:1368 [inline]
 >     [<ffffffff86f4eb10>] do_initcalls init/main.c:1384 [inline]
 >     [<ffffffff86f4eb10>] do_basic_setup init/main.c:1403 [inline]
 >     [<ffffffff86f4eb10>] kernel_init_freeable+0x255/0x2cf init/main.c:1610
 >     [<ffffffff845b427a>] kernel_init+0x1a/0x1c0 init/main.c:1499
 >     [<ffffffff8100225f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 > 
 > [   88.
 > 
 > 
 > Tested on:
 > 
 > commit:         b047602d Merge tag 'trace-v5.19-rc5' of git://git.kern..
 > git tree:       upstream
 > console output: https://syzkaller.appspot.com/x/log.txt?x=13d4252a080000
 > kernel config:  https://syzkaller.appspot.com/x/.config?x=689b5fe7168a1260
 > dashboard link: https://syzkaller.appspot.com/bug?extid=7a942657a255a9d9b18a
 > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
 > 
 > Note: no patches were applied.
 > 
