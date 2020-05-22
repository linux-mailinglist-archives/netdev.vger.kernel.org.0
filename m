Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1727D1DF10E
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbgEVV0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730976AbgEVV03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:26:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF526C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 14:26:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 49BF112725EDA;
        Fri, 22 May 2020 14:26:29 -0700 (PDT)
Date:   Fri, 22 May 2020 14:26:28 -0700 (PDT)
Message-Id: <20200522.142628.1582912241162372403.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com
Subject: Re: [PATCH net] felix: Fix initialization of ioremap resources
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590137674-31727-1-git-send-email-claudiu.manoil@nxp.com>
References: <1590137674-31727-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 14:26:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Fri, 22 May 2020 11:54:34 +0300

> The caller of devm_ioremap_resource(), either accidentally
> or by wrong assumption, is writing back derived resource data
> to global static resource initialization tables that should
> have been constant.  Meaning that after it computes the final
> physical start address it saves the address for no reason
> in the static tables.  This doesn't affect the first driver
> probing after reboot, but it breaks consecutive driver reloads
> (i.e. driver unbind & bind) because the initialization tables
> no longer have the correct initial values.  So the next probe()
> will map the device registers to wrong physical addresses,
> causing ARM SError async exceptions.
> This patch fixes all of the above.
> 
> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied and queued up for -stable, thanks.
