Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB4E44D09
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbfFMUIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:08:55 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38426 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFMUIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 16:08:54 -0400
Received: by mail-qt1-f196.google.com with SMTP id n11so21948413qtl.5
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 13:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WtZSiqOyyYDm2KSvapb+1O5WsoKBBmhoVRpL4EkcewU=;
        b=O+dSn+T4rETNgoXo0DSXSdMM2Z1xp2JzcoUbtFg4dKb6pl2nexxHH9aH8jAyY0ly35
         LjwDMiBFjzdPMPbxGQwftZqUPb+XFGjKArf/3jfeNyutf433AtpVH19uN74qqUW3US/X
         7JxSx3N8gv9QtqroFEDLqMXHlUrfchLTdHhmEgOpPxtBF9rdB7FpbWIrOYLNvGOhHebU
         1V4qWNpezLbFqJNS4IUyVnUIylVkatv4dJOmVlsdb39AW4+1bhvTCgoJ1wCuQkABrc8k
         AdZW90v8h1zXARTCBgM+aWUTk/NSRMnvYj5SEtoy95HsyJnu4CKnzenLb0xJMlAsd3x2
         enow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WtZSiqOyyYDm2KSvapb+1O5WsoKBBmhoVRpL4EkcewU=;
        b=PWKVYqUrpgTuCvRUXWytmK1l2melqYl5y+k3zfyQd8l529D1l1ZlmQL2+OmB4Vvod/
         X+HphJy/BZ3KsuVDiEkgLUQeviEptRnVdEgt951L56pWQQaVhdUggHSv7i+yx3QWl7wm
         Yonm4w/yBJ9RPIfkS31hN91or4DVPyXnv6o9fFr3ZrHfBv+AVxh3bB1bhpyyFrfdWEYl
         d3ywW2rwedOtvfWSwS0crUC1zou7nVCTyZblFxUDzsSiuP3jH6wsGCikCQw8q/Ohr7PF
         unxpw1BDeRGFK93oSiF0/SBARlgh/zpTq7Vyx+WVX6TaId6hj8sakUX3HD9/oM8PWjno
         0tlg==
X-Gm-Message-State: APjAAAXsd1vzheIzQWFXnHxokbm3KLuZqgekWtg3rjsWXjCLiCG7o1iE
        KzgdCg/XDeGeCjN4vyIbwD0=
X-Google-Smtp-Source: APXvYqwqgBInLR375po/q578p/otUDtv7d0dO8Li4aGlHXPpDnhUSr8uphT7JxiwZNlYcks8ArwTKQ==
X-Received: by 2002:aed:3ec5:: with SMTP id o5mr49702895qtf.199.1560456532744;
        Thu, 13 Jun 2019 13:08:52 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:278e:68eb:7f4f:8f57:4b3a])
        by smtp.gmail.com with ESMTPSA id f3sm382027qkb.58.2019.06.13.13.08.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 13:08:51 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 1F63EC1BC6; Thu, 13 Jun 2019 17:08:49 -0300 (-03)
Date:   Thu, 13 Jun 2019 17:08:49 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        John Hurley <john.hurley@netronome.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Message-ID: <20190613200849.GH3436@localhost.localdomain>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
 <20190612180239.GA3499@localhost.localdomain>
 <20190612114627.4dd137ab@cakuba.netronome.com>
 <20190613083329.dmkmpl3djd3lewww@netronome.com>
 <97632F5C-6AB9-4B71-8DE6-A2A3ED02226A@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97632F5C-6AB9-4B71-8DE6-A2A3ED02226A@darbyshire-bryant.me.uk>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 09:09:47AM +0000, Kevin 'ldir' Darbyshire-Bryant wrote:
> 
> 
> > On 13 Jun 2019, at 10:33, Simon Horman <simon.horman@netronome.com> wrote:
> > 
> > On Wed, Jun 12, 2019 at 11:46:27AM -0700, Jakub Kicinski wrote:
> >> On Wed, 12 Jun 2019 15:02:39 -0300, Marcelo Ricardo Leitner wrote:
> >>> On Tue, May 28, 2019 at 05:03:50PM +0000, Kevin 'ldir' Darbyshire-Bryant wrote:
> >>> ...
> >>>> +static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
> >>>> +			   struct nlattr *est, struct tc_action **a,
> >>>> +			   int ovr, int bind, bool rtnl_held,
> >>>> +			   struct tcf_proto *tp,
> >>>> +			   struct netlink_ext_ack *extack)
> >>>> +{
> >>>> +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
> >>>> +	struct nlattr *tb[TCA_CTINFO_MAX + 1];
> >>>> +	struct tcf_ctinfo_params *cp_new;
> >>>> +	struct tcf_chain *goto_ch = NULL;
> >>>> +	u32 dscpmask = 0, dscpstatemask;
> >>>> +	struct tc_ctinfo *actparm;
> >>>> +	struct tcf_ctinfo *ci;
> >>>> +	u8 dscpmaskshift;
> >>>> +	int ret = 0, err;
> >>>> +
> >>>> +	if (!nla)
> >>>> +		return -EINVAL;
> >>>> +
> >>>> +	err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, NULL);
> >>>                                                                       ^^^^
> >>> Hi, two things here:
> >>> Why not use the extack parameter here? Took me a while to notice
> >>> that the EINVAL was actually hiding the issue below.
> >>> And also on the other two EINVALs this function returns.
> >>> 
> >>> 
> >>> Seems there was a race when this code went in and the stricter check
> >>> added by
> >>> b424e432e770 ("netlink: add validation of NLA_F_NESTED flag") and
> >>> 8cb081746c03 ("netlink: make validation more configurable for future
> >>> strictness").
> >>> 
> >>> I can't add these actions with current net-next and iproute-next:
> >>> # ~/iproute2/tc/tc action add action ctinfo dscp 0xfc000000 0x01000000
> >>> Error: NLA_F_NESTED is missing.
> >>> We have an error talking to the kernel
> >>> 
> >>> This also happens with the current post of act_ct and should also
> >>> happen with the act_mpls post (thus why Cc'ing John as well).
> >>> 
> >>> I'm not sure how we should fix this. In theory the kernel can't get
> >>> stricter with userspace here, as that breaks user applications as
> >>> above, so older actions can't use the more stricter parser. Should we
> >>> have some actions behaving one way, and newer ones in a different way?
> >>> That seems bad.
> >>> 
> >>> Or maybe all actions should just use nla_parse_nested_deprecated()?
> >>> I'm thinking this last. Yet, then the _deprecated suffix may not make
> >>> much sense here. WDYT?
> >> 
> >> Surely for new actions we can require strict validation, there is
> >> no existing user space to speak of..  Perhaps act_ctinfo and act_ct
> >> got slightly confused with the race you described, but in principle
> >> there is nothing stopping new actions from implementing the user space
> >> correctly, right?
> > 
> > FWIW, that is my thinking too.
> 
> 
> Hi everyone,
> 
> Apologies that somehow I seem to have caused a bit of trouble.  If need be

No need to be. :-)

  Marcelo
