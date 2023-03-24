Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8506C87B6
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 22:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjCXVuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 17:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjCXVud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 17:50:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2C5EFB2
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 14:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BFB7B82607
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 21:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34625C433EF;
        Fri, 24 Mar 2023 21:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679694619;
        bh=pDBUaM+X6j6xSLdJIvEsf0XhxTzQ104pK52HcG2/qzk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mvOVcPzUhLfzDTX4uJP+ALlC8Kx5u1ep1YdRgnn28OWV+YXajHObUemB6jD0kWQ8Q
         4j2OnBOR1a24DPKELZXqymS1Fbz+qcoOzNuaGbkxSyTBiOQwUbsEE7cKBMNtnp7yFQ
         rAURJaTUSpzP2pbaB4SZnFN6nXGgoCDccO0yL2G5Q4nGHYDKUZMk7mQwe1ZETpf6sf
         CtA6ALJuPq9Af/+MxsiHyNNxXRI/kt9khqspfpCyTq/UvuF0VLRAsfnMeA4jP3sdgB
         UXEX6cHoPT1xFADf8ADMnFDlOwlgDqB6fcOmjJzwyaxYoNue9y2qp/ESuuvJ52MEs/
         va039KeRfHgKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0CC0BE52505;
        Fri, 24 Mar 2023 21:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] sfc: ef10: don't overwrite offload features at NIC
 reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167969461904.5464.1615964344930483116.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 21:50:19 +0000
References: <20230323083417.7345-1-ihuguet@redhat.com>
In-Reply-To: <20230323083417.7345-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, tizhao@redhat.com,
        jonathan.s.cooper@amd.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Mar 2023 09:34:17 +0100 you wrote:
> At NIC reset, some offload features related to encapsulated traffic
> might have changed (this mainly happens if the firmware-variant is
> changed with the sfboot userspace tool). Because of this, features are
> checked and set again at reset time.
> 
> However, this was not done right, and some features were improperly
> overwritten at NIC reset:
> - Tunneled IPv6 segmentation was always disabled
> - Features disabled with ethtool were reenabled
> - Features that becomes unsupported after the reset were not disabled
> 
> [...]

Here is the summary with links:
  - [v2,net] sfc: ef10: don't overwrite offload features at NIC reset
    https://git.kernel.org/netdev/net/c/ca4a80e4bb7e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


