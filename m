Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1AD23B057
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgHCWmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHCWmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:42:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B3DC06174A;
        Mon,  3 Aug 2020 15:42:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 72BD712777A0D;
        Mon,  3 Aug 2020 15:26:03 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:42:48 -0700 (PDT)
Message-Id: <20200803.154248.2020214547846261577.davem@davemloft.net>
To:     joe@perches.com
Cc:     romieu@fr.zoreil.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] via-velocity: Add missing KERN_<LEVEL> where needed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e45d15ad36a0c9a994b5a1136c72518215c99f7a.camel@perches.com>
References: <e45d15ad36a0c9a994b5a1136c72518215c99f7a.camel@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:26:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 01 Aug 2020 08:51:03 -0700

> Link status is emitted on multiple lines as it does not use
> KERN_CONT.
> 
> Coalesce the multi-part logging into a single line output and
> add missing KERN_<LEVEL> to a couple logging calls.
> 
> This also reduces object size.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

The real problem is the whole VELOCITY_PRT() private debug log
control business this driver is doing.

It should be using the standard netdev logging level infrastructure.

> +			VELOCITY_PRT(MSG_LEVEL_INFO, KERN_INFO "set Velocity to forced full mode\n");

You can't tell me that this "KERN_INFO blah blah blah" is really
something we should add more of these days, right?

If you're going to improve this driver's logging code please do
so by having it use the standard interfaces.

Thanks.
