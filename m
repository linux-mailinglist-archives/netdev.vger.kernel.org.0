Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211716D1ACB
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbjCaIue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbjCaIu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:50:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFDB1BF7C;
        Fri, 31 Mar 2023 01:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCDD3B82D5A;
        Fri, 31 Mar 2023 08:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C980C43445;
        Fri, 31 Mar 2023 08:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680252618;
        bh=wxIPqkwYPdKr0won1ENYznNgmtYMu1BdaFxQtzmUVWw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O/v88uFsbirSgv/7d67K6FfcIreC32+lYznPk5c4WDPn/N0JGP0vYhJ36RFTuWK/x
         tIygVQ1dFVMquIY9IWV1WeT8F2oz8dYaUw0RRXGvHH4m8w5I9LZfToNSFaYx8FmnPD
         xpQ0VtE5uFl1Cluet+zOig+4E6FGVGL7Sx6LOVnjxWW4rhympPnK+F21v0/lttdxAr
         7FI4y7FgshUo91mBd487vG+yTWMqdp9BXKJqmafm3CTWjwTAjRk1i26gtZnzc0rjAd
         ex3HDH2rCDqiRIchO7GkQo/ZeKC+meYJfZKydXgzCUGW1hIJCrLyfbVUdfQllDC4Q6
         fk8/NURbvYZcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6254AC0C40E;
        Fri, 31 Mar 2023 08:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vsock/vmci: convert VMCI error code to -ENOMEM on send
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168025261839.9284.14988415059370438454.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 08:50:18 +0000
References: <2c3aeeac-2fcb-16f6-41cd-c0ca4e6a6d3e@sberdevices.ru>
In-Reply-To: <2c3aeeac-2fcb-16f6-41cd-c0ca4e6a6d3e@sberdevices.ru>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        bobby.eshleman@bytedance.com, bryantan@vmware.com,
        vdasa@vmware.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com, avkrasnov@sberdevices.ru, pv-drivers@vmware.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 31 Mar 2023 10:56:41 +0300 you wrote:
> This adds conversion of VMCI specific error code to general -ENOMEM. It
> is needed, because af_vsock.c passes error value returned from transport
> to the user, which does not expect to get VMCI_ERROR_* values.
> 
> Fixes: c43170b7e157 ("vsock: return errors other than -ENOMEM to socket")
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] vsock/vmci: convert VMCI error code to -ENOMEM on send
    https://git.kernel.org/netdev/net/c/ffa5395a7901

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


