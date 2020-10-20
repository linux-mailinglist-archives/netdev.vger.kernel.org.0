Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086E6293815
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 11:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392894AbgJTJeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 05:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390997AbgJTJeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 05:34:17 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C263C061755;
        Tue, 20 Oct 2020 02:34:17 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id n6so1253104wrm.13;
        Tue, 20 Oct 2020 02:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DZC7gQVRgBkfWFSy4Zj0mTKth7u/ZD8XS8fXZxizUy4=;
        b=IumYBix4dOjEkprdR2mNebMgHhFIvNFq+vI89F7vyQsd9ertKFtlsxLwLQxhIlxyN8
         IRL7I422iKjhxmTYnW7zMjs8f+YrYhcI8s5/OMRg41xBfHR2NgxfSYDd4vY1+gmEAtQi
         bXiD6+Rx0kKVJukqS8sez8jxkHnuooFpUrFnAVP6rloFT1TQkc3BLeVW2lF9KXv5Y8wO
         X3ozM++tOEP93gtStz/73ED+vX5jNc+DrBHluaiZ4vPGHsMcSdhNVmYhAP34IdMEYVUB
         r3F5IAIAgHyueJZYKCOI7+LArUtpsQo8MSL57/utcImUic67AG5AxuBJ+mMKUV1mIfEF
         59rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DZC7gQVRgBkfWFSy4Zj0mTKth7u/ZD8XS8fXZxizUy4=;
        b=sv//qjjL9Egr6EspHUFK9Ei2lLe5y0CV2sDAyC53BPVVGksY9ZRINJV57nlhG/FFIF
         pPfmqsP/U2zxRonA1wTdlCVTyva9pgmeejYq5Xzrl4OxrFkghK2n2DyqR2w4lQq/wowS
         XpkBHb+HczNS6WoxB0ovj9IZI1tBh/pmRCwKqU+WOnej4pVF58sv2xWFFAnfcQ3rIrUf
         juN0ssg8FIJL6XkXUrZmLUhx6Z/5mOKcM8eWbRYXYAdV8kyK1fP8LergSMkjt8Blbqg0
         q1CBZJgyCUF95aRozlEUucf3CHB8MWRHsWcVqBLgonmz7Enw/ZTx8Uc9gHVIv0HuqGpp
         wZ3w==
X-Gm-Message-State: AOAM533zLbrEW/gJ2+5+oYazWAMIi1D728RZkAmeJAgyijYlxXUSBG2M
        ipuAF2zxAoxeJ2b4fcaG1lM=
X-Google-Smtp-Source: ABdhPJwvF17tk2TsJf4n9cht1KkWY3WRDWH263MXgqWDABkKMkVl5bJdYE1AraEZUbzNgodFxFxsMQ==
X-Received: by 2002:adf:e70a:: with SMTP id c10mr2365742wrm.425.1603186455930;
        Tue, 20 Oct 2020 02:34:15 -0700 (PDT)
Received: from AHABDELS-M-J3JG ([173.38.220.56])
        by smtp.gmail.com with ESMTPSA id p11sm2046557wrm.44.2020.10.20.02.34.14
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 20 Oct 2020 02:34:15 -0700 (PDT)
Date:   Tue, 20 Oct 2020 11:34:13 +0200
From:   Ahmed Abdelsalam <ahabdels.dev@gmail.com>
To:     Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Cc:     Reji Thomas <rejithomas.d@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        andrea.mayer@uniroma2.it
Subject: Re: [PATCH v2] IPv6: sr: Fix End.X nexthop to use oif.
Message-Id: <20201020113413.9413e2910e549a5722911004@gmail.com>
In-Reply-To: <20201020112829.d689c849c85f4d5448c8f62d@gmail.com>
References: <20201015082119.68287-1-rejithomas@juniper.net>
        <20201018160147.6b3c940a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAA8Zg7Gcua1=6CgSkJ-z8uKJneDjedB4z6zm2a+DcYt-_YcmSQ@mail.gmail.com>
        <20201020112829.d689c849c85f4d5448c8f62d@gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are submitting the patch for End.DT4. End.DX4 is already there. 

So the optional parameter and OIF applies directly to End.X/End.DX6/End.DX4.
 

On Tue, 20 Oct 2020 11:28:29 +0200
Ahmed Abdelsalam <ahabdels.dev@gmail.com> wrote:

