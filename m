Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC8529DE7D
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbgJ1WSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731733AbgJ1WRn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A67C6218AC;
        Wed, 28 Oct 2020 01:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603847013;
        bh=tDJG2gYu10quU01UV+ZK8m8Jw8xFmREbiM5m1omsM2Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yJAr4ByrZfFjMpjK/cfWn5ph0dnKCffNmEAPWw3+pxxizfPVS5NM+I0OHyc9wI6An
         o85CUDvUv3J+OZL/n4q2K/6WxI0HEJ6psOqVDdS+DCDPmhLkDD3bAAQ+mWAFzy4s8m
         Lul4tcohxfdxSAgOhFYYBhcPrevL0d4QTjEl1BRA=
Date:   Tue, 27 Oct 2020 18:03:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net v1] net: protect tcf_block_unbind with block lock
Message-ID: <20201027180331.42ece60f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201026123327.1141066-1-leon@kernel.org>
References: <20201026123327.1141066-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 14:33:27 +0200 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The tcf_block_unbind() expects that the caller will take block->cb_lock
> before calling it, however the code took RTNL lock and dropped cb_lock
> instead. This causes to the following kernel panic.
 
> Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> v1:
>  * Returned rtnl_lock()
> v0:
> https://lore.kernel.org/netdev/20201026060407.583080-1-leon@kernel.org

Applied, thanks. 

I'm surprised you put the lore link in the notes. Maybe the usefulness
of the change log could be argued, but the number of times I tried to
find a specific revision and couldn't...
