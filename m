Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1313F27EA16
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 15:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbgI3NjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 09:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgI3NjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 09:39:05 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66283C061755;
        Wed, 30 Sep 2020 06:39:05 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1kNcJy-0000MR-98; Wed, 30 Sep 2020 15:39:02 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1kNcJj-0010WT-W4; Wed, 30 Sep 2020 15:38:48 +0200
Date:   Wed, 30 Sep 2020 15:38:47 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Richard Haines <richard_c_haines@btinternet.com>
Cc:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        stephen.smalley.work@gmail.com, paul@paul-moore.com,
        pablo@netfilter.org, jmorris@namei.org
Subject: Re: [PATCH 3/3] selinux: Add SELinux GTP support
Message-ID: <20200930133847.GD238904@nataraja>
References: <20200930094934.32144-1-richard_c_haines@btinternet.com>
 <20200930094934.32144-4-richard_c_haines@btinternet.com>
 <20200930110153.GT3871@nataraja>
 <33cf57c9599842247c45c92aa22468ec89f7ba64.camel@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33cf57c9599842247c45c92aa22468ec89f7ba64.camel@btinternet.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

On Wed, Sep 30, 2020 at 01:25:27PM +0100, Richard Haines wrote:

> As in the reply to Pablo, I did it for no particular reason other than
> idle curiosity, and given the attempted move to Open 5G I thought
> adding MAC support might be useful somewhere along the line.

thanks, I only saw your related mail earlier today.

Unfortunately there's a lot of talk about "open source" in the context of 5G
but as far as I can tell (and I'm involved in open source cellular full-time
for a decade now) it's mostly marketing.  And if something is relased, it's
some shared source license that doesn't pass the OSI OSD nor DFSG, ...

In any case, this is off-topic here.

I think it would not be the best idea to merge SELinux support patches for the
GTP kernel driver without thoroughly understanding the use case, and/or having
some actual userspace implementations that make use of them.  In the end, we may
be introducing code that nobody uses, and which only turns out to be insufficient
for what later actual users may want.

So like Pablo suggested, it would probably be best to focus on
submitting / merging features for things that are either well-defined (e.g.
specified in a standerd), and/or have existing userspace implementations.

> I guess the '*_pkt' permissions would cover PDP for 3G and PDR
> & FAR for 5G ?.

The permissions would probably cover those two items, yes.  As you
probably know, we currently don't have any ability in the kernel GTP
driver to map "external" IP traffic to TEID based on anything except the
destination IP address.  This is sufficient for all 2G and 3G use cases,
and should also cover many 4G use cases.  However, if you want to go for
different dedicated bearers and QoS classes, for sure you need something
more advanced in terms of classification of packets.

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
