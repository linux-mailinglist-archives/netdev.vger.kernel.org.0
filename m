Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4D72937FD
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 11:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405533AbgJTJ2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 05:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391535AbgJTJ2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 05:28:33 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE691C061755;
        Tue, 20 Oct 2020 02:28:33 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id b127so1080620wmb.3;
        Tue, 20 Oct 2020 02:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WD3p79rBKNlzu8W8uJ5pRcWHCcyNcchsVdQI+4oz5wg=;
        b=B6Vj08fA1kJWDp9jzdIOm4J6qJjMAO/oH4ihlVtQH9A9oyGLDjdhmP+eoaDIEPCRF7
         +0Sp7/uc6eO+z2oaFw2+fdZXyzug7btmXnP3r9glEEko9qLJyVpxVfKaruczWcW29vC0
         qZ1KWZ6vQllyS6mtyqbXbvY7bpfRm3RTgrWJfZswmmnlfQHsLRVx8Ypz6vfs3t2Xg06S
         xNby4DUgzSLdqhWZcWbNBF0T9fFffG8qRl4a94YBoIKo4SFxUjjOmjPy9PO9RWnYLYEn
         P2ZAT+jnpV7vP87jKxPSKG+uxw89Q6PQThdZMCD78p+J1SyJC/NZ7PBAvnTugb0/+TLG
         1c/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WD3p79rBKNlzu8W8uJ5pRcWHCcyNcchsVdQI+4oz5wg=;
        b=cZox7AE79QTfD59endrnMZE069v4tTcg+rNwJwoT2s+SlcADCTbq7aCcXLvMkLw4sh
         BTR/Z/08pjuMsyhgH0HZkwNGVhpd2MDuF31XXhc7WZFpjcpnG/ceIlNgrb15PXoGv1w6
         0jEx490M7r8flm4PzefeW9sf4pAhIEe5WdFZ1aLsEgV59705um67BH02G2VYrHMJCCgr
         WFQRwN6mA1ALIW3IjehxWOpa/EKvbMSOPg85l2TS4WZ+S6zsOW1UDd1Bi3T4FfBA6xck
         Yld59SGtvcrYA7w+XupA89HGyQ4qGpjmkTD2pMQsYbdgG6ONzog/d5MKHnzw8AQOzYZE
         K+ZA==
X-Gm-Message-State: AOAM5329i/4cEFutemvkKIOV/iVkoQlIMoo8KL8GJTRvgBIyDc6XkdPA
        YK/wBhigObftxEkatJe+Dws=
X-Google-Smtp-Source: ABdhPJywK+3Vu8Zd9LZOvFUhLXg0pzw0Gpc/oybNITqqoM3N/BWrz4AxgmWZW9Z2PaBjA7W8QKAuSQ==
X-Received: by 2002:a05:600c:21d9:: with SMTP id x25mr1836291wmj.145.1603186112410;
        Tue, 20 Oct 2020 02:28:32 -0700 (PDT)
Received: from AHABDELS-M-J3JG ([173.38.220.56])
        by smtp.gmail.com with ESMTPSA id f8sm1970004wrw.85.2020.10.20.02.28.30
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 20 Oct 2020 02:28:31 -0700 (PDT)
Date:   Tue, 20 Oct 2020 11:28:29 +0200
From:   Ahmed Abdelsalam <ahabdels.dev@gmail.com>
To:     Reji Thomas <rejithomas.d@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        David Lebrun <david.lebrun@uclouvain.be>,
        andrea.mayer@uniroma2.it
Subject: Re: [PATCH v2] IPv6: sr: Fix End.X nexthop to use oif.
Message-Id: <20201020112829.d689c849c85f4d5448c8f62d@gmail.com>
In-Reply-To: <CAA8Zg7Gcua1=6CgSkJ-z8uKJneDjedB4z6zm2a+DcYt-_YcmSQ@mail.gmail.com>
References: <20201015082119.68287-1-rejithomas@juniper.net>
        <20201018160147.6b3c940a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAA8Zg7Gcua1=6CgSkJ-z8uKJneDjedB4z6zm2a+DcYt-_YcmSQ@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub, Reji, 

