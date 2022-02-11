Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C484B2BAC
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 18:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352060AbiBKRYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 12:24:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352045AbiBKRYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 12:24:44 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5321FC
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:24:43 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id j2so27121622ybu.0
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1f5nHZJ9uVD6/I7NM/ovxfltUAK5E77rKDDs7ab4Xic=;
        b=hdu4UcvLhoPoj1+nnYpidzG5ybt+SATEc36EIA2F0rim60MDWLZbsC80UkLLFmgXby
         6I7VzLYSiW5Hapfkc4bxg/0zMn3VeyGHa9/SvKDExmKANfuJfsNd6je7gRTcEAM/wO2E
         5k/ztc0BzeVqRc/H/3YbHOxS3vgNm34Mbjg/TDoA/kaFo5G8eyLRjuaGUtF9h0KcMX9m
         fEuLqzzSDlJ0RCRESc6rqHoVWILYakTV0dwZXWrP4312DRfINDk2pgn0Fu7FKQ3rF7x0
         25wJIFy+QCKBFG07xvaYmccVexj7YtoX+pqqDBPrxZ6At0yiOQT+AwCoJmqV3vTfAtPA
         QcMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1f5nHZJ9uVD6/I7NM/ovxfltUAK5E77rKDDs7ab4Xic=;
        b=afzqmTMoEErgSNBv9/bNymlzgILf54AuOXa5TURne0lQ54r6DDNDdLNgJzF/FoSuJ/
         hDPgtHowZYU0bMnqxL1l3MgvEzv9xdNaXd3Bg8MFapZ3AiGaXyGpNn6Ft/r1Ehw3cBTg
         Aw7TOp1PVxnttaRqpfMn6TThE1VL/0iHYL4n+QH52LcVlg1gv3doi/JO2xyV6xdoAiVZ
         53Qm7zoIILRa+JFng+L60dLkW/5CHtyJSM2OV3UfpZgdJTkO/HSew8sD4/S1ggE/+0jI
         nob+tLUoJAe2Fv4gI+BUNo8qKxIALklyuICM6dQIsfbhkBbfvYa2FSLsj5NYKHfn1ROt
         1YhA==
X-Gm-Message-State: AOAM532+T+aTXmokhn3/qI7Bdss8OEBTNK7/mLLHajQMnACqpKXcb8Bx
        Eqrwe0+nUjqdzr+zU/utL7CQr3Y7dHCLYNG5uDyhhg==
X-Google-Smtp-Source: ABdhPJxmj9cstWH2lKAb2aiO3OuQbmZ8A5jPVYo/c8dto0k13vNXhpRUa1YxFuZZi/PUuAIxg/HTlYAJuXQSAWRKgDo=
X-Received: by 2002:a25:8885:: with SMTP id d5mr2268605ybl.383.1644600281921;
 Fri, 11 Feb 2022 09:24:41 -0800 (PST)
MIME-Version: 1.0
References: <20220211164026.409225-1-ribalda@chromium.org>
In-Reply-To: <20220211164026.409225-1-ribalda@chromium.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Feb 2022 09:24:30 -0800
Message-ID: <CANn89i+2idhm3wpGO79RHdCYMfYuKURvBaWmoXmYxBwj5z59yg@mail.gmail.com>
Subject: Re: [PATCH] net: Fix build when CONFIG_INET is not enabled
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 8:40 AM Ricardo Ribalda <ribalda@chromium.org> wrote:
>
> If the kernel is configured with CONFIG_NET, but without CONFIG_INET we
> get the following error when building:
>
> sock.c:(.text+0x4c17): undefined reference to `__sk_defer_free_flush'
>
> Lets move __sk_defer_free_flush to sock.c
>

deja vu ?

commit 48cec899e357cfb92d022a9c0df6bbe72a7f6951
Author: Gal Pressman <gal@nvidia.com>
Date:   Thu Jan 20 14:34:40 2022 +0200

    tcp: Add a stub for sk_defer_free_flush()

    When compiling the kernel with CONFIG_INET disabled, the
    sk_defer_free_flush() should be defined as a nop.

    This resolves the following compilation error:
      ld: net/core/sock.o: in function `sk_defer_free_flush':
      ./include/net/tcp.h:1378: undefined reference to `__sk_defer_free_flush'

    Fixes: 79074a72d335 ("net: Flush deferred skb free on socket destroy")
    Reported-by: kernel test robot <lkp@intel.com>
    Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
    Signed-off-by: Gal Pressman <gal@nvidia.com>
    Reviewed-by: Eric Dumazet <edumazet@google.com>
    Link: https://lore.kernel.org/r/20220120123440.9088-1-gal@nvidia.com
    Signed-off-by: Jakub Kicinski <kuba@kernel.org>
