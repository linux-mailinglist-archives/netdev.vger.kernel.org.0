Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7F52794CC
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgIYXbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgIYXbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:31:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B584C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 16:31:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5638A13BA071C;
        Fri, 25 Sep 2020 16:14:29 -0700 (PDT)
Date:   Fri, 25 Sep 2020 16:31:15 -0700 (PDT)
Message-Id: <20200925.163115.1983585891277676668.davem@davemloft.net>
To:     jesse.brandeburg@gmail.com
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, kuba@kernel.org, saeed@kernel.org
Subject: Re: [PATCH net-next v3 0/9] make drivers/net/ethernet W=1 clean
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
References: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:14:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Date: Fri, 25 Sep 2020 15:24:36 -0700

> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> The Goal: move to W=1 being default for drivers/net/ethernet, and
> then use automation to catch more code issues (warnings) being
> introduced.
> The status: Getting much closer but not quite done for all
> architectures.
> 
> After applying the patches below, the drivers/net/ethernet
> directory can be built as modules with W=1 with no warnings (so
> far on x64_64 arch only!). As Jakub pointed out, there is much
> more work to do to clean up C=1, but that will be another series
> of changes.
> 
> This series removes 1,247 warnings and hopefully allows the
> ethernet directory to move forward from here without more
> warnings being added. There is only one objtool warning now.
> 
> This version drops one of the Intel patches, as I couldn't
> reproduce the original issue to document the warning.
> 
> Some of these patches are already sent and tested on Intel Wired
> Lan, but the rest of the series titled drivers/net/ethernet
> affects other drivers. The changes are all pretty
> straightforward.
> 
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Saeed Mahameed <saeed@kernel.org>

Series applied, but that sh_eth.c thing gives me major cancer.

There has to be a better way to describe that table and I recently
pushed back on someone trying to stick a CFLAGS modification into
that subdirectory's Makefile to fix it.

That strategy of initializing a table might be convenient, but with it
you can't look at each table and see which registers DO NOT exist for
each chip which is just as interesting as which ones do exist.

But the main point is that the warning should be avoided in a cleaner
way somehow.  And by doing so we'll likely make the tables more
expressive.

