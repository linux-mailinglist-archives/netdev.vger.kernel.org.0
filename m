Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EFE20008B
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgFSDLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgFSDLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:11:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8215BC06174E;
        Thu, 18 Jun 2020 20:11:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E741C120ED49A;
        Thu, 18 Jun 2020 20:11:30 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:11:30 -0700 (PDT)
Message-Id: <20200618.201130.941014011043746603.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, joakim.tjernlund@infinera.com,
        madalin.bucur@oss.nxp.com, fido_max@inbox.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net 0/2] Reapply DSA fix for dpaa-eth with proper
 Fixes: tag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616151910.3908882-1-olteanv@gmail.com>
References: <20200616151910.3908882-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:11:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 16 Jun 2020 18:19:08 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Joakim notified me that this fix breaks stable trees.
> It turns out that my assessment about who-broke-who was wrong.
> The real Fixes: tag should have been:
> 
> Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")
> 
> which changes the device on which SET_NETDEV_DEV is made.
> 
> git describe --tags 060ad66f97954
> v5.4-rc3-783-g060ad66f9795
> 
> Which means that it shouldn't have been backported to 4.19 and below.
> This series reverts the commit with the misleading commit message, and
> reapplies it with a corrected one. The resulting code is exactly the
> same, but now, the revert should make it to the stable trees (along with
> the bad fix), and the new fix should only make it down to v5.4.y.
> 
> Changes in v2:
> Corrected the reversed sysfs paths in the new commit description.

This is so messy.

What's done is done, just submit the necessary revert to -stable
if necessary and let's not just change things back and forth
because then we'll have two commits which make identical changes
and each having a different Fixes: tag which is confusing.

Thanks.
