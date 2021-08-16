Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3CF3EDE83
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhHPUUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 16:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231203AbhHPUUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 16:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68BC860EE4;
        Mon, 16 Aug 2021 20:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629145177;
        bh=09JRx2dySPG/sAhx0CkMmhxCvBRYMblxMdlNtD0kqpQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kDcESZoK8HKpu7ANMHREih417+vUAUbkjxFvNYWJJ3d6jCd+1jlaujtE5RAxOkbWa
         McHWeepTvco+2hzQqIojxgdc48TWKI/MKVmBRjRaD7OOnHjMEqtdeO8q2mMHvmS/HY
         RU6sBv+PEzrQkS8vPpe6hpUw94nDMeACFu5td4VFhvBUiLs8mnzeVfgoe+5F3Wc2oo
         FJIgroUGflDmU/jX0BZCwXNBbO8A0exhv4GJMQTj5WmvHj5YVoYmfoFIEM6hNDHSn5
         Agxf4xoz/tVKFqeorVPhPv76chkUVucIJh5VA3jlWavBMCLajuRgnw5bB1PhYdENGN
         uh52cPMF9Yg2w==
Date:   Mon, 16 Aug 2021 13:19:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] net: ipa: ensure hardware has power in
 ipa_start_xmit()
Message-ID: <20210816131936.3118119d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ebc4e7af-8300-307c-9278-25fdd6bf1e65@linaro.org>
References: <20210812195035.2816276-1-elder@linaro.org>
        <20210812195035.2816276-5-elder@linaro.org>
        <20210813174655.1d13b524@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3a9e82cc-c09e-62e8-4671-8f16d4f6a35b@linaro.org>
        <20210816071543.39a44815@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b6b1ca41-36de-bcb1-30ca-6e8d8bfcc5a9@linaro.org>
        <ebc4e7af-8300-307c-9278-25fdd6bf1e65@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Aug 2021 12:56:40 -0500 Alex Elder wrote:
> I'm finding this isn't an easy problem to solve (or even think
> about).  While I ponder the best course of action I'm going
> to send out another series (i.e., *before* I send a fix for
> this issue) because I'd like to get everything I have out
> for review this week.  I *will* address this potential race
> one way or another, possibly later today.

Alright, thanks for the heads up.
