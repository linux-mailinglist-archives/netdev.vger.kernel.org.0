Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FDD359DEB
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhDILuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhDILuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 07:50:32 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449A6C061760;
        Fri,  9 Apr 2021 04:50:19 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5-20020a05600c0245b029011a8273f85eso2836137wmj.1;
        Fri, 09 Apr 2021 04:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5w0D0I/DpWkHUYPOs9kZ8KUrL2jeXir0cySNED2VroM=;
        b=XPqMUz+/46oxHBegWofgVdr8ELuknw2rI5cr/mfm7gRY6xIbONeqBUkXJk5JnkyOSa
         J+jNJJHwfXs2guDfz8d+xDNYKvl+9+i6yEcmciVAuguHGmEZWagFOG/HUpXcjCgNadZE
         WO+YWdEugYBE7EoWJHRhDOfQjCAjSBt9hNkmuKIaDyz4B6Z5axBeyTDz0lDbw6f7JRDr
         +107rPHBBMeMd4z19aqSdzh3+uj6e+7YkGrk02I8UCcHKMzVmM0E6Fv+rJonimnDSMNX
         KmVjk2A0VinUIaQey/70TGrVlB/HJV1DqN8dI/lpdIHSQ5VNLFrXmZ26ikIWgoCOU7WV
         Ve3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5w0D0I/DpWkHUYPOs9kZ8KUrL2jeXir0cySNED2VroM=;
        b=WVKE5NDJX+jslJVO/tGBEJHiDcWdvd3alFF7/tmmFuS2qb0olgirkc1d/+V4FQXv/i
         z/CCq7W5tffFqPnxNeIxsQ+ATQRSXwZl6i69mAsK3bFG5qKf4xCm+dq8xpA1XZHwRt70
         ITZuwxZm3iWoJhbM2flopSlPnk8Gn3/JGDiXxRs5a/44H6pSR2L+YHpcC7w+ZwU5tP9V
         YpUAeQix7OzglpHZbdyOsH53ShaYCFsTizxw6e6u98ww4uQa6xI1d0wivmIh07hSs9Dt
         BQv5vaoaxGjYvpd0AFtfbf0LY9o6onfN6yKzXB0/eIuJCWyitcO1Wc2tqee5eN0gwo59
         65sw==
X-Gm-Message-State: AOAM531iuqeI4NOzWtHtWWaY0JWE6fQEB0s5El+UecQezTroGrN+tpI0
        3BDmKnSPkBX+hPdYH1duqwY5FB4fknQ=
X-Google-Smtp-Source: ABdhPJwLjkxggFpv/JHMMAipaeGauG7PsIZ2fhcyWoKRbqh2+kuDpadpBVpHafkGWziJELriuPSaHQ==
X-Received: by 2002:a05:600c:1992:: with SMTP id t18mr13129540wmq.125.1617969017824;
        Fri, 09 Apr 2021 04:50:17 -0700 (PDT)
Received: from [192.168.1.101] ([37.167.116.29])
        by smtp.gmail.com with ESMTPSA id m26sm3544155wmg.17.2021.04.09.04.50.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 04:50:17 -0700 (PDT)
Subject: Re: Problem in pfmemalloc skb handling in net/core/dev.c
To:     Xie He <xie.he.0141@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Mel Gorman <mgorman@suse.de>, jslaby@suse.cz,
        Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <CAJht_ENNvG=VrD_Z4w+G=4_TCD0Rv--CQAkFUrHWTh4Cz_NT2Q@mail.gmail.com>
 <20210409073046.GI3697@techsingularity.net>
 <CAJht_EPXS3wVoNyaD6edqLPKvDTG2vg4qxiGuWBgWpFsNhB-4g@mail.gmail.com>
 <20210409084436.GK3697@techsingularity.net>
 <CAJht_EPrdujG_0QHM1vc2yrgwwKMQiFzUAK2pgR4dS4z9-Xknw@mail.gmail.com>
 <87ab3d13-f95d-07c5-fc6a-fb33e32685e5@gmail.com>
 <CAJht_EOmcOdKGKnoUQDJD-=mnHOK0MKiV0+4Epty5H5DMED-qw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3c79924f-3603-b259-935a-2e913dc3afcd@gmail.com>
Date:   Fri, 9 Apr 2021 13:50:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAJht_EOmcOdKGKnoUQDJD-=mnHOK0MKiV0+4Epty5H5DMED-qw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/21 12:14 PM, Xie He wrote:
> On Fri, Apr 9, 2021 at 3:04 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> Note that pfmemalloc skbs are normally dropped in sk_filter_trim_cap()
>>
>> Simply make sure your protocol use it.
> 
> It seems "sk_filter_trim_cap" needs an "struct sock" argument. Some of
> my protocols act like a middle layer to another protocol and don't
> have any "struct sock".

Then simply copy the needed logic.

> 
> Also, I think this is a problem in net/core/dev.c, there are a lot of
> old protocols that are not aware of pfmemalloc skbs. I don't think
> it's a good idea to fix them one by one.
> 

I think you are mistaken.

There is no problem in net/core/dev.c really, it uses
skb_pfmemalloc_protocol()

pfmemalloc is best effort really.

If a layer store packets in many long living queues, it has to drop pfmemalloc packets,
unless these packets are used for swapping.




