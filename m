Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733D12192D0
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgGHVtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgGHVtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 17:49:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4240E206C3;
        Wed,  8 Jul 2020 21:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594244942;
        bh=jrrQ/BCtBiJFJ0A4cBfc8WXlQN52IDVeYFYN+UZ+OnI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OAHJIW0Lm1fkcXmUwnKqgomGJjh6xxHYHYrdMeUf+r6AQylVIoX7rBjr8ecaJ/0qq
         /MFX6HNaSUIohx5KtFtKzO+nCYN8UEKf+JBAim9G/OuuE2z1KgfkUsC5kDbz3YySUj
         +YDtWymRGUaQ77ZZtaHUnAeCPPXYFuRMEqf5uBWc=
Date:   Wed, 8 Jul 2020 14:49:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Ooi, Joyce" <joyce.ooi@intel.com>
Cc:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>
Subject: Re: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Message-ID: <20200708144900.058a8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200708072401.169150-10-joyce.ooi@intel.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
        <20200708072401.169150-10-joyce.ooi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jul 2020 15:24:00 +0800 Ooi, Joyce wrote:
> +		/* get prefetcher rx poll frequency from device tree */
> +		if (of_property_read_u32(pdev->dev.of_node, "rx-poll-freq",
> +					 &priv->rx_poll_freq)) {
> +			dev_info(&pdev->dev, "Defaulting RX Poll Frequency to 128\n");
> +			priv->rx_poll_freq = 128;
> +		}
> +
> +		/* get prefetcher rx poll frequency from device tree */
> +		if (of_property_read_u32(pdev->dev.of_node, "tx-poll-freq",
> +					 &priv->tx_poll_freq)) {
> +			dev_info(&pdev->dev, "Defaulting TX Poll Frequency to 128\n");
> +			priv->tx_poll_freq = 128;
> +		}

I'm no device tree expert but these look like config options rather than
HW description. They also don't appear to be documented in the next
patch.
