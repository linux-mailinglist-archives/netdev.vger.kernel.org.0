Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9FE4EA1A6
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 22:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345354AbiC1Ul4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 16:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344758AbiC1Ulz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 16:41:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E5B3DDED
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 13:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6034B81213
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 20:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 420DDC340F0;
        Mon, 28 Mar 2022 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648500011;
        bh=xm/glU3pw4+PQdpekhg/1oBYH+qVnvh2OfFcNjJtNk4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RZKb5D/Lzc4fvxkSdCHxfukEbya/yPYTa5rhT/aT+jsp1s5Ulfp+cqVcs1N2C8F9D
         eLAcObMKVl9+JjARxws8+sE5zwVFq7MJ+Xj0c85vpYsRciPN7WARgH6F5U2Esz2FFg
         L795y4NT4SiUfQgSPw3EYUxxe23gcgZbzDko1H3uNVShSF2kLzEXmbOfTKMbArr+o9
         zAe5RJF4Rskvlt7WcSHlUzoId0qZUzDSaj7vEqZvkAxVWL0eMSREEo9lq8rVEP/KYQ
         gQFin71QAyZFXP9v+kq2jo2kiFIdl/hzisKYNQKT3m3Dmvmkmnt7C5LshndqlC92HA
         VFPVyHzC//aVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24C87EAC09B;
        Mon, 28 Mar 2022 20:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: bnxt_ptp: fix compilation error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164850001114.15808.2888038241566176965.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Mar 2022 20:40:11 +0000
References: <20220328062708.207079-1-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220328062708.207079-1-damien.lemoal@opensource.wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, pavan.chebbi@broadcom.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Mar 2022 15:27:08 +0900 you wrote:
> The Broadcom bnxt_ptp driver does not compile with GCC 11.2.2 when
> CONFIG_WERROR is enabled. The following error is generated:
> 
> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c: In function ‘bnxt_ptp_enable’:
> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:400:43: error: array
> subscript 255 is above array bounds of ‘struct pps_pin[4]’
> [-Werror=array-bounds]
>   400 |  ptp->pps_info.pins[pin_id].event = BNXT_PPS_EVENT_EXTERNAL;
>       |  ~~~~~~~~~~~~~~~~~~^~~~~~~~
> In file included from drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:20:
> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h:75:24: note: while
> referencing ‘pins’
>    75 |         struct pps_pin pins[BNXT_MAX_TSIO_PINS];
>       |                        ^~~~
> cc1: all warnings being treated as errors
> 
> [...]

Here is the summary with links:
  - [v3] net: bnxt_ptp: fix compilation error
    https://git.kernel.org/netdev/net/c/dcf500065fab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


