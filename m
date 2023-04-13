Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306A66E15D8
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 22:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjDMUaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 16:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjDMUaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 16:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABDD2735;
        Thu, 13 Apr 2023 13:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 658CC64198;
        Thu, 13 Apr 2023 20:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 881F2C4339B;
        Thu, 13 Apr 2023 20:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681417820;
        bh=a5x9QYPzlYjC4i+/VEC2vZQfe2RMRXQEQDfiHLDCWFo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=auIO1C7gXvnGtH4b2N2YW5M1F0eUvtXzAfCN1Y+9u9xE+lUEgq8i/YpbL/mnA4gH+
         Gpt+I1vw/I9M8wM6q/j4bN1df6DtzmdBGIG7/NwEQW0KSNGkqDKmNDoBeKqstYCsZo
         5P49dLS01tW3goqHt0FmJMF3V0WznPmy1zfreHprkiY9y1WhcvBY8Xeswfs6UJPw6E
         v3tz4gv1vsZkPb4nawItMoeI5MKM4rSJtruasojm3LB9A6vlSCbfkwO6eqVoHs9L3p
         zmqh+wiDybyjmAPZQb6upro8/Ytg4SK0tDVGuI8V6QdlSBqS1z1OB0rcNJ4r/JOTLZ
         nBsx6VK/X5w3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 623F1C395C5;
        Thu, 13 Apr 2023 20:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf V10 0/6] XDP-hints: API change for RX-hash kfunc
 bpf_xdp_metadata_rx_hash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168141782039.3934.14068721419146167788.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 20:30:20 +0000
References: <168132888942.340624.2449617439220153267.stgit@firesoul>
In-Reply-To: <168132888942.340624.2449617439220153267.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, sdf@google.com, toke@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        linux-rdma@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Alexei Starovoitov <ast@kernel.org>:

On Wed, 12 Apr 2023 21:48:30 +0200 you wrote:
> Current API for bpf_xdp_metadata_rx_hash() returns the raw RSS hash value,
> but doesn't provide information on the RSS hash type (part of 6.3-rc).
> 
> This patchset proposal is to change the function call signature via adding
> a pointer value argument for providing the RSS hash type.
> 
> Patchset also removes all bpf_printk's from xdp_hw_metadata program
> that we expect driver developers to use. Instead counters are introduced
> for relaying e.g. skip and fail info.
> 
> [...]

Here is the summary with links:
  - [bpf,V10,1/6] selftests/bpf: xdp_hw_metadata remove bpf_printk and add counters
    https://git.kernel.org/netdev/net/c/e8163b98d96c
  - [bpf,V10,2/6] xdp: rss hash types representation
    https://git.kernel.org/netdev/net/c/0cd917a4a8ac
  - [bpf,V10,3/6] mlx5: bpf_xdp_metadata_rx_hash add xdp rss hash type
    https://git.kernel.org/netdev/net/c/67f245c2ec0a
  - [bpf,V10,4/6] veth: bpf_xdp_metadata_rx_hash add xdp rss hash type
    https://git.kernel.org/netdev/net/c/96b1a098f3db
  - [bpf,V10,5/6] mlx4: bpf_xdp_metadata_rx_hash add xdp rss hash type
    https://git.kernel.org/netdev/net/c/9123397aeeb4
  - [bpf,V10,6/6] selftests/bpf: Adjust bpf_xdp_metadata_rx_hash for new arg
    https://git.kernel.org/netdev/net/c/0f26b74e7d07

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


