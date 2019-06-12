Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D72E42F45
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfFLSqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:46:34 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38452 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfFLSqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:46:33 -0400
Received: by mail-qt1-f196.google.com with SMTP id n11so17503224qtl.5
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 11:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Eu1eNyk1PHWKW2tCzBK9wWgrl99NkviLeWksxrUxCh8=;
        b=J4wy3FsrrTiLhxoiMM4/kof6nUbhVPmRZ/w2djFMsa3K5dLjtShhrtxvBAr+Fp3LUh
         /FCc/euYyFvxArtRyWzQdBbMKpU0lrc0mB4rPPnlOS9ffTqNPU/1AmVdAlAEkyCypp/1
         do/FHCNsidjU0d//s/F7avOCrU2U3J7M1USqL9mKlZlPKRqJFfh2WEOvPMohgBA13sCh
         Wo5+C2j4WgP6SrKKVRnn/7bDC4l5oWh0RZbb3eTm4yAXo/Qm6+odMHgoAhkVpqmV7Tup
         GL0bUOheXKYDKG9Facew4VXmOt4Xld5L5Fk8JCWmvKX145JRznwk2lyRGguCgtAEDxpQ
         TGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Eu1eNyk1PHWKW2tCzBK9wWgrl99NkviLeWksxrUxCh8=;
        b=aGinqHx2nooXGi0ls56yvYoovJ7TERs50luAGX3Ow2eNzij4zxjElmN7+aUBAsAzHy
         0AhfPxulre825ZOJWNABoAGTt6ac/9cProb8IHOpKaw3dFQNmphnY99YFnYntFtm3++R
         /TIG7zvVZVjIsa7TGqgBKhv/bC9V8uf7YU2EXzKvV/KFAIbnjFmkeMwnAp3Pb3zeYGUA
         +vJ+13woLKcWFFNWMJ9TtM8ScA92oOMp1YIiA2pf+9LTXqvnvQsUIBCqjiLXB7TvLOqp
         oZ9XnzsHU/ycOdaeITixFf1he4uZcETBS67dK7KFXSbg3UeoIQatySb6dyI1W2GDjHaJ
         JtcA==
X-Gm-Message-State: APjAAAXfDolz4aqT0qg8SExVwOXNGBgPckJy8IS6n5bCkJmh0s0caOTh
        z8AcoFazOZoTPi6AGmY7enLrQg==
X-Google-Smtp-Source: APXvYqwMSd5NX7SeX43PZqdAbDK63cnLkbvIb5+ujmhA9YK/id8Zxd6ikFwPxUFk2k8s1e8DK5E1tA==
X-Received: by 2002:a0c:d295:: with SMTP id q21mr154869qvh.245.1560365192604;
        Wed, 12 Jun 2019 11:46:32 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i17sm202106qkl.71.2019.06.12.11.46.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 11:46:32 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:46:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        John Hurley <john.hurley@netronome.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>, dcaratti@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Message-ID: <20190612114627.4dd137ab@cakuba.netronome.com>
In-Reply-To: <20190612180239.GA3499@localhost.localdomain>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
        <20190612180239.GA3499@localhost.localdomain>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 15:02:39 -0300, Marcelo Ricardo Leitner wrote:
> On Tue, May 28, 2019 at 05:03:50PM +0000, Kevin 'ldir' Darbyshire-Bryant wrote:
> ...
> > +static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
> > +			   struct nlattr *est, struct tc_action **a,
> > +			   int ovr, int bind, bool rtnl_held,
> > +			   struct tcf_proto *tp,
> > +			   struct netlink_ext_ack *extack)
> > +{
> > +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
> > +	struct nlattr *tb[TCA_CTINFO_MAX + 1];
> > +	struct tcf_ctinfo_params *cp_new;
> > +	struct tcf_chain *goto_ch = NULL;
> > +	u32 dscpmask = 0, dscpstatemask;
> > +	struct tc_ctinfo *actparm;
> > +	struct tcf_ctinfo *ci;
> > +	u8 dscpmaskshift;
> > +	int ret = 0, err;
> > +
> > +	if (!nla)
> > +		return -EINVAL;
> > +
> > +	err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, NULL);  
>                                                                        ^^^^
> Hi, two things here:
> Why not use the extack parameter here? Took me a while to notice
> that the EINVAL was actually hiding the issue below.
> And also on the other two EINVALs this function returns.
> 
> 
> Seems there was a race when this code went in and the stricter check
> added by
> b424e432e770 ("netlink: add validation of NLA_F_NESTED flag") and
> 8cb081746c03 ("netlink: make validation more configurable for future
> strictness").
> 
> I can't add these actions with current net-next and iproute-next:
> # ~/iproute2/tc/tc action add action ctinfo dscp 0xfc000000 0x01000000
> Error: NLA_F_NESTED is missing.
> We have an error talking to the kernel
> 
> This also happens with the current post of act_ct and should also
> happen with the act_mpls post (thus why Cc'ing John as well).
> 
> I'm not sure how we should fix this. In theory the kernel can't get
> stricter with userspace here, as that breaks user applications as
> above, so older actions can't use the more stricter parser. Should we
> have some actions behaving one way, and newer ones in a different way?
> That seems bad.
> 
> Or maybe all actions should just use nla_parse_nested_deprecated()?
> I'm thinking this last. Yet, then the _deprecated suffix may not make
> much sense here. WDYT?

Surely for new actions we can require strict validation, there is
no existing user space to speak of..  Perhaps act_ctinfo and act_ct
got slightly confused with the race you described, but in principle
there is nothing stopping new actions from implementing the user space
correctly, right?
