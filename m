Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B211F26C9
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfKGFQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:16:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33618 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfKGFQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:16:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B38915108908;
        Wed,  6 Nov 2019 21:16:17 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:16:17 -0800 (PST)
Message-Id: <20191106.211617.1179395285730859401.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next] tipc: eliminate the dummy packet in link synching
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106111217.23178-1-tuong.t.lien@dektech.com.au>
References: <20191106111217.23178-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:16:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Wed,  6 Nov 2019 18:12:17 +0700

> When preparing tunnel packets for the link failover or synchronization,
> as for the safe algorithm, we added a dummy packet on the pair link but
> never sent it out. In the case of failover, the pair link will be reset
> anyway. But for link synching, it will always result in retransmission
> of the dummy packet after that.
> We have also observed that such the retransmission at the early stage
> when a new node comes in a large cluster will take some time and hard
> to be done, leading to the repeated retransmit failures and the link is
> reset.
> 
> Since in commit 4929a932be33 ("tipc: optimize link synching mechanism")
> we have already built a dummy 'TUNNEL_PROTOCOL' message on the new link
> for the synchronization, there's no need for the dummy on the pair one,
> this commit will skip it when the new mechanism takes in place. In case
> nothing exists in the pair link's transmq, the link synching will just
> start and stop shortly on the peer side.
> 
> The patch is backward compatible.
> 
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Tested-by: Hoang Le <hoang.h.le@dektech.com.au>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied, thanks Tuong.
