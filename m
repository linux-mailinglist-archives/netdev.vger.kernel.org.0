Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 378D814C8E1
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 11:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgA2Kop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 05:44:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59200 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgA2Kop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 05:44:45 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83E8F15C04592;
        Wed, 29 Jan 2020 02:44:43 -0800 (PST)
Date:   Wed, 29 Jan 2020 11:44:36 +0100 (CET)
Message-Id: <20200129.114436.2049929524324371297.davem@davemloft.net>
To:     johnathanx.mantey@intel.com
Cc:     netdev@vger.kernel.org, sam@mendozajonas.com
Subject: Re: [PATCH ftgmac100:] Return link speed and duplex settings for
 the NCSI channel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ca1ed820-8da4-fad0-7335-ab92501e95a0@intel.com>
References: <ca1ed820-8da4-fad0-7335-ab92501e95a0@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 02:44:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johnathan Mantey <johnathanx.mantey@intel.com>
Date: Mon, 27 Jan 2020 11:17:50 -0800

> @@ -1218,10 +1218,30 @@ static int ftgmac100_set_pauseparam(struct
> net_device *netdev,

Please fix your email client so that the patch is not mangled like this.

>  	return 0;
>  }
> 
> +int ftgmac100_ethtool_get_link_ksettings(struct net_device *netdev,
> +					 struct ethtool_link_ksettings *cmd)
> +{
> +	struct phy_device *phydev = netdev->phydev;
> +	struct ftgmac100 *priv = netdev_priv(netdev);
> +	int retval = 0;
> +
> +	if (phydev) {
> +		phy_ethtool_ksettings_get(phydev, cmd);

This should be retval = phy_ethtool_ksettings_get() otherwise error indications
will not propagate.
