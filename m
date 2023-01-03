Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E88465C551
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 18:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238228AbjACRrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 12:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237982AbjACRrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 12:47:14 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5CE6572;
        Tue,  3 Jan 2023 09:47:13 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id u9so75918422ejo.0;
        Tue, 03 Jan 2023 09:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xv23uFExM2LvOZ6MXvWBaZStvyI5+FhGv1pfjK5XMR8=;
        b=DL3DOSjRmrsFyBH6+4+QHQWYjlisMC2MTj9lQ2jgRKjGUWeeOjz0x1ipTxjEtajl1r
         61hn4Jk86qtC1r2ZJQ6ewPFJmeBX0boeSVUNXboqgJkNewWRnjHvFeeBGUSJmfcwUzTB
         Qxg5eY7lZqN8HvYyN8S+kKsuu+IhaDF9VCMaT/KZvrcBdcXj/UmDVH/MOasM4c587exU
         dx53pttW5YCP/O6AbD+Q9IhqhRpsTPo9yLvN4N67R4NqflSoNdl36YuEYWeXV750srR7
         VCCXJpFF2HNHhT+RV4eee7Hszxz04mAcayZhJ9JoVELl622ClUBw+b94arRcrQwrl2ia
         NP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xv23uFExM2LvOZ6MXvWBaZStvyI5+FhGv1pfjK5XMR8=;
        b=Z3J1aF4qnT///Z6SsiW2MLLR1WP3jJuxfubhFZePPPRbspqSarT/ByaLZSFPlJVeRa
         oKw9zLMh+qehOlYrwaBbCVVzK0v3mTzrNWkbdxRZ11vmGcMYp6DON0VtkdS+LhP+vIuS
         w2DlI4KXOTTgu6QG5NmV46sdPJs8LiWRZzt88fYS6Py4nm6Y2ImSQt+//Fd8xeib9it1
         WfkA4fdF6kGEAtfyMmsexRYSWOtsEGF64Z/KyoJO0hwIwiiICF4tj5d/1ocviA+N2qBy
         D79gWXaP9Mw+b8YPIFJMPv6A+l3OJPCUsd0Fgkzt3Rr2RquEDFy6HJqurfiSNMsJeuST
         efbw==
X-Gm-Message-State: AFqh2kqmLCN0hWpY39d+UuR6G6JJdUQ0viGvpe3Su0k8KH0mXUTPDM3u
        7dIbHL8SRQv+HuXLh0f60LY=
X-Google-Smtp-Source: AMrXdXvbG3Ha9vS24+zdJs+kic01YcSnyh8tCgm7Cs8VxQ6DQMW9pplWKIZpFHiHNmCD6gnNu/pJkw==
X-Received: by 2002:a17:906:71c3:b0:7c0:dd80:e95e with SMTP id i3-20020a17090671c300b007c0dd80e95emr44695436ejk.51.1672768032320;
        Tue, 03 Jan 2023 09:47:12 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906300a00b007c53090d511sm14293642ejz.192.2023.01.03.09.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:47:11 -0800 (PST)
Date:   Tue, 3 Jan 2023 19:47:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de, jacob.e.keller@intel.com
Subject: Re: [Patch net-next v6 12/13] net: dsa: microchip: ptp: lan937x: add
 2 step timestamping
Message-ID: <20230103174709.uzzxrvloei4diz2n@skbuf>
References: <20230102050459.31023-1-arun.ramadoss@microchip.com>
 <20230102050459.31023-1-arun.ramadoss@microchip.com>
 <20230102050459.31023-13-arun.ramadoss@microchip.com>
 <20230102050459.31023-13-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102050459.31023-13-arun.ramadoss@microchip.com>
 <20230102050459.31023-13-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 02, 2023 at 10:34:58AM +0530, Arun Ramadoss wrote:
> ---
>  drivers/net/dsa/microchip/ksz_ptp.c | 37 ++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
> index 2d52a3d4771e..c2d156002ee5 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.c
> +++ b/drivers/net/dsa/microchip/ksz_ptp.c
> @@ -283,6 +283,9 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts)
>  
>  	ts->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ONESTEP_P2P);
>  
> +	if (is_lan937x(dev))
> +		ts->tx_types |= BIT(HWTSTAMP_TX_ON);
> +
>  	ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
>  			 BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
>  			 BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
> @@ -310,6 +313,8 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev,
>  				   struct ksz_port *prt,
>  				   struct hwtstamp_config *config)
>  {
> +	int ret;
> +
>  	if (config->flags)
>  		return -EINVAL;
>  
> @@ -325,6 +330,25 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev,
>  		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = 1;
>  		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 0;
>  		prt->hwts_tx_en = true;
> +
> +		ret = ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_1STEP, PTP_1STEP);
> +		if (ret)
> +			return ret;
> +
> +		break;
> +	case HWTSTAMP_TX_ON:
> +		if (!is_lan937x(dev))
> +			return -ERANGE;
> +
> +		prt->ptpmsg_irq[KSZ_SYNC_MSG].ts_en  = 1;
> +		prt->ptpmsg_irq[KSZ_XDREQ_MSG].ts_en = 1;
> +		prt->ptpmsg_irq[KSZ_PDRES_MSG].ts_en = 1;

s/1/true/ please

> +		prt->hwts_tx_en = true;
> +
> +		ret = ksz_rmw16(dev, REG_PTP_MSG_CONF1, PTP_1STEP, 0);
> +		if (ret)
> +			return ret;
> +
>  		break;
>  	default:
>  		return -ERANGE;
