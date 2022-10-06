Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5BF5F5DC4
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 02:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJFAbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 20:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiJFAbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 20:31:10 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9960585A8E
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 17:31:09 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id j71so467512pge.2
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 17:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date;
        bh=tLxHZ4CcgYDIFFbopH9F9PJl1cN7HOhyUtM5x1PUDR4=;
        b=xhUjWuqLjGV249kMFhiGiZ7hkj07wuYO7+WoWfMkfM26lNqCX7bOWKgt9Hsfgkv5F/
         kaLg1Y85bmpWROTAptlau05D7tK8eQFCIQ42InP0rcvU++VHcTifAYbW7Um3t9UzQe8D
         2WVx7eUpKZiJzxUAYW4cfy4CzG++FjVK3gkgs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=tLxHZ4CcgYDIFFbopH9F9PJl1cN7HOhyUtM5x1PUDR4=;
        b=q0DrcKa+WnYVdEgmzyWztR9fMzfnzkDSFturl5k2OJxm5WcjFlAS+B4y6JeuX3kWJD
         EdwHMXNd/TJcwJLnsu/Ktbee+Uf4StKlWAxyuK8GKo+YbMrYrhJeWd+xygI8olpZxeeV
         QSVlr0bHI6+vf7jCy6PZ6KpA6Ev2oQsE4etVntBC/LucAhI0KDiec2er/lls9ep1+82d
         J49xTQwCqUQ0tE409dw1p4NDEUZAFAOQhcCIpTNpikkkNJWJQTMMIeGz8ynsZJBQ99l7
         C+cvlLlt6OIICv9I1lkPHYVPHmgxdWLkUEdx0l61z/Zlr+eCdz8Lnbhto0Zq0B5SjVOQ
         omVg==
X-Gm-Message-State: ACrzQf2MJ8H4QZsgevy9pPPHpt34Jkp0fC1OwAwe4fjF3POZfreFAWeB
        250aOO4i6Kkg+QnmbOcK98quew==
X-Google-Smtp-Source: AMsMyM5VNa55z0S2bhemdn039W+kQslBsY/aq25sKZ3XrLbAlo3GNGKvcT1fEiWPkPiZEkxcGnAXxA==
X-Received: by 2002:a05:6a00:194a:b0:55a:a604:28fc with SMTP id s10-20020a056a00194a00b0055aa60428fcmr1988517pfk.47.1665016269023;
        Wed, 05 Oct 2022 17:31:09 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0020ad7678ba0sm1677683pjd.3.2022.10.05.17.31.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 17:31:08 -0700 (PDT)
Date:   Wed, 5 Oct 2022 17:31:05 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com, maciej.fijalkowski@intel.com
Subject: Re: [next-queue v2 2/4] i40e: Record number TXes cleaned during NAPI
Message-ID: <20221006003104.GA30279@fastly.com>
References: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
 <1665004913-25656-3-git-send-email-jdamato@fastly.com>
 <0cdcc8ee-e28d-f3cc-a65a-6c54ee7ee03e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0cdcc8ee-e28d-f3cc-a65a-6c54ee7ee03e@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 07:16:56PM -0500, Samudrala, Sridhar wrote:
