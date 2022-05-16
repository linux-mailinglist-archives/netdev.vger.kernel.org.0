Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E80528318
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243077AbiEPLXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243079AbiEPLXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:23:48 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38C2387A0;
        Mon, 16 May 2022 04:23:45 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id i19so27956073eja.11;
        Mon, 16 May 2022 04:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nhUzmjzE+Ld/75gG+YZjiVfrWe7MmqeXKrsUUQnnt4g=;
        b=ZhVkMkf5wEDo/mhny8h+Jxccdaip2rI5CAKsY7PbST5PU9grnIuCBUyIX0+0Kpt1RC
         6sRwwiecuYqrMwXL+Wg/hCQhETU00TeXV83sH645QLTqk5nt58V8cp9MzgiMY5bUZ3I0
         6ZswfMlC8AtuY8TuMm9HpFOeNRxBV58G5DIP6iy8HpN2RydA0lgQEMyOjIKniTUKcmhB
         M19qqwVPujk+JudyoC7NFShgJRk1AuNs7JWZeWsvA+y3vbTEgRkWBuqbdyQFzK48k2GN
         f1K2v/W/dGaAIvlU/5qpPmGZ+apURQK2EWpeK1NIflGTBStdd5+907UZxCQKVA3vcBHb
         chzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nhUzmjzE+Ld/75gG+YZjiVfrWe7MmqeXKrsUUQnnt4g=;
        b=VClYH/HJVCe5wi6xdyxgY253nxN0t1E2zfN4qXQtn0uEHKVub7bQ/fjDaCMiqrTYHM
         JuOTV/exoplY1TzXTMaL0HvPsT54lAb14G8pzsZs54IW4fIXJ4z/k5BErD88Wfy6MU5W
         yHp33bwh3wDQhFJf8RAm7n5RyRtOdJRvNwjeCZzDeHR1pgSpoDgF/2Kq9HL40ySoeSJ5
         eBjBbd8Pnl2tH9cPMUU1rFq+z+xjd/5Pk8Knp/eFRCzms7RR/stpSMFkxSxNi3WmGl43
         YFI7ujdzxBTzP+S54BPsuuR+wUjBCGHRRcJj6oYS42JUgdHhGhgzC13VVQaTz39B2kn+
         D4og==
X-Gm-Message-State: AOAM530d3u+N6DxEYYaAto5zutl7XQERZ9yEiEctO0WzmB1Cx2yu8vmD
        X86Mknr4mgszSMjIiTyLkj0=
X-Google-Smtp-Source: ABdhPJxn1SptoPndCbmgwQUMnhSbKe0CRgG2JqNDDxeZrSTKf2y4xV3+zlpd/qeMIhcRH2e4gsB5aA==
X-Received: by 2002:a17:907:8a21:b0:6f4:d2e5:4d17 with SMTP id sc33-20020a1709078a2100b006f4d2e54d17mr15081705ejc.196.1652700224513;
        Mon, 16 May 2022 04:23:44 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id j13-20020a508a8d000000b0042617ba63cbsm4972969edj.85.2022.05.16.04.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 04:23:43 -0700 (PDT)
Date:   Mon, 16 May 2022 14:23:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC Patch net-next v2 5/9] net: dsa: microchip: move struct
 mib_names to ksz_chip_data
Message-ID: <20220516112342.5euhhzohvpziwwxe@skbuf>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-6-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513102219.30399-6-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:52:15PM +0530, Arun Ramadoss wrote:
> The ksz88xx family has one set of mib_names. The ksz87xx, ksz9477,
> LAN937x based switches has one set of mib_names. In order to remove
> redundant declaration, moved the struct mib_names to ksz_chip_data
> structure. And allocated the mib memory in switch_register instead of
> individual switch_init function.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  static int ksz9477_switch_init(struct ksz_device *dev)
>  {
> -	int i;
> -
>  	dev->ds->ops = &ksz9477_switch_ops;
>  
>  	dev->port_mask = (1 << dev->info->port_cnt) - 1;
>  
> -	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
> -	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
> -
> -	for (i = 0; i < dev->info->port_cnt; i++) {
> -		spin_lock_init(&dev->ports[i].mib.stats64_lock);
> -		mutex_init(&dev->ports[i].mib.cnt_mutex);
> -		dev->ports[i].mib.counters =
> -			devm_kzalloc(dev->dev,
> -				     sizeof(u64) *
> -				     (TOTAL_SWITCH_COUNTER_NUM + 1),
> -				     GFP_KERNEL);
> -		if (!dev->ports[i].mib.counters)
> -			return -ENOMEM;
> -	}
> -

This fixes the NULL pointer dereference on probe that was introduced in
the previous patch, but please make sure that this does not happen in
the first place, for bisectability purposes.

>  	return 0;
>  }
