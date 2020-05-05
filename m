Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18CB1C5AEE
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgEEPUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729709AbgEEPUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:20:55 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D841FC061A0F;
        Tue,  5 May 2020 08:20:53 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mq3so1296245pjb.1;
        Tue, 05 May 2020 08:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ijPZh8B4iDN+Zy3Lbn8azz7wIkX6gQvepkatyf1Zg2U=;
        b=b+4dZwe21myBqVCmmpmf7s/5B4GYvFeMaXPncR16D1Lwjgt/CG4navWP1THhFFdxVC
         FrgwbB7pTbqozj2ncAaWSkhSgi0Ug8t/9UuE24ydi5dzzEDqROPx2pkGFpbnTiAi5pvX
         ylLJOy/L4/wUd0Mk1LIjMvaqPbHjr6SC9XAgcoDmfxp1pbcqFkoOZ6LHtXAhkQNzDvEA
         5UNQYdWphLOVit2+RO+P4RMMPzPtJ5gZuMwz1r4VlF47oB2L9mV44+gloqHUqpFKikla
         hNOHDE0O2jTGV/X6tFT7i/e8nwvC1HS9HrBK2zoBw7Uw4NKSKpuwIXgjilVj1V58SHVP
         Upcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ijPZh8B4iDN+Zy3Lbn8azz7wIkX6gQvepkatyf1Zg2U=;
        b=sClHn0bjOd9q4gsuIOcRd+9RMFp/r9TNeilOBcFrqNlyKccJ5Q7AWuNhkW4fSyWLac
         zBKCVAU7zp4xu7j7PfohWljFBOYHh4Kps1zVajxYHjt2jIBkYveG14SCvwHldKJSY/Qt
         2DmPPBbWpoaRJ4cDQBGCxLiy3gQDtydJRlbfLf0IHEvECyRoXsh+BHKx53TOCAsKp/1I
         2/54c+fX0nDANl5FGh2UJ+cxuxewQA+t57J4uWuOJKNpOoETrKCguCQHwYHZ4MhxBEgu
         B6/zm99RACqVp+g+/NrG2ibByz6YZiVXGU32TRHF6TnlGkAtWf13hNhw5EI9kwZ1kn4Z
         ocmQ==
X-Gm-Message-State: AGi0Pubjz16f39ZrutkH+Dr5H87GQI5SYtfboIupRzHVeYIU5j4XZvRh
        1UnBCxPSDxFIucJqSsPB26HZisEm
X-Google-Smtp-Source: APiQypJvLcl/oSqUO8QDsnhtfE89l2uZcumGHsREzxjyjBFBrNG2uLvQZpDgGISs0bngBpVE6Nt2VQ==
X-Received: by 2002:a17:90b:f11:: with SMTP id br17mr1361595pjb.222.1588692053003;
        Tue, 05 May 2020 08:20:53 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 62sm2292222pfu.181.2020.05.05.08.20.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 08:20:51 -0700 (PDT)
Subject: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
To:     SeongJae Park <sjpark@amazon.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sj38.park@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, snu@amazon.com,
        amit@kernel.org, stable@vger.kernel.org
References: <20200505150717.5688-1-sjpark@amazon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a8510327-d4f0-1207-1342-d688e9d5b8c3@gmail.com>
Date:   Tue, 5 May 2020 08:20:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200505150717.5688-1-sjpark@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 8:07 AM, SeongJae Park wrote:
> On Tue, 5 May 2020 07:53:39 -0700 Eric Dumazet <edumazet@google.com> wrote:
> 

>> Why do we have 10,000,000 objects around ? Could this be because of
>> some RCU problem ?
> 
> Mainly because of a long RCU grace period, as you guess.  I have no idea how
> the grace period became so long in this case.
> 
> As my test machine was a virtual machine instance, I guess RCU readers
> preemption[1] like problem might affected this.
> 
> [1] https://www.usenix.org/system/files/conference/atc17/atc17-prasad.pdf
> 
>>
>> Once Al patches reverted, do you have 10,000,000 sock_alloc around ?
> 
> Yes, both the old kernel that prior to Al's patches and the recent kernel
> reverting the Al's patches didn't reproduce the problem.
>

I repeat my question : Do you have 10,000,000 (smaller) objects kept in slab caches ?

TCP sockets use the (very complex, error prone) SLAB_TYPESAFE_BY_RCU, but not the struct socket_wq
object that was allocated in sock_alloc_inode() before Al patches.

These objects should be visible in kmalloc-64 kmem cache.

