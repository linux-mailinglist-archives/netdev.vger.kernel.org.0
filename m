Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452A2E8F5D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbfJ2Sf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:35:59 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39204 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfJ2Sf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:35:59 -0400
Received: by mail-lj1-f194.google.com with SMTP id y3so16431235ljj.6
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 11:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VVzOWaW+8WScZs4n+Dg4lETcm9GAwtrOVevdTx2yiNw=;
        b=HKsjqS2IAM573Lz8ROLM6jfS3knA1pQ01xLeIp0aBxdvWQ3mG/tT4NDr9gfClzXGRE
         1XbK1E6SADvZEn87iaBrrsojdnnf3XWdqvrOjzsZvhHfM1XMQgARJHMNRySqyBCF54Fw
         uRTMQ7TxhcGdShK8QiEyXimlf+yK8At44wDag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VVzOWaW+8WScZs4n+Dg4lETcm9GAwtrOVevdTx2yiNw=;
        b=fS/IP4DunWo62zakHUI4StSkhcJQ3DxdjfX2E+Ysp5d78mHvO63kM2UOQGjKFclLf8
         xFm7kl5gpHwe9FE9qss80EA8d8AiVt2R+h4/xR85TbEFfXmCLdsz+828sX/YavK8lvXq
         04N3e5/iJ/0FI7DiAfbXpEU/wuQhcVpWmP/RsYP9egNeYtWzvTFRWHvQZXzwX83POfFO
         NguD+QyAQyiIrTR1XZrBccwOBeRluKNSXgWNhzKLRIFzuA0yEl3ufsdV7cCqQ2GUN+vJ
         6eRI3rhUkfKUr3OTfdl5u3QFDalYzYte8ywSYh/kSLAOMGvSavonlhTfCurUTWE9O8n+
         j3jA==
X-Gm-Message-State: APjAAAUEYrDH21GlFQ99gVy6iHOUOhBulMrBqbTGmZejQlAjz+AYdBPT
        4SxgtU1fG7ipslAGq47gBHNMuw==
X-Google-Smtp-Source: APXvYqws9Kvxp5AtGZPOyHwWm0t5qtGaVHPqspQuzOKUufQe6npJGSXYa12tKIEgABu5BSjWbLnPug==
X-Received: by 2002:a2e:9595:: with SMTP id w21mr3649227ljh.181.1572374157687;
        Tue, 29 Oct 2019 11:35:57 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id u11sm3665585ljo.17.2019.10.29.11.35.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2019 11:35:57 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/4] bonding: balance ICMP echoes in layer3+4
 mode
To:     Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
References: <20191029135053.10055-1-mcroce@redhat.com>
 <20191029135053.10055-5-mcroce@redhat.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <5be14e4e-807f-486d-d11a-3113901e72fe@cumulusnetworks.com>
Date:   Tue, 29 Oct 2019 20:35:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191029135053.10055-5-mcroce@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/10/2019 15:50, Matteo Croce wrote:
> The bonding uses the L4 ports to balance flows between slaves. As the ICMP
> protocol has no ports, those packets are sent all to the same device:
> 
>     # tcpdump -qltnni veth0 ip |sed 's/^/0: /' &
>     # tcpdump -qltnni veth1 ip |sed 's/^/1: /' &
>     # ping -qc1 192.168.0.2
>     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 315, seq 1, length 64
>     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 315, seq 1, length 64
>     # ping -qc1 192.168.0.2
>     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 316, seq 1, length 64
>     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 316, seq 1, length 64
>     # ping -qc1 192.168.0.2
>     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 317, seq 1, length 64
>     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 317, seq 1, length 64
> 
> But some ICMP packets have an Identifier field which is
> used to match packets within sessions, let's use this value in the hash
> function to balance these packets between bond slaves:
> 
>     # ping -qc1 192.168.0.2
>     0: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 303, seq 1, length 64
>     0: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 303, seq 1, length 64
>     # ping -qc1 192.168.0.2
>     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 304, seq 1, length 64
>     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 304, seq 1, length 64
> 
> Aso, let's use a flow_dissector_key which defines FLOW_DISSECTOR_KEY_ICMP,

Also ?

> so we can balance pings encapsulated in a tunnel when using mode encap3+4:
> 
>     # ping -q 192.168.1.2 -c1
>     0: IP 192.168.0.1 > 192.168.0.2: GREv0, length 102: IP 192.168.1.1 > 192.168.1.2: ICMP echo request, id 585, seq 1, length 64
>     0: IP 192.168.0.2 > 192.168.0.1: GREv0, length 102: IP 192.168.1.2 > 192.168.1.1: ICMP echo reply, id 585, seq 1, length 64
>     # ping -q 192.168.1.2 -c1
>     1: IP 192.168.0.1 > 192.168.0.2: GREv0, length 102: IP 192.168.1.1 > 192.168.1.2: ICMP echo request, id 586, seq 1, length 64
>     1: IP 192.168.0.2 > 192.168.0.1: GREv0, length 102: IP 192.168.1.2 > 192.168.1.1: ICMP echo reply, id 586, seq 1, length 64
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  drivers/net/bonding/bond_main.c | 77 ++++++++++++++++++++++++++++++---
>  1 file changed, 70 insertions(+), 7 deletions(-)
> 

Hi Matteo,
Wouldn't it be more useful and simpler to use some field to choose the slave (override the hash
completely) in a deterministic way from user-space ?
For example the mark can be interpreted as a slave id in the bonding (should be
optional, to avoid breaking existing setups). ping already supports -m and
anything else can set it, this way it can be used to do monitoring for a specific
slave with any protocol and would be a much simpler change.
User-space can then implement any logic for the monitoring case and as a minor bonus
can monitor the slaves in parallel. And the opposite as well - if people don't want
these balanced for some reason, they wouldn't enable it.

Or maybe I've misunderstood why this change is needed. :)
It would actually be nice to include the use-case which brought this on
in the commit message.

Cheers,
 Nik

