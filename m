Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFAA2CDE1E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgLCS4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:56:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbgLCS4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 13:56:30 -0500
Date:   Thu, 3 Dec 2020 10:55:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607021749;
        bh=EfLvReCiv4Wlz9AfYVhW6cO3n4jUMp+CptkDdC10U7Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LnN3azw7Fd7YbdbrigoY4OqNcA2t/Q6rlk3PoxZ9mEygGTm5Qn1x62EtOUXk2j03K
         wvMqjNU2qxh8ZWL6dbS57r1mze+AuIHKdN48DaRoRh1WDrcsf5pb31wkUD4KrBSV6F
         kcjn7Ed9TIDoMzLr5e52fioSSWhccHXcjT1NkbgS9zfDTHDLLaRnv5JbXR4rf0Mm7i
         IfGfPiN17EdB0D0B2JO/Sw4rwZA1Gmhym8Cu2F3DEAEQlIX1yaosd2byEH7sxOxvEI
         g+3oOHoGavvj+KRVRUxX67gPJaaIwNKNkIj3MJ79zAauVwC2JMpGyTDp0ISLS4fiJc
         uPiC4o9dpnbJw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] chelsio/chtls: fix a double free in chtls_setkey()
Message-ID: <20201203105547.13364c00@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <X8ilb6PtBRLWiSHp@mwanda>
References: <X8ilb6PtBRLWiSHp@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 11:44:31 +0300 Dan Carpenter wrote:
> The "skb" is freed by the transmit code in cxgb4_ofld_send() and we
> shouldn't use it again.  But in the current code, if we hit an error
> later on in the function then the clean up code will call kfree_skb(skb)
> and so it causes a double free.
> 
> Set the "skb" to NULL and that makes the kfree_skb() a no-op.
> 
> Fixes: d25f2f71f653 ("crypto: chtls - Program the TLS session Key")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks!
