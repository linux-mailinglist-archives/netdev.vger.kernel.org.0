Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6813ED04BA
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 02:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbfJIAVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 20:21:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:22116 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728792AbfJIAVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 20:21:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 17:21:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="394853045"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 08 Oct 2019 17:21:21 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v1] net: taprio: Fix returning EINVAL when configuring without flags
In-Reply-To: <CA+h21hoc=shDEHSN-SEyO3qS7sBW4GzswcVrHW-7Sud9aP7apA@mail.gmail.com>
References: <20191008232007.16083-1-vinicius.gomes@intel.com> <CA+h21hoc=shDEHSN-SEyO3qS7sBW4GzswcVrHW-7Sud9aP7apA@mail.gmail.com>
Date:   Tue, 08 Oct 2019 17:22:13 -0700
Message-ID: <87pnj66a4q.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Vladimir Oltean <olteanv@gmail.com> writes:

> Hi Vinicius,
>
> On Wed, 9 Oct 2019 at 02:19, Vinicius Costa Gomes
> <vinicius.gomes@intel.com> wrote:
>>
>> When configuring a taprio instance if "flags" is not specified (or
>> it's zero), taprio currently replies with an "Invalid argument" error.
>>
>> So, set the return value to zero after we are done with all the
>> checks.
>>
>> Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> ---
>
> You mean clockid, not flags, right?

I do mean "flags", yeah. The case I was testing was something like this:

$ tc qdisc replace dev $IFACE parent root handle 100 taprio \
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 2@2 \
      base-time $BASE_TIME \
      sched-entry S 01 300000 \
      sched-entry S 02 300000 \
      sched-entry S 04 400000 \
      clockid CLOCK_TAI


Cheers,
--
Vinicius
