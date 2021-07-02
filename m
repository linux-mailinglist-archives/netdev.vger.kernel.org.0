Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FC53B9D9A
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 10:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhGBIik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 04:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhGBIij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 04:38:39 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3489C061764
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 01:36:07 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id v5so11478998wrt.3
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 01:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7FZN41zFvSYxh+iEV226AlMaIZ9YuMRVvjo0w5RlrRg=;
        b=zARHa0Smrt/1UIlw1UhZvHTz5jbXFIGlSVYne/ZG7zj6bAj6G68ScyCLlTxEQAxFv6
         qJIJhckBCmxtJ/QsW6Ck5W5YdiIyOzm987UxCmeVfg6hQIeZDSaq1Ztj+kQdNHpMx1w/
         4z7MpEVjIQK9G1EMnQvMQ/N9Vw0cYmo1OTj9n5toT/cZ/IVEvLZwXVYMq6IxhOxLpHQm
         2haIVsCbbQstJkfnjqc0XnHwPD0TDrZt7G/d8b828z248uFm6YZGw1yiEBqmXzCCXeeU
         f1Arll1K+2v/i6+OfR8AWn0cl8ylzGpknTGQMmVvBxehFETzzN+IU/X3BlGrdZAASvPY
         Fcag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7FZN41zFvSYxh+iEV226AlMaIZ9YuMRVvjo0w5RlrRg=;
        b=WRImYwGUs/ECfowZFkOxxC5lffbewIS8RfXGq0Y/en0JRgOEBBtFAHRyMZw+OmDaGX
         p8hmzWJ78gB0DWjZX3AxsIYDYd69b1lxQTcExCphVHlfpOde8zCYOp22yws/jW8waLMD
         6LDCt4mqkvFKB96EBzj4OgthFXm89b2pgZjZTzzGRYasvE86rBcBK4cHwULsqCBkwvmn
         b3ykymSXhoRQKer36wvsnJfxKW6MA0MfKcuNQ03su0YIW48Z3mgedcftqS8kiJmt2FfM
         jmiGdQidWS5FlNSbGFTItqugo/rC8pB4Rf8LvaaPKkvALY6zlBY4WpEXZ8cndqRvwNgB
         pogg==
X-Gm-Message-State: AOAM532yOVc9sNz5QHzzZ5O29jVs/49VezJ+Uy9Y0cmL2b+yQ/ykbu+/
        7SouNVqG8tc9M/sY6gEzJfAGjw==
X-Google-Smtp-Source: ABdhPJzga7frJg+9Zf+0ANeCdeGJyDqrA4zrx8RoTlibuVEj3L9i0gf3FY/cbI1z2ewA+/OBYH4y6A==
X-Received: by 2002:a05:6000:1251:: with SMTP id j17mr4499946wrx.122.1625214966270;
        Fri, 02 Jul 2021 01:36:06 -0700 (PDT)
Received: from enceladus (ppp-94-66-242-227.home.otenet.gr. [94.66.242.227])
        by smtp.gmail.com with ESMTPSA id w3sm11965453wmi.24.2021.07.02.01.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 01:36:05 -0700 (PDT)
Date:   Fri, 2 Jul 2021 11:36:01 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        thomas.petazzoni@bootlin.com, mw@semihalf.com,
        linux@armlinux.org.uk, hawk@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        akpm@linux-foundation.org, peterz@infradead.org, will@kernel.org,
        willy@infradead.org, vbabka@suse.cz, fenghua.yu@intel.com,
        guro@fb.com, peterx@redhat.com, feng.tang@intel.com, jgg@ziepe.ca,
        mcroce@microsoft.com, hughd@google.com, jonathan.lemon@gmail.com,
        alobakin@pm.me, willemb@google.com, wenxu@ucloud.cn,
        cong.wang@bytedance.com, haokexin@gmail.com, nogikh@google.com,
        elver@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next RFC 0/2] add elevated refcnt support for page
 pool
Message-ID: <YN7P8Y+qWxAADJJR@enceladus>
References: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1625044676-12441-1-git-send-email-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yunsheng, 

On Wed, Jun 30, 2021 at 05:17:54PM +0800, Yunsheng Lin wrote:
> This patchset adds elevated refcnt support for page pool
> and enable skb's page frag recycling based on page pool
> in hns3 drvier.
> 

Thanks for taking the time with this! I am a bit overloaded atm, give me a
few days and I'll go through the patches

Cheers
/Ilias


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
>  net/core/page_pool.c                               | 215 +++++++++++++++++----
>  9 files changed, 285 insertions(+), 57 deletions(-)
> 
> -- 
> 2.7.4
> 
