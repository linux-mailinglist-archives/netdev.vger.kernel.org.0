Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080C0568BA8
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 16:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbiGFOuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 10:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiGFOuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 10:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612D01B791;
        Wed,  6 Jul 2022 07:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15AECB81D4C;
        Wed,  6 Jul 2022 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1AEBC341C6;
        Wed,  6 Jul 2022 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657119016;
        bh=9+gEuSSfLtAJkYuFFcnjKhneT43FC8KvqeBrFBYo8ak=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OfSIk0dSe6L9sBRc487uvZVmAbJLtYtsFFDESi9QoXKdeLrxywwLJQgqz89CITTZ0
         elqfdFIFlm1rkVgPzWgn2TGBNYsQAehcRqw3SOMr14uJU1qgc9esR+EzMjxiP3xVjF
         s3P0TK3zQs2iJCrnxyn9Hi62NAQmyWjQI5R+bIr6zMg1+UEpTKfVm1Z/lsP9jZCACb
         quWR6SxpiyOW49NFfxnZOIvWVK7xm0QOthuUJaqmFKSPsWlKxncFltkz4fJIePsKnV
         m1ezYp3VFXMuUlm/dyINjrAOihqNCm0LM6YhWiQLYGeF2VjvAyssVzRqOntR6cJCv6
         +OX5XzPXbDxNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74F71E45BD9;
        Wed,  6 Jul 2022 14:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v3] xdp: Fix spurious packet loss in generic XDP TX path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165711901647.17272.10488298931417432170.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jul 2022 14:50:16 +0000
References: <20220705082345.2494312-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20220705082345.2494312-1-johan.almbladh@anyfinetworks.com>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hawk@kernel.org, john.fastabend@gmail.com,
        song@kernel.org, martin.lau@linux.dev, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, Freysteinn.Alfredsson@kau.se, toke@redhat.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue,  5 Jul 2022 10:23:45 +0200 you wrote:
> The byte queue limits (BQL) mechanism is intended to move queuing from
> the driver to the network stack in order to reduce latency caused by
> excessive queuing in hardware. However, when transmitting or redirecting
> a packet using generic XDP, the qdisc layer is bypassed and there are no
> additional queues. Since netif_xmit_stopped() also takes BQL limits into
> account, but without having any alternative queuing, packets are
> silently dropped.
> 
> [...]

Here is the summary with links:
  - [bpf,v3] xdp: Fix spurious packet loss in generic XDP TX path
    https://git.kernel.org/bpf/bpf/c/1fd6e5675336

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


