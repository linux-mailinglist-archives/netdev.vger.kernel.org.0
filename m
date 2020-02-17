Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B6161D4E
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgBQW3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:29:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgBQW3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:29:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CF74B15AA763A;
        Mon, 17 Feb 2020 14:29:17 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:29:17 -0800 (PST)
Message-Id: <20200217.142917.1260854235072889214.davem@davemloft.net>
To:     michal.kalderon@marvell.com
Cc:     aelior@marvell.com, netdev@vger.kernel.org, ariel.elior@marvell.com
Subject: Re: [PATCH net] qede: Fix race between rdma destroy workqueue and
 link change event
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217113718.32207-1-michal.kalderon@marvell.com>
References: <20200217113718.32207-1-michal.kalderon@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 14:29:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>
Date: Mon, 17 Feb 2020 13:37:18 +0200

> If an event is added while the rdma workqueue is being destroyed
> it could lead to several races, list corruption, null pointer
> dereference during queue_work or init_queue.
> This fixes the race between the two flows which can occur during
> shutdown.
> 
> A kref object and a completion object are added to the rdma_dev
> structure, these are initialized before the workqueue is created.
> The refcnt is used to indicate work is being added to the
> workqueue and ensures the cleanup flow won't start while we're in
> the middle of adding the event.
> Once the work is added, the refcnt is decreased and the cleanup flow
> is safe to run.
> 
> Fixes: cee9fbd8e2e ("qede: Add qedr framework")
> Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

Applied and queeud up for -stable, thanks.
