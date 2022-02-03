Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD3A4A8840
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352104AbiBCQDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiBCQDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:03:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7482CC061714;
        Thu,  3 Feb 2022 08:03:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33E30B834DE;
        Thu,  3 Feb 2022 16:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A3AC340E8;
        Thu,  3 Feb 2022 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643904192;
        bh=LC6Uw/4iRQgEicjbz3l1kpey9eelEu6Mf2oUdApElRY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p7TJFRlKrrWTfGlxLXYrCX+per1Zny4gr933z+b62n42fOQH8hkxlsn4tLMxDY4wZ
         NzGBmB+ak/Rh4v/UzQ1odA7wnzlIwDNlZ4p8aBbzecTrzCm/fzFHGvug7LOrrg8wS3
         r3wMRQCPg/UgNA7thgc4qN7HV3IeK+4pNY7EsjEbzUGBqWkJL/rArfpABpU9p6jyVw
         hPINXK/OhTS4kw5wUTbwlJ9q6xWO7mP1k0aHxNokxImyuKkxvxoTwHBtXhXp9epg1Y
         h2baXAhv3qb1v4JwUPebc45XB6EUVu4IsMqHeHpI3NtfEJZgrY/CkyEWjj1PREVWcm
         d+dkL6x8QSTUA==
Date:   Thu, 3 Feb 2022 08:03:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, robh+dt@kernel.org,
        bjorn.andersson@linaro.org, agross@kernel.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: ipa: request IPA register values be
 retained
Message-ID: <20220203080309.3b085a97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6d303dbb-bdbc-bac1-526d-be593f329d23@linaro.org>
References: <20220201140412.467233-1-elder@linaro.org>
        <20220201140412.467233-3-elder@linaro.org>
        <20220202210248.6e3f92ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6d303dbb-bdbc-bac1-526d-be593f329d23@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 05:22:23 -0600 Alex Elder wrote:
> On 2/2/22 11:02 PM, Jakub Kicinski wrote:
> > On Tue,  1 Feb 2022 08:04:12 -0600 Alex Elder wrote:  
> >> Fixes: 2775cbc5afeb6 ("net: ipa: rename "ipa_clock.c"")  
> > 
> > The Fixes tag should point at the place the code was introduced,
> > even if it moved or otherwise the patch won't apply as far back.  
> 
> The problem was not "activated" until this commit:
>    1aac309d32075 net: ipa: use autosuspend
> 
> 
> And that commit was merged together in a series that
> included the one I mentioned above:
>    2775cbc5afeb6 net: ipa: rename "ipa_clock.c"
> 
> The rename commit is two commits after "use autosuspend".
> 
> The merge commit was:
>    863434886497d Merge branch 'ipa-autosuspend'
> 
> 
> Until autosuspend is enabled, this new code is
> completely unnecessary, so back-porting it beyond
> that is pointless.  I supplied the commit in the
> "Fixes" tag because I thought it would be close
> to equivalent and would avoid some trouble back-porting.
> 
> Perhaps the "use autosuspend" commit is the one that
> should be in the "Fixes" tag, but I don't believe it
> should be back-ported any further than that.
> 
> Re-spinning the series to fix the tag is trivial, but
> before I do that, can you tell me which commit you
> recommend I use in the "Fixes" tag?
> 
> The original commit that introduced the microcontroller
> code (and also included the clock/power code) is:
>    a646d6ec90983 soc: qcom: ipa: modem and microcontroller

Thanks for the explanation 1aac309d32075 sounds like the right choice.
Let me just swap it for you and apply the v2.
