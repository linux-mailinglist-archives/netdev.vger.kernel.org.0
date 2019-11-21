Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E2F104DDA
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfKUI2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:28:02 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8421 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfKUI2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:28:01 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd64a8d0000>; Thu, 21 Nov 2019 00:27:58 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 21 Nov 2019 00:27:56 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 21 Nov 2019 00:27:56 -0800
Received: from [10.2.169.101] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 Nov
 2019 08:27:56 +0000
Subject: Re: [PATCH v7 01/24] mm/gup: pass flags arg to __gup_device_*
 functions
To:     Christoph Hellwig <hch@infradead.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-2-jhubbard@nvidia.com>
 <20191121080644.GA30991@infradead.org>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <72299562-df12-cbe6-b9c8-05d08625d923@nvidia.com>
Date:   Thu, 21 Nov 2019 00:25:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191121080644.GA30991@infradead.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574324878; bh=fBEs8zvhTdiK+GxG6jBbxLF9y/0PajclAlx5MVf68dY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=qd3vyt4F6HTwKKFCyZDRI1qul9fTK80VD0HOAtpUJsLmp+uOnJP/0/mfORMpRDIWh
         msa/9tW2R6G3NEV2vxUdIVUrSBPbm+dg7h5ks0ydjI1ZXAilO+KUn3onxdYvYd5yLN
         th/eVTL36YxBubARAfxgWsMF5jHbNrsWfvpc1zmtToQtEJyTHI9jhj2Fav/Qg69ylO
         Vy7wGuKCXhdmLuU5+JPthKW1n/P1IS7DJEMqLH2TUUbpLDARMfwqNpDJNlkgiwpB9C
         7ZnSeTY/le1R03Z0KIA9sli+2LeQchnYq98ah5HhIRhjwHluG7JOQqaaQVMgGA+5Gr
         gsPwOYerki+jg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 12:06 AM, Christoph Hellwig wrote:
> On Wed, Nov 20, 2019 at 11:13:31PM -0800, John Hubbard wrote:
>> A subsequent patch requires access to gup flags, so
>> pass the flags argument through to the __gup_device_*
>> functions.
> 
> Looks fine, but why not fold this into the patch using the flags.

Yes, I'll do that.

> 
> Also you can use up your full 73 chars per line in the commit log.
> 

OK.

thanks,
-- 
John Hubbard
NVIDIA
