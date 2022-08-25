Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5725A0F9C
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241238AbiHYLwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241208AbiHYLwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:52:05 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E114622E
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:52:04 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id u24so13597913lji.0
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=2NvgUODXGl6fIcDUpmQL3eMz80MNlUuQMGmCrUuI82Q=;
        b=S4radL9jFmi1eUN6mst0Ebm2VN7maD1YrtQFzdQcsoo4ARwulK+QNZAcB3bVUwCIeR
         +Hpkv6xjx0JKi0sDP63ywO1J1nzMTTUJmwjUKWwb8ekYy4t7kEsNRaEe7vXSZ68dpM0U
         GiY0qgruznULZ7m7IrEO9DIf7O/AE5bmLF8vRnmrhZlewxJlHoX6GxeymP4sPF9709b7
         06PmCSuHkVw+4ZbAg6S7T32KPkg+txTFDIYj5HkXzoI2DUAFObqx3aauOw482PITwsRI
         JnBN7nUyKg3UjRZz6NKy1gEOyj9C2rkw+DJampeR8cvBjn4MYZVZcXNm/U8ofGqearrG
         akeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=2NvgUODXGl6fIcDUpmQL3eMz80MNlUuQMGmCrUuI82Q=;
        b=IpaJsoLMrZYwNIkVbo45F3iebnvOIx3iRnhJbmyY36C7VgF2G6+VehkzG9SAJ8P4er
         9flVLhkWn6hhk851VY9PgAB9LL2C/ZpKi3VVNQFF2MfXzuRj+DdZvZNq5BQwSDbXpE2q
         4TXWVdszOm3SygBPeCgek9puFV4hIQV6pmyNKwhoCVfQgcxhDyyHOaYYHc7klvSQliaY
         l5yqWxuGX2PqCLuP3V36laaDd0rJbucVsSMeHQzFVn7VPFM9PJluWChmDnkluekNQ9E+
         hOj2LPg8LzF6XTR6E5xjOY+9CCgZewfHUyIiyTnAuSN+BEP/gzlJmpv7bG29AIIf+9An
         5qfw==
X-Gm-Message-State: ACgBeo3/wHP6p3KWSjp6inynqDoHLN9RzghMPMXRgzs0+KNzdRuGxJR3
        tTWkySLqpDKRKyvGY1HUP/IWffm3fNBtbjAc/Q==
X-Google-Smtp-Source: AA6agR4WXYV3CRZbCsYD/zneLKl05co08eUaqPq2VeWBn+etOxraQScFZkDsyR7Z6LTvk2b88A0vdc3qTWGYTmUKdyI=
X-Received: by 2002:a2e:80d5:0:b0:261:dfc2:2367 with SMTP id
 r21-20020a2e80d5000000b00261dfc22367mr951956ljg.66.1661428322473; Thu, 25 Aug
 2022 04:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220825113645.212996-1-bigeasy@linutronix.de> <20220825113645.212996-2-bigeasy@linutronix.de>
In-Reply-To: <20220825113645.212996-2-bigeasy@linutronix.de>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 25 Aug 2022 06:51:59 -0500
Message-ID: <CAFSKS=Pes1XzvG0OkuR+KfOcBH0xwgWnZinSf9mExFjJ+2s3sw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: dsa: xrs700x: Use irqsave variant for u64
 stats update
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 6:36 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> xrs700x_read_port_counters() updates the stats from a worker using the
> u64_stats_update_begin() version. This is okay on 32-UP since on the
> reader side preemption is disabled.
> On 32bit-SMP the writer can be preempted by the reader at which point
> the reader will spin on the seqcount until writer continues and
> completes the update.
>
> Assigning the mib_mutex mutex to the underlying seqcount would ensure
> proper synchronisation. The API for that on the u64_stats_init() side
> isn't available. Since it is the only user, just use disable interrupts
> during the update.
>
> Use u64_stats_update_begin_irqsave() on the writer side to ensure an
> uninterrupted update.
>
> Fixes: ee00b24f32eb8 ("net: dsa: add Arrow SpeedChips XRS700x driver")
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: George McCollister <george.mccollister@gmail.com>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/net/dsa/xrs700x/xrs700x.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
> index 3887ed33c5fe2..fa622639d6401 100644
> --- a/drivers/net/dsa/xrs700x/xrs700x.c
> +++ b/drivers/net/dsa/xrs700x/xrs700x.c
> @@ -109,6 +109,7 @@ static void xrs700x_read_port_counters(struct xrs700x *priv, int port)
>  {
>         struct xrs700x_port *p = &priv->ports[port];
>         struct rtnl_link_stats64 stats;
> +       unsigned long flags;
>         int i;
>
>         memset(&stats, 0, sizeof(stats));
> @@ -138,9 +139,9 @@ static void xrs700x_read_port_counters(struct xrs700x *priv, int port)
>          */
>         stats.rx_packets += stats.multicast;
>
> -       u64_stats_update_begin(&p->syncp);
> +       flags = u64_stats_update_begin_irqsave(&p->syncp);
>         p->stats64 = stats;
> -       u64_stats_update_end(&p->syncp);
> +       u64_stats_update_end_irqrestore(&p->syncp, flags);
>
>         mutex_unlock(&p->mib_mutex);
>  }
> --
> 2.37.2
>

Acked-by: George McCollister <george.mccollister@gmail.com>

Thanks,
George
