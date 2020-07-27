Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4F822F112
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 16:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732752AbgG0O3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 10:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729827AbgG0O32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 10:29:28 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1929C061794;
        Mon, 27 Jul 2020 07:29:28 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id 72so8083674ple.0;
        Mon, 27 Jul 2020 07:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o0FwXWJzk9fg0IFqdpyGQiSwsPpWPqkwzppi0kl4fRE=;
        b=X19ILMVnSbYreBVhndZtyG/r7ymaNtXrolJRzStGqDjC4fBj1tBNPp2/0EwMC3pEWg
         ctByeaI16babSvSD07KdX/CGEYLGi5oDewwAmTQiiLyTPSU0nBcIJb0wqd9+0ZXUt5NA
         R2wyGyskfKapkd0fa3WPAgXzhhvGPwgabtTeWg1q7bYeE4mpxLYsaj+mRlQqb931qLHs
         Ol1abQ97x1y0CCetMhhAss3ahDc2dUUmOHVJjViV/pwqNlM9bsfT5zU3D1sK6nhYk/+g
         sJrbZsg3VGdG7rPYQVrDxWsbptv6eFp2fcjuyDNBPEl+L7E1nbxdz/VVj9M823BV1jJs
         6KRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o0FwXWJzk9fg0IFqdpyGQiSwsPpWPqkwzppi0kl4fRE=;
        b=hLIXlFTygGHP28woh80l2FN+tLaiQ7p0VmbldHdffDzdoW72Bk0b2DPBeiWkVuHXOZ
         8Uv78JOMdQVWPMP5seCmt0pwhQMyf92u+6XZq2v8o5tl7hBSmyV7GI/8uNuFYlPBH2z3
         l9j+BrmqDS3A3cwEMK0001wXCyFSQk6en3t86yLFNqc8LFqEOoYFk4Sqc6UFzi0yv+IJ
         O3PtDsXyii6RyWItQuKbh0MyBbCnHDBygp+FoIG/dD3AACzxUnhjuNWSKMD4Fnh5Lgch
         9Ko/H/m16MuV5WUOsJ+SidnEVoZPkIj5AvbHAzKStMkqoERBaBwaWsNz3rivLF8/cLCZ
         EMjg==
X-Gm-Message-State: AOAM532YpSKk/lS0d68YXDZtJcaPV0V7YZe7zrQGr09MTBz1bwxOoymd
        oU/ijqafGsubDy1Fo2ERshg=
X-Google-Smtp-Source: ABdhPJw9puvQA92a0JkpFjjmz2WkQsRKIqNGuvtIwBDIBtS9+/irr2W/OVTdPqbqO7VVJ6F2Tr0LAg==
X-Received: by 2002:a17:902:9a96:: with SMTP id w22mr19257977plp.172.1595860168111;
        Mon, 27 Jul 2020 07:29:28 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id o8sm14330081pgb.23.2020.07.27.07.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 07:29:27 -0700 (PDT)
Date:   Mon, 27 Jul 2020 07:29:25 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Ooi, Joyce" <joyce.ooi@intel.com>
Cc:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>
Subject: Re: [PATCH v5 08/10] net: eth: altera: add support for ptp and
 timestamping
Message-ID: <20200727142925.GB16836@hoboy>
References: <20200727092157.115937-1-joyce.ooi@intel.com>
 <20200727092157.115937-9-joyce.ooi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727092157.115937-9-joyce.ooi@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 05:21:55PM +0800, Ooi, Joyce wrote:

> +/* ioctl to configure timestamping */
> +static int tse_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
> +{
> +	struct altera_tse_private *priv = netdev_priv(dev);
> +	struct hwtstamp_config config;
> +
> +	if (!netif_running(dev))
> +		return -EINVAL;
> +
> +	if (!priv->has_ptp) {
> +		netdev_alert(priv->dev, "Timestamping not supported");
> +		return -EOPNOTSUPP;
> +	}

The user might well have a PHY that supports time stamping.  The code
must pass the ioctl through to the PHY even when !priv->has_ptp.

> +
> +	if (!dev->phydev)
> +		return -EINVAL;
> +
> +	if (!phy_has_hwtstamp(dev->phydev)) {
> +		if (cmd == SIOCSHWTSTAMP) {
> +			if (copy_from_user(&config, ifr->ifr_data,
> +					   sizeof(struct hwtstamp_config)))
> +				return -EFAULT;
> +
> +			if (config.flags)
> +				return -EINVAL;
> +
> +			switch (config.tx_type) {
> +			case HWTSTAMP_TX_OFF:
> +				priv->hwts_tx_en = 0;
> +				break;
> +			case HWTSTAMP_TX_ON:
> +				priv->hwts_tx_en = 1;
> +				break;
> +			default:
> +				return -ERANGE;
> +			}
> +
> +			switch (config.rx_filter) {
> +			case HWTSTAMP_FILTER_NONE:
> +				priv->hwts_rx_en = 0;
> +				config.rx_filter = HWTSTAMP_FILTER_NONE;
> +				break;
> +			default:
> +				priv->hwts_rx_en = 1;
> +				config.rx_filter = HWTSTAMP_FILTER_ALL;
> +				break;
> +			}
> +
> +			if (copy_to_user(ifr->ifr_data, &config,
> +					 sizeof(struct hwtstamp_config)))
> +				return -EFAULT;
> +			else
> +				return 0;
> +		}
> +
> +		if (cmd == SIOCGHWTSTAMP) {
> +			config.flags = 0;
> +
> +			if (priv->hwts_tx_en)
> +				config.tx_type = HWTSTAMP_TX_ON;
> +			else
> +				config.tx_type = HWTSTAMP_TX_OFF;
> +
> +			if (priv->hwts_rx_en)
> +				config.rx_filter = HWTSTAMP_FILTER_ALL;
> +			else
> +				config.rx_filter = HWTSTAMP_FILTER_NONE;
> +
> +			if (copy_to_user(ifr->ifr_data, &config,
> +					 sizeof(struct hwtstamp_config)))
> +				return -EFAULT;
> +			else
> +				return 0;
> +		}
> +	}
> +
> +	return phy_mii_ioctl(dev->phydev, ifr, cmd);
> +}

Thanks,
Richard
