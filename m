Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA13A401B
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfH3WHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:07:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42656 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbfH3WHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:07:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35B5E154FFAFD;
        Fri, 30 Aug 2019 15:07:10 -0700 (PDT)
Date:   Fri, 30 Aug 2019 15:07:09 -0700 (PDT)
Message-Id: <20190830.150709.478421783835117542.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, marc.dionne@auristor.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix lack of conn cleanup when local
 endpoint is cleaned up [ver #2]
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156708433176.26714.15112030261308314860.stgit@warthog.procyon.org.uk>
References: <156708433176.26714.15112030261308314860.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 15:07:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 29 Aug 2019 14:12:11 +0100

> When a local endpoint is ceases to be in use, such as when the kafs module
> is unloaded, the kernel will emit an assertion failure if there are any
> outstanding client connections:
> 
> 	rxrpc: Assertion failed
> 	------------[ cut here ]------------
> 	kernel BUG at net/rxrpc/local_object.c:433!
> 
> and even beyond that, will evince other oopses if there are service
> connections still present.
> 
> Fix this by:
 ...
> Only after destroying the connections can we close the socket lest we get
> an oops in a workqueue that's looking at a connection or a peer.
> 
> Fixes: 3d18cbb7fd0c ("rxrpc: Fix conn expiry timers")
> Signed-off-by: David Howells <dhowells@redhat.com>
> Tested-by: Marc Dionne <marc.dionne@auristor.com>

Applied.
