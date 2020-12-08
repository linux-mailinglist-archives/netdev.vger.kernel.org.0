Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090E12D2DE3
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 16:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgLHPJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 10:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbgLHPJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 10:09:36 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE484C061794
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 07:08:55 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id 91so12638543wrj.7
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 07:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4VWcs2yFRFudtSifeet7387FaOh2+wzkZREGLlag6WY=;
        b=OqEi9bARIV6TwbjwZCXOML6BM58z2Mcgcxjf0CxHqfSrUB/5ss1PMbBAH3LOz2lu/B
         PGXyu/2I4f6JMxQQxA+m0FYGI7XgONhiBdJtyx/ZUo1laLXF4JPQcQZGjd+Ld3hBbsQv
         aE/zIAxvKkvTKSfkHN9Ov745qinj5q7mQB7FS4r/FsmuJYhDBlhliUVVO26V4TArNa9U
         MJ7MSbrOe2e317EHJ9FdQGHMkPge0hFu7N6438mz90i5kdbvymPgbFZclWz+dS3IzXRu
         i9o9H5uMvAPmUujdZok8qhtTzCd3bSCz+4EBYIFyqytBq7NDqmLL75I0mHtLX+ue3lju
         p3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4VWcs2yFRFudtSifeet7387FaOh2+wzkZREGLlag6WY=;
        b=ld4EaeXJ3lj7jHGPITwyTfAA1APqM+8MQmKv2/knHr73d/ktSzeIEAJMsRI7oxAJ1S
         BL/QZ0YUbn9EolM2XxlqNs1cn25XwEBMouHA18jCSnPsR4mdYUN21M0EHyykhi1bFUXS
         kDnkrr/XWxtDC3ZNhMGvie6/kY9zvU6xgOu6vLLvMQwKTY0dqi2c4EsTWhAC7twmo8u6
         O2FAytEqh2EzsycgB3kt68d2yd3xh+OYWK3F4Cz/CGlKGGlBpZhtJcwEulqg2LHuMrrA
         I7UOHELuIYnT3CtwvIveXp84JhrCSitgfpL1shtqq8RZ/6ecMBCwPmdxK4GbTS7JinrO
         tbJQ==
X-Gm-Message-State: AOAM531QUWo7cKvm4UjwXyEqj6dElEU2glCDuInM19ZORMl4mwHZYkmx
        amb3sJgfhZyZKJfksqdXY7o7Lcy/xWQ=
X-Google-Smtp-Source: ABdhPJwyglQ+zP4lf39JjtFUPqNXkCKcuLzNGNgbNvaXjvHcrCjPss6bwTpyDA+js0i8qkAVK7XqoQ==
X-Received: by 2002:adf:e788:: with SMTP id n8mr25561122wrm.84.1607440134419;
        Tue, 08 Dec 2020 07:08:54 -0800 (PST)
Received: from [192.168.8.116] ([37.167.174.84])
        by smtp.gmail.com with ESMTPSA id z64sm3928503wme.10.2020.12.08.07.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 07:08:53 -0800 (PST)
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
To:     stranche@codeaurora.org, dsahern@gmail.com, weiwan@google.com,
        kafai@fb.com, maheshb@google.com, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     subashab@codeaurora.org
References: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <56e72b72-685f-925d-db2d-d245c1557987@gmail.com>
Date:   Tue, 8 Dec 2020 16:08:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/8/20 4:55 AM, stranche@codeaurora.org wrote:
> Hi everyone,
> 
> We've recently been investigating a refcount problem when unregistering a netdevice from the kernel. It seems that the IPv6 module is still holding various references to the inet6_dev associated with the main netdevice struct that are not being released, preventing the unregistration from completing.
> 
> After tracing the various locations that take/release refcounts to these two structs, we see that there are mismatches in the refcount for the inet6_dev in the DST path when there are routes flushed with the rt6_uncached_list_flush_dev() function during rt6_disable_ip() when the device is unregistering. It seems that usually these references are freed via ip6_dst_ifdown() in the dst_ops->ifdown callback from dst_dev_put(), but this callback is not executed in the rt6_uncached_list_flush_dev() function. Instead, a reference to the inet6_dev is simply dropped to account for the inet6_dev_get() in ip6_rt_copy_init().
> 
> Unfortunately, this does not seem to be sufficient, as these uncached routes have an additional refcount on the inet6_device attached to them from the DST allocation. In the normal case, this reference from the DST allocation will happen in the dst_ops->destroy() callback in the dst_destroy() function when the DST is being freed. However, since rt6_uncached_list_flush_dev() changes the inet6_device stored in the DST to the loopback device, the dst_ops->destroy() callback doesn't decrement the refcount on the correct inet6_dev struct.
> 
> We're wondering if it would be appropriate to put() the refcount additionally for the uncached routes when flushing out the list for the unregistering device. Perhaps something like the following?
> 

dev refcount imbalances are quite common, particularly on old kernel versions, lacking few fixes.

First thing is to let us know on which kernel version you see this, and how you reproduce it.

