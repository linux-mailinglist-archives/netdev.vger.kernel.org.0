Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCEC5BA1C2
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 22:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiIOUT7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 15 Sep 2022 16:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIOUT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 16:19:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F9715811;
        Thu, 15 Sep 2022 13:19:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oYvKu-0001hI-Jg; Thu, 15 Sep 2022 22:19:48 +0200
Date:   Thu, 15 Sep 2022 22:19:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        syzbot <syzbot+b5d82a651b71cd8a75ab@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix nft_counters_enabled underflow
 at nf_tables_addchain()
Message-ID: <20220915201948.GA4385@breakpoint.cc>
References: <000000000000a9172705e7ffef2e@google.com>
 <8c86a1bb-9c43-b02e-cf93-e098b158ee8c@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <8c86a1bb-9c43-b02e-cf93-e098b158ee8c@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> syzbot is reporting underflow of nft_counters_enabled counter at
> nf_tables_addchain() [1], for commit 43eb8949cfdffa76 ("netfilter:
> nf_tables: do not leave chain stats enabled on error") missed that
> nf_tables_chain_destroy() after nft_basechain_init() in the error path of
> nf_tables_addchain() decrements the counter because nft_basechain_init()
> makes nft_is_base_chain() return true by setting NFT_CHAIN_BASE flag.
> 
> Increment the counter immediately after returning from
> nft_basechain_init().

Applied, thanks.
