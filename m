Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05ECA46D2BE
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhLHL6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhLHL6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:58:06 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B89C061746;
        Wed,  8 Dec 2021 03:54:34 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y13so7390595edd.13;
        Wed, 08 Dec 2021 03:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i+BBrV39yQN5ugDL1XnDCRdzJq+bmMUXwbNDLt1dK7Y=;
        b=KY1QngnD2VTzt0Df4igdAgobgMlSMK+SA8ysBTqYOdzpiTN43Ivd77+5oUF8iLtCEw
         XuUgZ9utb1tbtQ3z+vEUe+jwALsgyqNmgJdyoXj6VSl/WJoSNMsNI/L849G4cdwwwr8M
         CS1mGCxDM+VFf6v7jAdHwLfpWl1KIAvCmBYDC4fqX3neOX/JEBFrN8KTW2Z3963x2/Ic
         K+hcC28AWU1qCotas/YKd5BAQVhkdEmKhMrkLYP6dgGnZd0qJRlqlDbQGstZGgd47j51
         PGuBTuQMZCQ/HXGU8e3jtjD00IXpj1aVoGLxbW+0E5y48IgjHWi05MBbN4KILdxJQhmi
         qsQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i+BBrV39yQN5ugDL1XnDCRdzJq+bmMUXwbNDLt1dK7Y=;
        b=hWdKSBs9Awwa5LEdOfFNU+iwV3heKohtGOKqhZ+3WW7jC1S3Rr2LHF4es70KnkFmcL
         TgdRT+Hn1kKyxvi8tCDRCCHj1iPj/XWGQM+a8WD0ppCtsfmYSuuPn+qZ5aYkrCfu1qLE
         hDAMINSmmxhbqlr+fCstyBt8kXcJtIa6NIX2Z4WqsYtBEvoACCXOurs47nknnKu+avGU
         PBAMDSKkc8SoauNlz8zm67ATL8uFF5a/UIyRiErGFH3naBNWzYWtFU1Y/1v8XWfKvK+R
         OJHKr2O7XGUoZktgaPHXz9bQNBF8prCl6wfZU/JGWKT7amQfQywei7OBg9mxpKo1xSrH
         bDyg==
X-Gm-Message-State: AOAM531wg10iKCaV3HbIvBr9zUpgYrkI9biXz2OhjeeACze/gkAyhVHn
        OwXDRI2EhAV3rSuiduDfjQfsb7tuT5o=
X-Google-Smtp-Source: ABdhPJwL+LA/Xj5312O7J8oVYkq4iWX4X1G7GZnVhQveiMKDc3WsvztbL50aFt1QBO0AaK0O32RzSg==
X-Received: by 2002:aa7:dad5:: with SMTP id x21mr18234509eds.280.1638964473278;
        Wed, 08 Dec 2021 03:54:33 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id s2sm1478895ejn.96.2021.12.08.03.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:54:32 -0800 (PST)
Date:   Wed, 8 Dec 2021 13:54:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20211208115431.av6r4occxbocglgx@skbuf>
References: <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <Ya/esX+GTet9PM+D@lunn.ch>
 <20211207234736.vpqurmattqx4a76h@skbuf>
 <20211208000432.5nq47bjz3aqjvilp@skbuf>
 <20211208004051.bx5u7rnpxxt2yqwc@skbuf>
 <61afff9e.1c69fb81.92f07.6e7d@mx.google.com>
 <20211208010947.xavzcnih3xx4dxxs@skbuf>
 <61b0275d.1c69fb81.efd64.83fb@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61b0275d.1c69fb81.efd64.83fb@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:32:43AM +0100, Ansuel Smith wrote:
