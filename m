Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5BCA2BF7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfH3Ay0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:54:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56268 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfH3Ay0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:54:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 92A6C153D58C8;
        Thu, 29 Aug 2019 17:54:25 -0700 (PDT)
Date:   Thu, 29 Aug 2019 17:54:25 -0700 (PDT)
Message-Id: <20190829.175425.1248230437028888792.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     kou.ishizaki@toshiba.co.jp, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: spider_net: Use struct_size() helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190828202108.GA9494@embeddedor>
References: <20190828202108.GA9494@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 17:54:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Wed, 28 Aug 2019 15:21:08 -0500

> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
> 
> struct spider_net_card {
> 	...
>         struct spider_net_descr darray[0];
> };
> 
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
> 
> So, replace the following form:
> 
> sizeof(struct spider_net_card) + (tx_descriptors + rx_descriptors) * sizeof(struct spider_net_descr)
> 
> with:
> 
> struct_size(card, darray, tx_descriptors + rx_descriptors)
> 
> Notice that, in this case, variable alloc_size is not necessary, hence it
> is removed.
> 
> Building: allmodconfig powerpc.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied to net-next, thanks.
