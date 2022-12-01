Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3C163F343
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiLAPAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiLAO77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 09:59:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA8D303C9
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 06:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669906738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+uYBljK/NL1VBBGgMtdpXJ4o7v4qjWy0b00U/1xaN3w=;
        b=RSL800qHLVpmvktx9e0DuVmRLGo0eIPt3Gpx5UQfTGW+jkAxP2wuirZU3iOuyZam/PkKmP
        69uyi3x/gfr+YXZ7oE8jX28feFOf4wLs6W9WVLlsQwavHnYgj5RlpPC5RwNoFXLjrjEoA7
        BpglYbJJUbxUzr8uVARjuPlw7gmSTgI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-341-Ow2k6nboPIa8NYACpQTHuA-1; Thu, 01 Dec 2022 09:58:57 -0500
X-MC-Unique: Ow2k6nboPIa8NYACpQTHuA-1
Received: by mail-qk1-f198.google.com with SMTP id f13-20020a05620a408d00b006fc740f837eso6928609qko.20
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 06:58:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+uYBljK/NL1VBBGgMtdpXJ4o7v4qjWy0b00U/1xaN3w=;
        b=iUl+vjauz1PYFDUKIOx3matdUAunR8ktKjfYGmzXuYDbJAiGXiN99h6zyllHtHgXnL
         sQzYA/2/NhIBNJKJtyqdhim1sFwOYY4VUsrds1XV7xD/UDslrghkwGDwM7dsdYwyE+Fd
         7/Gkge5FY2y2J6fm9CYO4bjjM56YgqozkhcHhgAKL//k6ZWnBdsu2KU3guS8g6YQkaDY
         GeoJEdKjZMy75qZAd65aU+sR5t2KazBuCgU9VhJmKbeWh4LhcX/H0bAS6oNUGnGhjPqe
         JKSIU44YV5o2w/cLLiVGhPNWcGzvat6iLs9bgsCeQWFlgmlVVfzXBBDL4rB02MsJGls9
         dooA==
X-Gm-Message-State: ANoB5pk6UK1u8AVUdHnke3HQjSxtmxhNKo/ewD3e1wz8TVbu+Z9Z5ENm
        2lwOJPQ4xhojg7QW+xAz6r4B7hPOtnGzm38AWfrC94nraSk0c/LvAlMkFfhUpQFjLDPlWSRIIhM
        0Nk/0iltliw5zOmGX
X-Received: by 2002:ac8:4501:0:b0:3a5:cb81:aff5 with SMTP id q1-20020ac84501000000b003a5cb81aff5mr52566998qtn.662.1669906736721;
        Thu, 01 Dec 2022 06:58:56 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5y6mjM8R+Hfsode1IfdFZaGlKGa65JfGakrcgShNK8G4fIYO1fZdwQNVXFWYTBNKm9gi7YnA==
X-Received: by 2002:ac8:4501:0:b0:3a5:cb81:aff5 with SMTP id q1-20020ac84501000000b003a5cb81aff5mr52566976qtn.662.1669906736403;
        Thu, 01 Dec 2022 06:58:56 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id bn2-20020a05620a2ac200b006fbbffd08f9sm3357320qkb.87.2022.12.01.06.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 06:58:56 -0800 (PST)
Message-ID: <870d718381cea832db341c84ae928ddfc424af64.camel@redhat.com>
Subject: Re: [PATCH net-next 06/14] ice: handle discarding old Tx requests
 in ice_ptp_tx_tstamp
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        richardcochran@gmail.com, Gurucharan G <gurucharanx.g@intel.com>
Date:   Thu, 01 Dec 2022 15:58:52 +0100
In-Reply-To: <20221130194330.3257836-7-anthony.l.nguyen@intel.com>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
         <20221130194330.3257836-7-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-11-30 at 11:43 -0800, Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> Currently the driver uses the PTP kthread to process handling and
> discarding of stale Tx timestamp requests. The function
> ice_ptp_tx_tstamp_cleanup is used for this.
> 
> A separate thread creates complications for the driver as we now have both
> the main Tx timestamp processing IRQ checking timestamps as well as the
> kthread.
> 
> Rather than using the kthread to handle this, simply check for stale
> timestamps within the ice_ptp_tx_tstamp function. This function must
> already process the timestamps anyways.
> 
> If a Tx timestamp has been waiting for 2 seconds we simply clear the bit
> and discard the SKB. This avoids the complication of having separate
> threads polling, reducing overall CPU work.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c | 106 ++++++++++-------------
>  1 file changed, 45 insertions(+), 61 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
> index 1564c72189bf..58e527f202c0 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ptp.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
> @@ -626,15 +626,32 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
>   * Note that we only take the tracking lock when clearing the bit and when
>   * checking if we need to re-queue this task. The only place where bits can be
>   * set is the hard xmit routine where an SKB has a request flag set. The only
> - * places where we clear bits are this work function, or the periodic cleanup
> - * thread. If the cleanup thread clears a bit we're processing we catch it
> - * when we lock to clear the bit and then grab the SKB pointer. If a Tx thread
> - * starts a new timestamp, we might not begin processing it right away but we
> - * will notice it at the end when we re-queue the task. If a Tx thread starts
> - * a new timestamp just after this function exits without re-queuing,
> - * the interrupt when the timestamp finishes should trigger. Avoiding holding
> - * the lock for the entire function is important in order to ensure that Tx
> - * threads do not get blocked while waiting for the lock.
> + * places where we clear bits are this work function, or when flushing the Tx
> + * timestamp tracker.
> + *
> + * If the Tx tracker gets flushed while we're processing a packet, we catch
> + * this because we grab the SKB pointer under lock. If the SKB is NULL we know
> + * that another thread already discarded the SKB and we can avoid passing it
> + * up to the stack.
> + *
> + * If a Tx thread starts a new timestamp, we might not begin processing it
> + * right away but we will notice it at the end when we re-queue the task.
> + *
> + * If a Tx thread starts a new timestamp just after this function exits, the
> + * interrupt for that timestamp should re-trigger this function once
> + * a timestamp is ready.
> + *
> + * Note that minimizing the time we hold the lock is important. If we held the
> + * lock for the entire function we would unnecessarily block the Tx hot path
> + * which needs to set the timestamp index. Limiting how long we hold the lock
> + * ensures we do not block Tx threads.
> + *
> + * If a Tx packet has been waiting for more than 2 seconds, it is not possible
> + * to correctly extend the timestamp using the cached PHC time. It is
> + * extremely unlikely that a packet will ever take this long to timestamp. If
> + * we detect a Tx timestamp request that has waited for this long we assume
> + * the packet will never be sent by hardware and discard it without reading
> + * the timestamp register.
>   */
>  static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
>  {
> @@ -653,9 +670,20 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
>  		struct skb_shared_hwtstamps shhwtstamps = {};
>  		u8 phy_idx = idx + tx->offset;
>  		u64 raw_tstamp, tstamp;
> +		bool drop_ts = false;
>  		struct sk_buff *skb;
>  		int err;
>  
> +		/* Drop packets which have waited for more than 2 seconds */
> +		if (time_is_before_jiffies(tx->tstamps[idx].start + 2 * HZ)) {
> +			drop_ts = true;
> +
> +			/* Count the number of Tx timestamps that timed out */
> +			pf->ptp.tx_hwtstamp_timeouts++;
> +
> +			goto skip_ts_read;

This skips raw_tstamp initialization and causes later compiler warning
when accessing raw_tstamp.

You probably need to duplicate/factor out a bit of later code to fix
this.

Cheers,

Paolo

