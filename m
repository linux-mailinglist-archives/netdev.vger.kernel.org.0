Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8131D557C
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgEOQEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726239AbgEOQEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:04:35 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4127C061A0C;
        Fri, 15 May 2020 09:04:34 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZcoI-009AnZ-2z; Fri, 15 May 2020 16:03:42 +0000
Date:   Fri, 15 May 2020 17:03:42 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Nate Karstens <nate.karstens@garmin.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Laight <David.Laight@aculab.com>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH v2] Implement close-on-fork
Message-ID: <20200515160342.GE23230@ZenIV.linux.org.uk>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515152321.9280-1-nate.karstens@garmin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 10:23:17AM -0500, Nate Karstens wrote:

> This functionality was approved by the Austin Common Standards
> Revision Group for inclusion in the next revision of the POSIX
> standard (see issue 1318 in the Austin Group Defect Tracker).

It penalizes every call of fork() in the system (as well as adds
an extra dirtied cacheline on each socket()/open()/etc.), adds
memory footprint and complicates the API.  All of that - to deal
with rather uncommon problem that already has a portable solution.

As for the Austin Group, the only authority it has ever had derives
from consensus between existing Unices.  "Solaris does it, Linux and
*BSD do not" translates into "Austin Group is welcome to take a hike".
BTW, contrary to the lovely bit of misrepresentation in that
thread of theirs ("<LWN URL> suggests that" != "someone's comment
under LWN article says it _appears_ that"), none of *BSD do it.

IMO it's a bad idea.

NAKed-by: Al Viro <viro@zeniv.linux.org.uk>
