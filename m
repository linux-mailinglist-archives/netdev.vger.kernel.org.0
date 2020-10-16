Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D08A2903F8
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 13:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406030AbgJPL0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 07:26:34 -0400
Received: from mout.gmx.net ([212.227.17.20]:36493 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405448AbgJPL0d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 07:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1602847582;
        bh=YpE5D0lZNVrKgKTRZEOm6pxTQNat1qwWbxmE0RF+aXw=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date;
        b=EPuZyWqiLaGJLLZFEJlOgTiexdUZFyVdC6jEPvuQc63eeTYnk206Oa+73f/bCGkuB
         3UNEuiQGPvge58l5nECs49788hR/lwxt4jitTJBrwbqKi64b6BFYcItQ4dEDVSCKgb
         61ZpDfMoGVLVY+ZNxqn6uxw7prkaJ1IjNef4UZEo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.simpson.net ([188.174.240.147]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MEV3C-1kezWm1Mew-00G2k7; Fri, 16
 Oct 2020 13:26:22 +0200
Message-ID: <9c34e18280bde5c14f40b1ef89a5e6ea326dd5da.camel@gmx.de>
Subject: [patchlet] r8169: fix napi_schedule_irqoff() called with irqs
 enabled warning
From:   Mike Galbraith <efault@gmx.de>
To:     netdev <netdev@vger.kernel.org>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Date:   Fri, 16 Oct 2020 13:26:20 +0200
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xPkaelE4X/6bYTTahYdmjg88PQrdYc6xleJ058q/cJZIYJ0mNkm
 hcvVdQBewQAf+DTpyoVEIshS0rBIp2UUQ5iEYl7kEXpcH9mjmZ4NTELf5VJBTxiSTR0pvBv
 YWDWdh+Twgf34/55GcaDkjDB7Ab2hL6qCxM50+4IeqT5Koa+K6y+epkKZ8hWP5tDQYsWv0E
 /TBlHgoyqR9dC1xy8+agg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5cpYpwLUfEo=:UvzId7ECuPYU/U0m7NDFtS
 9PG8RCk0Q78/zmgIK/LRvJCohMXF68YhxibONEEjqzl8s+b0+y1ptsnENFK5uDaUSQ0pMWWqr
 MazmIBphYuuESPL2FYtXlRyvlwJOHhLZmGAvwZe2KMFQIgJ7Im7prrYdciSK5u8ed5rn4uVH/
 HkIDFjblx6Wi2oEOFqosj8tV2/muNrsGk0yJhbyWRwNakZRzMCaaQwbp/ZwwSysxYurHNGGq9
 6mzlu4uSOpPzlBotqWVXQpri20FX1ZuPiT0rRjPQ+lkl/XzYIIQZ0TnTP67zJAJSnd4LQwbCi
 e21jPzyXGuFwUR0A9+eq0oohbv6biKrppCb0/h4XRdXaJzd4kelTp7Kkgp7G6qGZJPOWXOVRQ
 t+AJTJ3E0ejqwIS4gFKVgZ20IZf4kjBZliRm+QIM2SqnskVW1nNeQ2BQvBut/f02wmTcgzMzv
 TTW0+079Zreyp083ClKlNPVpvaYVNpfxOygRAv0fDvZ7uYYno4gLC07LhAMEDuoCm0tPRoP5E
 e64YbHYawdhzGObxvl+sh7DPRR9+T4+zt0LfKm/ZLyydwOe0+IyZU6gdp+a0bJJlNjrzAnytZ
 l7wD4Q/eqdaECXswYDfhTjpKXJqwbabGN3sDj5jsCeVA/RFxEmQADwIs/l8JoiMetkO6E07Di
 ghLDlws6roOKkYBR3+bWF9awSDm0oQ1yWVbdkLHmg8CK6Dwn+T7+lLat7JfsqX71ibtuLEzcv
 W0YCcBTHuAB9hqAAJ2GUgF6tg0ukq2PUE1YKMWtWGOxrJUrhbJWbxSHOoFtZ7zyqaDhd7tD2k
 POBV27VBk897vC+RbGRCjPb0L9X+iL1D/s8SgnYjtVqCRqrxeOO7SAy6Dds9xfDMJOJCIt9AE
 ubvkVzaGDAhuLb3GDrdg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


When the kernel is built with PREEMPT_RT or booted with threadirqs,
irqs are not disabled when rtl8169_interrupt() is called, inspiring
__raise_softirq_irqoff() to gripe.  Use plain napi_schedule().

Signed-off-by: Mike Galbraith <efault@gmx.de>
=2D--
 drivers/net/ethernet/realtek/r8169_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

=2D-- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4573,7 +4573,7 @@ static irqreturn_t rtl8169_interrupt(int
 	}

 	rtl_irq_disable(tp);
-	napi_schedule_irqoff(&tp->napi);
+	napi_schedule(&tp->napi);
 out:
 	rtl_ack_events(tp, status);


