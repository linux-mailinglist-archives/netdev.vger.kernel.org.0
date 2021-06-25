Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296243B4A6C
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 00:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhFYWG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 18:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFYWG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 18:06:57 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05646C061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 15:04:36 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id d16so13885943ejm.7
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 15:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sv2HpFB9ghJwo1qOuWLpmkrUc7zDKP8BTbEeCMtImt8=;
        b=NfguORK8HjGoixwuQBNDD8NWnFbPSYDHPg/LnLQe+3Yc6LifN+9YWHlnit4a78EVHi
         ZitwBa7pOKqX5Pz0BMIO12wUUerHO1Clq1pU0ChXGWnFtEF1/79gCUgADO3BnEeMAfNl
         pVB7PJha5PLMCsdYR2kMSBaa/C5Af4TV4zZc6KphOFOWvfrZWVbHGo+plr4WM0sDHdzi
         tS9cd2fCLZJYfKXqFMmig7O5sodrBAjQEVMm1Xoc1ZonBS+vkKNI28XJ7rtfEj/am3++
         zdDBOrmz2yQdTUmeKi3xP/ojLtwkqtlNdqbFiZwiSBjQ1Owj5pi1uBpmp7+bW2z3iflO
         4Kpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sv2HpFB9ghJwo1qOuWLpmkrUc7zDKP8BTbEeCMtImt8=;
        b=KQLGx+GmZiyFN0aWhSJMIQO+m82JcggJWcCAxC+bfa/RfsqDyCFuLUUpe5B87B/Lau
         FCyvU1L2ilPvaFL8BSKWTfiQrZ35+qsjitw3uOFgH18odpegp+DSwOVkBA0WAGNSL7Fs
         mu99KocQKl8bPT172B3RleXbQLQFgoWnqSA6YI1YvL60D6AqcjbqfBivhgx5SQIsok8u
         UQsOgp6FEboU+QA64KWeLXGhQSCBET7H2ZSZ9bM+DQ2UXFzVpfR/KOpwVJEeHC9LpSFX
         BQyPrTz4Q1Jn9jT5XutJSTDj+D6K4TJrN19a2PME2xw7TXSE4UYxKork0SRbek7eMHSO
         iKSw==
X-Gm-Message-State: AOAM532RN2kexZxxholsqAbCGn00MjUzEr8Vf+nTnls7Kz3ZjJKpka+L
        XsYaEo/cbDLMbdBlsRg4Klg=
X-Google-Smtp-Source: ABdhPJzJ6v+hU9HWCC+i+qEwb5VGIoyKrJHsO/Ey+uVBjTO3BLTAhZtVRR807O/2O7T2ZHih6LIIPA==
X-Received: by 2002:a17:906:744:: with SMTP id z4mr13357120ejb.347.1624658674299;
        Fri, 25 Jun 2021 15:04:34 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id j19sm4664928edw.43.2021.06.25.15.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 15:04:33 -0700 (PDT)
Date:   Sat, 26 Jun 2021 01:04:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@lists.infradead.org
Subject: Re: [RFC 0/3] net: imx: Provide support for L2 switch as switchdev
 accelerator
Message-ID: <20210625220432.lg2plfzkudoxbeer@skbuf>
References: <20210622144111.19647-1-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622144111.19647-1-lukma@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 04:41:08PM +0200, Lukasz Majewski wrote:
> This patch series is a followup for the earlier effort [1]
> to bring support for L2 switch IP block on some NXP devices.
>
> This time it augment the fec driver, so the L2 switch is treated
> as a HW network accelerator. This is minimal, yet functional
> driver, which enables bridging between imx28 ENET-MAC ports.
>
> Links:
> [1] - https://lwn.net/ml/linux-kernel/20201125232459.378-1-lukma@denx.de/

On which tree are these patches supposed to apply?

Patch 1 doesn't apply on today's net-next.
git am ~/incoming/*
Applying: ARM: dts: imx28: Add description for L2 switch on XEA board
error: arch/arm/boot/dts/imx28-xea.dts: does not exist in index
Patch failed at 0001 ARM: dts: imx28: Add description for L2 switch on XEA board
hint: Use 'git am --show-current-patch' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Patch 2 doesn't apply on today's linux-next.
git am ~/incoming/*
Applying: ARM: dts: imx28: Add description for L2 switch on XEA board
Applying: net: Provide switchdev driver for NXP's More Than IP L2 switch
error: patch failed: drivers/net/ethernet/freescale/Makefile:27
error: drivers/net/ethernet/freescale/Makefile: patch does not apply
Patch failed at 0002 net: Provide switchdev driver for NXP's More Than IP L2 switch
hint: Use 'git am --show-current-patch' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
