Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B48F5EE8AC
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbfKDTdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:33:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50586 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDTdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:33:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 592F6151D7249;
        Mon,  4 Nov 2019 11:33:45 -0800 (PST)
Date:   Mon, 04 Nov 2019 11:33:44 -0800 (PST)
Message-Id: <20191104.113344.1336648901043158957.davem@davemloft.net>
To:     christophe.roullier@st.com
Cc:     robh@kernel.org, joabreu@synopsys.com, mark.rutland@arm.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH net-next 1/4] net: ethernet: stmmac: Add support for
 syscfg clock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191104132533.5153-2-christophe.roullier@st.com>
References: <20191104132533.5153-1-christophe.roullier@st.com>
        <20191104132533.5153-2-christophe.roullier@st.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 11:33:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe Roullier <christophe.roullier@st.com>
Date: Mon, 4 Nov 2019 14:25:30 +0100

> +				if (dwmac->syscfg_clk)
> +					goto unprepare_syscfg;
>  				return ret;
 ...
> +unprepare_syscfg:
> +	clk_disable_unprepare(dwmac->syscfg_clk);
> +
> +	return ret;

This is so amazingly silly.  You're doing a goto instead of the
clk_disable_unprepare() call itself.

Please don't do this.
