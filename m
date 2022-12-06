Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E226A6449F2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 18:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbiLFRIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 12:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235449AbiLFRIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 12:08:06 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73ABEDF77;
        Tue,  6 Dec 2022 09:08:05 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id m18so6229908eji.5;
        Tue, 06 Dec 2022 09:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nQy1QBUpeuNTaLoaBP6NQNUp97yCKwC841vY4JbVEXo=;
        b=HnsnVe7w9HTT6ViTvbLtHAAdgPPKrdbPTAt5BDC0X0GJab0VhwQkwxEG4+QOwlyV55
         hEds2StZunG6a3uGms2WiK0UHrlEC/a4Us/f3QLF0292PqgHBP9rzLhISJrNGnqBLI2f
         6EjdZfE+BwI+e9kETZ5Ju7k6zxnrgeK87gkW9sz+hcz1PW9JxCUdoPIYX9w4r/dGMOV8
         VuBDVNV3dej5OUq3gzPULxTrpCiHpjN/QKhn4/WQbLO/C5kC3Ex2lgXyxAs+cRQm090k
         POF/bU9lFHNLqc8R90QTqliGeNT0wPfzz80jEKrJWvohJKMkh4eKnoFx0V1BoRNkBayR
         vbcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQy1QBUpeuNTaLoaBP6NQNUp97yCKwC841vY4JbVEXo=;
        b=gXcfTZWPEM+LsHw6GSI3b2pEhPDFYALXPBgGlihNA7CEJ+dbU/0HAlPZ3lWdvZmEPF
         eBlMV0PBYXhxHaQS9t/ahG12iu7UxjzJwHgaaMMyeMMx5K37RCFeqkVKoKY7f8U0PQoV
         6kT/Wlxh+OFcQsM/nNNeGCXL6LhWMFH41TMsI5UHEAhTUcbfCCltEcqVTeilpB0UpTbv
         rDfikYnG5jZGI/ysO/vy/t371BRmST2VkCzyZHfNwzi7Cjo0Eqt+TZ2JRXie9npwr0Wx
         I+Iz0XNgTJUtvijBIZ96PVZDKNXwZ3gNGLT/5Vx2jXwweNJIoo0v3cIHoDHcN631t4Mr
         wbJA==
X-Gm-Message-State: ANoB5pkj+MVg3cbGGMsZKkPiIrrP52hsdo1NRclvkHQAysDy02gHMEJ1
        lhYWrhyl6I1ndFW7oJMgamL2HZpK2j/irg==
X-Google-Smtp-Source: AA0mqf5akfdAaaDyOIT8vkmO83FPxEvQkhKHvl/QSwuMbZSYFwgEZmjn4jZj2Bc3DwmIYpUDBMeZEw==
X-Received: by 2002:a17:907:d40e:b0:7bb:f10c:9282 with SMTP id vi14-20020a170907d40e00b007bbf10c9282mr13017454ejc.325.1670346483982;
        Tue, 06 Dec 2022 09:08:03 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id gi20-20020a1709070c9400b0077d6f628e14sm7619800ejc.83.2022.12.06.09.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:08:03 -0800 (PST)
Date:   Tue, 6 Dec 2022 19:08:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: add stats64 support
 for ksz8 series of switches
Message-ID: <20221206170801.othuifyrm3qrz7ub@skbuf>
References: <20221205052904.2834962-1-o.rempel@pengutronix.de>
 <20221205052904.2834962-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205052904.2834962-1-o.rempel@pengutronix.de>
 <20221205052904.2834962-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 06:29:04AM +0100, Oleksij Rempel wrote:
> +void ksz88xx_r_mib_stats64(struct ksz_device *dev, int port)
> +{
> +	struct ethtool_pause_stats *pstats;
> +	struct rtnl_link_stats64 *stats;
> +	struct ksz88xx_stats_raw *raw;
> +	struct ksz_port_mib *mib;
> +
> +	mib = &dev->ports[port].mib;
> +	stats = &mib->stats64;
> +	pstats = &mib->pause_stats;
> +	raw = (struct ksz88xx_stats_raw *)mib->counters;
> +
> +	spin_lock(&mib->stats64_lock);
> +
> +	stats->rx_packets = raw->rx_bcast + raw->rx_mcast + raw->rx_ucast +
> +		raw->rx_pause;
> +	stats->tx_packets = raw->tx_bcast + raw->tx_mcast + raw->tx_ucast +
> +		raw->tx_pause;
> +
> +	/* HW counters are counting bytes + FCS which is not acceptable
> +	 * for rtnl_link_stats64 interface
> +	 */
> +	stats->rx_bytes = raw->rx + raw->rx_hi - stats->rx_packets * ETH_FCS_LEN;
> +	stats->tx_bytes = raw->tx + raw->tx_hi - stats->tx_packets * ETH_FCS_LEN;

What are rx_hi, tx_hi compared to rx, tx?

> +
> +	stats->rx_length_errors = raw->rx_undersize + raw->rx_fragments +
> +		raw->rx_oversize;
> +
> +	stats->rx_crc_errors = raw->rx_crc_err;
> +	stats->rx_frame_errors = raw->rx_align_err;
> +	stats->rx_dropped = raw->rx_discards;
> +	stats->rx_errors = stats->rx_length_errors + stats->rx_crc_errors +
> +		stats->rx_frame_errors  + stats->rx_dropped;
> +
> +	stats->tx_window_errors = raw->tx_late_col;
> +	stats->tx_fifo_errors = raw->tx_discards;
> +	stats->tx_aborted_errors = raw->tx_exc_col;
> +	stats->tx_errors = stats->tx_window_errors + stats->tx_fifo_errors +
> +		stats->tx_aborted_errors;
> +
> +	stats->multicast = raw->rx_mcast;
> +	stats->collisions = raw->tx_total_col;
> +
> +	pstats->tx_pause_frames = raw->tx_pause;
> +	pstats->rx_pause_frames = raw->rx_pause;

FWIW, ksz_get_pause_stats() can sleep, just ksz_get_stats64() can't. So
the pause stats don't need to be periodically read (unless you want to
do that to prevent 32-bit overflows).

> +
> +	spin_unlock(&mib->stats64_lock);
> +}
