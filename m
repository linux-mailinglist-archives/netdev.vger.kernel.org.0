Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6D346CD2B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhLHFbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbhLHFbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:31:20 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F23C061746
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 21:27:49 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id r5so1105183pgi.6
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 21:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C/xmja+VaCYMUqWD89Oy8QuQw1Lbx2l43n/WXHJebHo=;
        b=Q1tD6MF8e5eHgSICypuGaj6cfSO+lpaPpW5St/IlJvGMavr6KY2fwtmLEzYkoTEioa
         QyiezwsN1S7hF202483eKn4nRgPzA3/fqPJ541nO4lMaQB3JdqBBt0n/YqXztGvWH+oj
         I8ofsDuKTK6ersjkjTqXfwRXS19ngTOsjanRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C/xmja+VaCYMUqWD89Oy8QuQw1Lbx2l43n/WXHJebHo=;
        b=uuU7++XFsXvaHrNmkYkHQ6YF+RZFp4TCf1MUZBcxsHaF4q77eXFjQBNbTRSUZewBuW
         pRdpxsaHWwamC7lyZoUEcWSn9sXhf1Yw6+qE6cb+f7qGVPvTTF8VM9Xv6edYLWbSjB+7
         hzdsJLVgN7ICwvFy84lSOxA9aY6mTRsC1iJewlOp/8Qn5IzcNMu4BGTgUIl6GHLJRmKY
         SFyjqBJqJzNaNJLovbjel72FFCoB7aPfTeKoMWoC2wba7V1ZE60xf66Hq6bag7rlK01N
         bs1Zd1YYDp/PZE7TIE4+y2vA489ZZ+MQVcJKqfHl9aKVOga1YVekVcQF5fstuels4QmU
         xTvA==
X-Gm-Message-State: AOAM531Zqw9/12Se0sm2jNyxKruU+2MCAzz8CJpISyVZqdR5PCXY8wuV
        dU2gihPnEC3DeExbgA19vTgd3g==
X-Google-Smtp-Source: ABdhPJw0ifG721tDSMl4Pa0kahZYl0+d2BQ/RC+y7ZsrF0w2eviIDphPswt+oUpH4a16rlCwphSkoA==
X-Received: by 2002:a05:6a00:17a4:b0:49f:c0c0:3263 with SMTP id s36-20020a056a0017a400b0049fc0c03263mr3717005pfg.81.1638941268574;
        Tue, 07 Dec 2021 21:27:48 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t12sm4477039pjo.44.2021.12.07.21.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 21:27:48 -0800 (PST)
Date:   Tue, 7 Dec 2021 21:27:47 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Xiu Jianfeng <xiujianfeng@huawei.com>
Cc:     akpm@linux-foundation.org, laniel_francis@privacyrequired.com,
        andriy.shevchenko@linux.intel.com, adobriyan@gmail.com,
        linux@roeck-us.net, andreyknvl@gmail.com, dja@axtens.net,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH -next 0/2] Introduce memset_range() helper for wiping
 members
Message-ID: <202112072125.AC79323201@keescook>
References: <20211208030451.219751-1-xiujianfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208030451.219751-1-xiujianfeng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 11:04:49AM +0800, Xiu Jianfeng wrote:
> Xiu Jianfeng (2):
>   string.h: Introduce memset_range() for wiping members

For doing a memset range, the preferred method is to use
a struct_group in the structure itself. This makes the range
self-documenting, and allows the compile to validate the exact size,
makes it addressable, etc. The other memset helpers are for "everything
to the end", which doesn't usually benefit from the struct_group style
of range declaration.

>   bpf: use memset_range helper in __mark_reg_known

I never saw this patch arrive on the list?

-- 
Kees Cook
