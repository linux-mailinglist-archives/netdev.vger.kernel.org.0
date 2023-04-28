Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A609F6F1CE3
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346235AbjD1Qvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjD1Qvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:51:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6441BE1;
        Fri, 28 Apr 2023 09:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 454D264492;
        Fri, 28 Apr 2023 16:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36D0C433D2;
        Fri, 28 Apr 2023 16:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682700703;
        bh=1RvrRNpn09jUVO+n+hwz5crXtPov4gaf+umReiinV1s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=J2w/MJfdB5QyGTzflpcMkPAC+WUnLm2++QP+ZpYLaKt+1ZWgreZDRDHWt0Eo9/G7y
         ppqeFzQyGmNu/d+qD47UwhFzciTa5u8vJD4gDK4n52FJvNRwfLAgnOf/iv8/AzEqwI
         f3NCOyHokFm6Umtn6ieRctkCX7+Q4ZOn5gY8t9IF7y/mGqT49dq/vMuFcQAFNNL7YC
         pKXE3bynTGyRcavpLvZ7FJwEbSCxuG/UbFufeEyzYPOYzrvQfJIF87S0o+O9u2jnbh
         shdfpKv96uUIG2QFgClpEis+c5Dlby3nK6tMecU14GDP5PQkC9iAF/o5pTvAfEshhn
         AHPUjTwjr6DHw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] wifi: ath9k: fix AR9003 mac hardware hang check
 register
 offset calculation
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230422212423.26065-1-ps.report@gmx.net>
References: <20230422212423.26065-1-ps.report@gmx.net>
To:     Peter Seiderer <ps.report@gmx.net>
Cc:     linux-wireless@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregg Wonderly <greggwonderly@seqtechllc.com>,
        Simon Horman <simon.horman@corigine.com>,
        Peter Seiderer <ps.report@gmx.net>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168270069650.13772.16153713023196522480.kvalo@kernel.org>
Date:   Fri, 28 Apr 2023 16:51:40 +0000 (UTC)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Seiderer <ps.report@gmx.net> wrote:

> Fix ath9k_hw_verify_hang()/ar9003_hw_detect_mac_hang() register offset
> calculation (do not overflow the shift for the second register/queues
> above five, use the register layout described in the comments above
> ath9k_hw_verify_hang() instead).
> 
> Fixes: 222e04830ff0 ("ath9k: Fix MAC HW hang check for AR9003")
> 
> Reported-by: Gregg Wonderly <greggwonderly@seqtechllc.com>
> Link: https://lore.kernel.org/linux-wireless/E3A9C354-0CB7-420C-ADEF-F0177FB722F4@seqtechllc.com/
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

3e56c80931c7 wifi: ath9k: fix AR9003 mac hardware hang check register offset calculation

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230422212423.26065-1-ps.report@gmx.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

