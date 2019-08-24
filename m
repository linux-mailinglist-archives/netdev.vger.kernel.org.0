Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA54F9C116
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbfHXX6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:58:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48732 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbfHXX6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:58:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0797A152621F3;
        Sat, 24 Aug 2019 16:58:51 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:58:51 -0700 (PDT)
Message-Id: <20190824.165851.1817456673626840850.davem@davemloft.net>
To:     yanjun.zhu@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        gerd.rausch@oracle.com
Subject: Re: [PATCHv2 1/1] net: rds: add service level support in rds-info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566608656-30836-1-git-send-email-yanjun.zhu@oracle.com>
References: <1566608656-30836-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:58:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Fri, 23 Aug 2019 21:04:16 -0400

> diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
> index fd6b5f6..cba368e 100644
> --- a/include/uapi/linux/rds.h
> +++ b/include/uapi/linux/rds.h
> @@ -250,6 +250,7 @@ struct rds_info_rdma_connection {
>  	__u32		rdma_mr_max;
>  	__u32		rdma_mr_size;
>  	__u8		tos;
> +	__u8		sl;
>  	__u32		cache_allocs;
>  };

I'm applying this, but I am once again severely disappointed in how
RDS development is being handled.

From the Fixes: commit:

	Since rds.h in rds-tools is not related with the kernel rds.h,
	the change in kernel rds.h does not affect rds-tools.

This is the height of arrogance and shows a lack of understanding of
what user ABI requirements are all about.

It is possible for other userland components to be built by other
people, outside of your controlled eco-system and tools, that use
these interfaces.

And you cannot control that.

Therefore you cannot make arbitrary changes to UABI data strucures
just because the tool you use and maintain is not effected by it.

Please stop making these incredibly incompatible user interface
changes in the RDS stack.

I am, from this point forward, going to be extra strict on RDS stack
changes especially in this area.

