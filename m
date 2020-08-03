Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B4A23B080
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgHCWvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728213AbgHCWvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:51:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BB0C06174A;
        Mon,  3 Aug 2020 15:51:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A3F312777F36;
        Mon,  3 Aug 2020 15:34:54 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:51:38 -0700 (PDT)
Message-Id: <20200803.155138.467790375085778952.davem@davemloft.net>
To:     baijiaju@tsinghua.edu.cn
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: eni: avoid accessing the data mapped to streaming
 DMA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200802091611.24331-1-baijiaju@tsinghua.edu.cn>
References: <20200802091611.24331-1-baijiaju@tsinghua.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:34:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Date: Sun,  2 Aug 2020 17:16:11 +0800

> In do_tx(), skb->data is mapped to streaming DMA on line 1111:
>   paddr = dma_map_single(...,skb->data,DMA_TO_DEVICE);
> 
> Then skb->data is accessed on line 1153:
>   (skb->data[3] & 0xf)
> 
> This access may cause data inconsistency between CPU cache and hardware.
> 
> To fix this problem, skb->data[3] is assigned to a local variable before
> DMA mapping, and then the driver accesses this local variable instead of
> skb->data[3].
> 
> Signed-off-by: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>

Applied.
