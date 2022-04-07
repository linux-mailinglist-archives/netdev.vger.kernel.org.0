Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096F44F8666
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346480AbiDGRoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346512AbiDGRoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:44:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D68228ABC;
        Thu,  7 Apr 2022 10:42:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9233261AE1;
        Thu,  7 Apr 2022 17:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F71C385A6;
        Thu,  7 Apr 2022 17:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649353355;
        bh=D3po4An1h0oHihhacUGAId0URTwmJZ35j6bwJNecFb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZFoHVruocz5KD4PDoMOSjOiTOmnqN/Q9Z+VArlqHeruCE2jG18SGBO3z0wb33DI5W
         1R2V633+F3UFFAgncSqjy4hNEC7FkOqfoJvDrFnDITjirr5Zdiy4ep7mDpuR2iN6fp
         pWshFZeqUJUbCDCghjx5SWCfuOaakF1lW7JaaO5g=
Date:   Thu, 7 Apr 2022 19:42:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v10 0/1] wfx: get out from the staging area
Message-ID: <Yk8iiZKFpYNgCbCz@kroah.com>
References: <20220226092142.10164-1-Jerome.Pouiller@silabs.com>
 <YhojjHGp4EfsTpnG@kroah.com>
 <87wnhhsr9m.fsf@kernel.org>
 <5830958.DvuYhMxLoT@pc-42>
 <878rslt975.fsf@tynnyri.adurom.net>
 <20220404232247.01cc6567@kernel.org>
 <20220404232930.05dd49cf@kernel.org>
 <878rskrod1.fsf@kernel.org>
 <20220405092046.465ff7e5@kernel.org>
 <875ynmr8qu.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875ynmr8qu.fsf@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 10:06:33AM +0300, Kalle Valo wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > On Tue, 05 Apr 2022 10:16:58 +0300 Kalle Valo wrote:
> >> Sure, that would technically work. But I just think it's cleaner to use
> >> -rc1 (or later) as the baseline for an immutable branch. If the baseline
> >> is an arbitrary commit somewhere within merge windows commits, it's more
> >> work for everyone to verify the branch is suitable.
> >> 
> >> Also in general I would also prefer to base -next trees to -rc1 or newer
> >> to make the bisect cleaner. The less we need to test kernels from the
> >> merge window (ie. commits after the final release and before -rc1) the
> >> better.
> >> 
> >> But this is just a small wish from me, I fully understand that it might
> >> be too much changes to your process. Wanted to point out this anyway.
> >
> > Forwarded!
> 
> Awesome, thank you Jakub!
> 
> Greg, I now created an immutable branch for moving wfx from
> drivers/staging to drivers/net/wireless/silabs:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git wfx-move-out-of-staging
> 
> The baseline for this branch is v5.18-rc1. If you think the branch is
> ok, please pull it to staging-next and let me know. I can then pull the
> branch to wireless-next and the transition should be complete. And do
> let me know if there are any problems.

Looks great to me!  I've pulled it into staging-next now.  And will not
take any more patches to the driver (some happened before the merge but
git handled the move just fine.)

thanks!

greg k-h
