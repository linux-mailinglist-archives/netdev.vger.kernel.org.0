Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC441ED53C
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 19:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgFCRq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 13:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgFCRq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 13:46:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BE1C08C5C0
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 10:46:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F37E1281D6A6;
        Wed,  3 Jun 2020 10:46:55 -0700 (PDT)
Date:   Wed, 03 Jun 2020 10:46:54 -0700 (PDT)
Message-Id: <20200603.104654.509090864511244400.davem@davemloft.net>
To:     vinay.yadav@chelsio.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        borisp@mellanox.com, secdev@chelsio.com
Subject: Re: [PATCH net-next] crypto/chtls: Fix compile error when
 CONFIG_IPV6 is disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200603103317.653-1-vinay.yadav@chelsio.com>
References: <20200603103317.653-1-vinay.yadav@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jun 2020 10:46:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Date: Wed,  3 Jun 2020 16:03:17 +0530

> @@ -102,19 +100,24 @@ static struct net_device *chtls_find_netdev(struct chtls_dev *cdev,
>  			return ndev;
>  		ndev = ip_dev_find(&init_net, inet_sk(sk)->inet_rcv_saddr);
>  		break;
> +#if IS_ENABLED(CONFIG_IPV6)
>  	case PF_INET6:
> +		struct net_device *temp;
> +		int addr_type;
> +

You never, ever, compiled this code.
