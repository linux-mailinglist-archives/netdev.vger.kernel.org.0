Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E69369BD
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 04:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfFFCD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 22:03:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfFFCDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 22:03:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 52AD8144EB8B8;
        Wed,  5 Jun 2019 19:03:55 -0700 (PDT)
Date:   Wed, 05 Jun 2019 19:03:53 -0700 (PDT)
Message-Id: <20190605.190353.1269004280892262456.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     jiri@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: objagg: Use struct_size() in kzalloc()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605144516.GA3383@embeddedor>
References: <20190605144516.GA3383@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 19:03:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Wed, 5 Jun 2019 09:45:16 -0500

> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
> 
> struct objagg_stats {
> 	...
>         struct objagg_obj_stats_info stats_info[];
> };
> 
> size = sizeof(*objagg_stats) + sizeof(objagg_stats->stats_info[0]) * count;
> instance = kzalloc(size, GFP_KERNEL);
> 
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
> 
> instance = kzalloc(struct_size(instance, stats_info, count), GFP_KERNEL);
> 
> Notice that, in this case, variable alloc_size is not necessary, hence it
> is removed.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
