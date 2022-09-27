Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5492B5EBB17
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 09:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiI0HEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 03:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiI0HEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 03:04:45 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FEE659F3;
        Tue, 27 Sep 2022 00:04:42 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1od4de-008szV-AY; Tue, 27 Sep 2022 17:04:19 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 27 Sep 2022 15:04:18 +0800
Date:   Tue, 27 Sep 2022 15:04:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, tgraf@suug.ch, urezki@gmail.com,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Martin Zaharinov <micron10@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH net] rhashtable: fix crash due to mm api change
Message-ID: <YzKgcvHhjU7B5EOj@gondor.apana.org.au>
References: <20220926083139.48069-1-fw@strlen.de>
 <YzFkt744uWI4y3Sv@gondor.apana.org.au>
 <20220926085018.GA11304@breakpoint.cc>
 <YzFyz5FWn50rhLsH@gondor.apana.org.au>
 <20220926100550.GA12777@breakpoint.cc>
 <YzF8Ju+jXe09f0kj@gondor.apana.org.au>
 <20220926102456.GC12777@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926102456.GC12777@breakpoint.cc>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 12:24:56PM +0200, Florian Westphal wrote:
.
> In memory allocation failure, there is no bug, so nothing to fix,
> so WARN is useless.

It depends on why it failed.  If it failed because we're asking
for something that simply can't be fulfilled then sure.  But if
we're asking for something sane and kvzalloc still failed it then
we should know about it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
