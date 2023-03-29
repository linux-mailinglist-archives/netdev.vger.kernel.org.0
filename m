Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5E86CD26D
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjC2HAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjC2HAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:00:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F94326AD
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 00:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB74BB820AD
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D97EC4339B;
        Wed, 29 Mar 2023 07:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680073226;
        bh=ZwnVLwBtlSSHihMMXuRdwpmXa1RHkMOhEoF8k3nsd9U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gH69LXPYoL792meRJCBTJC0KvUjjGF3ef2ZeTEz7W0+hm2E2FYfmBdYKMdnKcPhFQ
         rQw8CJI3vzmj7j+FXdlrTATwsEbMYreLVJAqsKr4JhGVLwwRx3moeK3odUgu2HsaZA
         ysvCjAFz1AsA3Y6gKbtZnEfykilT48CbDU8/uL97F+dcDRujwzUqZwOqJBKbRaOFrh
         FS++ZhJU7Z6hgKyUomhWbHg7y1ta0m/Fv8GIvfH9f7+kqiSPPxjAro2FPUVxeFrkUt
         /zHSj1OBm4MiRoLHGSrWl2u+kklSnFPwetuS/kOk9gKuum0hJZYt7wuuoyNnHVRR1S
         0mE85NoDWnRtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D0CEC41612;
        Wed, 29 Mar 2023 07:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V2 01/15] lib: cpu_rmap: Avoid use after free on rmap->obj
 array entries
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007322637.11543.1690845820853149153.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 07:00:26 +0000
References: <20230324231341.29808-2-saeed@kernel.org>
In-Reply-To: <20230324231341.29808-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, tglx@linutronix.de, elic@nvidia.com,
        jacob.e.keller@intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Fri, 24 Mar 2023 16:13:27 -0700 you wrote:
> From: Eli Cohen <elic@nvidia.com>
> 
> When calling irq_set_affinity_notifier() with NULL at the notify
> argument, it will cause freeing of the glue pointer in the
> corresponding array entry but will leave the pointer in the array. A
> subsequent call to free_irq_cpu_rmap() will try to free this entry again
> leading to possible use after free.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/15] lib: cpu_rmap: Avoid use after free on rmap->obj array entries
    https://git.kernel.org/netdev/net-next/c/4e0473f1060a
  - [net-next,V2,02/15] lib: cpu_rmap: Use allocator for rmap entries
    https://git.kernel.org/netdev/net-next/c/9821d8d4628e
  - [net-next,V2,03/15] lib: cpu_rmap: Add irq_cpu_rmap_remove to complement irq_cpu_rmap_add
    https://git.kernel.org/netdev/net-next/c/71f0a2478605
  - [net-next,V2,04/15] net/mlx5e: Coding style fix, add empty line
    https://git.kernel.org/netdev/net-next/c/b94616d9c6fd
  - [net-next,V2,05/15] net/mlx5: Fix wrong comment
    https://git.kernel.org/netdev/net-next/c/40a252c123c7
  - [net-next,V2,06/15] net/mlx5: Modify struct mlx5_irq to use struct msi_map
    https://git.kernel.org/netdev/net-next/c/235a25fe28de
  - [net-next,V2,07/15] net/mlx5: Use newer affinity descriptor
    https://git.kernel.org/netdev/net-next/c/bbac70c74183
  - [net-next,V2,08/15] net/mlx5: Improve naming of pci function vectors
    https://git.kernel.org/netdev/net-next/c/8bebfd767909
  - [net-next,V2,09/15] net/mlx5: Refactor completion irq request/release code
    https://git.kernel.org/netdev/net-next/c/b48a0f72bc3e
  - [net-next,V2,10/15] net/mlx5: Use dynamic msix vectors allocation
    https://git.kernel.org/netdev/net-next/c/3354822cde5a
  - [net-next,V2,11/15] net/mlx5: Move devlink registration before mlx5_load
    https://git.kernel.org/netdev/net-next/c/fe578cbb2f05
  - [net-next,V2,12/15] net/mlx5: Refactor calculation of required completion vectors
    https://git.kernel.org/netdev/net-next/c/1dc85133c207
  - [net-next,V2,13/15] net/mlx5: Use one completion vector if eth is disabled
    https://git.kernel.org/netdev/net-next/c/b637ac5db0d0
  - [net-next,V2,14/15] net/mlx5: Provide external API for allocating vectors
    https://git.kernel.org/netdev/net-next/c/fb0a6a268dcd
  - [net-next,V2,15/15] vdpa/mlx5: Support interrupt bypassing
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


