Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30997140AB
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 17:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfEEPiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 11:38:15 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33232 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbfEEPiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 11:38:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id s18so3384028wmh.0
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 08:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fy/+9PXUKyRSU3Sv4uDN/frulT1UbpBoDta1NyU3LdQ=;
        b=hduuH+iSAU4/CVQrL7ssm4qd11xpv2CA4DyCQIy+HM465sIQZ6ZsIPTavO3PWIEVe7
         shm/PtBOkNJw7zWZWP89SYwGRgLmctdoCIIYbJN1vx46XJcGKMn17wQl+tFnbXm2TN+m
         3HxQX0Rv2tn0hMkBeSs/yGegbgD2D+CLaQesc0lw5FSwEOJxpXdCpC1I33mOJwGLQiXm
         oNp3PUhOxUwztG5tL7jy4Hm3NszLSXeexvAMAMcTFozMJUyZ/CP48TtCTEzC8mEyoWNR
         /Zsx5d+0Whp4+ubWJ68WkQvO4CjvSK+uaIp9Py11WpI0WFRC0h0yGJHfzU6tsomkhoXz
         dp3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fy/+9PXUKyRSU3Sv4uDN/frulT1UbpBoDta1NyU3LdQ=;
        b=jZ3pjiMBJNxOYquz3Q2tUfEJxcg/IZ0z0bMsJ6PD2PYUQNa8+7SscDBuEoqowxAEXg
         D2jbAev6OHA1dutqt3vRhve8pCQOVdKi8Ygue2Ec6P+8jhUBB1vHomsUkBM7ZxNtlIql
         QnR7ahasC2ixro3akijnzpXp464U4QZDfp53/hvB41YC61aJi490v93SNXpvptxWTLQ9
         +fYBuliVWjjlZxAj6ibcnNaM0ENcChg1tWmhYgJcKAbI7Cv0iY+CEpu8aVkEjpqhu0MC
         FjS4ASmOrw+06tyyvU0VQWFrvL+0PQ2A0RzpMjwZr+8Qrot1f6isrdDMEQtz562FUEJO
         dAgQ==
X-Gm-Message-State: APjAAAWfaKXeUBcGYO/Aba3rCA3waP646Ldqbn7M+uqDOGlSbzGler5i
        cGZ71hx67Je3+sG2J9Cv9QbFWQ==
X-Google-Smtp-Source: APXvYqw32MU1u5TyV3l9ZszLQl4E/BFX1qSFocwUwnDBfagYdFGX80lqzBtJWF6uezFt5ni+C8iLnQ==
X-Received: by 2002:a1c:ce:: with SMTP id 197mr13117099wma.105.1557070692320;
        Sun, 05 May 2019 08:38:12 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t81sm10786453wmb.47.2019.05.05.08.38.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 08:38:12 -0700 (PDT)
Date:   Sun, 5 May 2019 17:38:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [net-next 07/15] net/mlx5: Issue SW reset on FW assert
Message-ID: <20190505153811.GB31501@nanopsycho.orion>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-8-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505003207.1353-8-saeedm@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 05, 2019 at 02:33:18AM CEST, saeedm@mellanox.com wrote:
>From: Feras Daoud <ferasda@mellanox.com>
>
>If a FW assert is considered fatal, indicated by a new bit in the health
>buffer, reset the FW. After the reset go through the normal recovery
>flow. Only one PF needs to issue the reset, so an attempt is made to
>prevent the 2nd function from also issuing the reset.
>It's not an error if that happens, it just slows recovery.
>
>Signed-off-by: Feras Daoud <ferasda@mellanox.com>
>Signed-off-by: Alex Vesker <valex@mellanox.com>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
>Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>---
> .../ethernet/mellanox/mlx5/core/diag/crdump.c |  13 +-
> .../net/ethernet/mellanox/mlx5/core/health.c  | 157 +++++++++++++++++-
> .../net/ethernet/mellanox/mlx5/core/main.c    |   1 +
> .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
> include/linux/mlx5/device.h                   |  10 +-
> include/linux/mlx5/driver.h                   |   1 +
> 6 files changed, 176 insertions(+), 8 deletions(-)
>

[...]


>+void mlx5_error_sw_reset(struct mlx5_core_dev *dev)
>+{
>+	unsigned long end, delay_ms = MLX5_FW_RESET_WAIT_MS;
>+	int lock = -EBUSY;
>+
>+	mutex_lock(&dev->intf_state_mutex);
>+	if (dev->state != MLX5_DEVICE_STATE_INTERNAL_ERROR)
>+		goto unlock;
>+
>+	mlx5_core_err(dev, "start\n");

Leftover?
