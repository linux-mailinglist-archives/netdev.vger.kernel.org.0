Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F341DA4EF
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgESWsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgESWsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:48:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3282BC061A0E;
        Tue, 19 May 2020 15:48:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F1EF128F0072;
        Tue, 19 May 2020 15:48:06 -0700 (PDT)
Date:   Tue, 19 May 2020 15:48:05 -0700 (PDT)
Message-Id: <20200519.154805.2002435538113436383.davem@davemloft.net>
To:     nhorman@tuxdriver.com
Cc:     linux-sctp@vger.kernel.org, vyasevich@gmail.com,
        jere.leppanen@nokia.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] sctp: Don't add the shutdown timer if its already been
 added
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519200405.857632-1-nhorman@tuxdriver.com>
References: <20200519200405.857632-1-nhorman@tuxdriver.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 15:48:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 19 May 2020 16:04:05 -0400

> This BUG halt was reported a while back, but the patch somehow got
> missed:
> 
 ...
> It appears that the side effect that starts the shutdown timer was processed
> multiple times, which can happen as multiple paths can trigger it.  This of
> course leads to the BUG halt in add_timer getting called.
> 
> Fix seems pretty straightforward, just check before the timer is added if its
> already been started.  If it has mod the timer instead to min(current
> expiration, new expiration)
> 
> Its been tested but not confirmed to fix the problem, as the issue has only
> occured in production environments where test kernels are enjoined from being
> installed.  It appears to be a sane fix to me though.  Also, recentely,
> Jere found a reproducer posted on list to confirm that this resolves the
> issues
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Applied and queued up for -stable, thanks.
