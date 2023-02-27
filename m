Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4693D6A4FAC
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 00:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjB0XcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 18:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjB0XcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 18:32:01 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF6E1C7E0
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 15:31:59 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pWmyJ-0003Sf-U3; Tue, 28 Feb 2023 00:31:55 +0100
Date:   Tue, 28 Feb 2023 00:31:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Alexander Atanasov <alexander.atanasov@virtuozzo.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] netfilter: nf_tables: always synchronize with readers
 before releasing tables
Message-ID: <20230227233155.GA6107@breakpoint.cc>
References: <20230227121720.3775652-1-alexander.atanasov@virtuozzo.com>
 <901abd29-9813-e4fe-c1db-f5273b1c55e3@virtuozzo.com>
 <20230227124402.GA30043@breakpoint.cc>
 <266de015-7712-8672-9ca0-67199817d587@virtuozzo.com>
 <20230227161140.GA31439@breakpoint.cc>
 <28a88519-d0e2-7629-9ed9-3f9c12ca024b@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28a88519-d0e2-7629-9ed9-3f9c12ca024b@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Atanasov <alexander.atanasov@virtuozzo.com> wrote:
> As i said i am still trying to figure out the basechain place,
> where is that synchronize_rcu() call done?

cleanup_net() in net/core/net_namespace.c.

pre_exit handlers run, then synchronize_rcu, then the
normal exit handlers, then exit_batch.

> > Do you see this with current kernels or did the splat happen with
> > an older version?
> 
> It's with a bit older kernel but there is no significant difference
> wrt nf_tables_api code.
> I will prepare a more detailed report for you.

Thanks.
