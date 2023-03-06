Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A5B6ADB8C
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 11:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCGKP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 05:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjCGKP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 05:15:27 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9982129C
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 02:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678184126; x=1709720126;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=/YdWZNh0t2y/ak7Jvo4SVilCrbIglF3/wkSfwXR8kEQ=;
  b=Y7UzLaLL4lwFhILFWhCRHc+46CHeqdqSa0XYUalk014yYu57EbTWjSNx
   rAkQ/AfoHAYj3HjbEEsJEttFFw0sL003sewPPD5CIrqAnrlf7O/BVniIv
   lTEZSQJN5M/CqkmSgg+BdR60h1DPmLGSueVB0yh0jK6++MQ59bEzx8rbs
   k=;
X-IronPort-AV: E=Sophos;i="5.98,240,1673913600"; 
   d="scan'208";a="190476982"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 10:15:23 +0000
Received: from EX19D007EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id 141F1810BA;
        Tue,  7 Mar 2023 10:15:22 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D007EUA004.ant.amazon.com (10.252.50.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 7 Mar 2023 10:15:21 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 7 Mar 2023 10:15:13 +0000
References: <20230302203045.4101652-1-shayagr@amazon.com>
 <20230302203045.4101652-3-shayagr@amazon.com>
 <ZAHfVNAgzgEZNByU@corigine.com>
User-agent: mu4e 1.8.13; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        David Arinzon <darinzon@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH RFC v2 net-next 2/4] net: ena: Add an option to
 configure large LLQ headers
Date:   Mon, 6 Mar 2023 11:27:56 +0200
In-Reply-To: <ZAHfVNAgzgEZNByU@corigine.com>
Message-ID: <pj41zlpm9k27h0.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D033UWA001.ant.amazon.com (10.13.139.103) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Simon Horman <simon.horman@corigine.com> writes:

> On Thu, Mar 02, 2023 at 10:30:43PM +0200, Shay Agroskin wrote:
>> From: David Arinzon <darinzon@amazon.com>
>> 
>> Allow configuring the device with large LLQ headers. The Low 
>> Latency
>> Queue (LLQ) allows the driver to write the first N bytes of the 
>> packet,
>> along with the rest of the TX descriptors directly into device 
>> (N can be
>> either 96 or 224 for large LLQ headers configuration).
>> 
>> Having L4 TCP/UDP headers contained in the first 96 bytes of 
>> the packet
>> is required to get maximum performance from the device.
>> 
>> Signed-off-by: David Arinzon <darinzon@amazon.com>
>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>
> Overall this looks very nice to me, its a very interesting HW 
> feature.
>
> As this is an RFC I've made a few nit-picking comments inline.
> Those not withstanding,
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>

