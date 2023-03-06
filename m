Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8896AC1B9
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjCFNq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjCFNq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:46:57 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068DE2B60C
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 05:46:40 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id cy23so38613557edb.12
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 05:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678110398;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zgcaYDQbk/EoEhsuR0EVIipKoB8qZGB7arKPMPk6ZU4=;
        b=A4Q52isFrfv+fGAu01rxlFm8TgPr5fjjseLkAcSwBxF2pe11BtNnG0dQCWA3r54I0V
         i7EF+bAYyx3pLnhTzsq5qRl7yjoWj+/yyPnJQQ+ZK2kMKeMaBPgRYVthfKZ6jplnPgD9
         cDnRw/yis1uQ5RvLqetILpXduR41VPjmmHBw6jUzjif075HElbdudL9dT8d4rZeClwTq
         d8q43qr7gQQPhKnz/iyhzdg6hklfG5wMlfNWs0o/rVpTbj4EvjdqX0juk2wppi5T+MOw
         lWLvy49YZUcsWwcx2Ql3XzW3HZNeJC5JTlqCpZhdAArb/6V3sfhMp1y9WNds4o7wDZuy
         3hLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678110398;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zgcaYDQbk/EoEhsuR0EVIipKoB8qZGB7arKPMPk6ZU4=;
        b=NYzO7+1zSKENjDKrChFJdn8kJ3ZlYADYgbqu4Z6cvXvDVKbUeS9I4rlQ3gU1Ujzq9o
         BC0HKsTJCpaqtFmtgw1AWcm6iPdLWPWCk3/rBYMZOQMhUWeNNZN7nAx5Q+oXvo8m3ak9
         9cW0PqXgmjuXBHxdyme5mi0WCFgDoO+pgKeto1bYfKTMgFGZmJDQfjEyFqLrDTyw6/vZ
         1YXL6341XB5f+5qyQne8Uk6N2OUVOcUpjBgXm7bYLYvNF8hwC2rUyVVtFG+CR1ps8msN
         oNBaNsZa3IPfwIYMsh3g/UvgC4Xa2Tyyu3P16ehKu4LvPDGSNGqhIeM90xPjGs7hH4Oz
         QecA==
X-Gm-Message-State: AO0yUKUnBEgR85wxJzVtc7yRpTCh+61wNGXXGJ37qfFHDHxAesAinYJ7
        AHoEU6bXaY2qEiUOKY5ayxQ=
X-Google-Smtp-Source: AK7set+94qAyoUR9Rf9uB6XNEZ0vFFCF0M64zACx/d+6+pKNg9NJtC6TqesVA1V5E0xLzp9YXmX6eg==
X-Received: by 2002:a17:907:168e:b0:8fc:c566:dc67 with SMTP id hc14-20020a170907168e00b008fcc566dc67mr14009268ejc.64.1678110398339;
        Mon, 06 Mar 2023 05:46:38 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id jy24-20020a170907763800b008d7a8083dffsm4591438ejc.222.2023.03.06.05.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 05:46:38 -0800 (PST)
Date:   Mon, 6 Mar 2023 15:46:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jan Hoffmann <jan@3e8.eu>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     openwrt-devel@lists.openwrt.org,
        Sander Vanheule <sander@svanheule.net>,
        erkin.bozoglu@xeront.com
Subject: Re: [PATCH 0/6] realtek: fix management of mdb entries
Message-ID: <20230306134636.p2ufzoqk6kf3hu3y@skbuf>
References: <20230303214846.410414-1-jan@3e8.eu>
 <dd0c8abb-ebb7-8ea5-12ed-e88b5e310a28@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd0c8abb-ebb7-8ea5-12ed-e88b5e310a28@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 04, 2023 at 01:52:32PM +0300, Arınç ÜNAL wrote:
> On 4.03.2023 00:48, Jan Hoffmann wrote:
> > This series fixes multiple issues related to the L2 table and multicast
> > table. That includes an issue that causes corruption of the port mask
> > for unknown multicast forwarding, which can occur even when multicast
> > snooping is disabled.
> > 
> > With these patches, multicast snooping should be mostly working.
> > However, one important missing piece is forwarding of all multicast
> > traffic to multicast router ports (as specified in section 2.1.2-1 of
> > RFC4541). As far as I can see, this is a general issue that affects all
> > DSA switches, and cannot be fixed without changes to the DSA subsystem.
> 
> Do you plan to discuss this on the netdev mailing list with Vladimir?
> 
> Arınç

