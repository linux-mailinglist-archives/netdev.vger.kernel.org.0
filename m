Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AA74F684E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239586AbiDFRzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239719AbiDFRz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:55:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3674F16D8D0
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 09:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zyo69A9+lvVrYf5IO94+XBfaUPR+bOiJT21rp8Zrys0=; b=F0TMS1qWFqaTDE8cs+mFYo3mDE
        kWGSaNfBtJJVw0vF7mbBxPC13iB191V/1n2Z1LBFLSQj5Fn5IrroaX58bXsZEJH8A1K4rYjk2kTbt
        /NwLtyuqrRW2yhodj1uLuV73Lq6FSt4RYL9VSpPIIG2dwJKAwCxpCcUI4cSARhaT5jTjESb3vWjZX
        iMNZ48OZ+sTkeZqk5+Jl487qHZQu1HE2OHHfxKNtSmQFNa6YuzKEroXJTNubRgvEtfzLsmhlnb/LW
        InOyvipPBL0Ay+CB09Jw+ONtLNtUry6l1T9YAmCi9Ggm6d5cVpwXw0q7lPyUb60eGWZReFI7jHEcT
        ivGJxgPg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nc8OP-007AXI-01; Wed, 06 Apr 2022 16:20:25 +0000
Date:   Wed, 6 Apr 2022 09:20:24 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     xiangxia.m.yue@gmail.com, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Kees Cook <keescook@chromium.org>,
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
Message-ID: <Yk29yO53lSigIbml@bombadil.infradead.org>
References: <20220406124208.3485-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406124208.3485-1-xiangxia.m.yue@gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 08:42:08PM +0800, xiangxia.m.yue@gmail.com wrote:
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
> 
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Iurii Zaikin <yzaikin@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Akhmat Karakotov <hmukos@yandex-team.ru>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

I can take this through sysctl-next [0] if folks are OK with that. There are
quite a bit of changes already queued there for sysctl.

Jakub?

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=sysctl-next

  Luis
