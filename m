Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CAE67F66B
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 09:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbjA1IkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 03:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjA1IkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 03:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEB31D90B
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 00:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48630B81239
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7E17C433AA;
        Sat, 28 Jan 2023 08:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674895217;
        bh=t+gGmUFgRjUtXfeyG6XpNK13aT/9uUt6Km8oP+jj5OU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pqKdFPESriFd7x1JpjrpSFCtxswV9b24z+0gnq577wQsMLajejj+gBuCIZoz185vA
         UIIwI7iIs1IG0tAJuw/jkmmiKQNTLI0RnoU3/WTXlZDWbQlcMqJN+dHROz202rsTKn
         MPAAAcd+Y+/EUibOq8xVB9quVDMQBuXUlqJHqA33VjECin5UTu/l3ihOUXJR+SVKMO
         IESa6s40LAGvnBGqHH5nHuWPUVC3AxlCO5o9o3txJ8CeMs0uTHZV32hUv+mj+4DrWF
         z7t5uvrbxyXgVKtov+oqB6MEiUHZ3gFFnIPz/m1lYrfmKo4wQGP3NDx+3sPKE6Oky/
         a3k+cjJJFYbfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1A8FF83ED5;
        Sat, 28 Jan 2023 08:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: correctly advertise tunneled IPv6 segmentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167489521765.20245.3223836347790017514.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 08:40:17 +0000
References: <20230125143513.25841-1-ihuguet@redhat.com>
In-Reply-To: <20230125143513.25841-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, tizhao@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 25 Jan 2023 15:35:13 +0100 you wrote:
> Recent sfc NICs are TSO capable for some tunnel protocols. However, it
> was not working properly because the feature was not advertised in
> hw_enc_features, but in hw_features only.
> 
> Setting up a GENEVE tunnel and using iperf3 to send IPv4 and IPv6 traffic
> to the tunnel show, with tcpdump, that the IPv4 packets still had ~64k
> size but the IPv6 ones had only ~1500 bytes (they had been segmented by
> software, not offloaded). With this patch segmentation is offloaded as
> expected and the traffic is correctly received at the other end.
> 
> [...]

Here is the summary with links:
  - [net] sfc: correctly advertise tunneled IPv6 segmentation
    https://git.kernel.org/netdev/net/c/ffffd2454a7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


