Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70122A2243
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 00:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgKAXEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 18:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbgKAXEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 18:04:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1222BC0617A6;
        Sun,  1 Nov 2020 15:04:48 -0800 (PST)
Date:   Mon, 2 Nov 2020 00:04:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604271886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hTz98QayFDBHYxMPWUtO7gaEkyZ/vOcdTDDbAj+qRew=;
        b=RMU/zjUYLCUjVRchj6Lg3u4Z19FFUmuHwlDZ2qGVpy/BdoA3b//QydpJ7N7D+WmAoRB0IH
        pmV1W/0VeokRopnyeRg+ygSZZOfWKGYRwtyI5HiyH0TUIGejGgymkIN4DKkHfDbRSJQn8e
        rT5+PlUZP2ugKmnOCJm35JryUgdJb7ljV7ykRm6tF2faCdOtJej9FtWwHhc6hSX3h1uEDH
        Gd4WxxV8TJ6q2juUmfy5klRvhEADPp4nTFTDxGw/BMqURzqkJLdvmfM4w3u6QgmPIid7Rl
        NX1YuzWXGWY+YLx3NL0aXhAOvMJaZv3rGHCSwHHqsUjDwq+K5lyxO0Uo8/q1sA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604271886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hTz98QayFDBHYxMPWUtO7gaEkyZ/vOcdTDDbAj+qRew=;
        b=tnpRn8tRWR4CI2WkiILhCMpdG2/AknpJnnJmkdPNVstOdtLFWUfk/KI2sY0XDMTfc58jfy
        8FUsfwCSSqWeBgCw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
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
Subject: Re: [PATCH net-next 14/15] net: dpaa: Replace in_irq() usage.
Message-ID: <20201101230444.x5dxzarehepyynp3@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
 <20201027225454.3492351-15-bigeasy@linutronix.de>
 <20201031101215.38a13e51@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201031101215.38a13e51@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-31 10:12:15 [-0700], Jakub Kicinski wrote:
> Nit: some networking drivers have a bool napi which means "are we
> running in napi context", the semantics here feel a little backwards,
> at least to me. But if I'm the only one thinking this, so be it.

I renamed it to `sched_napi'.

Sebastian
