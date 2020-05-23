Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8791DFBE4
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 01:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388179AbgEWXfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 19:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388010AbgEWXfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 19:35:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F61C061A0E;
        Sat, 23 May 2020 16:35:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C92821286F3AD;
        Sat, 23 May 2020 16:35:20 -0700 (PDT)
Date:   Sat, 23 May 2020 16:35:19 -0700 (PDT)
Message-Id: <20200523.163519.974222011620661089.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        s-anna@ti.com
Subject: Re: [PATCH] net: ethernet: ti: cpsw: fix ASSERT_RTNL() warning
 during suspend
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200522163931.29905-1-grygorii.strashko@ti.com>
References: <20200522163931.29905-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 16:35:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Fri, 22 May 2020 19:39:31 +0300

> vlan_for_each() are required to be called with rtnl_lock taken, otherwise
> ASSERT_RTNL() warning will be triggered - which happens now during System
> resume from suspend:
>   cpsw_suspend()
>   |- cpsw_ndo_stop()
>     |- __hw_addr_ref_unsync_dev()
>       |- cpsw_purge_all_mc()
>          |- vlan_for_each()
>             |- ASSERT_RTNL();
> 
> Hence, fix it by surrounding cpsw_ndo_stop() by rtnl_lock/unlock() calls.
> 
> Fixes: 15180eca569b net: ethernet: ti: cpsw: fix vlan mcast
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied.
