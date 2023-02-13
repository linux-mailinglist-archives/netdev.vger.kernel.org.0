Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84DC694230
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 11:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjBMKAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 05:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjBMKAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 05:00:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE67E3A0;
        Mon, 13 Feb 2023 02:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38ECEB80EC2;
        Mon, 13 Feb 2023 10:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D115BC433D2;
        Mon, 13 Feb 2023 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676282420;
        bh=gci7ztcK13nY3QL8mqe9BhJiQ/V1zaLfCsRD/jr5fBE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uZlz9eLGAyyjtw0Dbc3fP3Yzv3l09HPY5zVroAeBdyMPEpI1Q/M+LR5Pl08hg2s9e
         ah5zrIhFbc97NTze+keAbY4RBKNXs02VTVriiMm2B/Gu3Yet7n5ZmkVqqLy+LV2Ogw
         k2SobHbRlKzMHNL6PfKHrN1Jq3FExODHHxVDd1Yx5g4F/YEd3DKPdo9Rnb1OOUPCMy
         iAqH+j+pOPI2Qv8BUV1WVgAJoZ2jnXe5qvEbP9Vh9X+Cx6X1+4AGV41ij3qtBQuIWp
         o93h3LQK5iaJuA/DphaQrwGXRFT4fzU6//PiCrolcIr7Qw/tH7d6DzOliYZWai+V1K
         ERB/Pon7i8bug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC59CE68D2E;
        Mon, 13 Feb 2023 10:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] net: ipa: determine GSI register offsets
 differently
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628242076.19101.9880598205001821654.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 10:00:20 +0000
References: <20230210193655.460225-1-elder@linaro.org>
In-Reply-To: <20230210193655.460225-1-elder@linaro.org>
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

On Fri, 10 Feb 2023 13:36:47 -0600 you wrote:
> This series changes the way GSI register offset are specified, using
> the "reg" mechanism currently used for IPA registers.  A follow-on
> series will extend this work so fields within GSI registers are also
> specified this way.
> 
> The first patch rearranges the GSI register initialization code so
> it is similar to the way it's done for the IPA registers.  The
> second identifies all the GSI registers in an enumerated type.
> The third introduces "gsi_reg-v3.1.c" and uses the "reg" code to
> define one GSI register offset.  The second-to-last patch just
> adds "gsi_reg-v3.5.1.c", because that version introduces a new
> register not previously defined.  All the rest just define the
> rest of the GSI register offsets using the "reg" mechanism.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: ipa: introduce gsi_reg_init()
    https://git.kernel.org/netdev/net-next/c/3c506add35c7
  - [net-next,2/8] net: ipa: introduce GSI register IDs
    https://git.kernel.org/netdev/net-next/c/8f0fece65d9e
  - [net-next,3/8] net: ipa: start creating GSI register definitions
    https://git.kernel.org/netdev/net-next/c/d2bb6e657f16
  - [net-next,4/8] net: ipa: add more GSI register definitions
    https://git.kernel.org/netdev/net-next/c/76924eb92801
  - [net-next,5/8] net: ipa: define IPA v3.1 GSI event ring register offsets
    https://git.kernel.org/netdev/net-next/c/d1ce6395d464
  - [net-next,6/8] net: ipa: define IPA v3.1 GSI interrupt register offsets
    https://git.kernel.org/netdev/net-next/c/7ba51aa2d09b
  - [net-next,7/8] net: ipa: add "gsi_v3.5.1.c"
    https://git.kernel.org/netdev/net-next/c/465d1bc9823d
  - [net-next,8/8] net: ipa: define IPA remaining GSI register offsets
    https://git.kernel.org/netdev/net-next/c/5791a73c8916

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


