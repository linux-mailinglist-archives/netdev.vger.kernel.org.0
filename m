Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67B11AB430
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 01:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389242AbgDOXYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 19:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388353AbgDOXYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 19:24:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0391DC061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 16:24:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 830A1120ED569;
        Wed, 15 Apr 2020 16:24:05 -0700 (PDT)
Date:   Wed, 15 Apr 2020 16:24:04 -0700 (PDT)
Message-Id: <20200415.162404.1740698602850159370.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net] tipc: fix incorrect increasing of link window
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200415113449.7289-1-tuong.t.lien@dektech.com.au>
References: <20200415113449.7289-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Apr 2020 16:24:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Wed, 15 Apr 2020 18:34:49 +0700

> In commit 16ad3f4022bb ("tipc: introduce variable window congestion
> control"), we allow link window to change with the congestion avoidance
> algorithm. However, there is a bug that during the slow-start if packet
> retransmission occurs, the link will enter the fast-recovery phase, set
> its window to the 'ssthresh' which is never less than 300, so the link
> window suddenly increases to that limit instead of decreasing.
> 
> Consequently, two issues have been observed:
> 
> - For broadcast-link: it can leave a gap between the link queues that a
> new packet will be inserted and sent before the previous ones, i.e. not
> in-order.
> 
> - For unicast: the algorithm does not work as expected, the link window
> jumps to the slow-start threshold whereas packet retransmission occurs.
> 
> This commit fixes the issues by avoiding such the link window increase,
> but still decreasing if the 'ssthresh' is lowered.
> 
> Fixes: 16ad3f4022bb ("tipc: introduce variable window congestion control")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied, thanks.
