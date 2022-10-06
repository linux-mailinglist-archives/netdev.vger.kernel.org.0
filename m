Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE175F6D04
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 19:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJFRcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 13:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJFRcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 13:32:53 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB55A4BA7
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 10:32:52 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id z20so2308060plb.10
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 10:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GqYIbC4MRoi1+A3vrhxjLGpYA/IA7e6nRTLcVncEAC4=;
        b=TR7GLoD3Du1ThxndDo4BbbTpkI4IEaXnUNawXV5YM/poB8JFiacX+uvs5vRMxF9Qbx
         Hok4NcKGGQQ8mZzuKBKXoCuXFoRwBVJX9asvjDumZnfZeIfL1gzqCglkwkUQfo1BZ6nm
         53EVk3Y8xH7Nph9AwpgKegR54ovAy+CwXzV5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GqYIbC4MRoi1+A3vrhxjLGpYA/IA7e6nRTLcVncEAC4=;
        b=NT0ZbGcdjXWL21KPfv/fUFyuhKVvbxnhNuR5R+RnZ/vPBpLc7F9wWCytneejH2jbYF
         JTPmikcQK4JWsCymp15PugIgvR1YL7zlqurJJa0MQKYb+8MYGwC29OwCvCADPXtXoztS
         nl35zx9KY6gE7sy8/1lqjgfuhdn++B3jFCa+zJdVAMF+olCjyhPbyMBqBGRujMcjXpem
         awihnjQrd53rebLBwQ32ik0GQtnJFfsKZbwihuvNw6HVzJm/KKDyK0JvxrTZxzEObK38
         ZyjAO4BML13voVx8wTTkkLPimcCj1MkKgjvKzxU7ZTGqtdi2GwM7GsA2ZnHfPBHslFeU
         bVcw==
X-Gm-Message-State: ACrzQf3HfDL/fURcmxaQYT4YoPSm7lZlYh2JYBNPL44A7wQ4bwEZh3cH
        m9NB49DtMhAzVFDvk0hG6aLZWlByw/cF7g==
X-Google-Smtp-Source: AMsMyM4ryp/40vCIKJXkA7rKnztxCc3KrVZqYcKadV3TKHq70LddD27zMa/tjzJ+U4AHnQslbxAtZw==
X-Received: by 2002:a17:902:8bc3:b0:178:8563:8e42 with SMTP id r3-20020a1709028bc300b0017885638e42mr565794plo.0.1665077571790;
        Thu, 06 Oct 2022 10:32:51 -0700 (PDT)
