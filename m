Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED11661F3A
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbjAIHaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbjAIHaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEC112769;
        Sun,  8 Jan 2023 23:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFADD60F3E;
        Mon,  9 Jan 2023 07:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E0D2C433F0;
        Mon,  9 Jan 2023 07:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673249416;
        bh=VxWTfqxEMpBw9xSfv9/nyY3pYSejPi/tQPBKoL5xCQU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jftJbAoo5F5Nm7ujNYHlKtwco0V3cDgQi1QKEhrBna/7F2OtE9OOUrYHkk2MaE8yK
         1Gc3ZYiS2kkCt/tG0nrhvt9su40aIlkqxifz45nbUVnD6zEmOoJm0TZx+1qaSENMH3
         HudXvQ9/3gLLFM2uhGcTw584HF+u0ZZ9Sla6GWO6f16Tgqwf+23c7DCVm/Jajw2W73
         OgLi0OQQanHBvO6booLnbKXT5ky2g/LEsQjucqjn8HTVU2UofGDamuK8300mq52ZMA
         ipo6ZRniHZUJJRm82yq3ESclOU/lBprD7CiL5CDQgj5CpfnHxol1KhLFNgt3WvQ9PH
         B9gsIc1kWoFEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B823C395DF;
        Mon,  9 Jan 2023 07:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: ipa: correct IPA v4.7 IMEM offset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167324941610.24554.3662566736671862735.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Jan 2023 07:30:16 +0000
References: <20230106132502.3307220-1-elder@linaro.org>
In-Reply-To: <20230106132502.3307220-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, luca.weiss@fairphone.com,
        konrad.dybcio@linaro.org, caleb.connolly@linaro.org,
        mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Fri,  6 Jan 2023 07:25:01 -0600 you wrote:
> Commit b310de784bacd ("net: ipa: add IPA v4.7 support") was merged
> despite an unresolved comment made by Konrad Dybcio.  Konrad
> observed that the IMEM region specified for IPA v4.7 did not match
> that used downstream for the SM7225 SoC.  In "lagoon.dtsi" present
> in a Sony Xperia source tree, a ipa_smmu_ap node was defined with a
> "qcom,additional-mapping" property that defined the IPA IMEM area
> starting at offset 0x146a8000 (not 0x146a9000 that was committed).
> 
> [...]

Here is the summary with links:
  - [net,v2] net: ipa: correct IPA v4.7 IMEM offset
    https://git.kernel.org/netdev/net/c/60ea6f00c57d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


