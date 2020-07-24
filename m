Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9E522C0F6
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 10:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgGXIjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 04:39:13 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:37284 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGXIjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 04:39:13 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A08CA1C0BD5; Fri, 24 Jul 2020 10:39:11 +0200 (CEST)
Date:   Fri, 24 Jul 2020 10:39:10 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] ath9k: Fix typo in function name
Message-ID: <20200724083910.GA31930@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Typo "destoy" made me wonder if correct patch is wrong; fix it. No
functional change.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>


diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireles=
s/ath/ath9k/hif_usb.c
index 4ed21dad6a8e..1bb55b9532c9 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1373,7 +1373,7 @@ static void ath9k_hif_usb_disconnect(struct usb_inter=
face *interface)
 	if (hif_dev->flags & HIF_USB_READY) {
 		ath9k_htc_hw_deinit(hif_dev->htc_handle, unplugged);
 		ath9k_hif_usb_dev_deinit(hif_dev);
-		ath9k_destoy_wmi(hif_dev->htc_handle->drv_priv);
+		ath9k_destroy_wmi(hif_dev->htc_handle->drv_priv);
 		ath9k_htc_hw_free(hif_dev->htc_handle);
 	}
=20
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wi=
reless/ath/ath9k/htc_drv_init.c
index 1d6ad8d46607..ac79dfd5be7a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -973,7 +973,7 @@ int ath9k_htc_probe_device(struct htc_target *htc_handl=
e, struct device *dev,
 	ath9k_stop_wmi(priv);
 	hif_dev =3D (struct hif_device_usb *)htc_handle->hif_dev;
 	ath9k_hif_usb_dealloc_urbs(hif_dev);
-	ath9k_destoy_wmi(priv);
+	ath9k_destroy_wmi(priv);
 err_free:
 	ieee80211_free_hw(hw);
 	return ret;
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/at=
h/ath9k/wmi.c
index e7a3127395be..9cf5ae3f7298 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -121,7 +121,7 @@ void ath9k_stop_wmi(struct ath9k_htc_priv *priv)
 	mutex_unlock(&wmi->op_mutex);
 }
=20
-void ath9k_destoy_wmi(struct ath9k_htc_priv *priv)
+void ath9k_destroy_wmi(struct ath9k_htc_priv *priv)
 {
 	kfree(priv->wmi);
 }
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/at=
h/ath9k/wmi.h
index d8b912206232..9386b3a9d303 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -189,7 +189,7 @@ void ath9k_wmi_event_tasklet(unsigned long data);
 void ath9k_fatal_work(struct work_struct *work);
 void ath9k_wmi_event_drain(struct ath9k_htc_priv *priv);
 void ath9k_stop_wmi(struct ath9k_htc_priv *priv);
-void ath9k_destoy_wmi(struct ath9k_htc_priv *priv);
+void ath9k_destroy_wmi(struct ath9k_htc_priv *priv);
=20
 #define WMI_CMD(_wmi_cmd)						\
 	do {								\

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8ani4ACgkQMOfwapXb+vKEsgCfRQav37v1rOlcIXZFDyUfn07L
+6gAnA3+j5CZy4OQ8wyn7tzGWLliIbBe
=mgqb
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
