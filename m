Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A656123937
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfLQWRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:17:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43650 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfLQWRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:17:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4044E1473DC0B;
        Tue, 17 Dec 2019 14:17:19 -0800 (PST)
Date:   Tue, 17 Dec 2019 14:17:18 -0800 (PST)
Message-Id: <20191217.141718.1870382028958768011.davem@davemloft.net>
To:     jon.maloy@ericsson.com
Cc:     netdev@vger.kernel.org, tung.q.nguyen@dektech.com.au,
        hoang.h.le@dektech.com.au, lxin@redhat.com, shuali@redhat.com,
        ying.xue@windriver.com, edumazet@google.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next 1/1] tipc: don't send gap blocks in ACK messages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576520462-25952-1-git-send-email-jon.maloy@ericsson.com>
References: <1576520462-25952-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 14:17:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>
Date: Mon, 16 Dec 2019 19:21:02 +0100

> In the commit referred to below we eliminated sending of the 'gap'
> indicator in regular ACK messages, reserving this to explicit NACK
> ditto.
> 
> Unfortunately we missed to also eliminate building of the 'gap block'
> area in ACK messages. This area is meant to report gaps in the
> received packet sequence following the initial gap, so that lost
> packets can be retransmitted earlier and received out-of-sequence
> packets can be released earlier. However, the interpretation of those
> blocks is dependent on a complete and correct sequence of gaps and
> acks. Hence, when the initial gap indicator is missing a single gap
> block will be interpreted as an acknowledgment of all preceding
> packets. This may lead to packets being released prematurely from the
> sender's transmit queue, with easily predicatble consequences.
> 
> We now fix this by not building any gap block area if there is no
> initial gap to report.
> 
> Fixes: commit 02288248b051 ("tipc: eliminate gap indicator from ACK messages")
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>

Applied, thanks Jon.
