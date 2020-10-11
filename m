Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F54528A804
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 17:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgJKPps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 11:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgJKPps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 11:45:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B81762222A;
        Sun, 11 Oct 2020 15:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602431148;
        bh=xe3fq0hSfzSGKm8Ry9d7SS9pzBcCbLI0gqyC21aVx0U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hZFWZCH/WWSKvgNn+Si2ccnvoiUKWI5qxzd5PbwWpfVk/r4/L2H+rXS+HJ9b9Sfdy
         tCCFrwHXHRNdLxNAyfUyt4V0RvB6pBKqMSEnB2RLxkbSi995NdJlrkTAHc27dHS5eC
         v7WDC8DjTJX6NG7roe7/FybuDAJdR1wq6aexJz10=
Date:   Sun, 11 Oct 2020 08:45:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     netdev@vger.kernel.org, mkl@pengutronix.de, davem@davemloft.net,
        linux-can@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] can-isotp: implement cleanups /
 improvements from review
Message-ID: <20201011084546.2ee6117b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011092408.1766-1-socketcan@hartkopp.net>
References: <20201011092408.1766-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 11:24:07 +0200 Oliver Hartkopp wrote:
> @@ -769,7 +771,7 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
>  
>  isotp_tx_burst:
>  		skb = alloc_skb(so->ll.mtu + sizeof(struct can_skb_priv),
> -				gfp_any());
> +				GFP_KERNEL);

hrtimer will need GFP_ATOMIC
