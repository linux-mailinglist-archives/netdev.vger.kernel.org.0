Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4D52DD912
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 20:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgLQTGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 14:06:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgLQTGg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 14:06:36 -0500
Date:   Thu, 17 Dec 2020 11:05:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608231956;
        bh=++RLJTrfniFmNbiJ+nge0uT4aigDm3ZuuS3CMp4H04A=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=gYy9SUVM2qguDxmsBqZcFoH5Pg+mMQEMPa62PWA6Ur7UYTNSxKzP3HrnEIg6W+AQX
         dDLefP0rJvempcLqSsCm+KQOpi58qD7YN87NpUKVpEy2XDqzmN+0npODwY/ADIlJhN
         DaLm+HCDsU+7WPy9NZeGkWptNDlXR1LMx1Tpvgs/1pf3PtiXe1VyuVC/8A9QKecDvD
         hYkmvcV1FCXXi1WT/hgrlcMyhBZoZtFNvZKi41+w7SFoZj1QVZqrTlddibjS/duhpk
         tM6YQk+mbzqv7V1XzOQKWyW9+31NZ3p/9jXltLgbgiLxKedB1+4BVzT2Nh7Q57+ONj
         WJi77gxWyYWRg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH net] nfp: move indirect block cleanup to flower app stop
 callback
Message-ID: <20201217110554.050095d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216145701.30005-1-simon.horman@netronome.com>
References: <20201216145701.30005-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 15:57:01 +0100 Simon Horman wrote:
> The indirect block cleanup may cause control messages to be sent
> if offloaded flows are present. However, by the time the flower app
> cleanup callback is called txbufs are no longer available and attempts
> to send control messages result in a NULL-pointer dereference in
> nfp_ctrl_tx_one().
> 
> This problem may be resolved by moving the indirect block cleanup
> to the stop callback, where txbufs are still available.
> 
> As suggested by Jakub Kicinski and Louis Peens.
> 
> Fixes: a1db217861f3 ("net: flow_offload: fix flow_indr_dev_unregister path")
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> Signed-off-by: Louis Peens <louis.peens@netronome.com>

Applied, thank you!
