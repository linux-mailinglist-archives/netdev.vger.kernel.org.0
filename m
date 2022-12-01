Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12DB63F350
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiLAPFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiLAPFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:05:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F5A37204
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 07:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669907080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P1v4vqnV+AB4eII7BWwX7SB847FIxczykl1tSxBqHZw=;
        b=IMdJbeBYUof/zZaUXF2ktDxY4stq9C+PK9d16Lxat1uyG2knoG/0veQbIhFu/t/5WHFjUV
        sk5h6ZsJmdcp8Uzdx+j3TU3lpZ3bbJsXf5dBNRjgobS1pOEiD60PAfXZO4nPMoyts7RAXp
        3ux2gc3s2JSOuk1z1H3Xfi5EzCEbGJA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-626-5d212GBpN-2zRQQ5VdSY5w-1; Thu, 01 Dec 2022 10:04:38 -0500
X-MC-Unique: 5d212GBpN-2zRQQ5VdSY5w-1
Received: by mail-qv1-f71.google.com with SMTP id c10-20020a05621401ea00b004c72d0e92bcso4659904qvu.12
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 07:04:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P1v4vqnV+AB4eII7BWwX7SB847FIxczykl1tSxBqHZw=;
        b=MuNvRhoJihIXa76KNP6ph/u9RBkZnA1it044cQjWNOWLIWmY1Zx1QIPnYhmTWbXnpe
         vjzQKfScUMGpk42VHSE5UYKpEo8O3MtxTi2VERaXP/gZ8jbb+VRT8HH3SS+pQdTUbkeA
         aER6CK6hXqSdzO5YqEoQlTVnFd8G3Drn9Fa74rp0UblObwSDcgZY5sy6U3T0DhW/aR45
         WSeYWJ0uPk7PN1ppOVOSCbdR73eWp91YcPmMnkggc64OJqXWiiLlcY6MxyC974FxbxvF
         PAw//YhpORP1gJ27MGtR3CgP9ZEXL06N3LSkyC+vSgz9hHjtZSG8DdB2HbgYnx57181E
         5m/A==
X-Gm-Message-State: ANoB5pnRbRF5JznQ/Ue8GA+Ro0JVE+u/GeURnrfcmEq6DklSeZf4WHv0
        0YwPkpKA3An7tEAxI/AuP8L0OnlBGblftolyYCQxJyABKMViRPLtwYzOnQHTE0QFChru1/OoklX
        8xG4ugbZARyFwADqK
X-Received: by 2002:ac8:66d4:0:b0:3a5:3388:4093 with SMTP id m20-20020ac866d4000000b003a533884093mr62014939qtp.262.1669907078008;
        Thu, 01 Dec 2022 07:04:38 -0800 (PST)
X-Google-Smtp-Source: AA0mqf59JOydKh0CJY5F8VqXzy1OtG07puqDDkW5Z9aBfms9PBaoK/DawQ6276Kxlpf3B61KLpT3YQ==
X-Received: by 2002:ac8:66d4:0:b0:3a5:3388:4093 with SMTP id m20-20020ac866d4000000b003a533884093mr62014904qtp.262.1669907077667;
        Thu, 01 Dec 2022 07:04:37 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id o14-20020ac8698e000000b003a580cd979asm2687407qtq.58.2022.12.01.07.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 07:04:37 -0800 (PST)
Message-ID: <0917b04e6a1439d2730bdae2f87a847a3c76951a.camel@redhat.com>
Subject: Re: [PATCH net-next 06/14] ice: handle discarding old Tx requests
 in ice_ptp_tx_tstamp
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        richardcochran@gmail.com, Gurucharan G <gurucharanx.g@intel.com>
Date:   Thu, 01 Dec 2022 16:04:33 +0100
In-Reply-To: <870d718381cea832db341c84ae928ddfc424af64.camel@redhat.com>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
         <20221130194330.3257836-7-anthony.l.nguyen@intel.com>
         <870d718381cea832db341c84ae928ddfc424af64.camel@redhat.com>
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

