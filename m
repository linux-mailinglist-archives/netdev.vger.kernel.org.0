Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C64D1AFAF7
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 15:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgDSNu5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 19 Apr 2020 09:50:57 -0400
Received: from piie.net ([80.82.223.85]:49180 "EHLO piie.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgDSNu4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 09:50:56 -0400
Received: from mail.piie.net (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
        (Client did not present a certificate)
        by piie.net (Postfix) with ESMTPSA id BC23C1613;
        Sun, 19 Apr 2020 15:50:35 +0200 (CEST)
Mime-Version: 1.0
Date:   Sun, 19 Apr 2020 13:50:35 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: RainLoop/1.11.3
From:   "=?utf-8?B?UGV0ZXIgS8Okc3RsZQ==?=" <peter@piie.net>
Message-ID: <a3f6a008696d87acb67db06c21eb600d@piie.net>
Subject: Re: [RFC v3 1/2] thermal: core: Let thermal zone device's mode be
 stored in its struct
To:     "Andrzej Pietrasiewicz" <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org
Cc:     "Zhang Rui" <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        "Len Brown" <lenb@kernel.org>, "Jiri Pirko" <jiri@mellanox.com>,
        "Ido Schimmel" <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Darren Hart" <dvhart@infradead.org>,
        "Andy Shevchenko" <andy@infradead.org>,
        "Support Opensource" <support.opensource@diasemi.com>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Amit Kucheria" <amit.kucheria@verdurent.com>,
        "Shawn Guo" <shawnguo@kernel.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        "Fabio Estevam" <festevam@gmail.com>,
        "NXP Linux Team" <linux-imx@nxp.com>,
        "Allison Randal" <allison@lohutok.net>,
        "Enrico Weigelt" <info@metux.net>,
        "Gayatri Kammela" <gayatri.kammela@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com,
        "Barlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>
In-Reply-To: <20200417162020.19980-2-andrzej.p@collabora.com>
References: <20200417162020.19980-2-andrzej.p@collabora.com>
 <9ac3b37a-8746-b8ee-70e1-9c876830ac83@linaro.org>
 <20200417162020.19980-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

17. April 2020 18:20, "Andrzej Pietrasiewicz" <andrzej.p@collabora.com> schrieb:

> Thermal zone devices' mode is stored in individual drivers. This patch
> changes it so that mode is stored in struct thermal_zone_device instead.
> 
> As a result all driver-specific variables storing the mode are not needed
> and are removed. Consequently, the get_mode() implementations have nothing
> to operate on and need to be removed, too.
> 
> Some thermal framework specific functions are introduced:
> 
> thermal_zone_device_get_mode()
> thermal_zone_device_set_mode()
> thermal_zone_device_enable()
> thermal_zone_device_disable()
> 
> thermal_zone_device_get_mode() and its "set" counterpart take tzd's lock
> and the "set" calls driver's set_mode() if provided, so the latter must
> not take this lock again. At the end of the "set"
> thermal_zone_device_update() is called so drivers don't need to repeat this
> invocation in their specific set_mode() implementations.
> 
> The scope of the above 4 functions is purposedly limited to the thermal
> framework and drivers are not supposed to call them. This encapsulation
> does not fully work at the moment for some drivers, though:
> 
> - platform/x86/acerhdf.c

Acked-by: Peter Kaestle <peter@piie.net>

[...]

-- 
--peter;
