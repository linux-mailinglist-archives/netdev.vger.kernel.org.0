Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27094FA019
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 01:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbiDHX2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 19:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbiDHX2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 19:28:06 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FCC11A13;
        Fri,  8 Apr 2022 16:26:00 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id u18so994351eda.3;
        Fri, 08 Apr 2022 16:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4GaWA2Fuk8kXND0qeqeKieqo0o4cogxqEcU10NDv2L0=;
        b=GCS7HNe7t4bJOfiX0Qgs3D/Mrf/3IfWv/qrKrcaR4fUWn8Koy+kdQ72uVPhlOqY3nj
         LTPrf5LHX700EXL7K5HngD8vFI4X8RJzdQWQLaX2DNYSyE3rEB3PpiQERrgThmIpapVH
         REDou3bA6BV+6pAcJRdaDevjwxvxqvpFP+p7U/eCkVRnQo0xBnr/gAz+p/9qyHuUdS77
         NpqAqb4g3ZVSgAaJPcPtz5jFSTpJkd8jtP77nnsci/IsrvEftzEKptnwazPb9aEz3/Q8
         QE4CEO310URG5WQh+D9eohVStBhYoJAOqaqen3AFvKauXpCHQepY//x58ltZP/XZL0M2
         jb6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4GaWA2Fuk8kXND0qeqeKieqo0o4cogxqEcU10NDv2L0=;
        b=oq2pCIFy+gZ7PvS8hO1FW3gyAL8aENhoEekAeQbWzhKQcsAGVYMZwkl+13gFMEB1B9
         2dfWQs+QWivfNIe2/YDT/b5YMQQIwtLqj/Ej0ZwWJSDf6r7B7B4HFCalgtQSkV3aiT7g
         r3Vu+nd2LVtOYUHLCe1HaKqnEua+A45jziPqwh0t6yoL1vJAeM1jodGVJ5IJbPDiQB8I
         ELPqbCMn2eHV1ola1h+ATuQ50DbemvnTgnSxewqF68+zLFpzgxb4jPsqTTW5j6izBnSB
         m5E/eVo4KPEsm/8WprY1kR/Ims3JHZpbwCZ0rpjRTR4AMYwndxQ010bS3LbqpBrQVByY
         wEgQ==
X-Gm-Message-State: AOAM533SZiZxpAuhKPctyznAL0VVNbrGVcKaqPxuBjISjqsSOKbQ1xG2
        XBaKe5ENLmN7fAZOuqRv9yw=
X-Google-Smtp-Source: ABdhPJzfIvGtPN+jui8oCXx7bKJpTEqrNJuCGXO5M3y/EkXa0i1TjkJevRHfeKTTghskLBNHnllf2g==
X-Received: by 2002:a05:6402:40ce:b0:41a:6817:5b07 with SMTP id z14-20020a05640240ce00b0041a68175b07mr21777105edb.7.1649460359283;
        Fri, 08 Apr 2022 16:25:59 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id r22-20020a17090638d600b006d584aaa9c9sm9170186ejd.133.2022.04.08.16.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 16:25:58 -0700 (PDT)
Date:   Sat, 9 Apr 2022 02:25:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org, pabeni@redhat.com
Subject: Re: [RFC PATCH v11 net-next 05/10] net: dsa: microchip: add DSA
 support for microchip lan937x
Message-ID: <20220408232557.b62l3lksotq5vuvm@skbuf>
References: <20220325165341.791013-1-prasanna.vengateshan@microchip.com>
 <20220325165341.791013-6-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325165341.791013-6-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 10:23:36PM +0530, Prasanna Vengateshan wrote:
