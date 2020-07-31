Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424B1234C42
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 22:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgGaU1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 16:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729014AbgGaU1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 16:27:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A55152087C;
        Fri, 31 Jul 2020 20:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596227253;
        bh=usbF6gZS0cou6TC+rn8VqAayqyhLVXIlSpF1z9kMBdE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ud5yi5aVh8V4KQZjvVRLEFH7FdbK2xHT8goqCuMGx+UPm1hLsNDR90AZ3CRWRzfVS
         3vwcHSwO9RrLwK3Suw7WdjXt37cltk+D+jQiGfdaJ2SPjk6mCcVVHj8Ar5gL/KeVCr
         eegeQh1pLXmy4bFjuGTbck+8IWVaz+X18UNqEZzo=
Date:   Fri, 31 Jul 2020 13:27:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 08/11] sfc_ef100: statistics gathering
Message-ID: <20200731132732.2ddf3db6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <64c11143-4749-5891-85eb-c312f1de721e@solarflare.com>
References: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
        <64c11143-4749-5891-85eb-c312f1de721e@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jul 2020 14:00:24 +0100 Edward Cree wrote:
> +	core_stats->rx_packets = stats[EF100_STAT_port_rx_packets];
> +	core_stats->tx_packets = stats[EF100_STAT_port_tx_packets];
> +	core_stats->rx_bytes = stats[EF100_STAT_port_rx_bytes];
> +	core_stats->tx_bytes = stats[EF100_STAT_port_tx_bytes];

> +	core_stats->multicast = stats[EF100_STAT_port_rx_multicast];

> +	core_stats->rx_crc_errors = stats[EF100_STAT_port_rx_bad];
> +	core_stats->rx_frame_errors =
> +			stats[EF100_STAT_port_rx_align_error];
> +	core_stats->rx_fifo_errors = stats[EF100_STAT_port_rx_overflow];

Since this is a new driver please stop reporting this in ethtool.
They clearly have a perfect match with the standard stats there is 
no need for duplication.
