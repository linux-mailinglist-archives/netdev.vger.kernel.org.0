Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA8A1DC218
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 00:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgETWfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 18:35:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:2464 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbgETWfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 18:35:45 -0400
IronPort-SDR: sb/rL2+03NlW44RZKUsDU3u+V2TieCIR5uXK7gY8ptXT0YHImKU4POpFFQD7662ZJq3SEjAiVG
 1k/KIvz81+Yg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 15:35:44 -0700
IronPort-SDR: ZEJSJqmURq3x/rur5ku7fc6VeKIe7MNloL9OorldYn2IJaY6dNX5V6iSf7hr/T6eqrWC7JuSuM
 yn/Sv0mTKxBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,415,1583222400"; 
   d="scan'208";a="466694791"
Received: from alopezch-mobl.amr.corp.intel.com (HELO ellie) ([10.213.162.205])
  by fmsmga006.fm.intel.com with ESMTP; 20 May 2020 15:35:44 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Andre Guedes <andre.guedes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jose.Abreu@synopsys.com, vladimir.oltean@nxp.com, po.liu@nxp.com,
        m-karicheri2@ti.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, olteanv@gmail.com,
        David Miller <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [next-queue RFC 0/4] ethtool: Add support for frame preemption
In-Reply-To: <159001094525.59702.8769665430201911136@sdkini-mobl1.amr.corp.intel.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com> <20200516.133739.285740119627243211.davem@davemloft.net> <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com> <20200516.151932.575795129235955389.davem@davemloft.net> <87wo59oyhr.fsf@intel.com> <20200518135613.379f6a63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <87h7wcq4nx.fsf@intel.com> <20200518152259.29d2e3c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <87blmkq1y3.fsf@intel.com> <20200518160906.40e9d8bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <159001094525.59702.8769665430201911136@sdkini-mobl1.amr.corp.intel.com>
Date:   Wed, 20 May 2020 15:35:44 -0700
Message-ID: <874ksamdz3.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andre Guedes <andre.guedes@intel.com> writes:

>> If standard defines it as per-MAC and we can reasonably expect vendors
>> won't try to "add value" and make it per queue (unlikely here AFAIU),
>> then for this part ethtool configuration seems okay to me.
>
> Before we move forward with this hybrid approach, let's recap a few points that
> we discussed in the previous thread and make sure it addresses them
> properly.

Thanks for bringing them up.

>
> 1) Frame Preemption (FP) can be enabled without EST, as described in IEEE
> 802.1Q. In this case, the user has to create a dummy EST schedule in taprio
> just to be able to enable FP, which doesn't look natural.

What I meant by "dummy" schedule, is to configure taprio without
specifying any "sched-entry". And since we have support for adding
schedules during runtime, this might be even useful in general.

>
> 2) Mpqrio already looks overloaded. Besides mapping traffic classes into
> hardware queues, it also supports different modes and traffic shaping. Do we
> want to add yet another setting to it?

I also don't see this as a problem. The parameters that mqprio has carry
a lot of information, but the number of them is not that big.


Cheers,
-- 
Vinicius
