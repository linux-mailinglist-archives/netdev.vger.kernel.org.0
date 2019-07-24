Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC80723B7
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 03:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbfGXBbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 21:31:43 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5085 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfGXBbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 21:31:43 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d37b5040000>; Tue, 23 Jul 2019 18:31:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 23 Jul 2019 18:31:41 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 23 Jul 2019 18:31:41 -0700
Received: from [10.110.48.28] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 24 Jul
 2019 01:31:40 +0000
Subject: Re: [PATCH v2 1/3] mm/gup: add make_dirty arg to
 put_user_pages_dirty_lock()
To:     <john.hubbard@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Christoph Hellwig <hch@lst.de>,
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
        LKML <linux-kernel@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>
References: <20190724012606.25844-1-jhubbard@nvidia.com>
 <20190724012606.25844-2-jhubbard@nvidia.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <5c303c80-57fd-d278-44d5-942597051c9b@nvidia.com>
Date:   Tue, 23 Jul 2019 18:31:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724012606.25844-2-jhubbard@nvidia.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563931908; bh=81R/Z2rovzmAa3O7DCJ8y2Mm5lAz4O2B1wbIdVhO0d8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=L8+8TSTfHtIkC1xowWnZPPItlJoP+leFf6ucvU5E2owqzMuOQ9jIZ8vvOAmRE48gG
         nJc2BkzeiefBvFmLrdVIpofi+FqWCxnLVVCD8Km+TEsxK75nMF86BzzMDvJhOtd4Sv
         tv/oBJtf5JB77EfsmMmPFfjUqHdF8FrA9NTbWBGktbrAYnfNv/v7rTGnTIY6IQINWA
         7KWjSbQNfLlkpCFtMta3TS57pn2JgRvHM6UCjTP01IAnW414t4BHJWGwnR2xyxPuNo
         ve66cppddE8vW2LUpVK1xyY3WfDsi+6f6NZZzv7rod362wLBdY3VFm9CgxAGyrUul/
         iXE/3sT5XunbA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 6:26 PM, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
...
> +		 * 2) This code sees the page as clean, so it calls
> +		 * set_page_dirty(). The page stays dirty, despite being
> +		 * written back, so it gets written back again in the
> +		 * next writeback cycle. This is harmless.
> +		 */
> +		if (!PageDirty(page))
> +			set_page_dirty_lock(page);
> +		break;

ahem, the above "break" should not be there, it's an artifact, sorry about 
that. Will correct on the next iteration.

thanks,
-- 
John Hubbard
NVIDIA


> +		put_user_page(page);
> +	}
>  }
>  EXPORT_SYMBOL(put_user_pages_dirty_lock);
>  
> 
