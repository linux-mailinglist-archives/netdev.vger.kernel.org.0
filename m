Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC01136FCE7
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 16:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhD3Ovb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 10:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhD3Ova (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 10:51:30 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196AFC06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 07:50:42 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id w3so105705531ejc.4
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 07:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gUJ9FjOlvILDnVEQgM4Qbo77GgjrqL2BnpZ7tigxVZ0=;
        b=02NjxWl1uAiB2g4T571RZEMwkOCQKfYKrRqNaBtjlhHE6I1FnZPZmD9I6THnLBpmyr
         oFobaPK6IC31wBg397dTT5Ps8uQ/pIJswFwPerWhFxR78+lqNliPcbVUeISUAul+mNUV
         rlHWVkT5LhSlzRZEt1SMSxNhkvWpbBHUrUxzMm5wHHNRH+036dRiG6Fd7UCE6hTPCV7H
         97FQWd0ubsOoEI7lx1FuTfOUA7KnWarxKTgy8mEBjWzIXHQ8wKI+gOsW9EOemeLfkMuu
         0FPukCpSFeWamv/ydodo66xIXiksXqDGyBaBcZ4yDlKrZdJh94yU7QIUb42fVJLhW1Rq
         XMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gUJ9FjOlvILDnVEQgM4Qbo77GgjrqL2BnpZ7tigxVZ0=;
        b=V9Fx/xFQ/YazAj3k4BudVayYmrKWh3dSI+XXIHNpFtZPR4LufYNmHfykINVT1J6Xp0
         35w7xSBPtJzqCo7+wJZAdQTxvzgtsQVIRRYsR7nQOtD3lrkHOAJym88fCcEAMjlASRXp
         0OCG4c8i0aZATpcwYNd3vsZPWr+NG81twrlevAVnesRI9wtuRN9axyNxda/zQ0ucGm/c
         WX9ZT27+phdJXuG5WPT9xuxyP/B4ACJAsf+odfpLOWuAiK9aL8QBXqC9qYLeET7LSpul
         CxWRJBMPbk2jmxITmqrrHRO238sKrSCEfxQ84O4SgxOhx+vCsfVRy5HOXysnOhuJEsq9
         3VMQ==
X-Gm-Message-State: AOAM533Xi3mjEww7K0neoMyO33uYBHd9kSWC+fzaANjbj5rcaq3cCuJ3
        L+rMkaMQtA7BDHlbEXil/bsHhThi9v3dLap9/l8=
X-Google-Smtp-Source: ABdhPJw819dLYiycp1o390l//8YnEK3p7mcejJzC1czwPpI4E/6+E93csILPyOhmQCj5HOuukod1Fw==
X-Received: by 2002:a17:906:f41:: with SMTP id h1mr4872178ejj.399.1619794240719;
        Fri, 30 Apr 2021 07:50:40 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:b92a:fcbd:82a0:9dba])
        by smtp.gmail.com with ESMTPSA id w19sm1348926edd.52.2021.04.30.07.50.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 07:50:40 -0700 (PDT)
Subject: Re: [PATCH iproute2] mptcp: make sure flag signal is set when add
 addr with port
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>
Cc:     mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Jianguo Wu <wujianguo106@163.com>, netdev@vger.kernel.org
References: <ea7d8eb1-5484-09dc-aa53-cf839b93bc73@163.com>
 <6ec00dc5-de95-566d-f292-d43a3f5cf6cb@tessares.net>
 <0544c818-1537-7a7e-0a86-8d0c28aa4797@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <0005ef27-7304-152b-58e8-b5e0cc87b492@tessares.net>
Date:   Fri, 30 Apr 2021 16:50:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <0544c818-1537-7a7e-0a86-8d0c28aa4797@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/04/2021 16:27, David Ahern wrote:
> On 4/30/21 3:35 AM, Matthieu Baerts wrote:
>> On 23/04/2021 12:24, Jianguo Wu wrote:
>>> From: Jianguo Wu <wujianguo@chinatelecom.cn>
>>>
>>> When add address with port, it is mean to send an ADD_ADDR to remote,
>>> so it must have flag signal set.
>>>
>>> Fixes: 42fbca91cd61 ("mptcp: add support for port based endpoint")
>>> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
>>
>> I see on patchwork[1] that this patch is marked as "Accepted". But I
>> cannot find it in 'main' branches from iproute2-next.git and
>> iproute2.git repos.
>>
>> Did I miss it somewhere?
> 
> no idea what happened
> 
>>
>> If it is not too late, here is a ACK from MPTCP team:
>>
>> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
>>
> 
> I'll add the Ack and apply.

Thank you for your help!

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
