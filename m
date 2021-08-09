Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665663E3DBB
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 03:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhHIBlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 21:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbhHIBlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 21:41:06 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98210C061757;
        Sun,  8 Aug 2021 18:40:45 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id b25-20020a4ac2990000b0290263aab95660so3941214ooq.13;
        Sun, 08 Aug 2021 18:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l6laj60gF3EBJJf37/HSy0mFR0yiQYrPH8paT5cifVc=;
        b=PE9uHRpOY1P83cQ2hvR2ffdRd8QYhA/QCQGXlf0XNi9HScWL10UfLVELo9OElLoVKJ
         guUr6ubqcBYENkIxJyhURG7z9aOfuhCVXnBxr+ueFEZwA4jNYSOfF6GmuFh2J8dWxjR6
         gn7DCDMxUj4iSw8XOpdD0q+pGqEGeyrv67TgFNCLTQb1YaYfefVqRIBM0erRfXIqM9cq
         Go8TAaxVkg9yDG4MFnpNoXfLK8Y5UrbOW9WNX3jAs0RCmrnuO9avgRADQW1QbQgCk8vi
         cTG2cz8I3v97hOvYQg/85a4XQYSZ0Xz0gNB9bYD+oceRThPLq2TtrTJQ3oyqfaoqAeBA
         yJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=l6laj60gF3EBJJf37/HSy0mFR0yiQYrPH8paT5cifVc=;
        b=JCMtzu4EuAs3jWiUavuccAUEesnPgUz+tHTuJ7wc8h5PONlrDEQo2uIzHHSvGNDC/W
         LiEVaFrTp/jQb8Agf2R1943K3Q+wAYVDeKjaS6U7zMU34VIbI1X/oUXXyI12q9Al9nmU
         d2FsNip1+aNkJ9CwKWt1L6LpnN2qIf7xbJ8oUwL1RH2COptnrg/CQ6GnhI0Pl4IFBiMm
         m9/H+75NjVbuhGyOZxD3HHOMqCe0a88Kmhn8mpcHnYtNBRZbVKtX+xFznITddsTT6ELk
         9sGcG+USAQGog2Vqj33zvQP4AtA1k0sdmNpHqsyhzHbb8WZW/YZia1saPyMCgw2/lbGP
         O85A==
X-Gm-Message-State: AOAM531EhogJ6JfqffyKJqX8Ak+6U/D4HXJ7sdGrOzPif0HlHMcrtpMr
        x0H9xTXyeumZF7gQRemNCfA=
X-Google-Smtp-Source: ABdhPJxmYGx4zWxL0fvSC8obf6Owik82jL1rJv6TpMkpJSNz9YpFtbBh/bwCdkpsgL/mIdLLfcypaw==
X-Received: by 2002:a4a:b98c:: with SMTP id e12mr13534396oop.67.1628473245038;
        Sun, 08 Aug 2021 18:40:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l13sm3020531oii.11.2021.08.08.18.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 18:40:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 8 Aug 2021 18:40:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH V1 4/5] net: fec: add eee mode tx lpi support
Message-ID: <20210809014043.GA3712165@roeck-us.net>
References: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
 <20210709075355.27218-5-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709075355.27218-5-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 03:53:54PM +0800, Joakim Zhang wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> The i.MX8MQ ENET version support IEEE802.3az eee mode, add
> eee mode tx lpi enable to support ethtool interface.
> 
> usage:
> 1. set sleep and wake timer to 5ms:
> ethtool --set-eee eth0 eee on tx-lpi on tx-timer 5000
> 2. check the eee mode:
> ~# ethtool --show-eee eth0
> EEE Settings for eth0:
>         EEE status: enabled - active
>         Tx LPI: 5000 (us)
>         Supported EEE link modes:  100baseT/Full
>                                    1000baseT/Full
>         Advertised EEE link modes:  100baseT/Full
>                                     1000baseT/Full
>         Link partner advertised EEE link modes:  100baseT/Full
> 
> Note: For realtime case and IEEE1588 ptp case, it should disable
> EEE mode.
> 
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

This patch results in:

drivers/net/ethernet/freescale/fec_main.c: In function 'fec_enet_eee_mode_set':
drivers/net/ethernet/freescale/fec_main.c:2801:40: error: 'FEC_LPI_SLEEP' undeclared
drivers/net/ethernet/freescale/fec_main.c:2802:39: error: 'FEC_LPI_WAKE' undeclared

when building m68k:m5272c3_defconfig.

Guenter
