Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D2D1696E2
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 09:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgBWIyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 03:54:55 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:25805 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgBWIyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 03:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582448094; x=1613984094;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=SNDZqfsE1FeOVBV0ERULQsptio2vQqgGGVSaYknQC7I=;
  b=I9Ql0ZMeqSatLEDs7KwmG7K8tTNe46aMRgLetl6Xs2me8Q7i5auIB2G6
   5Cy21v3rur0uetHWAWfRp4L9rGryDI9lG/VNzMgyornwyq9KJ2kM+TqdH
   Ec/XSTbjdK54S0pBROwUHLskVVhRgi0dBvVkfgdxL1cmagldlgdv0880o
   g=;
IronPort-SDR: c82jz6Qgt65E+lfYqeJbLjpDsmSinWdIX10ZVssmhRNvSmzcoZRoRiQJ4BOJIgHNSzHvp4o97p
 i/RMoRJeU3zA==
X-IronPort-AV: E=Sophos;i="5.70,475,1574121600"; 
   d="scan'208";a="18472173"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 23 Feb 2020 08:54:42 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 9D671A2872;
        Sun, 23 Feb 2020 08:54:40 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Sun, 23 Feb 2020 08:54:39 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.160.8) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 23 Feb 2020 08:54:34 +0000
Subject: Re: [PATCH net-next 11/16] net/amazon: Ensure that driver version is
 aligned to the linux kernel
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>
References: <20200220145855.255704-1-leon@kernel.org>
 <20200220145855.255704-12-leon@kernel.org>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <fb459df1-a1f7-964c-74a9-2f8e7a4ba26b@amazon.com>
Date:   Sun, 23 Feb 2020 10:54:29 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200220145855.255704-12-leon@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.8]
X-ClientProxiedBy: EX13D14UWC002.ant.amazon.com (10.43.162.214) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/02/2020 16:58, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> 
> Upstream drivers are managed inside global repository and released all
> together, this ensure that driver version is the same as linux kernel,
> so update amazon drivers to properly reflect it.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c |  1 -
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 17 ++---------------
>  drivers/net/ethernet/amazon/ena/ena_netdev.h  | 11 -----------
>  3 files changed, 2 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> index ced1d577b62a..19262f37db84 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> @@ -404,7 +404,6 @@ static void ena_get_drvinfo(struct net_device *dev,
>  	struct ena_adapter *adapter = netdev_priv(dev);
> 
>  	strlcpy(info->driver, DRV_MODULE_NAME, sizeof(info->driver));
> -	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
>  	strlcpy(info->bus_info, pci_name(adapter->pdev),
>  		sizeof(info->bus_info));
>  }
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 0b2fd96b93d7..4faf81c456d8 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -49,12 +49,9 @@
>  #include <linux/bpf_trace.h>
>  #include "ena_pci_id_tbl.h"
> 
> -static char version[] = DEVICE_NAME " v" DRV_MODULE_VERSION "\n";
> -
>  MODULE_AUTHOR("Amazon.com, Inc. or its affiliates");
>  MODULE_DESCRIPTION(DEVICE_NAME);
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(DRV_MODULE_VERSION);
> 
>  /* Time in jiffies before concluding the transmitter is hung. */
>  #define TX_TIMEOUT  (5 * HZ)
> @@ -3093,11 +3090,7 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev,
>  	host_info->os_dist = 0;
>  	strncpy(host_info->os_dist_str, utsname()->release,
>  		sizeof(host_info->os_dist_str) - 1);
> -	host_info->driver_version =
> -		(DRV_MODULE_VER_MAJOR) |
> -		(DRV_MODULE_VER_MINOR << ENA_ADMIN_HOST_INFO_MINOR_SHIFT) |
> -		(DRV_MODULE_VER_SUBMINOR << ENA_ADMIN_HOST_INFO_SUB_MINOR_SHIFT) |
> -		("K"[0] << ENA_ADMIN_HOST_INFO_MODULE_TYPE_SHIFT);
> +	host_info->driver_version = LINUX_VERSION_CODE;

Hey Leon,
I'm not sure it's safe to replace this one, adding ENA people..
