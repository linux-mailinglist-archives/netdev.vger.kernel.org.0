Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC6D2551C5
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 01:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgH0X7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 19:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgH0X7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 19:59:01 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD66C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:59:00 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id u2so1683784qtf.11
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h57l3kyoSge+DL/hTiwIZlDn37kJsV2OpP2WH0eMUrY=;
        b=qz2Q3oQfWqHwdBioUy7e30Wa5Uf6UQrbaKEU7/kqTwAwuCQh7v2CNEsybt6zayFeX1
         Rh5bUhKJE0ganW7yLCaal6Za6ej5gBHrR1m1QZdX0d0E2paVj9xDkI3Mq3s24Xw4ZJPd
         jiSlWZK/0OPd5Dd2h+a5sSFKQVNF1V8QfSb14bQtmaxM7KVYiA8lV0F8zJ5upj3RkzO/
         YYK/vm/tf+4VuZK3kdSDqCt6BvVQv+8FqA0EIf+q1twulIFvNRn6+FR4men6ZDHuAkLw
         0rE1MqNxz2Nk0hpbJEDm8CHaNSINvVW+5dv3pXbhrVNeBsOXpEl21VuheIkqk8uOBRbk
         PFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h57l3kyoSge+DL/hTiwIZlDn37kJsV2OpP2WH0eMUrY=;
        b=UzLwkl2PL0ojldlSs3RAcfpOYmtWIkYDyHdPgyf428bR3ORnsMnRkQcVZzhFw1j+pk
         2TXDXbMxFSRzgwc4T2up9RINbiBq/7840xbJulO0HBX3tTjNyJdzh/Q3czWzm60ISDTW
         3gdEkpQm1BIS/VkU8z2wkeT8jaxlqZ4A9L4zC/eteYZkrrVYEeM0nkanBWNLMNe7VBI0
         08AWI5VoCqslIYF3g/ueAknNqMwQvf/GIXEP8Pk1N2mdbPgSIfW1d2ri0kibqbYtfEXk
         mCG/kVFCqHI6fgoRy+BTMMf0PZYZxzOFhXQ2zCygWc2y4LyEVDW7WhJXOgsqKWtrl3JM
         JoRw==
X-Gm-Message-State: AOAM531AZO61azmNpkjHrdahc86uuEA6j0XCwSYfOg8uvvbSB2UknXl4
        ThYUaZKEACAFELDI8E3ng2huWA==
X-Google-Smtp-Source: ABdhPJx/rbRkLsrpsCZ9/p+65Is5d7p1Sr+vuIv9PqsCxxohllrQMOSFp7Kq1rbF5G2BSZ0QprMjZg==
X-Received: by 2002:ac8:4558:: with SMTP id z24mr22041157qtn.241.1598572739603;
        Thu, 27 Aug 2020 16:58:59 -0700 (PDT)
Received: from localhost.localdomain (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id 9sm3161050qky.81.2020.08.27.16.58.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 16:58:58 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 1/5] mm/error_inject: Fix allow_error_inject
 function signatures.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, bpoirier@suse.com, akpm@linux-foundation.org,
        hannes@cmpxchg.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
 <20200827220114.69225-2-alexei.starovoitov@gmail.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <9a4b6133-e0ca-c34e-6f85-1f04039109d5@toxicpanda.com>
Date:   Thu, 27 Aug 2020 19:58:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827220114.69225-2-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/20 6:01 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> 'static' and 'static noinline' function attributes make no guarantees that
> gcc/clang won't optimize them. The compiler may decide to inline 'static'
> function and in such case ALLOW_ERROR_INJECT becomes meaningless. The compiler
> could have inlined __add_to_page_cache_locked() in one callsite and didn't
> inline in another. In such case injecting errors into it would cause
> unpredictable behavior. It's worse with 'static noinline' which won't be
> inlined, but it still can be optimized. Like the compiler may decide to remove
> one argument or constant propagate the value depending on the callsite.
> 
> To avoid such issues make sure that these functions are global noinline.
> 
> Fixes: af3b854492f3 ("mm/page_alloc.c: allow error injection")
> Fixes: cfcbfb1382db ("mm/filemap.c: enable error injection at add_to_page_cache()")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
