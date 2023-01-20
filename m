Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A723F674FE3
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 09:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjATIzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 03:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjATIzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 03:55:06 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C565B9A
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 00:55:05 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id m5-20020a05600c4f4500b003db03b2559eso3108371wmq.5
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 00:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wsyq2rXa3k11y3i1YeYK9uB4f5bw1yM8tS3TWsD8Zmw=;
        b=RLugDE2lCdgdN7TU3IVgCup0KyWS7oGEOUoR78XUNcRNu9R6CNnl9M6P6gK4oNVoFV
         LHnmLCr9ChAd1R4xOjOS2RFiP+2wbqHzcMCzKwZ8b1axcCjOdSTitVmiqQVMP8gx2qiD
         M3lomIaeRjtHegS/WvJpYNgbKEtGcL1IMz0urVXb5AQ4MM6r4aJA0JjSQtS802qJwZTk
         mjLNPMTl/Xy9Jb0xrf5fuHw4JLUSNZs7MWxXzmSuTOMhMopXQ6j/i9OCEOjtScQaO05m
         tDo7azVQjwvnlKwpRpmDfyrBEA8o8snv4xhOnBIo0gtbF3QRK4EKLQQctVkFeHoLe32K
         JqaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wsyq2rXa3k11y3i1YeYK9uB4f5bw1yM8tS3TWsD8Zmw=;
        b=rVtNpfuIZY1BLIzT6JQKjH9i48VCQSKgUUXRgNMPrJP2lgQhYZvfzhin1yHIphgmIF
         4VYLEEkwzcrkP0N71niEJXsKMuHaXS9JFh+2qK7o0GxoyK9sMzVMi6uD5cjk5eryJTBQ
         7ivIDxZSSXTQB9gXDKWflGgU7Ldv9ytWykExsXDBPpHBTvokhhdDHEY/MTraTuD0+rGo
         Frs3cWPrpZBLTjAV8d7RM1VVL0C4I6D3T9aGtIiHm7jhOxUUWPJINV4rLgM8AupC4pPm
         KWrO9vO5cZYHPyMdgonRWijeOAYwIz8/C1kGeVi2tUODXFu0xPs3huiBIAeCLc/2328e
         IjqQ==
X-Gm-Message-State: AFqh2ko0BzOFOSUyt4XXsVS39GV4Fh7u4DZKQbKYp9jK9ACc1pa/dyKd
        M55IEgHldOK21xFgTPJrF30SgxyWu1s=
X-Google-Smtp-Source: AMrXdXv7wzqQIyCppioBzKveBOl2YMwdlCxNnrcWlIlmK6nMOF0DcLhsl1rqjcHMY688KRDJJzec1w==
X-Received: by 2002:a1c:f617:0:b0:3d2:191d:2420 with SMTP id w23-20020a1cf617000000b003d2191d2420mr12825886wmc.7.1674204904045;
        Fri, 20 Jan 2023 00:55:04 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003db2b81660esm1642490wmo.21.2023.01.20.00.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 00:55:03 -0800 (PST)
Date:   Fri, 20 Jan 2023 08:55:01 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next 0/7] sfc: devlink support for ef100
Message-ID: <Y8pW5aR3kZF2MrmB@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please fix my email address as per the MAINTAINTERS file:
 habetsm.xilinx@gmail.com

On Thu, Jan 19, 2023 at 11:31:33AM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> This patchset adds devlink port support for ef100 allowing setting VFs
> mac addresses through the VF representors netdevs.
> 
> Basic devlink support is first introduced for info command. Then changes
> for enumerating MAE ports which will be used for devlik port creation

Typo: devlink.

> when netdevs are register.

.. are registered.

> 
> Adding support for devlink port_function_hw_addr_get requires changes in
> the ef100 driver for getting the mac address based on a client handle.
> This allows to obtain VFs mac address during netdev initialization as
> well what is included in patch 5.
> 
> Such client handle is used in patches 6 and 7 for getting and setting
> devlink ports addresses.

port in stead of ports.

Martin

> 
> Alejandro Lucero (7):
>   sfc: add devlink support for ef100
>   sfc: enumerate mports in ef100
>   sfc: add mport lookup based on driver's mport data
>   sfc: add devlink port support for ef100
>   sfc: obtain device mac address based on firmware handle for ef100
>   sfc: add support for port_function_hw_addr_get devlink in ef100
>   sfc: add support for devlink port_function_hw_addr_set in ef100
> 
>  drivers/net/ethernet/sfc/Kconfig        |   1 +
>  drivers/net/ethernet/sfc/Makefile       |   3 +-
>  drivers/net/ethernet/sfc/ef100_netdev.c |  20 +-
>  drivers/net/ethernet/sfc/ef100_nic.c    |  96 +++-
>  drivers/net/ethernet/sfc/ef100_nic.h    |   7 +
>  drivers/net/ethernet/sfc/ef100_rep.c    |  58 ++-
>  drivers/net/ethernet/sfc/ef100_rep.h    |   9 +
>  drivers/net/ethernet/sfc/efx_devlink.c  | 629 ++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/efx_devlink.h  |  27 +
>  drivers/net/ethernet/sfc/mae.c          | 212 +++++++-
>  drivers/net/ethernet/sfc/mae.h          |  39 ++
>  drivers/net/ethernet/sfc/mcdi.c         |  72 +++
>  drivers/net/ethernet/sfc/mcdi.h         |  10 +
>  drivers/net/ethernet/sfc/net_driver.h   |   7 +
>  14 files changed, 1162 insertions(+), 28 deletions(-)
>  create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
>  create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h
> 
> -- 
> 2.17.1
