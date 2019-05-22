Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2282926A8E
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbfEVTJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:09:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60506 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbfEVTJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:09:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D5D8414FFA565;
        Wed, 22 May 2019 12:09:06 -0700 (PDT)
Date:   Wed, 22 May 2019 12:09:06 -0700 (PDT)
Message-Id: <20190522.120906.745446103879620889.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        pavel@denx.de, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] ocelot: Dont allocate another multicast list, use
 __dev_mc_sync
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558457575-13784-1-git-send-email-claudiu.manoil@nxp.com>
References: <1558457575-13784-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 12:09:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Tue, 21 May 2019 19:52:55 +0300

> Doing kmalloc in atomic context is always an issue,
> more so for a list that can grow significantly.
> Turns out that the driver only uses the duplicated
> list of multicast mac addresses to keep track of
> what addresses to delete from h/w before committing
> the new list from kernel to h/w back again via set_rx_mode,
> every time this list gets updated by the kernel.
> Given that the h/w knows how to add and delete mac addresses
> based on the mac address value alone, __dev_mc_sync should be
> the much better choice of kernel API for these operations
> avoiding the considerable overhead of maintaining a duplicated
> list in the driver.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---
> Maybe this should go to net, since there were objections
> for abusing kmalloc(GFP_ATOMIC).

Applied.
