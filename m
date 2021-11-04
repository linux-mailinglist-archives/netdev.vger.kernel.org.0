Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8C0445853
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhKDRcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231709AbhKDRcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8F96610D0;
        Thu,  4 Nov 2021 17:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636046975;
        bh=jqOaHAleoMAYNHqOASMGyfT9PLNNxKiJ1RUKdmVsJAA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IJPiONKiNGrTvdQ5UBzinQR7+IR0RX/BsXJI55A6ZD0TSlo8TUd0pTDfRgZkHhaIL
         DTgy+fLPsTS0VI2+qkqmS8sde1JbI8tpdXxueL23HuUtRDw9pPSVl6BF8BnHXVbZVU
         R2pk9C5lwvH8w0UGusrP7H0gV1Y1dqwqegdELW87QV52XG0g8wX6lKFrUil1GuEyAz
         dMOgJIYQtSfCv8T+th+8Xw4310QH1f260K22HpzKo47dC6Q+2bH5uSOhUNfQV1jAAW
         IqtIKHfBxGMjJXH1DcdvwnRhXhLDpx+6J7LTPJtJBNXy7GPii4480bxqnoAT8E1Vzx
         yx8lJup6gWpSQ==
Date:   Thu, 4 Nov 2021 10:29:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Kaistra <martin.kaistra@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] Add PTP support for BCM53128 switch
Message-ID: <20211104102933.3c6f5b12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211104133204.19757-1-martin.kaistra@linutronix.de>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Nov 2021 14:31:54 +0100 Martin Kaistra wrote:
> this series adds PTP support to the b53 DSA driver for the BCM53128
> switch using the BroadSync HD feature.
> 
> As there seems to be only one filter (either by Ethertype or DA) for
> timestamping incoming packets, only L2 is supported.
> 
> To be able to use the timecounter infrastructure with a counter that
> wraps around at a non-power of two point, patch 2 adds support for such
> a custom point. Alternatively I could fix up the delta every time a
> wrap-around occurs in the driver itself, but this way it can also be
> useful for other hardware.

Please make sure that the code builds as a module and that each patch
compiles cleanly with W=1 C=1 flags set - build the entire tree first
with W=1 C=1 cause there will be extra warning noise, then apply your
patches one by one and recompile, there should be no warnings since b53
itself builds cleanly.
