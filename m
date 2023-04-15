Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38A46E2DF2
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 02:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjDOAeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 20:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDOAet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 20:34:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFFC49D7;
        Fri, 14 Apr 2023 17:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B25E60F7D;
        Sat, 15 Apr 2023 00:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAFCC433D2;
        Sat, 15 Apr 2023 00:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681518886;
        bh=9q2Q/ZaB7kLbBAAHs/qU7dpW1suEZttgmZ+TFGZ8GN4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HBIOAJhTR8iBTALYujzIbWSOiy3dLYQ+ke6XS81sN50q5heei8FVTFi+UXEwBzUXY
         Rp/08pF7xd91S8YB1xI6f7hdj+mH5QkiCZMtvf3AogMMgFeubiXp20Rz9q2O8qQ2Yd
         YPPjaQUPQBbNSOUlaHyOYkpssgPHSJjEjWnyMIgoHYYbd2A4w5jku73ggjAumNzmqr
         Ndev6YgaPTl+roUe0n6j19oWo2ETrkBvsR9mYbuFsCEeri2VQD4MWriqEiJNZxhYMR
         1Ul/AdqbMmHoCwXq2zGz3xbjMz9l9MzQJbogv8J/xUcV4HHE2DzSyPtx6oaERMn9Oi
         0aa6wlak2WEdw==
Date:   Fri, 14 Apr 2023 17:34:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <20230414173445.0800b7cf@kernel.org>
In-Reply-To: <ZDnRkVNYlHk4QVqy@x130>
References: <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
        <20230410054605.GL182481@unreal>
        <20230413075421.044d7046@kernel.org>
        <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
        <ZDhwUYpMFvCRf1EC@x130>
        <20230413152150.4b54d6f4@kernel.org>
        <ZDiDbQL5ksMwaMeB@x130>
        <20230413155139.22d3b2f4@kernel.org>
        <ZDjCdpWcchQGNBs1@x130>
        <20230413202631.7e3bd713@kernel.org>
        <ZDnRkVNYlHk4QVqy@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 15:20:01 -0700 Saeed Mahameed wrote:
> >> Officially we test only 3 GA FWs back. The fact that mlx5 is a generic CX
> >> driver makes it really hard to test all the possible combinations, so we
> >> need to be strict with how back we want to officially support and test old
> >> generations.  
> >
> >Would you be able to pull the datapoints for what 3 GA FWs means
> >in case of CX4? Release number and date when it was released?
>
> https://network.nvidia.com/files/related-docs/eol/LCR-000821.pdf
> 
> Since CX4 was EOL last year, it is going to be hard to find this info but
> let me check my email archive.. 
> 
> 12.28.2006   27-Sep-20 - recommended version
> 12.26.xxxx   12-Dec-2019
> 12.24.1000   2-Dec-18

That's basically 3 years of support. Seems fairly reasonable.
 
> >> Upgrade FW when possible, it is always easier than upgrading the kernel.
> >> Anyways this was a very rare FW/Arch bug, We should've exposed an
> >> explicit cap for this new type of PF when we had the chance, now it's too
> >> late since a proper fix will require FW and Driver upgrades and breaking
> >> the current solution we have over other OSes as well.
> >>
> >> Yes I can craft an if condition to explicitly check for chip id and FW
> >> version for this corner case, which has no precedence in mlx5, but I prefer
> >> to ask to upgrade FW first, and if that's an acceptable solution, I would
> >> like to keep the mlx5 clean and device agnostic as much as possible.  
> >
> >IMO you either need a fully fleshed out FW update story, with advanced
> >warnings for a few releases, distributing the FW via linux-firmware or
> >fwupdmgr or such.  Or deal with the corner cases in the driver :(
> 
> Completely agree, I will start an internal discussion .. 
> 
> >We can get Paul to update, sure, but if he noticed so quickly the
> >question remains how many people out in the wild will get affected
> >and not know what the cause is?  
> 
> Right, I will make sure this will be addressed, will let you know how we
> will handle this, will try to post a patch early next cycle, but i will
> need to work with Arch and release managers for this, so it will take a
> couple of weeks to formalize a proper solution.

What do we do now, tho? If the main side effect of a revert is that
users of a newfangled device with an order of magnitude lower
deployment continue to see a warning/error in the logs - I'm leaning
towards applying it :(
