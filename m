Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570AD613465
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 12:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiJaLUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 07:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiJaLUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 07:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36864DF21
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 04:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEAAAB815BB
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 11:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D259C433C1;
        Mon, 31 Oct 2022 11:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667215218;
        bh=KT9CDxyXOu7N/WCw6PXeqvP+iCEne49tG2KW/106XG8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XGi8Dd4vCfFfgbV/UYI/JY0jID5pmqSYxi9bvfqkiUj47dx5zXNYkc+uDwpHurl62
         LDjDNkZ03lK5zY4jOvavw0XUH6/BTEwjVccbe5vVj0V2xOl1OH0VlKds63OjJFspNu
         vjNnj2pDhsTu8bMh8steytaLbW5rBB+7VBAqBWI26EdWeXHKYaptt65KLckGRvgexm
         2sVH+QtUbOvNhDKkUnEkiVI5F5TcOs/ZXZ666HnKwmTo1ihi4H+2NuN4TVPf0vzCum
         uL8nN2rYhFQmqyWay3t6sOLejCr3s34yNwQhImfCjO0+Z0c/zqBHKg7H2ZX2NATfdZ
         R7sqKuP/DssfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4502CE50D71;
        Mon, 31 Oct 2022 11:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v3 0/9] ptp: convert drivers to .adjfine
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166721521827.14218.11416568315766206050.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 11:20:18 +0000
References: <20221028110420.3451088-1-jacob.e.keller@intel.com>
In-Reply-To: <20221028110420.3451088-1-jacob.e.keller@intel.com>
To:     Keller@ci.codeaurora.org, Jacob E <jacob.e.keller@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, thomas.lendacky@amd.com,
        Shyam-sundar.S-k@amd.com, edumazet@google.com, pabeni@redhat.com,
        siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, bryan.whitehead@microchip.com, s.shtylyov@omp.ru,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, vithampi@vmware.com,
        pv-drivers@vmware.com, wangjie125@huawei.com,
        huangguangbin2@huawei.com, eranbe@nvidia.com, ayal@nvidia.com,
        cai.huoqing@linux.dev, biju.das.jz@bp.renesas.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com, phil.edworthy@renesas.com,
        jiasheng@iscas.ac.cn, gustavoars@kernel.org,
        linus.walleij@linaro.org, wanjiabing@vivo.com, lv.ruyi@zte.com.cn,
        arnd@arndb.de
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Oct 2022 04:04:11 -0700 you wrote:
> Many drivers implementing PTP have not yet migrated to the new .adjfine
> frequency adjustment implementation.
> 
> A handful of these drivers use hardware with a simple increment value which
> is adjusted by multiplying by the adjustment factor and then dividing by
> 1 billion. This calculation is very easy to convert to .adjfine, by simply
> updating the divisor.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/9] ptp: add missing documentation for parameters
    https://git.kernel.org/netdev/net-next/c/b9a61b97798c
  - [net-next,v3,2/9] ptp: introduce helpers to adjust by scaled parts per million
    (no matching commit)
  - [net-next,v3,3/9] drivers: convert unsupported .adjfreq to .adjfine
    https://git.kernel.org/netdev/net-next/c/73aa29a2b119
  - [net-next,v3,4/9] ptp: mlx4: convert to .adjfine and adjust_by_scaled_ppm
    https://git.kernel.org/netdev/net-next/c/6ed795965ede
  - [net-next,v3,5/9] ptp: mlx5: convert to .adjfine and adjust_by_scaled_ppm
    https://git.kernel.org/netdev/net-next/c/d8aad3f3694f
  - [net-next,v3,6/9] ptp: lan743x: remove .adjfreq implementation
    https://git.kernel.org/netdev/net-next/c/c56dff6a9a31
  - [net-next,v3,7/9] ptp: lan743x: use diff_by_scaled_ppm in .adjfine implementation
    https://git.kernel.org/netdev/net-next/c/8bc900cbffa7
  - [net-next,v3,8/9] ptp: ravb: convert to .adjfine and adjust_by_scaled_ppm
    https://git.kernel.org/netdev/net-next/c/673dd2c78817
  - [net-next,v3,9/9] ptp: xgbe: convert to .adjfine and adjust_by_scaled_ppm
    https://git.kernel.org/netdev/net-next/c/337ffae0e4d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


