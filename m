Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1D46887EC
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjBBUAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbjBBUAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7625774C00;
        Thu,  2 Feb 2023 12:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12AEA61CB4;
        Thu,  2 Feb 2023 20:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C584C4339B;
        Thu,  2 Feb 2023 20:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675368018;
        bh=O4DJ8D3JjwDWB9LK5kVI4nu5xSpL/iitMXyDRQKEgBE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LDdtRSpOzAd8mHkCSfQfZUtI8yf32kx7v8IloBAzzbx+t6uhU3gBPCFGRzDveQimV
         0YOnDparmXKEGGBVn8Fw1ELZI0azrg57Aheo4++j3S1/Rfg9IMb8uY6FrxeT/9tF3Z
         qI/5Z27DyOL0sTaonYCTzeFEIuwktVq+xRgRXpq6NXXtmRJefJlzUwnzAy7nLU+JU+
         0ffKxlxpZkCyZ/lgqOnBzzX+Fj2Q8gLrlqtu/kWhdxkXF+5Qr7mHFFzHD8fiSy4UC+
         EznViQ5v9/Glt9ASrxMlZmitbRwyiSmdBq8HivrjyuMJ6TM8qIOfTLknZAVkvpj+oV
         7Flo22fPi55sA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 337AAC0C40E;
        Thu,  2 Feb 2023 20:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] can: j1939: fix errant WARN_ON_ONCE in
 j1939_session_deactivate
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167536801820.2266.16323260245473548715.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 20:00:18 +0000
References: <20230202094135.2293939-2-mkl@pengutronix.de>
In-Reply-To: <20230202094135.2293939-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        william.xuanziyang@huawei.com,
        syzbot+9981a614060dcee6eeca@syzkaller.appspotmail.com,
        o.rempel@pengutronix.de
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Thu,  2 Feb 2023 10:41:31 +0100 you wrote:
> From: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
> The conclusion "j1939_session_deactivate() should be called with a
> session ref-count of at least 2" is incorrect. In some concurrent
> scenarios, j1939_session_deactivate can be called with the session
> ref-count less than 2. But there is not any problem because it
> will check the session active state before session putting in
> j1939_session_deactivate_locked().
> 
> [...]

Here is the summary with links:
  - [net,1/5] can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate
    https://git.kernel.org/netdev/net/c/d0553680f94c
  - [net,2/5] can: raw: fix CAN FD frame transmissions over CAN XL devices
    https://git.kernel.org/netdev/net/c/3793301cbaa4
  - [net,3/5] can: isotp: handle wait_event_interruptible() return values
    https://git.kernel.org/netdev/net/c/823b2e42720f
  - [net,4/5] can: isotp: split tx timer into transmission and timeout
    https://git.kernel.org/netdev/net/c/4f027cba8216
  - [net,5/5] can: mcp251xfd: mcp251xfd_ring_set_ringparam(): assign missing tx_obj_num_coalesce_irq
    https://git.kernel.org/netdev/net/c/1613fff7a32e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


