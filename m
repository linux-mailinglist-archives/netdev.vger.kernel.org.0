Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B0969A5F0
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 08:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjBQHKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 02:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBQHKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 02:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2065693DF;
        Thu, 16 Feb 2023 23:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4D0860FF6;
        Fri, 17 Feb 2023 07:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED5CEC4339B;
        Fri, 17 Feb 2023 07:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676617818;
        bh=xfHV3NQ6+NmEOss+O6Bzr/Ev3Mp2vZ3FA5bht/acSIM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E86kQ82Q7XEyD5lmdZvXZwsdABRdnG2rchpP2Swn4WIi+BwXkmLnkUvEs3dp9M97k
         21x/nRkPtonV9yJdD4PZYRsT9RA32edITm1UmUM/XXjgJXrbM4dk49ocU+iR+nmQMt
         3NMIjACOB1XP+v0FB7YBeDzgmJrLfYuLaYz+rQ9KvbJsb9NAMou9ieXO8ww/Lx8HMg
         WF6DaaL19tz/pvL9yMbEqf+nfx49BKfM3D3RuhoaggY2qRgimTqPN4Uh18Ju2aiiW9
         bF0EtwG1W2INUQtKDfaKY/vywqBH7v+d7fiGzvG/8inb5ITPT5zSMDUHq5F1clk0LD
         sz3/7qQZYVC8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D48D6C1614B;
        Fri, 17 Feb 2023 07:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: check IFF_UP earlier in Tx path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167661781786.4204.9196824978376893308.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Feb 2023 07:10:17 +0000
References: <20230215143309.13145-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20230215143309.13145-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        michal.kubiak@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Wed, 15 Feb 2023 15:33:09 +0100 you wrote:
> Xsk Tx can be triggered via either sendmsg() or poll() syscalls. These
> two paths share a call to common function xsk_xmit() which has two
> sanity checks within. A pseudo code example to show the two paths:
> 
> __xsk_sendmsg() :                       xsk_poll():
> if (unlikely(!xsk_is_bound(xs)))        if (unlikely(!xsk_is_bound(xs)))
>     return -ENXIO;                          return mask;
> if (unlikely(need_wait))                (...)
>     return -EOPNOTSUPP;                 xsk_xmit()
> mark napi id
> (...)
> xsk_xmit()
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: check IFF_UP earlier in Tx path
    https://git.kernel.org/bpf/bpf/c/92a3f9895236

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


