Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044FB3157F4
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhBIUrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbhBIUg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:36:26 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733CDC0698DA
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 12:35:46 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id 100so12044268otg.3
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 12:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wL/jAZoWHnJS6Rr3x5OGh2VjUYScAixbdmrhlvekP/U=;
        b=QlOrcnUWGtMVwgPq2gZ9UO8Pn66HnJWnq8viGHMwudg1pcxwR8uuRcJ0ZshhLfyN2R
         R5E3JjIobeeI9kJ5+tCxEda8vgW6xwe3d6fjMVnS8s1owiMSlXvv8YZhWyz1yfX/jM7o
         e4UwwLZq1FNXgxXWse8MbrlGr7HZHMQh1wadoKGarU0G9ltE/wTzq8Os6GdvF+NAg3uE
         WKkSu5spEr8jg3xXnltMBoLbdYn6SEB+MZx0MeaGy8IKvuJY1BLGLk3wEDSnDolM9X8/
         ewcRfPgMY1Y9qAwaYxuqaHyp0B6PMzJsitvs3Wgi3PM/52WInmIOxUDWrOi+OoWoqpQu
         uXng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=wL/jAZoWHnJS6Rr3x5OGh2VjUYScAixbdmrhlvekP/U=;
        b=EONSxJAwEi1aviX4Sw24Doj1jjU02PWxeUZ7mAUlMKm7vCACDaaabmgoOIw5vxhME5
         LILrlZn3B1h+jkAg4bgEzlVpdCPjyT8AS9SoRILpUC1zbF07zLWB1HbWTh9FQWx9MB44
         GpmVjzea6j04PgcKGoiJWVhS0DMVcRuu5Zt+unr5dIeTXlrJiAVMKSH4NMp9OwWziOqA
         IpTV7dALOVAIPo6rk0so6o5cwWVXUDnYuzICjCYjCTpwdROLKyyM2qZjM34UBTC1UZAU
         qbjhIh9So3/mM5Yv44elxWOZwFZ+9be0xnn5TPq6VKAawl1XRXWYOAyGtFsQVMbvwSlG
         a08w==
X-Gm-Message-State: AOAM533Uz5UD869QgD6rEL/3X9JKS3CPgFLxl6eNxHEdBLWvakY7L89p
        LWRMDka4Wi0+vqlgObD0mpo=
X-Google-Smtp-Source: ABdhPJyBkEfxVhQt5OpphCgFUctqbH/XwHZ/msnyPLnh76NWnAxH+JQL3tcstxdQkcCwp8pQtF5fSw==
X-Received: by 2002:a9d:6047:: with SMTP id v7mr17216593otj.55.1612902945925;
        Tue, 09 Feb 2021 12:35:45 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c26sm2116408otl.80.2021.02.09.12.35.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Feb 2021 12:35:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 9 Feb 2021 12:35:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V2 12/17] net/mlx5e: Extract tc tunnel encap/decap
 code to dedicated file
Message-ID: <20210209203543.GA171626@roeck-us.net>
References: <20210206050240.48410-1-saeed@kernel.org>
 <20210206050240.48410-13-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210206050240.48410-13-saeed@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 09:02:35PM -0800, Saeed Mahameed wrote:
> From: Vlad Buslov <vladbu@nvidia.com>
> 
> Following patches in series extend the extracted code with routing
> infrastructure. To improve code modularity created a dedicated
> tc_tun_encap.c source file and move encap/decap related code to the new
> file. Export code that is used by both regular TC code and encap/decap code
> into tc_priv.h (new header intended to be used only by TC module). Rename
> some exported functions by adding "mlx5e_" prefix to their names.
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

When building s390:defconfig, this patch results in:

In file included from drivers/net/ethernet/mellanox/mlx5/core/en_tc.h:40,
                 from drivers/net/ethernet/mellanox/mlx5/core/en_main.c:45:
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h:24:29: error: field 'match_level' has incomplete type

Bisect log attached.

Guenter

---
# bad: [a4bfd8d46ac357c12529e4eebb6c89502b03ecc9] Add linux-next specific files for 20210209
# good: [92bf22614b21a2706f4993b278017e437f7785b3] Linux 5.11-rc7
git bisect start 'HEAD' 'v5.11-rc7'
# bad: [a8eb921ba7e8e77d994a1c6c69c8ef08456ecf53] Merge remote-tracking branch 'crypto/master'
git bisect bad a8eb921ba7e8e77d994a1c6c69c8ef08456ecf53
# good: [b68df186dae8ae890df08059bb068b78252b053a] Merge remote-tracking branch 'hid/for-next'
git bisect good b68df186dae8ae890df08059bb068b78252b053a
# good: [1299616023a0db19be4ff5588db4fb61d8cd51f9] Merge tag 'mt76-for-kvalo-2021-01-29' of https://github.com/nbd168/wireless
git bisect good 1299616023a0db19be4ff5588db4fb61d8cd51f9
# good: [db9deabba7a9a6fded1aeda51dda1ce9b78f0711] Merge remote-tracking branch 'v4l-dvb-next/master'
git bisect good db9deabba7a9a6fded1aeda51dda1ce9b78f0711
# good: [ed19e2282476b1e0dc01c67fc19010ab791a7a46] Merge remote-tracking branch 'rdma/for-next'
git bisect good ed19e2282476b1e0dc01c67fc19010ab791a7a46
# bad: [ae3b49168f93b4432b852ca6f2f7323fead45e8d] Merge remote-tracking branch 'bluetooth/master'
git bisect bad ae3b49168f93b4432b852ca6f2f7323fead45e8d
# good: [215cb7d3823e798de327e3232e396434fab84f42] bpf/benchs/bench_ringbufs: Remove unneeded semicolon
git bisect good 215cb7d3823e798de327e3232e396434fab84f42
# good: [de71a6cb4bf24d8993b9ca90d1ddb131b60251a1] Bluetooth: btusb: Fix memory leak in btusb_mtk_wmt_recv
git bisect good de71a6cb4bf24d8993b9ca90d1ddb131b60251a1
# bad: [8914add2c9e5518f6a864936658bba5752510b39] net/mlx5e: Handle FIB events to update tunnel endpoint device
git bisect bad 8914add2c9e5518f6a864936658bba5752510b39
# good: [4ad9116c84ed3243f7b706f07646a995f3bca502] net/mlx5e: Remove redundant match on tunnel destination mac
git bisect good 4ad9116c84ed3243f7b706f07646a995f3bca502
# bad: [0d9f96471493d5483d116c137693f03604332a04] net/mlx5e: Extract tc tunnel encap/decap code to dedicated file
git bisect bad 0d9f96471493d5483d116c137693f03604332a04
# good: [48d216e5596a58e3cfa6d4548343f982c5921b79] net/mlx5e: Refactor reg_c1 usage
git bisect good 48d216e5596a58e3cfa6d4548343f982c5921b79
# good: [8e404fefa58b6138531e3d4b5647ee79f75ae9a8] net/mlx5e: Match recirculated packet miss in slow table using reg_c1
git bisect good 8e404fefa58b6138531e3d4b5647ee79f75ae9a8
# first bad commit: [0d9f96471493d5483d116c137693f03604332a04] net/mlx5e: Extract tc tunnel encap/decap code to dedicated file

