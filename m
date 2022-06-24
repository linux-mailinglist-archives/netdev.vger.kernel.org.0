Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DD255A428
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 00:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiFXWDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 18:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiFXWD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 18:03:29 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6766586;
        Fri, 24 Jun 2022 15:03:21 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ay16so7326093ejb.6;
        Fri, 24 Jun 2022 15:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VyXYggi/L92haITL8cq/jngSqWpyxhf55D5TpEd02t4=;
        b=M2hUu6cyDch3Te/zIlbYFWetXhT4N9nkI+hZyLPRGV1OeZwxa5aiLXJiyja0pH3025
         ppiCxN/uaFnUj97H5yMFtiw1m3aquIGzhinssolp1Hlbc7/ArkpQNJdQxozLm5t3T2Gh
         erc4wwSTrkkaK6BYLSssunX7hVAYxIlxXevH1x7TdgJZli7aiisHWL5Un+6/NlTR5Iov
         Nwmx51uDLkkQf3hLVYwsePWVuf78jeKVSa567/Ip3OXHqUo2O/xftBT4NlRBFWVMyJn7
         Fow6m+sTqravqSt1x4Nx5LMm+ewnU9VlQaOGt0ZmIzkDin2gbqClP8qoz5fqOBVa/M7C
         BJfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VyXYggi/L92haITL8cq/jngSqWpyxhf55D5TpEd02t4=;
        b=4J/z/L15MNQgigZlR5jIpoHjNvobpf7kugpkf72ZlKdSGWaD2ehaM4ma/TB4ut8708
         b6RJT7IMA1QMjuwTZ+7CqkQociPtxJIQPjOpdHftKkNmb9cAah5J/ZAOD+gPFOtWEu7U
         HPzG2z4LHi6KmrJKAruuMtuM1xX/YictOvJoLKxistwCLFSr7wtNwwAbQrxs3nNi8szV
         2Mn97Y4r9d5x2zDf5wI87ePYwqWxQeW1SHtVuzRoXlCNX42ESHK8XhCddaLSXKgRciBo
         3DjmHF4BkYG23/hj92Rjy4PfYAtXOi0LArPCy+hdx0GlbR2jaz6KxYWHNtN4ZvQ4II13
         HeZA==
X-Gm-Message-State: AJIora8b8yoXSPF9s2vr+h6tiO2J/5BerL19Xy3SqsXBnqqv9BJxYdnk
        Ek6SwD3YKFsfZIH+VjEEcM0=
X-Google-Smtp-Source: AGRyM1sAEM+OmaHBA5bPm+6nS8tHBpXTXaMiQC5FA+yAhQKT/rEBtvqKuIUY30ld4caMzmufYPbjIQ==
X-Received: by 2002:a17:907:6e17:b0:726:2b3c:d373 with SMTP id sd23-20020a1709076e1700b007262b3cd373mr1090734ejc.357.1656108199593;
        Fri, 24 Jun 2022 15:03:19 -0700 (PDT)
Received: from skbuf ([188.27.185.253])
        by smtp.gmail.com with ESMTPSA id f19-20020a170906825300b0071160715917sm1695802ejx.223.2022.06.24.15.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 15:03:18 -0700 (PDT)
Date:   Sat, 25 Jun 2022 01:03:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/3] net: dsa: ar9331: add support for pause
 stats
Message-ID: <20220624220317.ckhx6z7cmzegvoqi@skbuf>
References: <20220624125902.4068436-1-o.rempel@pengutronix.de>
 <20220624125902.4068436-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624125902.4068436-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 02:59:01PM +0200, Oleksij Rempel wrote:
> Add support for pause stats and fix rx_packets/tx_packets calculation.
> 
> Pause packets are counted by raw.rx64byte/raw.tx64byte counters, so
> subtract it from main rx_packets/tx_packets counters.
> 
> tx_/rx_bytes are not affected.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/qca/ar9331.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> index fb3fe74abfe6..82412f54c432 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -606,6 +607,7 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
>  static void ar9331_read_stats(struct ar9331_sw_port *port)
>  {
>  	struct ar9331_sw_priv *priv = ar9331_sw_port_to_priv(port);
> +	struct ethtool_pause_stats *pstats = &port->pause_stats;
>  	struct rtnl_link_stats64 *stats = &port->stats;
>  	struct ar9331_sw_stats_raw raw;
>  	int ret;
> @@ -625,9 +627,11 @@ static void ar9331_read_stats(struct ar9331_sw_port *port)
>  	stats->tx_bytes += raw.txbyte;
>  
>  	stats->rx_packets += raw.rx64byte + raw.rx128byte + raw.rx256byte +
> -		raw.rx512byte + raw.rx1024byte + raw.rx1518byte + raw.rxmaxbyte;
> +		raw.rx512byte + raw.rx1024byte + raw.rx1518byte +
> +		raw.rxmaxbyte - raw.rxpause;
>  	stats->tx_packets += raw.tx64byte + raw.tx128byte + raw.tx256byte +
> -		raw.tx512byte + raw.tx1024byte + raw.tx1518byte + raw.txmaxbyte;
> +		raw.tx512byte + raw.tx1024byte + raw.tx1518byte +
> +		raw.txmaxbyte - raw.txpause;

Is there an authoritative source who is able to tell whether rtnl_link_stats64 ::
rx_packets and tx_packets should count PAUSE frames or not?

>  
>  	stats->rx_length_errors += raw.rxrunt + raw.rxfragment + raw.rxtoolong;
>  	stats->rx_crc_errors += raw.rxfcserr;
> @@ -646,6 +650,9 @@ static void ar9331_read_stats(struct ar9331_sw_port *port)
>  	stats->multicast += raw.rxmulti;
>  	stats->collisions += raw.txcollision;
>  
> +	pstats->tx_pause_frames += raw.txpause;
> +	pstats->rx_pause_frames += raw.rxpause;
> +
>  	spin_unlock(&port->stats_lock);
>  }
