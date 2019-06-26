Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F5E56E67
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfFZQLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:11:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37258 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZQLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:11:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4719D144FF0E6;
        Wed, 26 Jun 2019 09:11:02 -0700 (PDT)
Date:   Wed, 26 Jun 2019 09:11:01 -0700 (PDT)
Message-Id: <20190626.091101.141287264489993877.davem@davemloft.net>
To:     jonathanh@nvidia.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] net: stmmac: Fix crash observed if PHY does not
 support EEE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190626102322.18821-2-jonathanh@nvidia.com>
References: <20190626102322.18821-1-jonathanh@nvidia.com>
        <20190626102322.18821-2-jonathanh@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 09:11:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>
Date: Wed, 26 Jun 2019 11:23:22 +0100

> If the PHY does not support EEE mode, then a crash is observed when the
> ethernet interface is enabled. The crash occurs, because if the PHY does
> not support EEE, then although the EEE timer is never configured, it is
> still marked as enabled and so the stmmac ethernet driver is still
> trying to update the timer by calling mod_timer(). This triggers a BUG()
> in the mod_timer() because we are trying to update a timer when there is
> no callback function set because timer_setup() was never called for this
> timer.
> 
> The problem is caused because we return true from the function
> stmmac_eee_init(), marking the EEE timer as enabled, even when we have
> not configured the EEE timer. Fix this by ensuring that we return false
> if the PHY does not support EEE and hence, 'eee_active' is not set.
> 
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>

Applied.
