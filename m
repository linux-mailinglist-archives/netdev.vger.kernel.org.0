Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF636D8754
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 21:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbjDETu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 15:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjDETuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 15:50:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9637A96;
        Wed,  5 Apr 2023 12:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C667B640E8;
        Wed,  5 Apr 2023 19:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 117CAC4339B;
        Wed,  5 Apr 2023 19:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680724219;
        bh=C2JZKsWWj3Lk4gHlvzP56MFwzu9QP4vVz64o99qXE54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HmnEib3n+9AJTSeAllh6ljIfZDRl+CJsFJ5MYKYAezCHCTOCV39ELj2QaGW6TMGlT
         lm1yJXhUFo7yi4vKzewrkp40zSdKvIlGOee0lU99yaQqOIeOy4c2eXAY2aUo4/z0O8
         SS5DnamGrcFqYIjWIzAf5ok7rr+Ew9dReLfaznTJTNoP4cq3gaoaY+YJVyMpqhhGJW
         4qHLDwJVp3FwOeWPcrXHsK9F/aa2yCr86ppnDZ8uAli7V9mRgh8vInjwEpCfSUhJkQ
         lbaQ+7O1G79wlhai1swhnSUf6QaNm/8MNLYj8GToWjxrkGFXl2ATV0wmoycCEDdeJq
         BQDrG3YKda08Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7674C395D8;
        Wed,  5 Apr 2023 19:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] selftests: xsk: Deflakify STATS_RX_DROPPED test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168072421894.28321.18230230316101507233.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Apr 2023 19:50:18 +0000
References: <20230403120400.31018-1-kal.conley@dectris.com>
In-Reply-To: <20230403120400.31018-1-kal.conley@dectris.com>
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, mykolal@fb.com,
        shuah@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Mon,  3 Apr 2023 14:03:59 +0200 you wrote:
> Fix flaky STATS_RX_DROPPED test. The receiver calls getsockopt after
> receiving the last (valid) packet which is not the final packet sent in
> the test (valid and invalid packets are sent in alternating fashion with
> the final packet being invalid). Since the last packet may or may not
> have been dropped already, both outcomes must be allowed.
> 
> This issue could also be fixed by making sure the last packet sent is
> valid. This alternative is left as an exercise to the reader (or the
> benevolent maintainers of this file).
> 
> [...]

Here is the summary with links:
  - [bpf] selftests: xsk: Deflakify STATS_RX_DROPPED test
    https://git.kernel.org/bpf/bpf-next/c/68e7322142f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


