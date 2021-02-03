Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A578A30D099
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 02:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBCBEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 20:04:53 -0500
Received: from mga04.intel.com ([192.55.52.120]:24055 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhBCBEx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 20:04:53 -0500
IronPort-SDR: bG8g0LRlwCjIGh9NHKIMrUTgOqH8i4tKZNPS/8BhZxuZO6p+KsbWV9ZjZtmncwTIyvjxAzIgn8
 0ZIsFXhlL7nw==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="178402593"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="178402593"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 17:04:12 -0800
IronPort-SDR: WlEExi0fnFb3ba3E21yQx0RRrEKP9Pf14bqAFJ2A4f1lpH5k2fDBazBAOzTyLuOA8b8ggHgnR2
 bA5U3NC4QTwA==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="392043889"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.11]) ([10.239.13.11])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 17:04:11 -0800
Subject: Re: [PATCH] selftests/tls: fix compile errors after adding
 CHACHA20-POLY1305
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>
References: <20210202094500.679761-1-rong.a.chen@intel.com>
 <20210202135307.6a2306fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <dcfd45ee-46eb-618a-1e28-03e8e213df16@intel.com>
Date:   Wed, 3 Feb 2021 09:03:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20210202135307.6a2306fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/21 5:53 AM, Jakub Kicinski wrote:
> On Tue,  2 Feb 2021 17:45:00 +0800 Rong Chen wrote:
>> The kernel test robot reported the following errors:
>>
>> tls.c: In function ‘tls_setup’:
>> tls.c:136:27: error: storage size of ‘tls12’ isn’t known
>>    union tls_crypto_context tls12;
>>                             ^~~~~
>> tls.c:150:21: error: ‘tls12_crypto_info_chacha20_poly1305’ undeclared (first use in this function)
>>     tls12_sz = sizeof(tls12_crypto_info_chacha20_poly1305);
>>                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> tls.c:150:21: note: each undeclared identifier is reported only once for each function it appears in
>> tls.c:153:21: error: ‘tls12_crypto_info_aes_gcm_128’ undeclared (first use in this function)
>>     tls12_sz = sizeof(tls12_crypto_info_aes_gcm_128);
>>
>> Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>> Link: https://lore.kernel.org/lkml/20210108064141.GB3437@xsang-OptiPlex-9020/
>> Signed-off-by: Rong Chen <rong.a.chen@intel.com>
> Are you sure you have latest headers installed on your system?
>
> Try make headers_install or some such, I forgot what the way to appease
> selftest was exactly but selftests often don't build on a fresh kernel
> clone if system headers are not very recent :S

Hi Jakub,

These errors still exist when testing the latest linux-next/master 
branch on our test system,
and kernelci noticed the errors too:

https://storage.staging.kernelci.org/kernelci/staging-mainline/staging-mainline-20210130.0/x86_64/x86_64_defconfig+kselftest/gcc-8/build.log

Best Regards,
Rong Chen

