Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C3F5BEA8A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbiITPuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiITPuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E634F667;
        Tue, 20 Sep 2022 08:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CE59B82AEB;
        Tue, 20 Sep 2022 15:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50E4CC433D6;
        Tue, 20 Sep 2022 15:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663689016;
        bh=XVCmJtbJtR81L6NH/MyXEMpBjoZWmBPls2ZCMBskZk0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MwA1VgzZnGymfKnvmF2RWsDsduyE+ZsYMFXqluzh16xarisfJmpaCBp9Yd94D56I1
         oKBTfX4Z42/dIYSbzZe0jKakfqWSW+QoVvhQK/N+YJM/0yhhi8UCuCWuw88i1I9rXf
         6+TTsmMlHO1O9LSFtafSDxXdq9vrNi8CANuD180xswnBywXQ+EDmR3VgAQC92OYTq5
         Pp1TjiNn6NEFcI2gC2HNAKDX337m0FHc1Cd2RphLu8xNA13h1ZmBnnd2drH2+mRM/A
         zTmPaXyyppMU2XpRpLiPKqM4GrwORL4YcHPeVsvg6QSdn+E4of1tawj3LtBc1rfr25
         PdKJ5E55DPCVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37662E5251D;
        Tue, 20 Sep 2022 15:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5] ravb: Add RZ/G2L MII interface support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368901622.16825.11625479930549195610.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 15:50:16 +0000
References: <20220914192604.265859-1-biju.das.jz@bp.renesas.com>
In-Reply-To: <20220914192604.265859-1-biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, s.shtylyov@omp.ru,
        prabhakar.mahadev-lad.rj@bp.renesas.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, geert+renesas@glider.be,
        Chris.Paterson2@renesas.com, biju.das@bp.renesas.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Sep 2022 20:26:04 +0100 you wrote:
> EMAC IP found on RZ/G2L Gb ethernet supports MII interface.
> This patch adds support for selecting MII interface mode.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v4->v5:
>  * Reorderd enum CXR35_BIT from LSB to MSB
> v3->v4:
>  * Dropped CXR35_HALFCYC_CLKSW1000 enum
>  * Added CXR35_HALFCYC_CLKSW, CXR35_SEL_XMII and CXR35_SEL_XMII_RGMII
>    enum.
> v2->v3:
>  * Documented CXR35_HALFCYC_CLKSW1000 and CXR35_SEL_XMII_MII enum.
> v1->v2:
>  * Fixed spaces->Tab around CXR35 description.
> 
> [...]

Here is the summary with links:
  - [net-next,v5] ravb: Add RZ/G2L MII interface support
    https://git.kernel.org/netdev/net-next/c/1089877ada8d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


