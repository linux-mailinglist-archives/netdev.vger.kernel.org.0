Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23A44F7F80
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245466AbiDGMyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiDGMyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:54:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238B4228D01
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 05:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649335924; x=1680871924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CAH+iS7m/12hX7rWL7WkAk1h3vrWAPhBaKGaZKftaWA=;
  b=nF8GIhWxubEX3WPBtouvd5ofvg58z6JWMXuJKPqRxbPVps6PRJTKLzya
   +/X6CrbKe5xFVc363295CpdKcBPXIg4pj6IvQbl8aRy5fVdZbYStScMcm
   hLd8MngzHxSCTLfdc+jCek8evldiQRs+Gt6V2hfuLEhnNc8k5XzeRf7Zt
   9q2101AtAkx9dvA2ltRJ4GQDy+EUdQ7fA5ncfjkzhEpCDdmCZIcg8B95y
   HEGr+kCBRZKL09K8nexewbWwNJkcS1vCL+7q45Px/SvEYXn9WdewWN17b
   3EVFk78wBPU8R+zjWhJLkw7WnN6rd/RYZvrqCHw68qOIP2GYPkZ2vtll4
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10309"; a="241244307"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241244307"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 05:52:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="697783123"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 07 Apr 2022 05:51:59 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 237CpvB1001819;
        Thu, 7 Apr 2022 13:51:57 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     xiangxia.m.yue@gmail.com
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
Date:   Thu,  7 Apr 2022 14:50:06 +0200
Message-Id: <20220407125006.947300-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406124208.3485-1-xiangxia.m.yue@gmail.com>
References: <20220406124208.3485-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Wed,  6 Apr 2022 20:42:08 +0800

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

--- 8< ---

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
>  
>  /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
>  #define SYSCTL_MAXOLDUID		((void *)&sysctl_vals[10])

You forgot to change this one. It should point to 65535, i.e.
&sysctl_vals[11] from your adjusted array.

Maybe it's better to add new constants simply to the tail of the
array? To not adjust it each time and give a room for mistakes.

> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 7123fe7feeac..6ea51c155860 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c

--- 8< ---

> -- 
> 2.27.0

Thanks,
Al