I searched for the patches and found them at
https://patchwork.ozlabs.org/project/openwrt/cover/20230303214846.410414-1-jan@3e8.eu/

I guess that what should be discussed is the topic of switch ports
attached to multicast routers, yes?

DSA does not (and has never) listen(ed) to the switchdev notifications
emitted for bridge ports regarding multicast routers (SWITCHDEV_ATTR_ID_PORT_MROUTER).
It has only listened for a while to the switchdev notifications for the
bridge itself as a multicast router (SWITCHDEV_ATTR_ID_BRIDGE_MROUTER),
and even that was done for a fairly strange reason and eventually got
reverted for breaking something - see commits 08cc83cc7fd8 and c73c57081b3d.

I personally don't have use cases for IP multicast routing / snooping,
so I would need some guidance regarding what is needed for things to
work smoothly. Also, to make sure that they keep working in the future,
one of the tests from tools/testing/selftests/net/forwarding/ which
exercises flooding towards multicast ports (if it exists) should be
symlinked to tools/testing/selftests/drivers/net/dsa/ and adapted until
it works. That's a pretty good way to get maintainers' attention on a
feature that they don't normally test.

It's not the first time I'm reading RFC4541, but due to a lack of any
practical applications surrounding me (and therefore also partial lack
of understanding), I keep forgetting what it says :)

Section 2.1.1.  IGMP Forwarding Rules (for the control path) says

   1) A snooping switch should forward IGMP Membership Reports only to
      those ports where multicast routers are attached.

how? I guess IGMP/MLD packets should reach the CPU via packet traps
(which cause skb->offload_fwd_mark to be unset), and from there, the
bridge software data path identifies the mrouter ports and forwards
control packets only there? What happens if the particular switch
hardware doesn't support IGMP/MLD packet identification and trapping?
Should the driver install a normal multicast forwarding rule for
all 224.0.0.X traffic (translated to MAC), and patch the tagging
protocol driver to set skb->offload_fwd_mark = 0 based on
eth_hdr(skb)->h_dest?

Then for the data path we have:

2.1.2.  Data Forwarding Rules

   1) Packets with a destination IP address outside 224.0.0.X which are
      not IGMP should be forwarded according to group-based port
      membership tables and must also be forwarded on router ports.

      This is the main IGMP snooping functionality for the data path.
      One approach that an implementation could take would be to
      maintain separate membership and multicast router tables in
      software and then "merge" these tables into a forwarding cache.

For my clarity, this means that *all* IP multicast packets must be
forwarded to the multicast router ports, be their addresses known
(bridge mdb entries exist for them) or unknown (flooded)?

What does the software bridge implementation do? Does it perform this
"merging" of tables for us? (for known MDB entries, does it also notify
them through switchdev on the mrouter ports?) Looking superficially at
the first-order callers of br_mdb_notify(), I don't get the impression
that the bridge has this logic?

Or am I completely off with my reading of RFC4541?

It's not obvious to me, after looking at the few implementations of
SWITCHDEV_ATTR_ID_PORT_MROUTER handlers in drivers, that this merging of
forwarding tables would be done anywhere within sight.

If someone could explain to me what are the expectations (we don't seem
to have a lot of good documentation) and how do the existing drivers work,
we can start discussing more concretely how the layering and API within
DSA should look like.

As a way to fix a bug quickly and get correct behavior, I guess there's
also the option of stopping to process multicast packets in hardware,
and configure the switch to always send any multicast to the CPU port
only. As long as the tagger knows to leave skb->offload_fwd_mark unset,
the bridge driver should know how to deal with those packets in
software, and forward them only to whom is interested. But the drawback
is that there is no forwarding acceleration involved. Maybe DSA should
have done that from the get go for drivers which didn't care about
multicast in particular, instead of ending up with this current situation
which appears to be slightly chaotic.
