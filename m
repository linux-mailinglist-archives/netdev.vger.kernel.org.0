Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B1E3146F1
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 04:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhBIDWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 22:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhBIDVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 22:21:18 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33283C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 19:20:33 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id v193so12550096oie.8
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 19:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gDh/V+EYAFnYmiU7pJtpB5PE+2Rtzq2zI8OsHiAS74U=;
        b=XorQhpizB/Pwk2hLmTfMlPZUk29sB10qZ2lhJD15Pe6r9l/QgAAgNgBJMsnUK0rLMq
         fMoLcQgyzNDn0py51pSSyyzMl6IN6XDl88IvPVEuRexwoCfbXvB1v87EM4HcjyILjr1B
         gN9RLKtFlkG2KvtKxnquHGLthZm2xCtLJ0/CibtSy9W9MmFaju+1cXKxzVmLRlDrTUUW
         jCkHnvtjSu+d/1Yo9e/nrFYwZf0fTO8Xg5vXFfqfreCp5rRjgpPPErFjf8W4WM8Q+s+z
         xYeVhIB5XibgdaEoyrPFsB7YdAl5VL5ITyZvGzPSMhEAWG6dPOlZy63IC3kUWml8H10I
         GnXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gDh/V+EYAFnYmiU7pJtpB5PE+2Rtzq2zI8OsHiAS74U=;
        b=AbyapTNVyrkclrEl10Im5CZJC3O3I0+y+jy0OmqtxSn6yORNW7WB/R4IhxfCmqAuiX
         agFInZARQSwhs9UvM1ewCvLtcCbWucZhf8Gk71bPO/tQkr+EJPGgKa8r34mcjhOxYfug
         kF1a9qXub2PnZWcHnXF56NBMnf3Han8LJlG7JmFPkNlTjx3uvNywERQJcwN7gVJPvsPj
         WKtL0JWU6yPYUiPkJ0hEWjEt4XL1sNUw4C9BTVVGO9CfXRUa6x2osSSco2q24r9+BW5A
         kUTUO/BZXADe2kwT8Z2JH1ZGtXqVRlhtma3uVe6cDKUQpU62iwlXaAjqZc/v9xonYwLr
         XsbA==
X-Gm-Message-State: AOAM532Be0vmHybgIhZO/bzZPPHfJMfZTDeY8y154DD8kAh4GxG7fsjp
        lYTik+i6tKmSo5DMICEL1RY=
X-Google-Smtp-Source: ABdhPJwi5GQLDm0AUrPtEXO4lMbCRwroUE8xzaEBkQSg080ank3O9sDeXJuvVmcDmVrfpOzxERXUag==
X-Received: by 2002:a05:6808:bc3:: with SMTP id o3mr1217349oik.134.1612840832673;
        Mon, 08 Feb 2021 19:20:32 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id k32sm4087397otc.74.2021.02.08.19.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 19:20:32 -0800 (PST)
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
 <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210207082654.GC4656@unreal>
 <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <09fa284e-ea02-a6ca-cd8f-6d90dff2fa00@gmail.com>
 <20210208185323.11c2bacf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <af35d535-8d58-3cf3-60e3-1764e409308b@gmail.com>
Date:   Mon, 8 Feb 2021 20:20:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210208185323.11c2bacf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 7:53 PM, Jakub Kicinski wrote:
> On Mon, 8 Feb 2021 19:24:05 -0700 David Ahern wrote:
>> On 2/8/21 11:41 AM, Jakub Kicinski wrote:
>>> On Sun, 7 Feb 2021 10:26:54 +0200 Leon Romanovsky wrote:  
>>>> There is a check that len is not larger than zs and users can't give
>>>> large buffer.
>>>>
>>>> I would say that is pretty safe to write "if (zc.reserved)".  
>>>
>>> Which check? There's a check which truncates (writes back to user space
>>> len = min(len, sizeof(zc)). Application can still pass garbage beyond
>>> sizeof(zc) and syscall may start failing in the future if sizeof(zc)
>>> changes.
>>
>> That would be the case for new userspace on old kernel. Extending the
>> check to the end of the struct would guarantee new userspace can not ask
>> for something that the running kernel does not understand.
> 
> Indeed, so we're agreeing that check_zeroed_user() is needed before
> original optlen from user space gets truncated?
> 

I thought so, but maybe not. To think through this ...

If current kernel understands a struct of size N, it can only copy that
amount from user to kernel. Anything beyond is ignored in these
multiplexed uAPIs, and that is where the new userspace on old kernel falls.

Known value checks can only be done up to size N. In this case, the
reserved field is at the end of the known struct size, so checking just
the field is fine. Going beyond the reserved field has implications for
extensions to the API which should be handled when those extensions are
added.

So, in short I think the "if (zc.reserved)" is correct as Leon noted.
