Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458A94BA535
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242965AbiBQP4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:56:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242962AbiBQP4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:56:12 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CB2296937;
        Thu, 17 Feb 2022 07:55:57 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id p15so8311047ejc.7;
        Thu, 17 Feb 2022 07:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=stQBLerS0YgUN6i139GS07sIlm3wjb9GOv6uFJCm+0k=;
        b=ngbPMd00wQBSD7HZOJ8ELcHecyJBsrn6baiWsPCyF3kH9vxCvbZDEpDNlCZSFD6eVH
         DCuLIhPP7vmIhfXdES37Dp9CPihdqSJYwFUYjvv/CHApehH/aQTy3eKJnElvEE+hK7eL
         9ZoLQ43YOUktjowkEHNe4Q4JVfAbMkJr3fb4p9Qn6jC6Xp2gd38MhPfQFJ0GBctjrrp8
         +fWKPwl/MJYImn0HfHynVMifOYHlPVW77ZlDwuHe4ofrPW3uBeXYmaFAmLi4nRohfKgj
         l5Q205nJV9ciZWTFNhcakNp9FG0jes7aClYlAzJ2IMzVxX0gUDZmksQyZtwPokqioXnA
         KxQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=stQBLerS0YgUN6i139GS07sIlm3wjb9GOv6uFJCm+0k=;
        b=b2yfdc2TQwPAnavqUJ38eoYeut5ulQo81BoAchQuviJfIrwXcaOrWWd4l6qpWJ92Qm
         md93+4JQRLDW0MC+JWNMTYLrzK973hYhiVNTXKbVTwJDxH7vWX2HV4HpOkBY4PEYXDmB
         tbNVtlSlfv8lXIjqZsOE6pqnyvIcwSCmxkKx1JhPoFjIyPrGvdRVb9NOH18ljNHG0w7a
         SRcPJkLtxQ4nUvIT1ffgm5QUy38IwMIZ8Y4JEQ72gG8UjaoArQlJs81+B4cewsZt8fxo
         z40VepiZKQsewys6tn2NpeMsFOiv5/iHvjqPbzOwVW/c8QJUZrk9YY9DmdLU/fSI/V/3
         i3JA==
X-Gm-Message-State: AOAM533RfnxOQvsgV+GUJ5sI/4DaGcd/le9YSiIstn5uOBcQEi3In1NG
        W9JhVweAlzmeZlbhLV2Lnfs=
X-Google-Smtp-Source: ABdhPJyjvBmoJf9tIXGqi11mYbXDCRFUlBOLsYXdLOTgRE5MsOxzyGD615f87LiiU+VvQL/tVjKitQ==
X-Received: by 2002:a17:906:9f06:b0:6ce:36da:8247 with SMTP id fy6-20020a1709069f0600b006ce36da8247mr2891047ejc.651.1645113356089;
        Thu, 17 Feb 2022 07:55:56 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id r3sm1325786ejd.129.2022.02.17.07.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 07:55:55 -0800 (PST)
Date:   Thu, 17 Feb 2022 17:55:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz9477: export HW
 stats over stats64 interface
Message-ID: <20220217155554.bo6gcva6h2pkryou@skbuf>
References: <20220217140726.248071-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217140726.248071-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 03:07:26PM +0100, Oleksij Rempel wrote:
> +static void ksz9477_get_stats64(struct dsa_switch *ds, int port,
> +				struct rtnl_link_stats64 *stats)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz9477_stats_raw *raw;
> +	struct ksz_port_mib *mib;
> +	int ret;
> +
> +	mib = &dev->ports[port].mib;
> +	raw = (struct ksz9477_stats_raw *)mib->counters;
> +
> +	mutex_lock(&mib->cnt_mutex);

The eternal problem, ndo_get_stats64 runs in atomic context,
mutex_lock() sleeps. Please test your patches with
CONFIG_DEBUG_ATOMIC_SLEEP=y.

> +
> +	stats->rx_packets = raw->rx_bcast + raw->rx_mcast + raw->rx_ucast;
> +	stats->tx_packets = raw->tx_bcast + raw->tx_mcast + raw->tx_ucast;
> +
> +	/* HW counters are counting bytes + FCS which is not acceptable
> +	 * for rtnl_link_stats64 interface
> +	 */
> +	stats->rx_bytes = raw->rx_total - stats->rx_packets * ETH_FCS_LEN;
> +	stats->tx_bytes = raw->tx_total - stats->tx_packets * ETH_FCS_LEN;
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
> +	mutex_unlock(&mib->cnt_mutex);
> +}
> +
>  static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
>  {
>  	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
> @@ -1365,6 +1447,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
>  	.port_mdb_del           = ksz9477_port_mdb_del,
>  	.port_mirror_add	= ksz9477_port_mirror_add,
>  	.port_mirror_del	= ksz9477_port_mirror_del,
> +	.get_stats64		= ksz9477_get_stats64,
>  };
>  
>  static u32 ksz9477_get_port_addr(int port, int offset)
> -- 
> 2.30.2
> 

