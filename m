Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D4F4B0B32
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240053AbiBJKpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 05:45:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiBJKpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:45:15 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42961FE2;
        Thu, 10 Feb 2022 02:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644489917; x=1676025917;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=M2CM5NfwpO/sk3E/JwzC7zio62b21QRytXCQjpt6TUY=;
  b=UaxkzIAVuqKqkM5t5xdGqOajIAbyQoWvwF6ehuVQoyFYEm0eltw16WFX
   +5ZEUmUZsb2i+ZUsYuD//qXt1T6JGz/jnw/cq9W/Li2UkmTLb+BL2r3Kj
   PbXeJ4jcE1/+Rsgp1h/lFpvhAxiLGii4hCvgh9FhUv3armgYF8yRlZkuI
   YiiGX2EbSTTYLLl/z1JRylBB4OZG7rKBZmZDfdyJOEV/W5IllSCIaE8n6
   y5seHZxLkwPpv1QeCne4rV2jqZn+PawaFjRWsf5wRL8eC3BrkfDNrwPqF
   9pweYE2aX03GJs+b2xXX2STUFsSuO0u2AyUZqMxp73z8gLvImgx7adQ0U
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249412374"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="249412374"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 02:45:16 -0800
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="541556883"
Received: from asamsono-mobl1.ccr.corp.intel.com ([10.252.41.247])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 02:45:10 -0800
Date:   Thu, 10 Feb 2022 12:45:04 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 09/13] net: wwan: t7xx: Add WWAN network
 interface
In-Reply-To: <20220114010627.21104-10-ricardo.martinez@linux.intel.com>
Message-ID: <a97968f-348c-ccb3-98c1-c58264a87c2d@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-10-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Creates the Cross Core Modem Network Interface (CCMNI) which implements
> the wwan_ops for registration with the WWAN framework, CCMNI also
> implements the net_device_ops functions used by the network device.
> Network device operations include open, close, start transmission, TX
> timeout, change MTU, and select queue.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---

> +static int t7xx_ccmni_open(struct net_device *dev)
> +{
> +	struct t7xx_ccmni *ccmni = wwan_netdev_drvpriv(dev);
> +
> +	netif_carrier_on(dev);
> +	netif_tx_start_all_queues(dev);
> +	atomic_inc(&ccmni->usage);
> +	return 0;
> +}
> +
> +static int t7xx_ccmni_close(struct net_device *dev)
> +{
> +	struct t7xx_ccmni *ccmni = wwan_netdev_drvpriv(dev);
> +
> +	if (atomic_dec_return(&ccmni->usage) < 0)
> +		return -EINVAL;

I'm certainly way out of my expertize here in knowing how/when these open 
and close can be called. That kept in mind, I wonder if there's need to do 
rollback for the atomic dec.

> +static void t7xx_ccmni_wwan_setup(struct net_device *dev)
> +{
> +	dev->header_ops = NULL;
> +	dev->hard_header_len += sizeof(struct ccci_header);
> +
> +	dev->mtu = ETH_DATA_LEN;
> +	dev->max_mtu = CCMNI_MTU_MAX;
> +	dev->tx_queue_len = DEFAULT_TX_QUEUE_LEN;
> +	dev->watchdog_timeo = CCMNI_NETDEV_WDT_TO;
> +	/* CCMNI is a pure IP device */
> +	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
> +
> +	/* Not supporting VLAN */
> +	dev->features = NETIF_F_VLAN_CHALLENGED;
> +
> +	dev->features |= NETIF_F_SG;
> +	dev->hw_features |= NETIF_F_SG;
> +
> +	/* Uplink checksum offload */
> +	dev->features |= NETIF_F_HW_CSUM;
> +	dev->hw_features |= NETIF_F_HW_CSUM;
> +
> +	/* Downlink checksum offload */
> +	dev->features |= NETIF_F_RXCSUM;
> +	dev->hw_features |= NETIF_F_RXCSUM;
> +
> +	/* Use kernel default free_netdev() function */
> +	dev->needs_free_netdev = true;
> +
> +	/* No need to free again because of free_netdev() */
> +	dev->priv_destructor = NULL;

Isn't the struct zeroed for you?

Maybe some of those comments are not that useful?


> +	ctlb->capability = NIC_CAP_TXBUSY_STOP | NIC_CAP_SGIO |
> +			   NIC_CAP_DATA_ACK_DVD | NIC_CAP_CCMNI_MQ;

Is capability going to remain constant? And some of these are
not used at all.

Related to this, e.g., the NETIF_F_SG setting above doesn't seem to care 
about what is in capability (assuming SGIO means what I think it does),
should it?

> +	/* WWAN core will create a netdev for the default IP MUX channel */
> +	ret = wwan_register_ops(dev, &ccmni_wwan_ops, ctlb, IP_MUX_SESSION_DEFAULT);
> +	if (ret)
> +		goto err_unregister_ops;
> +
> +	init_md_status_notifier(t7xx_dev);
> +
> +	return 0;
> +
> +err_unregister_ops:
> +	wwan_unregister_ops(dev);

If wwan_register_ops fails, why is wwan_unregister_ops needed?

> +/* Must be less than DPMAIF_HW_MTU_SIZE (3*1024 + 8) */

This could be enforced with BUILD_BUG_ON if you want.


-- 
 i.

