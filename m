Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961EC4937C4
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 10:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353170AbiASJxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 04:53:06 -0500
Received: from mga17.intel.com ([192.55.52.151]:44095 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353108AbiASJxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 04:53:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642585985; x=1674121985;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=nbZxDijhz+Glybpj0vSn4exGWtl6B5PgaZnhuvzIbwY=;
  b=QGYkRNz1iG8+vKzR9zNWlJXjH+jelFIU4cUv44DMPRr2KuOvCRfXSY5F
   wykUvJJm2+cb7s+YbKdnd6eNvORmu5ncGFhFPW/oGtk66xWrcTEsMR33o
   hsunN66hqZ+mB/RPKehsrAWRJWEcvbcA+NDAVE+F+6VhTYnctA2gBbDny
   /1R9MBolZxoRk9X+ib0izgmpCSlkNTOj6CJhjUMYDqN4T9X32HTIrI1EC
   y4lr8twoToMv+fSwcUDaW34LxD70ymARihXBzE8lvAelfczMaznS/r0Tm
   jPGtNtr/qjrTbLe4wdD6MoZrdGC9uB2H5b+vTYcq8nH45LAqaVeZLaLCO
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="225703924"
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="225703924"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 01:52:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="615652288"
Received: from unknown (HELO ijarvine-MOBL2.mshome.net) ([10.237.66.34])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 01:52:47 -0800
Date:   Wed, 19 Jan 2022 11:52:40 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
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
Subject: Re: [PATCH net-next v4 02/13] net: wwan: t7xx: Add control DMA
 interface
In-Reply-To: <4a4b2848-d665-c9ba-c66a-dd4408e94ea5@linux.intel.com>
Message-ID: <cb33ee41-b885-6523-199-b8a339c1a531@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-3-ricardo.martinez@linux.intel.com> <d5854453-84b-1eba-7cc7-d94f41a185d@linux.intel.com> <4a4b2848-d665-c9ba-c66a-dd4408e94ea5@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1619414095-1642585974=:1564"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1619414095-1642585974=:1564
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 18 Jan 2022, Martinez, Ricardo wrote:

> 
> On 1/18/2022 6:13 AM, Ilpo Järvinen wrote:
> > On Thu, 13 Jan 2022, Ricardo Martinez wrote:
> ...
> > > +#define CLDMA_NUM 2
> > I tried to understand its purpose but it seems that only one of the
> > indexes is used in the arrays where this define gives the size? Related to
> > this, ID_CLDMA0 is not used anywhere?
> 
> The modem HW has 2 CLDMAs, idx 0 for the app processor (SAP) and idx 1 for the
> modem (MD).
> 
> CLDMA_NUM is defined as 2 to reflect the HW capabilities but mainly to have a
> cleaner upcoming
> 
> patches, which will use ID_CLDMA0.

Please note this in your commit message then and I think it should be 
fine to leave it as is (or use 1 sized array, if you prefer to).

> If having array's of size 1 is not a problem then we can define CLDMA_NUM as 1
> and
> 
> play with the CLDMA indexes.
> 
> ...
>
> > > +static bool t7xx_cldma_qs_are_active(struct t7xx_cldma_hw *hw_info)
> > > +{
> > > +	unsigned int tx_active;
> > > +	unsigned int rx_active;
> > > +
> > > +	tx_active = t7xx_cldma_hw_queue_status(hw_info, CLDMA_ALL_Q, MTK_TX);
> > > +	rx_active = t7xx_cldma_hw_queue_status(hw_info, CLDMA_ALL_Q, MTK_RX);
> > > +	if (tx_active == CLDMA_INVALID_STATUS || rx_active ==
> > > CLDMA_INVALID_STATUS)
> > These cannot ever be true because of mask in t7xx_cldma_hw_queue_status().
> 
> t7xx_cldma_hw_queue_status() shouldn't apply the mask for CLDMA_ALL_Q.

I guess it shouldn't but it currently does apply 0xff (CLDMA_ALL_Q) as 
mask in that case. However, this now raises another question, if 
0xffffffff (CLDMA_INVALID_STATUS) means status is invalid, should all 
callers both single Q and CLDMA_ALL_Q be returned/check/handle that value?

Why would CLDMA_ALL_Q be special in this respect that the INVALID_STATUS 
means invalid only with it?

> > > +/**
> > > + * t7xx_cldma_send_skb() - Send control data to modem.
> > > + * @md_ctrl: CLDMA context structure.
> > > + * @qno: Queue number.
> > > + * @skb: Socket buffer.
> > > + * @blocking: True for blocking operation.
> > > + *
> > > + * Send control packet to modem using a ring buffer.
> > > + * If blocking is set, it will wait for completion.
> > > + *
> > > + * Return:
> > > + * * 0		- Success.
> > > + * * -ENOMEM	- Allocation failure.
> > > + * * -EINVAL	- Invalid queue request.
> > > + * * -EBUSY	- Resource lock failure.
> > > + */
> > > +int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct
> > > sk_buff *skb, bool blocking)
> > > +{
> > > +	struct cldma_request *tx_req;
> > > +	struct cldma_queue *queue;
> > > +	unsigned long flags;
> > > +	int ret;
> > > +
> > > +	if (qno >= CLDMA_TXQ_NUM)
> > > +		return -EINVAL;
> > > +
> > > +	queue = &md_ctrl->txq[qno];
> > > +
> > > +	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
> > > +	if (!(md_ctrl->txq_active & BIT(qno))) {
> > > +		ret = -EBUSY;
> > > +		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
> > > +		goto allow_sleep;
> > > +	}
> > ...
> > > +		if (!blocking) {
> > > +			ret = -EBUSY;
> > > +			break;
> > > +		}
> > > +
> > > +		ret = wait_event_interruptible_exclusive(queue->req_wq,
> > > queue->budget > 0);
> > > +	} while (!ret);
> > > +
> > > +allow_sleep:
> > > +	return ret;
> > > +}
> > First of all, if I interpreted the call chains correctly, this function is
> > always called with blocking=true.
> > 
> > Second, the first codepath returning -EBUSY when not txq_active seems
> > twisted/reversed logic to me (not active => busy ?!?).
> 
> What about -EINVAL?
> 
> Other codes considered: -EPERM, -ENETDOWN.

How about -EIO.

-- 
 i.

--8323329-1619414095-1642585974=:1564--
