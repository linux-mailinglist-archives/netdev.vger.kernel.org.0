Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0F6FBC94
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 00:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKMX3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 18:29:47 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14354 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbfKMX3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 18:29:47 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcc91e90000>; Wed, 13 Nov 2019 15:29:45 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 13 Nov 2019 15:29:46 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 13 Nov 2019 15:29:46 -0800
Received: from [10.2.160.107] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 23:29:45 +0000
Subject: Re: [PATCH v4 23/23] mm/gup: remove support for gup(FOLL_LONGTERM)
To:     Ira Weiny <ira.weiny@intel.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-24-jhubbard@nvidia.com>
 <20191113190935.GD12947@iweiny-DESK2.sc.intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <4e24c5af-bd96-e7c7-179b-0ca0f6abb852@nvidia.com>
Date:   Wed, 13 Nov 2019 15:27:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191113190935.GD12947@iweiny-DESK2.sc.intel.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573687785; bh=9B/DbxbXL2Cu8EFiCYVZNw+MxNudIvhgmb1GMnaTmQ0=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=rJKFgq0qWlNQhEr6LwQRM7xJTWCfLcG6jdSS31KElayO6wHx7IiwFsaXOvGhplyH1
         tCC68KrsRIXSAjoot89gKwHpedHmflDisAxv/IoMKZRuMzvzxHIp82VaySctaPBYkQ
         hZemWLx10v7w1crWSE8+tecZBKihDudRrciOwHkYvfyXR52KB/0+nCkX8xcEjYzOgD
         BdrgEwqj12gUt+52wZddvynAEOXEEJldAzotyUKT84BAusYTd8IMJOcdCe+okl1UqL
         yIUM4FRTzo2XVuGeXsCxvfWydTvgqiLWMulv4eIra/tutHomq+DAZbILc3dKig7Hd1
         UTGu99x3VirIw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/19 11:09 AM, Ira Weiny wrote:
...
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 82e7e4ce5027..90f5f95ee7ac 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -1756,11 +1756,11 @@ long get_user_pages(unsigned long start, unsigned long nr_pages,
>>   		struct vm_area_struct **vmas)
>>   {
>>   	/*
>> -	 * FOLL_PIN must only be set internally by the pin_user_page*() and
>> -	 * pin_longterm_*() APIs, never directly by the caller, so enforce that
>> -	 * with an assertion:
>> +	 * FOLL_PIN and FOLL_LONGTERM must only be set internally by the
>> +	 * pin_user_page*() and pin_longterm_*() APIs, never directly by the
>> +	 * caller, so enforce that with an assertion:
>>   	 */
>> -	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
>> +	if (WARN_ON_ONCE(gup_flags & (FOLL_PIN | FOLL_LONGTERM)))
> 
> Don't we want to block FOLL_LONGTERM in get_user_pages_fast() as well after all
> this?
> 

Yes. But with the latest idea to restore FOLL_LONGTERM to its original glory,
that won't be an issue in the next version. heh.


thanks,
-- 
John Hubbard
NVIDIA
