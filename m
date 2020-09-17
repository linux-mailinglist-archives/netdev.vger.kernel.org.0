Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B54C26D01F
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 02:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgIQApg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 20:45:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgIQApb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 20:45:31 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 20:45:31 EDT
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E91D0206A4;
        Thu, 17 Sep 2020 00:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600303011;
        bh=CTrACkA+Hifq4xvbEn5LW16kOT6gd6CN4XK12fnqVZg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fw1/uqvNUA5H06TR7mOWODnEV1izn1yqvlKUhJnKs2JRI+hPMgmuvDJtEn8jgVFuQ
         /np9ChMHMX+KonyC4haP5bKuejV2RZxgbosLKROgRp0/l3bNroIIeG55knuaTuK7tt
         IgK//zv+Ex2hPvAM4sfVASgrrn9852j8d8WDMbHY=
Date:   Wed, 16 Sep 2020 17:36:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: add and use message type for tunnel info
 reply
Message-ID: <20200916173649.73c1314f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200916230410.34FCE6074F@lion.mk-sys.cz>
References: <20200916230410.34FCE6074F@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 01:04:10 +0200 (CEST) Michal Kubecek wrote:
> Tunnel offload info code uses ETHTOOL_MSG_TUNNEL_INFO_GET message type (cmd
> field in genetlink header) for replies to tunnel info netlink request, i.e.
> the same value as the request have. This is a problem because we are using
> two separate enums for userspace to kernel and kernel to userspace message
> types so that this ETHTOOL_MSG_TUNNEL_INFO_GET (28) collides with
> ETHTOOL_MSG_CABLE_TEST_TDR_NTF which is what message type 28 means for
> kernel to userspace messages.
> 
> As the tunnel info request reached mainline in 5.9 merge window, we should
> still be able to fix the reply message type without breaking backward
> compatibility.
> 
> Fixes: c7d759eb7b12 ("ethtool: add tunnel info interface")
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Ouch, sorry & thanks!

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
