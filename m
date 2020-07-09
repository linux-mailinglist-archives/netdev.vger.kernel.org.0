Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEAB219F15
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 13:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgGILba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 07:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgGILba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 07:31:30 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F15DC061A0B;
        Thu,  9 Jul 2020 04:31:30 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a14so910418pfi.2;
        Thu, 09 Jul 2020 04:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sXEmKxMUQPh+anjWf/TN85kjSCFF6dnVSzbWyKgc7V8=;
        b=JiGJzxiL6Of4/SizVoILjcNlJp9Wzoh1P+aJZskAC5LRDAjD/Lv4QBsgDH3XMjSqVP
         SEpNt2YQDTSmXX9MEKd2Z+e2aGpZMn4/5bHkKo3tOPw3m3g8ofiIEpZW+eT6o3YCz3/B
         j+qa3N4UeVuxrnuiGbSw7LpcnaeuvwvpxxoU5rTl9gu+rUmzHD00pToInuZ2dV0hEYXn
         gDNCiunYDscpN70u3dPO6sl7ddpR78BobQdepS+WbRVLC3KhzXNVL9AgFwG8yJW1DMgt
         yp+h/4sQL/sFbPFvphompDeg+XySw4idQrQBGQ7XaL7KOXY3ZmF/jYfbebeE41BeOIc2
         nymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sXEmKxMUQPh+anjWf/TN85kjSCFF6dnVSzbWyKgc7V8=;
        b=gApH9djCxN3TOk5GAOc3OUcm1Q24PsiQ2lBWcDM80OMD3X9w8WcnrylHh4n91nLy35
         s01r33rHlw/RH8FQNeZvC9DVqfdV/x9kcmbEThKWdrRxzx2b1sl+Jka3gd+yV7TZyB5n
         J1WcnEydf2sBGQ/arMQj0C5Vn7XTVf9JustqeadbQAkD4X05oU8GNMxdrC994BEshCCz
         BdGE8u5xkJtYrKj4q7/lKOMVomL1JOb31REagaANmsfaNCueyeqNxHYA4jRxbGuNnDyM
         Ug6417pTc//cvVC/bKH98iCY1eLBHoPWhkla3EPuFblyKV5tKSNHuxgDW0/VFsCD67wY
         m7ow==
X-Gm-Message-State: AOAM531mc1+i0uer7hKOTgL3yhxKc1x1O74C/kknqYtPSJ97FkU3sddA
        IpT6R7FZ9hI3oH8ShKB2l80=
X-Google-Smtp-Source: ABdhPJxU4JlBuhXofkSOx2RQJ3pZUvyTfO/HTtm9Kxbvz8m7rRAF9ouXaGbcl7QNg0MmjhvADxzNzw==
X-Received: by 2002:a63:e045:: with SMTP id n5mr56526701pgj.274.1594294289690;
        Thu, 09 Jul 2020 04:31:29 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id z26sm2601293pfr.187.2020.07.09.04.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 04:31:28 -0700 (PDT)
Date:   Thu, 9 Jul 2020 04:31:26 -0700
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
Subject: Re: [PATCH v4 08/10] net: eth: altera: add support for ptp and
 timestamping
Message-ID: <20200709113126.GA776@hoboy>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
 <20200708072401.169150-9-joyce.ooi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708072401.169150-9-joyce.ooi@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 03:23:59PM +0800, Ooi, Joyce wrote:

