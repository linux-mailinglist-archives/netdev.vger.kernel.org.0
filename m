Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AADE5B95E3
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiIOICU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiIOICT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:02:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8614E6FA19
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A8E9B81D5D
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E6BC433D6;
        Thu, 15 Sep 2022 08:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663228935;
        bh=Dh1SmPgaT4yQg5VZM4IqEy+U583WdnamRlC8YY6FC9E=;
        h=In-Reply-To:References:To:From:Cc:Subject:Date:From;
        b=o05nSXxNmySCPPK+7Jj53BkrQ46JkRpPMTiDxE64Miyc5Y8uG+1ge+XrtTjgj3z9G
         DCcMzg31Kui/cVhropzbz+6SxF1r1QMqlXRFXiiRbEJxbzSf5Y4EhsCs2nrd3xF0BR
         NM0+F8HWQFIqXpo4qFiteHG4bgfTcGchJ9l4H04aP/R5L+VlUaNcKyP0fK3s1qjUkT
         AJa/JONArOcph6BdBtAVIVEOp21RDhZKIbN+XNEGWvcRK/UFwrDCtqUxgPy7UWdfka
         apbMPJdIuUANU1R7ylcb5XHx1vK9mnRUV9NVtruN/inP8vZTZrBU38g17oluqBfye+
         Mt2nj845iNMbA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CALHRZuqKjpr+u237dtE3+0b4mQrJKxDLhA=SKbiNjd0Fo5h1Nw@mail.gmail.com>
References: <20220906052129.104507-1-saeed@kernel.org> <20220906052129.104507-8-saeed@kernel.org> <CALHRZuq962PeU0OJ0pLrnW=tkaBd8T+iFSkT3mfWr2ArYKdO8A@mail.gmail.com> <20220914203849.fn45bvuem2l3ppqq@sx1> <CALHRZup8+nSNoD_=wSKGym3=EPMKoU+1UxbVReOv8xnBnTeRiw@mail.gmail.com> <CALHRZuqKjpr+u237dtE3+0b4mQrJKxDLhA=SKbiNjd0Fo5h1Nw@mail.gmail.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        sundeep subbaraya <sundeep.lkml@gmail.com>
From:   Antoine Tenart <atenart@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>, liorna@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>, naveenm@marvell.com,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>, andrew@lunn.ch
Subject: Re: [PATCH net-next V2 07/17] net/mlx5: Add MACsec offload Tx command support
Message-ID: <166322893264.61080.12133865599607623050@kwain>
Date:   Thu, 15 Sep 2022 10:02:12 +0200
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting sundeep subbaraya (2022-09-15 07:20:05)
> On Thu, Sep 15, 2022 at 10:44 AM sundeep subbaraya
> <sundeep.lkml@gmail.com> wrote:
> > On Thu, Sep 15, 2022 at 2:08 AM Saeed Mahameed <saeedm@nvidia.com> wrot=
e:
> > > On 14 Sep 20:09, sundeep subbaraya wrote:
> > > >Hi Saeed and Lior,
> > > >
> > > >Your mdo_ops can fail in the commit phase and do not validate input
> > > >params in the prepare phase.
> > > >Is that okay? I am developing MACSEC offload driver for Marvell CN10K
> > >
> > > It's ok since i think there is no reason to have the two steps system=
 ! it
> > > doesn't make any sense to me ! prepare and commit are invoked consecu=
tively
> > > one after the other for all mdo_ops and in every offload flow, with n=
o extra
> > > step in between! so it's totally redundant.
> > >
> > > when i reviewed the series initially i was hesitant to check params
> > > on prepare step but i didn't see any reason since commit can still fa=
il in
> > > the firmware anyways and there is nothing we can do about it !
> >
> > Yes, same with us where messages sent to the AF driver can fail in the
> > commit phase.
> >
> > > so we've decide to keep all the flows in one context for better reada=
bility
> > > and since the prepare/commit phases are confusing.

> > > >and I had to write some clever code
> > > >to honour that :). Please someone help me understand why two phase
> > > >init was needed for offloading.
> > >
> > > I don't know, let's ask the original author, Antoine ?

This two steps configuration wasn't part of the initial RFC and there
was a suggestion to go this way as it could allow the hardware to reject
some configurations and have an easier s/w fallback (w/ phase 1 error
being ignored but not phase 2). This mapped ~quite well to the first
device supporting this so I tried it. But looking back, this wasn't
discussed anymore nor improved and stayed this way. As you can see the
offloading doesn't fallback to s/w currently and I'd say if we want that
we should discuss it first; not sure if that is wanted after all.

If in the end all drivers ignore the first phase, or can't do much, it's
probably an indication the pattern doesn't fit well. We can still change
this, especially considering there are not that many drivers
implementing MACsec h/w offload for now. Now is a good time to discuss
this, thanks for raising that point.

[Adding Andrew who IIRC looked at the initial RFC; in case he wants to
add something].

Thanks,
Antoine
