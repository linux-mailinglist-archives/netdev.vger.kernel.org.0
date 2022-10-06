Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32E15F5E24
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 03:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJFBAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 21:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiJFBAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 21:00:30 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52478205D3
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 18:00:28 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r18so453628pgr.12
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 18:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date;
        bh=N7S5qylcdnDd0BDdomweGwSo5dJGB1KXoHVQtYxoPhg=;
        b=SScsHyiW9T6XZWZ5BKft3Crt0wv4VUDgJz17chysZGVYB1HeX6iCs/LMHAgdfBe/Dy
         CPyjvu9+I2Iz1+cRvEw+vb+xmcRzy4cJl9CSW0DCJs3q+70KoHPiK++PPQ/NstZwZQY3
         cygd/dZjVtW+KHGcUL2k0KJBV2cJ+HeAZwWsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=N7S5qylcdnDd0BDdomweGwSo5dJGB1KXoHVQtYxoPhg=;
        b=qAdP7GQJNnxZvSStxGkl3Blz0L+BItOq5Yk06wmCIxNcxDeKlDDi1qv5YJiXFeZIFM
         ZZBEF5bp/nwhKzajbnGMbyLbRmAmHUKySdpOATJ0gjOCz94Uv8UVMVXfHY0RwjI7vRut
         eHLx7O4QOez4KYPYoZO8TqT5UpyWk7ipILKC8y/5JI/M7npreCiMvPHLaiFVN4107EAy
         UTaHgC8JAjoyRY93Q2EMTyoTrEiDWp+9R9KFLHsirFnhBQ+3ZiMk2gUlExNvLqpP4QCV
         vbos/ve9D5pFa9vcU9HCFzXi6oMnm4v0FI7JG4vvtKR2HbqaojWTQfxsDzThd2gtJjvN
         WNbQ==
X-Gm-Message-State: ACrzQf2Om3i+FLvssU12CfpvHPstW9z/obCMqQ+S3Jgn6K1D8LtH28Va
        yTWlxnloioVHlQKUBZXrz+FeFQ==
X-Google-Smtp-Source: AMsMyM6vRGWbbzrlDdxEgYD4fPhb+Aiedz5u/xqNEb/nZRMYFvioQzr1oHG8dyApVhUn6P3R7fbHmg==
X-Received: by 2002:a63:4b5f:0:b0:43c:428d:507c with SMTP id k31-20020a634b5f000000b0043c428d507cmr2035540pgl.607.1665018027722;
        Wed, 05 Oct 2022 18:00:27 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id 1-20020a630b01000000b004388ba7e5a9sm379638pgl.49.2022.10.05.18.00.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 18:00:27 -0700 (PDT)
Date:   Wed, 5 Oct 2022 18:00:24 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com, maciej.fijalkowski@intel.com
Subject: Re: [next-queue v2 2/4] i40e: Record number TXes cleaned during NAPI
Message-ID: <20221006010024.GA31170@fastly.com>
References: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
 <1665004913-25656-3-git-send-email-jdamato@fastly.com>
 <0cdcc8ee-e28d-f3cc-a65a-6c54ee7ee03e@intel.com>
 <20221006003104.GA30279@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221006003104.GA30279@fastly.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 05:31:04PM -0700, Joe Damato wrote:
