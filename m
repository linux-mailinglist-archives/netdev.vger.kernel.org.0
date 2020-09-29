Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6489427BA76
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727293AbgI2BsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2BsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:48:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746ADC061755;
        Mon, 28 Sep 2020 18:48:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7AE5127C6C0A;
        Mon, 28 Sep 2020 18:31:28 -0700 (PDT)
Date:   Mon, 28 Sep 2020 18:48:14 -0700 (PDT)
Message-Id: <20200928.184814.134218247079915440.davem@davemloft.net>
To:     gustavoars@kernel.org
Cc:     aelior@marvell.com, kuba@kernel.org,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org
Subject: Re: [PATCH][next] qed/qed_ll2: Replace one-element array with
 flexible-array member
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928151617.GA16912@embeddedor>
References: <20200928151617.GA16912@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 18:31:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date: Mon, 28 Sep 2020 10:16:17 -0500

> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code according to the use of a flexible-array member in
> struct qed_ll2_tx_packet, instead of a one-element array and use the
> struct_size() helper to calculate the size for the allocations. Commit
> f5823fe6897c ("qed: Add ll2 option to limit the number of bds per packet")
> was used as a reference point for these changes.
> 
> Also, it's important to notice that flexible-array members should occur
> last in any structure, and structures containing such arrays and that
> are members of other structures, must also occur last in the containing
> structure. That's why _cur_completing_packet_ is now moved to the bottom
> in struct qed_ll2_tx_queue. _descq_mem_ and _cur_send_packet_ are also
> moved for unification.
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.9-rc1/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Tested-by: kernel test robot <lkp@intel.com>

I find such tags enormously misleading, because the kernel test robot
didn't perform any functional testing of this change and honestly
that's the part I'm more concerned about rather than "does it build".

Anyone can check test the build.

> Link: https://lore.kernel.org/lkml/5f707198.PA1UCZ8MYozYZYAR%25lkp@intel.com/
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied.
