Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F2F1E812A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgE2PFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgE2PFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:05:53 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA35C03E969;
        Fri, 29 May 2020 08:05:52 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m7so1262786plt.5;
        Fri, 29 May 2020 08:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=/9QtcEbKXfSNd6feJXtVNBLkm/HB/zDagS27p6rwHqQ=;
        b=qSTu3FS1pH6rTOhpEl7mQBPlB0nfj8DPoBnNJBjGJle0vPvr7h+0pzEf46FzYRp27K
         oupOOhVj00G0SWyvIa6wOWeRbcm+9+COI14yoWHxJWpJIoSDx+AP36Ox4QWShXTGNZxN
         TxNkEiXdQQ9kY1huboUiQ+2kC/e6Aih6vjiUX3CQoEa6CwMQKX7IQKpJU0v4jYKtZPm2
         HNIdojbfSui/yD8HKZq1d++WtYy8Q4W5cZ4e7l9/vgFWt0U4KHS2ubxYSBOAYDZ89Unj
         LhG/A5ZUkMuhAVUk0XM9tRPDxwR/WS+7DJuWESvgkRbh3eMDTFArLl4L0Zmo4oKgR8u3
         0EEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=/9QtcEbKXfSNd6feJXtVNBLkm/HB/zDagS27p6rwHqQ=;
        b=QO8f2KsprAJmBA40jLRKUdhf+j0h51jk8ib57jGQnQwLwdE9p7wV8uJJH9IYorj1+S
         kdTs8pkVdMR1m4bvz5lieW7VF8MC0Gnx3OEtw+HKDcVAw/deHjhkglB6njkBpsworE6c
         v6nplP1hIFuG+elWHNickegkexNSGGlfxb7mTniPm/mjwdXLs/QH7owvbPXahUzgL2h4
         U42DOkE+Et0SRiBjl0IcC+NndJpvka+iSNo8okkvZG03sEU3YxmVqpv/sOLPXuIMXxB7
         7Od955gQItLtCHZiAPx3WxTK1/LywE+BRdEklgCgyXdr38v3d1kowDl2lEjfxaDEGMYk
         +RTA==
X-Gm-Message-State: AOAM531rYDczjoIE1wsvBbN0A8DQgNINiuA17J0mJ0itpPLf/azUSbGU
        FL6gBWqtYhzfshKid8ArSqY=
X-Google-Smtp-Source: ABdhPJx1brJDIFAXFe0nbUSyhXFeAV3BsFWLNPpVKbWXwwZAgQOrMCreap/a2uy/VNLw/df7eQUMbg==
X-Received: by 2002:a17:90a:f40a:: with SMTP id ch10mr9777692pjb.161.1590764751884;
        Fri, 29 May 2020 08:05:51 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w19sm7592452pfq.43.2020.05.29.08.05.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2020 08:05:50 -0700 (PDT)
Date:   Fri, 29 May 2020 08:05:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel@collabora.com, Fabio Estevam <festevam@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Allison Randal <allison@lohutok.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Darren Hart <dvhart@infradead.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Len Brown <lenb@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ido Schimmel <idosch@mellanox.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Enrico Weigelt <info@metux.net>,
        Peter Kaestle <peter@piie.net>,
        Sebastian Reichel <sre@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>, Shawn Guo <shawnguo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy@infradead.org>
Subject: Re: [PATCH v4 02/11] thermal: Store thermal mode in a dedicated enum
Message-ID: <20200529150549.GA154196@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 09:20:42PM +0200, Andrzej Pietrasiewicz wrote:
> Prepare for storing mode in struct thermal_zone_device.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

What is the baseline for this series ? I can't get this patch to apply
on top of current mainline, nor on v5.6, nor on top of linux-next.

Thanks,
Guenter
