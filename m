Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C10F5090E4
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 21:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381994AbiDTUAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382006AbiDTUAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:00:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5E34924D
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 12:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b/p/Pjr5ZywCNRBqubhs8uK52pTLU/Q0ZMynjR0pwhI=; b=xiPcXnF2h5/X9LrJIi3nOEb7hu
        Zi9mqyZh6s9RbnMDR61YWHMPPrSy5sRe+VleUOeWrCLCPDnMURKQkea2Wh3HvrdXxGkiYVEW7VuPK
        zQ5E5XI5b4gkmYya/zjQ2UUIo8JU2JFJoGgl9ptSW1RPJymy8n2CZJSRyfyXuPFaB1zWcuiclxrru
        185qn4IJuyEegx/EBCpBeFzkwIMt8ur9smFW31n9k4HkWyOjSYUSa/y3SWIKNrcI6LOL59vkF8DhU
        UOJgzWJAnEDPT943XWzJAji2o0qt/prkbYG2x+YOnXF5tSr5hbofNVEMwpacNi/6d9F5x/mejpXaN
        uknQXv5Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nhGRI-00AGT4-M0; Wed, 20 Apr 2022 19:56:36 +0000
Date:   Wed, 20 Apr 2022 12:56:36 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: Re: [PATCH v3 2/2] net: sysctl: introduce sysctl SYSCTL_THREE
Message-ID: <YmBldHBBaff4IAK7@bombadil.infradead.org>
References: <20220415163912.26530-1-xiangxia.m.yue@gmail.com>
 <20220415163912.26530-3-xiangxia.m.yue@gmail.com>
 <CAMDZJNXb8bwXbbSoum3488c+zYA_4Ow3o5dXiWvquywnBtNg=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMDZJNXb8bwXbbSoum3488c+zYA_4Ow3o5dXiWvquywnBtNg=A@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 08:43:14PM +0800, Tonghao Zhang wrote:
> On Sat, Apr 16, 2022 at 12:40 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patch introdues the SYSCTL_THREE.
> Hi Luis, Jakub
> any thoughts? I have fixed v2.
> > KUnit:
> > [00:10:14] ================ sysctl_test (10 subtests) =================
> > [00:10:14] [PASSED] sysctl_test_api_dointvec_null_tbl_data
> > [00:10:14] [PASSED] sysctl_test_api_dointvec_table_maxlen_unset
> > [00:10:14] [PASSED] sysctl_test_api_dointvec_table_len_is_zero
> > [00:10:14] [PASSED] sysctl_test_api_dointvec_table_read_but_position_set
> > [00:10:14] [PASSED] sysctl_test_dointvec_read_happy_single_positive
> > [00:10:14] [PASSED] sysctl_test_dointvec_read_happy_single_negative
> > [00:10:14] [PASSED] sysctl_test_dointvec_write_happy_single_positive
> > [00:10:14] [PASSED] sysctl_test_dointvec_write_happy_single_negative
> > [00:10:14] [PASSED] sysctl_test_api_dointvec_write_single_less_int_min
> > [00:10:14] [PASSED] sysctl_test_api_dointvec_write_single_greater_int_max
> > [00:10:14] =================== [PASSED] sysctl_test ===================
> >
> > ./run_kselftest.sh -c sysctl
> > ...
> > ok 1 selftests: sysctl: sysctl.sh
> >
> > Cc: Luis Chamberlain <mcgrof@kernel.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Iurii Zaikin <yzaikin@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: Simon Horman <horms@verge.net.au>
> > Cc: Julian Anastasov <ja@ssi.bg>
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Cc: Florian Westphal <fw@strlen.de>
> > Cc: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Cc: Akhmat Karakotov <hmukos@yandex-team.ru>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

It would be good for you to also have a separate patch which extends
the selftest for sysctl which tests that each of the values always
matches, I thought we had that test already, if not one needs to be
added for this. That should be the first patch. The second one would
add this as you are here in this patch, and the last one adds the new
SYSCTL_THREE to the selftest.

Otherwise looks good to me.

Happy to route this via sysclt-next if Jacub is OK with that.

  Luis
