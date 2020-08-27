Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA35254A63
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 18:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgH0QR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 12:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgH0QRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 12:17:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A84DC061264;
        Thu, 27 Aug 2020 09:16:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 253F6127EB110;
        Thu, 27 Aug 2020 09:00:04 -0700 (PDT)
Date:   Thu, 27 Aug 2020 09:16:49 -0700 (PDT)
Message-Id: <20200827.091649.638150315608329579.davem@davemloft.net>
To:     m-karicheri2@ti.com
Cc:     kuba@kernel.org, grygorii.strashko@ti.com, nsekhar@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4] net: ethernet: ti: cpsw_new: fix error handling
 in cpsw_ndo_vlan_rx_kill_vid()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827143839.32327-1-m-karicheri2@ti.com>
References: <20200827143839.32327-1-m-karicheri2@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 09:00:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Thu, 27 Aug 2020 10:38:39 -0400

> This patch fixes a bunch of issues in cpsw_ndo_vlan_rx_kill_vid()
> 
>  - pm_runtime_get_sync() returns non zero value. This results in
>    non zero value return to caller which will be interpreted as error.
>    So overwrite ret with zero.
>  - If VID matches with port VLAN VID, then set error code.
>  - Currently when VLAN interface is deleted, all of the VLAN mc addresses
>    are removed from ALE table, however the return values from ale function
>    calls are not checked. These functions can return error code -ENOENT.
>    But that shouldn't happen in a normal case. So add error print to
>    catch the situations so that these can be investigated and addressed.
>    return zero in these cases as these are not real error case, but only
>    serve to catch ALE table update related issues and help address the
>    same in the driver.
> 
> Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Applied and queued up for -stable, thanks.
