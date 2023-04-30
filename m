Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626B56F2813
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 10:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjD3IU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 04:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjD3IU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 04:20:26 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7396D26A5;
        Sun, 30 Apr 2023 01:20:24 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 5160E5C0101;
        Sun, 30 Apr 2023 04:20:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 30 Apr 2023 04:20:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1682842821; x=1682929221; bh=FtoIgx0IqE4PIcUscvctGI7W1hQLnKYUYIe
        vTAA9fVk=; b=jz9kukz3E/TCjbKIb4KphaN8Ifhn8QMeqX4lzgM6Wvv6wo+VvY2
        qhJaDGqfC8Y/rpMqNlIR9mAA7GLBsb/7NXcUvrqIOk2sCQZqZc4EfSHVGyeJG8Hf
        UpOQvAFxOBjM1ZPVo+oS1abkLcswk6LPb1xiMolwa/jxUAySWuvzXyRbpeE3bpiM
        0nJbZ3XmISTyfTu7BnBsCE36SW/ZbT5QXWtfvUYrt3uuHKoFLFMVqbcfev5fIcz5
        dCbWJQ9xX4dYtteULC2TOOJEb4Ud3je67ENV9RCPic0sZvO7NO7iiUI53cvccuc3
        NsCts6pH5dYt776u/X42fbFQxOGqSIFbKdA==
X-ME-Sender: <xms:xCROZC4KTCfAFNg7pL7WuY0DayBFydQJt3q5NUz6-5ldoT5aGCn6EA>
    <xme:xCROZL7F45oCPqqu6F-y7LwZrRl8vWjZGtlxpRZHtpgZMo64tp5cZrU-aaVsKFK9H
    YqqjKG6MvtLNvY>
X-ME-Received: <xmr:xCROZBc-LJ20h9ekR1tkdtQkNncruItMaKL098cn0GJ9Sjimgzd764nFqjQd>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedvvddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekgefggefhuedvgeettdegvdeuvdfhudejvddvjeetledvuedtheehleel
    hffhudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:xCROZPKFth_CkhvjzQrewk7C9lnJiRANdAZvvnkhuTjJtkY4bVGGTw>
    <xmx:xCROZGI4ahCa36pGPSe4s1BphUCgATlZHzw515GqEyXivZmFkQXhJg>
    <xmx:xCROZAyqIOMqvBD0yL1bMVXzchsAXts-gVgAhtXf-VFQaMPonv2dvw>
    <xmx:xSROZIi0S5VW-87rI5OCFZJpLrvjU98XkBMDTXF0UL7FPfdm8-ymqA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Apr 2023 04:20:19 -0400 (EDT)
Date:   Sun, 30 Apr 2023 11:20:16 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdevsim: fib: Make use of rhashtable_iter
Message-ID: <ZE4kwMjQlcgrxuY7@shredder>
References: <20230425144556.98799-1-cai.huoqing@linux.dev>
 <ZEjw7XXFro6zYYXz@gondor.apana.org.au>
 <ZEviO+NPFP/IoiO2@chq-MS-7D45>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZEviO+NPFP/IoiO2@chq-MS-7D45>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 11:11:55PM +0800, Cai Huoqing wrote:
> On 26 4月 23 17:37:49, Herbert Xu wrote:
> > Cai Huoqing <cai.huoqing@linux.dev> wrote:
> > > Iterating 'fib_rt_ht' by rhashtable_walk_next and rhashtable_iter directly
> > > instead of using list_for_each, because each entry of fib_rt_ht can be
> > > found by rhashtable API. And remove fib_rt_list.
> > > 
> > > Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> > > ---
> > > drivers/net/netdevsim/fib.c | 37 ++++++++++++++++++-------------------
> > > 1 file changed, 18 insertions(+), 19 deletions(-)
> > 
> > What is the rationale for this patch? Are you trying to save
> > memory?
> Hi 
> Thanks for your reply,
> 
> I think not need to use two structs to link fib_rt node, 
> fib_rt_list is redundant.

There are cases where we want to iterate over the objects without
destroying the hashtable itself.

> 
> Thanks,
> Cai-
> 
> > 
> > > @@ -1099,9 +1090,12 @@ static void nsim_fib_dump_inconsistent(struct notifier_block *nb)
> > >        /* The notifier block is still not registered, so we do not need to
> > >         * take any locks here.
> > >         */
> > > -       list_for_each_entry_safe(fib_rt, fib_rt_tmp, &data->fib_rt_list, list) {
> > > -               rhashtable_remove_fast(&data->fib_rt_ht, &fib_rt->ht_node,
> > > +       rhashtable_walk_enter(&data->fib_rt_ht, &hti);
> > > +       rhashtable_walk_start(&hti);
> > > +       while ((pos = rhashtable_walk_next(&hti))) {
> > > +               rhashtable_remove_fast(&data->fib_rt_ht, hti.p,
> > >                                       nsim_fib_rt_ht_params);
> > > +               fib_rt = rhashtable_walk_peek(&hti);
> > >                nsim_fib_rt_free(fib_rt, data);
> > >        }
> > 
> > In general rhashtable walks are not stable.  You may miss entries
> > or see entries twice.  They should be avoided unless absolutely
> > necessary.
> Agree, but how about using rhashtable_free_and_destroy here
> instead of rhashtable_walk_next in this patch.

We don't want to destroy the hashtable in this case, only free the
objects.
