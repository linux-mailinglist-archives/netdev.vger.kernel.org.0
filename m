Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5C73AD1D
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387400AbfFJCke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:40:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48750 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729916AbfFJCke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:40:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECC8514EAD030;
        Sun,  9 Jun 2019 19:40:33 -0700 (PDT)
Date:   Sun, 09 Jun 2019 19:40:33 -0700 (PDT)
Message-Id: <20190609.194033.629249409855789470.davem@davemloft.net>
To:     bigeasy@linutronix.de
Cc:     netdev@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH v2 net-next 0/7] Avoid local_irq_save() and use
 napi_alloc_frag() where possible
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190607192040.19367-1-bigeasy@linutronix.de>
References: <20190607192040.19367-1-bigeasy@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 19:40:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Fri,  7 Jun 2019 21:20:33 +0200

> The first two patches remove local_irq_save() around
> `netdev_alloc_cache' which does not work on -RT. Besides helping -RT it
> whould benefit the users of the function since they can avoid disabling
> interrupts and save a few cycles.
> The remaining patches are from a time when I tried to remove
> `netdev_alloc_cache' but then noticed that we still have non-NAPI
> drivers using netdev_alloc_skb() and I dropped that idea. Using
> napi_alloc_frag() over netdev_alloc_frag() would skip the not required
> local_bh_disable() around the allocation.
 ...

Series applied, thanks.
