Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C70927D7B4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgI2UKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:10:08 -0400
Received: from mout.gmx.net ([212.227.17.20]:38675 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbgI2UKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 16:10:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601410203;
        bh=sMWbZD5vC0MdeV/KmHDoQvXbINr4rV74Xjinnuzwk2g=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=gNYgEmzRDDTInOjkXdoGpde/iqR+1Kx38YTPQIoWbWd/wdjdYpkSv/okVDtR73cwc
         +lklFBGujOPdZBeLj0c6QiZRK/hHW87PdK4TwEQ6vBb0O47dsNYFYJsjD5hF9qynrC
         umo6Y4zuEksRsBMAhoQw9BaTjr03O4+L6/6JY+NQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from PC1310.gateway.sonic.net ([173.228.6.223]) by mail.gmx.com
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MxlzC-1kdDpk3yne-00zHUZ; Tue, 29 Sep 2020 22:10:03 +0200
From:   Kevin Brace <kevinbrace@gmx.com>
To:     netdev@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@bracecomputerlab.com>
Subject: [PATCH net v2 1/4] via-rhine: Fix for the hardware having a reset failure after resume
Date:   Tue, 29 Sep 2020 13:09:40 -0700
Message-Id: <20200929200943.3364-2-kevinbrace@gmx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929200943.3364-1-kevinbrace@gmx.com>
References: <20200929200943.3364-1-kevinbrace@gmx.com>
X-Provags-ID: V03:K1:ZoBxt5B4RYaQeAIhB+A0DsymBkQpIY/52GHeJ8JbcKhTos4WxT2
 Ew95bOH0FeGHG7yQAz8yJhcARE/xdkN2u3X0RzJ8kVcGIwk8/wKS9D4e2Wkvo7YeOvotsKz
 mDGCsGHFqYyivx8kyK9sPssuciYdB4CFYZVD0+6YZsGfc8Cu6ax3w03aLxAiEH+eb75Zp/w
 ep9cNQ+7lssnBnmJhTO1Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PS2zRT3JGNA=:6pCjT912keythJ3VjdZuKo
 yfW4rsIe1RX4pm0rYXLI1CWIiCxJILZ+4V42iAGlf0/c8AAJSEUxfkqfpNVuQUK2iWnu/dPtX
 qE5SJ9q/WiahVXfVUg0fYOFzzKAXk+HLzsdYOZe4tJ6kuKzj3mXqjvH1kZF1o5HrHNpKU72oz
 LQtUvzbod2uzM7nfXot+spWA4e+1Oxm8GUl+hd9Opzgn/H6VW7Ao/QNdcn9HGxKY2qYwGlWja
 ajvNoD+EIdBe3dn9Z8dnyq1YmHY6r/4+K1+5FbQlYIPUNtA1x+xZ6EYVAVeam3H5PRLjFGWmZ
 +X6uz4A9YPZYynbnXfeqMTeQfeNaugCWzqkBIbBrFlkF6F+IG4xt4CVcdH1j0Du1FRtG99J2S
 NwKaiB8iH+j10R4K0S/CNZfE3I9UdKhY94UXhAtrrkaDoQ0d2jgrf1mDrvn97vEYuD27FHZnU
 GJxuFP1phpUJL0AjNUEWqllAj4KIwa88fGc+eSsXgK0EaeVM9mS/Evl/oxTHmBMzEE2RWFhgn
 vElRAVLKJHW8NtGumiEsfFH/wWy3XaBdThJC5dDPP0y0rtQ+ztdN7fIyCh9WP0/Lmvd3AWtBz
 T1wb1/b7XVbILMpmQwfJRYh7PMxt0Qvoitqw4mUnXwJ/CXaR7N63lZQHunbmuC217zkuTiwqz
 8wJLyzWlZkQXBx+RzPk99pwFVVoZS6tSHccnRfXbvhUyp0mClsO+PyvQDCHcOQLBykbffMY8v
 4xII7veueckZiyMYs1enuwEWN7At4QHluYvE/Qi9fRteIfQicMkGCKYy8CEPr0tAXC73UiisO
 H7h+mJS1vMw8p8Ivtn3pIkYJmFsGI9sADruwY9ir7nDV+2h8gghtLgW+X7E0nlQLiMq09z1qR
 Lidg/siHt2wEKtC/9hPho5eFTif+cz3rM0aULkI5EvEVeLqIXuQp5bZErPo2H7ByAF8Yttxvx
 xkHr1EaLd4TcU2z7VY6sQq9l24COzxiat/iUhLMvCJp2kTuUn8kJlxejDHDvt857yoWOpW6Ly
 aPECZ7DDc65BfWje2A4brw2M3vfQWn9TcJiNdKGlXsMyqMG2NtcyJcJpe/xeU8K7L0J5Yfz/s
 Y2zZ6faMJr2bcQW6reSCq8IFgNRZOiA39rh52toh1H85ql0vK5GsWYBSF+m3AMua6duziV3U2
 z2xTi7+omGvK0MmkpWOzn1KKHnCWrxVFwSwbSvhFr9D6LP+8RoVcjYPfi3q6lPgDwW191hM9W
 f4AiMwLKk3+das0HtLL7/ngS3wUScJOJPylH4ZQ==
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

