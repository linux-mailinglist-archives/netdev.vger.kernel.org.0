Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD5683DD7
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 01:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfHFXgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 19:36:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51356 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfHFXgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 19:36:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ACC2A15248635;
        Tue,  6 Aug 2019 16:36:14 -0700 (PDT)
Date:   Tue, 06 Aug 2019 14:51:04 -0700 (PDT)
Message-Id: <20190806.145104.1044990165298646882.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     ap420073@gmail.com, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, andrewx.bowers@intel.com
Subject: Re: [net] ixgbe: fix possible deadlock in ixgbe_service_task()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190805200403.23512-1-jeffrey.t.kirsher@intel.com>
References: <20190805200403.23512-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 16:36:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon,  5 Aug 2019 13:04:03 -0700

> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index cbaf712d6529..3386e752e458 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -7898,9 +7898,7 @@ static void ixgbe_service_task(struct work_struct *work)
>  	}
>  	if (ixgbe_check_fw_error(adapter)) {
>  		if (!test_bit(__IXGBE_DOWN, &adapter->state)) {
> -			rtnl_lock();
>  			unregister_netdev(adapter->netdev);
> -			rtnl_unlock();
>  		}

Please remove the (now unnecessary) curly braces for this basic block.

Thank you.
