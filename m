Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B7A4D4E21
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240489AbiCJQHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240425AbiCJQG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:06:56 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D832186460;
        Thu, 10 Mar 2022 08:05:46 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id b15so3498333edn.4;
        Thu, 10 Mar 2022 08:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QMLpysDwZRJXsNTpOkpDQ0qqZGLPweA1Fp1BJeeZZvI=;
        b=oHPETXL5JN1QV7aFH3+N2eY8CWrcsu+R0DVVt2ZByX/8mu3OLyaeO3eZsUX4BRYU5U
         s41dt5O7HaBXuXjQ1sVNfNGIgc9V9Tkv66jutuNQvQoqm0rRNNCcwcGV1byYwLOuS+XN
         JCLSMsVh/p9p6V1GN6XYnM2K+shhher1ibq8AHXVcpNay8a31yg34Bw6iAT330zV7DmX
         XhaYjQc6DlTo1GINt+ZYWiGh+XfU7uSC72DuqHn1OcycxO0+HxlzCUbjXuYbLKXHRZE+
         otqwrXiBgabxVQliFDJyZnOT0svdPKrkSH9saw2pY1MwOThlgTocR9fZY393LWgNPhkZ
         gXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QMLpysDwZRJXsNTpOkpDQ0qqZGLPweA1Fp1BJeeZZvI=;
        b=AQKFRavfgJkWpcNTizOTU7AUK03vONOvGugpzStkx7pgPBPKwAdutsaZkIeZ69wQSR
         3REbWW6SY9QdbZtjP45wq8/E38FguN8shK2FtyRlJ3jxjffK1X8TZ/zGRYW59oklXqcV
         +XYaZj4Nw151w6QL7pE2oiqYnRAWV1PpSWBB6chxMS6KQN552JduTT6WTTcBxEu2V6Yi
         INOl9oTmXOiSV6eYaSW/Dp8obiXwOIBcUc1USwJkrWqQIgyDVfNUOHLefKy3hU5zewen
         EkK+LFxyWaghLWqAVyZhIoXIcO0bcrzuJ/2oI8MIqYzbESILkcFWjb4Hj83IgT1PG6b0
         k43A==
X-Gm-Message-State: AOAM530E4125N39HYU0MZ5icIHkVLJTiJtfkzniJZI5RvjGxWI6OUIx2
        bMvNqoDSetaCYDegVzbNyw00S1LP0yg=
X-Google-Smtp-Source: ABdhPJxmMcwpl4Myrm2lOmxRAOis1Le2+RYH2Z4MXZZDErK+3wrDSnBGVatkRZhgH/43FVAgJawRiQ==
X-Received: by 2002:a05:6402:12d7:b0:415:ced2:389d with SMTP id k23-20020a05640212d700b00415ced2389dmr5156046edx.197.1646928344437;
        Thu, 10 Mar 2022 08:05:44 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id j5-20020a056402238500b00416c32d548esm444879eda.59.2022.03.10.08.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 08:05:43 -0800 (PST)
Date:   Thu, 10 Mar 2022 18:05:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20220310160542.dihodbfxnexyjo2d@skbuf>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-4-schultz.hans+netdev@gmail.com>
 <20220310142836.m5onuelv4jej5gvs@skbuf>
 <865yolg8d7.fsf@gmail.com>
 <20220310150717.h7gaxamvzv47e5zc@skbuf>
 <86sfrpergs.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86sfrpergs.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 04:51:15PM +0100, Hans Schultz wrote:
> On tor, mar 10, 2022 at 17:07, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Thu, Mar 10, 2022 at 04:00:52PM +0100, Hans Schultz wrote:
> >> >> +	brport = dsa_port_to_bridge_port(dp);
> >> >
> >> > Since this is threaded interrupt context, I suppose it could race with
> >> > dsa_port_bridge_leave(). So it is best to check whether "brport" is NULL
> >> > or not.
> >> >
> >> Would something like:
> >> if (dsa_is_unused_port(chip->ds, port))
> >>         return -ENODATA;
> >> 
> >> be appropriate and sufficient for that?
> >
> > static inline
> > struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
> > {
> > 	if (!dp->bridge)
> > 		return NULL;
> >
> > 	if (dp->lag)
> > 		return dp->lag->dev;
> > 	else if (dp->hsr_dev)
> > 		return dp->hsr_dev;
> >
> > 	return dp->slave;
> > }
> >
> > Notice the "dp->bridge" check. The assignments are in dsa_port_bridge_create()
> > and in dsa_port_bridge_destroy(). These functions assume rtnl_mutex protection.
> > The question was how do you serialize with that, and why do you assume
> > that dsa_port_to_bridge_port() returns non-NULL.
> >
> > So no, dsa_is_unused_port() would do absolutely nothing to help.
> 
> I was thinking in indirect terms (dangerous I know :-).

Sorry, I don't understand what you mean by "indirect terms". An "unused
port" is one with 'status = "disabled";' in the device tree. I would
expect that you don't need to handle FDB entries towards such a port!

You have a port receiving traffic with an unknown {MAC SA, VID}.
When the port is configured as locked by the bridge, this traffic will
generate ATU miss interrupts. These will be handled in an interrupt
thread that is scheduled to be handled some time in the future.
In between the moment when the packet is received and the moment when
the interrupt thread runs, a user could run "ip link set lan0 nomaster".
Then the interrupt thread would notify the bridge about these entries,
point during which a bridge port no longer exists => NULL pointer dereference.
By taking the rtnl_lock() and then checking whether dsa_port_to_bridge_port()
is NULL, you figure out whether the interrupt handler ran completely
before dsa_port_bridge_leave(), or completely after dsa_port_bridge_leave().

> 
> But wrt the nl lock, I wonder when other threads could pull the carpet
> away under this, and so I might have to wait till after the last call
> (mv88e6xxx_g1_atu_loadpurge) to free the nl lock?

That might make sense. It means: if the user runs "ip link set lan0 nomaster",
wait until I've notified the bridge and installed the entry to my own
ATU, so that they're in sync. Then, del_nbp() -> br_fdb_delete_by_port()
would come in, find that entry notified by us (I think!) and remove it.
If you call rtnl_unlock() too early, it might be possible that the ATU
entry remains lingering (unless I'm missing some subtle implicit
serialization based on mv88e6xxx_reg_lock() or similar).
