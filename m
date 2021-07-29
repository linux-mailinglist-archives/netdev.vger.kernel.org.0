Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3883DA28E
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 13:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhG2Lzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 07:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbhG2Lzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 07:55:37 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CB9C0613C1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 04:55:32 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b11so1250147wrx.6
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 04:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zXAEOLN9SYnmGGjsihLTS/Qt+xjg3BkjUtxD75Hc1B0=;
        b=qktN/sJt3VVMEgerPW78YecwI/DVI1W01zC9uJlT0gtjdbtEEQxgiPgFQTb1o8KIqq
         1Xu2+Nb7znYJU3T/0k1QkhZIMww9cREVnqBuIXZIIGAQCUgS8BKwRnJu8vC8a0rbS3xS
         SmMddVrcFwEHdI3hAwyelcQcPRxTQBN62VZ+LPFetBANe7Lb8LP3WFOC2pJC7yWYEcKY
         7L58TpZVYUlg2YJ+s45T+Ng+I1kWsR0Fs4pDlCHoAhIIAU4n+S5x+gspJo60xSyZ3Knr
         soSwa7QBM+vL8ZlYHZBwaWYpQmPojhQvp1lGQkWrGJ+k4uq3pJCbLeLb6evrSIodvYF7
         IjKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zXAEOLN9SYnmGGjsihLTS/Qt+xjg3BkjUtxD75Hc1B0=;
        b=mlsZya1u+ZAB6kgGMFrgElenm8pCl5OCP3s+HgSnkAgWYQ6GNSllPGwU7+00D/foT4
         xUa2aOvXFk9YZnmLop9k6kx3a8wm8xJ9Yudgr9jHFg2ce124M1ejdSPCySyWIeA00cCk
         v6c3W8XtOf/YDilnfGPAkvMSNU6PCzab4tmsPkMTBJCmetAmvht3Zvv2lEYen9Enqbha
         OvdH+yvIKC69saAtzsfaWERZ10WSMKcq1MEtrRwy2oCdLGYiy5EQdbY6qBZO6R3a7gRH
         wo03TVoegLEzxFlxuqHlgasGOBSBYO+tEo0N38D9ALjcAV6i/S8J5jbsTtUlYELoEONF
         8p6g==
X-Gm-Message-State: AOAM530H5f8eOymy2041D5OC9oGQZ+uMsKZoWriOx4oQLHnkBRTBs1vk
        ftH2Jnz7nesCQ0pPriVSD3NErQ==
X-Google-Smtp-Source: ABdhPJw8gVdPhukKi7m7Re7PufSJ5utAmX0FeBiTeQ+8h/WG7HqlU8/4O3cNXce1P+c5pLBaBlNHpA==
X-Received: by 2002:adf:d225:: with SMTP id k5mr4425617wrh.10.1627559731389;
        Thu, 29 Jul 2021 04:55:31 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j14sm3306941wru.58.2021.07.29.04.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 04:55:30 -0700 (PDT)
Date:   Thu, 29 Jul 2021 13:55:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net-next 2/2] devlink: Allocate devlink directly in
 requested net namespace
Message-ID: <YQKXMT4tbzCnkYlA@nanopsycho>
References: <cover.1627545799.git.leonro@nvidia.com>
 <ca29973a59c9c128ab960e3cbff8dfa95280b6b0.1627545799.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca29973a59c9c128ab960e3cbff8dfa95280b6b0.1627545799.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 29, 2021 at 10:15:26AM CEST, leon@kernel.org wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>There is no need in extra call indirection and check from impossible
>flow where someone tries to set namespace without prior call
>to devlink_alloc().
>
>Instead of this extra logic and additional EXPORT_SYMBOL, use specialized
>devlink allocation function that receives net namespace as an argument.
>
>Such specialized API allows clear view when devlink initialized in wrong
>net namespace and/or kernel users don't try to change devlink namespace
>under the hood.
>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---
> drivers/net/netdevsim/dev.c |  4 ++--
> include/net/devlink.h       | 14 ++++++++++++--
> net/core/devlink.c          | 26 ++++++++------------------
> 3 files changed, 22 insertions(+), 22 deletions(-)
>
>diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>index 6348307bfa84..d538a39d4225 100644
>--- a/drivers/net/netdevsim/dev.c
>+++ b/drivers/net/netdevsim/dev.c
>@@ -1431,10 +1431,10 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
> 	struct devlink *devlink;
> 	int err;
> 
>-	devlink = devlink_alloc(&nsim_dev_devlink_ops, sizeof(*nsim_dev));
>+	devlink = devlink_alloc_ns(&nsim_dev_devlink_ops, sizeof(*nsim_dev),
>+				   nsim_bus_dev->initial_net);
> 	if (!devlink)
> 		return -ENOMEM;
>-	devlink_net_set(devlink, nsim_bus_dev->initial_net);
> 	nsim_dev = devlink_priv(devlink);
> 	nsim_dev->nsim_bus_dev = nsim_bus_dev;
> 	nsim_dev->switch_id.id_len = sizeof(nsim_dev->switch_id.id);
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index e48a62320407..b4691c40320f 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -1540,8 +1540,18 @@ static inline struct devlink *netdev_to_devlink(struct net_device *dev)
> struct ib_device;
> 
> struct net *devlink_net(const struct devlink *devlink);
>-void devlink_net_set(struct devlink *devlink, struct net *net);
>-struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
>+/* This RAW call is intended for software devices that can

Not sure what "RAW call" is, perhaps you can just avoid this here.

Otherwise, this patch looks fine to me:
Reviewed-by: Jiri Pirko <jiri@nvidia.com>

[...]
