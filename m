Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483CB645AC5
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiLGNXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiLGNXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:23:40 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E08421A9;
        Wed,  7 Dec 2022 05:23:38 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id t17so13995103eju.1;
        Wed, 07 Dec 2022 05:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VK4oX/zlkDf1Sawu/Y3PEllktpoDkp3XrcBiUizrnfE=;
        b=BQXt8tbxEISTzk4tvDnUXevwzxf8kyTmV+G3AwWllACrMHNBNxgOujQrnwRhBY4SBA
         9evguVLnCzaOcQMmApuT1GzbPR55M1zsDMSsLOdyB4S1IZQTy1N9tcOr4SWVLCHOK7z0
         adzfrOosp01BpE08C2ZstemQyr9taEqfmkwBiyL570jaEQ1i3ZFGK94ZgJc6/Fk0cizv
         TmhR402UgHlZeAgb8C/L64cDYNEmx210LsleK7YV9D/G4lS5J2k+sP/vGrTxtizSw/MY
         8yOQlgmdgGJpux3ScytALgyhL/aHbmiu0M3BId55eRaaWxkAht7fdx9223SQNpJAKP1D
         C5DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VK4oX/zlkDf1Sawu/Y3PEllktpoDkp3XrcBiUizrnfE=;
        b=Amohtw3DdtecvPHqVOXcxGkNGICEqFg93gU8j6maYz+wXyJSxQ2cy5q19tuLwqAkB5
         SD5Yc4xOQ+1MG6bbmDhupwzD3jdfXJaVxp2XLQ9nbC+BKUNlEW6ksgCFW+hLY5IEd94C
         TNelRI9jEItGSv0mFvxAXvjsxApohFk9K91m7c5EbxNjDqLxcn+5emuys+McF1BIYg9Y
         QpOzipDNt2LceLQrGzqCd/iEyGLTo1cedrHkrRpJQz9Khj3nO1/UK2iekN3O8AP2uNKe
         ZM+vKUJ4AmoYyE4tUcwUTrsZLyQ49njchuEBdHmVEV6Vjn1FD73gwzzxGU7q9HoVaE9E
         jFvQ==
X-Gm-Message-State: ANoB5pkur19vDxYqSuh4OIBugO2sW+KkKcILoU29DBMlda1LS+eVZYmx
        nuwyxuNd9G2CCTnIFa3RkqQ=
X-Google-Smtp-Source: AA0mqf6OP9dplKn8vk3d31E1D/DuZQneONai1DCAFEVM3G/XqrLE0T5AJ40R8zx6Uo0RZl+mLVkEhg==
X-Received: by 2002:a17:906:b19a:b0:7ad:bc7e:3ffd with SMTP id w26-20020a170906b19a00b007adbc7e3ffdmr388025ejy.42.1670419417276;
        Wed, 07 Dec 2022 05:23:37 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id i16-20020a170906251000b007c10fe64c5dsm1693265ejb.86.2022.12.07.05.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:23:36 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:23:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC Patch net-next 1/5] net: dsa: microchip: add rmon grouping
 for ethtool statistics
Message-ID: <20221207132333.tw3ztzfgo7i3cf5x@skbuf>
References: <20221130132902.2984580-1-rakesh.sankaranarayanan@microchip.com>
 <20221130132902.2984580-2-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130132902.2984580-2-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 06:58:58PM +0530, Rakesh Sankaranarayanan wrote:
> diff --git a/drivers/net/dsa/microchip/ksz_ethtool.c b/drivers/net/dsa/microchip/ksz_ethtool.c
> new file mode 100644
> index 000000000000..7e1f1b4d1e98
> --- /dev/null
> +++ b/drivers/net/dsa/microchip/ksz_ethtool.c
> @@ -0,0 +1,178 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Microchip KSZ series ethtool statistics
> + *
> + * Copyright (C) 2022 Microchip Technology Inc.
> + */
> +
> +#include "ksz_common.h"
> +#include "ksz_ethtool.h"
> +
> +enum ksz8_mib_entry {
> +	ksz8_rx,
> +	ksz8_rx_hi,
> +	ksz8_rx_undersize,
> +	ksz8_rx_fragments,
> +	ksz8_rx_oversize,
> +	ksz8_rx_jabbers,
> +	ksz8_rx_symbol_err,
> +	ksz8_rx_crc_err,
> +	ksz8_rx_align_err,
> +	ksz8_rx_mac_ctrl,
> +	ksz8_rx_pause,
> +	ksz8_rx_bcast,
> +	ksz8_rx_mcast,
> +	ksz8_rx_ucast,
> +	ksz8_rx_64_or_less,
> +	ksz8_rx_65_127,
> +	ksz8_rx_128_255,
> +	ksz8_rx_256_511,
> +	ksz8_rx_512_1023,
> +	ksz8_rx_1024_1522,
> +	ksz8_tx,
> +	ksz8_tx_hi,
> +	ksz8_tx_late_col,
> +	ksz8_tx_pause,
> +	ksz8_tx_bcast,
> +	ksz8_tx_mcast,
> +	ksz8_tx_ucast,
> +	ksz8_tx_deferred,
> +	ksz8_tx_total_col,
> +	ksz8_tx_exc_col,
> +	ksz8_tx_single_col,
> +	ksz8_tx_mult_col,
> +	ksz8_rx_discards = 0x100,
> +	ksz8_tx_discards,
> +};
> +
> +enum ksz9477_mib_entry {
> +	ksz9477_rx_hi,
> +	ksz9477_rx_undersize,
> +	ksz9477_rx_fragments,
> +	ksz9477_rx_oversize,
> +	ksz9477_rx_jabbers,
> +	ksz9477_rx_symbol_err,
> +	ksz9477_rx_crc_err,
> +	ksz9477_rx_align_err,
> +	ksz9477_rx_mac_ctrl,
> +	ksz9477_rx_pause,
> +	ksz9477_rx_bcast,
> +	ksz9477_rx_mcast,
> +	ksz9477_rx_ucast,
> +	ksz9477_rx_64_or_less,
> +	ksz9477_rx_65_127,
> +	ksz9477_rx_128_255,
> +	ksz9477_rx_256_511,
> +	ksz9477_rx_512_1023,
> +	ksz9477_rx_1024_1522,
> +	ksz9477_rx_1523_2000,
> +	ksz9477_rx_2001,
> +	ksz9477_tx_hi,
> +	ksz9477_tx_late_col,
> +	ksz9477_tx_pause,
> +	ksz9477_tx_bcast,
> +	ksz9477_tx_mcast,
> +	ksz9477_tx_ucast,
> +	ksz9477_tx_deferred,
> +	ksz9477_tx_total_col,
> +	ksz9477_tx_exc_col,
> +	ksz9477_tx_single_col,
> +	ksz9477_tx_mult_col,
> +	ksz9477_rx_total = 0x80,
> +	ksz9477_tx_total,
> +	ksz9477_rx_discards,
> +	ksz9477_tx_discards,
> +};

We usually name constants using all capitals.

Can you do something to reuse the ksz_mib_names structures?
