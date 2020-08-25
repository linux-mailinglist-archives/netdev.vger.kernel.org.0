Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DD4251EA2
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgHYRuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:50:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:30548 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbgHYRuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 13:50:51 -0400
IronPort-SDR: 61xovL9MLi8AsEGvSw4FzZ2NPSJcNJ4Kks8gGo9FZOx/NRGaC1lRo/EONcI3dOimW9nFKI711d
 TPiKIcJ2LXyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="135718451"
X-IronPort-AV: E=Sophos;i="5.76,353,1592895600"; 
   d="scan'208";a="135718451"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 10:50:50 -0700
IronPort-SDR: mBy4kAEHercHMbotNfm9BjCeJlV7ysa+UDvg8fICyG6emBZiknw+7rsDFbfvm9avTEC0JzKnb8
 bJT8ln0mMtNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,353,1592895600"; 
   d="scan'208";a="499399872"
Received: from adent-mobl.amr.corp.intel.com (HELO ellie) ([10.209.77.195])
  by fmsmga006.fm.intel.com with ESMTP; 25 Aug 2020 10:50:50 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <87bliz13kj.fsf@kurt>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <87pn7ftx6b.fsf@intel.com> <87bliz13kj.fsf@kurt>
Date:   Tue, 25 Aug 2020 10:50:50 -0700
Message-ID: <87d03ety11.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

Kurt Kanzenbach <kurt@linutronix.de> writes:

> On Mon Aug 24 2020, Vinicius Costa Gomes wrote:
>> Hi,
>>
>> Kurt Kanzenbach <kurt@linutronix.de> writes:
>>
> [snip]
>>> +	/* Setup timer for schedule switch: The IP core only allows to set a
>>> +	 * cycle start timer 8 seconds in the future. This is why we setup the
>>> +	 * hritmer to base_time - 5 seconds. Then, we have enough time to
>>> +	 * activate IP core's EST timer.
>>> +	 */
>>> +	start = ktime_sub_ns(schedule->base_time, (u64)5 * NSEC_PER_SEC);
>>> +	hrtimer_start_range_ns(&hellcreek_port->cycle_start_timer, start,
>>> +			       NSEC_PER_SEC, HRTIMER_MODE_ABS);
>>
>> If we are talking about seconds here, I don't think you need to use a
>> hrtimer, you could use a workqueue/delayed_work. Should make things a
>> bit simpler.
>
> I've used hrtimers for one reason: The hrtimer provides a way to fire at
> an absolute base time based on CLOCK_TAI. All the other facilities such
> as workqueues, timer list timers, etc do not.

Oh, yeah. Good point.


Cheers,
-- 
Vinicius