> @@ -222,6 +223,32 @@ static void tse_get_regs(struct net_device *dev, struct ethtool_regs *regs,
>  		buf[i] = csrrd32(priv->mac_dev, i * 4);
>  }
>  
> +static int tse_get_ts_info(struct net_device *dev,
> +			   struct ethtool_ts_info *info)
> +{
> +	struct altera_tse_private *priv = netdev_priv(dev);
> +
> +	if (priv->ptp_enable) {
> +		if (priv->ptp_priv.ptp_clock)
> +			info->phc_index =
> +				ptp_clock_index(priv->ptp_priv.ptp_clock);

Need to handle case where priv->ptp_priv.ptp_clock == NULL.

> +		info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
> +					SOF_TIMESTAMPING_RX_HARDWARE |
> +					SOF_TIMESTAMPING_RAW_HARDWARE;
> +
> +		info->tx_types = (1 << HWTSTAMP_TX_OFF) |
> +						 (1 << HWTSTAMP_TX_ON);

No need to break statement.  This fits nicely on one line.

> +
> +		info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
> +						   (1 << HWTSTAMP_FILTER_ALL);
> +
> +		return 0;
> +	} else {

No need for else block.

> +		return ethtool_op_get_ts_info(dev, info);
> +	}
> +}
> +
>  static const struct ethtool_ops tse_ethtool_ops = {
>  	.get_drvinfo = tse_get_drvinfo,
>  	.get_regs_len = tse_reglen,


> @@ -1309,6 +1324,83 @@ static int tse_shutdown(struct net_device *dev)
>  	return 0;
>  }
>  
> +/* ioctl to configure timestamping */
> +static int tse_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
> +{
> +	struct altera_tse_private *priv = netdev_priv(dev);
> +	struct hwtstamp_config config;

Need to check here for phy_has_hwtstamp() and pass through to PHY
layer if true.

> +
> +	if (!netif_running(dev))
> +		return -EINVAL;
> +
> +	if (!priv->ptp_enable)	{
> +		netdev_alert(priv->dev, "Timestamping not supported");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (cmd == SIOCSHWTSTAMP) {
> +		if (copy_from_user(&config, ifr->ifr_data,
> +				   sizeof(struct hwtstamp_config)))
> +			return -EFAULT;
> +
> +		if (config.flags)
> +			return -EINVAL;
> +
> +		switch (config.tx_type) {
> +		case HWTSTAMP_TX_OFF:
> +			priv->hwts_tx_en = 0;
> +			break;
> +		case HWTSTAMP_TX_ON:
> +			priv->hwts_tx_en = 1;
> +			break;
> +		default:
> +			return -ERANGE;
> +		}
> +
> +		switch (config.rx_filter) {
> +		case HWTSTAMP_FILTER_NONE:
> +			priv->hwts_rx_en = 0;
> +			config.rx_filter = HWTSTAMP_FILTER_NONE;
> +			break;
> +		default:
> +			priv->hwts_rx_en = 1;
> +			config.rx_filter = HWTSTAMP_FILTER_ALL;
> +			break;
> +		}
> +
> +		if (copy_to_user(ifr->ifr_data, &config,
> +				 sizeof(struct hwtstamp_config)))
> +			return -EFAULT;
> +		else
> +			return 0;
> +	}
> +
> +	if (cmd == SIOCGHWTSTAMP) {
> +		config.flags = 0;
> +
> +		if (priv->hwts_tx_en)
> +			config.tx_type = HWTSTAMP_TX_ON;
> +		else
> +			config.tx_type = HWTSTAMP_TX_OFF;
> +
> +		if (priv->hwts_rx_en)
> +			config.rx_filter = HWTSTAMP_FILTER_ALL;
> +		else
> +			config.rx_filter = HWTSTAMP_FILTER_NONE;
> +
> +		if (copy_to_user(ifr->ifr_data, &config,
> +				 sizeof(struct hwtstamp_config)))
> +			return -EFAULT;
> +		else
> +			return 0;
> +	}
> +
> +	if (!dev->phydev)
> +		return -EINVAL;
> +
> +	return phy_mii_ioctl(dev->phydev, ifr, cmd);
> +}
> +
>  static struct net_device_ops altera_tse_netdev_ops = {
>  	.ndo_open		= tse_open,
>  	.ndo_stop		= tse_shutdown,


> @@ -1568,6 +1661,27 @@ static int altera_tse_probe(struct platform_device *pdev)
>  		netdev_err(ndev, "Cannot attach to PHY (error: %d)\n", ret);
>  		goto err_init_phy;
>  	}
> +
> +	priv->ptp_enable = of_property_read_bool(pdev->dev.of_node,
> +						 "altr,has-ptp");

The name "ptp_enable" is a poor choice.  It sounds like something that
can be enabled at run time.  Suggest "has_ptp" instead.

> +	dev_info(&pdev->dev, "PTP Enable: %d\n", priv->ptp_enable);
> +
> +	if (priv->ptp_enable) {
> +		/* MAP PTP */
> +		ret = intel_fpga_tod_probe(pdev, &priv->ptp_priv);
> +		if (ret) {
> +			dev_err(&pdev->dev, "cannot map PTP\n");
> +			goto err_init_phy;
> +		}
> +		ret = intel_fpga_tod_register(&priv->ptp_priv,
> +					      priv->device);
> +		if (ret) {
> +			dev_err(&pdev->dev, "Failed to register PTP clock\n");
> +			ret = -ENXIO;
> +			goto err_init_phy;
> +		}
> +	}
> +
>  	return 0;
>  
>  err_init_phy:


> +/* Initialize PTP control block registers */
> +int intel_fpga_tod_init(struct intel_fpga_tod_private *priv)
> +{
> +	struct timespec64 now;
> +	int ret = 0;
> +
> +	ret = intel_fpga_tod_adjust_fine(&priv->ptp_clock_ops, 0l);

Why clobber a learned frequency offset here?  If user space closes
then re-opens, then it expects the old frequency to be preserved.

It is fine to set this to zero when the driver loads, but not after.

> +	if (ret != 0)
> +		goto out;
> +
> +	/* Initialize the hardware clock to the system time */
> +	ktime_get_real_ts64(&now);

Please initialize to zero instead, as some people prefer it that way.

(But only the first time when the driver loads!)

> +	intel_fpga_tod_set_time(&priv->ptp_clock_ops, &now);
> +
> +	spin_lock_init(&priv->tod_lock);
> +
> +out:
> +	return ret;
> +}

Thanks,
Richard
