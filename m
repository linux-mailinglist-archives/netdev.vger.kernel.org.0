Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F556206C7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbiKHCaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbiKHCaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0170612D00
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 18:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6E69B8188C
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CE7CC433D7;
        Tue,  8 Nov 2022 02:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667874615;
        bh=YhyaVuKLWbMBXylKW1AndbE1/BAplt+Pdft1NtAmfqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ux5IKPYOwwyAIh+/rSDjg9uqXRxJAkEqII2It+VefjGT4iNg3Y+bWcdDJRgGpk+lK
         k9xtrDvzKvwZWcwYrQHhhehYcEYVHbc92YlMAj7J2QLHJD2gAI2N44OqTgsObFF8Ot
         odvl2JbeiRoaI+iKflF7NvhKVQnDFH9hjLCtIGtUJ2JM8YY6E3bG5xhtZazxZ44sbi
         7OmIiev9Gg+JR+yHgZJK8YfAj/4iGqYFP2kXdxkVjCd/sIaHsYBflS8XZiC6SPcccD
         bpMKYRsFQyQZc5gWl74z2fZCH7/HjlUw/SXZOUPipzGpYTmo2xmo4mxTEKrH9Uz5yb
         pNbKPPjFqxDVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 45DCAC73FFC;
        Tue,  8 Nov 2022 02:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-pf: fix build error when CONFIG_OCTEONTX2_PF=y
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166787461528.16737.5307318593915636319.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 02:30:15 +0000
References: <20221105063442.2013981-1-yangyingliang@huawei.com>
In-Reply-To: <20221105063442.2013981-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, sbhatta@marvell.com, sgoutham@marvell.com,
        davem@davemloft.net
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

On Sat, 5 Nov 2022 14:34:42 +0800 you wrote:
> If CONFIG_MACSEC=m and CONFIG_OCTEONTX2_PF=y, it leads a build error:
> 
>   ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.o: in function `otx2_pfaf_mbox_up_handler':
>   otx2_pf.c:(.text+0x181c): undefined reference to `cn10k_handle_mcs_event'
>   ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.o: in function `otx2_probe':
>   otx2_pf.c:(.text+0x437e): undefined reference to `cn10k_mcs_init'
>   ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.o: in function `otx2_remove':
>   otx2_pf.c:(.text+0x5031): undefined reference to `cn10k_mcs_free'
>   ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.o: in function `otx2_mbox_up_handler_mcs_intr_notify':
>   otx2_pf.c:(.text+0x5f11): undefined reference to `cn10k_handle_mcs_event'
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-pf: fix build error when CONFIG_OCTEONTX2_PF=y
    https://git.kernel.org/netdev/net/c/02f5999e6529

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


