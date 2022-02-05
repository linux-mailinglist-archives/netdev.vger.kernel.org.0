Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D5D4AA69E
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351532AbiBEEiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbiBEEiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:38:23 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5EDC061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 20:38:21 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id m6so24413298ybc.9
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 20:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=73lLALLVsj1f7Rrw46L6Qv9dE9g+GzGwVtv08Ah0AVo=;
        b=dqRbcTGa1WzyVyd0I3b/hJ+ZqJ6PyoQ6ApL8BrFCdA39yQj2PbuYovlC5gGbkJ/feo
         jEgH/5yoXDE2jQ5jLeZFL3TCAwc6V1wyrBbFGCuSuqFyhfeTNTsTUyKuiI8Y1/j8p0Cz
         GfE3lX7IP6o7xs75aAZCSuwycLtXKxRFkaNu9FDMWZbIYZws1sYdCXD3LY2cjpl9JaEy
         V8Hp56MHpwFz1cng2rZKpgPk20v0S2pt5g6loQOuct1wqIQtdsfgiIaGkylQz1Ct1IRH
         DxnkC5YUg0QnUvwhBt5j724d3AKjcIDiJNKPH86XYb2R/suOXhvHjyGRiWYFbLkvpG/G
         LW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=73lLALLVsj1f7Rrw46L6Qv9dE9g+GzGwVtv08Ah0AVo=;
        b=g4JhpfW1oNO7U1TQVoCbfNkFPs8CkjMgfhdX+Klo54W7al2sHhxUNWECJEupsxpVZx
         gwHECnzQvKVaInsG+oyxSzySG60mHadHRsksQxLaK/klqKq2mynXzMAW/fy8glBLHl31
         xSTz+PrMT3TY5ewfnC9WTAD8iRJ4MUPE9yYFs2w27NRRRplCxuqmgmZi6wc9NPOkR3Ww
         oUOHeaBt8fId7GvrUTp/wLGUA9z92a96VanQeWQ7MimMiEeok9d4cLp9k4L5R2utddqX
         0CqU/vLG3cjX3yFvIxmqkFyqL91Qt+PEIeS6qeOzPQLJkyBTObjcS0AMT9C2bvGC189o
         otIw==
X-Gm-Message-State: AOAM532MWZm8vppj+3+lW6MRSqwOqY8ZCg89iP8+VDibWY4qjCiltYPs
        DCtvb6+nn+IYrvaowJaKYq2hYwq4h3LCoNTMsAuZHa4Lfa4p1URvCQw=
X-Google-Smtp-Source: ABdhPJwQGlc3/rrG85XKdfXoUhUP5C/7g5ftjHOIQ+FKsg7wZKZ/zDeR6Wp3LbkYvSeAiiM3XoHguYaDevE3Res7ZvQ=
X-Received: by 2002:a81:1704:: with SMTP id 4mr2236349ywx.32.1644035899842;
 Fri, 04 Feb 2022 20:38:19 -0800 (PST)
MIME-Version: 1.0
References: <20220203180227.3751784-1-eric.dumazet@gmail.com>
 <20220203180227.3751784-2-eric.dumazet@gmail.com> <20220204195229.2e210fde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iKF0sf1APAaVKHdWRZEVZ5X1LoBRGHBgS4TfucD=SsOJw@mail.gmail.com> <20220204203434.17f56b23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204203434.17f56b23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Feb 2022 20:38:08 -0800
Message-ID: <CANn89iLGfc0xOXzhuytd=PUQ6MBHb-maYhB1ddvEunHb2jdaxg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: typhoon: implement ndo_features_check method
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 8:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 4 Feb 2022 20:26:58 -0800 Eric Dumazet wrote:
> > > Should we always clear SG? If we want to make the assumption that
> > > non-gso skbs are never this long (like the driver did before) then
> > > we should never clear SG. If we do we risk one of the gso-generated
> > > segs will also be longer than 32 frags.
> >
> > If I read the comment (deleted in this patch), it seems the 32 limits
> > is about TSO only ?
> >
> > #warning Typhoon only supports 32 entries in its SG list for TSO, disabling TSO
> >
> > This is why I chose this implementation.
>
> Right, sort of my point - to stay true to old code we don't need to
> worry about SG ? The old code didn't..

I misread your comment.

I thought you suggested to always clear SG, regardless of GSO or not, as in

       if (skb_shinfo(skb)->nr_frags > 32) {
               if (skb_is_gso(skb))
                       features &= ~NETIF_F_GSO_MASK;
               features &= ~NETIF_F_SG;
       }


>
> > > Thought I should ask.
> > >
> > > > +     }
> > > > +     return features;
> > >
> > > return vlan_features_check(skb, features) ?
> >
> > Hmm... not sure why we duplicate vlan_features_check() &
> > vxlan_features_check() in all ndo_features_check() handlers :/
>
> I was wondering as well. I can only speculate.. :S
