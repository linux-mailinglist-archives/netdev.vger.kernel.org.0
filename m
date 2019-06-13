Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372854439A
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730908AbfFMQao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:30:44 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36232 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730911AbfFMIdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 04:33:33 -0400
Received: by mail-ed1-f67.google.com with SMTP id k21so26635754edq.3
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 01:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T61V0Kj1vZs5sCf1ogi/xx++YggBR8U9WTqu2bpYO+s=;
        b=pI1tGc6b7L9/omeE4sIi7bqlYWR8spzLk38xbSyYpwoIc1JR1VwdLLN9sxYmKQQLb8
         BDA/LaHAo9s8XJWAaJq4SLfO2Sem0YRXDvwvXxP0YdV1UMJlzLdgIHO7/FJN4zxwNA2R
         E7GS9itoW0pe+V/Ry/9j8Rk6rhayzLd++plQsYctleRckzECJ3CZ1ZJP71F8UYCKm85B
         6YSssFVaW+vObpcWQUDhVWx9Kf0Vw9nSFvDIN0o/MqOSyBVEOM18Q3/In9yx3le93vK5
         H3/DiGA1Y0cvC/CXNg/lU4/l9m7iufo9WDTppQZ8+LiwyFr6ul6r5ZqzOyOlta1yOpHn
         5eKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T61V0Kj1vZs5sCf1ogi/xx++YggBR8U9WTqu2bpYO+s=;
        b=p2Tlht2TJpxCwkXEgF72NyJccvpCk842YzYdHw3ES1sPilf1S0QYUqDC6VrRjHuKFH
         o0uX4f1ZqFBkDnIvJSwU1o6/neXUF1crPlvcN6nmUtZPkp1VjB9NBInxZz6OLrU28FMA
         WpE1NdoOg6wurHXXk8/QZuOSEYJ3GuJhU1dloA/ef+L0qZOOh12UCDhkLQah+OQLFYii
         RuGyf16pE6Gi2mt0zricNnmD4uz9hAWjNDUS+NvIVW04h37DaX5mNhXyC3yQ9XDG1J5E
         Ng/PH29OpEnLh+4K5BS7W+8XATJzaZroFX1Gve7LcY7UPBU1fLRh79kEdt0kT+7hv3k6
         eU3g==
X-Gm-Message-State: APjAAAXIbLlIonzsTA1C4dYilLqFtItc/bPTsKv8WfXfyKLvkaGX6qSk
        uUBnQ1jsBbCpm2d2VgpFxKdFCg==
X-Google-Smtp-Source: APXvYqz+RLg7N5R8sftQaNXuJySoTZoPhydiE4e5zoSUL86YVjyDSlUYkHpMvHzaEM+eixoR1qLz2w==
X-Received: by 2002:a50:9116:: with SMTP id e22mr58951174eda.161.1560414811605;
        Thu, 13 Jun 2019 01:33:31 -0700 (PDT)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id x30sm704310edc.53.2019.06.13.01.33.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Jun 2019 01:33:31 -0700 (PDT)
Date:   Thu, 13 Jun 2019 10:33:30 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        John Hurley <john.hurley@netronome.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>, dcaratti@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Message-ID: <20190613083329.dmkmpl3djd3lewww@netronome.com>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
 <20190612180239.GA3499@localhost.localdomain>
 <20190612114627.4dd137ab@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612114627.4dd137ab@cakuba.netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 11:46:27AM -0700, Jakub Kicinski wrote:
> On Wed, 12 Jun 2019 15:02:39 -0300, Marcelo Ricardo Leitner wrote:
> > On Tue, May 28, 2019 at 05:03:50PM +0000, Kevin 'ldir' Darbyshire-Bryant wrote:
> > ...
> > > +static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
> > > +			   struct nlattr *est, struct tc_action **a,
> > > +			   int ovr, int bind, bool rtnl_held,
> > > +			   struct tcf_proto *tp,
> > > +			   struct netlink_ext_ack *extack)
> > > +{
> > > +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
> > > +	struct nlattr *tb[TCA_CTINFO_MAX + 1];
> > > +	struct tcf_ctinfo_params *cp_new;
> > > +	struct tcf_chain *goto_ch = NULL;
> > > +	u32 dscpmask = 0, dscpstatemask;
> > > +	struct tc_ctinfo *actparm;
> > > +	struct tcf_ctinfo *ci;
> > > +	u8 dscpmaskshift;
> > > +	int ret = 0, err;
> > > +
> > > +	if (!nla)
> > > +		return -EINVAL;
> > > +
> > > +	err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, NULL);  
> >                                                                        ^^^^
> > Hi, two things here:
> > Why not use the extack parameter here? Took me a while to notice
> > that the EINVAL was actually hiding the issue below.
> > And also on the other two EINVALs this function returns.
> > 
> > 
> > Seems there was a race when this code went in and the stricter check
> > added by
> > b424e432e770 ("netlink: add validation of NLA_F_NESTED flag") and
> > 8cb081746c03 ("netlink: make validation more configurable for future
> > strictness").
> > 
> > I can't add these actions with current net-next and iproute-next:
> > # ~/iproute2/tc/tc action add action ctinfo dscp 0xfc000000 0x01000000
> > Error: NLA_F_NESTED is missing.
> > We have an error talking to the kernel
> > 
> > This also happens with the current post of act_ct and should also
> > happen with the act_mpls post (thus why Cc'ing John as well).
> > 
> > I'm not sure how we should fix this. In theory the kernel can't get
> > stricter with userspace here, as that breaks user applications as
> > above, so older actions can't use the more stricter parser. Should we
> > have some actions behaving one way, and newer ones in a different way?
> > That seems bad.
> > 
> > Or maybe all actions should just use nla_parse_nested_deprecated()?
> > I'm thinking this last. Yet, then the _deprecated suffix may not make
> > much sense here. WDYT?
> 
> Surely for new actions we can require strict validation, there is
> no existing user space to speak of..  Perhaps act_ctinfo and act_ct
> got slightly confused with the race you described, but in principle
> there is nothing stopping new actions from implementing the user space
> correctly, right?

FWIW, that is my thinking too.
