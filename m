Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB5928099E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733133AbgJAVs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgJAVs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 17:48:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A25BD206A2;
        Thu,  1 Oct 2020 21:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601588905;
        bh=rSGqLL2DLu/LIhJ1Y1yw5Jy/3doK/XXXnkrtN7Y6pRk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tPNcXsuMEIzBslP5iFEZtx+SKDl/2QJeWqaMKnPTe8Xq19ZQ43uJ66WAH9cxqsanD
         +k1XvTrTDDDzKDJLzViAHtbpguhOFarrI4/nf50qDAFUWO22XYoYZTqlsVTasT9G3d
         weXJJhU5upJsqI9nPgfR8sYwYP1rngTixqdPjq4A=
Date:   Thu, 1 Oct 2020 14:48:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 05/16] devlink: Add remote reload stats
Message-ID: <20201001144824.4bb6d160@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1601560759-11030-6-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
        <1601560759-11030-6-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Oct 2020 16:59:08 +0300 Moshe Shemesh wrote:
> Add remote reload stats to hold the history of actions performed due
> devlink reload commands initiated by remote host. For example, in case
> firmware activation with reset finished successfully but was initiated
> by remote host.
> 
> The function devlink_remote_reload_actions_performed() is exported to
> enable drivers update on remote reload actions performed as it was not
> initiated by their own devlink instance.
> 
> Expose devlink remote reload stats to the user through devlink dev get
> command.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

>  		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
> -			if (!devlink_reload_action_is_supported(devlink, i) ||
> +			if ((!is_remote && !devlink_reload_action_is_supported(devlink, i)) 

I see the point of these checks now, I guess it would have been cleaner
if they were added in this patch, but no big deal.
