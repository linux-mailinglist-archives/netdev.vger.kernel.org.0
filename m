Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08377594E3B
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 03:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbiHPBrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 21:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245708AbiHPBq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 21:46:27 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0102C1FF8CD
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660599575; x=1692135575;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=leggy+yjJJpRhm0/+HJ35rCKQaQNrEHBj6WJXZm9l8s=;
  b=ITuHN3yBekXhNdBDJuS/8TUxctRxAHLtELk5yQ3HLxNF9Tk+FJvfqJcs
   zq/EN4JB5XeFRqe+tWoWH9+gvD+EsVk4Vk0z1trksbj+Lsdkn3hwbK+6f
   GXkYSbgSydAyIS1mYXcUHfe7G6m59yLGWat+DxIDgnVyNdT2/rGxYN0FB
   kaq05wKlA5yXTv48TvhaRmcrs7bp9CiBQJwwzdx/7PzFmupAaTHkIEKEP
   UqtUbqqr9kSWIcqmQ07e4QkeR7frRbtzXk3zJ0NCbwGSHzRvNZf4BC8jT
   2MtIHFyINxc73iEYnFFoGhWJ08uF7RvRC+v1J/OSj/bBF8OmKhPrbHPDB
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="272454921"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="272454921"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 14:39:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="666821440"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 14:39:34 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
In-Reply-To: <20220812201654.qx7e37otu32pxnbk@skbuf>
References: <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <87tu7emqb9.fsf@intel.com>
 <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
 <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <20220812201654.qx7e37otu32pxnbk@skbuf>
Date:   Mon, 15 Aug 2022 14:39:33 -0700
Message-ID: <87v8qti3u2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> Hi Ferenc,
>
> On Fri, Aug 12, 2022 at 02:13:52PM +0000, Ferenc Fejes wrote:
>> Ethtool after the measurement:
>> ethtool -S enp3s0 | grep hwtstamp
>>      tx_hwtstamp_timeouts: 1
>>      tx_hwtstamp_skipped: 419
>>      rx_hwtstamp_cleared: 0
>> 
>> Which is inline with what the isochron see.
>> 
>> But thats only happens if I forcingly put the affinity of the sender
>> different CPU core than the ptp worker of the igc. If those running on
>> the same core I doesnt lost any HW timestam even for 10 million
>> packets. Worth to mention actually I see many lost timestamp which
>> confused me a little bit but those are lost because of the small
>> MSG_ERRQUEUE. When I increased that from few kbytes to 20 mbytes I got
>> every timestamp successfully.
>
> I have zero knowledge of Intel hardware. That being said, I've looked at
> the driver for about 5 minutes, and the design seems to be that where
> the timestamp is not available in band from the TX completion NAPI as
> part of BD ring metadata, but rather, a TX timestamp complete is raised,
> and this results in igc_tsync_interrupt() being called. However there
> are 2 paths in the driver which call this, one is igc_msix_other() and
> the other is igc_intr_msi() - this latter one is also the interrupt that
> triggers the napi_schedule(). It would be interesting to see exactly
> which MSI-X interrupt is the one that triggers igc_tsync_interrupt().

Just some aditional information (note that I know very little about
interrupt internal workings), igc_intr_msi() is called when MSI-X is not
enabled (i.e. "MSI only" system), igc_msix_other() is called when MSI-X
is available. When MSI-X is available, i225/i226 sets up a separate
interrupt handler for "general" events, the TX timestamp being available
to be read from the registers is one those events.

>
> It's also interesting to understand what you mean precisely by affinity
> of isochron. It has a main thread (used for PTP monitoring and for TX
> timestamps) and a pthread for the sending process. The main thread's
> affinity is controlled via taskset; the sender thread via --cpu-mask.
> Is it the *sender* thread the one who makes the TX timestamps be
> available quicker to user space, rather than the main thread, who
> actually dequeues them from the error queue? If so, it might be because
> the TX packets will trigger the TX completion interrupt, and this will
> accelerate the processing of the TX timestamps. I'm unclear what happens
> when the sender thread runs on a different CPU core than the TX
> timestamp thread.
>
> Your need to increase the SO_RCVBUF is also interesting. Keep in mind
> that isochron at that scheduling priority and policy is a CPU hog, and
> that igc_tsync_interrupt() calls schedule_work() - which uses the system
> workqueue that runs at a very low priority (this begs the question, how
> do you know how to match the CPU on which isochron runs with the CPU of
> the system workqueue?). So isochron, high priority, competes for CPU
> time with igc_ptp_tx_work(), low priority. One produces data, one
> consumes it; queues are bound to get full at some point.
> On the other hand, other drivers use the ptp_aux_kworker() that the PTP
> core creates specifically for this purpose. It is a dedicated kthread
> whose scheduling policy and priority can be adjusted using chrt. I think
> it would be interesting to see how things behave when you replace
> schedule_work() with ptp_schedule_worker().

I was planning to do the conversion to use the PTP aux worker thread at
some point, perhaps this is the "excuse" I was looking for.


Cheers,
-- 
Vinicius
