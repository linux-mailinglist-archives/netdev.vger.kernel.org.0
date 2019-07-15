Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A8A69A93
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 20:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbfGOSKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 14:10:24 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18288 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729135AbfGOSKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 14:10:23 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d2cc18d0000>; Mon, 15 Jul 2019 11:10:22 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 15 Jul 2019 11:10:22 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 15 Jul 2019 11:10:22 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 15 Jul
 2019 18:10:21 +0000
Subject: Re: [PATCH] mm/gup: Use put_user_page*() instead of put_page*()
To:     Bharath Vedartham <linux.bhar@gmail.com>
CC:     <akpm@linux-foundation.org>, <ira.weiny@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Enrico Weigelt <info@metux.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Matt Sickler <Matt.Sickler@daktronics.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <xdp-newbies@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>
References: <1563131456-11488-1-git-send-email-linux.bhar@gmail.com>
 <deea584f-2da2-8e1f-5a07-e97bf32c63bb@nvidia.com>
 <20190715065654.GA3716@bharath12345-Inspiron-5559>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <1aeb21d9-6dc6-c7d2-58b6-279b1dfc523b@nvidia.com>
Date:   Mon, 15 Jul 2019 11:10:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190715065654.GA3716@bharath12345-Inspiron-5559>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563214222; bh=6wwgTZKS6jiJbEQByxUeIS9VuTtgekUJNWGw3cfIDgA=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Ok4pi/aW8U3yjBXqydhqyft24fqK5kLZb9vqN2v2ZscUA+LO0TUEntZeQFXwWM9mI
         LSrTQjPbgBURTVuTHsTSQsCgjCENvKuaFyzKLw2XoaWgUj+WvDafd8mw0VAnM6FcQ+
         +2MQLOvD9ImnAuT4gp9Ms08kG21euR6h30TCsuEWJ6lWOGD9RwjSXqHq846/IAB2oQ
         2xzmb3rUlMkYnUIwMFCjvBWCfVAdsKWykA4pdAEfJW4vFSKPaT2m4A9YAlaep+ltqs
         dnlEdJPni78MkMkdBjFMKskTkkSUDUGV5x/f03KwhrKwKXSc4NX56A3yXabbvoTqDL
         9Z2efhUFKhX1Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/19 11:56 PM, Bharath Vedartham wrote:
> On Sun, Jul 14, 2019 at 04:33:42PM -0700, John Hubbard wrote:
>> On 7/14/19 12:08 PM, Bharath Vedartham wrote:
[...]
>> 1. Pull down https://github.com/johnhubbard/linux/commits/gup_dma_core
>> and find missing conversions: look for any additional missing 
>> get_user_pages/put_page conversions. You've already found a couple missing 
>> ones. I haven't re-run a search in a long time, so there's probably even more.
>> 	a) And find more, after I rebase to 5.3-rc1: people probably are adding
>> 	get_user_pages() calls as we speak. :)
> Shouldn't this be documented then? I don't see any docs for using
> put_user_page*() in v5.2.1 in the memory management API section?

Yes, it needs documentation. My first try (which is still in the above git
repo) was reviewed and found badly wanting, so I'm going to rewrite it. Meanwhile,
I agree that an interim note would be helpful, let me put something together.

[...]
>>     https://github.com/johnhubbard/linux/commits/gup_dma_core
>>
>>     a) gets rebased often, and
>>
>>     b) has a bunch of commits (iov_iter and related) that conflict
>>        with the latest linux.git,
>>
>>     c) has some bugs in the bio area, that I'm fixing, so I don't trust
>>        that's it's safely runnable, for a few more days.
> I assume your repo contains only work related to fixing gup issues and
> not the main repo for gup development? i.e where gup changes are merged?

Correct, this is just a private tree, not a maintainer tree. But I'll try to
keep the gup_dma_core branch something that is usable by others, during the
transition over to put_user_page(), because the page-tracking patches are the
main way to test any put_user_page() conversions.

As Ira said, we're using linux-mm as the real (maintainer) tree.


thanks,
-- 
John Hubbard
NVIDIA
