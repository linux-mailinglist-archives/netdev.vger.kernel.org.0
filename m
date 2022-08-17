Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE1F597415
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237935AbiHQQYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240603AbiHQQYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:24:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21599C534
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 09:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660753477; x=1692289477;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AaQqWySqWIlvjPO4sEIcDj7cZ9WODvpljy7R6eBRYWQ=;
  b=dB4tPluVcUkIeaabAr80sHOMHAc249ZjwNlTjI79laIfv2eKdOouPM+B
   r5CBZX9ALmv4xsZMSiJ0QvN+BKbEis2jx7Az6yGY+RzC7j4D/ay1dK9ui
   oOWlejrP0nAM7iU+3zMOggNw68T52apFjul7S4A+CsLRtDLSEh5mIxAId
   eE+ULvOh3xiuzQyutpdXwTc/bRR001ihH6eZcanaFRszyIVhk/cFWELyy
   sIPRFAeFIe/FCLFTig2eGjY1P6dkB1RHpBr1RGSRHA71gsspxXs7kcvIY
   rIslOdTY83aC89J1GheTA0t40If1wr5dT8GLT42Iu13OjEnTndGk1ytEY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="354284067"
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="354284067"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 09:23:47 -0700
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="667692665"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.215.204.195]) ([10.215.204.195])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 09:23:42 -0700
Message-ID: <1bc73cf7-38d2-e30e-5d68-4a63a9186fd0@linux.intel.com>
Date:   Wed, 17 Aug 2022 21:53:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 2/5] net: wwan: t7xx: Infrastructure for early
 port configuration
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        m.chetan.kumar@intel.com
Cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
References: <20220816042340.2416941-1-m.chetan.kumar@intel.com>
 <5a74770-94d3-f690-4aa1-59cdbbb29339@linux.intel.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <5a74770-94d3-f690-4aa1-59cdbbb29339@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/2022 5:40 PM, Ilpo Järvinen wrote:
> On Tue, 16 Aug 2022, m.chetan.kumar@intel.com wrote:
> 
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>

<skip>

>> @@ -372,7 +435,8 @@ static int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *s
>>   
>>   	seq_num = t7xx_port_next_rx_seq_num(port, ccci_h);
>>   	port_conf = port->port_conf;
>> -	skb_pull(skb, sizeof(*ccci_h));
>> +	if (!port->port_conf->is_early_port)
>> +		skb_pull(skb, sizeof(*ccci_h));
> 
> This seems to be the only user for is_early_port, wouldn't be more obvious
> to store the header size instead?

Early port doesn't carry header.
If we change it to header size, skb_pull() operators on zero length. OR 
may need another such flag to bypass it.


-- 
Chetan
