Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDCF1F0900
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 00:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgFFWvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 18:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgFFWvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 18:51:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5261EC03E96A
        for <netdev@vger.kernel.org>; Sat,  6 Jun 2020 15:51:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 830C61274E636;
        Sat,  6 Jun 2020 15:51:34 -0700 (PDT)
Date:   Sat, 06 Jun 2020 15:51:33 -0700 (PDT)
Message-Id: <20200606.155133.1969168573861094911.davem@davemloft.net>
To:     herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] rhashtable: Drop raw RCU deref in nested_table_free
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200603081243.GA30134@gondor.apana.org.au>
References: <20200603081243.GA30134@gondor.apana.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 06 Jun 2020 15:51:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 3 Jun 2020 18:12:43 +1000

> This patch replaces some unnecessary uses of rcu_dereference_raw
> in the rhashtable code with rcu_dereference_protected.
> 
> The top-level nested table entry is only marked as RCU because it
> shares the same type as the tree entries underneath it.  So it
> doesn't need any RCU protection.
> 
> We also don't need RCU protection when we're freeing a nested RCU
> table because by this stage we've long passed a memory barrier
> when anyone could change the nested table.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks Herbert.
