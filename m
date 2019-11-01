Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6C5EBB7E
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 01:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbfKAAsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 20:48:47 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10301 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbfKAAsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 20:48:46 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dbb80eb0000>; Thu, 31 Oct 2019 17:48:43 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 31 Oct 2019 17:48:37 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 31 Oct 2019 17:48:37 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 1 Nov
 2019 00:48:36 +0000
Subject: Re: [PATCH 19/19] Documentation/vm: add pin_user_pages.rst
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
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-20-jhubbard@nvidia.com>
 <20191031234922.GM14771@iweiny-DESK2.sc.intel.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <8f92713c-7df8-9463-93f2-40967eba27b5@nvidia.com>
Date:   Thu, 31 Oct 2019 17:48:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191031234922.GM14771@iweiny-DESK2.sc.intel.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572569323; bh=5RHzCGcb3FFZzaA/uQgYrgLcorAAk8gLyrsrWdqCg0c=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=jb4OmT2UIK+29Kq6gyh3/B0GMYEYeQey6Q7av8aHODFF7iM3g87GXz+0+crrEhDuP
         ES91FHKZ2TRd6nelEsvX1Ees+632xFVXWCQcNiNfBlThFOHS+Mq1DZ+VJ6HtPA43u6
         Ynb5UhoXiX2+2DJcjRCsgJU7otXcWVOJr09yZe43vdQrzd13x1b0cKY4hBXDGaRMUL
         j+EkbcXcmrT2jSkaz6YzKoEolu/+k4osy9BAQew7kbxk+1/wC4eflk8358pt5RFQn7
         yh6waII5ieUtayl8B5UKc7eHNJXPir5mjj/cq3SpudLXylqcwjl1IrKdwtTrjKlzPg
         OjOeqmfrEDTrQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 4:49 PM, Ira Weiny wrote:
> On Wed, Oct 30, 2019 at 03:49:30PM -0700, John Hubbard wrote:
...
>> +TODO: There is also a special case when the pages are DAX pages: in addition to
>> +the above flags, the caller needs something like a layout lease on the
>> +associated file. This is yet to be implemented. When it is implemented, it's
>> +expected that the lease will be a prerequisite to setting FOLL_LONGTERM.
> 
> For now we probably want to leave this note out until we figure out how this is
> going to work.  Best to say something like:
> 
> Some pages, such as DAX pages, can't be pinned with longterm pins and will
> fail.
> 

OK, I have this wording queued up for the v2 patch:

NOTE: Some pages, such as DAX pages, cannot be pinned with longterm pins. That's
because DAX pages do not have a separate page cache, and so "pinning" implies
locking down file system blocks, which is not (yet) supported in that way.


thanks,

John Hubbard
NVIDIA