> +static void lan937x_r_mib_stats64(struct ksz_device *dev, int port)
> +{
> +	struct ksz_port_mib *mib = &dev->ports[port].mib;
> +	struct rtnl_link_stats64 *s;
> +	u64 *ctr = mib->counters;
> +
> +	s = &mib->stats64;
> +	spin_lock(&mib->stats64_lock);

I haven't looked at further patches yet to see if the situation improves
or not, but right now, this spin lock is useless, as you do not
implement .get_stats64.

> +
> +	s->rx_packets = ctr[lan937x_mib_rx_mcast] +
> +			ctr[lan937x_mib_rx_bcast] +
> +			ctr[lan937x_mib_rx_ucast] +
> +			ctr[lan937x_mib_rx_pause];
> +
> +	s->tx_packets = ctr[lan937x_mib_tx_mcast] +
> +			ctr[lan937x_mib_tx_bcast] +
> +			ctr[lan937x_mib_tx_ucast] +
> +			ctr[lan937x_mib_tx_pause];
> +
> +	s->rx_bytes = ctr[lan937x_mib_rx_total];
> +	s->tx_bytes = ctr[lan937x_mib_tx_total];
> +
> +	s->rx_errors = ctr[lan937x_mib_rx_fragments] +
> +		       ctr[lan937x_mib_rx_jabbers] +
> +		       ctr[lan937x_mib_rx_sym_err] +
> +		       ctr[lan937x_mib_rx_align_err] +
> +		       ctr[lan937x_mib_rx_crc_err];
> +
> +	s->tx_errors = ctr[lan937x_mib_tx_exc_col] +
> +		       ctr[lan937x_mib_tx_late_col];
> +
> +	s->rx_dropped = ctr[lan937x_mib_rx_discard];
> +	s->tx_dropped = ctr[lan937x_mib_tx_discard];
> +	s->multicast = ctr[lan937x_mib_rx_mcast];
> +
> +	s->collisions = ctr[lan937x_mib_tx_late_col] +
> +			ctr[lan937x_mib_tx_single_col] +
> +			ctr[lan937x_mib_tx_mult_col];
> +
> +	s->rx_length_errors = ctr[lan937x_mib_rx_fragments] +
> +			      ctr[lan937x_mib_rx_jabbers];
> +
> +	s->rx_crc_errors = ctr[lan937x_mib_rx_crc_err];
> +	s->rx_frame_errors = ctr[lan937x_mib_rx_align_err];
> +	s->tx_aborted_errors = ctr[lan937x_mib_tx_exc_col];
> +	s->tx_window_errors = ctr[lan937x_mib_tx_late_col];
> +
> +	spin_unlock(&mib->stats64_lock);
> +}

> +static int lan937x_init(struct ksz_device *dev)
> +{
> +	int ret;
> +
> +	ret = lan937x_switch_init(dev);
> +	if (ret < 0) {
> +		dev_err(dev->dev, "failed to initialize the switch");
> +		return ret;
> +	}
> +
> +	/* enable Indirect Access from SPI to the VPHY registers */
> +	ret = lan937x_enable_spi_indirect_access(dev);

Do you need to call this both from lan937x_init() and from lan937x_setup()?

> +	if (ret < 0) {
> +		dev_err(dev->dev, "failed to enable spi indirect access");
> +		return ret;
> +	}
> +
> +	ret = lan937x_mdio_register(dev);
> +	if (ret < 0) {
> +		dev_err(dev->dev, "failed to register the mdio");
> +		return ret;
> +	}
> +
> +	return 0;
> +}

> +static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
> +				       u8 state)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_port *p;
> +	u8 data;
> +
> +	lan937x_pread8(dev, port, P_STP_CTRL, &data);

This is a copy-paste of ksz8_port_stp_state_set() except for the use of
lan937x_pread8() instead of ksz_pread8(). But ksz_pread8() should work
too, since it calls dev->dev_ops->get_port_addr(port, offset) which you
translate into PORT_CTRL_ADDR(port, offset) which is exactly what
lan937x_pread8() does.

> +	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
> +
> +	switch (state) {
> +	case BR_STATE_DISABLED:
> +		data |= PORT_LEARN_DISABLE;
> +		break;
> +	case BR_STATE_LISTENING:
> +		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
> +		break;
> +	case BR_STATE_LEARNING:
> +		data |= PORT_RX_ENABLE;
> +		break;
> +	case BR_STATE_FORWARDING:
> +		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
> +		break;
> +	case BR_STATE_BLOCKING:
> +		data |= PORT_LEARN_DISABLE;
> +		break;
> +	default:
> +		dev_err(ds->dev, "invalid STP state: %d\n", state);
> +		return;
> +	}
> +
> +	lan937x_pwrite8(dev, port, P_STP_CTRL, data);
> +
> +	p = &dev->ports[port];
> +	p->stp_state = state;
> +
> +	ksz_update_port_member(dev, port);
> +}
