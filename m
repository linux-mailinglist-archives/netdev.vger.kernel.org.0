Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC7B5BF802
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiIUHos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIUHoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:44:46 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF56A65B6;
        Wed, 21 Sep 2022 00:44:43 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 77A2B201E2;
        Wed, 21 Sep 2022 09:44:41 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EY6uRd3Yvca6; Wed, 21 Sep 2022 09:44:40 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EFA0020189;
        Wed, 21 Sep 2022 09:44:40 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id DFCFC80004A;
        Wed, 21 Sep 2022 09:44:40 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 09:44:40 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 09:44:40 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 16C8C31829EC; Wed, 21 Sep 2022 09:44:40 +0200 (CEST)
Date:   Wed, 21 Sep 2022 09:44:40 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Li Zhong <floridsleeves@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <f.fainelli@gmail.com>, <pabeni@redhat.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <davem@davemloft.net>, <klassert@kernel.org>
Subject: Re: [PATCH v1] drivers/net/ethernet/3com: check the return value of
 vortex_up()
Message-ID: <20220921074440.GA2950045@gauss3.secunet.de>
References: <20220919073631.1574577-1-floridsleeves@gmail.com>
 <20220920100157.GV2950045@gauss3.secunet.de>
 <CAMEuxRo9oy4uc3XK7wQ26zgwmpwwp+iOT_47OsshAv-94tGgtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAMEuxRo9oy4uc3XK7wQ26zgwmpwwp+iOT_47OsshAv-94tGgtw@mail.gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 09:15:35AM -0700, Li Zhong wrote:
> On Tue, Sep 20, 2022 at 3:02 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > On Mon, Sep 19, 2022 at 12:36:31AM -0700, Li Zhong wrote:
> > > Check the return value of vortex_up(), which could be error code when
> > > the rx ring is not full.
> > >
> > > Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> > > ---
> > >  drivers/net/ethernet/3com/3c59x.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
> > > index ccf07667aa5e..7806c5f60ac8 100644
> > > --- a/drivers/net/ethernet/3com/3c59x.c
> > > +++ b/drivers/net/ethernet/3com/3c59x.c
> > > @@ -1942,6 +1942,7 @@ vortex_error(struct net_device *dev, int status)
> > >       void __iomem *ioaddr = vp->ioaddr;
> > >       int do_tx_reset = 0, reset_mask = 0;
> > >       unsigned char tx_status = 0;
> > > +     int err;
> > >
> > >       if (vortex_debug > 2) {
> > >               pr_err("%s: vortex_error(), status=0x%x\n", dev->name, status);
> > > @@ -2016,7 +2017,9 @@ vortex_error(struct net_device *dev, int status)
> > >                       /* Must not enter D3 or we can't legally issue the reset! */
> > >                       vortex_down(dev, 0);
> > >                       issue_and_wait(dev, TotalReset | 0xff);
> > > -                     vortex_up(dev);         /* AKPM: bug.  vortex_up() assumes that the rx ring is full. It may not be. */
> > > +                     err = vortex_up(dev);
> > > +                     if (err)
> > > +                             return;
> >
> > Why does that fix the bug mentioned in the above comment?
> >
> 
> Since the bug is an unchecked error

No, it is not. It is completely pointless to check the error value here.

> we detect it with static analysis and
> validate it's a bug by the comment we see above the code.

This code is from the nineties, so it is unfixed for more
then 20 years. Do you really think Andrew Morton would have
added this comment if the fix is that easy?

