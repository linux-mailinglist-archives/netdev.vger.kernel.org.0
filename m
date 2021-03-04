Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC0932CAD2
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 04:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhCDD3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 22:29:02 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.23]:31643 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbhCDD2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 22:28:35 -0500
X-Greylist: delayed 720 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2021 22:28:35 EST
ARC-Seal: i=1; a=rsa-sha256; t=1614827561; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=cZQ2GivNJawW/PW6eTmbjUAKtucWmOzorflkLT4nQwsTHgYDsuFMCEUsfRL0f6b8SG
    iABtrwpTTwGTcTj8Tk9J7MXOOSIRRVrQaS+hAkZxwy6ZkIQDRMQs3Zp/Sa7FqcDElnU4
    ZEJETddEfPQkrXl7Zou/ajdItnR+TpBvwojm7/f4dDNvccXLJOLXmDk2M08I8oK70+Sn
    xgZB27vp3Dqs41/iCNOpJeR/fSRIzFIIegKw8AO/+527Fuw2vYYERMqdjoqdmcmehtKe
    NAyJRhpEG8OXmrez33dWUA0/NnPaekb5jr9OXFir27UZdbQJyWipZTUQBzI/XX2h2nan
    fMUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1614827561;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=3pVm9+VOEtsZ8ory3qCwMgGP7xM9GxWl/SI2czOoEbY=;
    b=k0IvGKJs89UqMrs27VhHX6c4wC7j1lAD1ahuvSreKMwWKwMAdEn5ABZ+lskGo1r0jw
    gwgZrGseOC+b9ovaJWZP3JVq/+X1YwW3cMM8xChkQXYyNI77//ItTV4BjFpXhoj4SZqt
    Oa9AQ3ZgH+N3wUAxKSzaZaOXQrN5yOlvdnI8FAwcZmUzMKIoCO2xwbOe3/bg8dAFKLH4
    imSqynXZThKUa+1Rae85V8DVk3JGm41Vn0tJoFBk8xgJfGbXi4SCLx3vz+afjGmY3Fmk
    HwPAwN3R45RAbXt+day2EcQK8bu+PKZzqe0yLzITbUJdM0HL5JOnKQYvxtjpl/Yzq96j
    XHsA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1614827561;
    s=strato-dkim-0002; d=fami-braun.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=3pVm9+VOEtsZ8ory3qCwMgGP7xM9GxWl/SI2czOoEbY=;
    b=HPbdVy9JBczTFKxbB94b31BGUKTSqjbsarPJybVP5nOTlobF1GpRQTEYq9fehEj3T2
    /W1aiSwg2qn4Isr08/BMazeuQGFUbCitaWuOfLrQdGa2BkTDlwJXCrETi1r8L+ApIL1D
    PaUqnXdWU/ZXUhsjdTjtot40s7QtMU8aWaHD3agWQrIkYPmwx+W9VagL3AjDXqzbx22i
    a5uu97Lquw3K/xmW8xhWBJf3jvxgTDsLP0aHUXY4AmSTJqFBksWbZOlu9Iy+1qCnmMxG
    n7ihqDDyTdix1+meMWrIoaThmd370yDMd0iDonjtmU0B8+SlEzon7pl1rGvFf617OAku
    QNQA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpcA5nVfJ6oTd1q4vkpJiSs8OZgFrCn13AmHhe7AN5AhGyFbC6Mg=="
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
    by smtp.strato.de (RZmta 47.20.2 AUTH)
    with ESMTPSA id N06b68x243CfGye
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 4 Mar 2021 04:12:41 +0100 (CET)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id B0AC015415F;
        Thu,  4 Mar 2021 04:12:40 +0100 (CET)
Received: by dynamic.fami-braun.de (fami-braun.de, from userid 1001)
        id 786CC15823D; Thu,  4 Mar 2021 04:12:40 +0100 (CET)
From:   michael-dev@fami-braun.de
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org, Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH] gianfar: fix jumbo packets+napi+rx overrun crash
Date:   Thu,  4 Mar 2021 04:12:38 +0100
Message-Id: <20210304031238.28880-1-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Braun <michael-dev@fami-braun.de>

When using jumbo packets and overrunning rx queue with napi enabled,
the following sequence is observed in gfar_add_rx_frag:

   | lstatus                              |       | skb                   |
