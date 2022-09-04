Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8657D5AC2FF
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 08:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiIDGgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 02:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiIDGgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 02:36:42 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803A8419A4
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 23:36:41 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 03196C01F; Sun,  4 Sep 2022 08:36:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1662273398; bh=vo0PzcqfZdB7v2WKBCprMAW2PfLekN8nXdXP83De8XE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lF2dEfNoL81aIxauOVxtWeJMd9/bNZs1p3RG1RS1QhQXhBXjZq+sUc5cZFTgdK2Up
         BF6KqXVojetL6tWJGv6e7iSz3AZccS9ZpLu/OWvKucKy6zG0sDpgsWZRXNQwAqzX3V
         VTifXGD/XW85mOylJLmxKEejaM+MeROd0I7VupQ1E1x2niLoc86o4TEJZvp8WSZqcb
         1K2BjD2gm9Qn4NzcQXkBH1jciwEjNRyJwpzT269P6tt1q6tKwtNL1XPF9mgoRcBRnU
         WdLhCkp+zllnsGWEGJo4xKmjtc7RMD3sSOuaIG8XdDjmt6jjn6mU2jKLDuyfpkDqGQ
         4D0os4tomomIg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id C5E2CC009;
        Sun,  4 Sep 2022 08:36:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1662273397; bh=vo0PzcqfZdB7v2WKBCprMAW2PfLekN8nXdXP83De8XE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UsxqbDmCpsrmK58EgJvQynOpthIZ0ME8zhkEv9qT7xfReGtlMwU1J3wxZ9BRp/WwE
         66YpbVoyz1uUGDTck0b+COkuUTk/1YMsCYQDLCU+ooV0lITWn+VRYHUtvMzvqbyD5+
         nmM6SJuhPTbIpqas8skEPEq0xbm8qiOtwoZuoYnXgk3JgZvp+Rfx7WcWctFC9OroKl
         YNcdxYOjifDD7J/OBVXElvP83ZIYW5Y70XoAi0zQibwFryM/SAL2IgXCS874PhooH4
         l83lSuJkjIBZ8uybl8EQzsEHaSszSHrMXMr7+aPAmwyplaQ5xain2xJBvs55GjLesj
         VEa8RThZbmJ4A==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 0bc3a777;
        Sun, 4 Sep 2022 06:36:32 +0000 (UTC)
Date:   Sun, 4 Sep 2022 15:36:17 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        syzbot <syzbot+2f20b523930c32c160cc@syzkaller.appspotmail.com>,
        v9fs-developer@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net/9p: use a dedicated spinlock for modifying IDR
Message-ID: <YxRHYaqqISAr5Rif@codewreck.org>
References: <000000000000f842c805e64f17a8@google.com>
 <2470e028-9b05-2013-7198-1fdad071d999@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2470e028-9b05-2013-7198-1fdad071d999@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa wrote on Sun, Sep 04, 2022 at 03:09:28PM +0900:
> syzbot is reporting inconsistent lock state in p9_req_put(), for
> p9_tag_remove() from p9_req_put() from IRQ context is using
> spin_lock_irqsave() on "struct p9_client"->lock but other locations
> not from IRQ context are using spin_lock().

Ah, I was wondering what this problem could have been, but it's yet
another instance of trans_fd abusing the client's lock when it really
should get its own...
I didn't realize mixing spin_lock_irq*() and spin_lock() was the
problem, thank you.

> Since spin_lock() => spin_lock_irqsave() conversion on this lock will
> needlessly disable IRQ for infrequent event, and p9_tag_remove() needs
> to disable IRQ only for modifying IDR (RCU read lock can be used for
> reading IDR), let's introduce a spinlock dedicated for serializing
> idr_alloc()/idr_alloc_u32()/idr_remove() calls. Since this spinlock
> will be held as innermost lock, circular locking dependency problem
> won't happen by adding this spinlock.

We have an idr per client though so this is needlessly adding contention
between multiple 9p mounts.

That probably doesn't matter too much in the general case, but adding a
different lock per connection is cheap so let's do it the other way
around: could you add a lock to the p9_conn struct in net/9p/trans_fd.c
and replace c->lock by it there?
That should have identical effect as other transports don't use client's
.lock ; and the locking in trans_fd.c is to protect req's status and
trans_fd's own lists which is orthogonal to client's lock that protects
tag allocations. I agree it should work in theory.

(If you don't have time to do this this patch has been helpful enough and
I can do it eventually)

Thanks,
--
Dominique
