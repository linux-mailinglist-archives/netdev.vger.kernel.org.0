Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6131DF1DE
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 00:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbgEVWcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 18:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731127AbgEVWcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 18:32:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B77EC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 15:32:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA1421273C083;
        Fri, 22 May 2020 15:32:39 -0700 (PDT)
Date:   Fri, 22 May 2020 15:32:36 -0700 (PDT)
Message-Id: <20200522.153236.595582419310375454.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     maxime.chevallier@bootlin.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: fix RX hashing for non-10G ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jbMrr-0008Jc-R7@rmk-PC.armlinux.org.uk>
References: <E1jbMrr-0008Jc-R7@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 15:32:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Wed, 20 May 2020 12:26:35 +0100

> When rxhash is enabled on any ethernet port except the first in each CP
> block, traffic flow is prevented.  The analysis is below:
 ...
> So, this patch attempts to solve the issue by clearing the
> MVPP2_CLS_SWFWD_PCTRL_MASK() bit, allowing MVPP22_CLS_C2_ATTR0_QHIGH()
> from the classifier to define the queue-high field of the queue number.
> 
> My testing seems to confirm my findings above - clearing this bit
> means that if I enable rxhash on eth2, the interface can then pass
> traffic, as we are now directing traffic to RX queue 1 rather than
> queue 33. Traffic still seems to work with rxhash off as well.
> 
> Reported-by: Matteo Croce <mcroce@redhat.com>
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Fixes: 895586d5dc32 ("net: mvpp2: cls: Use RSS contexts to handle RSS tables")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied and queued up for -stable, thanks Russell.
