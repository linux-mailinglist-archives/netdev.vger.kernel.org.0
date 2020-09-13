Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D49267F4B
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 13:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgIMLD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 07:03:59 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:17819 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgIMLDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 07:03:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599995031; x=1631531031;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=JPqkWOIRFmR6XWe+wPkArUVRUL+EGbiVYPSdNAyk2+4=;
  b=bxX3e03MEz98re+fD422ihNCdOhiMzh5W9GrXf6DzVjnthgJAlo/Qzew
   MU4O4IcZTsYZEWPTE8YqEXZ8MVXbiYJTzs5+QScSBQtg88VGOsngZwrm4
   5CNsOsu9IyJyGRgTcg5evqCGLjwC4B4mODFaM0vZBCJapVfE01Z/2HADt
   o=;
X-IronPort-AV: E=Sophos;i="5.76,421,1592870400"; 
   d="scan'208";a="53414756"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 13 Sep 2020 11:03:49 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 2F54AA23F4;
        Sun, 13 Sep 2020 11:03:48 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.160.183) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 13 Sep 2020 11:03:39 +0000
References: <20200913082056.3610-6-shayagr@amazon.com>
User-agent: mu4e 1.4.12; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: Re: [PATCH V1 net-next 5/8] net: ena: Remove redundant print of placement policy
In-Reply-To: <20200913082056.3610-6-shayagr@amazon.com>
Date:   Sun, 13 Sep 2020 14:03:24 +0300
Message-ID: <pj41zlsgbmdjlv.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.183]
X-ClientProxiedBy: EX13D50UWA001.ant.amazon.com (10.43.163.46) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Shay Agroskin <shayagr@amazon.com> writes:

> The placement policy is printed in the process of queue creation 
> in
> ena_up(). No need to print it in ena_probe().
>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index cab83a9de651..97e701222226 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -4156,7 +4156,6 @@ static int ena_probe(struct pci_dev *pdev, 
> const struct pci_device_id *ent)
>  	struct net_device *netdev;
>  	static int adapters_found;
>  	u32 max_num_io_queues;
> -	char *queue_type_str;
>  	bool wd_state;
>  	int bars, rc;
>  
> @@ -4334,15 +4333,10 @@ static int ena_probe(struct pci_dev 
> *pdev, const struct pci_device_id *ent)
>  	timer_setup(&adapter->timer_service, ena_timer_service, 
>  0);
>  	mod_timer(&adapter->timer_service, round_jiffies(jiffies + 
>  HZ));
>  
> -	if (ena_dev->tx_mem_queue_type == 
> ENA_ADMIN_PLACEMENT_POLICY_HOST)
> -		queue_type_str = "Regular";
> -	else
> -		queue_type_str = "Low Latency";
> -
>  	dev_info(&pdev->dev,
> -		 "%s found at mem %lx, mac addr %pM, Placement 
> policy: %s\n",
> +		 "%s found at mem %lx, mac addr %pM\n",
>  		 DEVICE_NAME, (long)pci_resource_start(pdev, 0),
> -		 netdev->dev_addr, queue_type_str);
> +		 netdev->dev_addr);
>  
>  	set_bit(ENA_FLAG_DEVICE_RUNNING, &adapter->flags);

Hi, I got this patchset messed up a little. These patches are part 
of the 'Update license and polish ENA driver code' patchset 
(Message-id: <20200913081640.19560-1-shayagr@amazon.com>)
Sorry for the clutter. Please let me know it you prefer that I 
re-send this patchset as a single thread
