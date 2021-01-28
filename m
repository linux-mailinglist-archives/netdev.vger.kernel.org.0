Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04317307F3B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhA1ULC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhA1UIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 15:08:09 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5917CC061786
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 12:07:54 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id hs11so9665594ejc.1
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 12:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/aXg9jzQFFxJdr6SEvlIIeEM1b3GZ4JRYmfH6vWooU4=;
        b=ShLBYM/7JZi7GC6F8328SNaAFvKkrkVPAYlMqawzFTE85CE2nzjZDw6Jkir5E/U0sN
         PH8J+NXrWmvEyvZBhv6AFYqlOpi1PW1TyX7n+yELwve95Bqo3zp/vWQgxkQoCvZQdIWv
         jczeqPt/DO20ex0ccn9agakrCnDfZR8KoIU9nQqGn+tYoLtQWTscHxmWdw2Zb0WRbaxW
         IvFWSpOnkGmwyqwYkCS6knuj0kPjO/YpbjHDKi+dHf1ZfILmeqWh+op/ecar8DVidgEx
         4eSfOZGlH5NIKVXyv9+h9Scqy8og1AUaPcW3NT62dm7lYt2JbZJyBWxrP4+CZ1NvBG4s
         pqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/aXg9jzQFFxJdr6SEvlIIeEM1b3GZ4JRYmfH6vWooU4=;
        b=kDWs0fH19/LJbA5epLLeVtCo5GRcDjSBUm4NCIXBDMumPzafRD1OcOYc0QiznT8Jm+
         ovMqB6v3ph63svjpBVm/FyouwBbXicRvi4/SORLATAKIDUs8mh4WxukTT7dq5xr4ozZc
         V/ZCyqRFnV8gJH/2ZgEgP145dOsTg1Spc29G+w8tucSrW34KiEoOkE8Givx96R2BF3OZ
         mCYJctDsNkNoTexoT/7v96kdy9lJ8vT7q/0wyml/kzUv3N/iTiK5O8AkPZsqUuMrVOdq
         hPkPJW8Y4ZzUeqG02UVNBjb7k8Y5M/QqqYcBbnUZ8ZgqnZE5D57ayL06CS1qqEzw3wr8
         V7NA==
X-Gm-Message-State: AOAM531vkobkIokTLVVFWjhOLwI5d/CaEp34no8Qa/nNT/P2k0LUBTw3
        8LvcpwNHAN+0H00SD4+RHTg=
X-Google-Smtp-Source: ABdhPJysKeYNv0MF+3Z7YPW/xjTt22nrR1EoIICnP8W2QEInJmW8M4c5C3XpWKnzKAPFSWnjqnBl9Q==
X-Received: by 2002:a17:906:2ccb:: with SMTP id r11mr1153667ejr.39.1611864473053;
        Thu, 28 Jan 2021 12:07:53 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm2734885ejb.119.2021.01.28.12.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 12:07:52 -0800 (PST)
Date:   Thu, 28 Jan 2021 22:07:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v7 net-next 08/11] net: dsa: allow changing the tag
 protocol via the "tagging" device attribute
Message-ID: <20210128200750.gnmgxm4ojudqbtli@skbuf>
References: <20210125220333.1004365-1-olteanv@gmail.com>
 <20210125220333.1004365-9-olteanv@gmail.com>
 <20210127173044.65de6aba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127173044.65de6aba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 05:30:44PM -0800, Jakub Kicinski wrote:
> > +const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
> > +{
> > +	const struct dsa_device_ops *ops = NULL;
> > +	struct dsa_tag_driver *dsa_tag_driver;
> > +
> > +	mutex_lock(&dsa_tag_drivers_lock);
> > +	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
> > +		const struct dsa_device_ops *tmp = dsa_tag_driver->ops;
> > +
> > +		if (!sysfs_streq(buf, tmp->name))
> > +			continue;
> > +
> > +		ops = tmp;
> > +		break;
> > +	}
> > +	mutex_unlock(&dsa_tag_drivers_lock);
>
> What's protecting from the tag driver unloading at this very moment?

The user's desire to not crash the kernel, and do something productive
instead? Anyway, I've fixed this in my tree and I will repost soon.

