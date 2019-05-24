Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B97A29F94
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391751AbfEXULr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:11:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42518 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391612AbfEXULr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:11:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7A0014E226FC;
        Fri, 24 May 2019 13:11:46 -0700 (PDT)
Date:   Fri, 24 May 2019 13:11:44 -0700 (PDT)
Message-Id: <20190524.131144.357456710258151289.davem@davemloft.net>
To:     fugang.duan@nxp.com
Cc:     netdev@vger.kernel.org, baruch@tkos.co.il
Subject: Re: [PATCH net,stable 1/1] net: fec: add defer probe for
 of_get_mac_address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558576444-25080-1-git-send-email-fugang.duan@nxp.com>
References: <1558576444-25080-1-git-send-email-fugang.duan@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 May 2019 13:11:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Duan <fugang.duan@nxp.com>
Date: Thu, 23 May 2019 01:55:23 +0000

> @@ -3146,7 +3150,10 @@ static int fec_enet_init(struct net_device *ndev)
>  	memset(cbd_base, 0, bd_size);
>  
>  	/* Get the Ethernet address */
> -	fec_get_mac(ndev);
> +	ret = fec_get_mac(ndev);
> +	if (ret)
> +		return ret;

You're leaking the queues allocated by fec_enet_alloc_queue().
