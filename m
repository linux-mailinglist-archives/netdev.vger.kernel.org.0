Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA8A708F2
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731849AbfGVSx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:53:56 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3507 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbfGVSx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:53:56 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3606400002>; Mon, 22 Jul 2019 11:53:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 22 Jul 2019 11:53:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 22 Jul 2019 11:53:55 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 22 Jul
 2019 18:53:54 +0000
Subject: Re: [PATCH 1/3] drivers/gpu/drm/via: convert put_page() to
 put_user_page*()
To:     Christoph Hellwig <hch@lst.de>, <john.hubbard@gmail.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ilya Dryomov <idryomov@gmail.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ming Lei <ming.lei@redhat.com>, Sage Weil <sage@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Yan Zheng <zyan@redhat.com>, <netdev@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-mm@kvack.org>,
        <linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190722043012.22945-1-jhubbard@nvidia.com>
 <20190722043012.22945-2-jhubbard@nvidia.com> <20190722093355.GB29538@lst.de>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <397ff3e4-e857-037a-1aee-ff6242e024b2@nvidia.com>
Date:   Mon, 22 Jul 2019 11:53:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190722093355.GB29538@lst.de>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563821632; bh=dVEAb2CGI+Rcq3kPxf1ySX9mPnHE1aqM1bmhIjbORUc=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=HArRmCgkrni3Mv1zhHNTOrkORst1xu/RkKpSHN9NJ6eHvsCKnyilmR14o7Vu/72+2
         KzGoGeJ5LPaTaA997Z1lTeEX5TN0QxgL9zU0E1stVph1kaJP/CjI3G/fZC7Su8uSDP
         zQdMp40Hd3vz1tqkE44dAhr5RuD9olYTaUe61D28D1sEpt/q0j8DDbdv6B2ii7KaIW
         3XKa/T3Q4mkn6zgOvtasGsucgAaQQ3F4SWgLkmtCnVrJI8UW8FhQBhBRF+eCjxAZDo
         DjdQKgIytgBgEr6BmAqoJ/KeCGoQ826d60sYBB87S4A1fHrwdDnuUDjUmWCd/fqdhR
         fU5s088Wpq8BA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/19 2:33 AM, Christoph Hellwig wrote:
> On Sun, Jul 21, 2019 at 09:30:10PM -0700, john.hubbard@gmail.com wrote:
>>  		for (i = 0; i < vsg->num_pages; ++i) {
>>  			if (NULL != (page = vsg->pages[i])) {
>>  				if (!PageReserved(page) && (DMA_FROM_DEVICE == vsg->direction))
>> -					SetPageDirty(page);
>> -				put_page(page);
>> +					put_user_pages_dirty(&page, 1);
>> +				else
>> +					put_user_page(page);
>>  			}
> 
> Can't just pass a dirty argument to put_user_pages?  Also do we really

Yes, and in fact that would help a lot more than the single page case,
which is really just cosmetic after all.

> need a separate put_user_page for the single page case?
> put_user_pages_dirty?

Not really. I'm still zeroing in on the ideal API for all these call sites,
and I agree that the approach below is cleaner.

> 
> Also the PageReserved check looks bogus, as I can't see how a reserved
> page can end up here.  So IMHO the above snippled should really look
> something like this:
> 
> 	put_user_pages(vsg->pages[i], vsg->num_pages,
> 			vsg->direction == DMA_FROM_DEVICE);
> 
> in the end.
> 

Agreed.

thanks,
-- 
John Hubbard
NVIDIA
