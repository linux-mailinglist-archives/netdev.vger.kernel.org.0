Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458254E57CF
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343771AbiCWRvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343785AbiCWRvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C438567B;
        Wed, 23 Mar 2022 10:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 013C060F9A;
        Wed, 23 Mar 2022 17:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FC94C340EE;
        Wed, 23 Mar 2022 17:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648057811;
        bh=wccJqlHevyHVXhiPkHCrfCyeoEnsOdlBJdiCyaDDc0s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fn4s/Yz6FizxgPiLoqfnNjptnzQba9rGFaYzGRLS9na3Auf1K/X2Dfrp2R9IV8FDU
         iF/qWeOhzLCvkZRvrzsYQPEJ+e9C8Joy1EH+mieObvzCXJrFrKg4LarcbU1xS0am4z
         LVOUZB0aL/+/ivMOB7d4U2AeFhpJytOeu3x59w7S/6G6MClS87h3LMfJ9rTGpk9SPl
         rvJOOm3I47AokfvlmIMqCRnBqPEikvEdAVwLy3Id++RcmNyp3BFJ9gsjFQ8d/5RtFO
         2y8dEO/sKGdFKcVFcCHipu1xJpSktNkvB6PUJlLkczS3Vmi56/USLrfzM/B5ZP0YdG
         AF8VmEObkDYMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E817EAC081;
        Wed, 23 Mar 2022 17:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] ice: avoid sleeping/scheduling in atomic contexts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164805781118.23946.739203139839506306.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Mar 2022 17:50:11 +0000
References: <20220323124353.2762181-1-alexandr.lobakin@intel.com>
In-Reply-To: <20220323124353.2762181-1-alexandr.lobakin@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        maciej.fijalkowski@intel.com, michal.kubiak@intel.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        shiraz.saleem@intel.com, david.m.ertman@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Mar 2022 13:43:51 +0100 you wrote:
> The `ice_misc_intr() + ice_send_event_to_aux()` infamous pair failed
> once again.
> Fix yet another (hopefully last one) 'scheduling while atomic' splat
> and finally plug the hole to gracefully return prematurely when
> invoked in wrong context instead of panicking.
> 
> Alexander Lobakin (2):
>   ice: fix 'scheduling while atomic' on aux critical err interrupt
>   ice: don't allow to run ice_send_event_to_aux() in atomic ctx
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: fix 'scheduling while atomic' on aux critical err interrupt
    https://git.kernel.org/netdev/net/c/32d53c0aa3a7
  - [net,2/2] ice: don't allow to run ice_send_event_to_aux() in atomic ctx
    https://git.kernel.org/netdev/net/c/5a3156932da0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


