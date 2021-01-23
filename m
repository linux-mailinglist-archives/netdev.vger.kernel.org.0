Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062793012EB
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 05:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbhAWEA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 23:00:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbhAWEAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 23:00:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0489523B3E;
        Sat, 23 Jan 2021 04:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611374413;
        bh=iEhrcIZKkyq3zuL6PgORytauNw5HJAjuhrj3cKyNVJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BaczC1xitfhqmzIv7wZtTwyY6Pfv3ggpOi+9TCm2dvjX5NRXk2vCvMPuvckAiKMwI
         Kn+MloOzNHRy4VTf+IXlCQCc1Nq5fObVp14lq1qkWjVyUFTUnKC78C3tymy3Z6fLnf
         zpzaDRjYPbrsQi0CoKIdztws1P8p/qIle/ZwVCtPDjw9kLMSup06nEZx4aNU5EosjW
         WNMGoDqmjLPa38k4yTauRbqL0fPDXaYam31VnypleaGCx2aU/JCt+84WXmeNQE9sAG
         7QGxPsVtTOgH7/6EFiH8WJvjFxj7sG/HkDFZd80Uj9bXGweaELNPOTRIYDaFh67ZQq
         sCaYX/d5tmDhw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E2DBF61E44;
        Sat, 23 Jan 2021 04:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/14] net: bridge: multicast: add initial EHT
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161137441292.10014.1698354363160808184.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 04:00:12 +0000
References: <20210120145203.1109140-1-razor@blackwall.org>
In-Reply-To: <20210120145203.1109140-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 20 Jan 2021 16:51:49 +0200 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This set adds explicit host tracking support for IGMPv3/MLDv2. The
> already present per-port fast leave flag is used to enable it since that
> is the primary goal of EHT, to track a group and its S,Gs usage per-host
> and when left without any interested hosts delete them before the standard
> timers. The EHT code is pretty self-contained and not enabled by default.
> There is no new uAPI added, all of the functionality is currently hidden
> behind the fast leave flag. In the future that will change (more below).
> The host tracking uses two new sets per port group: one having an entry for
> each host which contains that host's view of the group (source list and
> filter mode), and one set which contains an entry for each source having
> an internal set which contains an entry for each host that has reported
> an interest for that source. RB trees are used for all sets so they're
> compact when not used and fast when we need to do lookups.
> To illustrate it:
>  [ bridge port group ]
>   ` [ host set (rb) ]
>    ` [ host entry with a list of sources and filter mode ]
>   ` [ source set (rb) ]
>    ` [ source entry ]
>     ` [ source host set (rb) ]
>      ` [ source host entry with a timer ]
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] net: bridge: multicast: rename src_size to addr_size
    https://git.kernel.org/netdev/net-next/c/9e10b9e65699
  - [net-next,02/14] net: bridge: multicast: pass host src address to IGMPv3/MLDv2 functions
    https://git.kernel.org/netdev/net-next/c/54bea7219641
  - [net-next,03/14] net: bridge: multicast: __grp_src_block_incl can modify pg
    https://git.kernel.org/netdev/net-next/c/0ad57c99e857
  - [net-next,04/14] net: bridge: multicast: calculate idx position without changing ptr
    https://git.kernel.org/netdev/net-next/c/e7cfcf2c18c5
  - [net-next,05/14] net: bridge: multicast: add EHT structures and definitions
    https://git.kernel.org/netdev/net-next/c/8f07b831197e
  - [net-next,06/14] net: bridge: multicast: add EHT host handling functions
    https://git.kernel.org/netdev/net-next/c/5b1632887930
  - [net-next,07/14] net: bridge: multicast: add EHT source set handling functions
    https://git.kernel.org/netdev/net-next/c/baa74d39ca39
  - [net-next,08/14] net: bridge: multicast: add EHT host delete function
    https://git.kernel.org/netdev/net-next/c/dba6b0a5ca21
  - [net-next,09/14] net: bridge: multicast: add EHT allow/block handling
    https://git.kernel.org/netdev/net-next/c/474ddb37fa3a
  - [net-next,10/14] net: bridge: multicast: add EHT include and exclude handling
    https://git.kernel.org/netdev/net-next/c/ddc255d993d8
  - [net-next,11/14] net: bridge: multicast: optimize TO_INCLUDE EHT timeouts
    https://git.kernel.org/netdev/net-next/c/b66bf55bbc1c
  - [net-next,12/14] net: bridge: multicast: add EHT host filter_mode handling
    https://git.kernel.org/netdev/net-next/c/c9739016a032
  - [net-next,13/14] net: bridge: multicast: handle block pg delete for all cases
    https://git.kernel.org/netdev/net-next/c/e87e4b5caa5d
  - [net-next,14/14] net: bridge: multicast: mark IGMPv3/MLDv2 fast-leave deletes
    https://git.kernel.org/netdev/net-next/c/d5a1022283c3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


