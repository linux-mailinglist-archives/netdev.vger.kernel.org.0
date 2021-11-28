Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C564608FE
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 19:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345056AbhK1SfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 13:35:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55598 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346768AbhK1SbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 13:31:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CCE4610E8
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 18:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4374C004E1;
        Sun, 28 Nov 2021 18:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638124075;
        bh=IopLbOhbLnb13+Wef47Nl0VNLDea/FXEXI9XcXbqCaw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YbDFpxdUg7ku24lG2LpRCXM38TsC62kTLC6UKq2ejpKVfc+fhbRde0jZ9GNkVDCXy
         dm/3rh0oRCy5rtOJcrz4FnCG8ziOAZsaGa4Z+GwuMW+2gsxdbMU3MojFW/asvIWcM3
         DNmaabk5KyUJPetmJoXzBPtmMrafVlYpg/rQ7mHlerWLrclDnTazFlTGWeEyal4jhN
         bBkZBIlE4XjmxH7NaFz7I5pdweruk9SSN4/qChY1By8jCWlXSevF6z7ykUPO9Oir+L
         wm37GepZZl3nvRmfzB9+ONRG/MhUI228mopNiRPH1dI6rk8XZ0fzyR6chbxWfPUJuC
         pFc/FDmPauwlw==
Date:   Sun, 28 Nov 2021 20:27:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH RESEND net-next 0/5] WWAN debugfs tweaks
Message-ID: <YaPKJ1JADMxheh0b@unreal>
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 28, 2021 at 03:55:17PM +0300, Sergey Ryazanov wrote:
> Resend with proper target tree. Also I should mention that the series is
> mostly compile-tested since I do not have IOSM supported device, so it
> needs Ack from the IOSM developers.
> 
> This is a follow-up series to just applied IOSM (and WWAN) debugfs
> interface support [1]. The series has two main goals:
> 1. move the driver-specific debugfs knobs to a subdirectory;
> 2. make the debugfs interface optional for both IOSM and for the WWAN
>    core.
> 
> As for the first part, I must say that it was my mistake. I suggested to
> place debugfs entries under a common per WWAN device directory. But I
> missed the driver subdirectory in the example, so it become:
> 
> /sys/kernel/debugfs/wwan/wwan0/trace
> 
> Since the traces collection is a driver-specific feature, it is better
> to keep it under the driver-specific subdirectory:
> 
> /sys/kernel/debugfs/wwan/wwan0/iosm/trace
> 
> It is desirable to be able to entirely disable the debugfs interface. It
> can be disabled for several reasons, including security and consumed
> storage space.

When such needs arise, the disable is done with CONFIG_DEBUGFS knob and
not with per-subsystem configs.

I personally see your CONFIG_*_DEBUGFS patches as a mistake, which
complicates code without any gain at all. Even an opposite is true,
by adding more knobs, you can find yourself with the system which
has CONFIG_DEBUGFS enabled but with your CONFIG_*_DEBUGFS disabled.

Thanks
