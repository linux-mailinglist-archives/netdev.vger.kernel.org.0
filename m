Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC0624C7FE
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 00:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgHTWs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 18:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728446AbgHTWs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 18:48:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220B0C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 15:48:28 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D772512868EC8;
        Thu, 20 Aug 2020 15:31:40 -0700 (PDT)
Date:   Thu, 20 Aug 2020 15:48:25 -0700 (PDT)
Message-Id: <20200820.154825.1980624947360309997.davem@davemloft.net>
To:     davthompson@nvidia.com
Cc:     kuba@kernel.org, dthompson@mellanox.com, netdev@vger.kernel.org,
        jiri@mellanox.com, Asmaa@mellanox.com
Subject: Re: [PATCH net-next v2] Add Mellanox BlueField Gigabit Ethernet
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <MN2PR12MB2975DAA7292C27DEB0B518A8C75A0@MN2PR12MB2975.namprd12.prod.outlook.com>
References: <1596149638-23563-1-git-send-email-dthompson@mellanox.com>
        <20200730173059.7440e21c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <MN2PR12MB2975DAA7292C27DEB0B518A8C75A0@MN2PR12MB2975.namprd12.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 15:31:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Thompson <davthompson@nvidia.com>
Date: Thu, 20 Aug 2020 18:51:39 +0000

> When I wrote the Kconfig definition I was thinking that "INET" is an
> obvious functional dependency for an Ethernet driver.

People can and should be able to use your driver even if ipv4/ipv6 is
disabled, don't you think?

> Yes, the mlxbf_gige silicon block needs to be programmed with the
> buffer's physical address so that the silicon logic can DMA incoming
> packet data into the buffer.  The kernel API "dma_alloc_coherent()"
> meets the driver's requirements in that it returns a CPU-useable address
> as well as a bus/physical address (used by silicon).

For descriptors and statistics blocks, coherent DMA memory makes sense.

For packet data, it does not.  These are streaming blocks of memory that
have their cohernecy managed by appropriate map/unmap/sync calls.
