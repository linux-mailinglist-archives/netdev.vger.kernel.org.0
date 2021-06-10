Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B623A2512
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhFJHMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhFJHMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:12:55 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305AAC061574;
        Thu, 10 Jun 2021 00:10:59 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id u24so31681319edy.11;
        Thu, 10 Jun 2021 00:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sDMUM5jQ/yZI/9ZRG9sS/s63Em3E6MUmiUZc4pjQWSs=;
        b=KJWjXejmJrpZIL+F5rsuNh2y2UUEla5nlW/VtxSrCk6LTa7FWtAXuvbAJq7BnY1/om
         I7bMITQA8UBBefAw3PaC0AElY7Cd57mfHL51IGbndEqMMvs0LNWRBxvOhgkhmkh0wvx5
         D30XSLTwoezO6G7D5Yk3fsUBXVa2Ruqcwcf9qzXvweGwQoNZOmyv5JeL/2CzPOnLK2E7
         0mVr4cVPDAfJbFEjs8ixKnBTBqWaki7UqbRZgJYlhH/tOlvDRQzIn84OcIUGMZYLB+5B
         kunaNlhaomDSh+A+nG03YPxwk6JG+G2k14jTooOQ0NXZY7m446M43Zp/kCwM15qytgG5
         pdSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sDMUM5jQ/yZI/9ZRG9sS/s63Em3E6MUmiUZc4pjQWSs=;
        b=qV1aROst7mPxE3AfCyBCAa2fdwPqDxAGxEV3AxjQ1DUQ9Xk8qSDp736vN0a6BZVOeG
         Q+bgO9riUaSHZxGe2z9RvjLOzEzU1AtKOM/f/f0knrY79w+CMYQyNzBVgPAFJCVrnSkI
         45p2VKynv89+6SKa+1HvQjNIS2Txdgfsk7c2WAFpV39kdmLky+9lOUWE4GGun3MLLd+n
         6xKcnaKZIknQDyM7baCj00zkEj0q3/8AT3VwPEkEosNQGc8mMLPwmOUnj3InaupIDFl8
         vXIpoK9CxM7mPq0hCTH6g62ajPOsjWo+TOmrGiHpU+/0lclQ49DCmqhoiheu3Lybvb4x
         A90A==
X-Gm-Message-State: AOAM531ua2xeTAzBNm8R5KO5rRk/+7eSTaP6ybgIoJQmVreLLh+NemXH
        WlEfToix6T68l40JDNsmYIY=
X-Google-Smtp-Source: ABdhPJym+3YGFnCHiRuf6ioutxiJqa9JnFyYgudpXDSLJRSG5xQmI83zHDPosKBESiLFUJ8CrdlJqw==
X-Received: by 2002:a50:eb92:: with SMTP id y18mr3250113edr.249.1623309057799;
        Thu, 10 Jun 2021 00:10:57 -0700 (PDT)
Received: from [10.21.182.92] ([212.23.236.67])
        by smtp.gmail.com with ESMTPSA id cw24sm652463ejb.20.2021.06.10.00.10.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 00:10:57 -0700 (PDT)
Subject: Re: [PATCH bpf-next 11/17] mlx4: remove rcu_read_lock() around XDP
 program invocation
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-12-toke@redhat.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <1763e3d2-844c-c2ca-b11d-fcd2af80fcd9@gmail.com>
Date:   Thu, 10 Jun 2021 10:10:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210609103326.278782-12-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/2021 1:33 PM, Toke Høiland-Jørgensen wrote:
> The mlx4 driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
> program invocations. However, the actual lifetime of the objects referred
> by the XDP program invocation is longer, all the way through to the call to
> xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
> turns out to be harmless because it all happens in a single NAPI poll
> cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
> misleading.
> 
> Rather than extend the scope of the rcu_read_lock(), just get rid of it
> entirely. With the addition of RCU annotations to the XDP_REDIRECT map
> types that take bh execution into account, lockdep even understands this to
> be safe, so there's really no reason to keep it around. Also switch the RCU
> dereferences in the driver loop itself to the _bh variants.
> 
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---

Thanks for your patch.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Regards,
Tariq
