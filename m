Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F5463CF24
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 07:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbiK3GRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 01:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiK3GQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 01:16:58 -0500
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063CF2CE33;
        Tue, 29 Nov 2022 22:16:56 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 1764DC009; Wed, 30 Nov 2022 07:17:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669789024; bh=W9hCW6luP/6v5RJwLkkF/k888Scy0g/o6MDl4j/XRHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qbYXVSsGvtKHAF7eNjlThPzJCsV8p735MPlXRJxCrDzXkaEkqurTssSmVozhKGvWg
         f7WWnMHDKFrdEYdBIoL2e5MSqer6hIQQD5RaD+kfE6ahIN9JsdZ7vbVLY6fQeT+WjB
         10BDRsOZYe9din+p6Yx/8dbMXf6zBQUudzj2GizYU1ODww1cR8mY7HHXG3FAFtnfAg
         7/uu/MPtt4TtIbHaK62jxyhf0xTqPmyctdWSNafYU2T4Z8Z6zLDrao8BGWS8Z2nU3i
         9kkrPSZF9ME3Q5nAuu/oW0636DvGsWx1utx8CoNgXfTEgZe1MFQVLjvnxc/Ko50ah8
         o7EtZhTSR6ELA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id B9D6BC009;
        Wed, 30 Nov 2022 07:16:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669789008; bh=W9hCW6luP/6v5RJwLkkF/k888Scy0g/o6MDl4j/XRHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BYFRPQXzBgX7gJTqn47e4RxS/7ps97i2zn3eVZuaHgaKv2hDkmzps3FlohwTNURPd
         71YfW1/fCri2W7mzIphgRoxP+AXz1VfbvcEMmCoRmgZRZVEo2PuUopH9hkqk1A+K2g
         ggwUkEBKG2I0UF4cm7ziFvO8ULQJdWdbOBi9nwzrSnFsKYkCmPbI+9cYMjzonE/OJh
         Zk6tjZMWmgbn6zcedPOwCi/kWIffm/JSk1OF5sXivUZYREfQr+JSPaFP0PYraf6pwE
         Icw/YK9dhvyzzUI7EWbdl5aP2GyqmlcMVK3zlir1r8o2BTTKcj4Mk8NYhTshSNuRYm
         GctMFTzkWI/hw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 074f5648;
        Wed, 30 Nov 2022 06:16:32 +0000 (UTC)
Date:   Wed, 30 Nov 2022 15:16:17 +0900
From:   asmadeus@codewreck.org
To:     Schspa Shi <schspa@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH] 9p: fix crash when transaction killed
Message-ID: <Y4b1MQaEsPRK+3lF@codewreck.org>
References: <20221129162251.90790-1-schspa@gmail.com>
 <Y4aJzjlkkt5VKy0G@codewreck.org>
 <m2r0xli1mq.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m2r0xli1mq.fsf@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(fixed Christophe's address, hopefully that will do for good...)

Schspa Shi wrote on Wed, Nov 30, 2022 at 10:22:44AM +0800:
> > I'm happy to believe we have a race somewhere (even if no sane server
> > would produce it), but right now I don't see it looking at the code.. :/
> 
> And I think there is a race too. because the syzbot report about 9p fs
> memory corruption multi times.

Yes, no point in denying that :)

> As for the problem, the p9_tag_lookup only takes the rcu_read_lock when
> accessing the IDR, why it doesn't take the p9_client->lock? Maybe the
> root cause is that a lock is missing here.

It shouldn't need to, but happy to try adding it.
For the logic:
 - idr_find is RCU-safe (trusting the comment above it)
 - reqs are alloced in a kmem_cache created with SLAB_TYPESAFE_BY_RCU.
 This means that if we get a req from idr_find, even if it has just been
 freed, it either is still in the state it was freed at (hence refcount
 0, we ignore it) or is another req coming from the same cache (if
 refcount isn't zero, we can check its tag)
 The refcount itself is an atomic operation so doesn't require lock.
 ... And in the off chance I hadn't considered that we're already
 dealing with a new request with the same tag here, we'll be updating
 its status so another receive for it shouldn't use it?...

I don't think adding the client lock helps with anything here, but it'll
certainly simplify this logic as we then are guaranteed not to get
obsolete results from idr_find.

Unfortunately adding a lock will slow things down regardless of
correctness, so it might just make the race much harder to hit without
fixing it and we might not notice that, so it'd be good to understand
the race.

-- 
Dominique
