Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9210A4B4B
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 21:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbfIATLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 15:11:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728930AbfIATLN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 15:11:13 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD4818535D;
        Sun,  1 Sep 2019 19:11:12 +0000 (UTC)
Received: from localhost (ovpn-112-7.rdu2.redhat.com [10.10.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E6A15D9D6;
        Sun,  1 Sep 2019 19:11:10 +0000 (UTC)
Date:   Sun, 01 Sep 2019 12:11:09 -0700 (PDT)
Message-Id: <20190901.121109.1164811815017267709.davem@redhat.com>
To:     christophe.jaillet@wanadoo.fr
Cc:     yuehaibing@huawei.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, tbogendoerfer@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: seeq: Fix the function used to release some
 memory in an error handling path
From:   David Miller <davem@redhat.com>
In-Reply-To: <20190831071751.1479-1-christophe.jaillet@wanadoo.fr>
References: <20190831071751.1479-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Sun, 01 Sep 2019 19:11:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sat, 31 Aug 2019 09:17:51 +0200

> In commit 99cd149efe82 ("sgiseeq: replace use of dma_cache_wback_inv"),
> a call to 'get_zeroed_page()' has been turned into a call to
> 'dma_alloc_coherent()'. Only the remove function has been updated to turn
> the corresponding 'free_page()' into 'dma_free_attrs()'.
> The error hndling path of the probe function has not been updated.
> 
> Fix it now.
> 
> Rename the corresponding label to something more in line.
> 
> Fixes: 99cd149efe82 ("sgiseeq: replace use of dma_cache_wback_inv")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.

> If 'dma_alloc_coherent()' fails, maybe the message in printk could be
> improved. The comment above may also not be relevant.

Memory allocation failures already give a stack backtrack down deep in the
memory allocators, therefore printing messages at allocation call sites
are veboten.
