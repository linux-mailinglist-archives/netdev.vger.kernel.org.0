Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F45F514F7D
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378475AbiD2PeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 11:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346797AbiD2PeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:34:18 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B870DEC;
        Fri, 29 Apr 2022 08:30:59 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 23TFUoWs012305;
        Fri, 29 Apr 2022 17:30:50 +0200
Date:   Fri, 29 Apr 2022 17:30:50 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net 3/7] tcp: resalt the secret every 10 seconds
Message-ID: <20220429153050.GD11224@1wt.eu>
References: <20220428124001.7428-1-w@1wt.eu>
 <20220428124001.7428-4-w@1wt.eu>
 <CAHmME9pYj85hCS0=37+XsaJSgNXoJ96N6TdiJ9TWBYTXQx0LAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pYj85hCS0=37+XsaJSgNXoJ96N6TdiJ9TWBYTXQx0LAA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 04:48:52PM +0200, Jason A. Donenfeld wrote:
> On Thu, Apr 28, 2022 at 2:40 PM Willy Tarreau <w@1wt.eu> wrote:
> > @@ -101,10 +103,12 @@ u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
> >                 struct in6_addr saddr;
> >                 struct in6_addr daddr;
> >                 __be16 dport;
> > +               unsigned int timeseed;
> 
> Also, does the struct packing (or lack thereof) lead to problems here?
> Uninitialized bytes might not make a stable hash.

Hmmm, I didn't notice, and I think you're right indeed. I did test in IPv6
without noticing any problem but it doesn't mean that the hash is perfectly
stable.

I'll send an update for this one, thank you!
Willy
