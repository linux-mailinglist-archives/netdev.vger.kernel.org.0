Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E9124A9E7
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 01:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgHSXZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 19:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSXZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 19:25:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83C7C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 16:25:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A72011DB315F;
        Wed, 19 Aug 2020 16:09:03 -0700 (PDT)
Date:   Wed, 19 Aug 2020 16:25:48 -0700 (PDT)
Message-Id: <20200819.162548.1211800869018001410.davem@davemloft.net>
To:     bigeasy@linutronix.de
Cc:     irusskikh@marvell.com, netdev@vger.kernel.org,
        mstarovoitov@marvell.com, kuba@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH NET] net: atlantic: Use readx_poll_timeout() for large
 timeout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818161439.3dkf6jzp3vuwmvvh@linutronix.de>
References: <20200818161439.3dkf6jzp3vuwmvvh@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 16:09:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Tue, 18 Aug 2020 18:14:39 +0200

> Commit
>    8dcf2ad39fdb2 ("net: atlantic: add hwmon getter for MAC temperature")
> 
> implemented a read callback with an udelay(10000U). This fails to
> compile on ARM because the delay is >1ms. I doubt that it is needed to
> spin for 10ms even if possible on x86.
> 
> From looking at the code, the context appears to be preemptible so using
> usleep() should work and avoid busy spinning.
> 
> Use readx_poll_timeout() in the poll loop.
> 
> Cc: Mark Starovoytov <mstarovoitov@marvell.com>
> Cc: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Applied, thanks.
