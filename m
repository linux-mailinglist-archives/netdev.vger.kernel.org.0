Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509CA41802C
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 09:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhIYH2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 03:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhIYH2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 03:28:15 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632F0C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 00:26:41 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s17so26517282edd.8
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 00:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AinfZCh8ac/vZYlLKdS7z3P/2YMWdXg/jnFO8/k/MCQ=;
        b=Qyngk2ocYg/gXjkx25lWsAlHH/Sw9tr9fJZRA1+Ep0kNCaFSBwDyoOwejIM6qyNxE3
         ezyn+MgkItaaL4j8nPHCzi8Ys/EZlmHzVgGMtWoUcZN2BoxrGZJRDpSaWq04Kzj3CJKa
         A9uaL5zju+w1uSCi6sCrnGi2yx3tOGT+W41Cqwc4kUWJsT9QvdHGWBMA2U0kc51afz8H
         XRv1Bixn8N5zRA3pV7T4RqTAlE7ejhFTlZPGSCm9vDEYgZ43K1kuPNPTdNvRlRnWl8PT
         pqwNtTgLpnIPlsrZlYc7+vyKDlbd9FHd6TCCA5/fDSINc8rRqCJ0V9uegduujMr/lJqq
         W2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AinfZCh8ac/vZYlLKdS7z3P/2YMWdXg/jnFO8/k/MCQ=;
        b=jpXy357x+mgJWSLTFTx1pTkVoEVj6t7lSNQt9q7EPzB6eiQjHYUdhq+Y7jWGi6eiA3
         uc5QpEj/29223MCzANHGCjno9BAUZlhlJctqY0G04HYwEIMITmjlwc6Hn+Ltqgw4nGJk
         Js/3NS5wTxbDVOSkkuV5kZcg1K4K7MpDrU6v0pPcYc4qj718DDI+EmRmEaOVLWFfAC0T
         sTpDSuMcW4mHWWLz1Fm/4vB9MPeKp/2SyNJq5/sQsbBZbgBiu2A5LA/zxfqBJauRbKHd
         TKI1ZzV4SacMpaDcWNqVequ/nCoXZypHDqt1EhL1WduglJgD/guRQh7roaP94LE6qBoD
         dOAQ==
X-Gm-Message-State: AOAM531+gQvtzy4l7KL/zqWiKhwoQdmzujilI1OBmaVRl2TuC3qxYcxX
        h8rQEqXNPB8eZ/t4vbZ4TTVHPfPMti10Zw8zIrw=
X-Google-Smtp-Source: ABdhPJxagVNXWOX9dbijTKqdF8Lx9FBWMdOHDo5OrNF38NhuYz8OGNojd1NuUuKn1OjC5MoJcHhFPy9XT9bcYgR/kTM=
X-Received: by 2002:a05:6402:c96:: with SMTP id cm22mr9945745edb.314.1632554799690;
 Sat, 25 Sep 2021 00:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210925061037.4555-1-shjy180909@gmail.com>
In-Reply-To: <20210925061037.4555-1-shjy180909@gmail.com>
From:   =?UTF-8?B?7KeE7ISx7Z2s?= <shjy180909@gmail.com>
Date:   Sat, 25 Sep 2021 16:26:28 +0900
Message-ID: <CAJg10r+VkaF-5fUtAOZwMxWs-VgRvGFUOZ-8oftFD8k44yosJw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/3] check return value of rhashtable_init in
 mlx5e, ipv6, mac80211.
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, vladbu@nvidia.com,
        lariel@nvidia.com, cmi@nvidia.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021=EB=85=84 9=EC=9B=94 25=EC=9D=BC (=ED=86=A0) =EC=98=A4=ED=9B=84 3:10, M=
ichelleJin <shjy180909@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> When rhashtable_init() fails, it returns -EINVAL.
> However, since error return value of rhashtable_init is not checked,
> it can cause use of uninitialized pointers.
> So, fix unhandled errors of rhashtable_init.
> The three patches are essentially the same logic.
>
> v1->v2:
>  - change commit message
>  - fix possible memory leaks
> v2->v3:
>  - split patch into mlx5e, ipv6, mac80211.
>
> MichelleJin (3):
>   net/mlx5e: check return value of rhashtable_init
>   net: ipv6: check return value of rhashtable_init
>   net: mac80211: check return value of rhashtable_init
>
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 14 +++++++++++---
>  net/ipv6/ila/ila_xlat.c                            |  6 +++++-
>  net/ipv6/seg6.c                                    |  6 +++++-
>  net/ipv6/seg6_hmac.c                               |  6 +++++-
>  net/mac80211/mesh_pathtbl.c                        |  5 ++++-
>  5 files changed, 30 insertions(+), 7 deletions(-)
>
> --
> 2.25.1
>

There are new build warnings in net/ipv6/seg6.c.
I'll fix it and send v4 soon.

Thank you.
