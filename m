Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE9E261F7D
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732592AbgIHUEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730397AbgIHPXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:23:51 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C28C0610E5
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:12:46 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id z22so22741655ejl.7
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3sHaSQTtEpVgxZUhYIXCbmOjlv1gJeOQFw7S/Ryj3Pc=;
        b=N+McjpguiDc1n2EPL915Ma7152SAViSTeH5vg+8E2QpOulQuWlPUZ3LyTfQVBU+7m6
         +M9vLe8Pja0QusLmo+vTDbDgyyLzhiOiEypL8xPNu6N3QXXgG3MrnudvKDgVjprnS0Hm
         QCzY2WSk02O3OpNLKbcRu6PBeXb1bqiUtfIPErkmpkBjggnmbeJCXAwk/9J8LEGHiZ0o
         QfRVvy6MUF4lPe/vMD8uXnFrvsoq+0iADzFL+EOuwtcNnRrwblYGBN2ZDZUda4lWArS7
         +4e+KhcoqGkTtd6H3/OcOsFq7Ahnhb0q1JCtMoBoQ4E31Yirm4gnEqXYhX4EyIPuIGOB
         FHmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3sHaSQTtEpVgxZUhYIXCbmOjlv1gJeOQFw7S/Ryj3Pc=;
        b=oJPWaqH+8/xKlSqch/1fC3nc9lJ5wJsY/2tutfFAzdaDkCwsbOzElV9AVX4/TzoejZ
         naKP7rE8iEGJAMA5Rc18OnXz9Ex7rXldv5Rp34I4VjctpaOdLYPULvgvq/1ptAyfucCb
         nwDeKx5ajBwx8PInSRcaMK5nQFx/xFTJj8FPtpaacP49AXbA+nuBNM3pSLvs1bBU5k+U
         mx2+BAt4V/X3GAvLna07E8UCpWS4+bbxdyoWeZPJOP+1OY9j78UJw2beinj6XeUfj7ss
         PrzLcokZPQoDcxczAx9ohKG6GpmYiHgSf6EJ402f3qZcjbiQXsoQj5idJ22QUlg+X48t
         Fjrg==
X-Gm-Message-State: AOAM533PQ0Aab36A4zOjOsAhKOyI9xHY1FZgMFu+VqiSDyOLk02MtwRu
        NCTZOLfSc7xCSFN2D7m5qhz57w==
X-Google-Smtp-Source: ABdhPJz+/Ym87EdWBFw9jeyyDYLiDue8fyg2iZF9/6qckGGEuWKGDmW4AoA72uFBjuToGO5yEP8i5Q==
X-Received: by 2002:a17:906:2b06:: with SMTP id a6mr25615230ejg.209.1599574365078;
        Tue, 08 Sep 2020 07:12:45 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id w14sm17826958ejn.36.2020.09.08.07.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 07:12:44 -0700 (PDT)
Date:   Tue, 8 Sep 2020 16:12:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Aya Levin <ayal@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v1 1/4] devlink: Wrap trap related lists and
 ops in trap_mngr
Message-ID: <20200908141243.GO2997@nanopsycho.orion>
References: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
 <1599060734-26617-2-git-send-email-ayal@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599060734-26617-2-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 02, 2020 at 05:32:11PM CEST, ayal@mellanox.com wrote:
>Bundle the trap related lists: trap_list, trap_group_list and
>trap_policer_list and trap ops like: trap_init, trap_fini,
>trap_action_set... together in trap_mngr. This will be handy in the
>coming patches in the set introducing traps in devlink port context.
>With trap_mngr, code reuse is much simpler.
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>---
> drivers/net/ethernet/mellanox/mlxsw/core.c |   4 +
> include/net/devlink.h                      |  59 ++++---
> net/core/devlink.c                         | 255 +++++++++++++++++------------

You need to split this. You do at least 2 separate things in one patch.
Please check it.


> 3 files changed, 188 insertions(+), 130 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
>index 08d101138fbe..97460f47e537 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
>+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
>@@ -1285,6 +1285,9 @@ static const struct devlink_ops mlxsw_devlink_ops = {
> 	.sb_occ_tc_port_bind_get	= mlxsw_devlink_sb_occ_tc_port_bind_get,
> 	.info_get			= mlxsw_devlink_info_get,
> 	.flash_update			= mlxsw_devlink_flash_update,
>+};
>+
>+static const struct devlink_trap_ops mlxsw_devlink_traps_ops = {
> 	.trap_init			= mlxsw_devlink_trap_init,
> 	.trap_fini			= mlxsw_devlink_trap_fini,
> 	.trap_action_set		= mlxsw_devlink_trap_action_set,
>@@ -1321,6 +1324,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
> 			err = -ENOMEM;
> 			goto err_devlink_alloc;
> 		}
>+		devlink_traps_ops(devlink, &mlxsw_devlink_traps_ops);
> 	}
> 
> 	mlxsw_core = devlink_priv(devlink);
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 8f3c8a443238..d387ea5518c3 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -21,6 +21,13 @@
> #include <linux/xarray.h>
> 
> struct devlink_ops;
>+struct devlink_trap_ops;
>+struct devlink_trap_mngr {

"Mngr" is odd. This is not a manager. Just a common place to store
trap-related things. Perhaps just "devlink_traps"?


>+	struct list_head trap_list;
>+	struct list_head trap_group_list;
>+	struct list_head trap_policer_list;
>+	const struct devlink_trap_ops *trap_ops;
>+};

[...]

