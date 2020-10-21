Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA78294938
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 10:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502201AbgJUIM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 04:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408399AbgJUIMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 04:12:24 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F504C0613CE;
        Wed, 21 Oct 2020 01:12:24 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h5so1912896wrv.7;
        Wed, 21 Oct 2020 01:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XE31dZFvIZ+t/YiO0g/RDy81M0xoxvihRRA0koUzIdU=;
        b=puGwL8MzKbejoMfNwmuFh4pW275UkTy2PpeNrqvDHxOAaDfGcbSagTSGgiV00Ugieg
         MoVLHIw//Hz9+mHJ5c6VdSjESb/X6IJqwY3+A9OqOt9oXHvW2ncy6W1Fp4acbldvQ92c
         TsHBpCRuWF5Q5ujL3+ju80bHs6e11azGf0F69bM2qag0B13AnkojJDXWySpk1z/lg2Ko
         FD6vzXLiTsFY4D1E5T4oPmIWPZ9lQRYvdBPAZU5BzVnbSfn4L1ZwsCqimH5nCKCrDa6x
         mAEsb93o0JkRPk4kiNz9+HSyB4eU8VrbHkmOfgP42ztO7yYqWHb9Bsny1erYPP458vx1
         J8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XE31dZFvIZ+t/YiO0g/RDy81M0xoxvihRRA0koUzIdU=;
        b=IXkgqJOil3mtKepW6vqE+N0gUyNcYqq6/eer7VatBy/PTRlIrV1mFq3+5AbGAhfbM9
         fbmQTzko/ALQmLGrzjEQPp05KaNNEA2PYKffsuFf7GXnIM5tVVv8MPiDgjiP6cDOaT2H
         TLK1Ll8i4LOM9PGeSaHzaIFxRGAOYL+K+EoP26WuN/VxHvNQpnt3w+uSgcwutYKKjK7a
         rrtm6SzX17dfgWOtNAYJT2IKqrNNS2BdkrKSnft+SUKf8Oy22me6JE0KeCczkIDG3FaV
         oWv6nQPdnVNuC+q1hhSGce09LSjd+5moiEWGijSCpxJaew3q7Hzye/PAvCNyoM4pgyrz
         Az3g==
X-Gm-Message-State: AOAM530Cwl4/7T5jGVgaTFM4boREawBk38cvDzAq8idIeYInuLzV/mVc
        IqRdNLyQzTv6B/NpUj7q++T+FpVxrjcG4pqT
X-Google-Smtp-Source: ABdhPJwNwMwdtuCQvw/JjFHevL19gKdflsZfvuRmxor1F3WcQmcRB+WaO+8R7ZqPXPvR+4NSB3YWuQ==
X-Received: by 2002:adf:b787:: with SMTP id s7mr3271442wre.390.1603267943086;
        Wed, 21 Oct 2020 01:12:23 -0700 (PDT)
Received: from ahabdels-m-j3jg.home (dynamic-adsl-78-12-10-96.clienti.tiscali.it. [78.12.10.96])
        by smtp.gmail.com with ESMTPSA id 67sm2109401wmb.31.2020.10.21.01.12.21
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 21 Oct 2020 01:12:22 -0700 (PDT)
Date:   Wed, 21 Oct 2020 10:12:21 +0200
From:   Ahmed Abdelsalam <ahabdels.dev@gmail.com>
To:     Reji Thomas <rejithomas.d@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        andrea.mayer@uniroma2.it
Subject: Re: [PATCH v2] IPv6: sr: Fix End.X nexthop to use oif.
Message-Id: <20201021101221.982a5814d25dd1179b81a7f2@gmail.com>
In-Reply-To: <CAA8Zg7HEpWrhaWrJ0Zf==Gf0fuDKH6E-zczb5aUUtMR8x7tBCA@mail.gmail.com>
References: <20201015082119.68287-1-rejithomas@juniper.net>
        <20201018160147.6b3c940a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAA8Zg7Gcua1=6CgSkJ-z8uKJneDjedB4z6zm2a+DcYt-_YcmSQ@mail.gmail.com>
        <20201020112829.d689c849c85f4d5448c8f62d@gmail.com>
        <20201020113413.9413e2910e549a5722911004@gmail.com>
        <CAA8Zg7HEpWrhaWrJ0Zf==Gf0fuDKH6E-zczb5aUUtMR8x7tBCA@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Reji, 

We are going to send the patch to the mailer in the next days. 

As for the link local addresses, we can add a check for that and kernel 
returns error in case of link local and OIF not provided. 

We will add you and Jakub to the recipients when we send the patch. 

Best,
Ahmed


On Tue, 20 Oct 2020 18:05:47 +0530
Reji Thomas <rejithomas.d@gmail.com> wrote:

