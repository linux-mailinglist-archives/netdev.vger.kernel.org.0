Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD39BD82B
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 08:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404810AbfIYGNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 02:13:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:60796 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404606AbfIYGNx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 02:13:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECF45AF10;
        Wed, 25 Sep 2019 06:01:09 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 71B64E03CE; Wed, 25 Sep 2019 08:01:09 +0200 (CEST)
Date:   Wed, 25 Sep 2019 08:01:09 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: Fw: [Bug 204903] New: unable to create vrf interface when
 ipv6.disable=1
Message-ID: <20190925060109.GG22507@unicorn.suse.cz>
References: <20190919104628.05d9f5ff@xps13>
 <a15f9952-e5ed-8358-e28d-6325bf4d5801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a15f9952-e5ed-8358-e28d-6325bf4d5801@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 08:28:52PM -0600, David Ahern wrote:
> On 9/19/19 2:46 AM, Stephen Hemminger wrote:
> > 
> > 
> > Begin forwarded message:
> > 
> > Date: Wed, 18 Sep 2019 15:15:42 +0000
> > From: bugzilla-daemon@bugzilla.kernel.org
> > To: stephen@networkplumber.org
> > Subject: [Bug 204903] New: unable to create vrf interface when ipv6.disable=1
> > 
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=204903
> > 
> >             Bug ID: 204903
> >            Summary: unable to create vrf interface when ipv6.disable=1
> >            Product: Networking
> >            Version: 2.5
> >     Kernel Version: 5.2.14
> >           Hardware: All
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: Other
> >           Assignee: stephen@networkplumber.org
> >           Reporter: zhangyoufu@gmail.com
> >         Regression: No
> > 
> > `ip link add vrf0 type vrf table 100` fails with EAFNOSUPPORT when boot with
> > `ipv6.disable=1`. There must be somewhere inside `vrf_newlink` trying to use
> > IPv6 without checking availablity. Maybe `vrf_add_fib_rules` I guess.
> > 
> 
> ack. I'll take a look when I get a chance. Should be a simple fix.

Not sure if it's the only problem but vrf_fib_rule() checks
ipv6_mod_enabled() for AF_INET6 but not for RTNL_FAMILY_IP6MR.

Michal
