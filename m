Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54D453695F
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 02:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355251AbiE1AYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 20:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245666AbiE1AYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 20:24:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E821A12816C;
        Fri, 27 May 2022 17:24:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 837D561B10;
        Sat, 28 May 2022 00:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7100BC385A9;
        Sat, 28 May 2022 00:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653697470;
        bh=qIeo6JA4DyQSPaWCe6rVK+y6LvJBmRfB69g0OJlcccQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CgNMxMfx7+wKROjD/tbPomCNoavKeo+cNapEs/zriCIX0Veinl3wj89kEd/SNdfih
         SKF9BoBugxnhbD3cudZgm/w4NZ77YffZJJKatGYDkMINzIo1rz6nPAY1KfTtxjvI9a
         SYeSS7KJcy14oAJgwV5Su+i44tQ892k9pDTmAKUgyLUSLv8NpPM3rmxiH7hpsfDx3z
         GI10eWJl/a3Y5fKkhP/F9PieaTPE8cXKDPlMDWbA+c4Hek20s4+p60/u1hWSEk90P2
         sIPuq43d8x9FMZwsFXuHoBzXB7yfVyDk/2IOWK7crM2Em5/2z+UvKBVWiAPLaVuP7s
         Tckgo3bTbS/TA==
Date:   Fri, 27 May 2022 17:24:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: mainline build failure due to c1918196427b ("iwlwifi: pcie:
 simplify MSI-X cause mapping")
Message-ID: <20220527172429.6cd3110e@kernel.org>
In-Reply-To: <604ee91b52c79c575bb0ac0849f504be354bf404.camel@sipsolutions.net>
References: <YpCWIlVFd7JDPfT+@debian>
        <875ylrqqko.fsf@kernel.org>
        <604ee91b52c79c575bb0ac0849f504be354bf404.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 May 2022 11:23:10 +0200 Johannes Berg wrote:
> On Fri, 2022-05-27 at 12:20 +0300, Kalle Valo wrote:
> > 
> > iwlwifi: pcie: rename CAUSE macro
> > 
> > https://patchwork.kernel.org/project/linux-wireless/patch/20220523220300.682be2029361.I283200b18da589a975a284073dca8ed001ee107a@changeid/
> > 
> > It's marked as accepted but I don't know where it's applied to, Gregory?  
> 
> Gregory picked it up to our internal tree.
> 
> > This is failing the build, should Linus apply the fix directly to his
> > tree?  
> 
> I had previous asked Jakub if he wanted to do that, but he didn't (yet).
> I don't know what's the best course of action right now...
> 
> No objections to it taking any kind of fast path though :)

IIRC this is a warning and it's on MIPS only [1], so if it can make its
way to your Wed PR and I'll send it to Linus on Thu - that should be
good enough (I think).

[1] https://lore.kernel.org/all/20220523125906.20d60f1d@kernel.org/
