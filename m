Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B91B3E2DBA
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244597AbhHFPYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:24:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48209 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244480AbhHFPX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:23:59 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 69D3D5C00D5;
        Fri,  6 Aug 2021 11:23:37 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute6.internal (MEProxy); Fri, 06 Aug 2021 11:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        stressinduktion.org; h=mime-version:message-id:in-reply-to
        :references:date:from:to:cc:subject:content-type; s=fm1; bh=B4fX
        XNqDcExo5PbK//XdrezpKXKEhtECX/f5RWkRlZM=; b=oeI36COyVM9U1hXuidYJ
        OUB3cq3QS+PVb52AWBJBSqTKV6FUxqvvN9UQMthDKepf4RfCMOtI41tKWxcsdjs+
        tjEJVtZ5mYj5ihsEse+58Ym4Cc2scgOJChF9kMP94GacuL+MGS0baUYS/fJlPq6Y
        +7kMKFhOw1+yxuqZRjBBEGFiQlIDfGRMxsxkowM8Cu7miXuCNpTBfWmgHXyGIxro
        id8hv9wruBFAvY1kk8WDO0JmWSh6g1mYemoWhzAKHe6nGg2lROt2nG18v6SSlVYT
        r/+eWhhayDTweBKcseTydEVW76f1uNTiL1Hne9O6XcOslVHDGK6DmRFnNKtBb8YA
        Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=B4fXXN
        qDcExo5PbK//XdrezpKXKEhtECX/f5RWkRlZM=; b=BMKDWBvcJFPk5WNNhCEOWv
        v8bd8jHxiC2ZEGjZLk5EEZdfw8U0zA5K4OCp8E69nkYT3AXoSxztx8rvkJ04FPvO
        O+r/6MGiEbC0V1hOWCF0YuzeuTmmEb1d2sLOyNUuEcfy/TD52Zoj4INwoXZ5sXWi
        /yGrT+/j927HT3pILOQHvqtqneJacsLZiJqcykTjOs1zanicr765koGTVgWfqZnR
        5GJnEgIDEbBp1hKA34YtL4tA1JtAHGxALptOcsxPtTR4W9KPclOezfyzGqcNkNDt
        PLYpY2XR3nqf1mR2LLZK3BUykCWtF7kBJl7MbqZtre/Ao/fueZqsyp8l17rhhrjw
        ==
X-ME-Sender: <xms:-FMNYba3wbcKbyf9wgYkWVyK2gJnFDx1quK4B4kw29HKqD-7DnHNGQ>
    <xme:-FMNYabYRsDk8sX58hVCHVMbJdpVtRQsjuBjVXLy-wmFybNKV80lENSMmjtI_h8HV
    1qP64SpaObNQUncbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjedugdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfjfgrnhhn
    vghsucfhrhgvuggvrhhitgcuufhofigrfdcuoehhrghnnhgvshesshhtrhgvshhsihhnug
    hukhhtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepveetteehffdtgeeihfduueel
    heeljeeiffffueevveeugeejkeefkefffedvfedtnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehhrghnnhgvshesshhtrhgvshhsihhnughukhhtihhonhdrohhrgh
X-ME-Proxy: <xmx:-FMNYd-6Nynv3FvFpCl0ivD04HtNLANjzdfQIiMHYdysxZvHO9e9Bg>
    <xmx:-FMNYRpXFovffZVtkS3pwoBG0-FOw98OB8RRIfFQT-abPz1TeAQORw>
    <xmx:-FMNYWo2AF8US5zq7s7I2IHjhUj_wruSHcKhppwBI02Qd3Xd6vghOA>
    <xmx:-VMNYXd2hFUZLvXSXOQZ_F94EL9omos_Nj06k_TU2-YhkYNzgWuqwA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 5115AA03D9B; Fri,  6 Aug 2021 11:23:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-552-g2afffd2709-fm-20210805.001-g2afffd27
Mime-Version: 1.0
Message-Id: <7ae60193-0114-46d2-9770-697a2f88b85b@www.fastmail.com>
In-Reply-To: <20210806082124.96607-1-wangkefeng.wang@huawei.com>
References: <20210806082124.96607-1-wangkefeng.wang@huawei.com>
Date:   Fri, 06 Aug 2021 17:22:55 +0200
From:   "Hannes Frederic Sowa" <hannes@stressinduktion.org>
To:     "Kefeng Wang" <wangkefeng.wang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David Miller" <davem@davemloft.net>
Cc:     "Andrew Morton" <akpm@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Minmin chen" <chenmingmin@huawei.com>
Subject: Re: [PATCH v2] once: Fix panic when module unload
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 6, 2021, at 10:21, Kefeng Wang wrote:
> DO_ONCE
> DEFINE_STATIC_KEY_TRUE(___once_key);
> __do_once_done
>   once_disable_jump(once_key);
>     INIT_WORK(&w->work, once_deferred);
>     struct once_work *w;
>     w->key = key;
>     schedule_work(&w->work);                     module unload
>                                                    //*the key is
> destroy*
> process_one_work
>   once_deferred
>     BUG_ON(!static_key_enabled(work->key));
>        static_key_count((struct static_key *)x)    //*access key, crash*
> 
> When module uses DO_ONCE mechanism, it could crash due to the above
> concurrency problem, we could reproduce it with link[1].
> 
> Fix it by add/put module refcount in the once work process.
> 
> [1] 
> https://lore.kernel.org/netdev/eaa6c371-465e-57eb-6be9-f4b16b9d7cbf@huawei.com/
> 
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Reported-by: Minmin chen <chenmingmin@huawei.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Thanks,
Hannes
