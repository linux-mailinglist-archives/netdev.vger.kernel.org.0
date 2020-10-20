Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BB2293BBF
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 14:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406225AbgJTMgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406096AbgJTMgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 08:36:02 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D572C061755;
        Tue, 20 Oct 2020 05:36:02 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a4so1780035lji.12;
        Tue, 20 Oct 2020 05:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GO41J3t+KQGcluoAbDTnlHbfgoWPQDfGQT8R7UnC7l8=;
        b=aWKiIpAiI4UNEZRlivP8LuNmuEu8i0b+vHdxlTSCrJM/f/jilILMrxlgBUC6iROYLO
         vOpNBiEHo+uODaQWiw6aDMcCxkkq3yLMlzGUrq4ebvWRFRiTGPQbL3047NTbKp6wmIdp
         dHkL0cXCoG+Sc6nDwRDjIoNEvvbxof6sFjMA/gqfEcmcj8OR41m3D4FvXSADoyq8+Dzx
         iwYibug6fLLDYT/U8wWq05Soa5NHAxLYmf9jCmNeE4mqeXkkU680Wg5rlyzo08QwXBnt
         t5uqodM15WvGLpu5nFH6rGhXUK/imVSw4SsoqS/dl5sEWMqqRbtlQKZDScUdwMzUur5V
         qgzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GO41J3t+KQGcluoAbDTnlHbfgoWPQDfGQT8R7UnC7l8=;
        b=KvvIzf3PpSCohb5xvANr3/Bo3f7T2SRfvH8aTpidSRB1hZ/oAO21gPMmPo62e0ooZS
         c2dsRe/vgh/opI601JD5/WaSWdLmDJ0Eg2CneSHeRxPnU0LED4TBIAjkNgYHhvCmvm+c
         nC1EjphjigH7L2WcutCzP9FHIIANv0y1uZ/AIWOvcSYi3gLyURnnmZHmputS8ONnzzwO
         FPTsyz0iC/9XHuRsy+CXIFR1mHRDf1chnfqNHVekklDh44PWWfNwUWnjbCfn0SOzwphP
         vFDLX6IL/3v75m1VGTD9+i67OC8NFIOZKIQ6ZiIUVe1w36jF/VSpOon4k0atSMMJbdPM
         KAJQ==
X-Gm-Message-State: AOAM533Hpy2YyX92df0Oi8ISEHZa+Ew3j/nY08gINCFaaj26eJZhARn4
        bqTMvh8qRlmHd11Hlp9M+Q0eHCOECAkGpSK9Xj4a1r7gFY97
X-Google-Smtp-Source: ABdhPJw56zrDQL6MB1dg8E6Ffo4qbDfVRREhzJy+lsYhtFQeLBGqK4FkSwTIwKqXvgBLjIilDGov6oIcRIS09lEai6o=
X-Received: by 2002:a2e:b4d0:: with SMTP id r16mr1083832ljm.470.1603197360543;
 Tue, 20 Oct 2020 05:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <20201015082119.68287-1-rejithomas@juniper.net>
 <20201018160147.6b3c940a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAA8Zg7Gcua1=6CgSkJ-z8uKJneDjedB4z6zm2a+DcYt-_YcmSQ@mail.gmail.com>
 <20201020112829.d689c849c85f4d5448c8f62d@gmail.com> <20201020113413.9413e2910e549a5722911004@gmail.com>
In-Reply-To: <20201020113413.9413e2910e549a5722911004@gmail.com>
From:   Reji Thomas <rejithomas.d@gmail.com>
Date:   Tue, 20 Oct 2020 18:05:47 +0530
Message-ID: <CAA8Zg7HEpWrhaWrJ0Zf==Gf0fuDKH6E-zczb5aUUtMR8x7tBCA@mail.gmail.com>
Subject: Re: [PATCH v2] IPv6: sr: Fix End.X nexthop to use oif.
To:     Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        andrea.mayer@uniroma2.it
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ahmed,


On Tue, Oct 20, 2020 at 3:04 PM Ahmed Abdelsalam <ahabdels.dev@gmail.com> wrote:
>
> We are submitting the patch for End.DT4. End.DX4 is already there.
>
> So the optional parameter and OIF applies directly to End.X/End.DX6/End.DX4.
>
The only catch is OIF cannot be an optional parameter for linklocal address.
For global address, it can be made to depend on user specifying the
oif in which case
code can enforce the lookup with oif and in other cases  do an "any"
interface lookup.
That would also solve Jakub's concern in breaking any existing
implementations(using global address)
thereby passing the onus to the control plane to enforce the interface
behavior as
needed for global address.

I will wait for the patch. Hope there will be a way to enforce the oif
for linklocal address..



