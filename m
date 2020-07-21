Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23081228915
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbgGUTXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728700AbgGUTXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 15:23:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBE0F206F2;
        Tue, 21 Jul 2020 19:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595359428;
        bh=Aix6mTpnSAglLsD98UCa78Jma661H4nz7ffy6E8zcQ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QcAGr0PjQAlEbL8ifayGPFMJ37F5Py7SMrslrVhh4yJi0w1IqBrJUUqGr56uVbGUy
         cn9ohPbB6cMCp/xqUKWFaBnxwgXZATbppLsgjqo4IDf7E2JnYYLrR+XMNw3BTq4od5
         w/p2RI8FfOPeuvvInMVjQ/mj1VOJpBHsjPkjWICk=
Date:   Tue, 21 Jul 2020 12:23:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/6] Add adaptive interrupt coalescing
Message-ID: <20200721122347.105249b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
References: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 10:55:16 +0300 Claudiu Manoil wrote:
> Apart from some related cleanup patches, this set
> introduces in a straightforward way the support needed
> to enable and configure interrupt coalescing for ENETC.
> 
> Patch 5 introduces the support needed for configuring the
> interrupt coalescing parameters and for switching between
> moderated (int. coalescing) and per-packet interrupt modes.
> When interrupt coalescing is enabled the Rx/Tx time
> thresholds are configurable, packet thresholds are fixed.
> To make this work reliably, patch 5 uses the traffic
> pause procedure introduced in patch 2.
> 
> Patch 6 adds DIM (Dynamic Interrupt Moderation) to implement
> adaptive coalescing based on time thresholds, for the Rx 'channel'.
> On the Tx side a default optimal value is used instead, optimized for
> TCP traffic over 1G and 2.5G links.  This default 'optimal' value can
> be overridden anytime via 'ethtool -C tx-usecs'.
> 
> netperf -t TCP_MAERTS measurements show a significant CPU load
> reduction correlated w/ reduced interrupt rates. For the
> measurement results refer to the comments in patch 6.
> 
> v2: Replaced Tx DIM with predefined optimal value, giving
> better results. This was also suggested by Jakub (cc).
> Switched order of patches 4 and 5, for better grouping.

Acked-by: Jakub Kicinski <kuba@kernel.org>
