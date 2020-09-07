Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24DD26060E
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 23:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgIGVKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 17:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgIGVK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 17:10:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D8172137B;
        Mon,  7 Sep 2020 21:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599513028;
        bh=UumymxLYqQ3OdFcuPJn2ZB1M+tzni4fLO4l47tqH7+k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZkHhuiu9ZoRLcegon6Y/AEMkvXigJt6M7xUdk/kLGxrtjXqKhVAlvA6HGeT9FJN6m
         LULLn7TGxYPs/2221nPMepiYegr0A2034KetdvY09R5iNIVvW4ELk+G0zB334V510e
         C74SUt/pUql/DMHv9a6kfyCTXaQlR01MAuFm8ShQ=
Date:   Mon, 7 Sep 2020 14:10:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mingming Cao <mmc@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.8 14/53] ibmvnic fix NULL tx_pools and
 rx_tools issue at do_reset
Message-ID: <20200907141026.093fc160@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907163220.1280412-14-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
        <20200907163220.1280412-14-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Sep 2020 12:31:40 -0400 Sasha Levin wrote:
> [ Upstream commit 9f13457377907fa253aef560e1a37e1ca4197f9b ]

> @@ -2024,10 +2033,14 @@ static int do_reset(struct ibmvnic_adapter *adapter,
>  		} else {
>  			rc = reset_tx_pools(adapter);
>  			if (rc)
> +				netdev_dbg(adapter->netdev, "reset tx pools failed (%d)\n",
> +						rc);
>  				goto out;
>  
>  			rc = reset_rx_pools(adapter);
>  			if (rc)
> +				netdev_dbg(adapter->netdev, "reset rx pools failed (%d)\n",
> +						rc);
>  				goto out;
>  		}
>  		ibmvnic_disable_irqs(adapter);

Hi Sasha!

I just pushed this to net:

8ae4dff882eb ("ibmvnic: add missing parenthesis in do_reset()")

You definitely want to pull that in if you decide to backport this one.
