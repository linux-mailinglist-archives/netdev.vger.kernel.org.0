Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBFE5B985
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 12:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfGAKyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 06:54:13 -0400
Received: from mout.web.de ([212.227.17.12]:54309 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727748AbfGAKyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 06:54:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561978413;
        bh=9QwErlRZh+JV5gna2Uztd7nQg7/e3OjouvCwXsnc3aA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=UxO7E9rgJEdJxnEEoMyOc9JjomVwWoHDlFFYA9TW6ARbg/23fD7PNnD02/FCqswJc
         ++k+H/R7ChBMrI7+MbXsUUMOpDSam0oaZQ8hy4OIeycujlDrYSaJNKIaw12tDFWgv1
         wrLvPJ9PkEpcae7P4BE2acJiwFMEZdCYNsQr+mMQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from platinum.localdomain ([77.13.129.177]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MhUbO-1hvb4g3iBG-00MdMP; Mon, 01
 Jul 2019 12:53:33 +0200
From:   Soeren Moch <smoch@web.de>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Soeren Moch <smoch@web.de>, stable@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] rt2x00usb: fix rx queue hang
Date:   Mon,  1 Jul 2019 12:53:13 +0200
Message-Id: <20190701105314.9707-1-smoch@web.de>
X-Mailer: git-send-email 2.17.1
X-Provags-ID: V03:K1:viXei3FjGw3mDh1/8pWh2EeoS3tIgkTWKIkpwYPI9ffckp7S9gA
 qf72dLxuNvDkJIRmNRO2VZi6NgCAa/ZZcKQgBahvRdJJgrDVcHUo1y30He9O2bwLMbSToev
 YJ3Qs1pMjE3BbyCu6S+knwGwb5q2BP+rs6WBdmfStHZ/5guSCrkUOKtqnSHiYnDQuncAwFX
 kZ4zq4ch7nObcxAfaqrFg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yn3Fskms/pk=:K+xu3zWN3SlAshSCo3qqJx
 M2iTczv+w8lZxC0iziu2Kmyt+SMIvHLLLedRm9M4ikRv3xuGT7vdj5ZBzORow6KZXTAsZirl6
 Fo3asvNvJxT7dvD15qM8XqYisvu/P1ezCEpWd+7cXVneduawxrzP8Dgwm4CZFKIxjsmjdpk2r
 aO/3W/f0qZPa6C5HgNilSWFvibLJmYIOf6KUSg0tl2udsaeIcEh2Zk8rEgknKq2FF2JUGbmMG
 yQgMGiSQ1IAI0TUPXEd885H91SWHdIkmpPXFxeyKW/1IpEfdQi5FC54UNA0+QvrhA4kcbFXN6
 NB1tqGCXm1sqv+mlkM3U8ixG7raQKiWdFGhQlToqlFxae6qa8b0XfWVU9QpxNxBJOWcBbWbRf
 RHw0s4UZzGl1Pnl5OiwOQdXMRj2vAv1EOCW3/BAnWoN41HmSPVh/Y7R7GeyqE5max7Dmulu86
 X22feKNnOMXDiIl41om/OhKxxl1YYzAkgeUTALF7oD6dNdSFGKQs7Hyfum2Mtu0R3Km96vSkv
 7bZRQUyj/7AQY4UCmHsbRoBVz3DuLqmPhXbJSzzW598RaMwpE9BrJjKC0RZ7OY4mKGkMfGycj
 xGY7RX20puu19mem60gb6zFD1bmOelrdIApA6IzEwE0nCOwzSd/m+ap9p5lEPv26UymIctpup
 EHlrYPF3kXmG719jG4tKrpsloLmIHuKuYHsJ21bOz/w16je/xxQSUphhYZzyiZVFnZZOpRfwr
 xDr1o/iW5qmpXS+YVPJ7BdVNOVKdEmd5FN5pnPnIDesMa5lzXbyTM7pt26xa0gAAM0E6U9JPi
 hrrl9hInSnetourhPW6jlpF1vEI0eRFEAfV2uARARH4f7hSAUxwFdnY1zhQ00gXDnRK/9C04i
 zajxlrm8aEpKvNStZTvhWA+PJHqgWgNXppQPuvoywM3yDey2QJJlB5K8quOKL/59w+aBnINHN
 W0lMbTtcnXotD5STkqYq899ZnlbfQHyrVzLt6PD/AByktOe2uKebFKW6dlZWkvSxzybGU6Ww/
 gxlcJkED6OviZCHN3O+pu9my8TGRC2AtlPyaOWTywhR1skckcL4ScpiEHSws530fJg==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit ed194d136769 ("usb: core: remove local_irq_save() around
 ->complete() handler") the handler rt2x00usb_interrupt_rxdone() is
not running with interrupts disabled anymore. So this completion handler
is not guaranteed to run completely before workqueue processing starts
for the same queue entry.
Be sure to set all other flags in the entry correctly before marking
this entry ready for workqueue processing. This way we cannot miss error
conditions that need to be signalled from the completion handler to the
worker thread.
Note that rt2x00usb_work_rxdone() processes all available entries, not
only such for which queue_work() was called.

This patch is similar to what commit df71c9cfceea ("rt2x00: fix order
of entry flags modification") did for TX processing.

This fixes a regression on a RT5370 based wifi stick in AP mode, which
suddenly stopped data transmission after some period of heavy load. Also
stopping the hanging hostapd resulted in the error message "ieee80211
phy0: rt2x00queue_flush_queue: Warning - Queue 14 failed to flush".
Other operation modes are probably affected as well, this just was
the used testcase.

Fixes: ed194d136769 ("usb: core: remove local_irq_save() around ->complete=
() handler")
Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Soeren Moch <smoch@web.de>
=2D--
Changes in v2:
 complete rework

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
=2D--
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/=
wireless/ralink/rt2x00/rt2x00usb.c
index 67b81c7221c4..7e3a621b9c0d 100644
=2D-- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -372,14 +372,9 @@ static void rt2x00usb_interrupt_rxdone(struct urb *ur=
b)
 	struct queue_entry *entry =3D (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev =3D entry->queue->rt2x00dev;

-	if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+	if (!test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;

-	/*
-	 * Report the frame as DMA done
-	 */
-	rt2x00lib_dmadone(entry);
-
 	/*
 	 * Check if the received data is simply too small
 	 * to be actually valid, or if the urb is signaling
@@ -388,6 +383,11 @@ static void rt2x00usb_interrupt_rxdone(struct urb *ur=
b)
 	if (urb->actual_length < entry->queue->desc_size || urb->status)
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);

+	/*
+	 * Report the frame as DMA done
+	 */
+	rt2x00lib_dmadone(entry);
+
 	/*
 	 * Schedule the delayed work for reading the RX status
 	 * from the device.
=2D-
2.17.1

