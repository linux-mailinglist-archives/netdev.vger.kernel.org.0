Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1D4879BF
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406802AbfHIMUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:20:52 -0400
Received: from ozlabs.org ([203.11.71.1]:35801 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406730AbfHIMUw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 08:20:52 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 464kpy5K69z9sBF;
        Fri,  9 Aug 2019 22:20:42 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?utf-8?B?SsOpcsO0?= =?utf-8?B?bWU=?= Glisse 
        <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Hellwig <hch@lst.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 38/41] powerpc: convert put_page() to put_user_page*()
In-Reply-To: <248c9ab2-93cc-6d8b-606d-d85b83e791e5@nvidia.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com> <20190807013340.9706-39-jhubbard@nvidia.com> <87k1botdpx.fsf@concordia.ellerman.id.au> <248c9ab2-93cc-6d8b-606d-d85b83e791e5@nvidia.com>
Date:   Fri, 09 Aug 2019 22:20:40 +1000
Message-ID: <875zn6ttrb.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Hubbard <jhubbard@nvidia.com> writes:
> On 8/7/19 10:42 PM, Michael Ellerman wrote:
>> Hi John,
>> 
>> john.hubbard@gmail.com writes:
>>> diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
>>> index b056cae3388b..e126193ba295 100644
>>> --- a/arch/powerpc/mm/book3s64/iommu_api.c
>>> +++ b/arch/powerpc/mm/book3s64/iommu_api.c
>>> @@ -203,6 +202,7 @@ static void mm_iommu_unpin(struct mm_iommu_table_group_mem_t *mem)
>>>  {
>>>  	long i;
>>>  	struct page *page = NULL;
>>> +	bool dirty = false;
>> 
>> I don't think you need that initialisation do you?
>> 
>
> Nope, it can go. Fixed locally, thanks.

Thanks.

> Did you get a chance to look at enough of the other bits to feel comfortable 
> with the patch, overall?

Mostly :) It's not really my area, but all the conversions looked
correct to me as best as I could tell.

So I'm fine for it to go in as part of the series:

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers
