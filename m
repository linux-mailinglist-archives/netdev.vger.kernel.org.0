Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF6A15A624
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfF1VIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:08:21 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45631 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1VIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:08:21 -0400
Received: by mail-pf1-f194.google.com with SMTP id r1so3575472pfq.12
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 14:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=EnbYtR1J6els+DHcdmFKGw27fpLnYm5QiajIcvCXex4=;
        b=M6j2pNcJ0VIqHweAIQe7hJjAZiHb39iptR0M8cAsWqGrXUF9n6aofTfMJCXEE7Jc8d
         A74D6q+Ua8TRFkAfNm78yMBTZ2oPTqP6lIktQY6UGCYAT/CMEMMjwh1KDpMQkGUS1/r5
         D3Gpu8V1B0F35LRwwAxLQ5St2k7/NWim96+RVd/fQZG/FYUvxCGqeFodEyqykgE8XZCE
         uVByCXkBEw/NgoRz2Q/6kJTuM2nHjy2Vlma1mLjELUNKxLbhNCcYihzBfQeWL6OnjJ9k
         D/2gfsgHzosfg/RrDmq6Q1x5kavCEwTInJar6z8Ex2Hw/RqSbXlb+en1ijiH8NyIqLKx
         0uYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=EnbYtR1J6els+DHcdmFKGw27fpLnYm5QiajIcvCXex4=;
        b=Sx0OYnXlEpx+U36k8XD5xHmf1gjvbixymGi90W0MTc23j7NK42hqLtDaWhpe5+qjIU
         v9a+9tjqquKPUD64KPq4syTwfIzapP2VFpZo/CHwXByQPWs1r+ZNGmiMVde8a0g2j7PQ
         k2JnNQU2wWUIEQ/mvXDzldkZGZiSYcbw90cMupz95X+tLMxUFuLOzlnv13qx5woOty79
         ASLuJFzMWQaXzst0pXkQQj5PYJiEf0W+st/oA0sDFIVvZxZObiHFxqezlA68SDoO8h8+
         fxnQMIA4zNYH0mrhqcSsmZbJjEceBOEQ5wdfPlKxYkWP13x41DfFD7oXWJc/a6eORk/D
         cdsw==
X-Gm-Message-State: APjAAAWPagwnGjF6PNoJbvL0oMabaFygjbLkzOrTIgL+F+etYjN/w157
        5dofC4ulURBnwdNArd6+Kxo=
X-Google-Smtp-Source: APXvYqz5gAMDb3enTtfeAJHvlWYoRMXBZGfgECJSpn4m38eWvuvGwse9mJKd4NLi0N/Eoq9zW/J5JA==
X-Received: by 2002:a17:90a:24e4:: with SMTP id i91mr16198347pje.9.1561756100417;
        Fri, 28 Jun 2019 14:08:20 -0700 (PDT)
Received: from [172.20.54.151] ([2620:10d:c090:200::e695])
        by smtp.gmail.com with ESMTPSA id f7sm2644866pgc.82.2019.06.28.14.08.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 14:08:19 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, saeedm@mellanox.com,
        maximmi@mellanox.com, brouer@redhat.com, kernel-team@fb.com
Subject: Re: [PATCH 2/6 bpf-next] Clean up xsk reuseq API
Date:   Fri, 28 Jun 2019 14:08:19 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <8E655F8E-1896-4EB9-992A-F93C64F2B490@gmail.com>
In-Reply-To: <20190628134121.2f54c349@cakuba.netronome.com>
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
 <20190627220836.2572684-3-jonathan.lemon@gmail.com>
 <20190627153856.1f4d4709@cakuba.netronome.com>
 <8E97A6A3-2B8D-4E03-960B-8625DA3BA4FF@gmail.com>
 <20190628134121.2f54c349@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; markup=markdown
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28 Jun 2019, at 13:41, Jakub Kicinski wrote:

> On Thu, 27 Jun 2019 19:31:26 -0700, Jonathan Lemon wrote:
>> On 27 Jun 2019, at 15:38, Jakub Kicinski wrote:
>>
>>> On Thu, 27 Jun 2019 15:08:32 -0700, Jonathan Lemon wrote:
>>>> The reuseq is actually a recycle stack, only accessed from the kernel
>>>> side.
>>>> Also, the implementation details of the stack should belong to the
>>>> umem
>>>> object, and not exposed to the caller.
>>>>
>>>> Clean up and rename for consistency in preparation for the next
>>>> patch.
>>>>
>>>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>>>
>>> Prepare/swap is to cater to how drivers should be written - being able
>>> to allocate resources independently of those currently used.  Allowing
>>> for changing ring sizes and counts on the fly.  This patch makes it
>>> harder to write drivers in the way we are encouraging people to.
>>>
>>> IOW no, please don't do this.
>>
>> The main reason I rewrote this was to provide the same type
>> of functionality as realloc() - no need to allocate/initialize a new
>> array if the old one would still end up being used.  This would seem
>> to be a win for the typical case of having the interface go up/down.
>>
>> Perhaps I should have named the function differently?
>
> Perhaps add a helper which calls both parts to help poorly architected
> drivers?

Still ends up taking more memory.

There are only 3 drivers in the tree which do AF_XDP: i40e, ixgbe, and mlx5.

All of these do the same thing:
    reuseq = xsk_reuseq_prepare(n)
    if (!reuseq)
       error
    xsk_reuseq_free(xsk_reuseq_swap(umem, reuseq));

I figured simplifying was a good thing.

But I do take your point that some future driver might want to allocate
everything up front before performing a commit of the resources.
-- 
Jonathan
