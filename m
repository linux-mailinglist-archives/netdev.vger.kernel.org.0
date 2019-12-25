Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B927612A534
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 01:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfLYAPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 19:15:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58006 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfLYAPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 19:15:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C497C154CCC3F;
        Tue, 24 Dec 2019 16:15:39 -0800 (PST)
Date:   Tue, 24 Dec 2019 16:15:39 -0800 (PST)
Message-Id: <20191224.161539.500554691107655943.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/3] rxrpc: Fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <157688311975.18694.10870615714269857980.stgit@warthog.procyon.org.uk>
References: <157688311975.18694.10870615714269857980.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 16:15:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Fri, 20 Dec 2019 23:05:19 +0000

> 
> Here are a couple of bugfixes plus a patch that makes one of the bugfixes
> easier:
> 
>  (1) Move the ping and mutex unlock on a new call from rxrpc_input_packet()
>      into rxrpc_new_incoming_call(), which it calls.  This means the
>      lock-unlock section is entirely within the latter function.  This
>      simplifies patch (2).
> 
>  (2) Don't take the call->user_mutex at all in the softirq path.  Mutexes
>      aren't allowed to be taken or released there and a patch was merged
>      that caused a warning to be emitted every time this happened.  Looking
>      at the code again, it looks like that taking the mutex isn't actually
>      necessary, as the value of call->state will block access to the call.
> 
>  (3) Fix the incoming call path to check incoming calls earlier to reject
>      calls to RPC services for which we don't have a security key of the
>      appropriate class.  This avoids an assertion failure if YFS tries
>      making a secure call to the kafs cache manager RPC service.
> 
> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-fixes-20191220

Pulled, thanks David.
