Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0B451CE2B
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387890AbiEFBYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378537AbiEFBX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26532188;
        Thu,  5 May 2022 18:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8BAF62021;
        Fri,  6 May 2022 01:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18AB4C385B6;
        Fri,  6 May 2022 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651800015;
        bh=xBLUhiaIuo9Y1XNtDWjj6ihKn/uAitAVim+bv3+TVkQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mvCn57yphW2RvRP1GuSdLQ/oT4OCL2pFSHwPRHBRkrTBxCVwrRqRvAIi3FCby5YOj
         grp2APkhELuSojoqQf7g0vToTFxYvLV+hbZ0OrZRPGUi18uChU5Di2vU80FrK9vvoc
         BzJfcHBELy9ZpynHMc3D1R4nPrJzo7DQDsnFzcJERZ72BkKRhZg/MRmZTA4+4Zhhwr
         9NG2FaslsiCGIfBby4iaYgQp2hSzBncO5aFJXf0qdww7WAMrLa7KSIavkk1wBE/zhu
         Lns9T1IYpGjF89NyZO0cG35OGlgMvuKPUOrx8WFJTaZ+T1vnOFce+OZVm8s3j00/e9
         Xcbj13YRKxvvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3CBCF03870;
        Fri,  6 May 2022 01:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: ethernet: Prepare cleanup of powerpc's
 asm/prom.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180001499.16316.17491619640124865110.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 01:20:14 +0000
References: <09a13d592d628de95d30943e59b2170af5b48110.1651663857.git.christophe.leroy@csgroup.eu>
In-Reply-To: <09a13d592d628de95d30943e59b2170af5b48110.1651663857.git.christophe.leroy@csgroup.eu>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dougmill@linux.ibm.com, drt@linux.ibm.com, sukadev@linux.ibm.com,
        tlfalcon@linux.ibm.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org,
        kou.ishizaki@toshiba.co.jp, geoff@infradead.org,
        tanghui20@huawei.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  4 May 2022 13:32:17 +0200 you wrote:
> powerpc's asm/prom.h includes some headers that it doesn't
> need itself.
> 
> In order to clean powerpc's asm/prom.h up in a further step,
> first clean all files that include asm/prom.h
> 
> Some files don't need asm/prom.h at all. For those ones,
> just remove inclusion of asm/prom.h
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: ethernet: Prepare cleanup of powerpc's asm/prom.h
    https://git.kernel.org/netdev/net-next/c/6bff3ffcf6ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


