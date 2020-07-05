Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118D9214965
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 02:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgGEAwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 20:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgGEAwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 20:52:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2700AC061794;
        Sat,  4 Jul 2020 17:52:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DADA157A9D82;
        Sat,  4 Jul 2020 17:52:46 -0700 (PDT)
Date:   Sat, 04 Jul 2020 17:52:46 -0700 (PDT)
Message-Id: <20200704.175246.123858644791564054.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, madhuparnabhowmik04@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-x25@vger.kernel.org
Subject: Re: [PATCH] drivers/net/wan/lapbether: Fixed the value of
 hard_header_len
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200704051246.203413-1-xie.he.0141@gmail.com>
References: <20200704051246.203413-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 04 Jul 2020 17:52:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Fri,  3 Jul 2020 22:12:46 -0700

> When transmitting data from upper layers or from AF_PACKET sockets,
>   this driver will first remove a pseudo header of 1 byte,
>   then the lapb module will prepend the LAPB header of 2 or 3 bytes,
>   then this driver will prepend a length field of 2 bytes,
>   then the underlying Ethernet device will prepend its own header.

Please add something like this above text to a comment:

> @@ -324,6 +323,8 @@ static int lapbeth_new_device(struct net_device *dev)
>  	if (!ndev)
>  		goto out;
>  
> +	ndev->hard_header_len = -1 + 3 + 2 + dev->hard_header_len;
> +

Above this new line so that someone reading the code can understand
these magic numbers and what they mean.

Thank you.
