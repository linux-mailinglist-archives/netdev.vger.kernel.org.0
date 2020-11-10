Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61142ACA46
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgKJBSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgKJBSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 20:18:36 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81690206ED;
        Tue, 10 Nov 2020 01:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604971115;
        bh=mFmQP6MVnu8HNriG/I7mYUuPLO04iLDlS9GjAN4ePwo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=w3nE8N2N6wHemOlUVXAuOv0BWy2YpmP466JNYcr7ObFaRtq+ZWWsWJ1h3t5GW2OXi
         yRffNMjoWJtEbwsSzgOgvlHdkHIe8WgCXY20aRxXuySQJno0rwh13yFwZV60y25iVU
         Ex6akSEGJ7YEirjhM+knsTaxcG4z4npSuCMburWY=
Date:   Mon, 9 Nov 2020 17:18:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] ethtool: netlink: add missing
 netdev_features_change() call
Message-ID: <20201109171834.2a66c56d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109140002.g45cbbroshyjotdh@lion.mk-sys.cz>
References: <ahA2YWXYICz5rbUSQqNG4roJ8OlJzzYQX7PTiG80@cp4-web-028.plabs.ch>
        <20201109140002.g45cbbroshyjotdh@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 15:00:02 +0100 Michal Kubecek wrote:
> On Sun, Nov 08, 2020 at 12:46:15AM +0000, Alexander Lobakin wrote:
> > After updating userspace Ethtool from 5.7 to 5.9, I noticed that
> > NETDEV_FEAT_CHANGE is no more raised when changing netdev features
> > through Ethtool.
> > That's because the old Ethtool ioctl interface always calls
> > netdev_features_change() at the end of user request processing to
> > inform the kernel that our netdevice has some features changed, but
> > the new Netlink interface does not. Instead, it just notifies itself
> > with ETHTOOL_MSG_FEATURES_NTF.
> > Replace this ethtool_notify() call with netdev_features_change(), so
> > the kernel will be aware of any features changes, just like in case
> > with the ioctl interface. This does not omit Ethtool notifications,
> > as Ethtool itself listens to NETDEV_FEAT_CHANGE and drops
> > ETHTOOL_MSG_FEATURES_NTF on it
> > (net/ethtool/netlink.c:ethnl_netdev_event()).
> > 
> > From v1 [1]:
> > - dropped extra new line as advised by Jakub;
> > - no functional changes.
> > 
> > [1] https://lore.kernel.org/netdev/AlZXQ2o5uuTVHCfNGOiGgJ8vJ3KgO5YIWAnQjH0cDE@cp3-web-009.plabs.ch
> > 
> > Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET request")
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>  
> 
> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Applied, thanks!
