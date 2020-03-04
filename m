Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD28E178981
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgCDEYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:24:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgCDEYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 23:24:16 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71BC420838;
        Wed,  4 Mar 2020 04:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583295856;
        bh=JOfa1U0FQ87xOvgyIMmNZNmR/dOV/u6u2JTeq7u0kvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V/Nt2GimoeUuWOhImMk4YuX2O5y+X6ziQFOPNsAuyOQ+HLNCHcGuHgtLBBZR7ZH+L
         jqU97tnz8QRjrgm4UAgkNxV+gmOxIijLYwJnfJg7Y/5nW51dHvZfQGl2Z8YLMtGUae
         iEzr2/WZyBqxU6njoHyywscowYp7UQPRbaNORwGs=
Date:   Tue, 3 Mar 2020 20:24:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 08/12] ice: let core reject the unsupported
 coalescing parameters
Message-ID: <20200303202413.6a312c3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200304035501.628139-9-kuba@kernel.org>
References: <20200304035501.628139-1-kuba@kernel.org>
        <20200304035501.628139-9-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Mar 2020 19:54:57 -0800 Jakub Kicinski wrote:
> @@ -3817,6 +3761,9 @@ ice_get_module_eeprom(struct net_device *netdev,
>  }
>  
>  static const struct ethtool_ops ice_ethtool_ops = {
> +	.coalesce_types = ETHTOOL_COALESCE_USECS |
> +			  ETHTOOL_COALESCE_USE_ADAPTIVE_RX |

Triple checking now this should have been ETHTOOL_COALESCE_USE_ADAPTIVE,
as TX also works. Let me resend, sorry for the noise.. :(

> +			  ETHTOOL_COALESCE_RX_USECS_HIGH,
>  	.get_link_ksettings	= ice_get_link_ksettings,
>  	.set_link_ksettings	= ice_set_link_ksettings,
>  	.get_drvinfo		= ice_get_drvinfo,

