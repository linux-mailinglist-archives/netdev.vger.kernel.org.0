Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184024BE95E
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357642AbiBUMNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 07:13:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357561AbiBUMNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 07:13:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7ED2408B;
        Mon, 21 Feb 2022 04:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 27A16CE0F9B;
        Mon, 21 Feb 2022 12:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7060AC340EC;
        Mon, 21 Feb 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645445410;
        bh=Bsa08A8l8q2Sdy6wdsD3fJbBvHVtS+gIZ6/u9OUucdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mizti06W7+yqDV/3zhePhUFWbB+sN83MMZZY8QAeGrpnsUWt5272zl+BByZYMD/AL
         V2E0FaQcPrniAXGUvhbaqFMHln2zx9pqD6gn6xesBLDt8cIjv7skOhTRuN860KOaf6
         iMu4zeFgqxio7yBoeOTsoPsZpVltmg3Rfp9nWy8sXlSztZ43YMvF+jUEfoTOLA06Jz
         yesRd95aC4SkRHnRbWdglLy/XYEkxYkWqW43Vchhstn2cMMZJQ87GfRPW/Ftgkp2zm
         JNsrZQ9JpbC8G1LV1tyZlQ+Xur6RAKtVBn9a56mPXBCeyTt+GoZj+819JmbcBoDQNH
         eoUJwUpKenzhg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5BBC3E6D45A;
        Mon, 21 Feb 2022 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ravb: Use GFP_KERNEL instead of GFP_ATOMIC when possible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164544541037.27256.8743996856052704518.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Feb 2022 12:10:10 +0000
References: <3d67f0369909010d620bd413c41d11b302eb0ff8.1645342015.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <3d67f0369909010d620bd413c41d11b302eb0ff8.1645342015.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 20 Feb 2022 08:27:15 +0100 you wrote:
> 'max_rx_len' can be up to GBETH_RX_BUFF_MAX (i.e. 8192) (see
> 'gbeth_hw_info').
> The default value of 'num_rx_ring' can be BE_RX_RING_SIZE (i.e. 1024).
> 
> So this loop can allocate 8 Mo of memory.
> 
> Previous memory allocations in this function already use GFP_KERNEL, so
> use __netdev_alloc_skb() and an explicit GFP_KERNEL instead of a
> implicit GFP_ATOMIC.
> 
> [...]

Here is the summary with links:
  - ravb: Use GFP_KERNEL instead of GFP_ATOMIC when possible
    https://git.kernel.org/netdev/net-next/c/91398a960edf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


