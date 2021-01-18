Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3902FAB44
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437839AbhARULV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437827AbhARUKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 15:10:53 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8CAC061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 12:10:11 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1l1aqi-00044y-Op; Mon, 18 Jan 2021 21:10:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1l1ai6-00FFRI-UL; Mon, 18 Jan 2021 21:01:10 +0100
Date:   Mon, 18 Jan 2021 21:01:10 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jonas Bonn <jonas@norrbonn.se>, Pravin B Shelar <pbshelar@fb.com>,
        netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next v5] GTP: add support for flow based tunneling API
Message-ID: <YAXpBoOOkGPi9rWI@nataraja>
References: <20210110070021.26822-1-pbshelar@fb.com>
 <20210116164642.4af4de8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8adc4450-c32d-625e-3c8c-70dbd7cbf052@norrbonn.se>
 <20210118092722.52c9d890@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <fea30896-e296-5eb3-4202-05a6bf2c1e8e@norrbonn.se>
 <20210118105657.72d9a6fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118105657.72d9a6fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub and list,

I also have my fair share of concerns about the "if the maintainers
don't ACK it, merge it in case of doubt" approach.  What is the point of
having a maintainer in the first place?

I don't really want to imagine the state of a codebase where everything
gets merged by default, unless somebody clearly and repeatedly actively
NACKs it.

Furthermore, for anyone who is maintaining a small portion of the code,
like a single driver, the suggested "two days" review cycle is simply
not possible.

Such people, like myself, are not full-time kernel developers, but
people who may only have a few hours per month to spend on maintenance
related duties of a rather small and exotic driver with few users.

We are not talking about a security related fix, or a bugfix, but the
introduction of massive changes (compared to the size of the gtp driver)
and new features.

I did see your ping for review, but the end of the year brings
unfortunately an incredible amount of work that needs to be done. I work
60+ hours each week as it is, and end of the year + financial year with
closing of accounts, changing of VAT rates, brexit related changes,
inventory counting, ... as a small business owner, I simply could not
provide feedback as quickly as I wanted.

I would have to build a kernel with that patch, then set up some
related test VMs, test with at least one existing userspace software
like OpenGGSN before I could ACK any change.  Given the low amount of
changes, and the lack of any commercial interest in funding, there is
no automatic test setup that involves the kernel GTP driver yet.  In
Osmocom we do have extensive automatic test suites for OpenGGSN, but
only with the userspace data plane, not with the gtp.ko kernel data
plane :(  SO this means manual testing, likely taking half a day to
get an idea about potential regressions.

> > Worse though, is the insinuation that anything unreviewed 
> > gets blindly merged...  No, the two day target should be for the merging 
> > of ACK:ed patches.
> 
> Well, certainly, the code has to be acceptable to the person merging it.

Indeed.  But given the highly exotic use case of the GTP driver, I would
say it needs at least an ACK from somebody who is actively using it,
to have some indication that there don't seem to be regressions at least
at first sight.

Compliance with kernel coding style and the general network architecture
alone is one part, but I would expect that virtually nobody except 2-3
people on this list have ever used the GTP kernel driver...

> Sorry, a week is far too long for netdev. If we were to wait that long
> we'd have a queue of 300+ patches always hanging around.

I would actually consider 300 in-flight patches a relatively small
number for such a huge project, but I don't want to get off-topic.

> > Sincerely frustrated because rebasing my IPv6 series on top of this mess 
> > will take days,
> 
> I sympathize, perhaps we should document the expectations we have so
> less involved maintainers know the expectations :(

As far as I remember, the IPv6 patches have appeared before, and I had
also hoped/wished for them to be merged before any large changes
(percentage of numbers of lines touched vs. size of the driver) like
this flow-based tunneling change.

Yes, I should have communicated better, that clearly was my fault.  But
I was operating under the assumption that code only gets merged if the
maintainers actually ACK it.  At least that's how I remember it from
my more active kernel hacking days ~20 years ago.

Regards,
	Harald

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
