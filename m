Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA48322174B
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 23:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgGOVq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 17:46:57 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43205 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgGOVq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 17:46:56 -0400
Received: by mail-io1-f67.google.com with SMTP id k23so3870427iom.10;
        Wed, 15 Jul 2020 14:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8X1vTbH+xw2rCtV8oFWi4+4P5U4mLPjeUc+S5jha1dI=;
        b=CD0MBXrfyiYFyvNMEbpo9r3X2YxyYRGnfjENQSg+aWtRe5RYuOBYFkL5roTO1vZ0DA
         Aj7b1PfQEag/VmLmzf160N/gUvsd9aOFMHzDulN3kXoLcFsUQCMtKfLmAkRzcculn2Mo
         Aua/QpxG9dFpIK7vunXLNfXCKrOuwI3MFZO5YBAJ+8P0pSBV9DwdkD3NNvWQ43zaqsx7
         Cz5Xd5dEMr1UZtKFnvbLRJbqug4AJj6MXpYFiKE/9Ya6v9hM3iqdRMbGTcAG36NDMNqF
         uLDRzc6QmivlYuTpeF/g8DLryuZFW9K2pveZi5BconobU7r29BWGFSxdT8sgAuwVajJL
         5akg==
X-Gm-Message-State: AOAM531ceMbADn/buTtlUA72v2bUZn80bHF87Jtw+O8U5w1v46qxFK5H
        pafhPUUq/6qkdTDz8RHdQA==
X-Google-Smtp-Source: ABdhPJyzuv6RdWuDkioL49WymJzxtFy1VHPX3fMw2CtZy0VDQtTxfVBdWTwCsbTEYs0hrDISr0c6PQ==
X-Received: by 2002:a6b:3f57:: with SMTP id m84mr1241019ioa.99.1594849615577;
        Wed, 15 Jul 2020 14:46:55 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id c14sm1623116ild.41.2020.07.15.14.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 14:46:55 -0700 (PDT)
Received: (nullmailer pid 872990 invoked by uid 1000);
        Wed, 15 Jul 2020 21:46:53 -0000
Date:   Wed, 15 Jul 2020 15:46:53 -0600
From:   Rob Herring <robh@kernel.org>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     robh+dt@kernel.org, leon@kernel.org, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, dmurphy@ti.com,
        krzk@kernel.org, masahiroy@kernel.org, linux-can@vger.kernel.org,
        sriram.dash@samsung.com, netdev@vger.kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        hpeter@gmail.com, devicetree@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] Replace HTTP links with HTTPS ones: CAN network drivers
Message-ID: <20200715214653.GA872937@bogus>
References: <20200705075606.22802-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705075606.22802-1-grandmaster@al2klimov.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 05 Jul 2020 09:56:06 +0200, Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
>           If both the HTTP and HTTPS versions
>           return 200 OK and serve the same content:
>             Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>  Continuing my work started at 93431e0607e5.
> 
>  If there are any URLs to be removed completely or at least not HTTPSified:
>  Just clearly say so and I'll *undo my change*.
>  See also https://lkml.org/lkml/2020/6/27/64
> 
>  If there are any valid, but yet not changed URLs:
>  See https://lkml.org/lkml/2020/6/26/837
> 
>  Documentation/devicetree/bindings/net/can/grcan.txt |  2 +-
>  drivers/net/can/grcan.c                             |  2 +-
>  drivers/net/can/m_can/m_can.c                       |  2 +-
>  drivers/net/can/m_can/m_can.h                       |  2 +-
>  drivers/net/can/m_can/m_can_platform.c              |  2 +-
>  drivers/net/can/m_can/tcan4x5x.c                    |  2 +-
>  drivers/net/can/sja1000/Kconfig                     | 12 ++++++------
>  drivers/net/can/sja1000/tscan1.c                    |  2 +-
>  drivers/net/can/slcan.c                             |  2 +-
>  drivers/net/can/ti_hecc.c                           |  4 ++--
>  drivers/net/can/usb/Kconfig                         |  6 +++---
>  11 files changed, 19 insertions(+), 19 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
