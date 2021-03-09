Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85F9332164
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhCIIzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhCIIzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:55:43 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC30C06174A;
        Tue,  9 Mar 2021 00:55:43 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 16so7515853pfn.5;
        Tue, 09 Mar 2021 00:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=B5ih2s0wGc6zEFGLbxaitiDeyP8RPIDxWcG4Pgj6aB8=;
        b=skIi6WtK6erYgcTFqAwcc4M5eJz175vB27CUN/27YkRO+dfOhWaYavQbh3YRsCJvxQ
         H8V60Cqx1GIFDazpK5UDJUbLlDQS+5nvVb4Wkn8yyOstL5uP7Gtkmm3Sb+bccTtDJbXU
         GZWUcydG+y6fQdpiYT/6fjbjkgjMC1o/p4BsXQq4Ka/B45g8y8t9uruFQgot5v/6vAHL
         qDA8oDvupxDCrhVjfefEwbMk5C61cW6OkBFuKJpNbVJGoClU91RLL/MUClC0BnWvb45j
         g7CBwhZPLSDFkUYicRdaYeu+qmsRbFkanzkliQDnIUxM6fej2uong4IjbKg8IkmNLG3w
         dqmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=B5ih2s0wGc6zEFGLbxaitiDeyP8RPIDxWcG4Pgj6aB8=;
        b=JUCM7LksH0bpIDY5he/OunPcJmhpLnqBCM8L07KZctsfv31h/W7LhpqeHsibO7IomI
         VwroaJ5HfwmnrgnxnVGhYUMo3OEhihE5XhX3hIuIy0ATyt2v3VnTfWiG/gqNx/JkY2dF
         2eP6kHSdqjOMYueQwQtve6lupnN82i+EwWt765v1GOHQ6zgOQ6mJDxwbhDiXIRnp5351
         AzwUZUBMkFuBA5+Wi1kDLCG6C4aTDys9veu2zXidRqjHiE34N5ivcA9QSBEskvK4vIrL
         Kf0YGteY3Ldorx2IjjT0RtJBTm/oHQMdaN/M7gLleMSP3SXUrQpMdr3Q0Byf2sfb54Xz
         lkPw==
X-Gm-Message-State: AOAM531MKz0U9SJOiT0lB/L2syGDfshsg9tdcei+szMuG96UuS2ZugbX
        Z/tADrt8eB/XswXK80zWRWHldTxqhnv6I5AI
X-Google-Smtp-Source: ABdhPJyUidhLxO3ucv6QEixM3GFAayp3mRjka2yVAXt2nBJzBPNyqYya/vLaPZLxcrpMT2cBdlI1bw==
X-Received: by 2002:a63:a22:: with SMTP id 34mr23965822pgk.328.1615280142844;
        Tue, 09 Mar 2021 00:55:42 -0800 (PST)
Received: from [10.160.0.86] ([45.135.186.124])
        by smtp.gmail.com with ESMTPSA id q34sm12073556pgl.92.2021.03.09.00.55.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 00:55:42 -0800 (PST)
Subject: Re: [PATCH] net: netlink: fix error return code of
 netlink_proto_init()
To:     Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        marcelo.leitner@gmail.com, mkubecek@suse.cz, jbi.octave@gmail.com,
        yangyingliang@huawei.com, 0x7f454c46@gmail.com,
        rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <20210309083356.24083-1-baijiaju1990@gmail.com>
 <1ca491b5-1c65-6dee-1f8c-d86006714b51@gmail.com>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <fb1e13d8-6b7e-ca47-2f65-930dfdb651dc@gmail.com>
Date:   Tue, 9 Mar 2021 16:55:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1ca491b5-1c65-6dee-1f8c-d86006714b51@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/3/9 16:47, Heiner Kallweit wrote:
> On 09.03.2021 09:33, Jia-Ju Bai wrote:
>> When kcalloc() returns NULL to nl_table, no error return code of
>> netlink_proto_init() is assigned.
>> To fix this bug, err is assigned with -ENOMEM in this case.
>>
> Didn't we talk enough about your incorrect patches yesterday?
> This one is incorrect again. panic() never returns.
> Stop sending patches until you understand the code you're changing!

Ah, sorry, I was too confident about this bug report...
Thanks for your reply.
Following your advice, now I am sending the patches only for the bug 
reports that I am confident about after careful code review.
Some of the patches have been applied, but some of them are still wrong, 
like this patch...
I am sorry for the false positives...


Best wishes,
Jia-Ju Bai
