Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D274467C67
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 18:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382350AbhLCRXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 12:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353361AbhLCRXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 12:23:30 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55B8C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 09:20:05 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id t23so7120970oiw.3
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 09:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=t6Kejxpt6kTY3shk2FPYEbpH9MbZcBIb6C56YxhPUb4=;
        b=mDcvGbn4+0DUUUJ51R7DcZra4mIuVV80rongfmwdtP4yn1veW5B3fLNmJUvjJAAIcV
         FCIsGPwOMkJBGzR58yLrugV8w6ae42t+kjOG+dJ3vUgWgrktMLuxbgI6XABvBZZxVZSj
         voBnFYnAaPLOaAXFcFnEXMHf70+9Kb3sk+tDcoeSo4dvB9GgiPWm/NWaP8DiYbJl/wID
         o0STBMWksGdT3ksjmCeNI5jE4sz1U3LflKPDW/fbiT7v4GKx73Ao+DYSH9hzwAHdsEg5
         96ClRpBHuXmJg2S6jngo4YRpvm3h++Jh9wZ9k4mKKJzl261kzR8vOWfdap6df8ms+4/v
         OfJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t6Kejxpt6kTY3shk2FPYEbpH9MbZcBIb6C56YxhPUb4=;
        b=iOeNQBOL7SMcYK1bGmMt4Tc2FMF8nFAdBEDNvonrkPEyudiHs8Hos0gfq5ivU8RTEB
         GTFEEOA4WDXd6XjWh17TZK+0kAY9G7o5PIMmhi4AJrgLJDczF9ja25qKcM6+EL2Raf1G
         mwqjV1NqdIE9JX8lrNzjVsBZXFe9Klw/zVgbJa6hcX489sR9ID6y/Z0nxZot5Kp3YUlS
         J0VVd5tzApZqVH/pismddjyUiiJG7Q3d7X7t3Q+pMiElBPV1GWzyskvJZLhdGwa5Md9x
         bUX8856OXRYEtiC04tTIn/uv598o1XJNiLe99qsPKZcOKiY5NNO1zbXI8eDZAB6rwtfZ
         i7Bg==
X-Gm-Message-State: AOAM533z5plwcEWCPzQzMOBKdcJpp4d4OFuqLGOvLeR8LqRn2TDAbNOS
        RBt3VUTbJJ5eOScy/tFk8QU=
X-Google-Smtp-Source: ABdhPJxmKjDe6DSvu4kd+NMj5Vlg0CR9D3WfkgUSbs5g3pPo1bX6lt/cajEhUoVACj3GD/HPynTOzg==
X-Received: by 2002:aca:280f:: with SMTP id 15mr10942207oix.129.1638552005248;
        Fri, 03 Dec 2021 09:20:05 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id r25sm720082ote.73.2021.12.03.09.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 09:20:05 -0800 (PST)
Message-ID: <765eb3d8-7dfa-2b28-e276-fac88453bc72@gmail.com>
Date:   Fri, 3 Dec 2021 10:20:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH iproute2-next] tc: Add support for ce_threshold_value/mask
 in fq_codel
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
References: <20211123201327.86219-1-toke@redhat.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211123201327.86219-1-toke@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/21 1:13 PM, Toke Høiland-Jørgensen wrote:
> Commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking for subset
> of traffic") added support in fq_codel for setting a value and mask that
> will be applied to the diffserv/ECN byte to turn on the ce_threshold
> feature for a subset of traffic.
> 
> This adds support to tc for setting these values. The parameter is
> called ce_threshold_selector and takes a value followed by a
> slash-separated mask. Some examples:
> 
>  # apply ce_threshold to ECT(1) traffic
>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x1/0x3
> 
>  # apply ce_threshold to ECN-capable traffic marked as diffserv AF22
>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x50/0xfc
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  tc/q_fq_codel.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)

please re-send with an update to
