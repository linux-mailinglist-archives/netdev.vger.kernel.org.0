Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CFA1C626D
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbgEEUxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:53:03 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11626 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgEEUxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:53:02 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb1d21f0000>; Tue, 05 May 2020 13:52:47 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 05 May 2020 13:52:59 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 05 May 2020 13:52:59 -0700
Received: from [10.2.56.198] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 May
 2020 20:52:59 +0000
Subject: Re: [RFC] mm/gup.c: Updated return value of
 {get|pin}_user_pages_fast()
To:     Souptick Joarder <jrdr.linux@gmail.com>
CC:     Tony Luck <tony.luck@intel.com>, <fenghua.yu@intel.com>,
        Rob Springer <rspringer@google.com>,
        Todd Poynor <toddpoynor@google.com>, <benchan@chromium.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, <kuba@kernel.org>,
        Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        <inux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        <tee-dev@lists.linaro.org>, Linux-MM <linux-mm@kvack.org>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>
References: <1588706059-4208-1-git-send-email-jrdr.linux@gmail.com>
 <0bfe4a8a-0d91-ef9b-066f-2ea7c68571b3@nvidia.com>
 <CAFqt6zZMsQkOdjAb2k1EjwX=DtZ8gKfbRzwvreHOX-0vJLngNg@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <3a974031-39dc-0359-a574-3ab6770de97f@nvidia.com>
Date:   Tue, 5 May 2020 13:52:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAFqt6zZMsQkOdjAb2k1EjwX=DtZ8gKfbRzwvreHOX-0vJLngNg@mail.gmail.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588711967; bh=SjPQ3EiGBoA/Ko2vVpbK4GSx23pqGazMC2fKGwkI0gs=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=OeQB4PijTuQKxfwtgJUNN+bgF8E0urXDFQHGK5s9+YU2d+c3XO8uHZOuK+cS6L33b
         IYVD4vhIabsTLiFjDgGRq5B1Qc6lU7Nyb6/eeHDdDcXU+73enzQd/9USoq08BwpMvw
         0sVdWMb9iZrxkNW2FUpDT0eMykb1cGNmOPucDfrk3t4r18UMzA0dU1olv8YHxzw4CM
         DYhoIbCFgxBCdxNTscDrdPs8AANcdyRLkYghMf6Nx4tkDY11x+Qx9YQwYCqP9FHt58
         RcFbTBk9Q7aQjbdUQfxT5dlgbcfSrc1pwR8cT9KkX1hxTXULYhYxEuC2s66Kc/dN6+
         +m38xhXp9XIzA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-05 13:36, Souptick Joarder wrote:
> On Wed, May 6, 2020 at 1:08 AM John Hubbard <jhubbard@nvidia.com> wrote:
>>
>> On 2020-05-05 12:14, Souptick Joarder wrote:
>>> Currently {get|pin}_user_pages_fast() have 3 return value 0, -errno
>>> and no of pinned pages. The only case where these two functions will
>>> return 0, is for nr_pages <= 0, which doesn't find a valid use case.
>>> But if at all any, then a -ERRNO will be returned instead of 0, which
>>> means {get|pin}_user_pages_fast() will have 2 return values -errno &
>>> no of pinned pages.
>>>
>>> Update all the callers which deals with return value 0 accordingly.
>>
>> Hmmm, seems a little shaky. In order to do this safely, I'd recommend
>> first changing gup_fast/pup_fast so so that they return -EINVAL if
>> the caller specified nr_pages==0, and of course auditing all callers,
>> to ensure that this won't cause problems.
> 
> While auditing it was figured out, there are 5 callers which cares for
> return value
> 0 of gup_fast/pup_fast. What problem it might cause if we change
> gup_fast/pup_fast
> to return -EINVAL and update all the callers in a single commit ?


If you change the semantics of a core API, it's critical to do it
in steps that are safe even against other code changes that may be
merged in. There are other people potentially editing the callers. And
those might very well be in different git trees, and on different mailing
lists.

Even within a tree, it's possible to either overlook a call site during
an audit, or for someone else (who overlooked your change's review
discussions) to commit a change that doesn't follow the same assumptions.
So API assumptions often need to be backed up by things like -errno return
values, or sometimes even WARN*() statements.

For a recent example: gup() assumes that no one passes in a "bare"
FOLL_PIN flag to it. Therfore, it returns -errno and also WARN's in that
case--for precisely the same reasons: other people are editing the code
base. It's not static.

> 
>>
>> The gup.c documentation would also need updating in a couple of comment
>> blocks, above get_user_pages_remote(), and __get_user_pages(), because
>> those talk about a zero return value.
> 
> OK.
> 
>>
>> This might be practical without slowing down the existing code, because
>> there is already a check in place, so just tweaking it like this (untested)
>> won't change performance at all:
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 11fda538c9d9..708eed79ae29 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2787,7 +2787,7 @@ static int internal_get_user_pages_fast(unsigned long start,
>> int nr_pages,
>>           end = start + len;
>>
>>           if (end <= start)
>> -               return 0;
>> +               return -EINVAL;
>>           if (unlikely(!access_ok((void __user *)start, len)))
>>                   return -EFAULT;
>>
>> ...although I might be missing some other things that need a similar change,
>> so you should look carefully for yourself.
> 
> Do you refer to other gup APIs similar to gup_fast/pup_fast ?


Yes, like all the gup/pup variants.


thanks,
-- 
John Hubbard
NVIDIA
