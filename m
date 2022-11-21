Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8950A6322EC
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiKUNAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiKUNAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BA429353;
        Mon, 21 Nov 2022 05:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E568CB80FAB;
        Mon, 21 Nov 2022 13:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AF49C433D6;
        Mon, 21 Nov 2022 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669035617;
        bh=IRLq90HgIgaYJBqQlWqulBLuJesIMlaOBHZHwZsU2kQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TCbD21TK43sgC0q0MdEx+Ng5Ab1Iuut4l/2CoLyQqeVts1o+uk/kemvRt274T9H20
         CmbzdS8oysqGYsjI9IIChUmrMBuIK03BN9+XUvzCZSXY/SpIyNWsPahmIWJWZ6LYyf
         voBsZ/rpHKvgPfWZOj7F5FN4UPtbNlv+9gClYaZ19BdUELwtlEjTEFSC+kBlXH3c7I
         uDQmUXvJzZbg2v5pAOqciliLIZHywBMrATE5uGabcXzftmwj8m+bDz37t1K9XqzLkv
         G3qrxsbnuencTwncy5b8LDgjtckUJH19Ymw/j2C4lTkAS3GG2n5MB/pc0kuNihJzxw
         D0tVZ9o8D1ucQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C979E270C9;
        Mon, 21 Nov 2022 13:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/net: Find nettest in current directory
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166903561750.31413.5757792572510946174.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 13:00:17 +0000
References: <20221118034421.994619-1-daniel.diaz@linaro.org>
In-Reply-To: <20221118034421.994619-1-daniel.diaz@linaro.org>
To:     =?utf-8?q?Daniel_D=C3=ADaz_=3Cdaniel=2Ediaz=40linaro=2Eorg=3E?=@ci.codeaurora.org
Cc:     linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 21:44:21 -0600 you wrote:
> The `nettest` binary, built from `selftests/net/nettest.c`,
> was expected to be found in the path during test execution of
> `fcnal-test.sh` and `pmtu.sh`, leading to tests getting
> skipped when the binary is not installed in the system, as can
> be seen in these logs found in the wild [1]:
> 
>   # TEST: vti4: PMTU exceptions                                         [SKIP]
>   [  350.600250] IPv6: ADDRCONF(NETDEV_CHANGE): veth_b: link becomes ready
>   [  350.607421] IPv6: ADDRCONF(NETDEV_CHANGE): veth_a: link becomes ready
>   # 'nettest' command not found; skipping tests
>   #   xfrm6udp not supported
>   # TEST: vti6: PMTU exceptions (ESP-in-UDP)                            [SKIP]
>   [  351.605102] IPv6: ADDRCONF(NETDEV_CHANGE): veth_b: link becomes ready
>   [  351.612243] IPv6: ADDRCONF(NETDEV_CHANGE): veth_a: link becomes ready
>   # 'nettest' command not found; skipping tests
>   #   xfrm4udp not supported
> 
> [...]

Here is the summary with links:
  - selftests/net: Find nettest in current directory
    https://git.kernel.org/netdev/net/c/bd5e1e42826f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


