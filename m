Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362596AF258
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbjCGSwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjCGSwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:52:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96071ABB0F;
        Tue,  7 Mar 2023 10:40:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CC6BB819CC;
        Tue,  7 Mar 2023 18:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC57CC4339C;
        Tue,  7 Mar 2023 18:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678214422;
        bh=iIj+KJVJvP+2p1SBvnFT8/Ub+i++GGMY0Mem0dbIzqY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HuVuAf1h9KSuk8dejsvl1Updr+QlpxusrT4Bg06Jf4RyuMjM9eZOfe0qp3H86oWL+
         Z5pXI/+hNY3LGTClUpiNdLt/vNWIhiNjNz/QBObkIGbtJEkhnrWy/DSgF/Ptaj4qqp
         B8AQlCdeVV8OjuJbU20o1h/cMwXzXlx5Z/YYgyp+Nj8MuxxVOmQb2UHuOda5MF8st1
         EneD9I5Iy9RtOpCCKfiLbDUDMrDXwtF/qHW+2QwYuqjTkh972FCZfvUlVV1XbEt+7K
         VBg4kAzddwJ/nIiBR9Ex/Bo6RSyXFcCaTLkT3ZYRJTHfTdmpnnSRSXqKpWxsnzfHqD
         9MWpcLu+dcTSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 96588E61B67;
        Tue,  7 Mar 2023 18:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: hci_sync: Don't wait peer's reply when powering
 off
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167821442261.6197.2161849719064064403.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Mar 2023 18:40:22 +0000
References: <20230306170628.1.I8d0612b2968dd4740a4ceaf42f329fb59d5b9324@changeid>
In-Reply-To: <20230306170628.1.I8d0612b2968dd4740a4ceaf42f329fb59d5b9324@changeid>
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, chromeos-bluetooth-upstreaming@chromium.org,
        apusaka@chromium.org, abhishekpandit@google.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Mon,  6 Mar 2023 17:07:07 +0800 you wrote:
> From: Archie Pusaka <apusaka@chromium.org>
> 
> Currently, when we initiate disconnection, we will wait for the peer's
> reply unless when we are suspending, where we fire and forget the
> disconnect request.
> 
> A similar case is when adapter is powering off. However, we still wait
> for the peer's reply in this case. Therefore, if the peer is
> unresponsive, the command will time out and the power off sequence
> will fail, causing "bluetooth powered on by itself" to users.
> 
> [...]

Here is the summary with links:
  - Bluetooth: hci_sync: Don't wait peer's reply when powering off
    https://git.kernel.org/bluetooth/bluetooth-next/c/bc044bb47d5a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


