Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EFC2C4BEC
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgKZASF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:18:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbgKZASE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 19:18:04 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C33F120770;
        Thu, 26 Nov 2020 00:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606349884;
        bh=Ns09msPPorQd9XdFURMU6NQc1Vtuzv00w8EUjh8w4Rg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tOgpY4IWei2nMIYlOPmgKIIWLjhAKDyu4xL7/tQnWRv5kE6r0TLpXd94q4NJ0ObnC
         duWKbzIjMW9ycyVXRnEk/PhaKe/3nqhQgM13PuicTd7Jo07W19zibSkC5JP/4wzD9c
         DOcnnGW5FM8L5MGUPsnJGnm9jp0wYrDabt7lYPCQ=
Date:   Wed, 25 Nov 2020 16:18:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next v5 08/14] net/smc: Introduce generic netlink
 interface for diagnostic purposes
Message-ID: <20201125161802.402912b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124175047.56949-9-kgraul@linux.ibm.com>
References: <20201124175047.56949-1-kgraul@linux.ibm.com>
        <20201124175047.56949-9-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 18:50:41 +0100 Karsten Graul wrote:
> From: Guvenc Gulce <guvenc@linux.ibm.com>
> 
> Introduce generic netlink interface infrastructure to expose
> the diagnostic information regarding smc linkgroups, links and devices.
> 
> Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

> @@ -2494,6 +2495,7 @@ static int __init smc_init(void)
>  
>  	smc_ism_init();
>  	smc_clc_init();
> +	smc_nl_init();

This can fail.

> +static const struct nla_policy smc_gen_nl_policy[SMC_GEN_MAX + 1] = {
> +	[SMC_GEN_UNSPEC]	= { .type = NLA_UNSPEC, },

This is unnecessary, NLA_UNSPEC is 0.

> +};

