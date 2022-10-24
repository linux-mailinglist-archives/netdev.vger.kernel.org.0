Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56BB609E08
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiJXJad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiJXJaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:30:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD473BC70
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F3C1B81032
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 09:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D0F7C433D6;
        Mon, 24 Oct 2022 09:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666603816;
        bh=gjWqjMcsNChVuu8i2uUqm9/QsqrR1jbP8nqR0arrozg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eWRQKRlpIsSPP/52aZAMP1GsS34rdAWU0+acwTWH8PL5L5VRcRkJK3HQGpIR3MU1I
         TO3suWMF+UpG0EH3Is2hklIj8/PIniz1ZFraoJK1bmzYiTe2u0LHDw94fOPBfuIUVX
         wSTyR0MDnDELwjcJjzf/AZ33mV/1tFDkC/dQvzlh8KQRxiAnvOXte05p+f7q+SM3uO
         ZwY0qwqxRaxOHEb4BlHkjKDvdnaApZPNi0g3jAp6g1u1BRXQK34npH7LzaDBpqtF2o
         FzELYuNYijbE2NWN/4wwfWbeCC9ljp4B/+urpcEHI5/prqJCZnmn431ChUTB0ltAf7
         xtjvXO3K4rsfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4531C4166D;
        Mon, 24 Oct 2022 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] atlantic: fix deadlock at aq_nic_stop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166660381593.16636.18419272488332420903.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 09:30:15 +0000
References: <20221020075310.15226-1-ihuguet@redhat.com>
In-Reply-To: <20221020075310.15226-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     irusskikh@marvell.com, kuba@kernel.org, andrew@lunn.ch,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        dbogdanov@marvell.com, mstarovo@pm.me, netdev@vger.kernel.org,
        liali@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 20 Oct 2022 09:53:10 +0200 you wrote:
> NIC is stopped with rtnl_lock held, and during the stop it cancels the
> 'service_task' work and free irqs.
> 
> However, if CONFIG_MACSEC is set, rtnl_lock is acquired both from
> aq_nic_service_task and aq_linkstate_threaded_isr. Then a deadlock
> happens if aq_nic_stop tries to cancel/disable them when they've already
> started their execution.
> 
> [...]

Here is the summary with links:
  - [v2,net] atlantic: fix deadlock at aq_nic_stop
    https://git.kernel.org/netdev/net/c/6960d133f66e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


