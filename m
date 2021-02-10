Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA88315E3C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 05:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhBJEgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 23:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBJEgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 23:36:04 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AFAC061574
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 20:35:24 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id 18so670902oiz.7
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 20:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pmDYdHylpLZ7e7YMJmaf0L7DKxyrerSfd1ak0nyGYUA=;
        b=WJmCJ3H/qC6comj1Iiy+U/tnqXHH8YC1ZR/YKYg6jA6kB37Dz+h67wCTl6TSFkUUit
         qflRadlk+WB9wuFepLayzwgUvJFuJgIcsTvnhtr/zQfjH34nD28lRHOKsl1WkyX2SUaj
         DLt6Jvf8Jis1AkQCIv3vieLmpDz95G3zqdMTzsISeIpACWia429GTmkPjm+6lU2n6VfK
         IIL+LWAW/zT6eLHLxE3uJ5UKungk9fUk3XbGMwDEjiDLzDWVJfTQ+p9hiA20ohFqo6Go
         wnSvgVD98Mzpif+nzxOX69xvlYnavRJGsASxTk/uneKspRT47RR7zjtrNHmZf5EePCAi
         jRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pmDYdHylpLZ7e7YMJmaf0L7DKxyrerSfd1ak0nyGYUA=;
        b=doix+a0QQpQKA9JyvwNiY9AqBf9U/fjQELPIVoqAds4/pPUu6h70f3KuNRCv5aN3ym
         BG31EijcwXey8q8bsthyrgf1uRk8GH1BykY9ktmJgIfpbnffnqCh/TBOdU+i6PpATjPT
         8hE97H+cwyh/SPfDZy8rYnKSST4pJ6nsAlg0D+Ivwync8w76v0grhmy3IcSIwes9UfJw
         3AlfhP8P+oX/NKCHrJ8whUHji3GVz9J2iMe1Ta1yKCaMjyR4WL3RnjYX7mCK+aQS3FCN
         exbPUZixVhQsHSp1XCVf7WxTXV6f5EceGySJ0A+ifHwUYQGNpfPyhWlZF2Vx1MRjMd5c
         9QSA==
X-Gm-Message-State: AOAM533tMId0NbIPgR2Wq/v+lsFeGoZCR6yVVQhiraqwsDqOOfJQLM9i
        8ZIUhHeUxyq2tIvlYa6YOFA=
X-Google-Smtp-Source: ABdhPJyh8IfBc3OTaC14S/B7gqgX7OlFGOJxtKRL0Lc9VqQEWe3il88OzTPXzcn7ekJb32fdUG+EZw==
X-Received: by 2002:aca:c704:: with SMTP id x4mr874079oif.24.1612931723731;
        Tue, 09 Feb 2021 20:35:23 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id g66sm171211otg.54.2021.02.09.20.35.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 20:35:22 -0800 (PST)
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
To:     Arjun Roy <arjunroy@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
 <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210207082654.GC4656@unreal>
 <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <09fa284e-ea02-a6ca-cd8f-6d90dff2fa00@gmail.com>
 <20210208185323.11c2bacf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <af35d535-8d58-3cf3-60e3-1764e409308b@gmail.com>
 <20210209085909.32d27f0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOFY-A3wgGfBM0gia66VJY_iUBueWN1a4Ai8v9MT+at_pcH7-w@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3d3a2949-0ce6-01d9-a1f1-2f48720d99a9@gmail.com>
Date:   Tue, 9 Feb 2021 21:35:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAOFY-A3wgGfBM0gia66VJY_iUBueWN1a4Ai8v9MT+at_pcH7-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/21 4:46 PM, Arjun Roy wrote:
> On Tue, Feb 9, 2021 at 8:59 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Mon, 8 Feb 2021 20:20:29 -0700 David Ahern wrote:
>>> On 2/8/21 7:53 PM, Jakub Kicinski wrote:
>>>> On Mon, 8 Feb 2021 19:24:05 -0700 David Ahern wrote:
>>>>> That would be the case for new userspace on old kernel. Extending the
>>>>> check to the end of the struct would guarantee new userspace can not ask
>>>>> for something that the running kernel does not understand.
>>>>
>>>> Indeed, so we're agreeing that check_zeroed_user() is needed before
>>>> original optlen from user space gets truncated?
>>>
>>> I thought so, but maybe not. To think through this ...
>>>
>>> If current kernel understands a struct of size N, it can only copy that
>>> amount from user to kernel. Anything beyond is ignored in these
>>> multiplexed uAPIs, and that is where the new userspace on old kernel falls.
>>>
>>> Known value checks can only be done up to size N. In this case, the
>>> reserved field is at the end of the known struct size, so checking just
>>> the field is fine. Going beyond the reserved field has implications for
>>> extensions to the API which should be handled when those extensions are
>>> added.
>>
>> Let me try one last time.
>>
>> There is no check in the kernels that len <= N. User can pass any
>> length _already_. check_zeroed_user() forces the values beyond the
>> structure length to be known (0) rather than anything. It can only
>> avoid breakages in the future.
>>
>>> So, in short I think the "if (zc.reserved)" is correct as Leon noted.
>>
>> If it's correct to check some arbitrary part of the buffer is zeroed
>> it should be correct to check the entire tail is zeroed.
> 
> So, coming back to the thread, I think the following appears to be the
> current thoughts:
> 
> 1. It is requested that, on the kernel as it stands today, fields
> beyond zc.msg_flags (including zc.reserved, the only such field as of
> this patch) are zero'd out. So a new userspace asking to do specific
> things would fail on this old kernel with EINVAL. Old userspace would
> work on old or new kernels. New of course works on new kernels.
> 2. If it's correct to check some arbitrary field (zc.reserved) to be
> 0, then it should be fine to check this for all future fields >=
> reserved in the struct. So some advanced userspace down the line
> doesn't get confused.
> 
> Strictly speaking, I'm not convinced this is necessary - eg. 64 bytes
> struct right now, suppose userspace of the future gives us 96 bytes of
> which the last 32 are non-zero for some feature or the other. We, in
> the here and now kernel, truncate that length to 64 (as in we only
> copy to kernel those first 64 bytes) and set the returned length to
> 64. The understanding being, any (future, past or present) userspace
> consults the output value; and considers anything byte >= the returned
> len to be untouched by the kernel executing the call (ie. garbage,
> unacted upon).
> 
> So, how would this work for old+new userspace on old+new kernel?
> 
> A) old+old, new+new: sizes match, no issue
> B) new kernel, old userspace: That's not an issue. We have the
> switch(len) statement for that.
> C) old kernel, new userspace: that's the 96 vs. 64 B example above -
> new userspace would see that the kernel only operated on 64 B and
> treat the last 32 B as garbage/unacted on.
> 
> In this case, we would not give EINVAL on case C, as we would if we
> returned EINVAL on a check_zeroed_user() case for fields past
> zc.reserved. We'd do a zerocopy operating on just the features we know
> about, and communicate to the user that we only acted on features up
> until this byte offset.
> 
> Now, given this is the case, we still have the padding confusion with
> zc.reserved and the current struct size, so we have to force it to 0
> as we are doing. But I think we don't need to go beyond this so far.
> 
> Thus, my personal preference is to not have the check_zeroed_user()
> check. But if the consensus demands it, then it's an easy enough fix.
> What are your thoughts?
> 

bpf uses check_zeroed_user to make sure extensions to its structs are
compatible, so yes, this is required.

Also, you need to address legitimate msg_flags as I mentioned in another
response.
