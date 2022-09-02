Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633215ABAB8
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 00:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiIBWQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 18:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiIBWQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 18:16:36 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4561AA032A
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 15:16:35 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id a9-20020a17090a8c0900b001fff9a99c0fso1401000pjo.5
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 15:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=Bh3U2E64C9QgQ7uAnXLjMJWJpvMMy/IcNnabGflMPaI=;
        b=Sz4k555vieOfiRqNHm2fa7Zrha640Ob2D9ONPRQCeuVt+m9s3O8/Wt43T6AU8SE/SY
         v/EGgDMcVGV9nQNnIE6cobRVvD+hTAUy1tZQ9Xk7Yf4ETk/fWudxzsdv8HdM1JACSk3g
         pM9ei7VPh9K1QoON/Zwe9GHoqrd2hOSnQ/srmIIv1swV8bT5F1o9puZASPjW6/laNpBP
         W6w3ja+ro0cQ2QrWDgCSRp0lNccaeMxtjvLFMIznTcrbC2vAMXt/NBwiqFfa/ZbW5Guw
         fPLg8ClctTyK66N1jZFiBLzY3WFaFCvjbzqmmj1R2/rxLsXHdeWOvkVonhUiTjj/X8bu
         4Www==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=Bh3U2E64C9QgQ7uAnXLjMJWJpvMMy/IcNnabGflMPaI=;
        b=rzNIKp8otk6fm7sY4WuZiHspySZwX7LkG1NBTDfDjrFg/BDSINHkkb6x4K5dc5vYn3
         bTW10VFC6IJ3URJDPEHkIpQrk2Y7PteqUCiZDIwVHI0Y3nvmx7viV0GNdj1iVHiAssvX
         eFGdn6lRWREvb33cXCv0g21M2cH++gMAHW5x1JbqtBBuHDkg+YVOBrDPAfYeancwkVXN
         NAAXQDtpXnac8cnyLiXz9/hEEY5RZ9zWdIg4mlsBuhVCbkH4fcM+APvbXqJdNZf3zrwd
         nlGyW/ZsLFvB6a4PHEzRqW71YNxnpQtDBQX3uZubINwh7Smb7nKlao+CD/+bEnn49NA3
         avqw==
X-Gm-Message-State: ACgBeo2nArGbmkhoXBGW9+XFQqi7nvIfgqOryKoo06hIPz9OEb1xfkD7
        vj8cP14VyBQ3DSKZ6s1mR3j8OnE=
X-Google-Smtp-Source: AA6agR6/G1ix2sGJUJSuRYZeQSXlLouOinEnX5a7t0AflyvR0shyKG5oczRBr9Ppu8tCoJ9lhMTlnTA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr733pje.0.1662156994353; Fri, 02 Sep 2022
 15:16:34 -0700 (PDT)
Date:   Fri, 2 Sep 2022 15:16:32 -0700
In-Reply-To: <20220902002750.2887415-1-kafai@fb.com>
Mime-Version: 1.0
References: <20220902002750.2887415-1-kafai@fb.com>
Message-ID: <YxKAwN/PgQE4pAon@google.com>
Subject: Re: [PATCH v2 bpf-next 00/17] bpf: net: Remove duplicated code from bpf_getsockopt()
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/01, Martin KaFai Lau wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>

> The earlier commits [0] removed duplicated code from bpf_setsockopt().
> This series is to remove duplicated code from bpf_getsockopt().

> Unlike the setsockopt() which had already changed to take
> the sockptr_t argument, the same has not been done to
> getsockopt().  This is the extra step being done in this
> series.

> [0]: https://lore.kernel.org/all/20220817061704.4174272-1-kafai@fb.com/

> v2:
> - The previous v2 did not reach the list. It is a resend.
> - Add comments on bpf_getsockopt() should not free
>    the saved_syn (Stanislav)
> - Explicitly null-terminate the tcp-cc name (Stanislav)

Looks great!

Reviewed-by: Stanislav Fomichev <sdf@google.com>

> Martin KaFai Lau (17):
>    net: Change sock_getsockopt() to take the sk ptr instead of the sock
>      ptr
>    bpf: net: Change sk_getsockopt() to take the sockptr_t argument
>    bpf: net: Avoid sk_getsockopt() taking sk lock when called from bpf
>    bpf: net: Change do_tcp_getsockopt() to take the sockptr_t argument
>    bpf: net: Avoid do_tcp_getsockopt() taking sk lock when called from
>      bpf
>    bpf: net: Change do_ip_getsockopt() to take the sockptr_t argument
>    bpf: net: Avoid do_ip_getsockopt() taking sk lock when called from bpf
>    net: Remove unused flags argument from do_ipv6_getsockopt
>    net: Add a len argument to compat_ipv6_get_msfilter()
>    bpf: net: Change do_ipv6_getsockopt() to take the sockptr_t argument
>    bpf: net: Avoid do_ipv6_getsockopt() taking sk lock when called from
>      bpf
>    bpf: Embed kernel CONFIG check into the if statement in bpf_getsockopt
>    bpf: Change bpf_getsockopt(SOL_SOCKET) to reuse sk_getsockopt()
>    bpf: Change bpf_getsockopt(SOL_TCP) to reuse do_tcp_getsockopt()
>    bpf: Change bpf_getsockopt(SOL_IP) to reuse do_ip_getsockopt()
>    bpf: Change bpf_getsockopt(SOL_IPV6) to reuse do_ipv6_getsockopt()
>    selftest/bpf: Add test for bpf_getsockopt()

>   include/linux/filter.h                        |   3 +-
>   include/linux/igmp.h                          |   4 +-
>   include/linux/mroute.h                        |   6 +-
>   include/linux/mroute6.h                       |   4 +-
>   include/linux/sockptr.h                       |   5 +
>   include/net/ip.h                              |   2 +
>   include/net/ipv6.h                            |   4 +-
>   include/net/ipv6_stubs.h                      |   2 +
>   include/net/sock.h                            |   2 +
>   include/net/tcp.h                             |   2 +
>   net/core/filter.c                             | 220 ++++++++----------
>   net/core/sock.c                               |  51 ++--
>   net/ipv4/igmp.c                               |  22 +-
>   net/ipv4/ip_sockglue.c                        |  98 ++++----
>   net/ipv4/ipmr.c                               |   9 +-
>   net/ipv4/tcp.c                                |  92 ++++----
>   net/ipv6/af_inet6.c                           |   1 +
>   net/ipv6/ip6mr.c                              |  10 +-
>   net/ipv6/ipv6_sockglue.c                      |  95 ++++----
>   net/ipv6/mcast.c                              |   8 +-
>   .../selftests/bpf/progs/bpf_tracing_net.h     |   1 +
>   .../selftests/bpf/progs/setget_sockopt.c      | 148 ++++--------
>   22 files changed, 379 insertions(+), 410 deletions(-)

> --
> 2.30.2