Thanks for reviewing this patchset (:
>> ---
>>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 100 
>>  ++++++++++++++-----
>>  drivers/net/ethernet/amazon/ena/ena_netdev.h |   8 ++
>>  2 files changed, 84 insertions(+), 24 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
>> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> index d3999db7c6a2..830d5be22aa9 100644
>> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> @@ -44,6 +44,8 @@ static int ena_rss_init_default(struct 
>> ena_adapter *adapter);
>>  static void check_for_admin_com_state(struct ena_adapter 
>>  *adapter);
>>  static void ena_destroy_device(struct ena_adapter *adapter, 
>>  bool graceful);
>>  static int ena_restore_device(struct ena_adapter *adapter);
>> +static void ena_calc_io_queue_size(struct ena_adapter 
>> *adapter,
>> +				   struct 
>> ena_com_dev_get_features_ctx *get_feat_ctx);
>>  
>
> FWIIW, I think it is nicer to move functions rather than provide 
> forward
> declarations. That could be done in a preparatory patch if you 
> want
> to avoid crowding out the intentions of this this patch.
>

Seeing that it is indeed called only once it does make more sense 
just to move the function implementation itself

>>  static void ena_init_io_rings(struct ena_adapter *adapter,
>>  			      int first_index, int count);
>> @@ -3387,13 +3389,30 @@ static int 
>> ena_device_validate_params(struct ena_adapter *adapter,
>>  	return 0;
>>  }
>>  
>> -static void set_default_llq_configurations(struct 
>> ena_llq_configurations *llq_config)
>> +static void set_default_llq_configurations(struct ena_adapter 
>> *adapter,
>> +					   struct 
>> ena_llq_configurations *llq_config,
>> +					   struct 
>> ena_admin_feature_llq_desc *llq)
>>  {
>> +	struct ena_com_dev *ena_dev = adapter->ena_dev;
>> +
>>  	llq_config->llq_header_location = ENA_ADMIN_INLINE_HEADER;
>>  	llq_config->llq_stride_ctrl = 
>>  ENA_ADMIN_MULTIPLE_DESCS_PER_ENTRY;
>>  	llq_config->llq_num_decs_before_header = 
>>  ENA_ADMIN_LLQ_NUM_DESCS_BEFORE_HEADER_2;
>> -	llq_config->llq_ring_entry_size = 
>> ENA_ADMIN_LIST_ENTRY_SIZE_128B;
>> -	llq_config->llq_ring_entry_size_value = 128;
>> +
>> +	adapter->large_llq_header_supported =
>> +		!!(ena_dev->supported_features & (1 << 
>> ENA_ADMIN_LLQ));
>
> nit: BIT(ENA_ADMIN_LLQ)
>

Yup, I'll change to it

> ...
>
>> @@ -3587,7 +3609,8 @@ static int 
>> ena_enable_msix_and_set_admin_interrupts(struct ena_adapter 
>> *adapter)
>>  	return rc;
>>  }
>>  
>> -static void ena_destroy_device(struct ena_adapter *adapter, 
>> bool graceful)
>> +static
>> +void ena_destroy_device(struct ena_adapter *adapter, bool 
>> graceful)
>
> nit: this change seems unrelated to the rest of this patch.
>

I'll remove it

>>  {
>>  	struct net_device *netdev = adapter->netdev;
>>  	struct ena_com_dev *ena_dev = adapter->ena_dev;
>> @@ -3633,7 +3656,8 @@ static void ena_destroy_device(struct 
>> ena_adapter *adapter, bool graceful)
>>  	clear_bit(ENA_FLAG_DEVICE_RUNNING, &adapter->flags);
>>  }
>>  
>> -static int ena_restore_device(struct ena_adapter *adapter)
>> +static
>> +int ena_restore_device(struct ena_adapter *adapter)
>
> Ditto.
>
> ...
>

I'll remove it

>> @@ -4333,7 +4384,6 @@ static int ena_probe(struct pci_dev 
>> *pdev, const struct pci_device_id *ent)
>>  	ena_dev->intr_moder_rx_interval = 
>>  ENA_INTR_INITIAL_RX_INTERVAL_USECS;
>>  	ena_dev->intr_delay_resolution = 
>>  ENA_DEFAULT_INTR_DELAY_RESOLUTION;
>>  	max_num_io_queues = ena_calc_max_io_queue_num(pdev, 
>>  ena_dev, &get_feat_ctx);
>> -	ena_calc_io_queue_size(adapter, &get_feat_ctx);
>>  	if (unlikely(!max_num_io_queues)) {
>>  		rc = -EFAULT;
>>  		goto err_device_destroy;
>> @@ -4366,6 +4416,7 @@ static int ena_probe(struct pci_dev 
>> *pdev, const struct pci_device_id *ent)
>>  			"Failed to query interrupt moderation 
>>  feature\n");
>>  		goto err_device_destroy;
>>  	}
>> +
>
> nit: this change seems unrelated to the rest of this patch.
>

These are cosmetic little changes to improve code 
readability. I'll just create an additional simple commit that 
adds them.

>>  	ena_init_io_rings(adapter,
>>  			  0,
>>  			  adapter->xdp_num_queues +
>> @@ -4486,6 +4537,7 @@ static void __ena_shutoff(struct pci_dev 
>> *pdev, bool shutdown)
>>  	rtnl_lock(); /* lock released inside the below if-else 
>>  block */
>>  	adapter->reset_reason = ENA_REGS_RESET_SHUTDOWN;
>>  	ena_destroy_device(adapter, true);
>> +
>
> Ditto.
>

I'll move it to another patch

>>  	if (shutdown) {
>>  		netif_device_detach(netdev);
>>  		dev_close(netdev);
>
> ...

