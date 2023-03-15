Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0E66BA965
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjCOHdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjCOHcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E3B5C9EF;
        Wed, 15 Mar 2023 00:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB4E061B4E;
        Wed, 15 Mar 2023 07:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BCFEC433EF;
        Wed, 15 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678865419;
        bh=7trHryZE8Pr0Aw/RTfmMPU+CiDo8HOU3nnti7DI27DU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xkz3DBJCvl6ECf6fZquYzrkvxUkeBtM7rfTwOYDWhJYV9RN6c9EyUxbKb9vx9Afam
         OtHmb4SzICi2dH/RyqB/Da/mA1kojaDs5o7FHR9ZRCb5kUG2uD0WeWhsZXKcyBukYi
         J6Ylqb/JJ4aVGFa/ruVTba/dhSqElempBW6q+0whOZyaMlcvupNLzlKz2+hlUIK/kh
         SVU87nxUsBXYDmGmik9tfg+5jV8Vfr75U4o3RBxlZUiehDMWGNTm33+fDIRYHmJeCA
         3sJCiBnNp4H1Mow0t+wMwk+Ngepj0muTkJ681SblrET8rCFnDgzgkT3f1qVdPn6wKA
         vVYRJQ6yG22mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E45DAE52532;
        Wed, 15 Mar 2023 07:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: st-nci: Fix use after free bug in ndlc_remove due to
 race condition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886541893.32297.9466042495115598646.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 07:30:18 +0000
References: <20230312160837.2040857-1-zyytlz.wz@163.com>
In-Reply-To: <20230312160837.2040857-1-zyytlz.wz@163.com>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Mar 2023 00:08:37 +0800 you wrote:
> This bug influences both st_nci_i2c_remove and st_nci_spi_remove.
> Take st_nci_i2c_remove as an example.
> 
> In st_nci_i2c_probe, it called ndlc_probe and bound &ndlc->sm_work
> with llt_ndlc_sm_work.
> 
> When it calls ndlc_recv or timeout handler, it will finally call
> schedule_work to start the work.
> 
> [...]

Here is the summary with links:
  - nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition
    https://git.kernel.org/netdev/net/c/5000fe6c2782

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


