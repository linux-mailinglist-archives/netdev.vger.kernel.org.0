Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D332520C4F9
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 02:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgF1A24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 20:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgF1A2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 20:28:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA5BC061794
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 17:28:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 353F013404B18;
        Sat, 27 Jun 2020 17:28:55 -0700 (PDT)
Date:   Sat, 27 Jun 2020 17:28:54 -0700 (PDT)
Message-Id: <20200627.172854.1616926333918264313.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     sasha.neftin@intel.com, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, andre.guedes@intel.com,
        aaron.f.brown@intel.com
Subject: Re: [net-next 01/13] igc: Add initial EEE support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200627015431.3579234-2-jeffrey.t.kirsher@intel.com>
References: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
        <20200627015431.3579234-2-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jun 2020 17:28:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 26 Jun 2020 18:54:19 -0700

> +static int igc_ethtool_get_eee(struct net_device *netdev,
> +			       struct ethtool_eee *edata)
> +{
> +	struct igc_adapter *adapter = netdev_priv(netdev);
> +	struct igc_hw *hw = &adapter->hw;
> +	u32 eeer;
> +
> +	if (hw->dev_spec._base.eee_enable)
> +		edata->advertised =
> +			mmd_eee_adv_to_ethtool_adv_t(adapter->eee_advert);
> +
> +	*edata = adapter->eee;
> +	edata->supported = SUPPORTED_Autoneg;
> +	netdev_info(netdev,
> +		    "Supported EEE link modes: 100baseT/Full, 1000baseT/Full, 2500baseT/Full\n");

I don't think you want to print a kernel log message every time someone
executes an ethtool query like this.

Please remove this.
