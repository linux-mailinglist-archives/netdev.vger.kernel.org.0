Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F240E50E9D5
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 21:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245076AbiDYUBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 16:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbiDYUBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 16:01:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FA472474;
        Mon, 25 Apr 2022 12:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69DEDB81A55;
        Mon, 25 Apr 2022 19:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45820C385A7;
        Mon, 25 Apr 2022 19:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650916710;
        bh=bHUpwy8UU25MKlqBugqGgSiVIho/pbqfPZjoPG2H7qI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uSJUUJc/J69QQS1DrhObK1uCZyDaECp1yJ/O15Ro48bnH25fYrYU/BhKbXKHZovYS
         NRdRemObOqvzvyuqgVlrdiKMZNX7R9zOwi1laWLRsOUFDcZjM04mO8/KhesjewDwYx
         HaiMMsgb/1PDMrkT4e2YHF/GCCGqFn0fj+jv68Cikk4WrCwhnnfgKPeJKYhSRJP4O5
         Ydca9BorDiGOknrdjJ6+QG1Cmi8nvkF+16Oqc5GlFUhSbQ2A8kKzoI+SLIn29kaI1R
         03V133SsInFnnoeTL5SXUItpQZUigNCHa+/SBDAw8UKcdA9TxI+FP+XX2BzWk+MtEc
         KPbkn69q4O6dw==
Date:   Mon, 25 Apr 2022 12:58:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
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
Message-ID: <20220425125828.06cc0b51@kernel.org>
In-Reply-To: <20220422070141.39397-4-xiangxia.m.yue@gmail.com>
References: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
        <20220422070141.39397-4-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Apr 2022 15:01:41 +0800 xiangxia.m.yue@gmail.com wrote:
>  static int __init test_sysctl_init(void)
>  {
> +	test_data.match_int[0] = *(int *)SYSCTL_ZERO,
> +	test_data.match_int[1] = *(int *)SYSCTL_ONE,
> +	test_data.match_int[2] = *(int *)SYSCTL_TWO,
> +	test_data.match_int[3] = *(int *)SYSCTL_THREE,
> +	test_data.match_int[4] = *(int *)SYSCTL_FOUR,
> +	test_data.match_int[5] = *(int *)SYSCTL_ONE_HUNDRED,
> +	test_data.match_int[6] = *(int *)SYSCTL_TWO_HUNDRED,
> +	test_data.match_int[7] = *(int *)SYSCTL_ONE_THOUSAND,
> +	test_data.match_int[8] = *(int *)SYSCTL_THREE_THOUSAND,
> +	test_data.match_int[9] = *(int *)SYSCTL_INT_MAX,
> +	test_data.match_int[10] = *(int *)SYSCTL_MAXOLDUID,
> +	test_data.match_int[11] = *(int *)SYSCTL_NEG_ONE,

> +	local VALUES=(0 1 2 3 4 100 200 1000 3000 $INT_MAX 65535 -1)

How does this test work? Am I reading it right that it checks if this
bash array is in sync with the kernel code?

I'd be better if we were checking the values of the constants against
literals / defines.
