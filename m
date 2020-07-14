Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF0B21FE9B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGNUcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgGNUcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 16:32:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C36C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 13:32:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E53215E21F1A;
        Tue, 14 Jul 2020 13:32:17 -0700 (PDT)
Date:   Tue, 14 Jul 2020 13:32:16 -0700 (PDT)
Message-Id: <20200714.133216.319021019310697324.davem@davemloft.net>
To:     rakeshs.lkm@gmail.com
Cc:     sbhatta@marvell.com, sgoutham@marvell.com, jerinj@marvell.com,
        rsaladi2@marvell.com, kuba@kernel.org, netdev@vger.kernel.org,
        Sunil.Goutham@cavium.com
Subject: Re: [net-next PATCH 1/2] octeontx2-af: add npa error af interrupt
 handlers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714063825.24369-2-rakeshs.lkm@gmail.com>
References: <20200714063825.24369-1-rakeshs.lkm@gmail.com>
        <20200714063825.24369-2-rakeshs.lkm@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 13:32:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: rakeshs.lkm@gmail.com
Date: Tue, 14 Jul 2020 12:08:24 +0530

> +static const char *rvu_npa_inpq_to_str(u16 in)
> +{
> +	switch (in) {
> +	case 0:
> +		return NULL;
> +	case BIT(NPA_INPQ_NIX0_RX):
> +		return __stringify(NPA_INPQ_NIX0_RX);

Hardware can report anything, multiple bits set at once, garbage
values, etc.

So to me it doesn't make much sense to expect only one bit set
and only handle specific well defined bits.

This is the error path in an interrupt handler, just print the
raw bits instead of trying to pretty print them please.

> +static irqreturn_t rvu_npa_af_gen_intr_handler(int irq, void *rvu_irq)
> +{
> +	struct rvu *rvu = (struct rvu *)rvu_irq;

Void pointers never need to be cast to another type of pointer.

Please fix this up in your entire submission.
