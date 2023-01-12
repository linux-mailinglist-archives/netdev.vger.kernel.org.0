Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B91666AC0
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 06:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbjALFUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 00:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236326AbjALFUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 00:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700A44859B;
        Wed, 11 Jan 2023 21:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25B31B81DD0;
        Thu, 12 Jan 2023 05:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C21AAC433F0;
        Thu, 12 Jan 2023 05:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673500816;
        bh=Hcd5U67VJsibz/ZoBZjvua6nJb0h/zNvZUfjlALqBXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i+vwN/+2MPRDYIX0KzsOh8/6LPZbIzLI0ecvylFx4m/6+Z1zSbi6deXP+W4sdDsdc
         bBnWyu0UzgELKHE0ZZ0LZJnPgg79Y1682EQRHpYqmJmvA/xgU4Bs3nCiLFmHdmrZlv
         bcBDkfN+8vMJ5Vn3OjQYXVHvTfDtQLRaVWkA2DhfiCDTUdY76N4aRJDAkMb2uApsk/
         yOqThwtLAatQLEvSOPXbZ8BpyFfEXWRhXW/7KPu9DeQZi6FntAxg5Gieqc1HQpGwyM
         VBRm5GPT6tlRdkRpJ2vZv6NlBf0O/zLEA7lwHNtuzHSnMP0RAN71HRRUgaK7yK/tur
         38w2rpZiVwA/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1DAFC395C8;
        Thu, 12 Jan 2023 05:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] net: stmmac: add aux timestamps fifo clearance
 wait
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167350081665.21073.1228450610276293938.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Jan 2023 05:20:16 +0000
References: <20230111050200.2130-1-noor.azura.ahmad.tarmizi@intel.com>
In-Reply-To: <20230111050200.2130-1-noor.azura.ahmad.tarmizi@intel.com>
To:     Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Cc:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        noor.azura.ahmad.tarmizi@linux.intel.com, tee.min.tan@intel.com,
        hong.aun.looi@intel.com, muhammad.husaini.zulkifli@intel.com,
        stable@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 Jan 2023 13:02:00 +0800 you wrote:
> Add timeout polling wait for auxiliary timestamps snapshot FIFO clear bit
> (ATSFC) to clear. This is to ensure no residue fifo value is being read
> erroneously.
> 
> Fixes: f4da56529da6 ("net: stmmac: Add support for external trigger timestamping")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] net: stmmac: add aux timestamps fifo clearance wait
    https://git.kernel.org/netdev/net/c/ae9dcb91c606

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


