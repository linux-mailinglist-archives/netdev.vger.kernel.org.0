Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7920E23F963
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 00:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgHHW5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 18:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgHHW5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 18:57:37 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2250C061756;
        Sat,  8 Aug 2020 15:57:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id c6so2761275pje.1;
        Sat, 08 Aug 2020 15:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9sPtCXARRDyoJ9gED6VcstU3ZnY0CN85dWocZ7ctG2E=;
        b=QZU/Tvgq78IUEtDcC1+6C6xvjHGuXJHXguScPFEZz+aS8foez55jwUhTUnx6KF7Il+
         M4iZheUMXLzs7xSlWXfG7H+dM0oO1GHdyFlV0iYOxUVqXT3hfmdNyhfIzRT+rq9ZVN0p
         lRJeSK58lKVj6qy80rOKm5wmcgQJxk8Egn9Qe4S2LdY9PTEFAUCSDT509S/C9+IxX6PH
         sNXvvUkN+iMb38o1tJ6uK54VtqU/ZK2fQsTq02a3T44B4e6sPjqwCS08rXMMlOJD1Akz
         yjwAl/o38v5nzut99M9Sbzr9YLxJdAPl/n+p9mtauvxWllfoTls6vC9FiQQ+0wzanl/6
         Aeyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9sPtCXARRDyoJ9gED6VcstU3ZnY0CN85dWocZ7ctG2E=;
        b=pc1ce5ZdI0gvM5iXcPpO3CzZuagcLFgbxg1XOYwpAyV5euFJdsDoOg3PIMKisqtZBh
         d85bo0dT9NEH+m9x8I1zJZzDe/GTygF/mGT/NqfTufw7J+PQDUcRDsXvfYSR9Ko6GjRi
         5iAB0XWncXBU1IjdmNItUR2Qz+AkSLKvrzSSBXy/MBjsWFPAHq1ucobzB7YlN2Bk7Gsn
         b9xT4J6hPHWmqPVvbe/Fx6AqUCvnEWcgGJOUpMWnFnEBtygziOsgx7++4UHx1TVxlRNB
         ugRm/D9qgrXaa+RGph3QCxt56tTZU2ZZR/TdVgPZXxmA1c9+UpBi0jFn2RAW6t3IcgVZ
         2vpQ==
X-Gm-Message-State: AOAM532Y80AuIWCNU5D+X8EDBfwHY4WW4CXAa6am/Nbi4i4yn7Cs4Y+y
        qHC/npR9im4OaCELMRw1VH4/uoF5oj9D3Q==
X-Google-Smtp-Source: ABdhPJxC1hb5eucKSMPhCKqbRKPCMGw/TpygTR/MPLb0wTD4LcgT7LTAWUFr7XtyF2eqj7hNOfB1oQ==
X-Received: by 2002:a17:90a:d482:: with SMTP id s2mr19980811pju.140.1596927456678;
        Sat, 08 Aug 2020 15:57:36 -0700 (PDT)
Received: from [100.115.92.198] (18.48.24.136.in-addr.arpa. [136.24.48.18])
        by smtp.gmail.com with ESMTPSA id y17sm17167551pfe.30.2020.08.08.15.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 15:57:36 -0700 (PDT)
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
To:     Jason Gunthorpe <jgg@ziepe.ca>, Joe Perches <joe@perches.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20200731053333.GB466103@kroah.com>
 <20200731140452.GE24045@ziepe.ca> <20200731142148.GA1718799@kroah.com>
 <20200731143604.GF24045@ziepe.ca> <20200731171924.GA2014207@kroah.com>
 <20200801053833.GK75549@unreal> <20200802221020.GN24045@ziepe.ca>
 <fb7ec4d4ed78e6ae7fa6c04abb24d1c00dc2b0f7.camel@perches.com>
 <20200802222843.GP24045@ziepe.ca>
 <60584f4c0303106b42463ddcfb108ec4a1f0b705.camel@perches.com>
 <20200803230627.GQ24045@ziepe.ca>
From:   Jack Leadford <leadford.jack@gmail.com>
Message-ID: <ff066616-3bb8-b6c8-d329-7de5ab8ee982@gmail.com>
Date:   Sat, 8 Aug 2020 15:57:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200803230627.GQ24045@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

Thanks to Jason for getting this conversation back on track.

Yes: in general, {} or a partial initializer /will/ zero padding bits.

However, there is a bug in some versions of GCC where {} will /not/ zero
padding bits; actually, Jason's test program in this mail 
https://lore.kernel.org/lkml/20200731143604.GF24045@ziepe.ca/
has the right ingredients to trigger the bug, but the GCC
versions used are outside of the bug window. :)

For more details on these cases and more (including said GCC bug), see 
my paper at:

https://www.nccgroup.com/us/about-us/newsroom-and-events/blog/2019/october/padding-the-struct-how-a-compiler-optimization-can-disclose-stack-memory/

Hopefully this paper can serve as a helpful reference when these cases 
are encountered in the kernel.

Thank you.

Jack Leadford

On 8/3/20 4:06 PM, Jason Gunthorpe wrote:
> On Sun, Aug 02, 2020 at 03:45:40PM -0700, Joe Perches wrote:
>> On Sun, 2020-08-02 at 19:28 -0300, Jason Gunthorpe wrote:
>>> On Sun, Aug 02, 2020 at 03:23:58PM -0700, Joe Perches wrote:
>>>> On Sun, 2020-08-02 at 19:10 -0300, Jason Gunthorpe wrote:
>>>>> On Sat, Aug 01, 2020 at 08:38:33AM +0300, Leon Romanovsky wrote:
>>>>>
>>>>>> I'm using {} instead of {0} because of this GCC bug.
>>>>>> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53119
>>>>>
>>>>> This is why the {} extension exists..
>>>>
>>>> There is no guarantee that the gcc struct initialization {}
>>>> extension also zeros padding.
>>>
>>> We just went over this. Yes there is, C11 requires it.
>>
>> c11 is not c90.  The kernel uses c90.
> 
> The kernel already relies on a lot of C11/C99 features and
> behaviors. For instance Linus just bumped the minimum compiler version
> so that C11's _Generic is usable.
> 
> Why do you think this particular part of C11 shouldn't be relied on?
> 
> Jason
> 
> 
