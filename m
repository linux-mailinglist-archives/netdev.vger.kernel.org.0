Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E832A5028
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgKCTby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:31:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgKCTby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:31:54 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D632080D;
        Tue,  3 Nov 2020 19:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604431913;
        bh=S+XTa/Ddbvh+IsyG31DYZypsQ7ugisv/L9FbS0/2MT0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k04pehKHXgSp1gCBIIxlvyMNlN4PLVoxEtSR7x5/ZEXOffB4o52TItFE+b2KZHrSW
         SwG4YWmCouheXFGspowoxdbzUcr7oLJZsERO8RhQv1Z0b4p6KyHByvoVgVxn9pD+7V
         zZfoeuawcOmpYjV+yEzum15EHJsBhYetDi8Izc74=
Message-ID: <2eeb1f2ccce034455babdef88a275b4e5ebfba81.camel@kernel.org>
Subject: Re: [PATCH net-next 04/15] net: mlx5: Replace in_irq() usage.
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Aymen Sghaier <aymen.sghaier@nxp.com>,
        Daniel Drake <dsd@gentoo.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia =?UTF-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
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
Date:   Tue, 03 Nov 2020 11:31:50 -0800
In-Reply-To: <20201031095938.3878412e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
         <20201027225454.3492351-5-bigeasy@linutronix.de>
         <20201031095938.3878412e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-10-31 at 09:59 -0700, Jakub Kicinski wrote:
> On Tue, 27 Oct 2020 23:54:43 +0100 Sebastian Andrzej Siewior wrote:
> > mlx5_eq_async_int() uses in_irq() to decide whether eq::lock needs
> > to be
> > acquired and released with spin_[un]lock() or the irq
> > saving/restoring
> > variants.
> > 
> > The usage of in_*() in drivers is phased out and Linus clearly
> > requested
> > that code which changes behaviour depending on context should
> > either be
> > seperated or the context be conveyed in an argument passed by the
> > caller,
> > which usually knows the context.
> > 
> > mlx5_eq_async_int() knows the context via the action argument
> > already so
> > using it for the lock variant decision is a straight forward
> > replacement
> > for in_irq().
> > 
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Cc: Saeed Mahameed <saeedm@nvidia.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: linux-rdma@vger.kernel.org
> 
> Saeed, please pick this up into your tree.

Applied to net-next-mlx5 will submit to net-next shortly.

