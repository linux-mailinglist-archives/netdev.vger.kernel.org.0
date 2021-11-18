Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704EF4553CD
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242958AbhKREcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:32:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233419AbhKREcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:32:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3683961AA3;
        Thu, 18 Nov 2021 04:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637209776;
        bh=Ryl3spVfg/QfsgWJ21X8Z8KlZL/17W72PzpAnqosNHE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lGFwMu5kDO72o+gP+hggscQ6wosVUwwpjyBmxi8w4Wmb61L5EAAt4t46+cMaRYfOx
         hDFToJCeey4hm8oA9r247jZEiqbpXZ9JIrsoNW8WTnx8XhNzYCtmjbMYnz1BX003FN
         bdH9te0R4DKMh6U25Pk83gqUqM4vsXz3iCn0zt92CLERzQ6d9gMpQDqFyUa43/v0K+
         2xXjvuZj0gVSOR6PxuVHFmOeCcg9SEBnQibubh07lEHaE0BZTGgMFeGIOYxvofKVo4
         RMi16ufj0lX4L8fpEK2PHQerBGdNdXw6FNna+Ro1qg5Pyb5xYiDI0AfmfVwDKfOVmm
         LX3N28v/KSScw==
Date:   Wed, 17 Nov 2021 20:29:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Amit Cohen <amcohen@nvidia.com>
Subject: Re: [PATCH net v1] devlink: Don't throw an error if flash
 notification sent before devlink visible
Message-ID: <20211117202935.10fcf82d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1009da147a0254f01779a47610de8df83d18cefe.1637160341.git.leonro@nvidia.com>
References: <1009da147a0254f01779a47610de8df83d18cefe.1637160341.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 16:49:09 +0200 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The mlxsw driver calls to various devlink flash routines even before
> users can get any access to the devlink instance itself. For example,
> mlxsw_core_fw_rev_validate() one of such functions.
> 
> __mlxsw_core_bus_device_register
>  -> mlxsw_core_fw_rev_validate
>   -> mlxsw_core_fw_flash
>    -> mlxfw_firmware_flash
>     -> mlxfw_status_notify
>      -> devlink_flash_update_status_notify
>       -> __devlink_flash_update_notify
>        -> WARN_ON(...)  
> 
> It causes to the WARN_ON to trigger warning about devlink not registered.
> 
> Fixes: cf530217408e ("devlink: Notify users when objects are accessible")
> Reported-by: Danielle Ratson <danieller@nvidia.com>
> Tested-by: Danielle Ratson <danieller@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
