Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A63B123FD7
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfLRG4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:56:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfLRG4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:56:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2447315036C0C;
        Tue, 17 Dec 2019 22:56:15 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:56:14 -0800 (PST)
Message-Id: <20191217.225614.1797207200536618024.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 6/8] net: stmmac: RX buffer size must be 16 byte
 aligned
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8d7b87265a2727a28896203f5569d7039c2c34c8.1576581853.git.Jose.Abreu@synopsys.com>
References: <cover.1576581853.git.Jose.Abreu@synopsys.com>
        <cover.1576581853.git.Jose.Abreu@synopsys.com>
        <8d7b87265a2727a28896203f5569d7039c2c34c8.1576581853.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 22:56:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Tue, 17 Dec 2019 12:42:36 +0100

> We need to align the RX buffer size to at least 16 byte so that IP
> doesn't mis-behave. This is required by HW.
 ...
>  
> -#define	STMMAC_ALIGN(x)		__ALIGN_KERNEL(x, SMP_CACHE_BYTES)
> +#define	STMMAC_ALIGN(x)		ALIGN_DOWN(ALIGN_DOWN(x, SMP_CACHE_BYTES), 16)

You need to align up, not down.
