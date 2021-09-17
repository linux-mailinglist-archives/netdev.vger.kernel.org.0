Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566F640F986
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241194AbhIQNvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240099AbhIQNvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:51:24 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F7CC061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 06:50:01 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id gs10so6389512qvb.13
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 06:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=piBRpEE+WWHlWllIUzB+ODVSBg/qtTReQB6Vdl5TiMQ=;
        b=QhBHO8WCAz0Nd0vl3OXDyPxZPaacuXWvOVBXISQKsz0CMPuqFQV+Z3rTARpzPSmDR8
         hHTkzcYXPO5+/KZ9CEAOVPnh/cJ5a3WN1FbpuMyA+V5xuFFXtiFxZwb+X7ifA8i+97Wc
         H/1zit8xyMceylXSwniUE8DB0gohz+phjXOgI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=piBRpEE+WWHlWllIUzB+ODVSBg/qtTReQB6Vdl5TiMQ=;
        b=YQEh6/xy9zMqJAgUFG/dV9s6ZGOT7poy8oidGsSpXJRurP4bYhGfYtvcHkxOmoEYLT
         we0RygRnl+7sPNVupSOTJBffW3QGEMMjh6+V08C83G4WcnOplfN/kFGJAsebP3fx8ZC1
         FJ+/6DqEN4JOihtgs9x9Sul2V33C1bViIEPuQ63Pz9BYjpICdSMCBTWsMyvtzNAS4uhZ
         02dZ4ujJv1jCFMnvEaYQgOUMzD9D/rwFrV0b6kpPde8n+ZqtoGu9tBFbMYtCOCsHeKH0
         Kbjd0HK+9k2vBFVJwzthf8yW2eevVDCmilX3Z3JH812W2dZXIqUHnsROiZehcxl5QNNw
         zlZw==
X-Gm-Message-State: AOAM531sv/O6xke+RSkjQIgpfNBcK3hb+gvzRg3u9VxOXStETtAe8ngZ
        4c20h0IvTMuys26Jm61+bA6kcw==
X-Google-Smtp-Source: ABdhPJzLhk3+6YH/nHR1yn4MtkGwS/tE79GZt3HiHObF1HIfEAtV1p8s5KFv4j8ECtFsiY6rFmPxVg==
X-Received: by 2002:a05:6214:1492:: with SMTP id bn18mr8463440qvb.44.1631886601105;
        Fri, 17 Sep 2021 06:50:01 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-181.dsl.bell.ca. [216.209.220.181])
        by smtp.gmail.com with ESMTPSA id a9sm4857113qkk.82.2021.09.17.06.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 06:50:00 -0700 (PDT)
Date:   Fri, 17 Sep 2021 09:49:58 -0400
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 net] net: mscc: ocelot: remove buggy and useless write
 to ANA_PFC_PFC_CFG
Message-ID: <20210917134958.6o2jev2ngegzmpfo@meerkat.local>
References: <20210916010938.517698-1-colin.foster@in-advantage.com>
 <20210916114917.aielkefz5gg7flto@skbuf>
 <DB8PR04MB67954EE02059714DD9A72435E6DD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210917033802.GA681448@euler>
 <DB8PR04MB6795DF1A354A33F3BE8F563CE6DD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795DF1A354A33F3BE8F563CE6DD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 10:39:18AM +0000, Joakim Zhang wrote:
> But it still failed at my side, after I google, have not found a solution, could you please
> help have a look about below error?
> 
> $ git b4 20210916010938.517698-1-colin.foster@in-advantage.com
> Traceback (most recent call last):
>   File "/home/zqq/.local/bin/b4", line 7, in <module>
>     from b4.command import cmd
>   File "/home/zqq/.local/lib/python2.7/site-packages/b4/__init__.py", line 11, in <module>
                              ^^^^^^^^^^^
You seem to be trying to run it with python 2.7

>     import email.policy
> ImportError: No module named policy

I'm not sure how you managed to make it install, but it won't work with python
versions < 3.6. Python version 2 is no longer maintained.

-K
