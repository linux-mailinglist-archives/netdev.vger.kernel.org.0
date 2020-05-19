Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34C51D9E2D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 19:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgESRtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 13:49:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:44933 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgESRtT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 13:49:19 -0400
IronPort-SDR: mHE+khGHz4PSIQ7vDLaSQ5z0KT5oaTPzKfMifC1FMP4x8sEGJCY7DWObytRrKIkDff+XfU8KrQ
 wjNEMa6KkKmQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 10:49:05 -0700
IronPort-SDR: MYW1UuulTzlhBMvTgl1szX1qyh5J9CHwu/jTPJeIQLCFA3iFS92wri7b23GBe48OFv0XFwY6xG
 nUT8iY49OnXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="466218150"
Received: from stputhen-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.5.127])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 10:49:05 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, olteanv@gmail.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, vladimir.oltean@nxp.com, po.liu@nxp.com,
        Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
In-Reply-To: <29959a1a-fc45-6870-fa11-311866b51aa0@ti.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com> <20200516.133739.285740119627243211.davem@davemloft.net> <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com> <20200516.151932.575795129235955389.davem@davemloft.net> <87wo59oyhr.fsf@intel.com> <20200518135613.379f6a63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <87h7wcq4nx.fsf@intel.com> <29959a1a-fc45-6870-fa11-311866b51aa0@ti.com>
Date:   Tue, 19 May 2020 10:49:04 -0700
Message-ID: <87ftbvolwv.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Murali Karicheri <m-karicheri2@ti.com> writes:

>> That was the (only?) strong argument in favor of having frame preemption
>> in the TC side when this was last discussed.
>> 
>> We can have a hybrid solution, we can move the express/preemptible per
>> queue map to mqprio/taprio/whatever. And have the more specific
>> configuration knobs, minimum fragment size, etc, in ethtool.
>
> Isn't this a pure h/w feature? FPE is implemented at L2 and involves
> fragments that are only seen by h/w and never at Linux network core
> unlike IP fragments and is transparent to network stack. However it
> enhances priority handling at h/w to the next level by pre-empting 
> existing lower priority traffic to give way to express queue traffic
> and improve latency. So everything happens in h/w. So ethtool makes
> perfect sense here as it is a queue configuration. I agree with Vinicius
> and Vladmir to support this in ethtool instead of TC.

The way I see, the issue that Jakub is pointing here is more of
usability/understandability.

By having the express/preemptible queue mapping in TC, we have the
configuration near where the "priority to queue" mapping happens. That
improves the ease of configuration, makes it easier to spot mistakes,
that kind of thing, all of which are a big plus.

Right now, I am seeing this hybrid approach as a good compromise, we
have the queue settings near to where the kinds of traffic are mapped to
queues, and we have the rest of the hardware configuration in ethtool.


Cheers,
-- 
Vinicius
