Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573EC1A5FF4
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 20:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgDLS7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 14:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727235AbgDLS7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 14:59:15 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF045C0A3BF0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 11:59:15 -0700 (PDT)
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB6B8206C3;
        Sun, 12 Apr 2020 18:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586717955;
        bh=NjSgy7aiwMrCO9ZK/QXGgUengY0nUwH2bQ4/v//DbGE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qgxAoG51eYDJ2BOYMIPvQZpiZqHkUdBejy+NBq+2yGsjWx/3dXUCrtqnBaCCdX1TD
         OPcjq6F7tA2yc8osg4z8vPff50ng2T+utHQcJO2QQgHxkUSpAdRnIhiJ9KqJGVZN9H
         R56CCvCdvO5J/EAWzcGUV+EjDOmYh2/qED+7Lae0=
Date:   Sun, 12 Apr 2020 11:59:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@mellanox.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Subject: Re: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
Message-ID: <20200412115913.14d69a7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200412060854.334895-1-leon@kernel.org>
References: <20200412060854.334895-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Apr 2020 09:08:54 +0300 Leon Romanovsky wrote:
> Hi Dave,
> 
> This is a new version of previously sent v0 [1] with change in print error
> level as was suggested by Jakub and Cong. I'm asking you to reevaluate
> your previous decision [2] given the fact that this is user triggered
> bug and very similar scenario was committed by Linus "fs/filesystems.c:
> downgrade user-reachable WARN_ONCE() to pr_warn_once()" a couple of days
> ago [3].
> 
> [1] https://lore.kernel.org/netdev/20200402152336.538433-1-leon@kernel.org
> [2] https://lore.kernel.org/netdev/20200402.180218.940555077368617365.davem@davemloft.net
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=26c5d78c976ca298e59a56f6101a97b618ba3539

How is it user triggerable? If there's a IB-specific reason maybe ib
netdev should stop implementing ndo_tx_timeout.
