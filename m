Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5A45BC4E6
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 11:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiISJB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 05:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiISJBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 05:01:52 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DDE1EACE
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 02:01:51 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id w20so15249698ply.12
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 02:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ZyBh2EWWrvGOUGs/CdnvlxE/mZhbjQ0C7IY5yfchJ18=;
        b=Se1edUQHinkb2VrSPj9AEaOkI3qX3bnTI1MH2p01G2eLzH37jO8CEmwls4M9ZyJHKU
         a+VMhdcy9CKTJtwByAKk6lvAikCojy0OvpEOp7yg2kXsW68EiiWYbz/L1fF5z4cFMBjs
         6ANh/V9N7RMF/s5uRyO/2tBx946Y16C0t68z+/e9vOrclcGxdcu8iR69ITTS/DetUWUD
         cRAlWN2ZITVV5/Wf289b5MpBQMwiuH08cZG4qzpyqiV5kGmnlt1Ik4ItVG4+az+DQ8SX
         Xqobtt0BuNB2dE6sV08XYkm9QmAbLrVhDcVuDot+jJa5FD3gFzmAFbelwJ0JqZm7PL5f
         VZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ZyBh2EWWrvGOUGs/CdnvlxE/mZhbjQ0C7IY5yfchJ18=;
        b=kYqxzYtmBoguRyRtR4QgXjByW+t3098mFo+dBeTQ5rj0w0kRSwiEZ91RYAru7RKS2Z
         cH1pTrspahZ7RAUrcLFQdnzwHHcJgDkzh6lRXcBR3+PnA2CNenDH6btEwlFhEKDbd2wP
         IXgRdkKyHJAXVQkFrIaF+zWuxg696rYL4co/rzd9Es40IUU7roKaQbyugQwkKK32MQd0
         gc3P0AzqpCwbuYM44UzW4tfCeFuvRo2K+tWiqTaHPqJ73nyO3zmECSiWvohRhLveF/Aa
         UIEbGmQL2GyFvUsaeCqhrrvurHE1B8fXibMhGzM3o/IFQkV8EVpQdR2DAtGlNnh/U5G4
         j9IA==
X-Gm-Message-State: ACrzQf1jHmWlKOCZAOdCbGclxB/eq3DAZwjSIif4YtL32XeONK3Ae+LJ
        jLkIncelWXsF2zO19sh6drdRfQDEeL1cfssPWdU=
X-Google-Smtp-Source: AMsMyM4bTsCyOJva27NAcmPBa1jZoiKrjsFnuk5pZM9SD7y8zKr3zFD7eYueqspZNeo+C3iBJjv8MW8af9+PNn6obJ4=
X-Received: by 2002:a17:902:8302:b0:178:3881:c7b7 with SMTP id
 bd2-20020a170902830200b001783881c7b7mr11741447plb.22.1663578110710; Mon, 19
 Sep 2022 02:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220906052129.104507-1-saeed@kernel.org> <20220906052129.104507-8-saeed@kernel.org>
 <CALHRZuq962PeU0OJ0pLrnW=tkaBd8T+iFSkT3mfWr2ArYKdO8A@mail.gmail.com>
 <20220914203849.fn45bvuem2l3ppqq@sx1> <CALHRZup8+nSNoD_=wSKGym3=EPMKoU+1UxbVReOv8xnBnTeRiw@mail.gmail.com>
 <CALHRZuqKjpr+u237dtE3+0b4mQrJKxDLhA=SKbiNjd0Fo5h1Nw@mail.gmail.com> <166322893264.61080.12133865599607623050@kwain>
In-Reply-To: <166322893264.61080.12133865599607623050@kwain>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Mon, 19 Sep 2022 14:31:37 +0530
Message-ID: <CALHRZurLscR15y48fzJXC4pAWe+wen8JZVCwk2fwT4wujqSdRQ@mail.gmail.com>
Subject: Re: [PATCH net-next V2 07/17] net/mlx5: Add MACsec offload Tx command support
To:     Antoine Tenart <atenart@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>, liorna@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>, naveenm@marvell.com,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>, andrew@lunn.ch
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 1:32 PM Antoine Tenart <atenart@kernel.org> wrote:
>
> Quoting sundeep subbaraya (2022-09-15 07:20:05)
> > On Thu, Sep 15, 2022 at 10:44 AM sundeep subbaraya
> > <sundeep.lkml@gmail.com> wrote:
> > > On Thu, Sep 15, 2022 at 2:08 AM Saeed Mahameed <saeedm@nvidia.com> wrote:
> > > > On 14 Sep 20:09, sundeep subbaraya wrote:
> > > > >Hi Saeed and Lior,
> > > > >
> > > > >Your mdo_ops can fail in the commit phase and do not validate input
> > > > >params in the prepare phase.
> > > > >Is that okay? I am developing MACSEC offload driver for Marvell CN10K
> > > >
> > > > It's ok since i think there is no reason to have the two steps system ! it
> > > > doesn't make any sense to me ! prepare and commit are invoked consecutively
> > > > one after the other for all mdo_ops and in every offload flow, with no extra
> > > > step in between! so it's totally redundant.
> > > >
> > > > when i reviewed the series initially i was hesitant to check params
> > > > on prepare step but i didn't see any reason since commit can still fail in
> > > > the firmware anyways and there is nothing we can do about it !
> > >
> > > Yes, same with us where messages sent to the AF driver can fail in the
> > > commit phase.
> > >
> > > > so we've decide to keep all the flows in one context for better readability
> > > > and since the prepare/commit phases are confusing.
>
> > > > >and I had to write some clever code
> > > > >to honour that :). Please someone help me understand why two phase
> > > > >init was needed for offloading.
> > > >
> > > > I don't know, let's ask the original author, Antoine ?
>
> This two steps configuration wasn't part of the initial RFC and there
> was a suggestion to go this way as it could allow the hardware to reject
> some configurations and have an easier s/w fallback (w/ phase 1 error
> being ignored but not phase 2). This mapped ~quite well to the first
> device supporting this so I tried it. But looking back, this wasn't
> discussed anymore nor improved and stayed this way. As you can see the
> offloading doesn't fallback to s/w currently and I'd say if we want that
> we should discuss it first; not sure if that is wanted after all.
>
I could not think of advantages we have with two phase init for
software fallback.
As of now we will send the new driver to do all the init in the
prepare phase and
commit phase will return 0 always.

Thanks,
Sundeep


> If in the end all drivers ignore the first phase, or can't do much, it's
> probably an indication the pattern doesn't fit well. We can still change
> this, especially considering there are not that many drivers
> implementing MACsec h/w offload for now. Now is a good time to discuss
> this, thanks for raising that point.
>
> [Adding Andrew who IIRC looked at the initial RFC; in case he wants to
> add something].
>
> Thanks,
> Antoine
