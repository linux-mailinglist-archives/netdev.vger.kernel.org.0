Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9C51416B
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfEER0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:26:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52852 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEER0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:26:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0663A14DA0325;
        Sun,  5 May 2019 10:26:11 -0700 (PDT)
Date:   Sun, 05 May 2019 10:26:11 -0700 (PDT)
Message-Id: <20190505.102611.257025800032151893.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     gustavo@embeddedor.com, dwmw2@infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: atm: clean up a range check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190503123948.GD29695@mwanda>
References: <20190503123948.GD29695@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:26:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 3 May 2019 15:39:48 +0300

> The code works fine but the problem is that check for negatives is a
> no-op:
> 
> 	if (arg < 0)
> 		i = 0;
> 
> The "i" value isn't used.  We immediately overwrite it with:
> 
> 	i = array_index_nospec(arg, MAX_LEC_ITF);
> 
> The array_index_nospec() macro returns zero if "arg" is out of bounds so
> this works, but the dead code is confusing and it doesn't look very
> intentional.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This applies to net, but it's just a clean up.

I'm applying this to net-next, thanks Dan.
