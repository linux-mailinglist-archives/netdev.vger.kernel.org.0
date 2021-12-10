Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9024701AC
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241879AbhLJNf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:35:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241650AbhLJNf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:35:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639143112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l5sAoIuRwrqpOLkTWcO38tx+jvlOvty7121ooryZ460=;
        b=hTOGfF9oSDi5Q8e+5fHqaILQ9ArV4t1iM+TvT/F0JuVg8DwcmzmY7eNHaCuTn+ugTGCn/k
        UqmH37Mo99kJwwmuyALvceJoDLdkSp36PeGIy/Yh/NRFKv9bTb5ny9OEJZNvvmt92C8WZN
        C389KdYOss4rON4/LsS8L2bJo5CFUMg=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-XwKtCKT-PquumpEAymr9Gg-1; Fri, 10 Dec 2021 08:31:51 -0500
X-MC-Unique: XwKtCKT-PquumpEAymr9Gg-1
Received: by mail-lj1-f197.google.com with SMTP id m20-20020a2eb6d4000000b002219b019ae8so2629607ljo.16
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 05:31:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=l5sAoIuRwrqpOLkTWcO38tx+jvlOvty7121ooryZ460=;
        b=ydqq16gCITRux1AwCbaQmLPwQW+EKM3AIphhPZBe6LmV/16P7nH9TEAyTzum+NtsCq
         Mq3QpoJJC6sqOMr08fcd70YRL+PjOeY2vjj5atb2hREGOUpvAWhabx4EwF/Z8eDLv6TJ
         GyxpCkSSR4TrQJZun5Ym9CIWU4EqFgPEgLD6fKeYM50xgyU3rkbA9aFyCKwAfFkZtacz
         1tCgmKVYlg/NISe1xv7dUymMmms1NPn2RGKojV4Xl/ko6/MmoVIM8yuY2UhA5rcq3pr1
         m630tM2GKjMGv3lLrgYNIN8+JcifX8EHS/+BoXROd5W8ZUE4Nf3zRqOW41dxZ8A9BUNb
         5j4Q==
X-Gm-Message-State: AOAM533u0DaFEyLYRkqBjAVEulCltsxwfrCyzv6mCEJ06TJY4mklI9pM
        tz2azE0ufSatRVqGI8pG2k6eOiTaiI3PZjk22yQ4icUua+O/w4m08ZYlw0OkzS+plscWajPRplG
        0d+HgbrhViQqeJzua
X-Received: by 2002:a05:6512:2111:: with SMTP id q17mr12277309lfr.371.1639143109658;
        Fri, 10 Dec 2021 05:31:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysW1eZdvHlg7c/OsYcsKZD7z8jtHRQrASeKFQqWi/mEk65sVMMaWjbUnS35YwKQwYM7xjjAQ==
X-Received: by 2002:a05:6512:2111:: with SMTP id q17mr12277281lfr.371.1639143109438;
        Fri, 10 Dec 2021 05:31:49 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id k3sm313809ljn.55.2021.12.10.05.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:31:48 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <ccd27f5f-31c4-603f-ea36-ad32b16325b9@redhat.com>
Date:   Fri, 10 Dec 2021 14:31:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v4 net-next 1/9] i40e: don't reserve excessive
 XDP_PACKET_HEADROOM on XSK Rx to skb
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com>
 <20211208140702.642741-2-alexandr.lobakin@intel.com>
 <da317f39-8679-96f7-ec6f-309216b02f33@redhat.com>
 <20211209173307.5003-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211209173307.5003-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/12/2021 18.33, Alexander Lobakin wrote:
> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
> Date: Thu, 9 Dec 2021 09:19:46 +0100
> 
>> On 08/12/2021 15.06, Alexander Lobakin wrote:
>>> {__,}napi_alloc_skb() allocates and reserves additional NET_SKB_PAD
>>> + NET_IP_ALIGN for any skb.
>>> OTOH, i40e_construct_skb_zc() currently allocates and reserves
>>> additional `xdp->data - xdp->data_hard_start`, which is
>>> XDP_PACKET_HEADROOM for XSK frames.
>>> There's no need for that at all as the frame is post-XDP and will
>>> go only to the networking stack core.
>>
>> I disagree with this assumption, that headroom is not needed by netstack.
>> Why "no need for that at all" for netstack?
> 
> napi_alloc_skb() in our particular case will reserve 64 bytes, it is
> sufficient for {TCP,UDP,SCTP,...}/IPv{4,6} etc.

My bad, I misunderstood you. I now see (looking at code) that (as you 
say) 64 bytes of headroom *is* reserved (in bottom of __napi_alloc_skb).
Thus, the SKB *do* have headroom, so this patch should be fine.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Do watch out that 64 bytes is not always enough. Notice the define 
LL_MAX_HEADER and MAX_HEADER in include/linux/netdevice.h (that tries to 
determine worst-case header length) which is above 64 bytes. It is also 
affected by HyperV and WiFi configs.

