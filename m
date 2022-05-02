Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C712517188
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 16:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358536AbiEBOa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 10:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347497AbiEBOaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 10:30:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6167EE00A;
        Mon,  2 May 2022 07:26:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C0BBB817D2;
        Mon,  2 May 2022 14:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F292AC385AC;
        Mon,  2 May 2022 14:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651501608;
        bh=vU9/ZvXf6xeGdB3aeZn5fIWE1fBD4DSrUCcKsWDBkR4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hXJnyXBZOmSBYEPLoK1m1HxLmpchOsGVZiQuX+EXeU9Wl20f0TgCRCZDbThs06eN9
         roZqA4uPT2m+uJIOGUtwWiKSwsS3XL4r0GI8GeEc3JyB3ttxscgB6e8UJ7w1LzOgdX
         fBthZAVIzC/UbpRqUja5bphlzN5hyUnsVJ4+1wSjmDZBL+p7fhwMBloMG36lCNMdmL
         W40JjPzEH6YTE4s/06e//+WNY+xldzXmIKuaPznSX7YWNtKFA7zg2tXZxSGNcNddPR
         EuswYSYjb7Ek4NeUH7dsR2HZmVGJmzku6JXBnuhWzk1JBvY94CE7gFi7WAFCLTTT4k
         KGyPHw3ASRkyg==
Date:   Mon, 2 May 2022 07:26:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: Re: [net-next v4 3/3] selftests/sysctl: add sysctl macro test
Message-ID: <20220502072646.7fdc45bc@kernel.org>
In-Reply-To: <CAMDZJNV69HeaBmy1uY7g7R=GKunoV3=bgNd5yfEMKUg_jMPuUg@mail.gmail.com>
References: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
        <20220422070141.39397-4-xiangxia.m.yue@gmail.com>
        <20220425125828.06cc0b51@kernel.org>
        <CAMDZJNV69HeaBmy1uY7g7R=GKunoV3=bgNd5yfEMKUg_jMPuUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 May 2022 11:31:47 +0800 Tonghao Zhang wrote:
>  static int __init test_sysctl_init(void)
>  {
> +       int i;
> +

nit: No empty line needed here.

> +       struct {
> +               int defined;
> +               int wanted;
> +       } match_int[] = {
> +               {.defined = *(int *)SYSCTL_ZERO,        .wanted = 0},
> +               {.defined = *(int *)SYSCTL_ONE,         .wanted = 1},
> +               {.defined = *(int *)SYSCTL_TWO,         .wanted = 2},
> +               {.defined = *(int *)SYSCTL_THREE,       .wanted = 3},
> +               {.defined = *(int *)SYSCTL_FOUR,        .wanted = 4},
> +               {.defined = *(int *)SYSCTL_ONE_HUNDRED, .wanted = 100},
> +               {.defined = *(int *)SYSCTL_TWO_HUNDRED, .wanted = 200},
> +               {.defined = *(int *)SYSCTL_ONE_THOUSAND, .wanted = 1000},
> +               {.defined = *(int *)SYSCTL_THREE_THOUSAND, .wanted = 3000},
> +               {.defined = *(int *)SYSCTL_INT_MAX,     .wanted = INT_MAX},
> +               {.defined = *(int *)SYSCTL_MAXOLDUID,   .wanted = 65535},
> +               {.defined = *(int *)SYSCTL_NEG_ONE,     .wanted = -1},
> +       };
> +
> +       for (i = 0; i < ARRAY_SIZE(match_int); i++)
> +               if (match_int[i].defined != match_int[i].wanted)
> +                       match_int_ok = 0;

That's better, thank you!