t  | lstatus,  size, flags                | first | len, data_len, *ptr   |
---+--------------------------------------+-------+-----------------------+
13 | 18002348, 9032, INTERRUPT LAST       | 0     | 9600, 8000,  f554c12e |
12 | 10000640, 1600, INTERRUPT            | 0     | 8000, 6400,  f554c12e |
11 | 10000640, 1600, INTERRUPT            | 0     | 6400, 4800,  f554c12e |
10 | 10000640, 1600, INTERRUPT            | 0     | 4800, 3200,  f554c12e |
09 | 10000640, 1600, INTERRUPT            | 0     | 3200, 1600,  f554c12e |
08 | 14000640, 1600, INTERRUPT FIRST      | 0     | 1600, 0,     f554c12e |
07 | 14000640, 1600, INTERRUPT FIRST      | 1     | 0,    0,     f554c12e |
06 | 1c000080, 128,  INTERRUPT LAST FIRST | 1     | 0,    0,     abf3bd6e |
05 | 18002348, 9032, INTERRUPT LAST       | 0     | 8000, 6400,  c5a57780 |
04 | 10000640, 1600, INTERRUPT            | 0     | 6400, 4800,  c5a57780 |
03 | 10000640, 1600, INTERRUPT            | 0     | 4800, 3200,  c5a57780 |
02 | 10000640, 1600, INTERRUPT            | 0     | 3200, 1600,  c5a57780 |
01 | 10000640, 1600, INTERRUPT            | 0     | 1600, 0,     c5a57780 |
00 | 14000640, 1600, INTERRUPT FIRST      | 1     | 0,    0,     c5a57780 |

So at t=7 a new packets is started but not finished, probably due to rx
overrun - but rx overrun is not indicated in the flags. Instead a new
packets starts at t=8. This results in skb->len to exceed size for the LAST
fragment at t=13 and thus a negative fragment size added to the skb.

This then crashes:

kernel BUG at include/linux/skbuff.h:2277!
Oops: Exception in kernel mode, sig: 5 [#1]
...
NIP [c04689f4] skb_pull+0x2c/0x48
LR [c03f62ac] gfar_clean_rx_ring+0x2e4/0x844
Call Trace:
[ec4bfd38] [c06a84c4] _raw_spin_unlock_irqrestore+0x60/0x7c (unreliable)
[ec4bfda8] [c03f6a44] gfar_poll_rx_sq+0x48/0xe4
[ec4bfdc8] [c048d504] __napi_poll+0x54/0x26c
[ec4bfdf8] [c048d908] net_rx_action+0x138/0x2c0
[ec4bfe68] [c06a8f34] __do_softirq+0x3a4/0x4fc
[ec4bfed8] [c0040150] run_ksoftirqd+0x58/0x70
[ec4bfee8] [c0066ecc] smpboot_thread_fn+0x184/0x1cc
[ec4bff08] [c0062718] kthread+0x140/0x144
[ec4bff38] [c0012350] ret_from_kernel_thread+0x14/0x1c

This patch fixes this by checking for computed LAST fragment size, so a
negative sized fragment is never added.
In order to prevent the newer rx frame from getting corrupted, the FIRST
flag is checked to discard the incomplete older frame.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 drivers/net/ethernet/freescale/gianfar.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 541de32ea662..2aecae23bfd0 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2390,6 +2390,10 @@ static bool gfar_add_rx_frag(struct gfar_rx_buff *rxb, u32 lstatus,
 		if (lstatus & BD_LFLAG(RXBD_LAST))
 			size -= skb->len;
 
+		WARN(size < 0, "gianfar: rx fragment size underflow");
+		if (size < 0)
+			return false;
+
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
 				rxb->page_offset + RXBUF_ALIGNMENT,
 				size, GFAR_RXB_TRUESIZE);
@@ -2552,6 +2556,16 @@ static int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue,
 		if (lstatus & BD_LFLAG(RXBD_EMPTY))
 			break;
 
+		/* lost RXBD_LAST descriptor due to overrun */
+		if (skb &&
+		    (lstatus & BD_LFLAG(RXBD_FIRST))) {
+			/* discard faulty buffer */
+			dev_kfree_skb(skb);
+			skb = NULL;
+
+			/* can continue normally */
+		}
+
 		/* order rx buffer descriptor reads */
 		rmb();
 
-- 
2.20.1

