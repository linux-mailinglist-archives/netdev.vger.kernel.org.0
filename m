Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106E04A2D4A
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 09:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiA2I4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 03:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiA2I4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 03:56:33 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15802C061714;
        Sat, 29 Jan 2022 00:56:33 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id qe6-20020a17090b4f8600b001b7aaad65b9so2531282pjb.2;
        Sat, 29 Jan 2022 00:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xn/qJjrrzAvXyxtE1CdQaJrstqcp2JmG2KjRcr5IUNk=;
        b=S0kRGrUdtb6+O2XoqCMR9FNw3hpDGFKxPXATSEXGU+XfskCh8+j9ORGhSHIMzKMMtv
         Li0Lg7IMCesd4TLZsMs5JILyAwj0FHEotg4MmdUU5n7ZqDrRNiw5DETsMuVqyDOUnLWM
         Xdzy6k+Y2koQXMZfQ0h7IfCVIii5m7QVX5cAiqGAiu24MeDRn8xSMRLm/EN0YFhtO18x
         BgEHDJGC4uwZ8OD4N6EXdrAqH5rJkSUnsAQhz5BuHCAZ5cb8pV1V+mERuU5Tb990wgq3
         cs5mq+U27oZ0vr6zsrh8j/TGNvRmxr0StAYbsmw40lMB+OahKrA50E183izk5cL176O+
         mY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xn/qJjrrzAvXyxtE1CdQaJrstqcp2JmG2KjRcr5IUNk=;
        b=qDF1OGO3iyiCHA6+eQGc0R7bt8IURYsq8s3+qLGUXiFx0t5j3H0BM/P1NF4CO7UIYv
         s5+JqaFfS1slG+gNzSNvMt0xCvJ+r26napIM7sKvGOoGTE2yul/aIT9AMNIzAX/6T3rm
         ap8Vq1vhe3BBvbllw2a0a1LNw4pOOstuQW5ZzFmi4jBWGXULbtwSPILPsCnoBYWaSl5j
         LC/CEj+a2BT0kujAnsabvMcHT5S2fI+NQTQiHA91WMHYJtJyRf8yBOTxe+A8anjpKt9M
         feslXbY0fjCQIQs3ul0iOXKYwD50m9K8mt0n0C0Kulsa4FqHl6w933ipDyblSxk0FW0I
         cw2A==
X-Gm-Message-State: AOAM533owZKP69em4qDSiq498fQ8/Kg7EVOFVYFwyossiXvwfxo4YD0k
        SFPwGsmLZ9eAYtepZZ72dnY=
X-Google-Smtp-Source: ABdhPJwSY20TPYJ25ZlXjRuK3gW21tFwgBtIXJAU15gNpsvvXqU4nFwSCDyO3RjxW3BOHTer5Zy+xw==
X-Received: by 2002:a17:90a:d58d:: with SMTP id v13mr14098494pju.210.1643446592611;
        Sat, 29 Jan 2022 00:56:32 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id d9sm11830687pfl.69.2022.01.29.00.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 00:56:32 -0800 (PST)
Date:   Sat, 29 Jan 2022 08:56:27 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Julian Wiedmann <jwiedmann.dev@gmail.com>
Cc:     Shay Agroskin <shayagr@amazon.com>, netdev@vger.kernel.org,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ena: Do not waste napi skb cache
Message-ID: <YfUBO2pTUVoHSTim@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <20220123115623.94843-1-42.hyeyoo@gmail.com>
 <f835cbb3-a028-1daf-c038-516dd47ce47c@gmail.com>
 <5cca8bdd-bed0-f26a-6c96-d18947d3a50b@gmail.com>
 <pj41zlmtjk7t9a.fsf@u570694869fb251.ant.amazon.com>
 <Ye/EQgqCBogZR87T@ip-172-31-19-208.ap-northeast-1.compute.internal>
 <bad34ba9-eacf-f325-7ebc-6fdd43414945@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bad34ba9-eacf-f325-7ebc-6fdd43414945@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 03:50:30PM +0200, Julian Wiedmann wrote:
> On 25.01.22 11:34, Hyeonggon Yoo wrote:
> > On Mon, Jan 24, 2022 at 10:50:05PM +0200, Shay Agroskin wrote:
> >>
> 
> [...]
> 
> >>
> >> I agree that the netdev_alloc_skb_ip_align() can become napi_alloc_skb().
> >> Hyeonggon Yoo, can you please apply this change as well to this patch?
> >>
> > 
> > Okay. I'll update and test it again.
> > 
> > BTW, It seems netdev_alloc_skb_ip_align() is used to make some fields
> > be aligned. It's okay to just ignore this?
> > 
> 
> napi_alloc_skb() adds NET_IP_ALIGN internally, so you end up with the same alignment as before.
> 

Oh I was missing that. I updated the patch and tested again.
Thank you!

> 
> > Thanks,
> > Hyeonggon.
> > 
> >> Thanks,
> >> Shay
> >>
> >>
> >>>>>  	else
> >>>>> -		skb = build_skb(first_frag, ENA_PAGE_SIZE);
> >>>>> +		skb = napi_build_skb(first_frag, ENA_PAGE_SIZE);
> >>>>>  	if (unlikely(!skb)) {
> >>>>>  		ena_increase_stat(&rx_ring->rx_stats.skb_alloc_fail,  1,
> >>>>
> 
