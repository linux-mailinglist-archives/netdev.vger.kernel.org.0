Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AC4456A5C
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 07:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhKSGoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 01:44:14 -0500
Received: from mga03.intel.com ([134.134.136.65]:49519 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhKSGoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 01:44:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="234315787"
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="234315787"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 22:41:11 -0800
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="594108957"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.190.52]) ([10.212.190.52])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 22:41:10 -0800
Message-ID: <94a1ea50-8c83-aa65-6905-d8e6aacf3d65@linux.intel.com>
Date:   Thu, 18 Nov 2021 22:41:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 04/14] net: wwan: t7xx: Add port proxy infrastructure
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-5-ricardo.martinez@linux.intel.com>
 <YYKs+DHYRHYFEYEN@smile.fi.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <YYKs+DHYRHYFEYEN@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/3/2021 8:38 AM, Andy Shevchenko wrote:
> On Sun, Oct 31, 2021 at 08:56:25PM -0700, Ricardo Martinez wrote:
>> From: Haijun Lio <haijun.liu@mediatek.com>
>>
>> Port-proxy provides a common interface to interact with different types
>> of ports. Ports export their configuration via `struct t7xx_port` and
>> operate as defined by `struct port_ops`.
> Same here, assuming that the comments from the previous patches are applied
> here as well, only unique are given.

Thanks for the feedback.

...

>> +	nlh = nlmsg_put(nl_skb, 0, 1, NLMSG_DONE, len, 0);
>> +	if (!nlh) {
>> +		dev_err(port->dev, "could not release netlink\n");
> I'm wondering why you are not using net_err() / netdev_err() / netif_err()
> where it's appropriate.

The original idea was to avoid mixing different types of APIs, but yes, 
it makes sense to use

those APIs where it's appropriate, I'm thinking on using them at 
t7xx_netdev.c where the

required net_device is available.

...

>> +		nlmsg_free(nl_skb);
>> +		return -EFAULT;
>> +	}
>>
>> ...
>>
>> +	ccci_h = (struct ccci_header *)skb->data;
> Do you need casting?
Yes, skb->data is an unsigned char*
> ...
...

