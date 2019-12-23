Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93808129B5D
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 23:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLWWF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 17:05:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:48238 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbfLWWFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 17:05:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7728CACEF;
        Mon, 23 Dec 2019 22:05:23 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id EEAC3E008B; Mon, 23 Dec 2019 23:05:16 +0100 (CET)
Date:   Mon, 23 Dec 2019 23:05:16 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v8 00/14] ethtool netlink interface, part 1
Message-ID: <20191223220516.GI21614@unicorn.suse.cz>
References: <cover.1577052887.git.mkubecek@suse.cz>
 <884c1d40-c0ca-37f2-4149-8c7189dbca3b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <884c1d40-c0ca-37f2-4149-8c7189dbca3b@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 08:52:01AM -0800, Florian Fainelli wrote:
> Hi Michal,
> 
> On 12/22/2019 3:45 PM, Michal Kubecek wrote:
> > This is first part of netlink based alternative userspace interface for
> > ethtool. It aims to address some long known issues with the ioctl
> > interface, mainly lack of extensibility, raciness, limited error reporting
> > and absence of notifications. The goal is to allow userspace ethtool
> > utility to provide all features it currently does but without using the
> > ioctl interface. However, some features provided by ethtool ioctl API will
> > be available through other netlink interfaces (rtnetlink, devlink) if it's
> > more appropriate.
> > 
> > The interface uses generic netlink family "ethtool" and provides multicast
> > group "monitor" which is used for notifications. Documentation for the
> > interface is in Documentation/networking/ethtool-netlink.rst file. The
> > netlink interface is optional, it is built when CONFIG_ETHTOOL_NETLINK
> > (bool) option is enabled.
> > 
> > There are three types of request messages distinguished by suffix "_GET"
> > (query for information), "_SET" (modify parameters) and "_ACT" (perform an
> > action). Kernel reply messages have name with additional suffix "_REPLY"
> > (e.g. ETHTOOL_MSG_SETTINGS_GET_REPLY). Most "_SET" and "_ACT" message types
> > do not have matching reply type as only some of them need additional reply
> > data beyond numeric error code and extack. Kernel also broadcasts
> > notification messages ("_NTF" suffix) on changes.
> 
> Thanks for re-posting these patches again, would you have ethtool and
> iproute2 branches with your latest ethnl patches applied? I did find
> your ethnl directory on your github, but it applies to a slightly oldish
> ethtool version. If you could maintain forks with an "ethnl" branch
> there, that would help greatly.

The iproute2 patch (adding display of permanent hardware address) is in
iproute2 "next" tree. As for (userspace) ethtool code, at the moment
it's not in a presentable state. As I wanted on getting v8 out as soon
as possible, I focused on making it work somehow so that I can test the
kernel patchset. So at the moment, the userspace series is still in the
form of an older one (implementing older UAPI) plus one bit "work in
progress" patch adapting it to current UAPI.

The userspace code also still doesn't look the way I would like it to.
I would like to spend some more time on it in second half of this week
and then I plan to also update the repository on github.

Michal 

> I will continue reviewing from there on, but also wanted to give it a
> spin to get a feel.
> 
> Thanks!
> -- 
> Florian
