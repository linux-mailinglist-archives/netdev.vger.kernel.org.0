Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE263BA151
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 15:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhGBNma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 09:42:30 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:42886 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbhGBNma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 09:42:30 -0400
Received: by mail-ed1-f52.google.com with SMTP id n25so13273904edw.9;
        Fri, 02 Jul 2021 06:39:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=w9kubsVWaTOUK+nU0YjZV/Ze/jgMiHptRWmLi0Ujvvg=;
        b=LCaclHVVTFcyBclFiXQlzb4AKlZZxnu9WAJFydVcmRnI2zuN7akKrF7FZcnXx/jjqi
         1EcMXXDp8YEoUofvMO+/FY5YFEZPhOnbWDYoCumMW6kPUPWUEwVieoVlvwVQD4cWdW8N
         adlnCbXizKxWVZxLJX4DyP0i6vdoOuskQxOWubKx5icb9VyYUXvSoc9cPepnhPhlnt2Z
         OFgg7BtZwJLKtXsLaBGOlAMNCYfkk6ox1LgA+CAB1NvhsVk86JLIXPiOwR3ndvcSK4tt
         A5vFguwzAR5lcjAH/8R+EpE5APIfIwu0sMZHZ9lJ/K9+o3xa8vlV3+XLj7hHhKhnHCFU
         OoNg==
X-Gm-Message-State: AOAM5302g2INy6/RvrMUSqOyfme2siyF1Zam3T0hakVF5arbOd4hxoKV
        fC5WltTHupH29tg6eJv0UuIWJSVQZXLJBhfN
X-Google-Smtp-Source: ABdhPJwIHuKU+e0GC/3/lK/8AFkZf088CPagR8W+iav39xxS3ibBGzCEopLZXrN9ZYeu7IIv1zPHNg==
X-Received: by 2002:a05:6402:88b:: with SMTP id e11mr6844737edy.21.1625233196688;
        Fri, 02 Jul 2021 06:39:56 -0700 (PDT)
Received: from localhost (host-80-182-89-242.retail.telecomitalia.it. [80.182.89.242])
        by smtp.gmail.com with ESMTPSA id b8sm1336709edr.42.2021.07.02.06.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 06:39:56 -0700 (PDT)
Date:   Fri, 2 Jul 2021 15:39:47 +0200
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>, <mw@semihalf.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Russell King <linux@armlinux.org.uk>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <linux@armlinux.org.uk>,
        <hawk@kernel.org>, <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next RFC 0/2] add elevated refcnt support for page
 pool
Message-ID: <20210702153947.7b44acdf@linux.microsoft.com>
In-Reply-To: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
Organization: Microsoft
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Jun 2021 17:17:54 +0800
Yunsheng Lin <linyunsheng@huawei.com> wrote:

> This patchset adds elevated refcnt support for page pool
> and enable skb's page frag recycling based on page pool
> in hns3 drvier.
> 
> Yunsheng Lin (2):
>   page_pool: add page recycling support based on elevated refcnt
>   net: hns3: support skb's frag page recycling based on page pool
> 
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  79 +++++++-
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   3 +
>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   1 +
>  drivers/net/ethernet/marvell/mvneta.c              |   6 +-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
>  include/linux/mm_types.h                           |   2 +-
>  include/linux/skbuff.h                             |   4 +-
>  include/net/page_pool.h                            |  30 ++-
>  net/core/page_pool.c                               | 215
> +++++++++++++++++---- 9 files changed, 285 insertions(+), 57
> deletions(-)
> 

Interesting!
Unfortunately I'll not have access to my macchiatobin anytime soon, can
someone test the impact, if any, on mvpp2?

Regards,
-- 
per aspera ad upstream
