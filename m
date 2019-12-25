Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C15012A53D
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 01:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfLYAS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 19:18:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58036 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfLYAS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 19:18:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1C00154CCC20;
        Tue, 24 Dec 2019 16:18:26 -0800 (PST)
Date:   Tue, 24 Dec 2019 16:18:26 -0800 (PST)
Message-Id: <20191224.161826.37676943451935844.davem@davemloft.net>
To:     fenghua.yu@intel.com
Cc:     michael.chan@broadcom.com, netdev@vger.kernel.org,
        tglx@linutronix.de, luto@kernel.org, peterz@infradead.org,
        tony.luck@intel.com, David.Laight@ACULAB.COM,
        ravi.v.shankar@intel.com
Subject: Re: [PATCH] drivers/net/b44: Change to non-atomic bit operations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576884551-9518-1-git-send-email-fenghua.yu@intel.com>
References: <1576884551-9518-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 16:18:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>
Date: Fri, 20 Dec 2019 15:29:11 -0800

> On x86, accessing data across two cache lines in one atomic bit
> operation (aka split lock) can take over 1000 cycles.

This happens during configuration of WOL, nobody cares that the atomic
operations done in this function take 1000 cycles each.

I'm not applying this patch.  It is gratuitous, and the commit message
talks about "performance" considuations (cycle counts) that completely
don't matter here.

If you are merely just arbitrarily trying to remove locked atomic
operations across the tree for it's own sake, then you should be
completely honest about that in your commit message.