> > +	info.tag_ops = old_tag_ops;
> > +	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_DEL, &info);
> > +	if (err)
> > +		goto out_unlock;
> > +
> > +	info.tag_ops = tag_ops;
> > +	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_SET, &info);
>
> Not sure I should bother you about this or not, but it looks like
> Ocelot does allocations on SET, so there is a chance of not being
> able to return to the previous config, leaving things broken.
>
> There's quite a few examples where we use REPLACE instead of set,
> so that a careful driver can prep its resources before it kills
> the previous config. Although that's not perfect either because
> we'd rather have as much of that logic in the core as possible.
>
> What are your thoughts?

On one hand, my immediate thoughts are:
(a) out of the 2 ocelot taggers, only tag_8021q can fail, the NPI tagger
    always returns 0. So either the .set_tag_protocol will always
    succeed, or we'll always be able to restore the initial tag
    protocol.
(b) changing the tag protocol is done with network down, so if you can't
    allocate some memory for some TCAM rules, you're probably in the
    wrong business anyway once the ports go back up and you'll start
    receiving network traffic.

But either way, I could create a single .replace_tag_protocol callback
instead of the current .set_tag_protocol and .del_tag_protocol, and have
the felix driver still call felix_set_tag_protocol privately from
.setup(), and .felix_del_tag_protocol from .teardown(). That's a
relatively non-invasive change which would make zero practical
difference to my use case due to point (a) above.

However I will not pretend that having an "atomic" .replace_tag_protocol
is going to ensure a consistent state of the tagger, because it won't.
In the case where you have a DSA switch tree with 7 switches, and
.replace_tag_protocol fails for the 5th, what do you do? You create a
transactional model, with a prepare and commit phase, right? But I am
doing some memory allocations from callbacks of external API
(struct dsa_8021q_ops felix_tag_8021q_ops), so unless I have a crystal
ball to guess what parameters will tag_8021q call me with (so I could
preallocate), my options are:
- propagate the prepare and commit phase to tag_8021q, which I'm not
  going to.
- do all of my setup in the prepare phase, the one that can return
  errors, and privately restore my tagger e.g. from tag_8021q mode to
  NPI mode if any allocation failed. Aka just do a facade thing with the
  whole prepare/commit model.
And having a prepare/commit model means that you do memory allocation in
prepare so that you can use it during commit, which means that there
must be some structure which holds the transactional storage of the
driver. All is well except that the preparation phase of the 5th switch
out of 7 may still fail, so you should also have an unprepare method
that performs the resource deallocation for the first four. Normally the
unprepare should not fail, but if I implement it the only I said I can
(i.e. I do all my configuration in the prepare phase, and return in
commit), then for all practical purposes, the unprepare phase will be a
.replace_tag_protocol in the opposite direction. Aka an operation that
can still fail.

If you have a better idea of how I can make dsa_tree_change_tag_proto
guarantee that all switches in the tree end up with the same tagger,
while not sabotaging the only driver implementing that API, do let me
know.

> > +static bool dsa_switch_tag_proto_match(struct dsa_switch *ds, int port,
> > +				       struct dsa_notifier_tag_proto_info *info)
> > +{
> > +	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> > +		return true;
> > +
> > +	return false;
>
> return dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port) ?

Thought about it, decided to keep the format similar to the rest of the
_match functions.

> > +}
> > +
> > +static int dsa_switch_tag_proto_del(struct dsa_switch *ds,
> > +				    struct dsa_notifier_tag_proto_info *info)
> > +{
> > +	int port;
> > +
> > +	/* Check early if we can replace it, so we don't delete it
> > +	 * for nothing and leave the switch dangling.
> > +	 */
> > +	if (!ds->ops->set_tag_protocol)
> > +		return -EOPNOTSUPP;
> > +
> > +	/* The delete method is optional, just the setter is mandatory */
> > +	if (!ds->ops->del_tag_protocol)
> > +		return 0;
> > +
> > +	ASSERT_RTNL();
> > +
> > +	for (port = 0; port < ds->num_ports; port++) {
> > +		if (dsa_switch_tag_proto_match(ds, port, info)) {
> > +			ds->ops->del_tag_protocol(ds, port,
> > +						  info->tag_ops->proto);
>
> invert condition, save indentation

Thought about it, saving indentation does not save line count, and it is
actually more intuitive to read this way, not to mention more similar
with other notifier handlers from switch.c.
