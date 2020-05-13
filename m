Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD091D1FC5
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 22:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390185AbgEMUAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 16:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732650AbgEMUAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 16:00:13 -0400
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3CE1C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 13:00:13 -0700 (PDT)
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1jYxY2-00022P-Nv; Wed, 13 May 2020 16:00:10 -0400
Received: from linville-x1.hq.tuxdriver.com (localhost.localdomain [127.0.0.1])
        by linville-x1.hq.tuxdriver.com (8.15.2/8.14.6) with ESMTP id 04DJwEND668294;
        Wed, 13 May 2020 15:58:14 -0400
Received: (from linville@localhost)
        by linville-x1.hq.tuxdriver.com (8.15.2/8.15.2/Submit) id 04DJwEVF668293;
        Wed, 13 May 2020 15:58:14 -0400
Date:   Wed, 13 May 2020 15:58:14 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH ethtool 0/2] improve the logic of fallback from netlink
 to ioctl
Message-ID: <20200513195814.GH650568@tuxdriver.com>
References: <cover.1588112572.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1588112572.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 12:30:00AM +0200, Michal Kubecek wrote:
> At the moment, ethtool falls back to ioctl implementation whenever either
> in response to request type not implemented in kernel or netlink interface
> is unavailable or netlink request fails with EOPNOTSUPP error code. This is
> not perfect as EOPNOTSUPP can have different meanings and we only want to
> fall back if it is caused by kernel lacking netlink implementation of the
> request. In other cases, we would needlessly repeat the same failure trying
> both netlink and ioctl.
> 
> These two patches improve the logic to avoid such duplicate failures and
> improve handling of cases where fallback to ioctl is impossible for other
> reasons (e.g. wildcard device name or no ioctl handler).
> 
> Michal Kubecek (2):
>   refactor interface between ioctl and netlink code
>   netlink: use genetlink ops information to decide about fallback
> 
>  ethtool.c          |  51 +++---------
>  netlink/extapi.h   |  14 ++--
>  netlink/monitor.c  |  15 +++-
>  netlink/netlink.c  | 193 ++++++++++++++++++++++++++++++++++++++-------
>  netlink/netlink.h  |   6 ++
>  netlink/parser.c   |   7 ++
>  netlink/settings.c |   7 ++
>  7 files changed, 220 insertions(+), 73 deletions(-)

Thanks (belatedly) -- queued for next release!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
