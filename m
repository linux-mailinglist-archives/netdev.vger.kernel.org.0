Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B935D474DC2
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhLNWPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhLNWPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:15:05 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822EAC061574;
        Tue, 14 Dec 2021 14:15:05 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r11so67253681edd.9;
        Tue, 14 Dec 2021 14:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QMg9BbBy57WYS+abM9yL/9aEfVzdm6T4UDI0fvqY5k8=;
        b=go8P6Cj/ZB0tNsDV62w1ZCXaFwaPx6VAs5THbpyAnOAI5LcqrI+hPFnLPvi/AoHoAg
         jyKZhc23BMTyrVqtwXFMhAk/mQpKMwb3MCG9V96sMdPoH9Rl0jkntP1NxQ05I2ZHS5cX
         qyb+emj0HGvp85rOuxOEn6SahN+60JKRuQBS72OfQQv8Uu91yXIVEceoNnNPaamamTZn
         NZoxzQ1kMMszASe1teJpU0ce9g26ZkvyxElP87Ar3tAlPt3uLwtCPT3n91hwGMPcsAjQ
         LFZSRr97lWwy7jC77Gc5w41dZm9WBFbRTnmocZ8uqiaQiwOgqOoVBK5T3zacq7f1Br/C
         hVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QMg9BbBy57WYS+abM9yL/9aEfVzdm6T4UDI0fvqY5k8=;
        b=CRC9lAej1XJDz99v0tOAqpqvgWJmWPU/lO8dwaoHbmGrymyJICrlMcHpovMyU3RmT3
         9J7+jSsd2d36q5sgbxzMUw676xHKJSFpbk8w5LZJnUyEG7sT2+gBbtSv8+MD17k9dtk5
         aqNsy61EmVRAFewduGAO5ZVoB4xQICNulQ9QjKSqPFuQ7YD98kyLAFHytI8l8L5i5C2w
         qu/dTHJ8DMf3hDzV5CstX8QfwSy8BjswriOhom5D3vOSQnfSJZOOoWek9gGJ9Jee7TB/
         V3esu/KPuMqJnd8TN6X/DW9uWgu2PYmorqGT21K60a6IhlYHLnNR4wv9pbHP8JNUlfSV
         Es8w==
X-Gm-Message-State: AOAM530PPIu/7U6icMBhN3BsHcIZepxUjpj8NRycPq358wdqERk2A5pl
        hkmlcNzOBa9mLLNVYuCckkQ=
X-Google-Smtp-Source: ABdhPJznXJbiV5lt1YHpL8q8rm1X+yc6RppjttY+vv/X4wcgYAhajbs8cvjrAIYyR1ZEF9CIIcymtw==
X-Received: by 2002:a05:6402:14f:: with SMTP id s15mr11414485edu.118.1639520103979;
        Tue, 14 Dec 2021 14:15:03 -0800 (PST)
Received: from ?IPV6:2a02:a03f:c062:a800:5f01:482d:95e2:b968? ([2a02:a03f:c062:a800:5f01:482d:95e2:b968])
        by smtp.gmail.com with ESMTPSA id e12sm26382ejm.135.2021.12.14.14.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 14:15:03 -0800 (PST)
Message-ID: <548feb0a-c066-93fd-c040-558624c8e429@gmail.com>
Date:   Tue, 14 Dec 2021 23:15:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next v2 1/3] net: Parse IPv6 ext headers from TCP
 sock_ops
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, KP Singh <kpsingh@kernel.org>,
        netdev@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Joe Stringer <joe@cilium.io>, David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20211207225635.113904-1-mathjadin@gmail.com>
 <20211209180143.6466e43a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Mathieu Jadin <mathjadin@gmail.com>
In-Reply-To: <20211209180143.6466e43a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/12/2021 03:01, Jakub Kicinski wrote:
> On Tue,  7 Dec 2021 23:56:33 +0100 Mathieu Jadin wrote:
>> Add a flag that, if set, triggers the call of eBPF program for each
>> packet holding an IPv6 extension header. Also add a sock_ops operator
>> that identifies such call.
>>
>> This change uses skb_data and skb_data_end introduced for TCP options'
>> parsing but these pointer cover the IPv6 header and its extension
>> headers.
>>
>> For instance, this change allows to read an eBPF sock_ops program to
>> read complex Segment Routing Headers carrying complex messages in TLV or
>> observing its intermediate segments as soon as they are received.
> 
> Can you share example use cases this opens up?
> 
In the context of IPv6 Segment Routing, Host A could communicate to Host 
B the Segment Routing Header (SRH) that it should use. For instance, a 
server could alleviate the load on its load balancer by asking the other 
host to route data away from the load balancer.
This can be more generic: Host A can have better information about the 
paths to use than the Host B.

Host A could communicate that in two ways:

1) Host B could simply reverse the segment list of an SRH used by Host 
A. This would make Host B follow the same path as Host A.

2) Host A could use a custom TLV in its own SRH to give an SRH to Host B.

For both options, Host B needs another patch to actually set the SRH in 
the same eBPF program. I plan to submit that later.

As for the other IPv6 extension headers, this seemed like a good 
opportunity to enable users to parse their received extension headers in 
eBPF.

Mathieu