> Hi Ahmed,
> 
> 
> On Tue, Oct 20, 2020 at 3:04 PM Ahmed Abdelsalam <ahabdels.dev@gmail.com> wrote:
> >
> > We are submitting the patch for End.DT4. End.DX4 is already there.
> >
> > So the optional parameter and OIF applies directly to End.X/End.DX6/End.DX4.
> >
> The only catch is OIF cannot be an optional parameter for linklocal address.
> For global address, it can be made to depend on user specifying the
> oif in which case
> code can enforce the lookup with oif and in other cases  do an "any"
> interface lookup.
> That would also solve Jakub's concern in breaking any existing
> implementations(using global address)
> thereby passing the onus to the control plane to enforce the interface
> behavior as
> needed for global address.
> 
> I will wait for the patch. Hope there will be a way to enforce the oif
> for linklocal address..
> 
> 
> 
> >
> > On Tue, 20 Oct 2020 11:28:29 +0200
> > Ahmed Abdelsalam <ahabdels.dev@gmail.com> wrote:
> >
> > > Jakub, Reji,
> > >
> > > Andrea (CC'ed) and I have been working on a patch that could solve this issue.
> > > The patch allows to provide optional parameters to when SRv6 behavior.
> > > The OIF can be provided as an optional parameter when configuring SRv6 End.X,
> > > End.DX6 or End.DX4 (we are submiting in the next couple of days to support End.DX4).
> > >
> > > We can submit the optional parameter again. Then Reji can leverage this to provide OIF
> > > as an optional parameters.
> > >
> > > Would you agree ?
> > >
> > > Thanks
> > > Ahmed
> > >
> > >
> > >
> > > On Mon, 19 Oct 2020 09:25:12 +0530
> > > Reji Thomas <rejithomas.d@gmail.com> wrote:
> > >
> > > > Hi,
> > > >
> > > > Please find my replies inline below.
> > > >
> > > > Regards
> > > > Reji
> > > >
> > > > On Mon, Oct 19, 2020 at 4:31 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > >
> > > > > On Thu, 15 Oct 2020 13:51:19 +0530 Reji Thomas wrote:
> > > > > > Currently End.X action doesn't consider the outgoing interface
> > > > > > while looking up the nexthop.This breaks packet path functionality
> > > > > > specifically while using link local address as the End.X nexthop.
> > > > > > The patch fixes this by enforcing End.X action to have both nh6 and
> > > > > > oif and using oif in lookup.It seems this is a day one issue.
> > > > > >
> > > > > > Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")
> > > > > > Signed-off-by: Reji Thomas <rejithomas@juniper.net>
> > > > >
> > > > > David, Mathiey - any comments?
> > > > >
> > > > > > @@ -239,6 +250,8 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > > > > >  static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > > > > >  {
> > > > > >       struct ipv6_sr_hdr *srh;
> > > > > > +     struct net_device *odev;
> > > > > > +     struct net *net = dev_net(skb->dev);
> > > > >
> > > > > Order longest to shortest.
> > > > Sorry. Will fix it.
> > > >
> > > > >
> > > > >
> > > > > >
> > > > > >       srh = get_and_validate_srh(skb);
> > > > > >       if (!srh)
> > > > > > @@ -246,7 +259,11 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > > > > >
> > > > > >       advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > > > > >
> > > > > > -     seg6_lookup_nexthop(skb, &slwt->nh6, 0);
> > > > > > +     odev = dev_get_by_index_rcu(net, slwt->oif);
> > > > > > +     if (!odev)
> > > > > > +             goto drop;
> > > > >
> > > > > Are you doing this lookup just to make sure that oif exists?
> > > > > Looks a little wasteful for fast path, but more importantly
> > > > > it won't be backward compatible, right? See below..
> > > > >
> > > > Please see reply below.
> > > >
> > > > > > +
> > > > > > +     seg6_strict_lookup_nexthop(skb, &slwt->nh6, odev->ifindex, 0);
> > > > > >
> > > > > >       return dst_input(skb);
> > > > > >
> > > > >
> > > > > > @@ -566,7 +583,8 @@ static struct seg6_action_desc seg6_action_table[] = {
> > > > > >       },
> > > > > >       {
> > > > > >               .action         = SEG6_LOCAL_ACTION_END_X,
> > > > > > -             .attrs          = (1 << SEG6_LOCAL_NH6),
> > > > > > +             .attrs          = ((1 << SEG6_LOCAL_NH6) |
> > > > > > +                                (1 << SEG6_LOCAL_OIF)),
> > > > > >               .input          = input_action_end_x,
> > > > > >       },
> > > > > >       {
> > > > >
> > > > > If you set this parse_nla_action() will reject all
> > > > > SEG6_LOCAL_ACTION_END_X without OIF.
> > > > >
> > > > > As you say the OIF is only required for using link local addresses,
> > > > > so this change breaks perfectly legitimate configurations.
> > > > >
> > > > > Can we instead only warn about the missing OIF, and only do that when
> > > > > nh is link local?
> > > > >
> > > > End.X is defined as an adjacency-sid and is used to select a specific link to a
> > > > neighbor for both global and link-local addresses. The intention was
> > > > to drop the
> > > > packet even for global addresses if the route via the specific
> > > > interface is not found.
> > > > Alternatively(believe semantically correct for End.X definition) I
> > > > could do a neighbor lookup
> > > > for nexthop address over specific interface and send the packet out.
> > > >
> > > > > Also doesn't SEG6_LOCAL_ACTION_END_DX6 need a similar treatment?
> > > >
> > > > Yes. I will update the patch for End.DX6 based on the patch finalized for End.X.
> > >
> > >
> > > --
> > > Ahmed Abdelsalam <ahabdels.dev@gmail.com>
> >
> >
> > --
> > Ahmed Abdelsalam <ahabdels.dev@gmail.com>


-- 
Ahmed Abdelsalam <ahabdels.dev@gmail.com>
