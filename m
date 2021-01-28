Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C9C306BE6
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 05:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhA1EHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 23:07:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231177AbhA1EGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 23:06:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C75764D9F;
        Thu, 28 Jan 2021 03:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611806049;
        bh=Fc/OLi4G72gGhAOgUf0bys+awPTFAAr1/5bJLVfrCXw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gwZMjDUp2qbITP/plUbt7swYMJaf32sjNCJDDFJkUZTSrZP98Fo9/a3w6lz5lkA84
         PIBmmDk8aZB5L0ClaLywR6YIaLyIV0XoEp2fikPceShKC2YcbBr2Uo54o+Ee3rvaYa
         tT3OoSc3VkSQNGiucweuxFSDLDp0/3zzRYuY+z6429NqmkZTmSPFZjl0OvW9qgJIMl
         1WaDuZFzF3iZ9BXYzyM9OvWAOTxSf6TwJ3TmKUqe29bUoNC15SwqimRjDi7pSWpeS1
         1LKwpllpYHhTVjAVMCRRtcpKayqEuNtHbZOtkThjKspRP+l59g4daF77ktA4HDUSfA
         SXUfViI/tESlw==
Date:   Wed, 27 Jan 2021 19:54:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Aya Levin <ayal@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next 01/14] devlink: Add DMAC filter generic packet trap
Message-ID: <20210127195408.3c3a5788@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126232419.175836-2-saeedm@nvidia.com>
References: <20210126232419.175836-1-saeedm@nvidia.com>
        <20210126232419.175836-2-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 15:24:06 -0800 Saeed Mahameed wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> Add packet trap that can report packets that were dropped due to
> destination MAC filtering.
> 
> Signed-off-by: Aya Levin <ayal@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  Documentation/networking/devlink/devlink-trap.rst | 5 +++++
>  include/net/devlink.h                             | 3 +++
>  net/core/devlink.c                                | 1 +
>  3 files changed, 9 insertions(+)
> 
> diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
> index d875f3e1e9cf..1dd86976ecf8 100644
> --- a/Documentation/networking/devlink/devlink-trap.rst
> +++ b/Documentation/networking/devlink/devlink-trap.rst
> @@ -480,6 +480,11 @@ be added to the following table:
>       - ``drop``
>       - Traps packets that the device decided to drop in case they hit a
>         blackhole nexthop
> +   * - ``dmac_filter``
> +     - ``drop``
> +     - Traps incoming packets that the device decided to drop in case

s/in case/because/

> +       the destination MAC is not configured in the MAC table

... and the interface is not in promiscuous mode

> +

Double new line

>  Driver-specific Packet Traps
>  ============================

Fix that up and applied from the list.
