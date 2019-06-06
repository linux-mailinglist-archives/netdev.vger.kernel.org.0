Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB88F37B1C
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfFFRdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:33:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54606 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfFFRdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:33:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5F18614DD3CC6;
        Thu,  6 Jun 2019 10:33:06 -0700 (PDT)
Date:   Thu, 06 Jun 2019 10:33:05 -0700 (PDT)
Message-Id: <20190606.103305.472940054915337291.davem@davemloft.net>
To:     yanjun.zhu@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH 1/1] net: rds: fix memory leak in rds_ib_flush_mr_pool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559808003-1030-1-git-send-email-yanjun.zhu@oracle.com>
References: <1559808003-1030-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 10:33:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Thu,  6 Jun 2019 04:00:03 -0400

> When the following tests last for several hours, the problem will occur.
 ...
> When ibmr_ret is NULL, llist_entry is not executed. clean_nodes->next
> instead of clean_nodes is added in clean_list.
> So clean_nodes is discarded. It can not be used again.
> The workqueue is executed periodically. So more and more clean_nodes are
> discarded. Finally the clean_list is NULL.
> Then this problem will occur.
> 
> Fixes: 1bc144b62524 ("net, rds, Replace xlist in net/rds/xlist.h with llist")
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Applied and queued up for -stable.
