Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11444CB670
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 06:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiCCFej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 00:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCCFej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 00:34:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF6F11172
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 21:33:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E83DBCE24ED
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 05:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EACC004E1;
        Thu,  3 Mar 2022 05:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646285631;
        bh=3Bd1SQdQxLngXUadpD8Z9sNrtSoC9S3G6IzadNVNh5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lCUKwH87kCu8XIeUMsgz9JXVJYGfMgcXzQOUuzxtgp3ySZEdMllvBu6o8z2pV3e0J
         rXyzgbS933PsxKYQmcVo+QEwRK+OAZlmJLyP6IZuq2q9V9CNqsPBbv2xS0tE6scx7D
         aEFRlTTLEehdFxTS0PbLU1OO23GQ4C4SW0LvCqeHydRFxsm+kGG9vHNxt5HdXZAxRm
         FPGi5mGyZmuJg6/Cmqo8qhCs4gf+H4R9iifijenPde8f75HEkMeGcbYTb9NXHjd4LV
         i+5h2E9Yiu+Vqx41jQ9U5bhgljtD3qFBVADAHF0gbjmaGPZm6w4p7aAl5X0Fn11Jdj
         jibkV2sk9mARA==
Date:   Wed, 2 Mar 2022 21:33:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kai Lueke <kailueke@linux.microsoft.com>,
        Paul Chaignon <paul@cilium.io>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Eyal Birger <eyal.birger@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return
 error"
Message-ID: <20220302213349.0ea3ad05@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <6c2d3e6b-23f8-d4a4-4701-ff9288c18a5c@linux.microsoft.com>
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
        <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com>
        <d5e58052-86df-7ffa-02a0-fc4db5a7bbdf@linux.microsoft.com>
        <CAHsH6GsxaSgGkF9gkBKCcO9feSrsXsuNBdKRM_R8=Suih9oxSw@mail.gmail.com>
        <20220301150930.GA56710@Mem>
        <dcc83e93-4a28-896c-b3d3-8d675bb705eb@linux.microsoft.com>
        <20220301161001.GV1223722@gauss3.secunet.de>
        <20220302080439.2324c5d0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <6c2d3e6b-23f8-d4a4-4701-ff9288c18a5c@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Mar 2022 19:11:06 +0100 Kai Lueke wrote:
> > Agreed. FWIW would be great if patch #2 started flowing towards Linus'es
> > tree separately if the discussion on #1 is taking longer.  
> 
> to preserve the initial goal of helping to uncover id 0 usage I think it
> would be best to have the revert be accompanied by a patch that instead
> creates a kernel log warning (or whatever).

extack would be best, but that would mean a little bit of plumbing 
so more likely net-next material. Which would have to come after.

> Since I never did that I suggest to not wait for me.
> Also, feel free to do the revert yourself with a different commit
> message if mine didn't capture the things appropriately.

TBH I'm not 100% clear on the nature of the regression. Does Cilium
update the configuration later to make if_id be non-zero? Or the broken 
interface is not used but not being able to create it fails the whole
configuration?
