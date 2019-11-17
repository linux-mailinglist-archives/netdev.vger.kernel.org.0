Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF47FFB62
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 19:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfKQSgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 13:36:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35368 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfKQSgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 13:36:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 47C06153E3852;
        Sun, 17 Nov 2019 10:36:04 -0800 (PST)
Date:   Sun, 17 Nov 2019 10:36:02 -0800 (PST)
Message-Id: <20191117.103602.1078870124245169278.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, apinski@marvell.com,
        pbhagavatula@marvell.com, sgoutham@marvell.com
Subject: Re: [PATCH 12/15] octeontx2-af: Add TIM unit support.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1574007266-17123-13-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
        <1574007266-17123-13-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 Nov 2019 10:36:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sunil.kovvuri@gmail.com
Date: Sun, 17 Nov 2019 21:44:23 +0530

> +static u64 get_tenns_tsc(void)
> +{
> +	u64 tsc = 0;
> +
> +#if defined(CONFIG_ARM64)
> +	asm volatile("mrs %0, cntvct_el0" : "=r" (tsc));
> +#endif
> +	return tsc;
> +}
> +
> +static u64 get_tenns_clk(void)
> +{
> +	u64 tsc = 0;
> +
> +#if defined(CONFIG_ARM64)
> +	asm volatile("mrs %0, cntfrq_el0" : "=r" (tsc));
> +#endif
> +	return tsc;
> +}

You cannot do this.

Read the tick register of the cpu in a portable way, we have interfaces for
this.  If not, create one.

