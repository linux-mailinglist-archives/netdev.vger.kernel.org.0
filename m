Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E697026E5AA
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 21:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgIQTzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 15:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgIQTza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 15:55:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B2D2311B;
        Thu, 17 Sep 2020 19:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600372218;
        bh=8KeHBxxv5Dh+2Pll6g45+FuGNeEGtKQ/ia181GRnyL4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ypIODrQep7bqiJg3ueplqr5YrCnTmSNH0cwSvLLTIgWONpyxpgqh6PgVLm1Oexlmd
         PvkugbuZy2byzmw4dLkL9yGCMR4nO49kwlD8ZU2BKu5h8g6+YKHyigPc7oV3HJuBhv
         Z7q5vRZZPhpaSLXB3LvPBwyyglTuMciyKqIGtvIE=
Date:   Thu, 17 Sep 2020 12:50:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v4 net-next 3/5] netdevsim: devlink flash timeout
 message
Message-ID: <20200917125017.70641be9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200917030204.50098-4-snelson@pensando.io>
References: <20200917030204.50098-1-snelson@pensando.io>
        <20200917030204.50098-4-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Sep 2020 20:02:02 -0700 Shannon Nelson wrote:
> Add a simple devlink flash timeout message to exercise
> the message mechanism.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/netdevsim/dev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 32f339fedb21..4123550e3f6e 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -768,6 +768,8 @@ static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
>  						   component,
>  						   NSIM_DEV_FLASH_SIZE,
>  						   NSIM_DEV_FLASH_SIZE);
> +		devlink_flash_update_timeout_notify(devlink, "Flash timeout",
> +						    component, 81);
>  		devlink_flash_update_status_notify(devlink, "Flashing done",
>  						   component, 0, 0);
>  		devlink_flash_update_end_notify(devlink);

To mimic a more real scenario could we perhaps change the msg to "Flash
select" ?
