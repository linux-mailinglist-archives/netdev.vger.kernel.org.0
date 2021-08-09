Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7A23E43A2
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhHIKK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233565AbhHIKKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 06:10:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B6A956108F;
        Mon,  9 Aug 2021 10:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628503805;
        bh=a1uxI0PmtDV0o9QXF4KHowqZymMZjF1yGtsUwEk1RqI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BzWZjAooTYbX9m+pxaxQPRP5+5PrE52yWMjjj1YxHJmqkjeNZhTn0hL5eEPQaWeTj
         UyXBPgz+AQXMbwjhE7VRaqJyI+848SceFfW3NSAz8uiZ3Dt/jemlu9QGkvgFqJiFVq
         1pNQ6UhcP+Re4a+QntcEA8hKsSOFpZUG/cdPADR5++O8vxSl6oeuc2Hy+XHYi3eC2/
         UifSaW6lSOOXGkVAtnU6ulnAwCnz6uKAxWLp2kxXT5/Pssae9/sw++GJ3zfxpAlbCI
         7AOidtmwfhCqsewcGt4Rq0sN+nvA4Q93XaW6Zlpg2yA2XuzvfNeFkdZ0fpo5ikkXIQ
         VhwCSoDvQGwtQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC44560A2A;
        Mon,  9 Aug 2021 10:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fec: fix build error for ARCH m68k
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162850380570.4301.2549596232050862056.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 10:10:05 +0000
References: <20210809042921.28931-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210809042921.28931-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, groeck7@gmail.com,
        netdev@vger.kernel.org, linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  9 Aug 2021 12:29:21 +0800 you wrote:
> reproduce:
> 	wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> 	chmod +x ~/bin/make.cross
> 	make.cross ARCH=m68k  m5272c3_defconfig
> 	make.cross ARCH=m68k
> 
>    drivers/net/ethernet/freescale/fec_main.c: In function 'fec_enet_eee_mode_set':
> >> drivers/net/ethernet/freescale/fec_main.c:2758:33: error: 'FEC_LPI_SLEEP' undeclared (first use in this function); did you mean 'FEC_ECR_SLEEP'?
>     2758 |  writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
>          |                                 ^~~~~~~~~~~~~
>    arch/m68k/include/asm/io_no.h:25:66: note: in definition of macro '__raw_writel'
>       25 | #define __raw_writel(b, addr) (void)((*(__force volatile u32 *) (addr)) = (b))
>          |                                                                  ^~~~
>    drivers/net/ethernet/freescale/fec_main.c:2758:2: note: in expansion of macro 'writel'
>     2758 |  writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
>          |  ^~~~~~
>    drivers/net/ethernet/freescale/fec_main.c:2758:33: note: each undeclared identifier is reported only once for each function it appears in
>     2758 |  writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
>          |                                 ^~~~~~~~~~~~~
>    arch/m68k/include/asm/io_no.h:25:66: note: in definition of macro '__raw_writel'
>       25 | #define __raw_writel(b, addr) (void)((*(__force volatile u32 *) (addr)) = (b))
>          |                                                                  ^~~~
>    drivers/net/ethernet/freescale/fec_main.c:2758:2: note: in expansion of macro 'writel'
>     2758 |  writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
>          |  ^~~~~~
> >> drivers/net/ethernet/freescale/fec_main.c:2759:32: error: 'FEC_LPI_WAKE' undeclared (first use in this function)
>     2759 |  writel(wake_cycle, fep->hwp + FEC_LPI_WAKE);
>          |                                ^~~~~~~~~~~~
>    arch/m68k/include/asm/io_no.h:25:66: note: in definition of macro '__raw_writel'
>       25 | #define __raw_writel(b, addr) (void)((*(__force volatile u32 *) (addr)) = (b))
>          |                                                                  ^~~~
>    drivers/net/ethernet/freescale/fec_main.c:2759:2: note: in expansion of macro 'writel'
>     2759 |  writel(wake_cycle, fep->hwp + FEC_LPI_WAKE);
>          |  ^~~~~~
> 
> [...]

Here is the summary with links:
  - [net-next] net: fec: fix build error for ARCH m68k
    https://git.kernel.org/netdev/net-next/c/e08d6d42b6f9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


