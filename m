Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1068674BDE
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjATFLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjATFLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:11:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2861AC4EBA;
        Thu, 19 Jan 2023 20:59:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B02EB822A0;
        Thu, 19 Jan 2023 12:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCD51C4339C;
        Thu, 19 Jan 2023 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674131417;
        bh=GitxTquGUz+90VYNOoAP7q1QmDkYeScw0cxKs7yRW4U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O7fVvQeiTDj21s2oqJ+41PiuLyMXhkHbi4QHHnqZYOv/lBUdYG8GuWW5vp03P0N8A
         Xbm6pOxD0iefwCdxgukVpNc1zjlaEd1XdYVSZewfs3/X9yneYtyviNbhjOWAr/JFe9
         h0fe9syUgaKb4TS2mm7nS5jc6077AOtSd4D9pkleuwE9hPVS0QBqw0JVOOiEyuIYOK
         ERI3clNSch3l2qKO7TlD8rua9olSt9kufc+rlgeu8IQR8rPzwNmwZyRf5C8lb6brYo
         sM2zAznoB/DseXJ7CxLkxsozguhaWiLr9QlZtA9mOdVu5+uvhhW+A2MgxAfzMn5VH8
         40D0+ggGIQLRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9100E54D27;
        Thu, 19 Jan 2023 12:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv4 net-next] selftests/net: mv bpf/nat6to4.c to net folder
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167413141775.31602.12927403453986476278.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 12:30:17 +0000
References: <20230118020927.3971864-1-liuhangbin@gmail.com>
In-Reply-To: <20230118020927.3971864-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, dsahern@kernel.org,
        lina.wang@mediatek.com, dietschc@csp.edu, bpf@vger.kernel.org,
        maze@google.com, bjorn@rivosinc.com, bjorn@kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 18 Jan 2023 10:09:27 +0800 you wrote:
> There are some issues with the bpf/nat6to4.c building.
> 
> 1. It use TEST_CUSTOM_PROGS, which will add the nat6to4.o to
>    kselftest-list file and run by common run_tests.
> 2. When building the test via `make -C tools/testing/selftests/
>    TARGETS="net"`, the nat6to4.o will be build in selftests/net/bpf/
>    folder. But in test udpgro_frglist.sh it refers to ../bpf/nat6to4.o.
>    The correct path should be ./bpf/nat6to4.o.
> 3. If building the test via `make -C tools/testing/selftests/ TARGETS="net"
>    install`. The nat6to4.o will be installed to kselftest_install/net/
>    folder. Then the udpgro_frglist.sh should refer to ./nat6to4.o.
> 
> [...]

Here is the summary with links:
  - [PATCHv4,net-next] selftests/net: mv bpf/nat6to4.c to net folder
    https://git.kernel.org/netdev/net-next/c/3c107f36db06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


