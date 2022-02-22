Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9804C0183
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbiBVSlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiBVSlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:41:04 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5470BF50;
        Tue, 22 Feb 2022 10:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645555238; x=1677091238;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xLzY/JVcPeA2ZyBqUlgD1y5GcKLYipcldZvcW7Rqn6Q=;
  b=ik5Q0JL+yyPDPeecmNQP+H+9JiKJV9wYtRu7Z/8GbuWRkOtaNFAVrAYu
   V+N6lPciaXKrPH4CdqtnOuBCwUgMP06oBigQuCQIusWC7dfetnCYF7r0P
   CI56b+7yXJw9TuaM5pU00Go1IsCerz/T64UI/hO1jwgZnRmwwmEppkzMB
   82wlfhAv99ayFU3mCxETl6kqdl+dPexFTRYaPb+/1WNgYbU7f9x00BxFf
   VT6/vXeqcjpnTIZwMtKux1kAQUI5Y7HKSTvqI9PWTeDnJo7OZ2jiVO1Zw
   6ZoRisBIXU7qUcssQDQZFpZcppqIY3i5DDzZ7GH6Idnck213uunVSn9Zt
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="251971717"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="251971717"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 10:40:26 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="637115999"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.28.65]) ([10.209.28.65])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 10:40:25 -0800
Message-ID: <947eb9a4-683e-7d10-d15c-28e2f18d192d@linux.intel.com>
Date:   Tue, 22 Feb 2022 10:40:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net-next v4 08/13] net: wwan: t7xx: Add data path
 interface
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
 <20220114010627.21104-9-ricardo.martinez@linux.intel.com>
 <ca592f64-c581-56a8-8d90-5341ebd8932d@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <ca592f64-c581-56a8-8d90-5341ebd8932d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/8/2022 12:19 AM, Ilpo Järvinen wrote:
> On Thu, 13 Jan 2022, Ricardo Martinez wrote:
>
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
>> for initialization, ISR, control and event handling of TX/RX flows.
...
>> +	bat_req->bat_mask[idx] = 1;
> ...
>> +		if (!bat_req->bat_mask[index])
> ...
>> +		bat->bat_mask[index] = 0;
> Seem to be linux/bitmap.h
>
> I wonder though if the loop in t7xx_dpmaif_avail_pkt_bat_cnt()
> could be replaced with arithmetic calculation based on
> bat_release_rd_idx and some other idx? It would make the bitmap
> unnecessary.

A bitmap is needed since entries could be returned out of order.

...

>> +	hw_read_idx = t7xx_dpmaif_ul_get_rd_idx(&dpmaif_ctrl->hif_hw_info, q_num);
>> +
>> +	new_hw_rd_idx = hw_read_idx / DPMAIF_UL_DRB_ENTRY_WORD;
> Is DPMAIF_UL_DRB_ENTRY_WORD size of an entry? In that case it
> would probably make sense put it inside t7xx_dpmaif_ul_get_rd_idx?
Yes, moving this into t7xx_dpmaif_ul_get_rd_idx()
>> +	if (new_hw_rd_idx >= DPMAIF_DRB_ENTRY_SIZE) {
> Is DPMAIF_DRB_ENTRY_SIZE telling the number of entries rather than
> an "ENTRY_SIZE"? I think these both constant could likely be named
> better.
...
>> +static int t7xx_txq_burst_send_skb(struct dpmaif_tx_queue *txq)
>> +{
>> +	int drb_remain_cnt, i;
>> +	unsigned long flags;
>> +	int drb_cnt = 0;
>> +	int ret = 0;
>> +
>> +	spin_lock_irqsave(&txq->tx_lock, flags);
>> +	drb_remain_cnt = t7xx_ring_buf_rd_wr_count(txq->drb_size_cnt, txq->drb_release_rd_idx,
>> +						   txq->drb_wr_idx, DPMAIF_WRITE);
>> +	spin_unlock_irqrestore(&txq->tx_lock, flags);
>> +
>> +	for (i = 0; i < DPMAIF_SKB_TX_BURST_CNT; i++) {
>> +		struct sk_buff *skb;
>> +
>> +		spin_lock_irqsave(&txq->tx_skb_lock, flags);
>> +		skb = list_first_entry_or_null(&txq->tx_skb_queue, struct sk_buff, list);
>> +		spin_unlock_irqrestore(&txq->tx_skb_lock, flags);
>> +
>> +		if (!skb)
>> +			break;
>> +
>> +		if (drb_remain_cnt < skb->cb[TX_CB_DRB_CNT]) {
>> +			spin_lock_irqsave(&txq->tx_lock, flags);
>> +			drb_remain_cnt = t7xx_ring_buf_rd_wr_count(txq->drb_size_cnt,
>> +								   txq->drb_release_rd_idx,
>> +								   txq->drb_wr_idx, DPMAIF_WRITE);
>> +			spin_unlock_irqrestore(&txq->tx_lock, flags);
>> +			continue;
>> +		}
> ...
>> +	if (drb_cnt > 0) {
>> +		txq->drb_lack = false;
>> +		ret = drb_cnt;
>> +	} else if (ret == -ENOMEM) {
>> +		txq->drb_lack = true;
> Based on the variable name, I'd expect drb_lack be set true when
> drb_remain_cnt < skb->cb[TX_CB_DRB_CNT] occurred but that doesn't
> happen. Maybe that if branch within loop should set ret = -ENOMEM;
> before continue?

This drb_lack logic is going to be dropped since it was intended for

multiple Tx queues but currently only one is used.

> It would be nice if the drb check here and in
> t7xx_check_tx_queue_drb_available could be consolidated into
> a single place. That requires small refactoring (adding __
> variant of that function which does just the check).
>
> Please also check the other comments on skb->cb below.
...
>
>> +int t7xx_dpmaif_tx_send_skb(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int txqt, struct sk_buff *skb)
>> +{
>> +	bool tx_drb_available = true;
> ...
>> +	send_drb_cnt = t7xx_get_drb_cnt_per_skb(skb);
>> +
>> +	txq = &dpmaif_ctrl->txq[txqt];
>> +	if (!(txq->tx_skb_stat++ % DPMAIF_SKB_TX_BURST_CNT))
>> +		tx_drb_available = t7xx_check_tx_queue_drb_available(txq, send_drb_cnt);
>> +
>> +	if (!tx_drb_available || txq->tx_submit_skb_cnt >= txq->tx_list_max_len) {
> Because of the modulo if, drbs might not be available despite
> variable claims them to be. Is it intentional?

It is intentional, I'll refactor this to do the  DRB and tx_list_max_len 
checks independently for clarity.

...