> On 10/5/2022 4:21 PM, Joe Damato wrote:
> >Update i40e_clean_tx_irq to take an out parameter (tx_cleaned) which stores
> >the number TXs cleaned.
> >
> >Likewise, update i40e_clean_xdp_tx_irq and i40e_xmit_zc to do the same.
> >
> >Care has been taken to avoid changing the control flow of any functions
> >involved.
> >
> >Signed-off-by: Joe Damato <jdamato@fastly.com>
> >---
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 16 +++++++++++-----
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 15 +++++++++++----
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  3 ++-
> >  3 files changed, 24 insertions(+), 10 deletions(-)
> >
> >diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> >index b97c95f..a2cc98e 100644
> >--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> >+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> >@@ -923,11 +923,13 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
> >   * @vsi: the VSI we care about
> >   * @tx_ring: Tx ring to clean
> >   * @napi_budget: Used to determine if we are in netpoll
> >+ * @tx_cleaned: Out parameter set to the number of TXes cleaned
> >   *
> >   * Returns true if there's any budget left (e.g. the clean is finished)
> >   **/
> >  static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> >-			      struct i40e_ring *tx_ring, int napi_budget)
> >+			      struct i40e_ring *tx_ring, int napi_budget,
> >+			      unsigned int *tx_cleaned)
> >  {
> >  	int i = tx_ring->next_to_clean;
> >  	struct i40e_tx_buffer *tx_buf;
> >@@ -1026,7 +1028,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> >  	i40e_arm_wb(tx_ring, vsi, budget);
> >  	if (ring_is_xdp(tx_ring))
> >-		return !!budget;
> >+		goto out;
> >  	/* notify netdev of completed buffers */
> >  	netdev_tx_completed_queue(txring_txq(tx_ring),
> >@@ -1048,6 +1050,8 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> >  		}
> >  	}
> >+out:
> >+	*tx_cleaned = total_packets;
> >  	return !!budget;
> >  }
> >@@ -2689,10 +2693,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
> >  			       container_of(napi, struct i40e_q_vector, napi);
> >  	struct i40e_vsi *vsi = q_vector->vsi;
> >  	struct i40e_ring *ring;
> >+	bool tx_clean_complete = true;
> >  	bool clean_complete = true;
> >  	bool arm_wb = false;
> >  	int budget_per_ring;
> >  	int work_done = 0;
> >+	unsigned int tx_cleaned = 0;
> >  	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
> >  		napi_complete(napi);
> >@@ -2704,11 +2710,11 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
> >  	 */
> >  	i40e_for_each_ring(ring, q_vector->tx) {
> >  		bool wd = ring->xsk_pool ?
> >-			  i40e_clean_xdp_tx_irq(vsi, ring) :
> >-			  i40e_clean_tx_irq(vsi, ring, budget);
> >+			  i40e_clean_xdp_tx_irq(vsi, ring, &tx_cleaned) :
> >+			  i40e_clean_tx_irq(vsi, ring, budget, &tx_cleaned);
> >  		if (!wd) {
> >-			clean_complete = false;
> >+			clean_complete = tx_clean_complete = false;
> >  			continue;
> >  		}
> >  		arm_wb |= ring->arm_wb;
> >diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> >index 790aaeff..f98ce7e4 100644
> >--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> >+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> >@@ -530,18 +530,22 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
> >   * i40e_xmit_zc - Performs zero-copy Tx AF_XDP
> >   * @xdp_ring: XDP Tx ring
> >   * @budget: NAPI budget
> >+ * @tx_cleaned: Out parameter of the TX packets processed
> >   *
> >   * Returns true if the work is finished.
> >   **/
> >-static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >+static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget,
> >+			 unsigned int *tx_cleaned)
> >  {
> >  	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
> >  	u32 nb_pkts, nb_processed = 0;
> >  	unsigned int total_bytes = 0;
> >  	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
> >-	if (!nb_pkts)
> >+	if (!nb_pkts) {
> >+		*tx_cleaned = 0;
> >  		return true;
> >+	}
> >  	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
> >  		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
> >@@ -558,6 +562,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >  	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
> >+	*tx_cleaned = nb_pkts;
> 
> With XDP, I don't think we should count these as tx_cleaned packets. These are transmitted
> packets. The tx_cleaned would be the xsk_frames counter in i40e_clean_xdp_tx_irq
> May be we need 2 counters for xdp.

I think there's two issues you are describing, which are separate in my
mind.

  1.) The name "tx_cleaned", and
  2.) Whether nb_pkts is the right thing to write as the out param.

For #1: I'm OK to change the name if that's the blocker here; please
suggest a suitable alternative that you'll accept.

For #2: nb_pkts is, IMO, the right value to bubble up to the tracepoint because
nb_pkts affects clean_complete in i40e_napi_poll which in turn determines
whether or not polling mode is entered.

The purpose of the tracepoint is to determine when/why/how you are entering
polling mode, so if nb_pkts plays a role in that calculation, it's the
right number to output.


> >  	return nb_pkts < budget;
> >  }
> >@@ -581,10 +586,12 @@ static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
> >   * i40e_clean_xdp_tx_irq - Completes AF_XDP entries, and cleans XDP entries
> >   * @vsi: Current VSI
> >   * @tx_ring: XDP Tx ring
> >+ * @tx_cleaned: out parameter of number of TXes cleaned
> >   *
> >   * Returns true if cleanup/tranmission is done.
> >   **/
> >-bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
> >+bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring,
> >+			   unsigned int *tx_cleaned)
> >  {
> >  	struct xsk_buff_pool *bp = tx_ring->xsk_pool;
> >  	u32 i, completed_frames, xsk_frames = 0;
> >@@ -634,7 +641,7 @@ bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
> >  	if (xsk_uses_need_wakeup(tx_ring->xsk_pool))
> >  		xsk_set_tx_need_wakeup(tx_ring->xsk_pool);
> >-	return i40e_xmit_zc(tx_ring, I40E_DESC_UNUSED(tx_ring));
> >+	return i40e_xmit_zc(tx_ring, I40E_DESC_UNUSED(tx_ring), tx_cleaned);
> >  }
> >  /**
> >diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> >index 821df24..396ed11 100644
> >--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> >+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> >@@ -30,7 +30,8 @@ int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
> >  bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 cleaned_count);
> >  int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
> >-bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring);
> >+bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring,
> >+			   unsigned int *tx_cleaned);
> >  int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags);
> >  int i40e_realloc_rx_bi_zc(struct i40e_vsi *vsi, bool zc);
> >  void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring);
> 
