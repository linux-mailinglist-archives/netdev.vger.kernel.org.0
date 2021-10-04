Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08A2421AC5
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 01:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhJDXkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 19:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234995AbhJDXj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 19:39:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BBA161131;
        Mon,  4 Oct 2021 23:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633390689;
        bh=7FQS12BJyVfLKwhmHhNpViQ6vnbzhOByhHXQRuhEDAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=czVI7h9CjVBBLcioO417aQterEvQMv2y8n4apS/L+6qdf8SIZ6u4Nz/6uHWRBsif9
         mYXIuuNprKHnMY7WfFqhRGbzQhUOG8w63Ao88tw449K8hQkJ7eF7JEsssh4xX4jvtY
         NO78FsgvvBDfIoQgm5JAEnTy1BtrgRHKuc+gyoEBKD32aOQpFsiMuxFXwksDvmkYf7
         yxqaDDhDR7r1QUftffK/a+UhWHD3XUoZV7l+b4hbI5g4wk+riiZaGuK870TGKuWp2f
         i/lkH7Qr4CYdFeBuXJNAbfAHVUmgB2opyha4vLjDvFKe+1qq7uqeL4Li8L++U1XAi6
         Q+7YfGr84SZCg==
Date:   Mon, 4 Oct 2021 16:38:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v2 1/5] devlink: Reduce struct devlink exposure
Message-ID: <20211004163808.437ea8f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d21ebe6fde8139d5630ef4ebc9c5eb6ed18b0e3b.1633284302.git.leonro@nvidia.com>
References: <cover.1633284302.git.leonro@nvidia.com>
        <d21ebe6fde8139d5630ef4ebc9c5eb6ed18b0e3b.1633284302.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  3 Oct 2021 21:12:02 +0300 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The declaration of struct devlink in general header provokes the
> situation where internal fields can be accidentally used by the driver
> authors. In order to reduce such possible situations, let's reduce the
> namespace exposure of struct devlink.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

100% subjective but every time I decided to hide a structure definition
like this I came to regret it later. The fact there is only one minor
infraction in drivers poking at members seems to prove this is not in
fact needed.
