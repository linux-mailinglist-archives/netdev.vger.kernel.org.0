Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA315212EC9
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgGBVZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBVZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 17:25:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5182FC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 14:25:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B1C21282F6F9;
        Thu,  2 Jul 2020 14:25:06 -0700 (PDT)
Date:   Thu, 02 Jul 2020 14:25:05 -0700 (PDT)
Message-Id: <20200702.142505.302089629790561856.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net/sched: act_ct: fix restore the
 qdisc_skb_cb after defrag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <89404b82-71b8-c94d-1e0b-11e3755da0b3@ucloud.cn>
References: <1593422178-26949-1-git-send-email-wenxu@ucloud.cn>
        <20200701.152116.1519098438346883237.davem@davemloft.net>
        <89404b82-71b8-c94d-1e0b-11e3755da0b3@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jul 2020 14:25:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>
Date: Thu, 2 Jul 2020 17:17:47 +0800

> On 7/2/2020 6:21 AM, David Miller wrote:
>> From: wenxu@ucloud.cn
>> Date: Mon, 29 Jun 2020 17:16:17 +0800
>>
>> Nothing can clobber the qdisc_skb_cb like this in these packet flows
>> otherwise we will have serious crashes and problems.  Some packet
>> schedulers store pointers in the qdisc CB private area, for example.
> Why store all the cb private and restore it can't total fix this?

Parallel accesses to the SKB.
