Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4C54DB82F
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347970AbiCPSv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354237AbiCPSv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:51:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9A56BDCE
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70EEDB81CD1
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 18:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 027FDC36AE3;
        Wed, 16 Mar 2022 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647456611;
        bh=N8m1/tz6g9qM/3psFzt/O88cQWDwW8uV7RxJSXzml/M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PxGFvQNgx1BIJUidVl1XBGFu2n0sTC2NN8Zqzf+zCutuAH/SE9SEvvnfZKidE8elQ
         22BHgyPTiSF6tbt9e7A4qiZwysJ/BqKVgbVMH7h7GYwQGXEl8Wy5bHmQwyQjcHdydy
         oRtHv4o0eKycbIGeaUxiClkQs8I5pXllhZUw6pLtQlAnfwNsHMBGq0cZEAxEXHP8jp
         2j6cldTskNDjgB2Cd7NmpmTQaDP8NJFfe+VPOz+xH5JiMLWG58r62cErXXCmYBooe5
         +ADnh34qUQOb2ZHpgAj0O4hC2fvql8aGyD3DDqfMMO2hLuI2fQ5GrcJ9d92XxoOdI+
         F2BxlietZfcwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D807CE6BBCA;
        Wed, 16 Mar 2022 18:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] af_key: add __GFP_ZERO flag for compose_sadb_supported in
 function pfkey_register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164745661088.4226.40823092237763663.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Mar 2022 18:50:10 +0000
References: <20220316121142.3142336-2-steffen.klassert@secunet.com>
In-Reply-To: <20220316121142.3142336-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Wed, 16 Mar 2022 13:11:41 +0100 you wrote:
> From: Haimin Zhang <tcs_kernel@tencent.com>
> 
> Add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
> to initialize the buffer of supp_skb to fix a kernel-info-leak issue.
> 1) Function pfkey_register calls compose_sadb_supported to request
> a sk_buff. 2) compose_sadb_supported calls alloc_sbk to allocate
> a sk_buff, but it doesn't zero it. 3) If auth_len is greater 0, then
> compose_sadb_supported treats the memory as a struct sadb_supported and
> begins to initialize. But it just initializes the field sadb_supported_len
> and field sadb_supported_exttype without field sadb_supported_reserved.
> 
> [...]

Here is the summary with links:
  - [1/2] af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
    https://git.kernel.org/netdev/net/c/9a564bccb78a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


