Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB77E4BBC46
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237080AbiBRPf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 10:35:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237078AbiBRPf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:35:56 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7038F2B3191;
        Fri, 18 Feb 2022 07:35:39 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id w3so16141446edu.8;
        Fri, 18 Feb 2022 07:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HwZo0l9KKud/JY0Rj2cHSL0TvZU1bqU4sfROyBKdLzo=;
        b=ZG8NQeAKFSo3EiLwoYTln41ja4Mu8BmrYMiT5oQfYrNpuiiCzk3XnPAbt4RiXO6t8Y
         j7GGDN63ZYBF5zD1/oSbPEPegv5SZPPY5jnhsZhTRXkLTOjfmATXFq6kqQCv8rwgtuMm
         vKAdejkXH1SGsx3WK9hV0cU+7yP51fmNosJWiSyci9Ap2xilIG8xvfzjbqmyGl6T22PF
         KfqK8Gi165iQA2POg/m2Dcw9Lx4wrZ71zG9ElTs0iVTir4UqVDF1ad1iJMLl1ESabL63
         jPVzV8jVqzoTOHH9SWWjpWt3Em4Gt2QxKLawjftN/Ahp2j9LnfauqHt0v+cHq0hHsZAY
         iKcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HwZo0l9KKud/JY0Rj2cHSL0TvZU1bqU4sfROyBKdLzo=;
        b=HaQpqpFl8U+AG3Q0Mz1PjPFuLrAc4CjnFG0BM6UxDWL2wZnxGQcyikKetq2HD9jJIP
         6LtCFp1eY9jOuDD1pMnf6XNLpQ37OYkwwto0xiAITEwxfD4NWnbfhtV7YHVvEq2Arqsc
         u2SE/fdAw5Bh7ndUB08EJ5iSbyTl+NPWeBpc2C9mNO/R0pjLB70ilPkeBXv5vvnidSe7
         hVUvMZ3lV5wx+suD2CT/3SNcYkf9o9JNXsfG2wBCvOeX4WQTzJQIiNRVvLY48wTZ3ihL
         YpdfGY0uKdiI2MYEXJWCquMBcu1MWqeVqJMl9Clq8R/ekgUNDYimMvb5vp5a+ZVfU6Cq
         UjkQ==
X-Gm-Message-State: AOAM531/SSLOcacBkB5/imYcI2SDNiu2Zmd7A3WEx60Y4waJnzTt9k7L
        mFUGyBuREutlkb+eyt36NKY=
X-Google-Smtp-Source: ABdhPJz22wXdH9AtFsrdX/keA3yPRhVE1i5zhIObziRILrjhlm3AiXDabdVN7vND4mwuBM6RICMsRQ==
X-Received: by 2002:a50:9ea2:0:b0:409:5438:debf with SMTP id a31-20020a509ea2000000b004095438debfmr8733188edf.126.1645198537792;
        Fri, 18 Feb 2022 07:35:37 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id eo7sm4462163edb.97.2022.02.18.07.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 07:35:36 -0800 (PST)
Date:   Fri, 18 Feb 2022 17:35:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/1] net: dsa: microchip: ksz9477: export HW
 stats over stats64 interface
Message-ID: <20220218153535.optweu6jtzkerehe@skbuf>
References: <20220218121149.1430145-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218121149.1430145-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 01:11:49PM +0100, Oleksij Rempel wrote:
> +static void ksz9477_r_mib_stats64(struct ksz_device *dev, int port)
> +{
> +	struct rtnl_link_stats64 *stats;
> +	struct ksz9477_stats_raw raw;
> +	struct ksz_port_mib *mib;
> +
> +	mib = &dev->ports[port].mib;
> +	stats = &mib->stats64;
> +
> +	memcpy(&raw, mib->counters, sizeof(raw));

I don't think you need an on-stack copy of mib->counters. If you're
concerned about line length just make "raw" point to mib->counters.

> +
> +	spin_lock(&mib->stats64_lock);
> +
> +	stats->rx_packets = raw.rx_bcast + raw.rx_mcast + raw.rx_ucast;
> +	stats->tx_packets = raw.tx_bcast + raw.tx_mcast + raw.tx_ucast;
> +
> +	/* HW counters are counting bytes + FCS which is not acceptable
> +	 * for rtnl_link_stats64 interface
> +	 */
> +	stats->rx_bytes = raw.rx_total - stats->rx_packets * ETH_FCS_LEN;
> +	stats->tx_bytes = raw.tx_total - stats->tx_packets * ETH_FCS_LEN;
> +
> +	stats->rx_length_errors = raw.rx_undersize + raw.rx_fragments +
> +		raw.rx_oversize;
> +
> +	stats->rx_crc_errors = raw.rx_crc_err;
> +	stats->rx_frame_errors = raw.rx_align_err;
> +	stats->rx_dropped = raw.rx_discards;
> +	stats->rx_errors = stats->rx_length_errors + stats->rx_crc_errors +
> +		stats->rx_frame_errors  + stats->rx_dropped;
> +
> +	stats->tx_window_errors = raw.tx_late_col;
> +	stats->tx_fifo_errors = raw.tx_discards;
> +	stats->tx_aborted_errors = raw.tx_exc_col;
> +	stats->tx_errors = stats->tx_window_errors + stats->tx_fifo_errors +
> +		stats->tx_aborted_errors;
> +
> +	stats->multicast = raw.rx_mcast;
> +	stats->collisions = raw.tx_total_col;
> +
> +	spin_unlock(&mib->stats64_lock);
> +}
