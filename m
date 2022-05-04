Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551A751AAAB
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 19:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357602AbiEDRb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 13:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358355AbiEDRaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 13:30:12 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23A95A2F0;
        Wed,  4 May 2022 10:03:19 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id m20so4063607ejj.10;
        Wed, 04 May 2022 10:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XHhPMghoycQ7eZAcORj5/5ITHZkNT2/OH1GPvvsrfbQ=;
        b=SqR7hHsK/RejCtFA8dwwMGr018xMpnEwTVqsiV1OYbcB7CXupjbHvoKgbg/XS3cM48
         eRn7SF255AE4R9aFZ1TZyskUzN0tGBzef+NuVU3lq6n9LP+N26MW2elzZhT1xn5WA/Z2
         JOBCA0yoFVNwZJ2fsfBU1+IJz+/64Yk2Lnb4zi+Hbt0ueXDvAtBIEj9aLzxwV/pDyVht
         /DiAj4o9gUTbLwTj+fR5grv10T6aXHbOiVCWkNURcJMXeHGaaxJT+uKMZwu1rCEL9nB1
         fn8iBwqTII2umXCBgpxJm8cX/0BnP+ffXKe+a8EBYqgTOrluF+tGriduCthmRw+ORgol
         LAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XHhPMghoycQ7eZAcORj5/5ITHZkNT2/OH1GPvvsrfbQ=;
        b=A3az3PVv/pJfylb190646IewdeqhIXXSmaNl6qedmcYRo7eXhpn5mYhUTPPBiYzS8R
         WHFGMkNhQtqGiZWl6z7DcWUOixYwA17mSNx3vRk6Oc67jvA5B3y0c5cPvQ77AKovAeha
         f84BiB9f6JAer8rkas/eBg1tWHDTv8cmm43q4rCHIP2zmn8OGaDlRcKNf38f//vxNrAt
         3ys8PnHxyZtqPzO8YhEjgnBIWyASDydj0pNOGHHZZ/DDC/fOckDTvCeVXQ8iENtJw1ck
         OhElBzctHnKGZ38I6AxEHckFeTLI6fMU8L60dlEWLpPRpyA+B9FcEMI3/zEMNsDSluvz
         L98A==
X-Gm-Message-State: AOAM533murcH+ZVBtEgC2ETxkR9QikFZQCE+jPhZ9V4MMnaSeS0ILh4g
        Lhe9T3909lLUaWrkOetWNNyUFUdBUjQFtoHA0f4=
X-Google-Smtp-Source: ABdhPJyiH+Wiy/O6YKtXm4uAxJeiKTP6KgF0Vo2a0ftqHtuKiOruQ0+lsJyO5wgCdO9HKC9pOAWnN4nQ5NpbqPYsoOU=
X-Received: by 2002:a17:906:a089:b0:6ef:e9e6:1368 with SMTP id
 q9-20020a170906a08900b006efe9e61368mr21038453ejy.626.1651683797349; Wed, 04
 May 2022 10:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220504143104.1286960-1-festevam@gmail.com>
In-Reply-To: <20220504143104.1286960-1-festevam@gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 4 May 2022 14:03:08 -0300
Message-ID: <CAOMZO5DU8XRCGaYOcGeHimgupqMksyLXsjL=R8JHajSBs4KAeg@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] net: phy: micrel: Do not use
 kszphy_suspend/resume for KSZ8061
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Fabio Estevam <festevam@denx.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, May 4, 2022 at 11:31 AM Fabio Estevam <festevam@gmail.com> wrote:
>
> From: Fabio Estevam <festevam@denx.de>
>
> Since commit f1131b9c23fb ("net: phy: micrel: use
> kszphy_suspend()/kszphy_resume for irq aware devices") the following
> NULL pointer dereference is observed on a board with KSZ8061:
>
>  # udhcpc -i eth0
> udhcpc: started, v1.35.0
> 8<--- cut here ---
> Unable to handle kernel NULL pointer dereference at virtual address 00000008
> pgd = f73cef4e
> [00000008] *pgd=00000000
> Internal error: Oops: 5 [#1] SMP ARM
> Modules linked in:
> CPU: 0 PID: 196 Comm: ifconfig Not tainted 5.15.37-dirty #94
> Hardware name: Freescale i.MX6 SoloX (Device Tree)
> PC is at kszphy_config_reset+0x10/0x114
> LR is at kszphy_resume+0x24/0x64
> ...
>
> The KSZ8061 phy_driver structure does not have the .probe/..driver_data
> fields, which means that priv is not allocated.
>
> This causes the NULL pointer dereference inside kszphy_config_reset().
>
> Fix the problem by using the generic suspend/resume functions as before.
>
> Another alternative would be to provide the .probe and .driver_data
> information into the structure, but to be on the safe side, let's
> just restore Ethernet functionality by using the generic suspend/resume.
>
> Cc: stable@vger.kernel.org
> Fixes: f1131b9c23fb ("net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices")
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
> Changes since v1:
> - Explained why enphy_suspend/resume solution is preferred (Andrew).

If this series gets applied, I plan to submit two patches targeting net-next to:

1. Allow .probe to be called without .data_driver being passed
2. Convert KSZ8061 to use .probe and kszphy_suspend/resume
