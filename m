Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D1327B5A4
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgI1TsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgI1TsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:48:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06F0C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 12:48:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9561214530BC7;
        Mon, 28 Sep 2020 12:31:36 -0700 (PDT)
Date:   Mon, 28 Sep 2020 12:48:23 -0700 (PDT)
Message-Id: <20200928.124823.1821386447234078357.davem@davemloft.net>
To:     razor@blackwall.org
Cc:     netdev@vger.kernel.org, idosch@nvidia.com, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, nikolay@nvidia.com
Subject: Re: [PATCH net] net: bridge: fdb: don't flush ext_learn entries
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928153002.1697183-1-razor@blackwall.org>
References: <20200928153002.1697183-1-razor@blackwall.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 12:31:36 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <razor@blackwall.org>
Date: Mon, 28 Sep 2020 18:30:02 +0300

> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> When a user-space software manages fdb entries externally it should
> set the ext_learn flag which marks the fdb entry as externally managed
> and avoids expiring it (they're treated as static fdbs). Unfortunately
> on events where fdb entries are flushed (STP down, netlink fdb flush
> etc) these fdbs are also deleted automatically by the bridge. That in turn
> causes trouble for the managing user-space software (e.g. in MLAG setups
> we lose remote fdb entries on port flaps).
> These entries are completely externally managed so we should avoid
> automatically deleting them, the only exception are offloaded entries
> (i.e. BR_FDB_ADDED_BY_EXT_LEARN + BR_FDB_OFFLOADED). They are flushed as
> before.
> 
> Fixes: eb100e0e24a2 ("net: bridge: allow to add externally learned entries from user-space")
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Applied and queued up for -stable, thank you.
