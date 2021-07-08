Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AED3BF6B8
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 10:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhGHILP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 04:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhGHILO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 04:11:14 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C10C061574;
        Thu,  8 Jul 2021 01:08:32 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id a8so6353585wrp.5;
        Thu, 08 Jul 2021 01:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0gQCiVWHnENSaNLbAkzqpLG4Nw4sNv4Kb7hrJojJUFQ=;
        b=HIoJLVdXN7GLqFdwM1tJZ+niNitRx3J6zWG9+W2pLSWdweIS7029LrZUqEt5zqcWLM
         tMDr04xgCJ4c+0xcbJUq7I4ENW4dKD9RHL8pAI996hnGyPRuBTFzD/ImO3zWLABIzAuJ
         7VoYHCcGdNJhp/5Jmnloun+UPTB2HD4oRop80aPQPgQ0srLmyGp3HEkRLml3L7LJ9+pz
         ZS7kYr7vZG6OPAOG24jXDJ/vwFHoYnrz4ZMPbkFna42N2wz2B0VmaEOKNQarmbyOIcJp
         LeZ5V4Rkpx6hOYvYbbyPFFOqtKg1a2onvPplqMjZhWEsTuzI5nIjenG8A9ju1fodDOtw
         kPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0gQCiVWHnENSaNLbAkzqpLG4Nw4sNv4Kb7hrJojJUFQ=;
        b=TcUVo5nO5081HzqPqizyk5g4jIuQxujCm5s1hSt+K5n2J/AUenUbtj+ai+Xf90bzyY
         9efvK2uXc/KwPr813z7wBL9eqY6rciNMgkyvQLl1QZknPh4Nl3sCvLFCOiW5E5lslsL8
         sqN5QxFyKaZnTJmHQXE2qzHPvKI4KOO4hAXtN8Qf3d8HDsBeBrJX+vram5/kSnWoWwET
         8q7pOflc6aUGKMIrpRUXiZA32b2Tq53oieGm8axgoY+imzhQfz4ZkALyIxpsAy70et5t
         O+bnj6HxTjD2MBZks6hRMLj9QnVV650BAcJXUB9S28MdBiXIW+djnb6JuydUiEPgzN0y
         PU1w==
X-Gm-Message-State: AOAM533PS27SJM1ethRCM1Qkd7Mj9cDZtaWAjUtR8c/n6ulsLxMbDizv
        52YulkCK8Vdgf3Afy0Kq88qjnDZVt6A=
X-Google-Smtp-Source: ABdhPJznJ8uFi7KEB3UmzZEHGRNcnSxfCw+kXc8n47jza2IATwHia2kJi0F6XEcYwLIbyH4JNXHpYw==
X-Received: by 2002:a5d:6986:: with SMTP id g6mr32174198wru.321.1625731710755;
        Thu, 08 Jul 2021 01:08:30 -0700 (PDT)
Received: from [192.168.98.98] ([37.165.6.154])
        by smtp.gmail.com with ESMTPSA id j1sm8277140wms.7.2021.07.08.01.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 01:08:29 -0700 (PDT)
Subject: Re: [PATCH] net: rtnetlink: Fix rtnl_dereference return value is NULL
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org, ryazanov.s.a@gmail.com, johannes.berg@intel.com,
        avagin@gmail.com, vladimir.oltean@nxp.com, cong.wang@bytedance.com,
        roopa@cumulusnetworks.com, zhudi21@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210708073745.13797-1-yajun.deng@linux.dev>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2a00ac67-f5bc-8ff8-3737-ebea83777f87@gmail.com>
Date:   Thu, 8 Jul 2021 10:08:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708073745.13797-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/21 9:37 AM, Yajun Deng wrote:
> rtnl_dereference() may be return NULL in rtnl_unregister(),
> so add this case handling.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/core/rtnetlink.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 

I do not see a use case for this.
None of rtnl_unregister() callers check the return value anyway.

Can you elaborate ?

If this was a bug fix, we would need a Fixes: tag.

If this is something you need for an upcoming work, you would need to tag
this for net-next tree.

Thanks.
