Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8422C3637
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 02:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgKYBYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 20:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKYBYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 20:24:41 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6904C0613D4;
        Tue, 24 Nov 2020 17:24:40 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id m9so498711iox.10;
        Tue, 24 Nov 2020 17:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zLMcdMXtgswh8+3VyJ8PCQJkVpapnbwSPCQAbYUycdA=;
        b=Oe1TN0c5f+pWuDX0LLRx63slCp0Hvsgqr9XVN0bfjbYZYnwZJTC13ivE6+HwcocpUS
         5J+AkscuzsAXfH7WY5/yR2Mmo6E4b/H+GKJiHZoDHFJYpNxzmqc8XI1LLF8SF4RZe7l6
         ZCtk/VybAWeiPZCngzpnkyv+izjDBQ22ujzU61qt55+t77xyQxPjw5GXo3A0gQuONC0H
         C6UONmUbL6hn+yTX3JnazzkkLZwGxdn/wHMcIo9LiEoz0fv85Hr10YGwv0HV8mOE36aa
         2Uz2wSFGvQkk/bwICOnHrCkHgAbnjQ+rsriMd2vFEcWqkPn1DrrZuBU2Dmb666lohHh9
         1sMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zLMcdMXtgswh8+3VyJ8PCQJkVpapnbwSPCQAbYUycdA=;
        b=IpCDrjs4Adtc6OKt6NhkNykqzCC8VvGl7fROjq8p4Dg0TOlgpEleWKA3ggN79H3h6v
         MCOrhNli7m4Y8VcOy6PtqCcXG54925qHwd/I5NBzNuUwbd442KUDKCpH4xprl+Ziwhok
         hNk7DPoCvGqweTq7hdQ9H1MGl0Wqq+SEUqZetO/k7AIV6btvtUG+ZfgN9+yfENiu8Vxv
         zyVDnxeHoFJYrW8P2T6z4QoXlCAFVfjT1LizGWOLqz1Xb+7uiEqoS6Npslad3gAp4m6s
         y/tCzhrfxn2s4c7xYO1OfpMBh1HCFTzPnBGjx4jDlrO221EAylAb6yKbL8GQsFUxHUVG
         CtIA==
X-Gm-Message-State: AOAM533euAdQeHdqStcpxUQ49wfiidJdBcFGktNbBTt4z1yl/SgDopmM
        OOH6jO4zXqqgEjpWuHF5wGw=
X-Google-Smtp-Source: ABdhPJxhzNwmgB3DuuK59xtzhntGDj4QrTLfv/jbbmIgjuIiAE6BhBzz8Tn/U+SuK784l+q3E1vp1g==
X-Received: by 2002:a5d:9b8f:: with SMTP id r15mr875851iom.35.1606267480083;
        Tue, 24 Nov 2020 17:24:40 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:b920:c7b8:6a02:a6c0])
        by smtp.googlemail.com with ESMTPSA id y12sm259051ill.88.2020.11.24.17.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 17:24:39 -0800 (PST)
Subject: Re: [net-next v3 0/8] seg6: add support for SRv6 End.DT4/DT6 behavior
To:     Jakub Kicinski <kuba@kernel.org>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
 <20201124154904.0699f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3dd23494-d6ae-1c09-acb3-c6c2b2ef93d8@gmail.com>
Date:   Tue, 24 Nov 2020 18:24:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201124154904.0699f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/20 4:49 PM, Jakub Kicinski wrote:
> 
> LGTM! Please address the nit and repost without the iproute2 patch.
> Mixing the iproute2 patch in has confused patchwork:
> 
> https://patchwork.kernel.org/project/netdevbpf/list/?series=389667&state=*
> 
> Note how it thinks that the iproute2 patch is part of the kernel
> series. This build bot-y thing is pretty new. I'll add a suggestion 
> to our process documentation not to mix patches.

That was me - I suggested doing that. I have done that in the past as
has several other people. I don't recall DaveM having a problem, so
maybe it is the new patchworks that is not liking it?

> 
>> I would like to thank David Ahern for his support during the development of
>> this patchset.
> 
> Should I take this to mean that David has review the code off-list?
> 

reviews and general guidance.
