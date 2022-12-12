Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17DEC64AB92
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiLLXaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiLLXaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91DC1ADAA;
        Mon, 12 Dec 2022 15:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 731E061284;
        Mon, 12 Dec 2022 23:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAE5BC433F0;
        Mon, 12 Dec 2022 23:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670887816;
        bh=DOltPtqE6qZNxC7DT1yeyYjKFNQqpzwbh75mtJgfWl0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k90bh442Fg4ZZqTiz/ZAanERwMTNvC4Ve6MybPm9ALJFFqInO5YqZPByyFW31ub0v
         oGTtpLBFA3ehHpUVHuswfr0TeAdiuWnQWzFh4GuT0jRTmU5BjCWjreFgWpFbioAjJJ
         B+L2QBmTvV79pgQhicgCUf1Ezl6gBTyjGXEJ+FSwyLJx4wcn7CLxct/MnJJBHwLEyV
         E0dY4LS8IKZsigF3olJK2RMPcFg0f7C6z+PX9P7t/oX+4/1KGT2v8EVvJjG+PdGF/N
         /3Wx2KI5BZ10WgDakYLxlKQ14podQN7TLYKTsjC75OoK1Msr3SOhBvRHMbiMXTP4yv
         nVcf4hAFOW14g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F0B9C41606;
        Mon, 12 Dec 2022 23:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 1/1] i40e: Fix the inability to attach XDP program on
 downed interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088781664.32014.2462162392412968800.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:30:16 +0000
References: <20221209185411.2519898-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221209185411.2519898-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, bartoszx.staszewski@intel.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bpf@vger.kernel.org, saeed@kernel.org,
        mateusz.palczewski@intel.com, Shwetha.nagaraju@intel.com
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

On Fri,  9 Dec 2022 10:54:11 -0800 you wrote:
> From: Bartosz Staszewski <bartoszx.staszewski@intel.com>
> 
> Whenever trying to load XDP prog on downed interface, function i40e_xdp
> was passing vsi->rx_buf_len field to i40e_xdp_setup() which was equal 0.
> i40e_open() calls i40e_vsi_configure_rx() which configures that field,
> but that only happens when interface is up. When it is down, i40e_open()
> is not being called, thus vsi->rx_buf_len is not set.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/1] i40e: Fix the inability to attach XDP program on downed interface
    https://git.kernel.org/netdev/net/c/0c87b545a2ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


