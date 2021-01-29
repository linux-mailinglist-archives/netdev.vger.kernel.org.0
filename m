Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0686030907A
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhA2XN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:13:56 -0500
Received: from mga12.intel.com ([192.55.52.136]:8868 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231287AbhA2XNx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 18:13:53 -0500
IronPort-SDR: z9zK3GWsdfj5rBObddgaC+JkPC0/llffQNVp9C+wsOjJTmUVJIXQYkMsgUlm47D/ONxXAvygwf
 /423cz/GMvmw==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="159663693"
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="159663693"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 15:13:12 -0800
IronPort-SDR: IP3ldZjSX8dNItA2zvtEg14fcKo1sT8oSp9Med1Xh/wWOHaEvG3yXgXnESEjNv+4I/DOVer3t7
 3nxa56QtDt1A==
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="574263502"
Received: from ndatiri-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.145.249])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 15:13:12 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 2/8] taprio: Add support for frame
 preemption offload
In-Reply-To: <20210129135702.0f8cf702@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-3-vinicius.gomes@intel.com>
 <20210126000924.jjkjruzmh5lgrkry@skbuf>
 <87wnvvsayz.fsf@vcostago-mobl2.amr.corp.intel.com>
 <20210129135702.0f8cf702@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Fri, 29 Jan 2021 15:12:58 -0800
Message-ID: <878s8bs5fp.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
>> > First I'm interested in the means: why check for preempt == U32_MAX when
>> > you determine that all traffic classes are preemptible? What if less
>> > than 32 traffic classes are used by the netdev? The check will be
>> > bypassed, won't it?  
>> 
>> Good catch :-)
>> 
>> I wanted to have this (at least one express queue) handled in a
>> centralized way, but perhaps this should be handled best per driver.
>
> Centralized is good. Much easier than reviewing N drivers to make sure
> they all behave the same, and right.

The issue is that it seems that not all drivers/hw have the same
limitation: that at least one queue needs to be configured as
express/not preemptible.

That's the point I was trying to make when I suggested for the check to
be done per-driver, different limitations.


Cheers,
-- 
Vinicius