Andrea (CC'ed) and I have been working on a patch that could solve this issue. 
The patch allows to provide optional parameters to when SRv6 behavior. 
The OIF can be provided as an optional parameter when configuring SRv6 End.X, 
End.DX6 or End.DX4 (we are submiting in the next couple of days to support End.DX4). 

We can submit the optional parameter again. Then Reji can leverage this to provide OIF
as an optional parameters. 

Would you agree ? 

Thanks 
Ahmed 
 


On Mon, 19 Oct 2020 09:25:12 +0530
Reji Thomas <rejithomas.d@gmail.com> wrote:

> Hi,
> 
> Please find my replies inline below.
> 
> Regards
> Reji
> 
> On Mon, Oct 19, 2020 at 4:31 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 15 Oct 2020 13:51:19 +0530 Reji Thomas wrote:
> > > Currently End.X action doesn't consider the outgoing interface
> > > while looking up the nexthop.This breaks packet path functionality
> > > specifically while using link local address as the End.X nexthop.
> > > The patch fixes this by enforcing End.X action to have both nh6 and
> > > oif and using oif in lookup.It seems this is a day one issue.
> > >
> > > Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")
> > > Signed-off-by: Reji Thomas <rejithomas@juniper.net>
> >
> > David, Mathiey - any comments?
> >
> > > @@ -239,6 +250,8 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > >  static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > >  {
> > >       struct ipv6_sr_hdr *srh;
> > > +     struct net_device *odev;
> > > +     struct net *net = dev_net(skb->dev);
> >
> > Order longest to shortest.
> Sorry. Will fix it.
> 
> >
> >
> > >
> > >       srh = get_and_validate_srh(skb);
> > >       if (!srh)
> > > @@ -246,7 +259,11 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > >
> > >       advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > >
> > > -     seg6_lookup_nexthop(skb, &slwt->nh6, 0);
> > > +     odev = dev_get_by_index_rcu(net, slwt->oif);
> > > +     if (!odev)
> > > +             goto drop;
> >
> > Are you doing this lookup just to make sure that oif exists?
> > Looks a little wasteful for fast path, but more importantly
> > it won't be backward compatible, right? See below..
> >
> Please see reply below.
> 
> > > +
> > > +     seg6_strict_lookup_nexthop(skb, &slwt->nh6, odev->ifindex, 0);
> > >
> > >       return dst_input(skb);
> > >
> >
> > > @@ -566,7 +583,8 @@ static struct seg6_action_desc seg6_action_table[] = {
> > >       },
> > >       {
> > >               .action         = SEG6_LOCAL_ACTION_END_X,
> > > -             .attrs          = (1 << SEG6_LOCAL_NH6),
> > > +             .attrs          = ((1 << SEG6_LOCAL_NH6) |
> > > +                                (1 << SEG6_LOCAL_OIF)),
> > >               .input          = input_action_end_x,
> > >       },
> > >       {
> >
> > If you set this parse_nla_action() will reject all
> > SEG6_LOCAL_ACTION_END_X without OIF.
> >
> > As you say the OIF is only required for using link local addresses,
> > so this change breaks perfectly legitimate configurations.
> >
> > Can we instead only warn about the missing OIF, and only do that when
> > nh is link local?
> >
> End.X is defined as an adjacency-sid and is used to select a specific link to a
> neighbor for both global and link-local addresses. The intention was
> to drop the
> packet even for global addresses if the route via the specific
> interface is not found.
> Alternatively(believe semantically correct for End.X definition) I
> could do a neighbor lookup
> for nexthop address over specific interface and send the packet out.
> 
> > Also doesn't SEG6_LOCAL_ACTION_END_DX6 need a similar treatment?
> 
> Yes. I will update the patch for End.DX6 based on the patch finalized for End.X.


-- 
Ahmed Abdelsalam <ahabdels.dev@gmail.com>
