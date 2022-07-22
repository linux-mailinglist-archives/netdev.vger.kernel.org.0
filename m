Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BA157DBB6
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbiGVIFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiGVIFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:05:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FEA220D7;
        Fri, 22 Jul 2022 01:05:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F3EFB8273C;
        Fri, 22 Jul 2022 08:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC80C341C7;
        Fri, 22 Jul 2022 08:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658477118;
        bh=yUhsbre7Stproz/pyPmCOnXy2UEDnrMFtsx9JT7/4UE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lTaP3UZI7UI3JMkZGYSU9epa2+hQZ1e5A9IqSPVyI4OtTLWec61P5nBM4ta3SdVTS
         h6UVPj07kXmxF5hNfY3qI1UG1aToKlbJ29ZEHR4W8fISDRhKcDXkE0M6Oi4deKUV5X
         QBCB/ZHtOrGqk1rsfAr7xnudGr2wd9AqXk9dafqfIpbgiMV5z3Ribdjr/3VHMT+9Yg
         XMQ4pgPYqc8Zb8k0+DdrT70JHOR4P6q+ZRduKXVN9UyIfMIvn5rpCbH9x+NNt8LGBo
         LunegZ4ObeD8G/yweaKTK2EiP2BKXLWc6CLWKUJh50A4xh7nYGZdBdciU81yeLXS9d
         lM4ja2j5OT4jw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oEnez-0001XR-8R; Fri, 22 Jul 2022 10:05:21 +0200
Date:   Fri, 22 Jul 2022 10:05:21 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: mac80211/ath11k regression in next-20220720
Message-ID: <YtpaQXhM5wuz4Zbq@hovoldconsulting.com>
References: <YtpXNYta924al1Po@hovoldconsulting.com>
 <0a400422546112e91e087ce285ec5a532193ada3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a400422546112e91e087ce285ec5a532193ada3.camel@sipsolutions.net>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 09:54:57AM +0200, Johannes Berg wrote:
> On Fri, 2022-07-22 at 09:52 +0200, Johan Hovold wrote:
> > Hi,
> > 
> > After moving from next-20220714 to next-20220720, ath11k stopped
> > working here and instead spits out a bunch of warnings (see log below).
> > 
> > I noticed that this series from Johannes was merged in that period:
> > 
> > 	https://lore.kernel.org/all/20220713094502.163926-1-johannes@sipsolutions.net/
> > 
> > but can't say for sure that it's related. I also tried adding the
> > follow-up fixes from the mld branch:
> > 
> > 	https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git/log/?h=mld
> > 
> > but it didn't seem to make any difference.
> > 
> > Any ideas about what might be going on here?
> > 
> 
> We think the "fix" is this:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git/commit/?h=mld&id=dd5a559d8e90fdb9424e0580b91702c5838928dc
> 
> Do you want to try it?

Thanks for the quick reply. And yes, that fixes the problem.

I apparently failed to apply all commits from that mld branch, but this
one alone fixes it.

> Note that if that fixes it, it's still a bug in the driver, but one that
> you'd otherwise not hit.

Yeah, those warnings looked like secondary issues if that's what you're
referring to?
 
> Anyway I'll do some tree shuffling today and get that in.

Thanks!

Johan
