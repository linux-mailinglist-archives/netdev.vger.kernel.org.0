Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417F0483A6E
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 03:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiADCBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 21:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiADCBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 21:01:35 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83186C061761;
        Mon,  3 Jan 2022 18:01:35 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id o7so40624340ioo.9;
        Mon, 03 Jan 2022 18:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Y8wJ+6Hc060UZZZN5D+qY5rqy6SgLLcG5cbwkD9/0Ps=;
        b=F9AMwjN15gZmCBk9yZH7TB9zlQ62c8e138Hpm+V3jKCaguL46Ww0aPwXTtaTMuwc6o
         V/uH782DDfu/qe8sbkA0zJkWoc6gZzB2orrSOlw46J76yxmG/0GfHveWE8D1AR+zqXaJ
         eOfQvMJoWVD9hv/Ub6CBb4y7zOAguZF2Ggpc+O8USvX5ITDGXTlUxC+WxYYtbTWpTe+v
         Ksz/Hk4LUu6zRXUNoLeDTILIlCT5Efa3B5FrKUNDquXvVm55XBOkE9XZwvy/K3zyx/xm
         i+ZGPCwOxgMg1eOunqrUZUOvv97TWk/MWrJeNxTRE+LHITJ45tZRf/CUQCB7yjj8uIHT
         UjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y8wJ+6Hc060UZZZN5D+qY5rqy6SgLLcG5cbwkD9/0Ps=;
        b=apbyAq+SlkQ85tofff2Jb9wEwhGl/2awRuieftjZ2K947+lGJC/ljq93jFxtSuBuSL
         MLfd3OSzWdGht5XTjousrBsTBYrLXXNhLiLwTMuv3sggG8cD3tsONCfhiGfSENJRAwBg
         7fR8f+P/mx4ky04GH1i2ZLY4A7OLhVwUNfdf06dboZCX0oYGI/N8qjP4OgVpajniQA4I
         SjNeuaKwkwQLOJaxViXFcPycSyvnYs/auzm3utUNzgpyKWaHk4gC23zqiOA6gGmWulxO
         GfMTZnqly0paVY8Q6yvEczLHjAmN/T1Qk4Bpzl9iUNoy+y4r0DBrMj1FDzBHMIwJAcDn
         TYXQ==
X-Gm-Message-State: AOAM53227wPqy7t85THg1fTVvzew4boQzLj77XV+hfM92Yk1TM42LvcP
        nQdsOjoenCKk4LdYIkM4EUI=
X-Google-Smtp-Source: ABdhPJxi6XwpS0nEmpGYCIS9Fm+n8lH1DYPtlkJfR0pYKwMKAf0+DWtS17alOK5ycXlr4cW7e5pcdA==
X-Received: by 2002:a05:6602:2cce:: with SMTP id j14mr22687615iow.111.1641261694963;
        Mon, 03 Jan 2022 18:01:34 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id q17sm18633273ilj.40.2022.01.03.18.01.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 18:01:34 -0800 (PST)
Message-ID: <810dd93c-c6a2-6f8b-beb9-a2119c1876fb@gmail.com>
Date:   Mon, 3 Jan 2022 19:01:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 net-next 0/3] net: skb: introduce
 kfree_skb_with_reason() and use it for tcp and udp
Content-Language: en-US
To:     Cong Wang <xiyou.wangcong@gmail.com>, menglong8.dong@gmail.com
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
References: <20211230093240.1125937-1-imagedong@tencent.com>
 <YdOnTcSBq8z961da@pop-os.localdomain>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YdOnTcSBq8z961da@pop-os.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/22 6:47 PM, Cong Wang wrote:
> On Thu, Dec 30, 2021 at 05:32:37PM +0800, menglong8.dong@gmail.com wrote:
>> From: Menglong Dong <imagedong@tencent.com>
>>
>> In this series patch, the interface kfree_skb_with_reason() is
>> introduced(), which is used to collect skb drop reason, and pass
>> it to 'kfree_skb' tracepoint. Therefor, 'drop_monitor' or eBPF is
>> able to monitor abnormal skb with detail reason.
>>
> 
> We already something close, __dev_kfree_skb_any(). Can't we unify
> all of these?

Specifically?

The 'reason' passed around by those is either SKB_REASON_CONSUMED or
SKB_REASON_DROPPED and is used to call kfree_skb vs consume_skb. i.e.,
this is unrelated to this patch set and goal.

> 
> 
>> In fact, this series patches are out of the intelligence of David
>> and Steve, I'm just a truck man :/
>>
> 
> I think there was another discussion before yours, which I got involved
> as well.
> 
>> Previous discussion is here:
>>
>> https://lore.kernel.org/netdev/20211118105752.1d46e990@gandalf.local.home/
>> https://lore.kernel.org/netdev/67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com/
>>
>> In the first patch, kfree_skb_with_reason() is introduced and
>> the 'reason' field is added to 'kfree_skb' tracepoint. In the
>> second patch, 'kfree_skb()' in replaced with 'kfree_skb_with_reason()'
>> in tcp_v4_rcv(). In the third patch, 'kfree_skb_with_reason()' is
>> used in __udp4_lib_rcv().
>>
> 
> I don't follow all the discussions here, but IIRC it would be nice
> if we can provide the SNMP stat code (for instance, TCP_MIB_CSUMERRORS) to
> user-space, because those stats are already exposed to user-space, so
> you don't have to invent new ones.

Those SNMP macros are not unique and can not be fed into a generic
kfree_skb_reason function.

