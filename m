Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC7A4F6CC6
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbiDFVeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiDFVeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:34:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E4C689A6
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 13:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JD9Jn1tbjwrWYj4MkCvgHPMRNQtMOHR9+0Ty6Z7EDdY=; b=EG4/JxDuv+/yFXRTY12wsTxfy2
        YEjTG5otRWW9duneR59PEKSp/2+36ycl4uO7RfYNwpZKula1P3CNrAIJFWPTHllzw+wv67qoJqsoi
        JGCJ79+D2JjQAdxYNQ/3867GttKoDtDoeyAAJJrPeXeVtY7aXwhHu0TJJ8v8LUcGsCbscdxDPrg3c
        ikJVOQQrjUGmHE2eVD0/Nw46MdeppBShCZy1TpnhjuFMkyFG9GkAlzVd497/cm0+jpDk747gtsOWy
        mGCP6fo0acBWS+WSjZzUdB7QBxdaXugNx8XygQhVqwdzWeD6Hv8IjHR/BmmIvgeImJ4N/UGvmuq3Z
        LJqG1eBQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ncCXS-007unX-SH; Wed, 06 Apr 2022 20:46:02 +0000
Date:   Wed, 6 Apr 2022 13:46:02 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org,
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
Message-ID: <Yk38ClhCaN5FnuDw@bombadil.infradead.org>
References: <20220406124208.3485-1-xiangxia.m.yue@gmail.com>
 <Yk29yO53lSigIbml@bombadil.infradead.org>
 <20220406121611.1791499d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406121611.1791499d@kernel.org>
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

On Wed, Apr 06, 2022 at 12:16:11PM -0700, Jakub Kicinski wrote:
> On Wed, 6 Apr 2022 09:20:24 -0700 Luis Chamberlain wrote:
> > On Wed, Apr 06, 2022 at 08:42:08PM +0800, xiangxia.m.yue@gmail.com wrote:
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > 
> > > This patch introdues the SYSCTL_THREE, and replace the
> > > two, three and long_one to SYSCTL_XXX accordingly.
> > > 
> > >  KUnit:
> > >  [23:03:58] ================ sysctl_test (10 subtests) =================
> > >  [23:03:58] [PASSED] sysctl_test_api_dointvec_null_tbl_data
> > >  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_maxlen_unset
> > >  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_len_is_zero
> > >  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_read_but_position_set
> > >  [23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_positive
> > >  [23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_negative
> > >  [23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_positive
> > >  [23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_negative
> > >  [23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_less_int_min
> > >  [23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_greater_int_max
> > >  [23:03:58] =================== [PASSED] sysctl_test ===================
> > > 
> > >  ./run_kselftest.sh -c sysctl
> > >  ...
> > >  # Running test: sysctl_test_0006 - run #49
> > >  # Checking bitmap handler... ok
> > >  # Wed Mar 16 14:58:41 UTC 2022
> > >  # Running test: sysctl_test_0007 - run #0
> > >  # Boot param test only possible sysctl_test is built-in, not module:
> > >  # CONFIG_TEST_SYSCTL=m
> > >  ok 1 selftests: sysctl: sysctl.sh
> >
> > I can take this through sysctl-next [0] if folks are OK with that. There are
> > quite a bit of changes already queued there for sysctl.
> > 
> > Jakub?
> > 
> > [0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=sysctl-next
> 
> sysctl-next makes a lot of sense, but I'm worried about conflicts.

I can try to deal with them as I can send the pull request to Linus towards
the end of the merge window.

> Would you be able to spin up a stable branch based on -rc1 so we
> can pull it into net-next as well?

Yes, absolutely. Just pushed, but I should note that linux-next already
takes in sysctl-next. And there are non-networking changes that are
in sysctl-next. Does net-next go to Linus or is it just to help with
developers so they get something more close to linux-next but not as
insane?

  Luis
