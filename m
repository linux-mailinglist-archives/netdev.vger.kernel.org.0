Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA447597663
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbiHQTUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236373AbiHQTUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6A0A2620;
        Wed, 17 Aug 2022 12:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95636B81F47;
        Wed, 17 Aug 2022 19:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C29CC433D7;
        Wed, 17 Aug 2022 19:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660764015;
        bh=L5ndml8nd1uuvj+9Xi32ix/zxQYR/q5VszUkitr6U28=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rUbx/+qZN1Sg7ICEf2M/KOQKKME9g9nd5l5aMHangKxQgHKr3vcZfQQjvdrJAqayA
         23FzcQgi8UaM6mRad5hrsEPwnhgMHXS7wmC0VVN9XOO363A9064McaEt9yfheydWQu
         qiIs+lUZoFbU/8X1PuIjQKg7wf0j7ZkZl7jbZfIRFO0FTFgx0zIV/gHtvHAheQu781
         S9G+gkhd9DkpLVa/62vILKjT+5FIg2MLmaCWjR4LD4X6Mbd3FjtxksfDArlaZrDtwY
         ow3SX5588bZ6x16ZxOpr4zVj9lCK23Q4Gdx8snotOrnJy5TS/8bIJXWzuYC6kp+FXR
         Wrkw0JnmIXNkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2EC42E2A052;
        Wed, 17 Aug 2022 19:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net v3] net: dsa: microchip: ksz9477: fix fdb_dump last
 invalid entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166076401518.21609.10073950872734120316.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 19:20:15 +0000
References: <20220816105516.18350-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220816105516.18350-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 Aug 2022 16:25:16 +0530 you wrote:
> In the ksz9477_fdb_dump function it reads the ALU control register and
> exit from the timeout loop if there is valid entry or search is
> complete. After exiting the loop, it reads the alu entry and report to
> the user space irrespective of entry is valid. It works till the valid
> entry. If the loop exited when search is complete, it reads the alu
> table. The table returns all ones and it is reported to user space. So
> bridge fdb show gives ff:ff:ff:ff:ff:ff as last entry for every port.
> To fix it, after exiting the loop the entry is reported only if it is
> valid one.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: dsa: microchip: ksz9477: fix fdb_dump last invalid entry
    https://git.kernel.org/netdev/net/c/36c0d9350157

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


