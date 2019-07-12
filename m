Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3A967691
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfGLWeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:34:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbfGLWet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:34:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F25B14E03845;
        Fri, 12 Jul 2019 15:34:49 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:34:48 -0700 (PDT)
Message-Id: <20190712.153448.2014775769142835466.davem@davemloft.net>
To:     chris.packham@alliedtelesis.co.nz
Cc:     jon.maloy@ericsson.com, eric.dumazet@gmail.com,
        ying.xue@windriver.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH v2] tipc: ensure head->lock is initialised
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190711224115.21499-1-chris.packham@alliedtelesis.co.nz>
References: <20190711224115.21499-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:34:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>
Date: Fri, 12 Jul 2019 10:41:15 +1200

> tipc_named_node_up() creates a skb list. It passes the list to
> tipc_node_xmit() which has some code paths that can call
> skb_queue_purge() which relies on the list->lock being initialised.
> 
> The spin_lock is only needed if the messages end up on the receive path
> but when the list is created in tipc_named_node_up() we don't
> necessarily know if it is going to end up there.
> 
> Once all the skb list users are updated in tipc it will then be possible
> to update them to use the unlocked variants of the skb list functions
> and initialise the lock when we know the message will follow the receive
> path.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Applied.
