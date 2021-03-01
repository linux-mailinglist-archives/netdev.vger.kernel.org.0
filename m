Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7779E32801B
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 14:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbhCAN4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbhCAN4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 08:56:32 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F88C061756
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 05:55:51 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id q23so19482391lji.8
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 05:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=stXRUtf48tQK6UO2n8d0RYjTXFbeNNDCHVc5TTol/Ds=;
        b=LrJg7v9MEuhDbcU8DptvX614AcwiSZw+BaJfXe4+U3T1sAr/vkd9z3GBBN5Wn3VloL
         UOBQ+Q6eiVtG1VUzQNsUxVlsMnhQ5AQEDJfCUPrgh95jaRVMSXzby8tkmCGHNWVxIZkW
         NzhxycOetPrPJtjIv3WpuJLNBsgkw1DrCc4C1+hCbKD2bdg0irjOAIs1rBbvMmMumaeP
         lPv8keN4UNWCvGJl0Kam4omVzR7AJXfz3/+AG/fsbXuBrPSFWt88mJmWEMFyB/0gb3lM
         CAsfSLgxdEwRZ4JHkLjCEXCe5hvo1xr8lVrdTDFtLxWwKMVk3nZ23GmgnQ+4zpnumC82
         LvCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=stXRUtf48tQK6UO2n8d0RYjTXFbeNNDCHVc5TTol/Ds=;
        b=iXSiaQSj1ODaPs1NlT+OgtPIJakGijHnbleQ46nyqOZdvYrTVW4glbERp7dNBvyipb
         9MITPKsIqcj2Kxmv3JminthyXiDj1P7l/KDDEJgYNxV7D/3ZLOF55SUNibw5H2afLz6Q
         ctKmYNwtLBEzF+z+EXqlSRkGuUO7rkGSAc6UNtGAJceOLt4wfGN9FALFFjO4deY467Vd
         QWAtWeENSSmY+0vsiW73YGgqsprYgpWVnFPaLtzDiezj1fBYfWOWnL8DOzK/EP3XxHD6
         iUhvmWZFGjZ/0odUoq74FeF4fXO1dc9yb8M4VG+XZFle9nd9OkcoAXwhWWkdE+dEVCJy
         h0+Q==
X-Gm-Message-State: AOAM530Y3gn3v3A8sSxZpZGuHtcS67iWsSROTCx6qb8MlGAhO7J6Ina7
        VLONAwYLstMbPQ3dI4uYLmtNLxxhTuFSyb2f+zVt0+XaJ/0=
X-Google-Smtp-Source: ABdhPJzT/ayw9CfkAeeooMvh1lbA9Y9KRkTbDBq2rlF2ar+1DmME16cf9ehrk7GFqHq/20oDpIrMgO7ltnuLPZBpAVk=
X-Received: by 2002:a2e:9041:: with SMTP id n1mr9312250ljg.273.1614606950308;
 Mon, 01 Mar 2021 05:55:50 -0800 (PST)
MIME-Version: 1.0
References: <20210224061205.23270-1-dqfext@gmail.com>
In-Reply-To: <20210224061205.23270-1-dqfext@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 1 Mar 2021 14:55:39 +0100
Message-ID: <CACRpkdZgwW=Zwehn+Bd7TkHq7WDVZ6VDbkXS5WKO0ACQAd2pcg@mail.gmail.com>
Subject: Re: [RFC net-next] net: dsa: rtl8366rb: support bridge offloading
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 7:12 AM DENG Qingfang <dqfext@gmail.com> wrote:

> +/* Port isolation registers */
> +#define RTL8366RB_PORT_ISO_BASE                0x0F08
> +#define RTL8366RB_PORT_ISO(pnum)       (RTL8366RB_PORT_ISO_BASE + (pnum))
> +#define RTL8366RB_PORT_ISO_EN          BIT(0)
> +#define RTL8366RB_PORT_ISO_PORTS_MASK  GENMASK(7, 1)

BTW where did you find this register? It's not in any of my
vendor driver code dumps.

Curious!

Yours,
Linus Walleij
