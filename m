Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2E45F5962
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 19:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiJERuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 13:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiJERum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 13:50:42 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F361A2F65E
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 10:50:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id lx7so16203310pjb.0
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 10:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=OkjKvJs8S/hQt0MPx2S5vsIaSqgsJN8VUNFF955H+xs=;
        b=L0bNNyeKXDLplArxxlKGfi8HJ5DW81Y6Xg1JA93SvrFFrH12k33UrYmiJSBuK8xWWq
         vfFo/ymFU9RSW+gjgGcrdPKVMLXnBlr/ixmZNY/GO+m0eyri4xWuz5nRpF0AUpBBXFMH
         YR6zjggihIXQyEJIdWPZVRqMrO6UF5wDcvUU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=OkjKvJs8S/hQt0MPx2S5vsIaSqgsJN8VUNFF955H+xs=;
        b=f6N7/nZZqqQ74NoQX0Et7NLzIGmAj8HjH0+/c7fYWmCWcbXGBkHoFU+N6AhyHUbnde
         9xGhi+WLTDlry8IsZFKkKg0rlKdLJRzUOOA/JatWyx3V8o9JWjpDsnTJBtj7rhDaxMDl
         PnugJGcDhwalIke8ImQVfyQxDt9D/vWlQKXcrJzV7vk37xtIklwIqhTv0OiDw6pBUgo2
         +pRPLYd2zEBEJmYOkfZSMfiIP5J2prvEyjQT+1ftMYlloAtWnFfmcxF91ApqanRS47RY
         0GQ+mng29r+GZJSUNEGToCEIivpBd2q71BrioenRIryQID/EYaIBjkGTU0hA/4s7A3ex
         M2gA==
X-Gm-Message-State: ACrzQf0WyvS3d68mudjDUTvGFGy6ES34jd2yv0deqrrrVg80DYZWrZF2
        hmMlK0IGT3sWo19pVMNwQx61cg==
X-Google-Smtp-Source: AMsMyM64sjcBhnUPXmFGqxUvu6Bxw8rA05JyFLgNLPKiQ4f8D63xMWsASz3Pmz05+qIiqmN+C6MRIQ==
X-Received: by 2002:a17:90b:1c88:b0:203:8400:13a9 with SMTP id oo8-20020a17090b1c8800b00203840013a9mr935880pjb.46.1664992235120;
        Wed, 05 Oct 2022 10:50:35 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id r18-20020aa79632000000b00561c3ec5346sm3366702pfg.129.2022.10.05.10.50.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 10:50:34 -0700 (PDT)
Date:   Wed, 5 Oct 2022 10:50:32 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com
Subject: Re: [next-queue 2/3] i40e: i40e_clean_tx_irq returns work done
Message-ID: <20221005175031.GA11626@fastly.com>
References: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
 <1664958703-4224-3-git-send-email-jdamato@fastly.com>
 <Yz1gh6ezOuc1tzH+@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz1gh6ezOuc1tzH+@boxer>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 12:46:31PM +0200, Maciej Fijalkowski wrote:
