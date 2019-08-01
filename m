Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5AB7DCA4
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 15:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfHANjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 09:39:54 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40882 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725804AbfHANjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 09:39:54 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from dmitrolin@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 Aug 2019 16:39:51 +0300
Received: from dev-r-vrt-111.mtr.labs.mlnx (dev-r-vrt-111.mtr.labs.mlnx [10.212.111.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x71DdpmF007443;
        Thu, 1 Aug 2019 16:39:51 +0300
Received: from dev-r-vrt-111.mtr.labs.mlnx (localhost [127.0.0.1])
        by dev-r-vrt-111.mtr.labs.mlnx (8.14.7/8.14.7) with ESMTP id x71DdpDm000857;
        Thu, 1 Aug 2019 13:39:51 GMT
Received: (from dmitrolin@localhost)
        by dev-r-vrt-111.mtr.labs.mlnx (8.14.7/8.14.7/Submit) id x71DdnIH000856;
        Thu, 1 Aug 2019 13:39:49 GMT
Date:   Thu, 1 Aug 2019 13:39:49 +0000
From:   Dmytro Linkin <dmitrolin@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@resnulli.us, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH] net: sched: use temporary variable for actions indexes
Message-ID: <20190801133947.GA32368@mellanox.com>
References: <1564664571-31508-1-git-send-email-dmitrolin@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564664571-31508-1-git-send-email-dmitrolin@mellanox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 01:02:51PM +0000, dmitrolin@mellanox.com wrote:
> From: Dmytro Linkin <dmitrolin@mellanox.com>
> 
> Currently init call of all actions (except ipt) init their 'parm'
> structure as a direct pointer to nla data in skb. This leads to race
> condition when some of the filter actions were initialized successfully
> (and were assigned with idr action index that was written directly
> into nla data), but then were deleted and retried (due to following
> action module missing or classifier-initiated retry), in which case
> action init code tries to insert action to idr with index that was
> assigned on previous iteration. During retry the index can be reused
> by another action that was inserted concurrently, which causes
> unintended action sharing between filters.
> To fix described race condition, save action idr index to temporary
> stack-allocated variable instead on nla data.
> 
> Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
> Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> ---

Hi,
Forgot to add target branch - net

Sincerely,
Dmytro
