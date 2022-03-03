Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212364CC05B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbiCCOvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiCCOvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:51:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE3718F230;
        Thu,  3 Mar 2022 06:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6A89B82601;
        Thu,  3 Mar 2022 14:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83634C340F0;
        Thu,  3 Mar 2022 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646319014;
        bh=OCUroMO+Hn4MAGjXlYAT3Z59GOg1NzgoFBzVVB2JnII=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CTua5J5BZFspbB5Snu2Tx3498/QYlHZzk2UWBhPxNU/xCeYjB7w5pGpdo4UpKAP3E
         KLDq9e60/1YC93xKJ2seZSdWSaBj4Il9vnzO5RsJi8GXpDCf7agbZMoauTuoPAqodX
         z72qv6EkiEB2TpW75rstfZ/wTyRoXQs5JHXDXkLFSY9KvPZNTY3ub3SV6wIaRZnta1
         0rQUAcsk/litD1gCGzMbl2fbL9I/4ViZnhFfLyCb832eHuBhz+At+wFUCs+sZwaXsm
         23JOnMWMcH3Eqe2O05dOehxpmeRV52lxU9n/8bMG7HmvQkPna/vbH4DwA4oHJlsNNn
         sXgUwx9bOdpTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69A93EAC096;
        Thu,  3 Mar 2022 14:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 net-next 0/13] Preserve mono delivery time (EDT) in
 skb->tstamp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164631901442.29171.11893100741370106265.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 14:50:14 +0000
References: <20220302195519.3479274-1-kafai@fb.com>
In-Reply-To: <20220302195519.3479274-1-kafai@fb.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, kernel-team@fb.com,
        willemb@google.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 2 Mar 2022 11:55:19 -0800 you wrote:
> skb->tstamp was first used as the (rcv) timestamp.
> The major usage is to report it to the user (e.g. SO_TIMESTAMP).
> 
> Later, skb->tstamp is also set as the (future) delivery_time (e.g. EDT in TCP)
> during egress and used by the qdisc (e.g. sch_fq) to make decision on when
> the skb can be passed to the dev.
> 
> [...]

Here is the summary with links:
  - [v6,net-next,01/13] net: Add skb->mono_delivery_time to distinguish mono delivery_time from (rcv) timestamp
    https://git.kernel.org/netdev/net-next/c/a1ac9c8acec1
  - [v6,net-next,02/13] net: Add skb_clear_tstamp() to keep the mono delivery_time
    https://git.kernel.org/netdev/net-next/c/de799101519a
  - [v6,net-next,03/13] net: Handle delivery_time in skb->tstamp during network tapping with af_packet
    https://git.kernel.org/netdev/net-next/c/27942a15209f
  - [v6,net-next,04/13] net: Clear mono_delivery_time bit in __skb_tstamp_tx()
    https://git.kernel.org/netdev/net-next/c/d93376f503c7
  - [v6,net-next,05/13] net: Set skb->mono_delivery_time and clear it after sch_handle_ingress()
    https://git.kernel.org/netdev/net-next/c/d98d58a00261
  - [v6,net-next,06/13] net: ip: Handle delivery_time in ip defrag
    https://git.kernel.org/netdev/net-next/c/8672406eb5d7
  - [v6,net-next,07/13] net: ipv6: Handle delivery_time in ipv6 defrag
    https://git.kernel.org/netdev/net-next/c/335c8cf3b537
  - [v6,net-next,08/13] net: ipv6: Get rcv timestamp if needed when handling hop-by-hop IOAM option
    https://git.kernel.org/netdev/net-next/c/b6561f8491ca
  - [v6,net-next,09/13] net: Get rcv tstamp if needed in nfnetlink_{log, queue}.c
    https://git.kernel.org/netdev/net-next/c/80fcec675112
  - [v6,net-next,10/13] net: Postpone skb_clear_delivery_time() until knowing the skb is delivered locally
    https://git.kernel.org/netdev/net-next/c/cd14e9b7b8d3
  - [v6,net-next,11/13] bpf: Keep the (rcv) timestamp behavior for the existing tc-bpf@ingress
    https://git.kernel.org/netdev/net-next/c/7449197d600d
  - [v6,net-next,12/13] bpf: Add __sk_buff->delivery_time_type and bpf_skb_set_skb_delivery_time()
    https://git.kernel.org/netdev/net-next/c/8d21ec0e46ed
  - [v6,net-next,13/13] bpf: selftests: test skb->tstamp in redirect_neigh
    https://git.kernel.org/netdev/net-next/c/c803475fd8dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


