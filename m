Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18015EA0FF
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 12:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbiIZKo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 06:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236477AbiIZKnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 06:43:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0449B1BE87;
        Mon, 26 Sep 2022 03:25:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oclIG-0003na-RG; Mon, 26 Sep 2022 12:24:56 +0200
Date:   Mon, 26 Sep 2022 12:24:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        tgraf@suug.ch, urezki@gmail.com, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Martin Zaharinov <micron10@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH net] rhashtable: fix crash due to mm api change
Message-ID: <20220926102456.GC12777@breakpoint.cc>
References: <20220926083139.48069-1-fw@strlen.de>
 <YzFkt744uWI4y3Sv@gondor.apana.org.au>
 <20220926085018.GA11304@breakpoint.cc>
 <YzFyz5FWn50rhLsH@gondor.apana.org.au>
 <20220926100550.GA12777@breakpoint.cc>
 <YzF8Ju+jXe09f0kj@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzF8Ju+jXe09f0kj@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Only in the case of kvzalloc.  We expect kzalloc to fail, that's
> why it gets NOWARN.  There is no sane reason for kvzalloc to fail
> so it should warn.

To me a WARN() only has one purpose:
It will get reported to mailing list and a developer can use that
to develop a patch/fix.

In memory allocation failure, there is no bug, so nothing to fix,
so WARN is useless.
