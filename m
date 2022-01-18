Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB7B49309C
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349865AbiARWWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:22:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:37200 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349846AbiARWWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 17:22:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642544530; x=1674080530;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sNPUM+qRmsPiTphVYBIIBrvPwmB4t+WjPBDWdLipk24=;
  b=PfZHNPGAjLvIt3MsBvfx0DhfmdfJZuv3Psf97mxMv6Ozk5L+oIqnnmVm
   Xp0tMtv+uf1/lRS3m6aL+h8V90pqS581tu6DM/50APBb83kXK2bbEQCBQ
   DRJLGwVri/6O9Ba2vI+4lT/RuB08RSQ+45QGBw3/nELyzS2ky/u5bTI4J
   spUlRf8IghPy+AVCE8JGgNg5Mx/CUTD9oxR3+5AB0hNO0w8kMdYGlPeBK
   S0kAt+o9Lk7g9Q4L3pKNKnmIZl38oJqqBCob1YaaS0Oo1DQZNFmeJf3Jw
   DTz3xgYxlFVdTpwJguifWWOlk0HpaU1V8H9UdeMOQNsAYueyKztaHwBCC
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="244721332"
X-IronPort-AV: E=Sophos;i="5.88,298,1635231600"; 
   d="scan'208";a="244721332"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 14:22:10 -0800
X-IronPort-AV: E=Sophos;i="5.88,298,1635231600"; 
   d="scan'208";a="517936265"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.77.211]) ([10.209.77.211])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 14:22:09 -0800
Message-ID: <4a4b2848-d665-c9ba-c66a-dd4408e94ea5@linux.intel.com>
Date:   Tue, 18 Jan 2022 14:22:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 02/13] net: wwan: t7xx: Add control DMA
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
 <20220114010627.21104-3-ricardo.martinez@linux.intel.com>
 <d5854453-84b-1eba-7cc7-d94f41a185d@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <d5854453-84b-1eba-7cc7-d94f41a185d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/18/2022 6:13 AM, Ilpo Järvinen wrote:
> On Thu, 13 Jan 2022, Ricardo Martinez wrote:
...
>> +#define CLDMA_NUM 2
> I tried to understand its purpose but it seems that only one of the
> indexes is used in the arrays where this define gives the size? Related to
> this, ID_CLDMA0 is not used anywhere?

The modem HW has 2 CLDMAs, idx 0 for the app processor (SAP) and idx 1 
for the modem (MD).

CLDMA_NUM is defined as 2 to reflect the HW capabilities but mainly to 
have a cleaner upcoming

patches, which will use ID_CLDMA0.

If having array's of size 1 is not a problem then we can define 
CLDMA_NUM as 1 and

play with the CLDMA indexes.

...


>> +static void t7xx_cldma_enable_irq(struct cldma_ctrl *md_ctrl)
>> +{
>> +	t7xx_pcie_mac_set_int(md_ctrl->t7xx_dev, md_ctrl->hw_info.phy_interrupt_id);
>> +}
>> +
>> +static void t7xx_cldma_disable_irq(struct cldma_ctrl *md_ctrl)
>> +{
>> +	t7xx_pcie_mac_clear_int(md_ctrl->t7xx_dev, md_ctrl->hw_info.phy_interrupt_id);
>> +}
> t7xx_pcie_mac_set_int and t7xx_pcie_mac_clear_int are only defined
> by a later patch.
>
>> +static bool t7xx_cldma_qs_are_active(struct t7xx_cldma_hw *hw_info)
>> +{
>> +	unsigned int tx_active;
>> +	unsigned int rx_active;
>> +
>> +	tx_active = t7xx_cldma_hw_queue_status(hw_info, CLDMA_ALL_Q, MTK_TX);
>> +	rx_active = t7xx_cldma_hw_queue_status(hw_info, CLDMA_ALL_Q, MTK_RX);
>> +	if (tx_active == CLDMA_INVALID_STATUS || rx_active == CLDMA_INVALID_STATUS)
> These cannot ever be true because of mask in t7xx_cldma_hw_queue_status().

t7xx_cldma_hw_queue_status() shouldn't apply the mask for CLDMA_ALL_Q.

>> +static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
>> +{
>> +	struct cldma_queue *rxq = &md_ctrl->rxq[qnum];
>> +	struct cldma_request *req;
>> +	struct cldma_rgpd *rgpd;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&rxq->ring_lock, flags);
>> +	t7xx_cldma_q_reset(rxq);
>> +	list_for_each_entry(req, &rxq->tr_ring->gpd_ring, entry) {
>> +		rgpd = req->gpd;
>> +		rgpd->gpd_flags = GPD_FLAGS_IOC | GPD_FLAGS_HWO;
>> +		rgpd->data_buff_len = 0;
>> +
>> +		if (req->skb) {
>> +			req->skb->len = 0;
>> +			skb_reset_tail_pointer(req->skb);
>> +		}
>> +	}
>> +
>> +	spin_unlock_irqrestore(&rxq->ring_lock, flags);
>> +	list_for_each_entry(req, &rxq->tr_ring->gpd_ring, entry) {
>> +		int ret;
> I find this kind of newline+unlock+more code a bit odd groupingwise.
> IMO, the newline should be after the unlock rather than just before it to
> better indicate the critical sections visually.

Agree. In general, the driver uses a newline after '}', unlock 
operations should be an

exception since it looks better to keep the critical section blocks 
together.

...

>> +/**
>> + * t7xx_cldma_send_skb() - Send control data to modem.
>> + * @md_ctrl: CLDMA context structure.
>> + * @qno: Queue number.
>> + * @skb: Socket buffer.
>> + * @blocking: True for blocking operation.
>> + *
>> + * Send control packet to modem using a ring buffer.
>> + * If blocking is set, it will wait for completion.
>> + *
>> + * Return:
>> + * * 0		- Success.
>> + * * -ENOMEM	- Allocation failure.
>> + * * -EINVAL	- Invalid queue request.
>> + * * -EBUSY	- Resource lock failure.
>> + */
>> +int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb, bool blocking)
>> +{
>> +	struct cldma_request *tx_req;
>> +	struct cldma_queue *queue;
>> +	unsigned long flags;
>> +	int ret;
>> +
>> +	if (qno >= CLDMA_TXQ_NUM)
>> +		return -EINVAL;
>> +
>> +	queue = &md_ctrl->txq[qno];
>> +
>> +	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
>> +	if (!(md_ctrl->txq_active & BIT(qno))) {
>> +		ret = -EBUSY;
>> +		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
>> +		goto allow_sleep;
>> +	}
> ...
>> +		if (!blocking) {
>> +			ret = -EBUSY;
>> +			break;
>> +		}
>> +
>> +		ret = wait_event_interruptible_exclusive(queue->req_wq, queue->budget > 0);
>> +	} while (!ret);
>> +
>> +allow_sleep:
>> +	return ret;
>> +}
> First of all, if I interpreted the call chains correctly, this function is
> always called with blocking=true.
>
> Second, the first codepath returning -EBUSY when not txq_active seems
> twisted/reversed logic to me (not active => busy ?!?).

What about -EINVAL?

Other codes considered: -EPERM, -ENETDOWN.

>
...

