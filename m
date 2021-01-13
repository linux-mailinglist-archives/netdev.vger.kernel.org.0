Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BF72F55E6
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbhAMXyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 18:54:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729638AbhAMXwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 18:52:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 050EC2250E;
        Wed, 13 Jan 2021 23:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610581824;
        bh=n7YXgMJK4exfAdhH0ZlRuWIleZ/O3yTamEthjIUsP5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qTZvVGHO5xkgxLTNWBficKuvKvJ2AJvrzQz3PZkBU4r6hmI/HI9b8x9wDGzlGBBcY
         DYN7ivH/SZg/kSHslr0oEgV0ZiCU/ZPkkaDwh9eiViCOLJj65ZV0GDOdlbYV6J6mC0
         V6Rwbi4vhK4PRxVWG2qBiNhH6nbIR2mZbiApCpvefyt651eGs7DZSWviACy9e3O9jU
         p9Q5hdBMbliTrUe0y4CYPa/YMIze5rGBVLfIkSphLCz0JOx3sWxv+N8SX8htJTjsuj
         kCBQPZ2Ch4brgC0WfehQ8zKr1JPivxVSYqwcWvcX7riCaq3DTuOgANvCAY77mSowcI
         lilxyC/d9qzPw==
Date:   Wed, 13 Jan 2021 15:50:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: use __napi_schedule() for PREEMPT_RT
Message-ID: <20210113155023.1f52ee4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112140121.1487619-1-sebastien.laveze@oss.nxp.com>
References: <20210112140121.1487619-1-sebastien.laveze@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 15:01:22 +0100 Sebastien Laveze wrote:
> From: Seb Laveze <sebastien.laveze@nxp.com>
> 
> Use of __napi_schedule_irqoff() is not safe with PREEMPT_RT in which
> hard interrupts are not disabled while running the threaded interrupt.
> 
> Using __napi_schedule() works for both PREEMPT_RT and mainline Linux,
> just at the cost of an additional check if interrupts are disabled for
> mainline (since they are already disabled).
> 
> Similar to the fix done for enetc:
> 215602a8d212 ("enetc: use napi_schedule to be compatible with PREEMPT_RT")
> 
> Signed-off-by: Seb Laveze <sebastien.laveze@nxp.com>

Fixed up the commit message to appease checkpatch and applied, thanks!