> Jakub, Reji, 
> 
> Andrea (CC'ed) and I have been working on a patch that could solve this issue. 
> The patch allows to provide optional parameters to when SRv6 behavior. 
> The OIF can be provided as an optional parameter when configuring SRv6 End.X, 
> End.DX6 or End.DX4 (we are submiting in the next couple of days to support End.DX4). 
> 
> We can submit the optional parameter again. Then Reji can leverage this to provide OIF
> as an optional parameters. 
> 
> Would you agree ? 
> 
> Thanks 
> Ahmed 
>  
> 
> 
> On Mon, 19 Oct 2020 09:25:12 +0530
> Reji Thomas <rejithomas.d@gmail.com> wrote:
> 
> > Hi,
> > 
> > Please find my replies inline below.
> > 
> > Regards
> > Reji
> > 
> > On Mon, Oct 19, 2020 at 4:31 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 15 Oct 2020 13:51:19 +0530 Reji Thomas wrote:
> > > > Currently End.X action doesn't consider the outgoing interface
> > > > while looking up the nexthop.This breaks packet path functionality
> > > > specifically while using link local address as the End.X nexthop.
> > > > The patch fixes this by enforcing End.X action to have both nh6 and
> > > > oif and using oif in lookup.It seems this is a day one issue.
> > > >
> > > > Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")
> > > > Signed-off-by: Reji Thomas <rejithomas@juniper.net>
> > >
> > > David, Mathiey - any comments?
> > >
> > > > @@ -239,6 +250,8 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > > >  static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > > >  {
> > > >       struct ipv6_sr_hdr *srh;
> > > > +     struct net_device *odev;
> > > > +     struct net *net = dev_net(skb->dev);
> > >
> > > Order longest to shortest.
> > Sorry. Will fix it.
> > 
> > >
> > >
> > > >
> > > >       srh = get_and_validate_srh(skb);
> > > >       if (!srh)
> > > > @@ -246,7 +259,11 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > > >
> > > >       advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > > >
> > > > -     seg6_lookup_nexthop(skb, &slwt->nh6, 0);
> > > > +     odev = dev_get_by_index_rcu(net, slwt->oif);
> > > > +     if (!odev)
> > > > +             goto drop;
> > >
> > > Are you doing this lookup just to make sure that oif exists?
> > > Looks a little wasteful for fast path, but more importantly
> > > it won't be backward compatible, right? See below..
> > >
> > Please see reply below.
> > 
> > > > +
> > > > +     seg6_strict_lookup_nexthop(skb, &slwt->nh6, odev->ifindex, 0);
> > > >
> > > >       return dst_input(skb);
> > > >
> > >
> > > > @@ -566,7 +583,8 @@ static struct seg6_action_desc seg6_action_table[] = {
> > > >       },
> > > >       {
> > > >               .action         = SEG6_LOCAL_ACTION_END_X,
> > > > -             .attrs          = (1 << SEG6_LOCAL_NH6),
> > > > +             .attrs          = ((1 << SEG6_LOCAL_NH6) |
> > > > +                                (1 << SEG6_LOCAL_OIF)),
> > > >               .input          = input_action_end_x,
> > > >       },
> > > >       {
> > >
> > > If you set this parse_nla_action() will reject all
> > > SEG6_LOCAL_ACTION_END_X without OIF.
> > >
> > > As you say the OIF is only required for using link local addresses,
> > > so this change breaks perfectly legitimate configurations.
> > >
> > > Can we instead only warn about the missing OIF, and only do that when
> > > nh is link local?
> > >
> > End.X is defined as an adjacency-sid and is used to select a specific link to a
> > neighbor for both global and link-local addresses. The intention was
> > to drop the
> > packet even for global addresses if the route via the specific
> > interface is not found.
> > Alternatively(believe semantically correct for End.X definition) I
> > could do a neighbor lookup
> > for nexthop address over specific interface and send the packet out.
> > 
> > > Also doesn't SEG6_LOCAL_ACTION_END_DX6 need a similar treatment?
> > 
> > Yes. I will update the patch for End.DX6 based on the patch finalized for End.X.
> 
> 
> -- 
> Ahmed Abdelsalam <ahabdels.dev@gmail.com>


-- 
Ahmed Abdelsalam <ahabdels.dev@gmail.com>
