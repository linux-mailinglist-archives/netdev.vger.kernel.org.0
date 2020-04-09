Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4159D1A38D3
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgDIRWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:22:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33432 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgDIRWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 13:22:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5219C128D797D;
        Thu,  9 Apr 2020 10:22:24 -0700 (PDT)
Date:   Thu, 09 Apr 2020 10:22:23 -0700 (PDT)
Message-Id: <20200409.102223.182007354397877992.davem@davemloft.net>
To:     ka-cheong.poon@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com, sironhide0null@gmail.com
Subject: Re: [PATCH v2 net 2/2] net/rds: Fix MR reference counting problem
From:   David Miller <davem@davemloft.net>
In-Reply-To: <76140548ff6c7ae75af0a7c4e6f585a061bd74a7.1586340235.git.ka-cheong.poon@oracle.com>
References: <fb149123516920dd5f5bf730a1da3a0cb9f3d25e.1586340235.git.ka-cheong.poon@oracle.com>
        <fb149123516920dd5f5bf730a1da3a0cb9f3d25e.1586340235.git.ka-cheong.poon@oracle.com>
        <76140548ff6c7ae75af0a7c4e6f585a061bd74a7.1586340235.git.ka-cheong.poon@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Apr 2020 10:22:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Date: Wed,  8 Apr 2020 03:21:02 -0700

> In rds_free_mr(), it calls rds_destroy_mr(mr) directly.  But this
> defeats the purpose of reference counting and makes MR free handling
> impossible.  It means that holding a reference does not guarantee that
> it is safe to access some fields.  For example, In
> rds_cmsg_rdma_dest(), it increases the ref count, unlocks and then
> calls mr->r_trans->sync_mr().  But if rds_free_mr() (and
> rds_destroy_mr()) is called in between (there is no lock preventing
> this to happen), r_trans_private is set to NULL, causing a panic.
> Similar issue is in rds_rdma_unuse().
> 
> Reported-by: zerons <sironhide0null@gmail.com>
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

Applied.
