Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A893691A52
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjBJIuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjBJIuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:50:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CFB7B16D;
        Fri, 10 Feb 2023 00:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D128AB82408;
        Fri, 10 Feb 2023 08:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 730ECC4339B;
        Fri, 10 Feb 2023 08:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676019019;
        bh=zLx32N6ff4/WOW/b2VRCpc3Z7afbLUIgebvJtMlg5eo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fsio/DMQ8j0nkzi3yZPDdFjI7OTgjTuqieq6V710sJZpUW2h4Z60Dmi1AKWXakSvP
         1anUfEozsEuyChcZDMbwcAfjlxTq4ARocrH7QPj6NQgxgQI7F7U+a2xPam20xunPZn
         LU6FmK82WEelv0WsaA0SD0eVGHfUawUMWcw3ECDo78NxljwenmB18uoIo+wRpdQYD0
         TDDkduuPVvfTMtkUdKim/s1ebdc7kPTNQNmVLZyz6MHOdecSXHwYoQ0H8/Ugl+6tEM
         ZMpRBNcQJUk9P66YAzhjGFc8zPOfTtsZRxCxfe31P88GNLXIGMKQqdsnrerl9TYmdU
         JKPoXJs5WmZRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 545C0C41677;
        Fri, 10 Feb 2023 08:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] net: ipa: prepare for GSI register updtaes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167601901934.32230.173851279004955737.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 08:50:19 +0000
References: <20230208205653.177700-1-elder@linaro.org>
In-Reply-To: <20230208205653.177700-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  8 Feb 2023 14:56:44 -0600 you wrote:
> An upcoming series (or two) will convert the definitions of GSI
> registers used by IPA so they use the "IPA reg" mechanism to specify
> register offsets and their fields.  This will simplify implementing
> the fairly large number of changes required in GSI registers to
> support more than 32 GSI channels (introduced in IPA v5.0).
> 
> A few minor problems and inconsistencies were found, and they're
> fixed here.  The last three patches in this series change the
> "ipa_reg" code to separate the IPA-specific part (the base virtual
> address, basically) from the generic register part, and the now-
> generic code is renamed to use just "reg_" or "REG_" as a prefix
> rather than "ipa_reg" or "IPA_REG_".
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: ipa: generic command param fix
    https://git.kernel.org/netdev/net-next/c/2df181f09c96
  - [net-next,2/9] net: ipa: get rid of ipa->reg_addr
    https://git.kernel.org/netdev/net-next/c/38028e6f3923
  - [net-next,3/9] net: ipa: add some new IPA versions
    https://git.kernel.org/netdev/net-next/c/3aac8ec1c028
  - [net-next,4/9] net: ipa: tighten up IPA register validity checking
    https://git.kernel.org/netdev/net-next/c/d86603e940ae
  - [net-next,5/9] net: ipa: use bitmasks for GSI IRQ values
    https://git.kernel.org/netdev/net-next/c/c5ebba75c762
  - [net-next,6/9] net: ipa: GSI register cleanup
    https://git.kernel.org/netdev/net-next/c/0ec573ef2a1b
  - [net-next,7/9] net: ipa: start generalizing "ipa_reg"
    (no matching commit)
  - [net-next,8/9] net: ipa: generalize register offset functions
    https://git.kernel.org/netdev/net-next/c/fc4cecf70675
  - [net-next,9/9] net: ipa: generalize register field functions
    https://git.kernel.org/netdev/net-next/c/f1470fd790b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


