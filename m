Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2074399F1
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 17:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhJYPSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 11:18:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53456 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbhJYPSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 11:18:18 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id F21A44F5F7090;
        Mon, 25 Oct 2021 08:15:54 -0700 (PDT)
Date:   Mon, 25 Oct 2021 16:15:49 +0100 (BST)
Message-Id: <20211025.161549.899716517054473254.davem@davemloft.net>
To:     jk@codeconstruct.com.au
Cc:     netdev@vger.kernel.org, kuba@kernel.org, matt@codeconstruct.com.au,
        esyr@redhat.com
Subject: Re: [PATCH net-next v5] mctp: Implement extended addressing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211025032757.2317020-1-jk@codeconstruct.com.au>
References: <20211025032757.2317020-1-jk@codeconstruct.com.au>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 25 Oct 2021 08:15:56 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>
Date: Mon, 25 Oct 2021 11:27:57 +0800

> @@ -152,10 +155,16 @@ struct mctp_sk_key {
>  
>  struct mctp_skb_cb {
>  	unsigned int	magic;
> -	unsigned int	net;
> +	int		net;
> +	int		ifindex; /* extended/direct addressing if set */
> +	unsigned char	halen;
>  	mctp_eid_t	src;
> +	unsigned char	haddr[];
>  };
>  
putting a variably sized type in the skb control blocxk is not a good idea.
Overruns will be silent, nothing in the typing protects you from udsing more space
han exists in skb->cb.

Plrease find another way, thank you.

