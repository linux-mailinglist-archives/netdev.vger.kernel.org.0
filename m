Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BD2424B30
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhJGAkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230322AbhJGAkf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:40:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5B2461177;
        Thu,  7 Oct 2021 00:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633567123;
        bh=N3SATjHZrhsDavQKVCAb0RqlxJGbsZDYgLhpBlyC2vY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s8Bqs5/n82dHLmNzRNwTfG6aXJ/9vVsBjk7h0DJjjz83yC/nUe0Cqpl8cXt96nCxn
         dOJYxS+zF4bzyqtV3KNVpMq++hnv8nh88fsfaBbJzY3Bik+XhElCyafdOSnL0tsVvt
         5GpxQsqu5nkijUruPqXeqnUVDM1OQ7cFXOrpJVu+5X9sj3Rzs5kx6H0J0j9aMpX1SG
         /2se3AcWUhfEB1Jrh20gZuMqe2NYHi8FLPicID1QYtnCVou7Q8Y5Wkg2nMjysNdJT+
         9zeeVqGEU534TXv5jG2arZUsRN2U4TKuumNutkuVoRzCc1bZO2f7s2sH9SLuewBG8m
         gjsUmMx5vZSmQ==
Date:   Wed, 6 Oct 2021 17:38:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] flow_offload: add l4 port range match
Message-ID: <20211006173841.63dde6f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1633525615-6341-1-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1633525615-6341-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Oct 2021 16:06:54 +0300 Volodymyr Mytnyk wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> Current flow offload API doen't allow to offload l4 port range
> match dissector (FLOW_DISSECTOR_KEY_PORTS_RANGE) in the driver,
> as is no relevant data struct that will hold this information
> and pass it to the driver.
> 
> Thus, to make offload of l4 port range possible by other drivers
> add dedicated dissector port range struct to get min and max
> value provided by user.
> 
> - add flow_dissector_key_ports_range to store
>   l4 port range match.
> - add flow_match_ports_range key/mask
> 
> tc cmd example:
>     tc qd add dev PORT clsact
>     tc filter add dev PORT protocol ip ingress \
>         flower skip_sw ip_proto udp src_port 2-37 action drop
> 
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>

A driver implementation needs to be posted in the same series.
Otherwise it's an API with no in-tree user. Let's consider this
posting an RFC.