> On Wed, Oct 05, 2022 at 07:16:56PM -0500, Samudrala, Sridhar wrote:
> > On 10/5/2022 4:21 PM, Joe Damato wrote:
> > >Update i40e_clean_tx_irq to take an out parameter (tx_cleaned) which stores
> > >the number TXs cleaned.
> > >
> > >Likewise, update i40e_clean_xdp_tx_irq and i40e_xmit_zc to do the same.
> > >
> > >Care has been taken to avoid changing the control flow of any functions
> > >involved.
> > >
> > >Signed-off-by: Joe Damato <jdamato@fastly.com>
> > >---
> > >  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 16 +++++++++++-----
> > >  drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 15 +++++++++++----
> > >  drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  3 ++-
> > >  3 files changed, 24 insertions(+), 10 deletions(-)
> > >
> > >diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > >index b97c95f..a2cc98e 100644
> > >--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > >+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > >@@ -923,11 +923,13 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
> > >   * @vsi: the VSI we care about
> > >   * @tx_ring: Tx ring to clean
> > >   * @napi_budget: Used to determine if we are in netpoll
> > >+ * @tx_cleaned: Out parameter set to the number of TXes cleaned
> > >   *
> > >   * Returns true if there's any budget left (e.g. the clean is finished)
> > >   **/
> > >  static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> > >-			      struct i40e_ring *tx_ring, int napi_budget)
> > >+			      struct i40e_ring *tx_ring, int napi_budget,
> > >+			      unsigned int *tx_cleaned)
> > >  {
> > >  	int i = tx_ring->next_to_clean;
> > >  	struct i40e_tx_buffer *tx_buf;
> > >@@ -1026,7 +1028,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> > >  	i40e_arm_wb(tx_ring, vsi, budget);
> > >  	if (ring_is_xdp(tx_ring))
> > >-		return !!budget;
> > >+		goto out;
> > >  	/* notify netdev of completed buffers */
> > >  	netdev_tx_completed_queue(txring_txq(tx_ring),
> > >@@ -1048,6 +1050,8 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> > >  		}
> > >  	}
> > >+out:
> > >+	*tx_cleaned = total_packets;
> > >  	return !!budget;
> > >  }
> > >@@ -2689,10 +2693,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
> > >  			       container_of(napi, struct i40e_q_vector, napi);
> > >  	struct i40e_vsi *vsi = q_vector->vsi;
> > >  	struct i40e_ring *ring;
> > >+	bool tx_clean_complete = true;
> > >  	bool clean_complete = true;
> > >  	bool arm_wb = false;
> > >  	int budget_per_ring;
> > >  	int work_done = 0;
> > >+	unsigned int tx_cleaned = 0;
> > >  	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
> > >  		napi_complete(napi);
> > >@@ -2704,11 +2710,11 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
> > >  	 */
> > >  	i40e_for_each_ring(ring, q_vector->tx) {
> > >  		bool wd = ring->xsk_pool ?
> > >-			  i40e_clean_xdp_tx_irq(vsi, ring) :
> > >-			  i40e_clean_tx_irq(vsi, ring, budget);
> > >+			  i40e_clean_xdp_tx_irq(vsi, ring, &tx_cleaned) :
> > >+			  i40e_clean_tx_irq(vsi, ring, budget, &tx_cleaned);
> > >  		if (!wd) {
> > >-			clean_complete = false;
> > >+			clean_complete = tx_clean_complete = false;
> > >  			continue;
> > >  		}
> > >  		arm_wb |= ring->arm_wb;
> > >diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > >index 790aaeff..f98ce7e4 100644
> > >--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > >+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > >@@ -530,18 +530,22 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
> > >   * i40e_xmit_zc - Performs zero-copy Tx AF_XDP
> > >   * @xdp_ring: XDP Tx ring
> > >   * @budget: NAPI budget
> > >+ * @tx_cleaned: Out parameter of the TX packets processed
> > >   *
> > >   * Returns true if the work is finished.
> > >   **/
> > >-static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> > >+static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget,
> > >+			 unsigned int *tx_cleaned)
> > >  {
> > >  	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
> > >  	u32 nb_pkts, nb_processed = 0;
> > >  	unsigned int total_bytes = 0;
> > >  	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
> > >-	if (!nb_pkts)
> > >+	if (!nb_pkts) {
> > >+		*tx_cleaned = 0;
> > >  		return true;
> > >+	}
> > >  	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
> > >  		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
> > >@@ -558,6 +562,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> > >  	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
> > >+	*tx_cleaned = nb_pkts;
> > 
> > With XDP, I don't think we should count these as tx_cleaned packets. These are transmitted
> > packets. The tx_cleaned would be the xsk_frames counter in i40e_clean_xdp_tx_irq
> > May be we need 2 counters for xdp.
> 
> I think there's two issues you are describing, which are separate in my
> mind.
> 
>   1.) The name "tx_cleaned", and
>   2.) Whether nb_pkts is the right thing to write as the out param.
> 
> For #1: I'm OK to change the name if that's the blocker here; please
> suggest a suitable alternative that you'll accept.
> 
> For #2: nb_pkts is, IMO, the right value to bubble up to the tracepoint because
> nb_pkts affects clean_complete in i40e_napi_poll which in turn determines
> whether or not polling mode is entered.
> 
> The purpose of the tracepoint is to determine when/why/how you are entering
> polling mode, so if nb_pkts plays a role in that calculation, it's the
> right number to output.

I suppose the alternative is to only fire the tracepoint when *not* in XDP.
Then the changes to the XDP stuff can be dropped and a separate set of
tracepoints for XDP can be created in the future.

That might reduce the complexity a bit, and will probably still be pretty
useful for people tuning their non-XDP workloads.
