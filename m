Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE2B27B86F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgI1Xpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:45:44 -0400
Received: from mout.gmx.net ([212.227.17.22]:58125 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgI1Xpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601336743;
        bh=sMWbZD5vC0MdeV/KmHDoQvXbINr4rV74Xjinnuzwk2g=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=TvgOwOk4ULaFXvq0oC2+f/DlNeClHHmTGx9qtIyAgV/arAKiLNd2377WbBHecWUYY
         p6QuJY8oFI7A/duXkydebQmbG8O/gxF0cc4C09yLCBgiLpElgn6iBBwA9R9FQpe9BC
         dAdiEJ4eI8x8eRLqTA7xidDT/SuUdBWz6DDvSzQk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from PC1310.gateway.sonic.net ([173.228.6.223]) by mail.gmx.com
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1N3bX1-1kVeEn3BeV-010aXx; Tue, 29 Sep 2020 00:01:03 +0200
From:   Kevin Brace <kevinbrace@gmx.com>
To:     netdev@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@bracecomputerlab.com>
Subject: [PATCH net 1/4] via-rhine: Fix for the hardware having a reset failure after resume
Date:   Mon, 28 Sep 2020 15:00:38 -0700
Message-Id: <20200928220041.6654-2-kevinbrace@gmx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200928220041.6654-1-kevinbrace@gmx.com>
References: <20200928220041.6654-1-kevinbrace@gmx.com>
X-Provags-ID: V03:K1:OCI5NfQi0rWaGreMHFD/EZMsksM9t6soXTPQZyzUHfs1hV9K3qJ
 NnE4yFnpnXMpB5lWfI7XpzvedrU7S5OsTLgS4GEcLUYalQgxWu96rRLpMVDs4KnMFJDH7UO
 MrEAkWlI34Rlx1EnVPfm3ipFgL7z37+mhjW7sAl5HBPuoagL9mDV704ty47Uf3R7WNk8T5g
 klYcxd7AopEr1WGUCkItA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:e7iNnM10z0M=:N9pUK9fEiAr8CAO2xn/wh9
 b6bQcnkPjpi7DbcgG3qU+kLLEw5y63rUBeRZSzVQ0ZzPOoSFNrGqKpqT7Ikk6Z/CnEwARX1eF
 cqiGJLp6dBGprQ5ggXNMccJx9gZutEMXPAndS/hoA9zSRUl6FzUiWTLjhx5DsncJ+Js++i5fs
 YqGIl8kjDaOEJ+S+ET60FfPG2y6EjHhaBZHl5w3p9+QWaVWxAlDw7kwxzAxwnFDSLSs9aHEb1
 O5y/qEyyyp6P4WS+RRXPfxjxLf3jy8x2ykvJSdk94eVEOsS67oHr6SvN1RZqIhQk0T/calGms
 8kRqD4ZGUN6rO39qmteSHpVA4P4izfqUjBR+1SHAMk04Lo1x48DWISNMLY0JkJU+7Jfd2H1m2
 WZ18pYuG11CXXZBNBeUXX6V4Gz1bhqQEjUaYLCvPTRuKV7/MiAS7MVtzhqjTxOSv1buPUEBrs
 qSh5VD/j+vh0uJ8LfbiRvmSh0nYoFVWjahMO6PAvMNqcRf0ecu8sXoJ/0+9Qm7IM32oA9ndkf
 Ee1FRr91Mepst7ip7TAfYacBjaCn9G+L8maIWU4gZ5FVWZKQ5q1ms/lWy58lnCTrmCy6lpxp8
 K4UviCZMCbab1Aht+OP1GNosS0QB73ZCzvTOGYLJiq6dKYD72LyWOvg5brqdo5QowQJqUzCvp
 b58Op7mRvIJosl5krTtscpj4TYacRq70KRBjYg5w+aPmFwJrPa7Je8wCMbNkfdS7IUI5BH6ES
 8ABivwO80QqJBI55Y2puur2UgkJmHkVcE6fMipSUwrJBWbhvPJA30NT7Je6c/S9OIsxOQWGH1
 ZXE6PSAFQipmCILEp8SWgAVMPG4y1J98l2ZH5qu/cXN2AIXLf8KCoVKXlTZ3iMo/NvlG2IyTB
 fneK/0LiCobTo7SGzy/uRWgxnJvKYNo/MyYUdsniQ/+XPD+hGPMx8GKFcKp9AXzVP/3Xe9CUi
 9QnCUQrf5YsM3ITKZdj/IGdOEP8WbtlBRzka4T1oO7o1NczdEZjlZ1xAjZULeUe8uKm+kT9Zl
 1jxsAQifCKtSbPnMali9Wvwog1EqunRBttpDap3RmxK2q/3sDefkJOEitwxew7ZWH1saQDV8z
 vJSzWdGPyYIv4maq53Or+22X3ncmFXOox3GbpfGVuU0xiIUGeQeYUbRQzXNy97v5twCl8D9gW
 qvPFpgzgRN9SyzG5B3jwb+eEt55op+1V0Sn0P6YZ9A8yt3riGRxqQc4QUx0VxCDAXEubg2vFw
 9VpxLfWTJsWHUuwccAy7bOC6lweSe43L6SzIagQ==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Brace <kevinbrace@bracecomputerlab.com>

In rhine_resume() and rhine_suspend(), the code calls netif_running()
to see if the network interface is down or not.  If it is down (i.e.,
netif_running() returning false), they will skip any housekeeping work
within the function relating to the hardware.  This becomes a problem
when the hardware resumes from a standby since it is counting on
rhine_resume() to map its MMIO and power up rest of the hardware.
Not getting its MMIO remapped and rest of the hardware powered
up lead to a soft reset failure and hardware disappearance.  The
solution is to map its MMIO and power up rest of the hardware inside
rhine_open() before soft reset is to be performed.  This solution was
verified on ASUS P5V800-VM mainboard's integrated Rhine-II Ethernet
MAC inside VIA Technologies VT8251 South Bridge.

Signed-off-by: Kevin Brace <kevinbrace@bracecomputerlab.com>
=2D--
 drivers/net/ethernet/via/via-rhine.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/v=
ia/via-rhine.c
index 803247d51fe9..a20492da3407 100644
=2D-- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1706,6 +1706,8 @@ static int rhine_open(struct net_device *dev)
 		goto out_free_ring;

 	alloc_tbufs(dev);
+	enable_mmio(rp->pioaddr, rp->quirks);
+	rhine_power_init(dev);
 	rhine_chip_reset(dev);
 	rhine_task_enable(rp);
 	init_registers(dev);
=2D-
2.17.1

