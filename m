Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF2477330
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfGZVFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:05:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55054 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfGZVFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:05:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A54B12665368;
        Fri, 26 Jul 2019 14:05:10 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:05:09 -0700 (PDT)
Message-Id: <20190726.140509.821828313930772794.davem@davemloft.net>
To:     baijiaju1990@gmail.com
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tipc: Fix a possible null-pointer dereference in
 tipc_publ_purge()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190725092021.15855-1-baijiaju1990@gmail.com>
References: <20190725092021.15855-1-baijiaju1990@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jul 2019 14:05:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>
Date: Thu, 25 Jul 2019 17:20:21 +0800

> @@ -223,7 +223,8 @@ static void tipc_publ_purge(struct net *net, struct publication *publ, u32 addr)
>  		       publ->key);
>  	}
>  
> -	kfree_rcu(p, rcu);
> +	if (p)
> +		kfree_rcu(p, rcu);

Please fix your automated tools if that is what found this, because as
others have nodes kfree_rcu() can take a NULL pointer argument just
fine.

Thank you.
