Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D89C9590
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 02:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfJCAWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 20:22:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38664 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbfJCAWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 20:22:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A6B415527ED1;
        Wed,  2 Oct 2019 17:22:14 -0700 (PDT)
Date:   Wed, 02 Oct 2019 17:22:13 -0700 (PDT)
Message-Id: <20191002.172213.1475260023258384833.davem@davemloft.net>
To:     thierry.reding@gmail.com
Cc:     joabreu@synopsys.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, f.fainelli@gmail.com, bbiswas@nvidia.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: Avoid deadlock on suspend/resume
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191002144946.176976-1-thierry.reding@gmail.com>
References: <20191002144946.176976-1-thierry.reding@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 17:22:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Wed,  2 Oct 2019 16:49:46 +0200

> From: Thierry Reding <treding@nvidia.com>
> 
> The stmmac driver will try to acquire its private mutex during suspend
> via phylink_resolve() -> stmmac_mac_link_down() -> stmmac_eee_init().
> However, the phylink configuration is updated with the private mutex
> held already, which causes a deadlock during suspend.
> 
> Fix this by moving the phylink configuration updates out of the region
> of code protected by the private mutex.
> 
> Fixes: 19e13cb27b99 ("net: stmmac: Hold rtnl lock in suspend/resume callbacks")
> Suggested-by: Bitan Biswas <bbiswas@nvidia.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Applied.
