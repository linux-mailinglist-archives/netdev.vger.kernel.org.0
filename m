Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306522FF89E
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbhAUXTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 18:19:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:2060 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbhAUXTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 18:19:21 -0500
IronPort-SDR: Isb3U2ZAatmr94YLeW872p7fH0od8r47kY1pOvVPTfXKZjgCZMpaxoDvMUxAtV9LBxJg9Lc7ld
 pCSlE9fY7UVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="159141543"
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="159141543"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 15:18:39 -0800
IronPort-SDR: mfNpbFeVLXc62MM26sFUwis9IRyptBiGvw5VuVdjRcOT7jgrQRolwluqoq3v9UWMavRRSJCc3Y
 e549T5LcizXA==
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="392127168"
Received: from amgiffor-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.124.114])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 15:18:38 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v2 1/8] ethtool: Add support for configuring
 frame preemption
In-Reply-To: <20210119181712.18f0ee24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210119004028.2809425-1-vinicius.gomes@intel.com>
 <20210119004028.2809425-2-vinicius.gomes@intel.com>
 <20210119181712.18f0ee24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 21 Jan 2021 15:18:27 -0800
Message-ID: <871redyj3w.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 18 Jan 2021 16:40:21 -0800 Vinicius Costa Gomes wrote:
>> +  ====================================  ======  ==========================
>> +  ``ETHTOOL_A_CHANNELS_HEADER``         nested  request header
>
> ETHTOOL_A_PREEMPT_HEADER
>
>> +  ====================================  ======  ==========================
>> +
>> +Kernel response contents:
>> +
>> +  =====================================  ======  ==========================
>> +  ``ETHTOOL_A_CHANNELS_HEADER``          nested  reply header
>
> here as well
>
>> +  ``ETHTOOL_A_PREEMPT_ENABLED``          u8      frame preemption enabled
>> +  ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE``    u32     Min additional frag size
>> +  =====================================  ======  ==========================
>> +
>> +``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE`` configures the minimum non-final
>> +fragment size that the receiver device supports.
>> +
>> +PREEMPT_SET
>> +============
>> +
>> +Sets frame preemption parameters.
>> +
>> +Request contents:
>> +
>> +  =====================================  ======  ==========================
>> +  ``ETHTOOL_A_CHANNELS_HEADER``          nested  reply header
>
> and here

Ugh. Will fix these copy&pasta mistakes.

>
>> +  ``ETHTOOL_A_PREEMPT_ENABLED``          u8      frame preemption enabled
>> +  ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE``    u32     Min additional frag size
>> +  =====================================  ======  ==========================
>
>> +struct netlink_ext_ack;
>
> Let's move it all the way to the top, right after header includes, so
> we don't have to move it again.

Sure. Will fix.
 
>
>> +/**
>> + * Convert from a Frame Preemption Additional Fragment size in bytes
>> + * to a multiplier. The multiplier is defined as:
>> + *	"A 2-bit integer value used to indicate the minimum size of
>> + *	non-final fragments supported by the receiver on the given port
>> + *	associated with the local System. This value is expressed in units
>> + *	of 64 octets of additional fragment length."
>> + *	Equivalent to `30.14.1.7 aMACMergeAddFragSize` from the IEEE 802.3-2018
>> + *	standard.
>
> Please double check the correct format for kdoc:
>
> https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html
>
> This comment should also be next to the definition of the function, 
> not in the header.

Will fix.


Cheers,
-- 
Vinicius
