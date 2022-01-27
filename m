Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B20149EDD9
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 22:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbiA0VzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 16:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiA0VzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 16:55:11 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EB6C061714;
        Thu, 27 Jan 2022 13:55:11 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id h14so3992121plf.1;
        Thu, 27 Jan 2022 13:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J35l0cCg0B8rjIasy2LKEQqHsevOK9wJkAphQcTelBM=;
        b=gXggFjW0L8WwND6TSJoBMLmPMyJPqQenm/QUchL+bIXQSNgY9gln/iZgfzSYRWRHSF
         C4+gw3+u7UkUx8tf8EXLkMKcpFNns8v3QTPd1LDlsiKA6xe/LGkk41mentNSsUAI+lIh
         CQ5cIbV05U8Mr1hQHWsCrc2h3CSY6KYxoSHugRXwUpWyzhkwGWeiiP+3o0ARap7W70Yp
         HwhWEi+x+BaaXXaMuLjOAsFd+zF+3nTKBFTRIwFyIz+4ViFHbO6kODYx7d08EL+59lLF
         oOU+lvsPNcdR9W3Qxd67qm9JoN2mGKuKdQvG5bmcxkK95AmobHM5yH/mgz6JqKecxy8Y
         hH4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J35l0cCg0B8rjIasy2LKEQqHsevOK9wJkAphQcTelBM=;
        b=Wdukk3I76avFBsKYF/EWkAah0aBToeKWAhxy1JBt9cvisxntxXWs+BHpDK4tQT5gMB
         GyMTREdPOg7BQDnmmV6arQLpv+zSfRQ8Jq38defLq7NonJW9EZ3lFEnBfUxqysr2sRgE
         qfrylHKNRMkD9irxPECr+W2JB9fIZvDR/E45ctq2/RL/EPmH83KN/FLacfc8vR3VPHjl
         jWuCUYrYunf4gp9yxJXnCaKS4fMxCwgrtcWBX2u6SlUgRCYznwyxKWswCV7FnfJ8AVjz
         9wyPuhTO/a6Oh21J45aCKptQZWED2Xjn7seC+lz0Eh8y22HvLxi7tf4HC13QlsVjVm9s
         blhQ==
X-Gm-Message-State: AOAM531QI5zB8vwk6L9GYVlAFcZLTKigpn4nNkm8kMFZuYAV4tD3OybF
        P26iBkUXtjJgDzjl9HXXnD85vrrDDFA=
X-Google-Smtp-Source: ABdhPJy4vgrcRfk23HHwPcJELerizqx+pP+ue/IEMM+DbxEHGH8I10KwWyOnHyWDUNrRdz1GV1YFbQ==
X-Received: by 2002:a17:90a:aa96:: with SMTP id l22mr6305571pjq.188.1643320510943;
        Thu, 27 Jan 2022 13:55:10 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id e14sm6832478pfv.219.2022.01.27.13.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 13:55:10 -0800 (PST)
Date:   Thu, 27 Jan 2022 13:55:08 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, vladimir.oltean@nxp.com, andrew@lunn.ch
Subject: Re: [PATCH net-next 4/7] net: lan966x: Implement SIOCSHWTSTAMP and
 SIOCGHWTSTAMP
Message-ID: <20220127215508.GA26514@hoboy.vegasvil.org>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
 <20220127102333.987195-5-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127102333.987195-5-horatiu.vultur@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:23:30AM +0100, Horatiu Vultur wrote:

> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> index 69d8f43e2b1b..9ff4d3fca5a1 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> @@ -35,6 +35,90 @@ static u64 lan966x_ptp_get_nominal_value(void)
>  	return res;
>  }
>  
> +int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr)
> +{
> +	struct lan966x *lan966x = port->lan966x;
> +	bool l2 = false, l4 = false;
> +	struct hwtstamp_config cfg;
> +	struct lan966x_phc *phc;
> +
> +	/* For now don't allow to run ptp on ports that are part of a bridge,
> +	 * because in case of transparent clock the HW will still forward the
> +	 * frames, so there would be duplicate frames
> +	 */
> +	if (lan966x->bridge_mask & BIT(port->chip_port))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> +		return -EFAULT;
> +
> +	switch (cfg.tx_type) {
> +	case HWTSTAMP_TX_ON:
> +		port->ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
> +		break;
> +	case HWTSTAMP_TX_ONESTEP_SYNC:
> +		port->ptp_cmd = IFH_REW_OP_ONE_STEP_PTP;
> +		break;
> +	case HWTSTAMP_TX_OFF:
> +		port->ptp_cmd = IFH_REW_OP_NOOP;
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	mutex_lock(&lan966x->ptp_lock);

No need to lock stack variables.  Move locking down to ...

> +	switch (cfg.rx_filter) {
> +	case HWTSTAMP_FILTER_NONE:
> +		break;
> +	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> +		l4 = true;
> +		break;
> +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> +		l2 = true;
> +		break;
> +	case HWTSTAMP_FILTER_PTP_V2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> +		l2 = true;
> +		l4 = true;
> +		break;
> +	default:
> +		mutex_unlock(&lan966x->ptp_lock);
> +		return -ERANGE;
> +	}
> +
> +	if (l2 && l4)
> +		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
> +	else if (l2)
> +		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> +	else if (l4)
> +		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
> +	else
> +		cfg.rx_filter = HWTSTAMP_FILTER_NONE;
> +
> +	/* Commit back the result & save it */

... here

> +	phc = &lan966x->phc[LAN966X_PHC_PORT];
> +	memcpy(&phc->hwtstamp_config, &cfg, sizeof(cfg));
> +	mutex_unlock(&lan966x->ptp_lock);
> +
> +	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
> +}

Thanks,
Richard
