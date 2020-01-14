Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C817513ADDD
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 16:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgANPnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 10:43:09 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33261 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgANPnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 10:43:08 -0500
Received: by mail-il1-f194.google.com with SMTP id v15so11916629iln.0
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 07:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GIfIPU4Hm1zdh9Ilk0yt5smZLFcWtrMT+sQQS4661no=;
        b=qmLAPNr8o72/G4NPryzd358n7v5gCPUxFb/a4E/qoNvQghLVpdCe65fPptzm5KIPWM
         kXIWOlZwSXEf9hzDNvRsvYqOfItNDJ80h4uAG/zwAsrzCw50KOfZGKpGU+UNOMOx843F
         4tvjbWy5mz75mI1LJ/JhAuOTTO5dBtnF3u+/O037u6sq1uhrXgmqcPYGhXX2be5toco0
         a4IfwIit29vkA4LBdhtpOA4CBc+azlUnfNSZbG0KxrbsyS8Lc2uqQXRRo/MNXl3Hjw8V
         nRifml981TwdzaIVPO+88Tj9H4qtA5b+br21FH70u6thedHZcwsBRTOenSjXOi4ECGcA
         Vj9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GIfIPU4Hm1zdh9Ilk0yt5smZLFcWtrMT+sQQS4661no=;
        b=IU+UtfVIQbLm4o5sWNQCX3gFMavXUApW09ylMydwFmXaIEQ8hftRpEirRncWt/obW3
         BS5KSH6tg4RcgyowbijUB2UI37IAjJujCE0zEMGKDsm9CapBr7T84tTSxqscnlEmk0VE
         oVu2rtQNBxAuiYxzpfOQ+zVflLP3ltz5uv/m3bTFMmmAAnv7gusCOPMFHYtS9MErUC7p
         NdW0g41cqwyC8M6yiodc7lDha9J3D/IJo7DQF6YYktbOdtcb69eTpBuP22GPoII8izwY
         QmupCQ4TvZSlbVf/Cq/8WiFSE9ZNXjmT3pzX3m/byEGnX6ASP4Fqu55YBjX7BaDhXlny
         bWiw==
X-Gm-Message-State: APjAAAUVycx4rL7RiFLE381EfXgA3PUtVneTaoMl4HuNTrBaPtfQN13l
        5/uIlYXC4NpSola6iaeDAl8=
X-Google-Smtp-Source: APXvYqyAd+yWZIAWT/AUfmmcfYjfSRFuTxsqFaFG+S8pLEGT/3sdq+JE7LH7+y/vN0VMwAQ31m1aUA==
X-Received: by 2002:a92:b11:: with SMTP id b17mr3990638ilf.202.1579016588273;
        Tue, 14 Jan 2020 07:43:08 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:ad53:3eb0:98a5:6359? ([2601:282:800:7a:ad53:3eb0:98a5:6359])
        by smtp.googlemail.com with ESMTPSA id i83sm4970800ilf.65.2020.01.14.07.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 07:43:07 -0800 (PST)
Subject: Re: [PATCH net-next v2 03/10] ipv4: Add "offload" and "trap"
 indications to routes
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20200114112318.876378-1-idosch@idosch.org>
 <20200114112318.876378-4-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7a2082c1-b6a5-cba2-00aa-329a813b8343@gmail.com>
Date:   Tue, 14 Jan 2020 08:43:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200114112318.876378-4-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/20 4:23 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> When performing L3 offload, routes and nexthops are usually programmed
> into two different tables in the underlying device. Therefore, the fact
> that a nexthop resides in hardware does not necessarily mean that all
> the associated routes also reside in hardware and vice-versa.
> 
> While the kernel can signal to user space the presence of a nexthop in
> hardware (via 'RTNH_F_OFFLOAD'), it does not have a corresponding flag
> for routes. In addition, the fact that a route resides in hardware does
> not necessarily mean that the traffic is offloaded. For example,
> unreachable routes (i.e., 'RTN_UNREACHABLE') are programmed to trap
> packets to the CPU so that the kernel will be able to generate the
> appropriate ICMP error packet.
> 
> This patch adds an "offload" and "trap" indications to IPv4 routes, so
> that users will have better visibility into the offload process.
> 
> 'struct fib_alias' is extended with two new fields that indicate if the
> route resides in hardware or not and if it is offloading traffic from
> the kernel or trapping packets to it. Note that the new fields are added
> in the 6 bytes hole and therefore the struct still fits in a single
> cache line [1].
> 
> Capable drivers are expected to invoke fib_alias_hw_flags_set() with the
> route's key in order to set the flags.
> 
> The indications are dumped to user space via a new flags (i.e.,
> 'RTM_F_OFFLOAD' and 'RTM_F_TRAP') in the 'rtm_flags' field in the
> ancillary header.
> 

...

> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  include/net/ip_fib.h           |  4 +++
>  include/uapi/linux/rtnetlink.h |  2 ++
>  net/ipv4/fib_lookup.h          |  3 ++
>  net/ipv4/fib_semantics.c       |  7 +++++
>  net/ipv4/fib_trie.c            | 52 ++++++++++++++++++++++++++++++++++
>  net/ipv4/route.c               | 19 +++++++++++++
>  6 files changed, 87 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


