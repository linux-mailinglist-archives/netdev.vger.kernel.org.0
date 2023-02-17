Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9967669B196
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBQRIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQRI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:08:29 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96FA642D8;
        Fri, 17 Feb 2023 09:08:26 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id w13so1601747wrl.13;
        Fri, 17 Feb 2023 09:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P4PTAR/CgPhVfDMvgxYRf5JeQ2wxUf2Wt/beEvjZKps=;
        b=eyTnb/OohWq9Z85Mc5PiGK9x2w58+T6UsnfJskFHpUl8Ky99ZNPvvbKvxJhI3S7lEX
         kIgEgElShVL4adihJk2p+dvqo8szcjbvO5uphXXn7MrgB0xI3OSPPnSWbNrqp9hL6nnQ
         izAuVznNEXFNLSkO17fD4tf272xu5zYpUuboCpDrJLP5MWej3DCT8aLk4CqBhHBSS59V
         mf+hhOS2TeCVGLzC/Lj7lh19o8mf1WASa50S1kyoOzkdCtFH36aiZs7YzjpbuUc5j+mA
         GajqJAGy904Mu38nnpIgQ8ANng7TBYdoQtfbAIoZA3FnlY7+BE41G3gsb00xLiRpLHx5
         ZSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4PTAR/CgPhVfDMvgxYRf5JeQ2wxUf2Wt/beEvjZKps=;
        b=TkdsGJ4txso3fXIgH5hGb+sba5UtVle7QlZnSQK1kxvpKWN/Xr5+wrcuadMMDR3P0f
         SjFHxYG/h+RA+Ssts6BEYJvrnIb9LFBObRSH2Ssqw/ThB999xR97VuAX4H0rmACY6SYk
         u2m6Dispyzf1okRwYhE63C1aKvYFHYevX3QVro39+XDcxcvBs1tE6H8GreK36Lk0xllk
         vOEf9AVNDE/Bh/avXJx56He/etLp/Sv21fXweebihN+y5s8eBLYPlNMEcLPV0WpAtash
         xok2WD2108c1MPjXzpehk5mPLhu7ZI9DowCRyXCsHsQup5HMkTfwYdCQLguydG53kBqg
         7sFw==
X-Gm-Message-State: AO0yUKVc8QhXn5gdVX+EaLqHH8tOKD0AjB8P3K8Q230N2j3eCDkf0OA9
        wVG4NXV+QRuAqv/opM274Cs=
X-Google-Smtp-Source: AK7set+Pq1ApdIdSUNcsY7OmHO9mGJljV5Gx/mx9tT0ZnnvNghg33vkXalHr00IZOCObJZqomFgo9g==
X-Received: by 2002:adf:f691:0:b0:2c6:e893:6f3a with SMTP id v17-20020adff691000000b002c6e8936f3amr1763025wrp.16.1676653705298;
        Fri, 17 Feb 2023 09:08:25 -0800 (PST)
Received: from skbuf ([188.25.231.176])
        by smtp.gmail.com with ESMTPSA id t10-20020a05600001ca00b002c53f5b13f9sm4642236wrx.0.2023.02.17.09.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 09:08:25 -0800 (PST)
Date:   Fri, 17 Feb 2023 19:08:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 2/5] net: dsa: microchip: add eth ctrl
 grouping for ethtool statistics
Message-ID: <20230217170822.w65c72hsbbnoqcab@skbuf>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <20230217110211.433505-3-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217110211.433505-3-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:32:08PM +0530, Rakesh Sankaranarayanan wrote:
> +void ksz8_get_eth_ctrl_stats(struct ksz_device *dev, int port,
> +			     struct ethtool_eth_ctrl_stats *ctrl_stats)
> +{
> +	struct ksz_port_mib *mib;
> +	u64 *cnt;
> +
> +	mib = &dev->ports[port].mib;
> +
> +	mutex_lock(&mib->cnt_mutex);
> +
> +	cnt = &mib->counters[KSZ8_TX_PAUSE];
> +	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_TX_PAUSE, NULL, cnt);
> +	ctrl_stats->MACControlFramesTransmitted = *cnt;
> +
> +	cnt = &mib->counters[KSZ8_RX_PAUSE];
> +	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_RX_PAUSE, NULL, cnt);
> +	ctrl_stats->MACControlFramesReceived = *cnt;
> +
> +	mutex_unlock(&mib->cnt_mutex);
> +}

These should be reported as standard pause stats as well (ethtool -I --show-pause swpN).
