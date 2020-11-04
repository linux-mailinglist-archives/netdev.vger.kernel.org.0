Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2802A5B6B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgKDBA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:00:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbgKDBA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:00:26 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04D06223C7;
        Wed,  4 Nov 2020 01:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604451626;
        bh=n5kS/l+By+vyTHPoAF6evCAUmVASF/FjLWJeuvVYAH0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vt25M8jfi9Wy3/Qb9ezm0EQnkG/BIqaEGRD39PxKrzCqYEXDLV7LHKipvnSg+HqI0
         iARO2ddrp19dtuor9VSlCuDqqDIWhNxOu0w7BgbLggBCJ1G44o3em1RF1G2cGpMRvs
         +uyQ80oqo2eYMkFdICG+uljV7iPfGlFxRVHVvwi0=
Date:   Tue, 3 Nov 2020 17:00:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org
Subject: Re: [PATCH net v2] net: openvswitch: silence suspicious RCU usage
 warning
Message-ID: <20201103170025.11dc0d3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160439190002.56943.1418882726496275961.stgit@ebuild>
References: <160439190002.56943.1418882726496275961.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 09:25:49 +0100 Eelco Chaudron wrote:
> Silence suspicious RCU usage warning in ovs_flow_tbl_masks_cache_resize()
> by replacing rcu_dereference() with rcu_dereference_ovsl().
> 
> In addition, when creating a new datapath, make sure it's configured under
> the ovs_lock.
> 
> Fixes: 9bf24f594c6a ("net: openvswitch: make masks cache size configurable")
> Reported-by: syzbot+9a8f8bfcc56e8578016c@syzkaller.appspotmail.com
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
> v2: - Moved local variable initialization above lock
>     - Renamed jump label to indicate unlocking

Applied, thanks!
