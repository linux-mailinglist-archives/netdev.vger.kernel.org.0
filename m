Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79F7697589
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbjBOEu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbjBOEuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E602D15A
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 20:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8980B82004
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 04:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99A84C4339B;
        Wed, 15 Feb 2023 04:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676436617;
        bh=sFBL7CL4EX0ZFfMl/e/HBhCKy9J/hAiZTaR7c5RYl5I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U6nCJZmI7T+QmY8+Ubo2icv3bMdB7439i3CPUh7pGC4KTLSvJ5kl1x6YXU6o2i09P
         0jUqJsdRHIxod6zolXiPIJOvudDDwihHjxck0BIWYyu4gMHtlE8YoZVj6q22+7PgxG
         PFxt5VXuDa6FkDaS62MEFWZdbjC9TEGtxphUXcL3jOmBNlfsrb2svCXl9+4sC6Fs2h
         28DEEVQqDXd2hCFDKymmG1/qZwGeckJrUUdPH7f6MUyObEEIAW8Y0OIMePDSgI3Q3/
         5IjGY37ux+G4A7ivdibSHJJieahMMwnZzo8oNl918PNU+bOz9TFoMpL4s14gtOdx0O
         xh8yg5SJ37a7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F6FEC4166F;
        Wed, 15 Feb 2023 04:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] igb: Fix PPS input and output using 3rd and 4th SDP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167643661751.17897.4509193517151082037.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 04:50:17 +0000
References: <20230213185822.3960072-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230213185822.3960072-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlichvar@redhat.com, netdev@vger.kernel.org,
        kernel.hbk@gmail.com, richardcochran@gmail.com,
        ntp-lists@mattcorallo.com, jacob.e.keller@intel.com,
        gurucharanx.g@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Feb 2023 10:58:22 -0800 you wrote:
> From: Miroslav Lichvar <mlichvar@redhat.com>
> 
> Fix handling of the tsync interrupt to compare the pin number with
> IGB_N_SDP instead of IGB_N_EXTTS/IGB_N_PEROUT and fix the indexing to
> the perout array.
> 
> Fixes: cf99c1dd7b77 ("igb: move PEROUT and EXTTS isr logic to separate functions")
> Reported-by: Matt Corallo <ntp-lists@mattcorallo.com>
> Cc: Jacob Keller <jacob.e.keller@intel.com>
> Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> [...]

Here is the summary with links:
  - [net,1/1] igb: Fix PPS input and output using 3rd and 4th SDP
    https://git.kernel.org/netdev/net/c/207ce626add8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


