Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC094839F4
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiADBsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiADBsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:48:00 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AC4C061761;
        Mon,  3 Jan 2022 17:47:59 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id j3-20020a056830014300b0058f4f1ef3c2so41581614otp.13;
        Mon, 03 Jan 2022 17:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zoQnw7K6HCodGm5UsU0Qw7DrbGZm16FdsLZ8m0V5NaM=;
        b=L+My/ejGxCjGS7tSlwjuwlPScwGl69XTPCHt+NxLk9WVJ+aMbgqj8D8wItFg7OsuCT
         qPsrlrNksFZYYDML6ET3rUwYfPd04ReHRx+ezRn9NZc9U7+EUSUhV7Ucz9/pkDsnVznT
         eN6bZ6dM/h6V44DirpFewFJfZYeRcJEhU2LIFtvtxdFu4Eg09K2KDNH7Y0YR5VLLfdGc
         fMM9NAY5fj0ON9dvdstZXYQ0iCaqcbYd89eTfzGyU2WjR1oXu10fHEB3hA8YVRhSx4oV
         erSq3k4wrBftzfmh06FRLLX+wjC1d23oiSjz/469k1EAfabSetC2VqTJ1xlNyr6YaQhv
         Dcpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zoQnw7K6HCodGm5UsU0Qw7DrbGZm16FdsLZ8m0V5NaM=;
        b=1CwuBqx7J6Xc7Stc+GgUAdjU9Xl0LsuoX2nV4j/HJn87K+MmomTVY7Phrd//8OVyja
         0fzUL3JWubJhfD6ZA3EhpLzQcYLwBcF4gVXwkAQJWPRuivhT/V0xuVX8XGGz9N14WS3N
         q8IuPHV1yDDuxupDB8Bsa2tW7NhuyN75+zq7W7EHG5ohUgdfRhkmMeCuE2rlZHVxWBUS
         vbvkFaiapnljiVBhhBGvvF64r4poptsQdkIv7eiqOvomVod3SPhB3S2MVy/sGXJb+odA
         peVI9VosqV5dZvDamgaauvvPjgsCtvIgPP9ZIlx5OMUsv4RA1bHSBE6Wzd/tSqB9oSPu
         KikA==
X-Gm-Message-State: AOAM533KZNGS85cuSk+Cptnm969E+iaBywajd3eyvzpewq4QupxdNqDY
        4m9vY1Hq1WTivl84R/iZFTY=
X-Google-Smtp-Source: ABdhPJxWYFXMeCTJiqf+Ey++DeC6PCAxPaumdjYKAHTOie3BzleJr+PcyBzkcUFwx8Ik9Wr93MC/LA==
X-Received: by 2002:a9d:7586:: with SMTP id s6mr33740684otk.158.1641260878751;
        Mon, 03 Jan 2022 17:47:58 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:73a2:abf:ebbe:9103])
        by smtp.gmail.com with ESMTPSA id i5sm7711458otj.3.2022.01.03.17.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:47:58 -0800 (PST)
Date:   Mon, 3 Jan 2022 17:47:57 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     menglong8.dong@gmail.com
Cc:     rostedt@goodmis.org, dsahern@kernel.org, mingo@redhat.com,
        davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        edumazet@google.com, yoshfuji@linux-ipv6.org,
        jonathan.lemon@gmail.com, alobakin@pm.me, keescook@chromium.org,
        pabeni@redhat.com, talalahmad@google.com, haokexin@gmail.com,
        imagedong@tencent.com, atenart@kernel.org, bigeasy@linutronix.de,
        weiwan@google.com, arnd@arndb.de, vvs@virtuozzo.com,
        cong.wang@bytedance.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, mengensun@tencent.com,
        mungerjiang@tencent.com
Subject: Re: [PATCH v2 net-next 0/3] net: skb: introduce
 kfree_skb_with_reason() and use it for tcp and udp
Message-ID: <YdOnTcSBq8z961da@pop-os.localdomain>
References: <20211230093240.1125937-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230093240.1125937-1-imagedong@tencent.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 05:32:37PM +0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In this series patch, the interface kfree_skb_with_reason() is
> introduced(), which is used to collect skb drop reason, and pass
> it to 'kfree_skb' tracepoint. Therefor, 'drop_monitor' or eBPF is
> able to monitor abnormal skb with detail reason.
> 

We already something close, __dev_kfree_skb_any(). Can't we unify
all of these?


> In fact, this series patches are out of the intelligence of David
> and Steve, I'm just a truck man :/
> 

I think there was another discussion before yours, which I got involved
as well.

> Previous discussion is here:
> 
> https://lore.kernel.org/netdev/20211118105752.1d46e990@gandalf.local.home/
> https://lore.kernel.org/netdev/67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com/
> 
> In the first patch, kfree_skb_with_reason() is introduced and
> the 'reason' field is added to 'kfree_skb' tracepoint. In the
> second patch, 'kfree_skb()' in replaced with 'kfree_skb_with_reason()'
> in tcp_v4_rcv(). In the third patch, 'kfree_skb_with_reason()' is
> used in __udp4_lib_rcv().
> 

I don't follow all the discussions here, but IIRC it would be nice
if we can provide the SNMP stat code (for instance, TCP_MIB_CSUMERRORS) to
user-space, because those stats are already exposed to user-space, so
you don't have to invent new ones.

Thanks.
