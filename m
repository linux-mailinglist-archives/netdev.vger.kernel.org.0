Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDBF2D497C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 19:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbgLISv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 13:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387490AbgLISvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 13:51:20 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9AFC061793
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 10:50:40 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id p187so2693710iod.4
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 10:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SPEOvDYUcPGB1mhkHOmjLnwBj98qiGs4ARJVt5iZbQM=;
        b=A9oFAvMeMr+e21ZynjhdkQ4fxaLAQLvRNYrvxSflC7Ed+QnGZIAmwD6781fFTi0lGo
         bA9s/MUlNf0EG/ud43Gckz5ATKuHbReqjdxLcxulZ1sQXTwN7a64lszWgiDw3IDvcjCN
         0uSnRqxmeqYdmWeqq18ctB1WZZyqXSBzbjHY9hGHNgWbmIv/oLjw0A6BqzQZAeNuk5Qs
         C/NzXtgiCMHzyo8tDGOsHTsZfeoexyI5sCXY7JBEC0yMYX1BAwBRhT3PzLoSN5cr+TeI
         X+l/DaongG4lLH9F2+uvpu3gwsPN2F9dPRqwHsa/0L01dV9JyBSkYpGtjR8anrR0fQBR
         eP/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SPEOvDYUcPGB1mhkHOmjLnwBj98qiGs4ARJVt5iZbQM=;
        b=JkculAhCFUjeZeEoqB5SJusWq0jBRE4PLP9UjBzTfkQ21ZL+KhCIa4Fs+UB9iSop2n
         mSAJmqoOIU+YTLYbIWRZW20MgEiti6+B3H/s/4xRl+MTt/lG3MiIn3zLh4VGjN17p65r
         3d4nsboO24snyUgHzuPLctFcaWASzJe8Kof8Hg1TWG3fEI3eWe8bYCHbbTOC/mrFDKhf
         5Qs+8hikyOSjlOvo8U4GrIB6ZaNM15IzqTeefjgxUGEj8GV7F5Zuy/oYZcYdFuXXyVeh
         xT4mZkYwKhPo1P/++b6MITOP0lpapQAA6Bo0CRZsR2Tkk+nWKywN8T465IZbs0Z70uyR
         VnnQ==
X-Gm-Message-State: AOAM533EgvujDe8+RLaemWkbfRSo0LTUct568FINEjaIdMCPoYr5EGWz
        7qT0UOqO0FMsJssV/jtGT66Wk2P/OhX6d6WucEEFKw==
X-Google-Smtp-Source: ABdhPJx1JQy9bV4NsMqVbc9Trl2pVaFN12Ypx07bqN03THiaN13O9oYcv8Opt6nBhAKjLGpm99sTx1EtKesrgdsZsu8=
X-Received: by 2002:a02:4007:: with SMTP id n7mr4866298jaa.99.1607539839324;
 Wed, 09 Dec 2020 10:50:39 -0800 (PST)
MIME-Version: 1.0
References: <cki.4066A31294.UNMQ21P718@redhat.com> <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com>
 <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com>
 <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CANn89iL8akG+u6sq4r7gxpWKMoDSKuCbgFvDPrrG+J85zC1KNg@mail.gmail.com>
 <CANn89iKcKATT902n6C1-Hi0ey0Ep20dD88nTTLLH9NNF6Pex5w@mail.gmail.com> <838391ff7ffa5dbfb79f30c6d31292c80415af18.camel@kernel.org>
In-Reply-To: <838391ff7ffa5dbfb79f30c6d31292c80415af18.camel@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Dec 2020 19:50:27 +0100
Message-ID: <CANn89iK+fU7LGH--JXx_FLxawr7rs1t-crLGtkbPAXsoiZMi8A@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBUZXN0IHJlcG9ydCBmb3Iga2VybmVsIDUuMTAuMC1yYzYgKG1haQ==?=
        =?UTF-8?B?bmxpbmUua2VybmVsLm9yZyk=?=
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vladyslav Buslov <vladbu@nvidia.com>,
        Jianlin Shi <jishi@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        netdev <netdev@vger.kernel.org>, skt-results-master@redhat.com,
        Yi Zhang <yi.zhang@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Jianwen Ji <jiji@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Changhui Zhong <czhong@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        David Arcari <darcari@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 7:34 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Wed, 2020-12-09 at 19:05 +0100, Eric Dumazet wrote:
> > On Wed, Dec 9, 2020 at 6:35 PM Eric Dumazet <edumazet@google.com>
> > wrote:
> > > Hmm... maybe the ECN stuff has always been buggy then, and nobody
> > > cared...
> > >
> >
> > Wait a minute, maybe this part was not needed,
> >
> > diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> > index
> > 8ae9ce2014a4a3ba7b962a209e28d1f65d4a83bd..896a7eb61d70340f69b9d3be0f7
> > 95fbaab1458dd
> > 100644
> > --- a/drivers/net/geneve.c
> > +++ b/drivers/net/geneve.c
> > @@ -270,7 +270,7 @@ static void geneve_rx(struct geneve_dev *geneve,
> > struct geneve_sock *gs,
> >                         goto rx_error;
> >                 break;
> >         default:
> > -               goto rx_error;
> > +               break;
> >         }
> >         oiph = skb_network_header(skb);
> >         skb_reset_network_header(skb);
> >
> >
> > > On Wed, Dec 9, 2020 at 6:20 PM Jakub Kicinski <kuba@kernel.org>
> > > wrote:
> > > > Eric, could this possibly be commit 4179b00c04d1 ("geneve: pull
> > > > IP
> > > > header before ECN decapsulation")?
> > > >
>
> We've bisected an issue in our CI to this patch, something about geneve
> TC offload traffic not passing, I don't have all the details, Maybe
> Vlad can chime in.
>

Yes, I think the patch I sent should fix this, ETH_P_ARP should not be
dropped ;)

I am testing this before offical patch submission.

Thanks !
