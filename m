Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398F95B981
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 12:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfGAKxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 06:53:53 -0400
Received: from mout.web.de ([217.72.192.78]:48907 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727748AbfGAKxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 06:53:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561978413;
        bh=I/QjOQfnNEp+6gWnTdhnQHhx6cwc6tKomQBR2IAazMo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Ttk+HU8XcYXObRs9tbo1R4nUtucJ64v7kQpyNAyvBamwemwlGTfVjHr5+/sF2xyZy
         PbQzHqF5B/EpVGYKdPH0q5cYvrMME6CNXeGLuk/I3v1y1ehBSo9TyWcJKZAHwQQtyE
         xcDOysDYP8CTPk89OJcvWa4AurtFbsPGmHPgk+Qs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from platinum.localdomain ([77.13.129.177]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MUWBb-1i8TEM1zUp-00RKKO; Mon, 01
 Jul 2019 12:53:33 +0200
From:   Soeren Moch <smoch@web.de>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Soeren Moch <smoch@web.de>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] rt2x00usb: remove unnecessary rx flag checks
Date:   Mon,  1 Jul 2019 12:53:14 +0200
Message-Id: <20190701105314.9707-2-smoch@web.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190701105314.9707-1-smoch@web.de>
References: <20190701105314.9707-1-smoch@web.de>
X-Provags-ID: V03:K1:OMXn9QTSt153/7tqZJt4i+x+aIEyNHTbfy3eZOSJQUqc7b9dnke
 w9AmAsbOmh22QQQIcCEzPZr71snmLOyi5Y7LKVKJQYd2LeLzzRVK9xW1FHhi3valkx7dB2Y
 zwcO0yV9xrbwZpFYEFIa+kPyIhJPB3eFgz8WzRlONiY8C6mm1oQf2EqEgnp9YHz2iIRs1rh
 zBFCAfZSzRl3xH0J/VTxA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7WaoN3sm11s=:6IY+TMsmNBePJyPrIbBizr
 RfPgWmHkfHkpO/IiEuWNBZ1Ep3MZlpf4Q5cDucsB/AQvVz22lXmDvz6JfCnawugQPtOpbSfHB
 r+QyiO9chdNEI60Sxf1w75nOgfov5hjP6ghHjNHtEdGrLbMKieX1M4CZLkDkMuu3CfNNzurn+
 9EVyXBmC5/McE9NUkAWdYTa099T+JlB+r311V9VRM10grf4CsQZqrpbaLabtsW5RN59KZ46cG
 5ZGkVA6F1yM2SyETaRiZllPSN01G5ukfw4C2pefwGnN3cK1s5jY/9GeIZ2ov9ak6QiaLkub0f
 4kyxOZ78yL3rev+KIUGbIOwGWrFeFVwjyC53I6KaypVIIlrpP6SLIqOJmuV+/MOb4ObENuaQH
 OobvvAa0KpO4ctOIvO+MCv8rm1Qi3juUM7nM7XqSE5QFyG3f/GN9Vihz/Ve7UHml7js37bkuY
 Hx6dotpkbNC3MLWYCm7kMRWikjdHqifWztwyjtKftV0tX3NbT4I2JSfU7kI4WCLTbcpZ7WA5o
 NTFuADH0HSzIcS0oMB1YXv6wvJjiLtEOdoCKaqauMC3VYpAJqbxlziqaXnyE4q+uyh4xZzXNy
 VkgigCAkZ+ftE4q7ofX4oF7BmyCLcXDpeU4gG4KP8qKcFaEsJYxljoJsI8W/DoIHXx5udzXTh
 MElX+hNlikEGxvdb82WRHqq/b5gBG5bWOVcYAHMfh813qCk0ut3+Ll5Qi4D3Tqc2p24rgWlG6
 hpxOrRH1IWw9Q+C6hh/Ffq7YaAIwqT9EBSuZBUoD+JF4f/HbbO4DjrCRudImFlzlwoj6AQjyd
 HBtVWqP6nXGNcSwAMhx1b1vAMYXEND6vujQ5w4WMFGs22vgoo6lolqYvxXscHEBXeAYLfYo+T
 nuDkKkROiVR8CxOcp6WKjuMMjPIHerjLnsQZRrFEVUK4RhqYIlo/jhSsUPwJipwfPtFXOoUnQ
 DZsho3RSb21YMrCUU+CwIzGq6WQSqqDgMYzznd6x7pttMBzk+ynFMaryI1TRMfC2CtQWp6zTM
 w5USkTF0yK22NefyHt55M6l41P7ajRrOpOSauYHyb6hojb8D9S1f99/xDGllxvk/BQ==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In contrast to the TX path, there is no need to separately read the transf=
er
status from the device after receiving RX data. Consequently, there is no
real STATUS_PENDING RX processing queue entry state.
Remove the unnecessary ENTRY_DATA_STATUS_PENDING flag checks from the RX p=
ath.
Also remove the misleading comment about reading RX status from device.

Suggested-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Soeren Moch <smoch@web.de>
=2D--
Changes in v2:
 new patch

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
=2D--
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/=
wireless/ralink/rt2x00/rt2x00usb.c
index 7e3a621b9c0d..bc2dfef0de22 100644
=2D-- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -349,8 +349,7 @@ static void rt2x00usb_work_rxdone(struct work_struct *=
work)
 	while (!rt2x00queue_empty(rt2x00dev->rx)) {
 		entry =3D rt2x00queue_get_entry(rt2x00dev->rx, Q_INDEX_DONE);

-		if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
-		    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
+		if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 			break;

 		/*
@@ -389,8 +388,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb=
)
 	rt2x00lib_dmadone(entry);

 	/*
-	 * Schedule the delayed work for reading the RX status
-	 * from the device.
+	 * Schedule the delayed work for processing RX data
 	 */
 	queue_work(rt2x00dev->workqueue, &rt2x00dev->rxdone_work);
 }
@@ -402,8 +400,7 @@ static bool rt2x00usb_kick_rx_entry(struct queue_entry=
 *entry, void *data)
 	struct queue_entry_priv_usb *entry_priv =3D entry->priv_data;
 	int status;

-	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
-	    test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
+	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return false;

 	rt2x00lib_dmastart(entry);
=2D-
2.17.1

