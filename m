Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8BC332FAB
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 21:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhCIUM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 15:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbhCIUMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 15:12:50 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F408C06174A;
        Tue,  9 Mar 2021 12:12:50 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id u14so18251672wri.3;
        Tue, 09 Mar 2021 12:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CFqGt3jkXZWIpeSMgqBoUJV7sayMwNCm6SroBnyaLxw=;
        b=KC4YlFaBaLPzN/5WQuWHRRyupm9jGoq2boh5da5Bo/+Q6E62iBwwLigjgH7T7ozJv6
         HAgCkagZAmLOdKHu3QFwI2x6vtGqarMhR5vUQhgdTNAedGhhji1+55uB/lva4woRhezx
         DIZNWGxACL3APb2O9Ry43i1j2vSjPp/s5JctsUSTYJi8eUxSQ3Nf1CFMF1ny8hjcZDxh
         vfsz4wzZudpZGNZSO9DOtwQanEhFmN2KrETb04BbieCagkdtMN46e7uI/xJc13Wthe9Z
         3pN2FVkab3bLJkT0TfDv8k1ujthc9HSj3V4vH/FY87nopZcsiuvUBHpQFdhOtCPArYSg
         sBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CFqGt3jkXZWIpeSMgqBoUJV7sayMwNCm6SroBnyaLxw=;
        b=r0mSGM75lUG20w9WXcWaJCd5036dz9r9v5gNBDUd2bbEbcTwNo26capzZ7yxG9nHTP
         KKJAxnBtqA25cI+ICdv79GDiiXw1TWn4Za+RCGA3l/fhyCMKk29fMWjNDCPIWRvvMMA+
         tvSZ7WyPWEKAt79y2NFBlWaz4PutMywm8Y5HoCVFryZe0y5QrlQzkLs/UjDpCVyedTqv
         Z4ahqJlthCkshjiXxV8jupndWjgYklHhRhIIRCripM7GPQhwfESDxVG12sGom/0ogFRK
         hJS3F4tDLLAyGB9AYUFtRiASHL7sJco5/iOgKOGOcXUHY9ZUr5dMjQ60FlwaLEcGk8Im
         WChw==
X-Gm-Message-State: AOAM532YZ4oMMmKf8SCW5UACHrkxSMOTU6cnZtvRZJ4fK+jwJAcyicjD
        A2lWctheAXLjv7tKUqeN2TpKkDTX+3s=
X-Google-Smtp-Source: ABdhPJwRQmBDVKHfa1Nq1G6tPhDLrHlte8cEjBeWw5umdv4Hs3H35orOUrZ6A+GWBAUVarwcjvvyUQ==
X-Received: by 2002:a5d:5744:: with SMTP id q4mr31082584wrw.390.1615320768518;
        Tue, 09 Mar 2021 12:12:48 -0800 (PST)
Received: from [192.168.1.101] ([37.165.49.26])
        by smtp.gmail.com with ESMTPSA id r11sm26965907wrm.26.2021.03.09.12.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 12:12:47 -0800 (PST)
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
To:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <203c49a3-6dd8-105e-e12a-0e15da0d4df7@gmail.com>
Date:   Tue, 9 Mar 2021 21:12:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210309044349.6605-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/21 5:43 AM, Tony Lu wrote:
> There are lots of net namespaces on the host runs containers like k8s.
> It is very common to see the same interface names among different net
> namespaces, such as eth0. It is not possible to distinguish them without
> net namespace inode.
> 
> This adds net namespace inode for all net_dev events, help us
> distinguish between different net devices.
> 
> Output:
>   <idle>-0       [006] ..s.   133.306989: net_dev_xmit: net_inum=4026531992 dev=eth0 skbaddr=0000000011a87c68 len=54 rc=0
> 
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> ---
>

There was a proposal from Lorenz to use netns cookies (SO_NETNS_COOKIE) instead.

They have a guarantee of being not reused.

After 3d368ab87cf6681f9 ("net: initialize net->net_cookie at netns setup")
net->net_cookie is directly available.


