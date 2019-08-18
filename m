Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAC1919B4
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 23:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfHRVTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 17:19:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49390 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfHRVTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 17:19:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66C72145F4F53;
        Sun, 18 Aug 2019 14:19:40 -0700 (PDT)
Date:   Sun, 18 Aug 2019 14:19:39 -0700 (PDT)
Message-Id: <20190818.141939.213294317843832464.davem@davemloft.net>
To:     horms+renesas@verge.net.au
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] ravb: Fix use-after-free ravb_tstamp_skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190816151702.2677-1-horms+renesas@verge.net.au>
References: <20190816151702.2677-1-horms+renesas@verge.net.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 14:19:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <horms+renesas@verge.net.au>
Date: Fri, 16 Aug 2019 17:17:02 +0200

> From: Tho Vu <tho.vu.wh@rvc.renesas.com>
> 
> When a Tx timestamp is requested, a pointer to the skb is stored in the
> ravb_tstamp_skb struct. This was done without an skb_get. There exists
> the possibility that the skb could be freed by ravb_tx_free (when
> ravb_tx_free is called from ravb_start_xmit) before the timestamp was
> processed, leading to a use-after-free bug.
> 
> Use skb_get when filling a ravb_tstamp_skb struct, and add appropriate
> frees/consumes when a ravb_tstamp_skb struct is freed.
> 
> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> Signed-off-by: Tho Vu <tho.vu.wh@rvc.renesas.com>
> Signed-off-by: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> ---
> As this is an old bug I am submitting a fix against net-next rather than
> net: I do not see any urgency here. I am however, happy for it to be
> applied against net instead.

Applied to 'net', thanks Simon.