On Thu, 2022-12-01 at 15:58 +0100, Paolo Abeni wrote:
> On Wed, 2022-11-30 at 11:43 -0800, Tony Nguyen wrote:
> > From: Jacob Keller <jacob.e.keller@intel.com>
> > 
> > Currently the driver uses the PTP kthread to process handling and
> > discarding of stale Tx timestamp requests. The function
> > ice_ptp_tx_tstamp_cleanup is used for this.
> > 
> > A separate thread creates complications for the driver as we now have both
> > the main Tx timestamp processing IRQ checking timestamps as well as the
> > kthread.
> > 
> > Rather than using the kthread to handle this, simply check for stale
> > timestamps within the ice_ptp_tx_tstamp function. This function must
> > already process the timestamps anyways.
> > 
> > If a Tx timestamp has been waiting for 2 seconds we simply clear the bit
> > and discard the SKB. This avoids the complication of having separate
> > threads polling, reducing overall CPU work.
> > 
> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> > Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_ptp.c | 106 ++++++++++-------------
> >  1 file changed, 45 insertions(+), 61 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
> > index 1564c72189bf..58e527f202c0 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_ptp.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
> > @@ -626,15 +626,32 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
> >   * Note that we only take the tracking lock when clearing the bit and when
> >   * checking if we need to re-queue this task. The only place where bits can be
> >   * set is the hard xmit routine where an SKB has a request flag set. The only
> > - * places where we clear bits are this work function, or the periodic cleanup
> > - * thread. If the cleanup thread clears a bit we're processing we catch it
> > - * when we lock to clear the bit and then grab the SKB pointer. If a Tx thread
> > - * starts a new timestamp, we might not begin processing it right away but we
> > - * will notice it at the end when we re-queue the task. If a Tx thread starts
> > - * a new timestamp just after this function exits without re-queuing,
> > - * the interrupt when the timestamp finishes should trigger. Avoiding holding
> > - * the lock for the entire function is important in order to ensure that Tx
> > - * threads do not get blocked while waiting for the lock.
> > + * places where we clear bits are this work function, or when flushing the Tx
> > + * timestamp tracker.
> > + *
> > + * If the Tx tracker gets flushed while we're processing a packet, we catch
> > + * this because we grab the SKB pointer under lock. If the SKB is NULL we know
> > + * that another thread already discarded the SKB and we can avoid passing it
> > + * up to the stack.
> > + *
> > + * If a Tx thread starts a new timestamp, we might not begin processing it
> > + * right away but we will notice it at the end when we re-queue the task.
> > + *
> > + * If a Tx thread starts a new timestamp just after this function exits, the
> > + * interrupt for that timestamp should re-trigger this function once
> > + * a timestamp is ready.
> > + *
> > + * Note that minimizing the time we hold the lock is important. If we held the
> > + * lock for the entire function we would unnecessarily block the Tx hot path
> > + * which needs to set the timestamp index. Limiting how long we hold the lock
> > + * ensures we do not block Tx threads.
> > + *
> > + * If a Tx packet has been waiting for more than 2 seconds, it is not possible
> > + * to correctly extend the timestamp using the cached PHC time. It is
> > + * extremely unlikely that a packet will ever take this long to timestamp. If
> > + * we detect a Tx timestamp request that has waited for this long we assume
> > + * the packet will never be sent by hardware and discard it without reading
> > + * the timestamp register.
> >   */
> >  static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
> >  {
> > @@ -653,9 +670,20 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
> >  		struct skb_shared_hwtstamps shhwtstamps = {};
> >  		u8 phy_idx = idx + tx->offset;
> >  		u64 raw_tstamp, tstamp;
> > +		bool drop_ts = false;
> >  		struct sk_buff *skb;
> >  		int err;
> >  
> > +		/* Drop packets which have waited for more than 2 seconds */
> > +		if (time_is_before_jiffies(tx->tstamps[idx].start + 2 * HZ)) {
> > +			drop_ts = true;
> > +
> > +			/* Count the number of Tx timestamps that timed out */
> > +			pf->ptp.tx_hwtstamp_timeouts++;
> > +
> > +			goto skip_ts_read;
> 
> This skips raw_tstamp initialization and causes later compiler warning
> when accessing raw_tstamp.
> 
> You probably need to duplicate/factor out a bit of later code to fix
> this.

Ah, I see the warning is resolved in the next patch. Perhaps it's
worthy to move the relevant chunk here?

Thanks,

Paolo

