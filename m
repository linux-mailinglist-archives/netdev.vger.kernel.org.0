Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8562A0D61
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgJ3S3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727055AbgJ3S3D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 14:29:03 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B15720702;
        Fri, 30 Oct 2020 18:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604082542;
        bh=T+9rwp4yVvdDVmqCTMI4J0+lif+YYrb6qw5IVuzKMoE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MIS4KY1J3r4JBmDfIwmP17X64aSTEg7voFCa7w9Tj72useO0Y96wHqtOAew6nNViV
         wqsc+1Y5IFshsOupCVLpIoqTC6s7JDJVi6q3Bz+c3t1d0x+K/XvrhUMitpBcFiZpJ2
         X5bIJJybGh+aXi+2T7b0fAsCfhJKTFATkXHLTeP8=
Date:   Fri, 30 Oct 2020 11:29:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, Aymen Sghaier <aymen.sghaier@nxp.com>,
        Daniel Drake <dsd@gentoo.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta@nxp.com>,
        Jon Mason <jdmason@kudzu.us>, Jouni Malinen <j@w1.fi>,
        Kalle Valo <kvalo@codeaurora.org>,
        Leon Romanovsky <leon@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Samuel Chessman <chessman@tux.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 00/15] in_interrupt() cleanup, part 2
Message-ID: <20201030112900.08bd1750@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027225454.3492351-1-bigeasy@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 23:54:39 +0100 Sebastian Andrzej Siewior wrote:
> Folks,
> 
> in the discussion about preempt count consistency across kernel configurations:
> 
>   https://lore.kernel.org/r/20200914204209.256266093@linutronix.de/
> 
> Linus clearly requested that code in drivers and libraries which changes
> behaviour based on execution context should either be split up so that
> e.g. task context invocations and BH invocations have different interfaces
> or if that's not possible the context information has to be provided by the
> caller which knows in which context it is executing.
> 
> This includes conditional locking, allocation mode (GFP_*) decisions and
> avoidance of code paths which might sleep.
> 
> In the long run, usage of 'preemptible, in_*irq etc.' should be banned from
> driver code completely.
> 
> This is part two addressing remaining drivers except for orinoco-usb.

Freescale folks - can I get an ack for merging the last three patches
into net-next?
