Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F145231A1
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 13:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbiEKLaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 07:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiEKLaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 07:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4760C21E20;
        Wed, 11 May 2022 04:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D16A61882;
        Wed, 11 May 2022 11:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D07D3C340F3;
        Wed, 11 May 2022 11:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652268613;
        bh=39CRATfpjuCjHAa2PbIoSrt715Y4+38r0j0d01uPD4k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P4qznh5VKtagjojaCavJmje0gInPrmoKyCAw2G4C9OY2VH2L4ye9Qz+cy9AXCujVX
         bBu+PLaZffF7m++Rcpae7gFIpzEaZWDEk0TmJSh8jvj3PqdWS+QFY/3okVoj+0AyDB
         YEsqHUfzIlbF6fXOphQRbf/vAtHLCOrEAD9Z6R3sebDDGCVAztR5phEX92WljwWggD
         Et6WfXETdtbnjwdgUrBFnwXfcVMl81d8iPB22EODs17Gs6OsCtvvD+EhnIc0aBJm6D
         K7LMd1NTYz8aJKhFIjLs18FiSjZZsw/wi1ABijl3mPRumhRNwypbwC7XQO9YYp2PuF
         ITBGhCSRNTzDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A679DF03931;
        Wed, 11 May 2022 11:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4 V2] net: atlantic: more fuzzing fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165226861367.11801.13863078014011642254.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 11:30:13 +0000
References: <20220510022826.2388423-1-grundler@chromium.org>
In-Reply-To: <20220510022826.2388423-1-grundler@chromium.org>
To:     Grant Grundler <grundler@chromium.org>
Cc:     irusskikh@marvell.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, aashay@google.com, yich@google.com,
        enlightened@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Mon,  9 May 2022 19:28:22 -0700 you wrote:
> The Chrome OS fuzzing team posted a "Fuzzing" report for atlantic driver
> in Q4 2021 using Chrome OS v5.4 kernel and "Cable Matters
> Thunderbolt 3 to 10 Gb Ethernet" (b0 version):
>     https://docs.google.com/document/d/e/2PACX-1vT4oCGNhhy_AuUqpu6NGnW0N9HF_jxf2kS7raOpOlNRqJNiTHAtjiHRthXYSeXIRTgfeVvsEt0qK9qK/pub
> 
> It essentially describes four problems:
> 1) validate rxd_wb->next_desc_ptr before populating buff->next
> 2) "frag[0] not initialized" case in aq_ring_rx_clean()
> 3) limit iterations handling fragments in aq_ring_rx_clean()
> 4) validate hw_head_ in hw_atl_b0_hw_ring_tx_head_update()
> 
> [...]

Here is the summary with links:
  - [1/4] net: atlantic: fix "frag[0] not initialized"
    https://git.kernel.org/netdev/net/c/62e0ae0f4020
  - [2/4] net: atlantic: reduce scope of is_rsc_complete
    https://git.kernel.org/netdev/net/c/79784d77ebbd
  - [3/4] net: atlantic: add check for MAX_SKB_FRAGS
    https://git.kernel.org/netdev/net/c/6aecbba12b5c
  - [4/4] net: atlantic: verify hw_head_ lies within TX buffer ring
    https://git.kernel.org/netdev/net/c/2120b7f4d128

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


