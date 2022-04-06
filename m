Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3424F6BE4
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiDFVAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbiDFU7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:59:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EF025667A
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 12:25:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5047B82545
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 19:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A5AC385A5;
        Wed,  6 Apr 2022 19:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649273130;
        bh=+10T+NJYtGfrIzyfPXBpZ5HpH+9UZJw9zLl5M43EIWA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r5QeBgHG2cidhh54ThjJ/oDuO2iSDfxPVLVMm9KaG2Tm1tx6ympbzISWv0GtPsJBW
         T37EDmHn/oVBygsZhgTYYsbbLpWjTEXm23kCxBJKGQlyw30putERKVqBhAuD79e2QQ
         fZ9KlXmnViBcXt9XkUXCRP0QBM0ztOC72OACGm/KgX1J5LqijJjR+DC9Oso1TgGn0A
         qDQzsv1MQNp5n6lG3U8M5AuyZh3hfBHFSK9Ih96aUAccX3WKqdXCvx2agurrZsMMey
         FcCFE2+StjXMqNJUgj+Rfq/AlXQv7vyJZ6SA+DkI35tx3uot3zTpYIxDOW8uaEqFIu
         UlBEYcWA4Qlug==
Date:   Wed, 6 Apr 2022 12:25:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: Re: [net-next RESEND v2] net: core: use shared sysctl macro
Message-ID: <20220406122528.1cb94bfb@kernel.org>
In-Reply-To: <20220406124208.3485-1-xiangxia.m.yue@gmail.com>
References: <20220406124208.3485-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Apr 2022 20:42:08 +0800 xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> This patch introdues the SYSCTL_THREE, and replace the
> two, three and long_one to SYSCTL_XXX accordingly.
> 
>  KUnit:
>  [23:03:58] ================ sysctl_test (10 subtests) =================
>  [23:03:58] [PASSED] sysctl_test_api_dointvec_null_tbl_data
>  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_maxlen_unset
>  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_len_is_zero
>  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_read_but_position_set
>  [23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_positive
>  [23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_negative
>  [23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_positive
>  [23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_negative
>  [23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_less_int_min
>  [23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_greater_int_max
>  [23:03:58] =================== [PASSED] sysctl_test ===================
> 
>  ./run_kselftest.sh -c sysctl
>  ...
>  # Running test: sysctl_test_0006 - run #49
>  # Checking bitmap handler... ok
>  # Wed Mar 16 14:58:41 UTC 2022
>  # Running test: sysctl_test_0007 - run #0
>  # Boot param test only possible sysctl_test is built-in, not module:
>  # CONFIG_TEST_SYSCTL=m
>  ok 1 selftests: sysctl: sysctl.sh

> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 7d9cfc730bd4..0bdd9249666b 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -26,7 +26,7 @@ static const struct file_operations proc_sys_dir_file_operations;
>  static const struct inode_operations proc_sys_dir_operations;
>  
>  /* shared constants to be used in various sysctls */
> -const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MAX, 65535 };
> +const int sysctl_vals[] = { -1, 0, 1, 2, 3, 4, 100, 200, 1000, 3000, INT_MAX, 65535 };
>  EXPORT_SYMBOL(sysctl_vals);
>  
>  const unsigned long sysctl_long_vals[] = { 0, 1, LONG_MAX };
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 6353d6db69b2..b2ac6542455f 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -42,12 +42,13 @@ struct ctl_dir;
>  #define SYSCTL_ZERO			((void *)&sysctl_vals[1])
>  #define SYSCTL_ONE			((void *)&sysctl_vals[2])
>  #define SYSCTL_TWO			((void *)&sysctl_vals[3])
> -#define SYSCTL_FOUR			((void *)&sysctl_vals[4])

nit: I vote we move the -1 later in the array, so that for the first
5 "natural" numbers the index matches the value.

> -#define SYSCTL_ONE_HUNDRED		((void *)&sysctl_vals[5])
> -#define SYSCTL_TWO_HUNDRED		((void *)&sysctl_vals[6])
> -#define SYSCTL_ONE_THOUSAND		((void *)&sysctl_vals[7])
> -#define SYSCTL_THREE_THOUSAND		((void *)&sysctl_vals[8])
> -#define SYSCTL_INT_MAX			((void *)&sysctl_vals[9])
> +#define SYSCTL_THREE			((void *)&sysctl_vals[4])
> +#define SYSCTL_FOUR			((void *)&sysctl_vals[5])
> +#define SYSCTL_ONE_HUNDRED		((void *)&sysctl_vals[6])
> +#define SYSCTL_TWO_HUNDRED		((void *)&sysctl_vals[7])
> +#define SYSCTL_ONE_THOUSAND		((void *)&sysctl_vals[8])
> +#define SYSCTL_THREE_THOUSAND		((void *)&sysctl_vals[9])
> +#define SYSCTL_INT_MAX			((void *)&sysctl_vals[10])

> @@ -388,7 +384,7 @@ static struct ctl_table net_core_table[] = {
>  		.extra2		= SYSCTL_ONE,
>  # else
>  		.extra1		= SYSCTL_ZERO,
> -		.extra2		= &two,
> +		.extra2		= SYSCTL_TWO,
>  # endif
>  	},
>  # ifdef CONFIG_HAVE_EBPF_JIT
> @@ -399,7 +395,7 @@ static struct ctl_table net_core_table[] = {
>  		.mode		= 0600,
>  		.proc_handler	= proc_dointvec_minmax_bpf_restricted,
>  		.extra1		= SYSCTL_ZERO,
> -		.extra2		= &two,
> +		.extra2		= SYSCTL_TWO,
>  	},
>  	{
>  		.procname	= "bpf_jit_kallsyms",
> @@ -417,7 +413,7 @@ static struct ctl_table net_core_table[] = {
>  		.maxlen		= sizeof(long),
>  		.mode		= 0600,
>  		.proc_handler	= proc_dolongvec_minmax_bpf_restricted,
> -		.extra1		= &long_one,
> +		.extra1		= SYSCTL_LONG_ONE,

Hm, looks like most of the conversions are not to the newly added value
of three. Feels like those should be a separate patch.
