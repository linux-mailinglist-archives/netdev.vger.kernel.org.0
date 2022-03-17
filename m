Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7DD4DD16C
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 00:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiCQXvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 19:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiCQXvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 19:51:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3532AD5C0;
        Thu, 17 Mar 2022 16:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB752B820F7;
        Thu, 17 Mar 2022 23:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 150C7C340FD;
        Thu, 17 Mar 2022 23:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647561013;
        bh=c1V1W/Z6upj9EHdN7vT5myGXAIy+0q+iY7PKceEadMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IBTPDbGMcV9tJ88ZCEPaEd4TLZuSK10F9wogtCVEH9ZHcVSXI1/+dnykZLXgDpErS
         i12IKQfhwI/VAJCZaTTTnJ6+BBTbCCTqIY0sJHONShqdeCHW2wjXBQh5Ir8h+jqIYI
         Ui2O8g5nj5c8cBlOj6o+6EHuZ8lO74oGW646TfN0a7vS9YrewMAkukJqCo7U1Ihyrl
         vqR2xp2k0V1B6TznTJMlBAE6vlhEK20VKrAsDU4kelmHqopR+W/quYQZK9/q3MIlVk
         4+N5gNYNKl6+zUXW2cxBweRV1zNVxBSkqw3mF9h8lxtSQZJjfYj/ss1/luaRnHxPp1
         YvBpQMFAzyapg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2569E8DD5B;
        Thu, 17 Mar 2022 23:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/fsl: xgmac_mdio: use correct format characters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164756101298.14093.46487010735333279.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 23:50:12 +0000
References: <20220316213114.2352352-1-morbo@google.com>
In-Reply-To: <20220316213114.2352352-1-morbo@google.com>
To:     Bill Wendling <morbo@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, tobias@waldekranz.com, mw@semihalf.com,
        andrew@lunn.ch, calvin.johnson@oss.nxp.com, markus@notsyncing.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Mar 2022 14:31:14 -0700 you wrote:
> When compiling with -Wformat, clang emits the following warning:
> 
> drivers/net/ethernet/freescale/xgmac_mdio.c:243:22: warning: format
> specifies type 'unsigned char' but the argument has type 'int'
> [-Wformat]
>                         phy_id, dev_addr, regnum);
>                                           ^~~~~~
> ./include/linux/dev_printk.h:163:47: note: expanded from macro 'dev_dbg'
>                 dev_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__); \
>                                                     ~~~     ^~~~~~~~~~~
> ./include/linux/dev_printk.h:129:34: note: expanded from macro 'dev_printk'
>                 _dev_printk(level, dev, fmt, ##__VA_ARGS__);            \
>                                         ~~~    ^~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - net/fsl: xgmac_mdio: use correct format characters
    https://git.kernel.org/netdev/net-next/c/c011072c9035

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


