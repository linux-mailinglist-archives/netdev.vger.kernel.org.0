Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A320B496E24
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 23:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiAVWBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 17:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiAVWBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 17:01:24 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D46C06173B
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 14:01:24 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id h29so3842173wrb.5
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 14:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+kJRc/JKfbpDy2O81NcVtf1MKbWVthVK02/XuLtrHfI=;
        b=H6W69fhQggb7IBm/firFZ4dGSsE07w2+PZVuLFiRRFWGYNZyXZOr4zj2zLRUeV3eNL
         STfb7OoTHaExzRVQ+DmKbp9HUSzkKGuE/T1rir5AO5rbPMB41PGy1Q9Iz9+QySGpPUNo
         177VJT+EsUL/U0S+t48+z+15sofEaPBbIM7cVWg98oH7YLSS6Xst2R2qVz4+6i3t9OYl
         mIhkrgzgG0SbS5QVIOOMDY+A3lpJWjmggigxc+DmPmXkY7HNhh8nWNei//YC1r7x172Y
         XXx7TS29W8nreGhHwza3UPTUHHEG6XQR7MytYaLAPOu0jlUo2twlj/yqXXWG/U+D64fD
         JoYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+kJRc/JKfbpDy2O81NcVtf1MKbWVthVK02/XuLtrHfI=;
        b=34H+QomYonajKt/eAqmhxgqWm6FIkV0kLhah9cM/x6liqswVLKdAqkDa8CNRzDk0Nu
         rCZssgjwVBv7fKe0cj8Tx9ie4viRYLlV6YtNoJkMrKIa9MqRMzsYQbdT02BZUilB2qJR
         VrB5AXizJ+dIOeSaWBz/SjzWSgI2XAqXkMHfu0h09hWU9IjRElGiNTYfoB8xKV96tN8V
         9ufpEt1Fv2Crq4kkmfe9l2NawDGh8iih438YrC3Z1f0xST3yZxR+v3ZfoHCgXyDSypQr
         cQ01azjzNb/E8rOUgy2tVv1zTKdzRsFaldNKD+BxqHLJoq+BPIhWWTUwBllTI4nz1463
         3kvA==
X-Gm-Message-State: AOAM531/WMFnL4NO79cxUvvX3+qy9IRsMIPkgiMkhR8bhku+ya0ho6xT
        m1lMk057wdxmWvFBY3k5/6o02fW1cro=
X-Google-Smtp-Source: ABdhPJw/OTs5o2CrusnG+71fwkdE6TD4D9bBfS8TMxVdKxJm+4u2Q3hgq25QugSgQW+etuNO6qCaKw==
X-Received: by 2002:adf:a59a:: with SMTP id g26mr8724582wrc.262.1642888882656;
        Sat, 22 Jan 2022 14:01:22 -0800 (PST)
Received: from nz (host81-129-87-131.range81-129.btcentralplus.com. [81.129.87.131])
        by smtp.gmail.com with ESMTPSA id p19sm9456735wmq.19.2022.01.22.14.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 14:01:22 -0800 (PST)
Date:   Sat, 22 Jan 2022 22:01:21 +0000
From:   Sergei Trofimovich <slyich@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: atl1c drivers run 'napi/eth%d-385' named threads with
 unsubstituted %d
Message-ID: <20220122220121.706317d8@nz>
In-Reply-To: <Yexdw8JSiTXtn2Bg@lunn.ch>
References: <YessW5YR285JeLf5@nz>
        <YetFsbw6885xUwSg@lunn.ch>
        <20220121170313.1d6ccf4d@hermes.local>
        <YetjpvBgQFApTRu0@lunn.ch>
        <20220122121228.3b73db2a@nz>
        <Yexdw8JSiTXtn2Bg@lunn.ch>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Jan 2022 20:40:51 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > > Oh, yes. I looked at some of the users. And some do take rtnl before
> > > calling it. And some don't!
> > > 
> > > Looking at register_netdev(), it seems we need something like:
> > > 
> > > 	if (rtnl_lock_killable()) {
> > > 	       err = -EINTR;
> > > 	       goto err_init_netdev;
> > > 	}
> > > 	err = dev_alloc_name(netdev, netdev->name);
> > > 	rtnl_unlock();
> > > 	if (err < 0)
> > > 		goto err_init_netdev;
> > > 
> > > 
> > > It might also be a good idea to put a ASSERT_RTNL() in
> > > __dev_alloc_name() to catch any driver doing this wrong.  
> 
> I looked at it some more, and some of the current users. And this does
> not really work. There is a race condition.
> 
> Taking rtnl means you at least get a valid name, while you hold
> rtnl. But it does not keep track of the name it just gave out. As a
> result, you can release rtnl, and another device can jump in and be
> given the same name in register_netdev(). When this driver then calls
> register_netdev() the core will notice the clash and return -EEXISTS,
> causing the probe to fail.
> 
> There are some drivers which take rtnl and keep it until after calling
> register_netdevice(), rather than register_netdev(), but this is
> rather ugly. And there are some drivers which don't take the lock, and
> just hope they don't hit the race.
> 
> Maybe a better fix for this driver is:
> 
> From a5fc0e127bdc4b6ba4fb923012729cbf3d529996 Mon Sep 17 00:00:00 2001
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Sat, 22 Jan 2022 13:33:58 -0600
> Subject: [PATCH] net: ethernet: atl1c: Move dev_set_threaded() after
>  register_netdev()
> 
> dev_set_threaded() creates new kernel threads to perform napi. The
> threads are given a name based on the interface name. However, the
> interface is not allocated a name until register_netdev() is called.
> By moving the call to dev_set_threaded() to later in the probe
> function, odd thread names like napi/eth%d-385 are avoided.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

This patch also works:

    687 root 20 0 0 0 0 R 6.7   0.0 0:00.15 napi/eth0-386
    688 root 20 0 0 0 0 S 6.7   0.0 0:00.32 napi/eth0-385

tested in the same environment on top of 5.16.1:

Tested-by: Sergei Trofimovich <slyich@gmail.com>

Thank you!

> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index da595242bc13..9b8088905946 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -2728,7 +2728,7 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>         adapter->mii.mdio_write = atl1c_mdio_write;
>         adapter->mii.phy_id_mask = 0x1f;
>         adapter->mii.reg_num_mask = MDIO_CTRL_REG_MASK;
> -       dev_set_threaded(netdev, true);
> +
>         for (i = 0; i < adapter->rx_queue_count; ++i)
>                 netif_napi_add(netdev, &adapter->rrd_ring[i].napi,
>                                atl1c_clean_rx, 64);
> @@ -2781,6 +2781,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>                 goto err_register;
>         }
>  
> +       dev_set_threaded(netdev, true);
> +
>         cards_found++;
>         return 0;
>  
> -- 
> 2.34.1


-- 

  Sergei
