Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C264FF31
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 04:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfFXCRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 22:17:04 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43801 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfFXCRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 22:17:04 -0400
Received: by mail-lj1-f195.google.com with SMTP id 16so10934712ljv.10
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 19:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q7wz2t7u/9aK1bNPZ479OzccMgC+SVvO9ZTRTaDQNLE=;
        b=wYbpjEslFKzGNA9UaWsVFJoVeLBrAL2HmRatz8rnXjHTni7OJoRzaBqf+1rBIdEwZw
         Cx9pdmsZUDC/a+Q7OsWMnQCi4PH5CB8Hre6I0gStJ4XwjEoTZWjf+E2fZ0aa75ILq1/o
         5wQyQz/YYBAYTpy4i6neEfHrjZqOG4vYDJ9qpJkyij231cxbv15bxsfnyKiSoUmIandO
         iyzVrAmOx/iZrCrvom9Y7aLJOvkdw6HJLoe1pee4JERvMzXQ4SMrE/9CBfFDcd5XSRr0
         ohuRCeg1XcOtmzKkZuVvV0xc9FQ6fNxv9yFvl9g5WAEjwm7x/GUrIV2kDIWoxEcWo2ZL
         ICHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=Q7wz2t7u/9aK1bNPZ479OzccMgC+SVvO9ZTRTaDQNLE=;
        b=g6QBWZ61kB4Pbf31loPrsGQY8hdDZE2nhdJRrjyx0gC+91h3ohjriDDL2pbQwgU0oG
         QPo5L9Q/YQtgB9eqSyk4DO6GLV1O6SNfFPGSAsWE5ICyQ0g0N3sCHXjQyXBQV++vIvDb
         V5YJ9LxTtnMr61LD8rHyZ9LkoQ5IlwODMDvl5MGsR1OrGE6nnAmbcxf57+TsPiNMRZ01
         hj1rD7hw3a3ydfUinKqa/sJBTbiOZsM1olb0XR6QTyj6qevRlMfHFWWY/30bkDouJgF5
         DW0kozTO7yb+PtB5LRfZfVCeQ2ie524Mr8s8PMupEYrw6vacoPnr+GCYTKauzy9b2BGf
         6b4g==
X-Gm-Message-State: APjAAAUaWcVZDEWQOfafJXaXamGzcrYKNRA/6yEkLdpUrTN7QiqIk1UH
        n7h/icjM9qrbTvW8Fmf4JuuzOQ==
X-Google-Smtp-Source: APXvYqzVtXIxqFwTgM8EzEXOeQXVyES/27218XIBMarVRmRWmUa/XKEZAMMJKYyORixUr2FpTKApSw==
X-Received: by 2002:a2e:9950:: with SMTP id r16mr45976579ljj.173.1561332668839;
        Sun, 23 Jun 2019 16:31:08 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id 80sm1325307lfz.56.2019.06.23.16.31.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 23 Jun 2019 16:31:08 -0700 (PDT)
Date:   Mon, 24 Jun 2019 02:31:06 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Keerthy <j-keerthy@ti.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, t-kristo@ti.com,
        grygorii.strashko@ti.com, nsekhar@ti.com
Subject: Re: [PATCH] net: ethernet: ti: cpsw: Fix suspend/resume break
Message-ID: <20190623233105.GA5472@khorivan>
Mail-Followup-To: Keerthy <j-keerthy@ti.com>, davem@davemloft.net,
        andrew@lunn.ch, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, t-kristo@ti.com,
        grygorii.strashko@ti.com, nsekhar@ti.com
References: <20190622103140.22902-1-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190622103140.22902-1-j-keerthy@ti.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 22, 2019 at 04:01:40PM +0530, Keerthy wrote:

Hi Keerty,

>Commit bfe59032bd6127ee190edb30be9381a01765b958 ("net: ethernet:
>ti: cpsw: use cpsw as drv data")changes
>the driver data to struct cpsw_common *cpsw. This is done
>only in probe/remove but the suspend/resume functions are
>still left with struct net_device *ndev. Hence fix both
>suspend & resume also to fetch the updated driver data.
>
>Fixes: bfe59032bd6127ee1 ("net: ethernet: ti: cpsw: use cpsw as drv data")
>Signed-off-by: Keerthy <j-keerthy@ti.com>
>---
> drivers/net/ethernet/ti/cpsw.c | 36 +++++++++++-----------------------
> 1 file changed, 11 insertions(+), 25 deletions(-)
>
>diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
>index 7bdd287074fc..2aeaad15e20e 100644
>--- a/drivers/net/ethernet/ti/cpsw.c
>+++ b/drivers/net/ethernet/ti/cpsw.c
>@@ -2590,20 +2590,12 @@ static int cpsw_remove(struct platform_device *pdev)
> #ifdef CONFIG_PM_SLEEP
> static int cpsw_suspend(struct device *dev)
> {
>-	struct net_device	*ndev = dev_get_drvdata(dev);
>-	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
>-
>-	if (cpsw->data.dual_emac) {
>-		int i;
>+	struct cpsw_common *cpsw = dev_get_drvdata(dev);
>+	int i;
>
>-		for (i = 0; i < cpsw->data.slaves; i++) {
>-			if (netif_running(cpsw->slaves[i].ndev))
>-				cpsw_ndo_stop(cpsw->slaves[i].ndev);
>-		}
>-	} else {
>-		if (netif_running(ndev))
>-			cpsw_ndo_stop(ndev);
>-	}
>+	for (i = 0; i < cpsw->data.slaves; i++)
>+		if (netif_running(cpsw->slaves[i].ndev))
Seems I've missed to add this, but in your fix potential issue in switch mode.
ndev is not necessarily present for slave, you need to check on ndev != null
before using it, if you still remove cpsw->data.dual_emac ofc.

Thanks.

>+			cpsw_ndo_stop(cpsw->slaves[i].ndev);
>
> 	/* Select sleep pin state */
> 	pinctrl_pm_select_sleep_state(dev);
>@@ -2613,25 +2605,19 @@ static int cpsw_suspend(struct device *dev)
>
> static int cpsw_resume(struct device *dev)
> {
>-	struct net_device	*ndev = dev_get_drvdata(dev);
>-	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
>+	struct cpsw_common *cpsw = dev_get_drvdata(dev);
>+	int i;
>
> 	/* Select default pin state */
> 	pinctrl_pm_select_default_state(dev);
>
> 	/* shut up ASSERT_RTNL() warning in netif_set_real_num_tx/rx_queues */
> 	rtnl_lock();
>-	if (cpsw->data.dual_emac) {
>-		int i;
>
>-		for (i = 0; i < cpsw->data.slaves; i++) {
>-			if (netif_running(cpsw->slaves[i].ndev))
>-				cpsw_ndo_open(cpsw->slaves[i].ndev);
>-		}
>-	} else {
>-		if (netif_running(ndev))
>-			cpsw_ndo_open(ndev);
>-	}
>+	for (i = 0; i < cpsw->data.slaves; i++)
>+		if (netif_running(cpsw->slaves[i].ndev))
>+			cpsw_ndo_open(cpsw->slaves[i].ndev);
>+
same here

> 	rtnl_unlock();
>
> 	return 0;
>-- 
>2.17.1
>

-- 
Regards,
Ivan Khoronzhuk
