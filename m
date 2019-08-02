Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB9F800FC
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405982AbfHBTex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:34:53 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17795 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391971AbfHBTew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:34:52 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d44905c0000>; Fri, 02 Aug 2019 12:34:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 02 Aug 2019 12:34:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 02 Aug 2019 12:34:51 -0700
Received: from [10.2.171.217] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 2 Aug
 2019 19:34:50 +0000
Subject: Re: [PATCH 00/34] put_user_pages(): miscellaneous call sites
To:     Peter Zijlstra <peterz@infradead.org>, <john.hubbard@gmail.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <amd-gfx@lists.freedesktop.org>, <ceph-devel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <devel@lists.orangefs.org>,
        <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-block@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-nfs@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-xfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <sparclinux@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>
References: <20190802021653.4882-1-jhubbard@nvidia.com>
 <20190802080554.GD2332@hirez.programming.kicks-ass.net>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <8968c928-5712-03a9-68df-051f5b58fdbc@nvidia.com>
Date:   Fri, 2 Aug 2019 12:33:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802080554.GD2332@hirez.programming.kicks-ass.net>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564774492; bh=+4YFr8hVqt3rnBZzpE/CDXaE3u2NtyGgeA2+CHyqUUg=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=pA8QugcwnL1HNNctuTXTMAa7CrBYZtv2cc2QzVDHg2S/Xz0x5cf9O8eGtP0C46aN6
         a197cn16D9E9xYsYwbovYwvjP0hTnTIrSK10+fiYfbToCUN0I9g4iXpjbE6kGTwrAp
         ncKdQLJTA/SOQtWLtiZt5vxeEAtfkDytTOFqyC79V99rQnUwNH1zBFEyzb+BV4yCcg
         0Lb+HCJur/Jv3WTiflqOcCteevFh1AJi/C8c1Ka1hIgLd+uE9NAbY1wcjbuQJmv03/
         F2ke8dbjLXpL5/tEd8euZ6kSYJfMWxVRqMIbW34EAHrZytttzmbzNNCLzf8Qy6VEOi
         6Ny99XF1JiDWQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/19 1:05 AM, Peter Zijlstra wrote:
> On Thu, Aug 01, 2019 at 07:16:19PM -0700, john.hubbard@gmail.com wrote:
> 
>> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
>> ("mm: introduce put_user_page*(), placeholder versions"). That commit
>> has an extensive description of the problem and the planned steps to
>> solve it, but the highlites are:
> 
> That is one horridly mangled Changelog there :-/ It looks like it's
> partially duplicated.

Yeah. It took so long to merge that I think I was no longer able to
actually see the commit description, after N readings. sigh

> 
> Anyway; no objections to any of that, but I just wanted to mention that
> there are other problems with long term pinning that haven't been
> mentioned, notably they inhibit compaction.
> 
> A long time ago I proposed an interface to mark pages as pinned, such
> that we could run compaction before we actually did the pinning.
> 

This is all heading toward marking pages as pinned, so we should finally
get there.  I'll post the RFC for tracking pinned pages shortly.


thanks,
-- 
John Hubbard
NVIDIA
