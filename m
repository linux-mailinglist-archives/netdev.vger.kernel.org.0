Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AA821E058
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 21:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgGMTCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 15:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGMTCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 15:02:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D283EC061755;
        Mon, 13 Jul 2020 12:02:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C7C4E1295A43F;
        Mon, 13 Jul 2020 12:02:07 -0700 (PDT)
Date:   Mon, 13 Jul 2020 12:02:06 -0700 (PDT)
Message-Id: <20200713.120206.428449983947812863.davem@davemloft.net>
To:     chenweilong@huawei.com
Cc:     kuba@kernel.org, jiri@mellanox.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] rtnetlink: Fix memory(net_device) leak when
 ->newlink fails
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200713075528.141235-1-chenweilong@huawei.com>
References: <20200713075528.141235-1-chenweilong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 12:02:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weilong Chen <chenweilong@huawei.com>
Date: Mon, 13 Jul 2020 15:55:28 +0800

> When vlan_newlink call register_vlan_dev fails, it might return error
> with dev->reg_state = NETREG_UNREGISTERED. The rtnl_newlink should
> free the memory. But currently rtnl_newlink only free the memory which
> state is NETREG_UNINITIALIZED.
 ...
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Weilong Chen <chenweilong@huawei.com>

This needs a Fixes: tag.

Also, can't this bug happen in mainline too?  It's a bug fix and therefore
should target 'net' instead of 'net-next'.
