Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F6D284E40
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgJFOrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgJFOrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 10:47:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5DAC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 07:47:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 05A56127D755B;
        Tue,  6 Oct 2020 07:30:30 -0700 (PDT)
Date:   Tue, 06 Oct 2020 07:47:15 -0700 (PDT)
Message-Id: <20201006.074715.742357947812105732.davem@davemloft.net>
To:     kliteyn@nvidia.com
Cc:     saeed@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        erezsh@nvidia.com, mbloch@nvidia.com, saeedm@nvidia.com
Subject: Re: [net-next 01/15] net/mlx5: DR, Add buddy allocator utilities
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c231b69d-812a-b98e-b785-a807d6d640b5@nvidia.com>
References: <20200928.144149.790487567012040407.davem@davemloft.net>
        <d53133e1-ca35-40cd-3856-f8592fd4895e@nvidia.com>
        <c231b69d-812a-b98e-b785-a807d6d640b5@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 06 Oct 2020 07:30:31 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>
Date: Tue, 6 Oct 2020 16:02:24 +0300

> Buddy allocator allocates blocks of different sizes, so when it
> scans the bits array, the allocator looks for free *area* of at
> least the required size.
> Can't store this info in a 'lowest set bit' counter.

If you make it per-order, why not?

> Furthermore, when buddy allocator scans for such areas, it
> takes into consideration blocks alignment as required by HW,
> which can't be stored in an external counter.

That's why you scan the bits, which you have to do anyways.

I'm kinda disappointed in how this discussion is going, to be honest.
