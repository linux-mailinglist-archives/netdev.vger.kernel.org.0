Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B234425CBC
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241663AbhJGUAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241500AbhJGT76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 15:59:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CACC760F6E;
        Thu,  7 Oct 2021 19:58:01 +0000 (UTC)
Date:   Thu, 7 Oct 2021 15:58:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v3 1/5] devlink: Reduce struct devlink exposure
Message-ID: <20211007155800.1ff26948@gandalf.local.home>
In-Reply-To: <39692583a2aace1b9e435399344f097c72073522.1633589385.git.leonro@nvidia.com>
References: <cover.1633589385.git.leonro@nvidia.com>
        <39692583a2aace1b9e435399344f097c72073522.1633589385.git.leonro@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Oct 2021 09:55:15 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> +void *devlink_priv(struct devlink *devlink)
> +{
> +	BUG_ON(!devlink);

Do we really want to bring down the kernel in this case?

Can't we just have:

	if (WARN_ON(!devlink))
		return NULL;
?

Same for the below as well.

-- Steve

> +	return &devlink->priv;
> +}
> +EXPORT_SYMBOL_GPL(devlink_priv);
> +
> +struct devlink *priv_to_devlink(void *priv)
> +{
> +	BUG_ON(!priv);
> +	return container_of(priv, struct devlink, priv);
> +}
> +EXPORT_SYMBOL_GPL(priv_to_devlink);
> +
> +struct device *devlink_to_dev(const struct devlink *devlink)
> +{
> +	return devlink->dev;
> +}
> +EXPORT_SYMBOL_GPL(devlink_to_dev);
> +
