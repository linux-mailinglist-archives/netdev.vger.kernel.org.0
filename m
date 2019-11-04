Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA834ED6E9
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 02:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbfKDB1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 20:27:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40296 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfKDB1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 20:27:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2819E150306B5;
        Sun,  3 Nov 2019 17:27:30 -0800 (PST)
Date:   Sun, 03 Nov 2019 17:27:29 -0800 (PST)
Message-Id: <20191103.172729.1947675467703746055.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next] tipc: improve message bundling algorithm
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101025857.27895-1-tuong.t.lien@dektech.com.au>
References: <20191101025857.27895-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 Nov 2019 17:27:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Fri,  1 Nov 2019 09:58:57 +0700

> As mentioned in commit e95584a889e1 ("tipc: fix unlimited bundling of
> small messages"), the current message bundling algorithm is inefficient
> that can generate bundles of only one payload message, that causes
> unnecessary overheads for both the sender and receiver.
> 
> This commit re-designs the 'tipc_msg_make_bundle()' function (now named
> as 'tipc_msg_try_bundle()'), so that when a message comes at the first
> place, we will just check & keep a reference to it if the message is
> suitable for bundling. The message buffer will be put into the link
> backlog queue and processed as normal. Later on, when another one comes
> we will make a bundle with the first message if possible and so on...
> This way, a bundle if really needed will always consist of at least two
> payload messages. Otherwise, we let the first buffer go its way without
> any need of bundling, so reduce the overheads to zero.
> 
> Moreover, since now we have both the messages in hand, we can even
> optimize the 'tipc_msg_bundle()' function, make bundle of a very large
> (size ~ MSS) and small messages which is not with the current algorithm
> e.g. [1400-byte message] + [10-byte message] (MTU = 1500).
> 
> Acked-by: Ying Xue <ying.xue@windreiver.com>
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied.
