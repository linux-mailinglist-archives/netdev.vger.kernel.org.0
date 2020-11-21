Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED7D2BC23A
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 22:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgKUVM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 16:12:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbgKUVM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 16:12:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 295E620936;
        Sat, 21 Nov 2020 21:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605993176;
        bh=5OPPnpq/liVUWNllLDEUx0dDdVZMbmJ0cKnxA3Np6Wo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TJf81O9iWgDkMRsKxus7fTh1DV90KlvDX7Y+OvA1xsTfI2Ft5Lr8nS4tARGmjn5cA
         Oe2LbQzsOvAbfKkgUQjnWWJNIxm1F0ooIyMDzfRxIJ4LNw+wun380CHUVI0nZh1a9E
         //aVETFUFuu2Npa8YoKGyNrau7/9N+mswV8iapdU=
Date:   Sat, 21 Nov 2020 13:12:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Seewald <tseewald@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, ayush.sawal@chelsio.com, rajur@chelsio.com
Subject: Re: [PATCH] cxgb4: Fix build failure when CONFIG_TLS=m
Message-ID: <20201121131255.051420ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120192528.615-1-tseewald@gmail.com>
References: <20201120073502.4beeb482@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201120192528.615-1-tseewald@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 13:25:28 -0600 Tom Seewald wrote:
> After commit 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
> whenever CONFIG_TLS=m and CONFIG_CHELSIO_T4=y, the following build
> failure occurs:
> 
> ld: drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.o: in function
> `cxgb_select_queue':
> cxgb4_main.c:(.text+0x2dac): undefined reference to `tls_validate_xmit_skb'
> 
> Fix this by ensuring that if TLS is set to be a module, CHELSIO_T4 will
> also be compiled as a module. As otherwise the cxgb4 driver will not be
> able to access TLS' symbols.
> 
> Fixes: 9d2e5e9eeb59 ("cxgb4/ch_ktls: decrypted bit is not enough")
> Signed-off-by: Tom Seewald <tseewald@gmail.com>

Applied, thanks!
