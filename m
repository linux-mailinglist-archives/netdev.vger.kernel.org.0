Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6E926E7AD
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 23:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgIQVsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 17:48:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:11736 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgIQVsg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 17:48:36 -0400
IronPort-SDR: jRxvhOvAyKFRAKG4POtDmJZdbOLKFpHngnI7FqFkPfUn3kFsdbC0Z0MAlG9ag/+OESqNF0MtWk
 MseN3o52Roqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="177899243"
X-IronPort-AV: E=Sophos;i="5.77,272,1596524400"; 
   d="scan'208";a="177899243"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 14:48:34 -0700
IronPort-SDR: DX1pqr/rasoGJGjKeGOdu7eMEy4RC3SvbgMQmyF6vW6QUwgqGohfhguGYmPQ9DQ5WmkoPalbwy
 QVgicDjCtLXA==
X-IronPort-AV: E=Sophos;i="5.77,272,1596524400"; 
   d="scan'208";a="483919158"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.151.155]) ([10.212.151.155])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 14:48:33 -0700
Subject: Re: [RFC][Patch v1 1/3] sched/isolation: API to get num of
 hosekeeping CPUs
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, frederic@kernel.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
References: <20200917201123.GA1726926@bjorn-Precision-5520>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <238f4d32-ac26-e0c6-b53c-9f7ab98050ca@intel.com>
Date:   Thu, 17 Sep 2020 14:48:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200917201123.GA1726926@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 1:11 PM, Bjorn Helgaas wrote:
> [+cc Ingo, Peter, Juri, Vincent (scheduler maintainers)]
> 
> s/hosekeeping/housekeeping/ (in subject)
> 
> On Wed, Sep 09, 2020 at 11:08:16AM -0400, Nitesh Narayan Lal wrote:
>> Introduce a new API num_housekeeping_cpus(), that can be used to retrieve
>> the number of housekeeping CPUs by reading an atomic variable
>> __num_housekeeping_cpus. This variable is set from housekeeping_setup().
>>
>> This API is introduced for the purpose of drivers that were previously
>> relying only on num_online_cpus() to determine the number of MSIX vectors
>> to create. In an RT environment with large isolated but a fewer
>> housekeeping CPUs this was leading to a situation where an attempt to
>> move all of the vectors corresponding to isolated CPUs to housekeeping
>> CPUs was failing due to per CPU vector limit.
> 
> Totally kibitzing here, but AFAICT the concepts of "isolated CPU" and
> "housekeeping CPU" are not currently exposed to drivers, and it's not
> completely clear to me that they should be.
> 
> We have carefully constructed notions of possible, present, online,
> active CPUs, and it seems like whatever we do here should be
> somehow integrated with those.
> 

Perhaps "active" CPUs could be separated to not include the isolated CPUs?
