Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F9F2D1D55
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 23:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbgLGWag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 17:30:36 -0500
Received: from mga07.intel.com ([134.134.136.100]:1328 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbgLGWaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 17:30:35 -0500
IronPort-SDR: i+JevJtq4hKmTPIXkXXozccr8NzDA6QBIPu3b1zDxYWSNiDwRF6lS6goKK3Ut9wHXBSZcKN+wk
 jrshwAS1CCWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="237895444"
X-IronPort-AV: E=Sophos;i="5.78,400,1599548400"; 
   d="scan'208";a="237895444"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 14:29:54 -0800
IronPort-SDR: L5Soz7wYDp4oNjcX/ydMMdKhCQ3nVA9Iu1Jng82x3Nai/m8JqiOz3rY33gTMqP3XXINPyWX3Y0
 Z73XTmSEGEvg==
X-IronPort-AV: E=Sophos;i="5.78,400,1599548400"; 
   d="scan'208";a="363343787"
Received: from seherahx-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.17.196])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 14:29:54 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v1 8/9] igc: Add support for exposing frame
 preemption stats registers
In-Reply-To: <20201205095948.5e0eba28@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
 <20201202045325.3254757-9-vinicius.gomes@intel.com>
 <20201205095948.5e0eba28@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Mon, 07 Dec 2020 14:29:54 -0800
Message-ID: <87v9ddz1ul.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue,  1 Dec 2020 20:53:24 -0800 Vinicius Costa Gomes wrote:
>> Expose the Frame Preemption counters, so the number of
>> express/preemptible packets can be monitored by userspace.
>> 
>> These registers are cleared when read, so the value shown is the
>> number of events that happened since the last read.
>> 
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>
> You mean expose in a register dump? That's not great user experience..

I can agree with that, even after some formatting on the ethtool side:

Preemption statistics:
    TX Preemption event counter: 14070
    Good TX Preemptable Packets: 201957
    Good TX Express Packets: 32031
    TX Preempted Packets: 13259
    RX Preemption event counter: 0
    Good RX Preemptable Packets: 0
    Good RX Preempted Packets: 0
    Preemption Exception Counter:
        OOO_SMDC 0
        OOO_FRAME 0
        OOO_FRAG 0
        MISS_FRAME_FRAG 0

It's less than ideal, but useful for development/debugging.

>
> Are there any stats that the standards mandate?

I just took abother look at the standard, mainly at the MIBs, there are
no statistics related to frame preemption that I could find, only
configuration stuff.

>
> It'd be great if we could come up with some common set and expose them
> via ethtool like the pause frame statistics.

Agreed, will drop this patch, until this common set is agreed upon.


Cheers,
-- 
Vinicius
