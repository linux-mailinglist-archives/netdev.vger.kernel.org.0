Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE2D2A18D6
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 17:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgJaQ7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 12:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgJaQ7k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 12:59:40 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2138020679;
        Sat, 31 Oct 2020 16:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604163579;
        bh=lDhAL0eL5RojYfF/GFsNMNdak8tx6KUFC/4p8XlKQ+0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WPRhV/HezItBXgNi5d2ycQq4A4eUJK+BThEYto+xOSJ4smwlD233EQe/+MSo6OUG7
         hAcoU/6GPl+ouTcU4vvF9vbkmuEbzLsBiM3DqzmAvhBNjBOSNGEpRMg+65J1cQxune
         Ku7TDFT5KDbD/PDEsn/bQLdlZEwFITorDxMKVTVQ=
Date:   Sat, 31 Oct 2020 09:59:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Aymen Sghaier <aymen.sghaier@nxp.com>,
        Daniel Drake <dsd@gentoo.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta@nxp.com>,
        Jon Mason <jdmason@kudzu.us>, Jouni Malinen <j@w1.fi>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Samuel Chessman <chessman@tux.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 04/15] net: mlx5: Replace in_irq() usage.
Message-ID: <20201031095938.3878412e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027225454.3492351-5-bigeasy@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
        <20201027225454.3492351-5-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 23:54:43 +0100 Sebastian Andrzej Siewior wrote:
> mlx5_eq_async_int() uses in_irq() to decide whether eq::lock needs to be
> acquired and released with spin_[un]lock() or the irq saving/restoring
> variants.
> 
> The usage of in_*() in drivers is phased out and Linus clearly requested
> that code which changes behaviour depending on context should either be
> seperated or the context be conveyed in an argument passed by the caller,
> which usually knows the context.
> 
> mlx5_eq_async_int() knows the context via the action argument already so
> using it for the lock variant decision is a straight forward replacement
> for in_irq().
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-rdma@vger.kernel.org

Saeed, please pick this up into your tree.
