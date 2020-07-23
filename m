Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAA222A457
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733261AbgGWBHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWBHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:07:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6560DC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:07:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E9979126B39BC;
        Wed, 22 Jul 2020 17:50:33 -0700 (PDT)
Date:   Wed, 22 Jul 2020 18:07:18 -0700 (PDT)
Message-Id: <20200722.180718.1511521016153348074.davem@davemloft.net>
To:     parav@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com
Subject: Re: [PATCH net-next] devlink: Always use user_ptr[0] for devlink
 and simplify post_doit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722155711.976214-1-parav@mellanox.com>
References: <20200722155711.976214-1-parav@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:50:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>
Date: Wed, 22 Jul 2020 18:57:11 +0300

> Currently devlink instance is searched on all doit() operations.
> But it is optionally stored into user_ptr[0]. This requires
> rediscovering devlink again doing post_doit().
> 
> Few devlink commands related to port shared buffers needs 3 pointers
> (devlink, devlink_port, and devlink_sb) while executing doit commands.
> Though devlink pointer can be derived from the devlink_port during
> post_doit() operation when doit() callback has acquired devlink
> instance lock, relying on such scheme to access devlik pointer makes
> code very fragile.
> 
> Hence, to avoid ambiguity in post_doit() and to avoid searching
> devlink instance again, simplify code by always storing devlink
> instance in user_ptr[0] and derive devlink_sb pointer in their
> respective callback routines.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Applied.
