Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4B84690B6
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 08:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbhLFHUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 02:20:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40624 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238367AbhLFHU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 02:20:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC57CB80FD4
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 07:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0F5C341C2;
        Mon,  6 Dec 2021 07:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638775019;
        bh=V8wVeVw3tN9o1lu8xgCQxndNZjjwpnhjNOQgUfPuEJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cu9GnYbT3gZHCwkTgLbWWZ/cvw75bvRDa7kJg61+c4/JrDRdac9pr8csKuh7EdgsS
         VkZJQr9MMJVv18x9ZmsCxjO/IdgbIWQROamHbYAXBZTERdijbZypojCTutFFs+ZXYy
         cGflCkj5FH+TdSi6yPWAD4ZoW7I4o8K2Ctc0gFmeXLTmfT25qRI7rHrf4u/MzQdQN+
         UjCIwz9zUgxYjOcJawOwgkc3PTKo0Qkwcbl+MvA4iCBxxIajc9yvxduzpvPK6kvniU
         Qz28cWXedemR55QS3bueXPHkgA42jxGLXIYvrh7sbYrtqSYtJ5LGHic/htyY1+gyI2
         An0BQYVw3Ni8Q==
Date:   Mon, 6 Dec 2021 09:16:55 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net] devlink: fix netns refcount leak in
 devlink_nl_cmd_reload()
Message-ID: <Ya245+a9vajIjYvU@unreal>
References: <20211205192822.1741045-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211205192822.1741045-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 05, 2021 at 11:28:22AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While preparing my patch series adding netns refcount tracking,
> I spotted bugs in devlink_nl_cmd_reload()
> 
> Some error paths forgot to release a refcount on a netns.
> 
> To fix this, we can reduce the scope of get_net()/put_net()
> section around the call to devlink_reload().
> 
> Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
> Fixes: dc64cc7c6310 ("devlink: Add devlink reload limit option")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Moshe Shemesh <moshe@mellanox.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@nvidia.com>
> ---
>  net/core/devlink.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
