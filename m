Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86282F28DA
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbhALHVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbhALHVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 02:21:38 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E65DC061575;
        Mon, 11 Jan 2021 23:20:58 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id s26so1818447lfc.8;
        Mon, 11 Jan 2021 23:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ygf0+sa9FROZR6Ry1uOnT1Kwi/qXO3Bcb7rJvLV/HE=;
        b=RceFeGlOIQUrR6aTdNaqAtGJdZhNGjTC16zDNqczl/JTEH9avUESxNdf5BUpWN1uf1
         ET0yH9LTDlB+8gbNRZUgaA3uyVC1zZkKwXVKaRc/wdS3n4dAQwcEUuRNnpH8DPp5xkXs
         VW38p3CP/7oT5DBi24z4DvGRkvwMz4baUB6TKdgSbCYOH8OADY66CklunOrN4Fy+LrAs
         ioz6pbEcyhxzSl6F2cTr81xjznh39csQHFZqoAoO7T7Mw2O4GnFWXqwJIvKsAJgQl3Af
         ckowkPjYUJNFYWTJPOWlmbu9nDx5SKvCVfEt23QFMDAK0Gd4oQKah9/agtMvn3aGGZ2h
         CUsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ygf0+sa9FROZR6Ry1uOnT1Kwi/qXO3Bcb7rJvLV/HE=;
        b=lEnBeCAmCksaVH9OTrHODg6jRbAMrsU0dO740lD5RuMD6DdJP8QVKL0itY7/kLm8m3
         CpD1XUCyCfkg6WCZmcsRX/CekJfJjk+hvwn4fSbw217BuyLWy/uOLaObWjyA6TGSJN7g
         nAG2mkSDflFF1NovUeDK/r3/I11EDkadYcQCdiSajy123pOC2JYilqt8aDRKcnNiMN1Q
         DFVeICiLhUfi3iXKpZ4guzdOX4EHF6GVL/d63zr0Lh2raxpmvD4bHzDo8ptcYlQfA3Zg
         0LeGDYyuDTUgvXRZvn1gioNoJvMHpZ3jzMQn6ayzAMJxl3sQrHPbxHf2mL2++8y4nQ41
         n8yg==
X-Gm-Message-State: AOAM531J9SZOyNxWwBJINdg2BY4LCJp+dZBJBKC6+MaISDu+C4I1akO0
        Mh4oz+Asa5SNCojCckc52YB/qlGBBGc2HEIC2ig=
X-Google-Smtp-Source: ABdhPJxUfvi4aqUZrI/dJUMcoENOauvcsxX+RWTuWTuqL7cOSSjaUWaSGQaV6+LxK99561d7A9bhl7yXytLfVS1lRtw=
X-Received: by 2002:a19:716:: with SMTP id 22mr1620843lfh.390.1610436056586;
 Mon, 11 Jan 2021 23:20:56 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610368918.git.lucien.xin@gmail.com> <a34a8dcde6a158c64b0478c7098da757a6690f0b.1610368918.git.lucien.xin@gmail.com>
 <CAKgT0UdgL-aYGUfeYVRoqLpDFhPzko26z7mxvi2HyTdrLpCF5A@mail.gmail.com>
In-Reply-To: <CAKgT0UdgL-aYGUfeYVRoqLpDFhPzko26z7mxvi2HyTdrLpCF5A@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 12 Jan 2021 15:20:44 +0800
Message-ID: <CADvbK_c4wUUp0We=Cv9jczzACAurZnu0_pRen7Oa=4k8bKcCMw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: move the hsize check to the else block
 in skb_segment
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 12:26 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, Jan 11, 2021 at 4:45 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > After commit 89319d3801d1 ("net: Add frag_list support to skb_segment"),
> > it goes to process frag_list when !hsize in skb_segment(). However, when
> > using skb frag_list, sg normally should not be set. In this case, hsize
> > will be set with len right before !hsize check, then it won't go to
> > frag_list processing code.
> >
> > So the right thing to do is move the hsize check to the else block, so
> > that it won't affect the !hsize check for frag_list processing.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/core/skbuff.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 7626a33..ea79359 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -3855,8 +3855,6 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
> >                 hsize = skb_headlen(head_skb) - offset;
> >                 if (hsize < 0)
> >                         hsize = 0;
> > -               if (hsize > len || !sg)
> > -                       hsize = len;
> >
> >                 if (!hsize && i >= nfrags && skb_headlen(list_skb) &&
> >                     (skb_headlen(list_skb) == len || sg)) {
>
> So looking at the function it seems like the only spot where the
> standard path actually reads the hsize value is right here, and it is
> overwritten before we exit the non-error portion of the if statement.
> I wonder if we couldn't save ourselves a few cycles and avoid an
> unnecessary assignment by replacing the "!hsize" with a check for
> "hsize <= 0" and just move the entire set of checks above down into
> the lower block.
>
> > @@ -3901,6 +3899,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
> >                         skb_release_head_state(nskb);
> >                         __skb_push(nskb, doffset);
> >                 } else {
> > +                       if (hsize > len || !sg)
> > +                               hsize = len;
> > +
>
> Then you could essentially just add the "if (hsize < 0)" piece here as
> an "else if" check and avoid the check if it isn't needed.
Look correct, will post v2. Thanks!

>
> >                         nskb = __alloc_skb(hsize + doffset + headroom,
> >                                            GFP_ATOMIC, skb_alloc_rx_flag(head_skb),
> >                                            NUMA_NO_NODE);
> > --
> > 2.1.0
> >
