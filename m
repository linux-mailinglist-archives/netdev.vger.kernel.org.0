Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C81623B093
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgHCW7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728545AbgHCW7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:59:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37236C06174A;
        Mon,  3 Aug 2020 15:59:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CACAA1277916C;
        Mon,  3 Aug 2020 15:43:04 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:59:49 -0700 (PDT)
Message-Id: <20200803.155949.39743839019093809.davem@davemloft.net>
To:     baijiaju@tsinghua.edu.cn
Cc:     doshir@vmware.com, pv-drivers@vmware.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: vmxnet3: avoid accessing the data mapped to
 streaming DMA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200802131107.15857-1-baijiaju@tsinghua.edu.cn>
References: <20200802131107.15857-1-baijiaju@tsinghua.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:43:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Date: Sun,  2 Aug 2020 21:11:07 +0800

> In vmxnet3_probe_device(), "adapter" is mapped to streaming DMA:
>   adapter->adapter_pa = dma_map_single(..., adapter, ...);
> 
> Then "adapter" is accessed at many places in this function.
> 
> Theses accesses may cause data inconsistency between CPU cache and 
> hardware.
> 
> To fix this problem, dma_map_single() is called after these accesses.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>

'adapter' is accessed everywhere, in the entire driver, not just here
in the probe function.