> On Wed, Dec 08, 2021 at 03:09:47AM +0200, Vladimir Oltean wrote:
> > On Wed, Dec 08, 2021 at 01:42:59AM +0100, Ansuel Smith wrote:
> > > On Wed, Dec 08, 2021 at 02:40:51AM +0200, Vladimir Oltean wrote:
> > > > On Wed, Dec 08, 2021 at 02:04:32AM +0200, Vladimir Oltean wrote:
> > > > > On Wed, Dec 08, 2021 at 01:47:36AM +0200, Vladimir Oltean wrote:
> > > > > > > 2) is harder. But as far as i know, we have an 1:N setup.  One switch
> > > > > > > driver can use N tag drivers. So we need the switch driver to be sure
> > > > > > > the tag driver is what it expects. We keep the shared state in the tag
> > > > > > > driver, so it always has valid data, but when the switch driver wants
> > > > > > > to get a pointer to it, it needs to pass a enum dsa_tag_protocol and
> > > > > > > if it does not match, the core should return -EINVAL or similar.
> > > > > > 
> > > > > > In my proposal, the tagger will allocate the memory from its side of the
> > > > > > ->connect() call. So regardless of whether the switch driver side
> > > > > > connects or not, the memory inside dp->priv is there for the tagger to
> > > > > > use. The switch can access it or it can ignore it.
> > > > > 
> > > > > I don't think I actually said something useful here.
> > > > > 
> > > > > The goal would be to minimize use of dp->priv inside the switch driver,
> > > > > outside of the actual ->connect() / ->disconnect() calls.
> > > > > For example, in the felix driver which supports two tagging protocol
> > > > > drivers, I think these two methods would be enough, and they would
> > > > > replace the current felix_port_setup_tagger_data() and
> > > > > felix_port_teardown_tagger_data() calls.
> > > > > 
> > > > > An additional benefit would be that in ->connect() and ->disconnect() we
> > > > > get the actual tagging protocol in use. Currently the felix driver lacks
> > > > > there, because felix_port_setup_tagger_data() just sets dp->priv up
> > > > > unconditionally for the ocelot-8021q tagging protocol (luckily the
> > > > > normal ocelot tagger doesn't need dp->priv).
> > > > > 
> > > > > In sja1105 the story is a bit longer, but I believe that can also be
> > > > > cleaned up to stay within the confines of ->connect()/->disconnect().
> > > > > 
> > > > > So I guess we just need to be careful and push back against dubious use
> > > > > during review.
> > > > 
> > > > I've started working on a prototype for converting sja1105 to this model.
> > > > It should be clearer to me by tomorrow whether there is anything missing
> > > > from this proposal.
> > > 
> > > I'm working on your suggestion and I should be able to post another RFC
> > > this night if all works correctly with my switch.
> > 
> > Ok. The key point with my progress so far is that Andrew may be right
> > and we might need separate tagger priv pointers per port and per switch.
> > At least for the cleanliness of implementation. In the end I plan to
> > remove dp->priv and stay with dp->tagger_priv and ds->tagger_priv.
> > 
> > Here's what I have so far. I have more changes locally, but the rest it
> > isn't ready and overall also a bit irrelevant for the discussion.
> > I'm going to sleep now.
> >
> 
> BTW, I notice we made the same mistake. Don't know if it was the problem
> and you didn't notice... The notifier is not ready at times of the first
> tagger setup and the tag_proto_connect is never called.
> Anyway sending v2 with your suggestion applied.

I didn't go past the compilation stage yesterday. Anyway, now that you
mention it, I remember Tobias hitting this issue as well when he worked
on changing tagging protocol via device tree, and this is why
dsa_switch_setup_tag_protocol() exists.  I believe that's where we'd
need to call ds->ops->connect_tag_proto from, like this:

static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
{
	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
	struct dsa_switch_tree *dst = ds->dst;
	struct dsa_port *cpu_dp;
	int err;

	if (tag_ops->proto == dst->default_proto)
		goto connect;

	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
		rtnl_lock();
		err = ds->ops->change_tag_protocol(ds, cpu_dp->index,
						   tag_ops->proto);
		rtnl_unlock();
		if (err) {
			dev_err(ds->dev, "Unable to use tag protocol \"%s\": %pe\n",
				tag_ops->name, ERR_PTR(err));
			return err;
		}
	}

connect:
	if (ds->ops->connect_tag_protocol) {
		err = ds->ops->connect_tag_protocol(ds, tag_ops->proto);
		if (err) {
			dev_err(ds->dev,
				"Unable to connect to tag protocol \"%s\": %pe\n",
				tag_ops->name, ERR_PTR(err));
			return err;
		}
	}

	return 0;
}