> On Wed, Oct 05, 2022 at 01:31:42AM -0700, Joe Damato wrote:
> > Adjust i40e_clean_tx_irq to return the actual number of packets cleaned
> > and adjust the logic in i40e_napi_poll to check this value.
> > 
> > Signed-off-by: Joe Damato <jdamato@fastly.com>
> > ---
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 24 +++++++++++++-----------
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 12 ++++++------
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  2 +-
> >  3 files changed, 20 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > index b97c95f..ed88309 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > @@ -924,10 +924,10 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
> >   * @tx_ring: Tx ring to clean
> >   * @napi_budget: Used to determine if we are in netpoll
> >   *
> > - * Returns true if there's any budget left (e.g. the clean is finished)
> > + * Returns the number of packets cleaned
> >   **/
> > -static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> > -			      struct i40e_ring *tx_ring, int napi_budget)
> > +static int i40e_clean_tx_irq(struct i40e_vsi *vsi,
> > +			     struct i40e_ring *tx_ring, int napi_budget)
> >  {
> >  	int i = tx_ring->next_to_clean;
> >  	struct i40e_tx_buffer *tx_buf;
> > @@ -1026,7 +1026,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> >  	i40e_arm_wb(tx_ring, vsi, budget);
> >  
> >  	if (ring_is_xdp(tx_ring))
> > -		return !!budget;
> > +		return total_packets;
> >  
> >  	/* notify netdev of completed buffers */
> >  	netdev_tx_completed_queue(txring_txq(tx_ring),
> > @@ -1048,7 +1048,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> >  		}
> >  	}
> >  
> > -	return !!budget;
> > +	return total_packets;
> >  }
> >  
> >  /**
> > @@ -2689,10 +2689,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
> >  			       container_of(napi, struct i40e_q_vector, napi);
> >  	struct i40e_vsi *vsi = q_vector->vsi;
> >  	struct i40e_ring *ring;
> > +	bool tx_clean_complete = true;
> >  	bool clean_complete = true;
> >  	bool arm_wb = false;
> >  	int budget_per_ring;
> >  	int work_done = 0;
> > +	int tx_wd = 0;
> >  
> >  	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
> >  		napi_complete(napi);
> > @@ -2703,12 +2705,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
> >  	 * budget and be more aggressive about cleaning up the Tx descriptors.
> >  	 */
> >  	i40e_for_each_ring(ring, q_vector->tx) {
> > -		bool wd = ring->xsk_pool ?
> > -			  i40e_clean_xdp_tx_irq(vsi, ring) :
> > -			  i40e_clean_tx_irq(vsi, ring, budget);
> > +		tx_wd = ring->xsk_pool ?
> > +			i40e_clean_xdp_tx_irq(vsi, ring) :
> > +			i40e_clean_tx_irq(vsi, ring, budget);
> >  
> > -		if (!wd) {
> > -			clean_complete = false;
> > +		if (tx_wd >= budget) {
> > +			tx_clean_complete = false;
> 
> This will break for AF_XDP Tx ZC. AF_XDP Tx ZC in intel drivers ignores
> budget given by NAPI. If you look at i40e_xmit_zc():
> 
> func def:
> static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> 
> callsite:
> 	return i40e_xmit_zc(tx_ring, I40E_DESC_UNUSED(tx_ring));
> 
> we give free ring space as a budget and with your change we would be
> returning the amount of processed tx descriptors which you will be
> comparing against NAPI budget (64, unless you have busy poll enabled with
> a different batch size). Say you start with empty ring and your HW rings
> are sized to 1k but there was only 512 AF_XDP descriptors ready for Tx.
> You produced all of them successfully to ring and you return 512 up to
> i40e_napi_poll.

Good point, my bad.

I've reworked this for the v2 and have given i40e_clean_tx_irq,
and i40e_clean_xdp_tx_irq an out parameter which will record the number
TXes cleaned.

I tweaked i40e_xmit_zc to return the number of packets (nb_pkts) and moved
the boolean to check if that's under the "budget"
(I40E_DESC_UNUSED(tx_ring)) into i40e_clean_xdp_tx_irq.

I think that might solve the issues you've described.


> >  			continue;
> >  		}
> >  		arm_wb |= ring->arm_wb;
> > @@ -2742,7 +2744,7 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
> >  	}
> >  
> >  	/* If work not completed, return budget and polling will return */
> > -	if (!clean_complete) {
> > +	if (!clean_complete || !tx_clean_complete) {
> >  		int cpu_id = smp_processor_id();
> >  
> >  		/* It is possible that the interrupt affinity has changed but,
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > index 790aaeff..925682c 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > @@ -531,9 +531,9 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
> >   * @xdp_ring: XDP Tx ring
> >   * @budget: NAPI budget
> >   *
> > - * Returns true if the work is finished.
> > + * Returns number of packets cleaned
> >   **/
> > -static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> > +static int i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >  {
> >  	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
> >  	u32 nb_pkts, nb_processed = 0;
> > @@ -541,7 +541,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >  
> >  	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
> >  	if (!nb_pkts)
> > -		return true;
> > +		return 0;
> >  
> >  	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
> >  		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
> > @@ -558,7 +558,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >  
> >  	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
> >  
> > -	return nb_pkts < budget;
> > +	return nb_pkts;
> >  }
> >  
> >  /**
> > @@ -582,9 +582,9 @@ static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
> >   * @vsi: Current VSI
> >   * @tx_ring: XDP Tx ring
> >   *
> > - * Returns true if cleanup/tranmission is done.
> > + * Returns number of packets cleaned
> >   **/
> > -bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
> > +int i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
> >  {
> >  	struct xsk_buff_pool *bp = tx_ring->xsk_pool;
> >  	u32 i, completed_frames, xsk_frames = 0;
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> > index 821df24..4e810c2 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> > @@ -30,7 +30,7 @@ int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
> >  bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 cleaned_count);
> >  int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
> >  
> > -bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring);
> > +int i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring);
> >  int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags);
> >  int i40e_realloc_rx_bi_zc(struct i40e_vsi *vsi, bool zc);
> >  void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring);
> > -- 
> > 2.7.4
> > 