Received: from fastly.com (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id o2-20020a17090a3d4200b001fbb0f0b00fsm3106485pjf.35.2022.10.06.10.32.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Oct 2022 10:32:51 -0700 (PDT)
Date:   Thu, 6 Oct 2022 10:32:48 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com
Subject: Re: [next-queue v2 2/4] i40e: Record number TXes cleaned during NAPI
Message-ID: <20221006173248.GA51751@fastly.com>
References: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
 <1665004913-25656-3-git-send-email-jdamato@fastly.com>
 <0cdcc8ee-e28d-f3cc-a65a-6c54ee7ee03e@intel.com>
 <20221006003104.GA30279@fastly.com>
 <20221006010024.GA31170@fastly.com>
 <Yz7SHod/GPxKWmvw@boxer>
 <481f7799-0f1c-efa3-bf2c-e22961e5f376@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <481f7799-0f1c-efa3-bf2c-e22961e5f376@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 06, 2022 at 09:57:19AM -0500, Samudrala, Sridhar wrote:
> On 10/6/2022 8:03 AM, Maciej Fijalkowski wrote:
> >On Wed, Oct 05, 2022 at 06:00:24PM -0700, Joe Damato wrote:
> >>On Wed, Oct 05, 2022 at 05:31:04PM -0700, Joe Damato wrote:
> >>>On Wed, Oct 05, 2022 at 07:16:56PM -0500, Samudrala, Sridhar wrote:
> >>>>On 10/5/2022 4:21 PM, Joe Damato wrote:
> >>>>>Update i40e_clean_tx_irq to take an out parameter (tx_cleaned) which stores
> >>>>>the number TXs cleaned.
> >>>>>
> >>>>>Likewise, update i40e_clean_xdp_tx_irq and i40e_xmit_zc to do the same.
> >>>>>
> >>>>>Care has been taken to avoid changing the control flow of any functions
> >>>>>involved.
> >>>>>
> >>>>>Signed-off-by: Joe Damato <jdamato@fastly.com>
> >>>>>---
> >>>>>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 16 +++++++++++-----
> >>>>>  drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 15 +++++++++++----
> >>>>>  drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  3 ++-
> >>>>>  3 files changed, 24 insertions(+), 10 deletions(-)
> >>>>>
> >>>>>diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> >>>>>index b97c95f..a2cc98e 100644
> >>>>>--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> >>>>>+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> >>>>>@@ -923,11 +923,13 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
> >>>>>   * @vsi: the VSI we care about
> >>>>>   * @tx_ring: Tx ring to clean
> >>>>>   * @napi_budget: Used to determine if we are in netpoll
> >>>>>+ * @tx_cleaned: Out parameter set to the number of TXes cleaned
> >>>>>   *
> >>>>>   * Returns true if there's any budget left (e.g. the clean is finished)
> >>>>>   **/
> >>>>>  static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> >>>>>-			      struct i40e_ring *tx_ring, int napi_budget)
> >>>>>+			      struct i40e_ring *tx_ring, int napi_budget,
> >>>>>+			      unsigned int *tx_cleaned)
> >>>>>  {
> >>>>>  	int i = tx_ring->next_to_clean;
> >>>>>  	struct i40e_tx_buffer *tx_buf;
> >>>>>@@ -1026,7 +1028,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> >>>>>  	i40e_arm_wb(tx_ring, vsi, budget);
> >>>>>  	if (ring_is_xdp(tx_ring))
> >>>>>-		return !!budget;
> >>>>>+		goto out;
> >>>>>  	/* notify netdev of completed buffers */
> >>>>>  	netdev_tx_completed_queue(txring_txq(tx_ring),
> >>>>>@@ -1048,6 +1050,8 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
> >>>>>  		}
> >>>>>  	}
> >>>>>+out:
> >>>>>+	*tx_cleaned = total_packets;
> >>>>>  	return !!budget;
> >>>>>  }
> >>>>>@@ -2689,10 +2693,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
> >>>>>  			       container_of(napi, struct i40e_q_vector, napi);
> >>>>>  	struct i40e_vsi *vsi = q_vector->vsi;
> >>>>>  	struct i40e_ring *ring;
> >>>>>+	bool tx_clean_complete = true;
> >>>>>  	bool clean_complete = true;
> >>>>>  	bool arm_wb = false;
> >>>>>  	int budget_per_ring;
> >>>>>  	int work_done = 0;
> >>>>>+	unsigned int tx_cleaned = 0;
> >>>>>  	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
> >>>>>  		napi_complete(napi);
> >>>>>@@ -2704,11 +2710,11 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
> >>>>>  	 */
> >>>>>  	i40e_for_each_ring(ring, q_vector->tx) {
> >>>>>  		bool wd = ring->xsk_pool ?
> >>>>>-			  i40e_clean_xdp_tx_irq(vsi, ring) :
> >>>>>-			  i40e_clean_tx_irq(vsi, ring, budget);
> >>>>>+			  i40e_clean_xdp_tx_irq(vsi, ring, &tx_cleaned) :
> >>>>>+			  i40e_clean_tx_irq(vsi, ring, budget, &tx_cleaned);
> >>>>>  		if (!wd) {
> >>>>>-			clean_complete = false;
> >>>>>+			clean_complete = tx_clean_complete = false;
> >>>>>  			continue;
> >>>>>  		}
> >>>>>  		arm_wb |= ring->arm_wb;
> >>>>>diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> >>>>>index 790aaeff..f98ce7e4 100644
> >>>>>--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> >>>>>+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> >>>>>@@ -530,18 +530,22 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
> >>>>>   * i40e_xmit_zc - Performs zero-copy Tx AF_XDP
> >>>>>   * @xdp_ring: XDP Tx ring
> >>>>>   * @budget: NAPI budget
> >>>>>+ * @tx_cleaned: Out parameter of the TX packets processed
> >>>>>   *
> >>>>>   * Returns true if the work is finished.
> >>>>>   **/
> >>>>>-static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >>>>>+static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget,
> >>>>>+			 unsigned int *tx_cleaned)
> >>>>>  {
> >>>>>  	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
> >>>>>  	u32 nb_pkts, nb_processed = 0;
> >>>>>  	unsigned int total_bytes = 0;
> >>>>>  	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
> >>>>>-	if (!nb_pkts)
> >>>>>+	if (!nb_pkts) {
> >>>>>+		*tx_cleaned = 0;
> >>>>>  		return true;
> >>>>>+	}
> >>>>>  	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
> >>>>>  		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
> >>>>>@@ -558,6 +562,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >>>>>  	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
> >>>>>+	*tx_cleaned = nb_pkts;
> >>>>With XDP, I don't think we should count these as tx_cleaned packets. These are transmitted
> >>>>packets. The tx_cleaned would be the xsk_frames counter in i40e_clean_xdp_tx_irq
> >>>>May be we need 2 counters for xdp.
> >>>I think there's two issues you are describing, which are separate in my
> >>>mind.
> >>>
> >>>   1.) The name "tx_cleaned", and
> >>>   2.) Whether nb_pkts is the right thing to write as the out param.
> >>>
> >>>For #1: I'm OK to change the name if that's the blocker here; please
> >>>suggest a suitable alternative that you'll accept.
> >>>
> >>>For #2: nb_pkts is, IMO, the right value to bubble up to the tracepoint because
> >>>nb_pkts affects clean_complete in i40e_napi_poll which in turn determines
> >>>whether or not polling mode is entered.
> >>>
> >>>The purpose of the tracepoint is to determine when/why/how you are entering
> >>>polling mode, so if nb_pkts plays a role in that calculation, it's the
> >>>right number to output.
> >>I suppose the alternative is to only fire the tracepoint when *not* in XDP.
> >>Then the changes to the XDP stuff can be dropped and a separate set of
> >>tracepoints for XDP can be created in the future.
> >Let's be clear that it's the AF_XDP quirk that we have in here that actual
> >xmit happens within NAPI polling routine.
> >
> >Sridhar is right with having xsk_frames as tx_cleaned but you're also
> >right that nb_pkts affects napi polling. But then if you look at Rx side
> >there is an analogous case with buffer allocation affecting napi polling.
> 
> To be correct,  I would suggest 2 out parameters to i40e_clean_xdp_tx_irq()
> tx_cleaned and xdp_transmitted.  tx_cleaned should be filled in
> with xsk_frames. Add xdp_transmitted as an out parameter to i40e_xmit_zc()
> and fill it with nb_pkts.

Sorry, but I don't see the value in the second param. NAPI decides what to
do based on nb_pkts. That's the only parameter that matters for the purpose
of NAPI going into poll mode or not, right?

If so: I don't see any reason why a second parameter is necessary.

As I mentioned earlier: if it's just that the name of the parameter isn't
right (e.g., you want it to be 'tx_processed' instead of 'tx_cleaned') then
that's an easy fix; I'll just change the name.

It doesn't seem helpful to have xsk_frames as an out parameter for
i40e_napi_poll tracepoint; that value is not used to determine anything
about i40e's NAPI.

> I am not completely clear on the reasoning behind setting clean_complete
> based on number of packets transmitted in case of XDP.
> >
> >>That might reduce the complexity a bit, and will probably still be pretty
> >>useful for people tuning their non-XDP workloads.
> 
> This option is fine too.

I'll give Jesse a chance to weigh in before I proceed with spinning a v3.
