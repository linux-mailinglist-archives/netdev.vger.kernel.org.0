Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27482277E5F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgIYDHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgIYDHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:07:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5222C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 20:07:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4538F135F8F1D;
        Thu, 24 Sep 2020 19:50:43 -0700 (PDT)
Date:   Thu, 24 Sep 2020 20:07:30 -0700 (PDT)
Message-Id: <20200924.200730.982972982825728936.davem@davemloft.net>
To:     rohitm@chelsio.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, vakul.garg@nxp.com,
        secdev@chelsio.com
Subject: Re: [PATCH] net/tls: race causes kernel panic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200924065845.30594-1-rohitm@chelsio.com>
References: <20200924065845.30594-1-rohitm@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:50:43 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>
Date: Thu, 24 Sep 2020 12:28:45 +0530

> BUG: kernel NULL pointer dereference, address: 00000000000000b8
 ...
>  RIP: 0010:tx_work_handler+0x1b/0x70 [tls]
 ...
>  Call Trace:
>   process_one_work+0x1a7/0x370
>   worker_thread+0x30/0x370
>   ? process_one_work+0x370/0x370
>   kthread+0x114/0x130
>   ? kthread_park+0x80/0x80
>   ret_from_fork+0x22/0x30
> 
> tls_sw_release_resources_tx() waits for encrypt_pending, which
> can have race, so we need similar changes as in commit
> 0cada33241d9de205522e3858b18e506ca5cce2c here as well.
> 
> Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Applied and queued up for -stable, thank you.
