Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEC518FB68
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbgCWRXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:23:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:42040 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727163AbgCWRXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 13:23:33 -0400
IronPort-SDR: CtnwtH6Epleof1/jMTaCzjjj7BMVy3d7fPRJwvv7tFInWacyewOS5H4G57Xs1AJJF3dW3FixJM
 eHMAj1DP+f8g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 10:23:33 -0700
IronPort-SDR: RybV43AbjALyWT93lDr87bowKo8WstEPm5ECgFLSVnmzMmTeHF6o2UhWyytAVk/DnblS5omK0q
 q041IBdjfwUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="237963277"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.251.232.239]) ([10.251.232.239])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2020 10:23:32 -0700
Subject: Re: [net-next 6/9] ice: enable initial devlink support
To:     Jakub Kicinski <kuba@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
References: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
 <20200321081028.2763550-7-jeffrey.t.kirsher@intel.com>
 <20200323100941.2043b224@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <61321056-0890-7760-4164-6fdbb9021bd3@intel.com>
Date:   Mon, 23 Mar 2020 10:23:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200323100941.2043b224@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/23/2020 10:09 AM, Jakub Kicinski wrote:
> On Sat, 21 Mar 2020 01:10:25 -0700 Jeff Kirsher wrote:
>> From: Jacob Keller <jacob.e.keller@intel.com>
>>
>> Begin implementing support for the devlink interface with the ice
>> driver.
>>
>> The pf structure is currently memory managed through devres, via
>> a devm_alloc. To mimic this behavior, after allocating the devlink
>> pointer, use devm_add_action to add a teardown action for releasing the
>> devlink memory on exit.
>>
>> The ice hardware is a multi-function PCIe device. Thus, each physical
>> function will get its own devlink instance. This means that each
>> function will be treated independently, with its own parameters and
>> configuration. This is done because the ice driver loads a separate
>> instance for each function.
>>
>> Due to this, the implementation does not enable devlink to manage
>> device-wide resources or configuration, as each physical function will
>> be treated independently. This is done for simplicity, as managing
>> a devlink instance across multiple driver instances would significantly
>> increase the complexity for minimal gain.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> 
> Thanks for posting these!
> 

The remaining patches from the RFCs will be posted as two separate
series after this has merged.

Thanks again for the detailed review and helping find consensus on all
the naming!

Thanks,
Jake
