Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9733813D7
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhENWld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234014AbhENWl3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:41:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 488D761454;
        Fri, 14 May 2021 22:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621032016;
        bh=Z2sRGaZBOglV6PySFYB6cWIU4v+GkoZfpx5wabpLkhk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lRcWe/CY9OGURS6iKLoEyCVKqdEp05H/nmwGgICxYsk/aZC5xFNRjet67vLrlkOhb
         7NzOCbQoSv+jIGIqcOEn1gpKQhwctZMUmXo32beIT4yNLwd7ny6CVRAxxMltlNjGyK
         ftwWBKu0i3xJ/MwfHcgTUreKd/dIXWNm+EpQiebHFB8loTYyTWMgi4qOVnJ4pYLmNx
         jyObaupBggDJeRgJu4OTmKva/fmhaEFoyCnq9J+fULJxb7AWwWvGQtlZFdNa2L7GBp
         vFUJaDH6ZPHrmTDVFvmSzCLJXbWkdoluLz425qB3WNWbPz2261DBN+H9XcYXb7ygum
         0WWDUJviT7tkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3A84160981;
        Fri, 14 May 2021 22:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 00/25] Multiple improvement to qca8k stability
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103201623.13732.1150658001864560628.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:40:16 +0000
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 14 May 2021 22:59:50 +0200 you wrote:
> Currently qca8337 switch are widely used on ipq8064 based router.
> On these particular router it was notice a very unstable switch with
> port not link detected as link with unknown speed, port dropping
> randomly and general unreliability. Lots of testing and comparison
> between this dsa driver and the original qsdk driver showed lack of some
> additional delay and values. A main difference arised from the original
> driver and the dsa one. The original driver didn't use MASTER regs to
> read phy status and the dedicated mdio driver worked correctly. Now that
> the dsa driver actually use these regs, it was found that these special
> read/write operation required mutual exclusion to normal
> qca8k_read/write operation. The add of mutex for these operation fixed
> the random port dropping and now only the actual linked port randomly
> dropped. Adding additional delay for set_page operation and fixing a bug
> in the mdio dedicated driver fixed also this problem. The current driver
> requires also more time to apply vlan switch. All of these changes and
> tweak permit a now very stable and reliable dsa driver and 0 port
> dropping. This series is currently tested by at least 5 user with
> different routers and all reports positive results and no problems.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,01/25] net: dsa: qca8k: change simple print to dev variant
    https://git.kernel.org/netdev/net-next/c/5d9e068402dc
  - [net-next,v6,02/25] net: dsa: qca8k: use iopoll macro for qca8k_busy_wait
    https://git.kernel.org/netdev/net-next/c/2ad255f2faaf
  - [net-next,v6,03/25] net: dsa: qca8k: improve qca8k read/write/rmw bus access
    https://git.kernel.org/netdev/net-next/c/504bf6593182
  - [net-next,v6,04/25] net: dsa: qca8k: handle qca8k_set_page errors
    https://git.kernel.org/netdev/net-next/c/ba5707ec58cf
  - [net-next,v6,05/25] net: dsa: qca8k: handle error with qca8k_read operation
    https://git.kernel.org/netdev/net-next/c/028f5f8ef44f
  - [net-next,v6,06/25] net: dsa: qca8k: handle error with qca8k_write operation
    https://git.kernel.org/netdev/net-next/c/d7805757c75c
  - [net-next,v6,07/25] net: dsa: qca8k: handle error with qca8k_rmw operation
    https://git.kernel.org/netdev/net-next/c/aaf421425cbd
  - [net-next,v6,08/25] net: dsa: qca8k: handle error from qca8k_busy_wait
    https://git.kernel.org/netdev/net-next/c/b7c818d19492
  - [net-next,v6,09/25] net: dsa: qca8k: add support for qca8327 switch
    https://git.kernel.org/netdev/net-next/c/6e82a457e062
  - [net-next,v6,10/25] devicetree: net: dsa: qca8k: Document new compatible qca8327
    https://git.kernel.org/netdev/net-next/c/227a9ffc1bc7
  - [net-next,v6,11/25] net: dsa: qca8k: add priority tweak to qca8337 switch
    https://git.kernel.org/netdev/net-next/c/83a3ceb39b24
  - [net-next,v6,12/25] net: dsa: qca8k: limit port5 delay to qca8337
    https://git.kernel.org/netdev/net-next/c/5bf9ff3b9fb5
  - [net-next,v6,13/25] net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
    https://git.kernel.org/netdev/net-next/c/0fc57e4b5e39
  - [net-next,v6,14/25] net: dsa: qca8k: add support for switch rev
    https://git.kernel.org/netdev/net-next/c/95ffeaf18b3b
  - [net-next,v6,15/25] net: dsa: qca8k: add ethernet-ports fallback to setup_mdio_bus
    https://git.kernel.org/netdev/net-next/c/1ee0591a1093
  - [net-next,v6,16/25] net: dsa: qca8k: make rgmii delay configurable
    https://git.kernel.org/netdev/net-next/c/e4b9977cee15
  - [net-next,v6,17/25] net: dsa: qca8k: clear MASTER_EN after phy read/write
    https://git.kernel.org/netdev/net-next/c/63c33bbfeb68
  - [net-next,v6,18/25] net: dsa: qca8k: dsa: qca8k: protect MASTER busy_wait with mdio mutex
    https://git.kernel.org/netdev/net-next/c/60df02b6ea45
  - [net-next,v6,19/25] net: dsa: qca8k: enlarge mdio delay and timeout
    https://git.kernel.org/netdev/net-next/c/617960d72e93
  - [net-next,v6,20/25] net: dsa: qca8k: add support for internal phy and internal mdio
    https://git.kernel.org/netdev/net-next/c/759bafb8a322
  - [net-next,v6,21/25] devicetree: bindings: dsa: qca8k: Document internal mdio definition
    https://git.kernel.org/netdev/net-next/c/0c994a28e751
  - [net-next,v6,22/25] net: dsa: qca8k: improve internal mdio read/write bus access
    https://git.kernel.org/netdev/net-next/c/b7ebac354d54
  - [net-next,v6,23/25] net: dsa: qca8k: pass switch_revision info to phy dev_flags
    https://git.kernel.org/netdev/net-next/c/a46aec02bc06
  - [net-next,v6,24/25] net: phy: at803x: clean whitespace errors
    https://git.kernel.org/netdev/net-next/c/d0e13fd5626c
  - [net-next,v6,25/25] net: phy: add support for qca8k switch internal PHY in at803x
    https://git.kernel.org/netdev/net-next/c/272833b9b3b3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