>
> On Tue, 20 Oct 2020 11:28:29 +0200
> Ahmed Abdelsalam <ahabdels.dev@gmail.com> wrote:
>
> > Jakub, Reji,
> >
> > Andrea (CC'ed) and I have been working on a patch that could solve this issue.
> > The patch allows to provide optional parameters to when SRv6 behavior.
> > The OIF can be provided as an optional parameter when configuring SRv6 End.X,
> > End.DX6 or End.DX4 (we are submiting in the next couple of days to support End.DX4).
> >
> > We can submit the optional parameter again. Then Reji can leverage this to provide OIF
> > as an optional parameters.
> >
> > Would you agree ?
> >
> > Thanks
> > Ahmed
> >
> >
> >
> > On Mon, 19 Oct 2020 09:25:12 +0530
> > Reji Thomas <rejithomas.d@gmail.com> wrote:
> >
> > > Hi,
> > >
> > > Please find my replies inline below.
> > >
> > > Regards
> > > Reji
> > >
> > > On Mon, Oct 19, 2020 at 4:31 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > >
> > > > On Thu, 15 Oct 2020 13:51:19 +0530 Reji Thomas wrote:
> > > > > Currently End.X action doesn't consider the outgoing interface
> > > > > while looking up the nexthop.This breaks packet path functionality
> > > > > specifically while using link local address as the End.X nexthop.
> > > > > The patch fixes this by enforcing End.X action to have both nh6 and
> > > > > oif and using oif in lookup.It seems this is a day one issue.
> > > > >
> > > > > Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")
> > > > > Signed-off-by: Reji Thomas <rejithomas@juniper.net>
> > > >
> > > > David, Mathiey - any comments?
> > > >
> > > > > @@ -239,6 +250,8 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > > > >  static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > > > >  {
> > > > >       struct ipv6_sr_hdr *srh;
> > > > > +     struct net_device *odev;
> > > > > +     struct net *net = dev_net(skb->dev);
> > > >
> > > > Order longest to shortest.
> > > Sorry. Will fix it.
> > >
> > > >
> > > >
> > > > >
> > > > >       srh = get_and_validate_srh(skb);
> > > > >       if (!srh)
> > > > > @@ -246,7 +259,11 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > > > >
> > > > >       advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > > > >
> > > > > -     seg6_lookup_nexthop(skb, &slwt->nh6, 0);
> > > > > +     odev = dev_get_by_index_rcu(net, slwt->oif);
> > > > > +     if (!odev)
> > > > > +             goto drop;
> > > >
> > > > Are you doing this lookup just to make sure that oif exists?
> > > > Looks a little wasteful for fast path, but more importantly
> > > > it won't be backward compatible, right? See below..
> > > >
> > > Please see reply below.
> > >
> > > > > +
> > > > > +     seg6_strict_lookup_nexthop(skb, &slwt->nh6, odev->ifindex, 0);
> > > > >
> > > > >       return dst_input(skb);
> > > > >
> > > >
> > > > > @@ -566,7 +583,8 @@ static struct seg6_action_desc seg6_action_table[] = {
> > > > >       },
> > > > >       {
> > > > >               .action         = SEG6_LOCAL_ACTION_END_X,
> > > > > -             .attrs          = (1 << SEG6_LOCAL_NH6),
> > > > > +             .attrs          = ((1 << SEG6_LOCAL_NH6) |
> > > > > +                                (1 << SEG6_LOCAL_OIF)),
> > > > >               .input          = input_action_end_x,
> > > > >       },
> > > > >       {
> > > >
> > > > If you set this parse_nla_action() will reject all
> > > > SEG6_LOCAL_ACTION_END_X without OIF.
> > > >
> > > > As you say the OIF is only required for using link local addresses,
> > > > so this change breaks perfectly legitimate configurations.
> > > >
> > > > Can we instead only warn about the missing OIF, and only do that when
> > > > nh is link local?
> > > >
> > > End.X is defined as an adjacency-sid and is used to select a specific link to a
> > > neighbor for both global and link-local addresses. The intention was
> > > to drop the
> > > packet even for global addresses if the route via the specific
> > > interface is not found.
> > > Alternatively(believe semantically correct for End.X definition) I
> > > could do a neighbor lookup
> > > for nexthop address over specific interface and send the packet out.
> > >
> > > > Also doesn't SEG6_LOCAL_ACTION_END_DX6 need a similar treatment?
> > >
> > > Yes. I will update the patch for End.DX6 based on the patch finalized for End.X.
> >
> >
> > --
> > Ahmed Abdelsalam <ahabdels.dev@gmail.com>
>
>
> --
> Ahmed Abdelsalam <ahabdels.dev@gmail.com>
