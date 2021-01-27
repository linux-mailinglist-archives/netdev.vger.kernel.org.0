Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38723051DD
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 06:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhA0FTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 00:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhA0FDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 00:03:35 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76DFC061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 21:02:52 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id a109so573641otc.1
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 21:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2bbbJFIhJ/FQPW0bB0Ir+3XfSRE5dIb9KqMUr20QvL0=;
        b=HihjmxZo6OO4eD04D6MdLEljF72lIvHZLcR3r3iUHm9ZeGgyzjjNsuXNLDWXAa76Ud
         atPkv3q982NQcqTxmDWQe/5WEdOKN87s6gvaS2+GAvuLPXK8TNvylnbPvKVjDbjXPIpK
         zea2KHY3r2cnZLt8+JayTQLuO2rbZyg7j0EcJXpfMZYApq/W3X0Wk1amqKt4UN0vZ1TT
         BT101jB6IWagfBs771Y18Axy0she547y/o8eA+so2zfFd7ncUoVaYZ1ZZUjSyKTv4Vqr
         tWm3wec+gtj1Udn2dueEx7wC/ZMTzORZ+qX0NlC4NK/LiJ/SdTwFWiJ1mm85Wj8n2U8q
         3umg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2bbbJFIhJ/FQPW0bB0Ir+3XfSRE5dIb9KqMUr20QvL0=;
        b=Gn65+4AG6tzyO2Po6p6sDKkyiPZuSPtOsG3KirzZxRtz4z5IWts1st4DEap+D9BtSQ
         2sxLUZeWpjuF/Q/gefMfysZVAyUygeUjcpXJMYsYixzUoDaWpMRJ9fyaCysV1C59BGgr
         rFvh16r1cygj5YTNxQCPTLwAfWeKIK5QjvDWZhBFGzMrTDGK62vV7HgQ7mUSX8Ij3r6R
         qN+4YyS+tlwRIr/XbR7+RJ2Bl6Ee9ZtEN+gd8RmGuBWw1wzqzXU3FongFitj+uLrv0W4
         j1ifJXtClZh2M+Q/QRdWaBBBhCVbW1AwFpfWkQAeZCbgdOKIzawJ4e648dDqQyBLtehO
         mBqQ==
X-Gm-Message-State: AOAM533OspTupDcNcwIFpIsISD/65TjSJ1Wd9dAv4l5sTP6mNukq7l6Q
        2NQs0no12DpAyXgLjgZCKAA=
X-Google-Smtp-Source: ABdhPJwpuDv8d/GN2gbL5AlS7OsjFAqX6rJFWcqbBbrt+KgbjghqO/WxeRXYu4u+Ytn6eYkFdFEQyA==
X-Received: by 2002:a9d:17aa:: with SMTP id j39mr6539735otj.255.1611723772333;
        Tue, 26 Jan 2021 21:02:52 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:a08d:e5cd:cfb5:2f9])
        by smtp.googlemail.com with ESMTPSA id k3sm237227ooj.33.2021.01.26.21.02.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 21:02:51 -0800 (PST)
Subject: Re: [PATCH net-next 05/10] net: ipv4: Emit notification when fib
 hardware flags are changed
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        roopa@nvidia.com, sharpd@nvidia.com, bpoirier@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-6-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <79194116-6d96-eb13-c845-b5d268df7a82@gmail.com>
Date:   Tue, 26 Jan 2021 22:02:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126132311.3061388-6-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 6:23 AM, Ido Schimmel wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> After installing a route to the kernel, user space receives an
> acknowledgment, which means the route was installed in the kernel,
> but not necessarily in hardware.
> 
> The asynchronous nature of route installation in hardware can lead to a
> routing daemon advertising a route before it was actually installed in
> hardware. This can result in packet loss or mis-routed packets until the
> route is installed in hardware.
> 
> It is also possible for a route already installed in hardware to change
> its action and therefore its flags. For example, a host route that is
> trapping packets can be "promoted" to perform decapsulation following
> the installation of an IPinIP/VXLAN tunnel.
> 
> Emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/RTM_F_TRAP flags
> are changed. The aim is to provide an indication to user-space
> (e.g., routing daemons) about the state of the route in hardware.
> 
> Introduce a sysctl that controls this behavior.
> 
> Keep the default value at 0 (i.e., do not emit notifications) for several
> reasons:
> - Multiple RTM_NEWROUTE notification per-route might confuse existing
>   routing daemons.

are you aware of any routing daemons that are affected? Seems like they
should be able to handle redundant notifications

> - Convergence reasons in routing daemons.
> - The extra notifications will negatively impact the insertion rate.

any numbers on the overhead?

> - Not all users are interested in these notifications.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Acked-by: Roopa Prabhu <roopa@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 20 +++++++++++++++++++
>  include/net/netns/ipv4.h               |  2 ++
>  net/ipv4/af_inet.c                     |  2 ++
>  net/ipv4/fib_trie.c                    | 27 ++++++++++++++++++++++++++
>  net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
>  5 files changed, 60 insertions(+)
> 

