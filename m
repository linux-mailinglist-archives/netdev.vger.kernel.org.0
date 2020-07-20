Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DD4226E94
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgGTSyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:54:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:63968 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgGTSyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 14:54:31 -0400
IronPort-SDR: UT2O3PE8gQIy7GYxBHetap2zCtHc3wfzMVqT6cTP3vv6TJN1oi9Ul3TccjJ5iozQVKpYf4G79N
 5VFnUcFGsZRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="129560750"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="129560750"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 11:54:31 -0700
IronPort-SDR: ZISKvJsPG7t4mbCtgmY/ZuV8UN754XJyY5u6HmECqr4PZhQJ4Yc5kPTWsOFgOAGHFGxZ5OwrF0
 FjIbndAC/pxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="309951390"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.252.137.6]) ([10.252.137.6])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jul 2020 11:54:31 -0700
Subject: Re: [PATCH net-next 3/3] docs: networking: timestamping: add a set of
 frequently asked questions
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-4-olteanv@gmail.com>
 <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
 <20200718113519.htopj6tgfvimaywn@skbuf>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <887fcc0d-4f3d-3cb8-bdea-8144b62c5d85@intel.com>
Date:   Mon, 20 Jul 2020 11:54:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200718113519.htopj6tgfvimaywn@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/18/2020 4:35 AM, Vladimir Oltean wrote:
> On Fri, Jul 17, 2020 at 04:12:07PM -0700, Jacob Keller wrote:
>> On 7/17/2020 9:10 AM, Vladimir Oltean wrote:
>>> +When the interface they represent offers both ``SOF_TIMESTAMPING_TX_HARDWARE``
>>> +and ``SOF_TIMESTAMPING_TX_SOFTWARE``.
>>> +Originally, the network stack could deliver either a hardware or a software
>>> +time stamp, but not both. This flag prevents software timestamp delivery.
>>> +This restriction was eventually lifted via the ``SOF_TIMESTAMPING_OPT_TX_SWHW``
>>> +option, but still the original behavior is preserved as the default.
>>> +
>>
>> So, this implies that we set this only if both are supported? I thought
>> the intention was to set this flag whenever we start a HW timestamp.
>>
> 
> It's only _required_ when SOF_TIMESTAMPING_TX_SOFTWARE is used, it
> seems. I had also thought of setting 'SKBTX_IN_PROGRESS' as good
> practice, but there are many situations where it can do more harm than
> good.
> 

I guess I've only ever implemented a driver with software timestamping
enabled as an option. What sort of issues arise when you have this set?
I'm guessing that it's some configuration of stacked devices as in the
other cases? If the issue can't be fixed I'd at least like more
explanation here, since the prevailing convention is that we set this
flag, so understanding when and why it's problematic would be useful.

Thanks,
Jake
