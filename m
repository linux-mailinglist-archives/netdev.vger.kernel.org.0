Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68264660C3A
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 04:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbjAGDkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 22:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjAGDkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 22:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5688392DF;
        Fri,  6 Jan 2023 19:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56BF061FD6;
        Sat,  7 Jan 2023 03:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B05B3C433A7;
        Sat,  7 Jan 2023 03:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673062816;
        bh=oL+dRXExPO7YXiNQX2vljFYDBKWQGLkRctQfgGREsTs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ufVbgk1rgjOszByvAKqE5I1miYqtT2kVDBgvsSMKjpOYLc324MdrEIe+IAvqgM4gY
         lRYh2Qu+IYEWtFdL7o9WodFgd9TfozoLx+FQ8BNdzGwKkU57WGurjlw1/PAYs01vuR
         pSqVje/8bh9pK4mbFgqgJY1aBRgqfhd7amvMxhNqIpxOZjjpis6T/IqdCLvekYLw4k
         iCwXkqRlHxqSTvrs4rMD26N8FgRVcLTNF/7Y+9Kubh1kATYdROpEqMJpQooK6KWtKv
         Vl5z4CdYzTY7q1abTqX8PkjZTurMeEGw9quAveWsX9bOgb5SImrhjJAnDFISSIwVip
         Ptev+jfoWyosQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97684E270F0;
        Sat,  7 Jan 2023 03:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] ethtool: Replace 0-length array with flexible array
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167306281661.4583.3241877198480570363.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Jan 2023 03:40:16 +0000
References: <20230106042844.give.885-kees@kernel.org>
In-Reply-To: <20230106042844.give.885-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        lkp@intel.com, linux@rempel-privat.de, sean.anderson@seco.com,
        alexandru.tachici@analog.com, amcohen@nvidia.com,
        gustavoars@kernel.org, mailhol.vincent@wanadoo.fr,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  5 Jan 2023 20:28:48 -0800 you wrote:
> Zero-length arrays are deprecated[1]. Replace struct ethtool_rxnfc's
> "rule_locs" 0-length array with a flexible array. Detected with GCC 13,
> using -fstrict-flex-arrays=3:
> 
> net/ethtool/common.c: In function 'ethtool_get_max_rxnfc_channel':
> net/ethtool/common.c:558:55: warning: array subscript i is outside array bounds of '__u32[0]' {aka 'unsigned int[]'} [-Warray-bounds=]
>   558 |                         .fs.location = info->rule_locs[i],
>       |                                        ~~~~~~~~~~~~~~~^~~
> In file included from include/linux/ethtool.h:19,
>                  from include/uapi/linux/ethtool_netlink.h:12,
>                  from include/linux/ethtool_netlink.h:6,
>                  from net/ethtool/common.c:3:
> include/uapi/linux/ethtool.h:1186:41: note: while referencing
> 'rule_locs'
>  1186 |         __u32                           rule_locs[0];
>       |                                         ^~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [v3] ethtool: Replace 0-length array with flexible array
    https://git.kernel.org/netdev/net-next/c/b466a25c930f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


