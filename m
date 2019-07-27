Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C0A77BEA
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 22:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388260AbfG0U61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 16:58:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40156 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388150AbfG0U61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 16:58:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6DC41534D217;
        Sat, 27 Jul 2019 13:58:26 -0700 (PDT)
Date:   Sat, 27 Jul 2019 13:58:26 -0700 (PDT)
Message-Id: <20190727.135826.2041392966126684368.davem@davemloft.net>
To:     baijiaju1990@gmail.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: rds: Fix possible null-pointer dereferences in
 rds_rdma_cm_event_handler_cmn()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726141705.9585-1-baijiaju1990@gmail.com>
References: <20190726141705.9585-1-baijiaju1990@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 13:58:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>
Date: Fri, 26 Jul 2019 22:17:05 +0800

> In rds_rdma_cm_event_handler_cmn(), there are some if statements to
> check whether conn is NULL, such as on lines 65, 96 and 112.
> But conn is not checked before being used on line 108:
>     trans->cm_connect_complete(conn, event);
> and on lines 140-143:
>     rdsdebug("DISCONNECT event - dropping connection "
>             "%pI6c->%pI6c\n", &conn->c_laddr,
>             &conn->c_faddr);
>     rds_conn_drop(conn);
> 
> Thus, possible null-pointer dereferences may occur.
> 
> To fix these bugs, conn is checked before being used.
> 
> These bugs are found by a static analysis tool STCheck written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Applied.
