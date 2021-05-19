Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9F33890F1
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354265AbhESOdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354148AbhESOcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:32:41 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F78AC061342;
        Wed, 19 May 2021 07:31:15 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v12so14260323wrq.6;
        Wed, 19 May 2021 07:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/uIuAty7PjxXFt4IM0i+V1A/dMXLvYisaqsv/qbrezE=;
        b=W+/COpqc5fQ8jmoquxbMKC6Ehnr83ZF2XRb52KqwZYN7L9L0nJoj8xNIabgDHYxZU0
         F6iZlhockfTfVVlBkn4ud9d63iT87RLJhl0WQV+OQVc0Z9lsHJAAuhWChvkIKFxDEhLd
         Xoa9cvo6JnHyS6iHtnXsHKHp+ZdMGxHsp/sajjaTvDNFprJ9bSOJGFyOiuU3cfWjhy2C
         YskgE3TmZMU/r5Xd90LTUeyiE4CVC0A4tBp0aekOUo+UNVY56u8W9gQ6fkhcO9VfRGSx
         GzoIvK4VI42X9hGqwFgF2D24x6CNomcKUJUvFaU7WURaHypRYJQvhdgxRr44O6trhOlA
         fB2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/uIuAty7PjxXFt4IM0i+V1A/dMXLvYisaqsv/qbrezE=;
        b=OTKeX8ewGBBAefsl2ZM7+uk0IgoWihAVVH0uR2IHXDTN+91ccXgB3OAt1hWa80ZGrx
         m5Ta4wq5pZbd/wiz7NS2MPHbyTxc0ZnSiTAuoT3p8HFPmjzVmQ7eUy9e1ne58rDTpQWb
         GuO25X45RcSDWwxHodNOuft5/VWhDmL8CVgc4KzIWB9FIPRmoDJNzRQaA3jbZSt1r+7w
         SKyMNh48HLuXOhZGgyKpJ7BlC2Lu/JZjpO4gvaApLgGeQjatfJdddFNFu91a20xk/v3+
         Zc7ulqr1BBtmcG2sqcq/OFuvxBW3MVYKayY9SywIq8+Vs9IFh9MASRPl7jSD6w/xPpGI
         N/Iw==
X-Gm-Message-State: AOAM5305jymLU/upyPckTMHPiiApfhoPQpe7Tdgy19uvbMWwvNou4fGO
        zGVIEfvmrhNg//gQX3Y7n5NiFgvu5bQ=
X-Google-Smtp-Source: ABdhPJyXuJnhzN0eu3ei8cGd0y+n4IYYl4B39s4zlfx5aYYQ7hSLjMfpxGTJMNX9DJK1bCo8vkyTLw==
X-Received: by 2002:a5d:508e:: with SMTP id a14mr14900327wrt.88.1621434674015;
        Wed, 19 May 2021 07:31:14 -0700 (PDT)
Received: from [10.0.0.2] ([37.172.163.196])
        by smtp.gmail.com with ESMTPSA id c6sm7693369wru.50.2021.05.19.07.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 07:31:12 -0700 (PDT)
Subject: Re: [Bloat] virtio_net: BQL?
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Dave Taht <dave.taht@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        bloat <bloat@lists.bufferbloat.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
 <CAA93jw6LUAnWZj0b5FvefpDKUyd6cajCNLoJ6OKrwbu-V_ffrA@mail.gmail.com>
 <CA+FuTSf0Af2RXEG=rCthNNEb5mwKTG37gpEBBZU16qKkvmF=qw@mail.gmail.com>
 <CAA93jw7Vr_pFMsPCrPadqaLGu0BdC-wtCmW2iyHFkHERkaiyWQ@mail.gmail.com>
 <20210517160036.4093d3f2@hermes.local>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a11eee78-b2a1-3dbc-4821-b5f4bfaae819@gmail.com>
Date:   Wed, 19 May 2021 16:31:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210517160036.4093d3f2@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/21 1:00 AM, Stephen Hemminger wrote:

> 
> The Azure network driver (netvsc) also does not have BQL. Several years ago
> I tried adding it but it benchmarked worse and there is the added complexity
> of handling the accelerated networking VF path.
> 


Note that NIC with many TX queues make BQL almost useless, only adding extra
overhead.

We should probably make BQL something that can be manually turned on/off.
