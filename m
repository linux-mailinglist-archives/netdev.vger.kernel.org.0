Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FC11DC17E
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 23:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgETVma convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 May 2020 17:42:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:18002 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbgETVma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 17:42:30 -0400
IronPort-SDR: uRhFTb3Uz3Pmu4+8qhcVGibI/89t3Vx7dNrbdeT5kLbsLzDtFh0LSuXrCcHNoy9MnR+B8ENWJt
 KkOCZ3zbdLlQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 14:42:30 -0700
IronPort-SDR: SFHmI0WESzRLt1wSE1FSQ6zpEr/u/O2HaexdYcGDlqUpfhIz8TFSyByQFdMh5q3BMU5GkcVA3/
 0N/nvMzIOTEg==
X-IronPort-AV: E=Sophos;i="5.73,415,1583222400"; 
   d="scan'208";a="255127925"
Received: from djmeffe-mobl1.amr.corp.intel.com (HELO localhost) ([10.255.230.216])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 14:42:29 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200518160906.40e9d8bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com> <20200516.133739.285740119627243211.davem@davemloft.net> <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com> <20200516.151932.575795129235955389.davem@davemloft.net> <87wo59oyhr.fsf@intel.com> <20200518135613.379f6a63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <87h7wcq4nx.fsf@intel.com> <20200518152259.29d2e3c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <87blmkq1y3.fsf@intel.com> <20200518160906.40e9d8bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [Intel-wired-lan] [next-queue RFC 0/4] ethtool: Add support for frame preemption
From:   Andre Guedes <andre.guedes@intel.com>
Cc:     Jose.Abreu@synopsys.com, vladimir.oltean@nxp.com, po.liu@nxp.com,
        m-karicheri2@ti.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, olteanv@gmail.com,
        David Miller <davem@davemloft.net>
To:     Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date:   Wed, 20 May 2020 14:42:25 -0700
Message-ID: <159001094525.59702.8769665430201911136@sdkini-mobl1.amr.corp.intel.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Quoting Jakub Kicinski (2020-05-18 16:09:06)
> On Mon, 18 May 2020 16:05:08 -0700 Vinicius Costa Gomes wrote:
> > Jakub Kicinski <kuba@kernel.org> writes:
> > >> That was the (only?) strong argument in favor of having frame preemption
> > >> in the TC side when this was last discussed.
> > >> 
> > >> We can have a hybrid solution, we can move the express/preemptible per
> > >> queue map to mqprio/taprio/whatever. And have the more specific
> > >> configuration knobs, minimum fragment size, etc, in ethtool.
> > >> 
> > >> What do you think?  
> > >
> > > Does the standard specify minimum fragment size as a global MAC setting?  
> > 
> > Yes, it's a per-MAC setting, not per-queue. 
> 
> If standard defines it as per-MAC and we can reasonably expect vendors
> won't try to "add value" and make it per queue (unlikely here AFAIU),
> then for this part ethtool configuration seems okay to me.

Before we move forward with this hybrid approach, let's recap a few points that
we discussed in the previous thread and make sure it addresses them properly.

1) Frame Preemption (FP) can be enabled without EST, as described in IEEE
802.1Q. In this case, the user has to create a dummy EST schedule in taprio
just to be able to enable FP, which doesn't look natural.

2) Mpqrio already looks overloaded. Besides mapping traffic classes into
hardware queues, it also supports different modes and traffic shaping. Do we
want to add yet another setting to it?

Regards,

Andre
