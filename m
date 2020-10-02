Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1674281ED4
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 01:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgJBXEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 19:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBXEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 19:04:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD2962074B;
        Fri,  2 Oct 2020 23:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601679863;
        bh=wchb8rjkjVP2Ub7v/OSfMn7lefDi7YZt+nvLk2nYH00=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pI6NnxXw1oRnzkARPkW+Iuzz5ssenhrH1yGwxuWEh/O+qzcgmVmMFPd0BuH04aNvr
         dU7/qV+Jz+XooMWD4xZZKZn+VdNiwm87h0xhZf4G7RlyIVf09xUkwxFQB5Nx/K0w2f
         ifQzgeqvSFWfsrzgiNIfnR5VpJc8zOs/pmz1hb5w=
Date:   Fri, 2 Oct 2020 16:04:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH net-next 0/8] net: ethernet: ti: am65-cpsw: add multi
 port support in mac-only mode
Message-ID: <20201002160421.59363229@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c758885c-6834-e689-2356-81291e4628e8@ti.com>
References: <20201001105258.2139-1-grygorii.strashko@ti.com>
        <20201001160847.3b5d91f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c758885c-6834-e689-2356-81291e4628e8@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Oct 2020 12:56:43 +0300 Grygorii Strashko wrote:
> On 02/10/2020 02:08, Jakub Kicinski wrote:
> > On Thu, 1 Oct 2020 13:52:50 +0300 Grygorii Strashko wrote:  
> >> This series adds multi-port support in mac-only mode (multi MAC mode) to TI
> >> AM65x CPSW driver in preparation for enabling support for multi-port devices,
> >> like Main CPSW0 on K3 J721E SoC or future CPSW3g on K3 AM64x SoC.
> >>
> >> The multi MAC mode is implemented by configuring every enabled port in "mac-only"
> >> mode (all ingress packets are sent only to the Host port and egress packets
> >> directed to target Ext. Port) and creating separate net_device for
> >> every enabled Ext. port.  
> > 
> > Do I get it right that you select the mode based on platform? Can the
> > other mode still be supported on these platforms?
> > 
> > Is this a transition to normal DSA mode where ports always have netdevs?
>
> The idea here is to start in multi mac mode by default, as we still
> have pretty high demand for this. Then, and we are working on it, the
> switchdev mode is going to be introduces (not DSA). The switch
> between modes will happen by using devlink option - the approach is
> similar to what was used for Sitara CPSW cpsw_new.c driver [1].

What's unclear from the patches is whether the default configuration
for already supported platforms will change?

All the patches sound like they are "in preparation for support of K3
J721E" etc. So this is just code restructuring with no user-visible
changes?
