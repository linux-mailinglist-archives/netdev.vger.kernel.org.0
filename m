Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0689B27CEBD
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgI2NNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:13:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728616AbgI2NNg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 09:13:36 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50767206DC;
        Tue, 29 Sep 2020 13:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601385215;
        bh=pUN031OfwDDhtzW8T/kdGePWvCTQA224tf3A5BDRTnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TnF8PLlTtsEYTtsOrft0daj4NNPkXwp58sWqNxCoh8kB9dBFmDXLoQw7HoADO8duk
         +pEWClEkWsJluJgM0knHlPxP9BApvCbknSFWWPPQ0vGf/gr0ZQCMk49lYVb3wBcMaV
         tc7r82+tUzx/TI0cucj+ldN4zC+fhdL/Vy67R4wM=
Date:   Tue, 29 Sep 2020 08:19:15 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     aelior@marvell.com, kuba@kernel.org,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org
Subject: Re: [PATCH][next] qed/qed_ll2: Replace one-element array with
 flexible-array member
Message-ID: <20200929131915.GC28922@embeddedor>
References: <20200928151617.GA16912@embeddedor>
 <20200928.184814.134218247079915440.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200928.184814.134218247079915440.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 06:48:14PM -0700, David Miller wrote:
> From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Date: Mon, 28 Sep 2020 10:16:17 -0500
> 
> > There is a regular need in the kernel to provide a way to declare having
> > a dynamically sized set of trailing elements in a structure. Kernel code
> > should always use “flexible array members”[1] for these cases. The older
> > style of one-element or zero-length arrays should no longer be used[2].
> > 
> > Refactor the code according to the use of a flexible-array member in
> > struct qed_ll2_tx_packet, instead of a one-element array and use the
> > struct_size() helper to calculate the size for the allocations. Commit
> > f5823fe6897c ("qed: Add ll2 option to limit the number of bds per packet")
> > was used as a reference point for these changes.
> > 
> > Also, it's important to notice that flexible-array members should occur
> > last in any structure, and structures containing such arrays and that
> > are members of other structures, must also occur last in the containing
> > structure. That's why _cur_completing_packet_ is now moved to the bottom
> > in struct qed_ll2_tx_queue. _descq_mem_ and _cur_send_packet_ are also
> > moved for unification.
> > 
> > [1] https://en.wikipedia.org/wiki/Flexible_array_member
> > [2] https://www.kernel.org/doc/html/v5.9-rc1/process/deprecated.html#zero-length-and-one-element-arrays
> > 
> > Tested-by: kernel test robot <lkp@intel.com>
> 
> I find such tags enormously misleading, because the kernel test robot
> didn't perform any functional testing of this change and honestly
> that's the part I'm more concerned about rather than "does it build".
> 
> Anyone can check test the build.
> 

I agree.  I should add a Built-Tested-by tag instead next time.

> > Link: https://lore.kernel.org/lkml/5f707198.PA1UCZ8MYozYZYAR%25lkp@intel.com/
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Applied.

Thanks
--
Gustavo
