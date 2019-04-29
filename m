Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32FBFECB6
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbfD2WZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:25:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59746 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728105AbfD2WZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:25:30 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F488146947B5;
        Mon, 29 Apr 2019 15:25:29 -0700 (PDT)
Date:   Mon, 29 Apr 2019 18:25:28 -0400 (EDT)
Message-Id: <20190429.182528.1266021884484046928.davem@davemloft.net>
To:     santosh.shilimkar@oracle.com
Cc:     netdev@vger.kernel.org
Subject: Re: [net-next][PATCH 1/2] rds: handle unsupported rdma request to
 fs dax memory
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1556239470-26908-2-git-send-email-santosh.shilimkar@oracle.com>
References: <1556239470-26908-1-git-send-email-santosh.shilimkar@oracle.com>
        <1556239470-26908-2-git-send-email-santosh.shilimkar@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Apr 2019 15:25:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Date: Thu, 25 Apr 2019 17:44:29 -0700

> @@ -158,8 +158,9 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
>  {
>  	int ret;
>  
> -	ret = get_user_pages_fast(user_addr, nr_pages, write, pages);
> -
> +      /* get_user_pages return -EOPNOTSUPP for fs_dax memory */
   ^^^^^^

These are spaces, please use a TAB character like the rest of the code.

> +	ret = get_user_pages_longterm(user_addr, nr_pages,
> +				      write, pages, NULL);
