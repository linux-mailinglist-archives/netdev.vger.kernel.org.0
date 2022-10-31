Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54836613249
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiJaJKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiJaJKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5C5DE8A
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 02:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 242BDB8125C
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 09:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB75EC433D7;
        Mon, 31 Oct 2022 09:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667207416;
        bh=sNftmCX0dgdvzG2qVHw9ppDZSiHlnoBJzIZbhXjyUAk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RfW3t/vOgtFjqW4TmKmCc7Bb32XLqMkImr2uXp1qV/eyf3/RhwJDgmT1QRapLU2PG
         k7UZ6ZH7d9PPdTWH0JT8LhpX3zNaatId5nQLmakjvs+uvKEh1ExUrcKvZuo1qDIMQi
         aZnZYEOtKnhJUZ9wIlAuysW3jLsYINDbO2bSKZtOfRqSPaWzpjzqY79YeAkDhqXDpj
         lCSnHVsDspZDUbXZT59acx4UcwczsdC2YNtXqthmJc5cKMqp70ivsfYqx7ndcUuKUp
         7sV6FqZY5IS9q044IzIeb8PkGhZapru3ROaPKAjhgr52P2mBvqrg1xa0koUWH0rIEw
         sRyh0XBk2x7tA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A712E270D6;
        Mon, 31 Oct 2022 09:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4] nfc: Fix potential memory leak of skb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166720741662.7426.5241342853089135473.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 09:10:16 +0000
References: <20221027140332.18336-1-shangxiaojing@huawei.com>
In-Reply-To: <20221027140332.18336-1-shangxiaojing@huawei.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     krzysztof.kozlowski@linaro.org, sebastian.reichel@collabora.com,
        peda@axentia.se, khalasa@piap.pl, kuba@kernel.org,
        u.kleine-koenig@pengutronix.de, michael@walle.cc,
        sameo@linux.intel.com, robert.dolca@intel.com,
        clement.perrochaud@nxp.com, r.baldyga@samsung.com,
        cuissard@marvell.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Oct 2022 22:03:28 +0800 you wrote:
> There are 6 kinds of send functions can be called by nci_send_frame():
> 	virtual_nci_send(),
> 	fdp_nci_send(),
> 	nxp_nci_send(),
> 	s3fwrn5_nci_send(),
> 	nfcmrvl_nci_send(),
> 	st_nci_send();
> 
> [...]

Here is the summary with links:
  - [1/4] nfc: fdp: Fix potential memory leak in fdp_nci_send()
    https://git.kernel.org/netdev/net/c/8e4aae6b8ca7
  - [2/4] nfc: nxp-nci: Fix potential memory leak in nxp_nci_send()
    https://git.kernel.org/netdev/net/c/7bf1ed6aff0f
  - [3/4] nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()
    https://git.kernel.org/netdev/net/c/3a146b7e3099
  - [4/4] nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()
    https://git.kernel.org/netdev/net/c/93d904a734a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


