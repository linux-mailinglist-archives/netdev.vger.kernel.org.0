Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6CF759BCC
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfF1Mkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:40:36 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:33037 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbfF1Mkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 08:40:35 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MVeDq-1i6FHy1JLA-00Rc6H; Fri, 28 Jun 2019 14:38:58 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kees Cook <keescook@chromium.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        James Morris <jmorris@namei.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: [PATCH 3/4] staging: rtl8712: reduce stack usage, again
Date:   Fri, 28 Jun 2019 14:37:48 +0200
Message-Id: <20190628123819.2785504-3-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190628123819.2785504-1-arnd@arndb.de>
References: <20190628123819.2785504-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:SwAfTMK1Aumu7ESGUIoGftrrnsBdgvwtumUFZxzqE6K6pYKg3Hh
 CPXI1Xp6zyKeCpdoillok8GzZC1zgclxe79btk0RScs8jLnpLd+fGTTCrZ6ESfLJRLKodUb
 A9k/gbUt58OMPil1gGcpA2mooDOqb+e3aDyPVhUiDn3oSiyTFH5H5MJRg1qoW6dzbqyUdGL
 jDjc4Mp7grULSM6oELhgQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HJ5BvMyhDYY=:ZGjCg58OgvdTOk3+GUlYTy
 hEKv0rctOxbXrWHKJDdX7PbWJU5ZOnKheKw+GUO0LclmJq0tB5yrdbPw5uM4KXOOWd/+tHyet
 yvuaKWGTu+oaKgVfRYqSTy75qxWPsf05YACe3TmS2v0arArMoxH221cOSSFxtHsXzp+YmdQuk
 n0B9SeZIv76m6mkaZpgmDTZ/ltIgiaRd1DSerERPUq42UkglDkiAaj+JzmR2UR1kj6P1n9WoM
 QetsSc7OnlZIGdEqraWx5kvS+Qe3YCvLDzu9VgHp6UqN9OpTtdNBAKanOWy3t7G4E/J89R+FS
 a3fEFOaAHVOFf4eAjbci9lFXd8GleG/2tqidjem7364VB5qwg7mwY8FeMeaykQ2Rsp7/ZSJ7o
 myIoRhpXLQBadaUpWjBIFyOgh5Y9mt+HchM4AOAbglymeZ4j0MbRQInGobrAAd573cLvKQWiY
 oNv/b2HBrcwmTb+WaQ07x5Dl7y7TSFNfkkrYlqTSXh27nCIsT8P92iYPCGGXKdoF/3oSbMt5d
 rEUMk6zHZOE+Tyq+NsEzw9NOiBM/cMFJXPjBuwDEQN5WBI0G+4uYZNCGER1R+z/HSOeweWqWd
 Thx5UaSW7lJ7zcBK84ATRDl9TmEiJDB33EUOQMkVZPEAEuMImCpf0wLgfsPhnlZ/oS35DsFHX
 0iuZ+v7bWE6JaFm6KnUWINzVSvJbLWqhWxDdxQK+aV2v38TBtKY5d/E7/PENtCDZ3G8BLThYZ
 zJaf5CY4vFIiCnKFCGzDWMXCZ3Hz3vYVaS1DCg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An earlier patch I sent reduced the stack usage enough to get
below the warning limit, and I could show this was safe, but with
GCC_PLUGIN_STRUCTLEAK_BYREF_ALL, it gets worse again because large stack
variables in the same function no longer overlap:

drivers/staging/rtl8712/rtl871x_ioctl_linux.c: In function 'translate_scan.isra.2':
drivers/staging/rtl8712/rtl871x_ioctl_linux.c:322:1: error: the frame size of 1200 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Split out the largest two blocks in the affected function into two
separate functions and mark those noinline_for_stack.

Fixes: 8c5af16f7953 ("staging: rtl8712: reduce stack usage")
Fixes: 81a56f6dcd20 ("gcc-plugins: structleak: Generalize to all variable types")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 157 ++++++++++--------
 1 file changed, 88 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index a224797cd993..fdc1df99d852 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -124,10 +124,91 @@ static inline void handle_group_key(struct ieee_param *param,
 	}
 }
 
-static noinline_for_stack char *translate_scan(struct _adapter *padapter,
-				   struct iw_request_info *info,
-				   struct wlan_network *pnetwork,
-				   char *start, char *stop)
+static noinline_for_stack char *translate_scan_wpa(struct iw_request_info *info,
+						   struct wlan_network *pnetwork,
+						   struct iw_event *iwe,
+						   char *start, char *stop)
+{
+	/* parsing WPA/WPA2 IE */
+	u8 buf[MAX_WPA_IE_LEN];
+	u8 wpa_ie[255], rsn_ie[255];
+	u16 wpa_len = 0, rsn_len = 0;
+	int n, i;
+
+	r8712_get_sec_ie(pnetwork->network.IEs,
+			 pnetwork->network.IELength, rsn_ie, &rsn_len,
+			 wpa_ie, &wpa_len);
+	if (wpa_len > 0) {
+		memset(buf, 0, MAX_WPA_IE_LEN);
+		n = sprintf(buf, "wpa_ie=");
+		for (i = 0; i < wpa_len; i++) {
+			n += snprintf(buf + n, MAX_WPA_IE_LEN - n,
+						"%02x", wpa_ie[i]);
+			if (n >= MAX_WPA_IE_LEN)
+				break;
+		}
+		memset(iwe, 0, sizeof(*iwe));
+		iwe->cmd = IWEVCUSTOM;
+		iwe->u.data.length = (u16)strlen(buf);
+		start = iwe_stream_add_point(info, start, stop,
+			iwe, buf);
+		memset(iwe, 0, sizeof(*iwe));
+		iwe->cmd = IWEVGENIE;
+		iwe->u.data.length = (u16)wpa_len;
+		start = iwe_stream_add_point(info, start, stop,
+			iwe, wpa_ie);
+	}
+	if (rsn_len > 0) {
+		memset(buf, 0, MAX_WPA_IE_LEN);
+		n = sprintf(buf, "rsn_ie=");
+		for (i = 0; i < rsn_len; i++) {
+			n += snprintf(buf + n, MAX_WPA_IE_LEN - n,
+						"%02x", rsn_ie[i]);
+			if (n >= MAX_WPA_IE_LEN)
+				break;
+		}
+		memset(iwe, 0, sizeof(*iwe));
+		iwe->cmd = IWEVCUSTOM;
+		iwe->u.data.length = strlen(buf);
+		start = iwe_stream_add_point(info, start, stop,
+			iwe, buf);
+		memset(iwe, 0, sizeof(*iwe));
+		iwe->cmd = IWEVGENIE;
+		iwe->u.data.length = rsn_len;
+		start = iwe_stream_add_point(info, start, stop, iwe,
+			rsn_ie);
+	}
+
+	return start;
+}
+
+static noinline_for_stack char *translate_scan_wps(struct iw_request_info *info,
+						   struct wlan_network *pnetwork,
+						   struct iw_event *iwe,
+						   char *start, char *stop)
+{
+	/* parsing WPS IE */
+	u8 wps_ie[512];
+	uint wps_ielen;
+
+	if (r8712_get_wps_ie(pnetwork->network.IEs,
+	    pnetwork->network.IELength,
+	    wps_ie, &wps_ielen)) {
+		if (wps_ielen > 2) {
+			iwe->cmd = IWEVGENIE;
+			iwe->u.data.length = (u16)wps_ielen;
+			start = iwe_stream_add_point(info, start, stop,
+				iwe, wps_ie);
+		}
+	}
+
+	return start;
+}
+
+static char *translate_scan(struct _adapter *padapter,
+			    struct iw_request_info *info,
+			    struct wlan_network *pnetwork,
+			    char *start, char *stop)
 {
 	struct iw_event iwe;
 	struct ieee80211_ht_cap *pht_capie;
@@ -240,73 +321,11 @@ static noinline_for_stack char *translate_scan(struct _adapter *padapter,
 	/* Check if we added any event */
 	if ((current_val - start) > iwe_stream_lcp_len(info))
 		start = current_val;
-	/* parsing WPA/WPA2 IE */
-	{
-		u8 buf[MAX_WPA_IE_LEN];
-		u8 wpa_ie[255], rsn_ie[255];
-		u16 wpa_len = 0, rsn_len = 0;
-		int n;
-
-		r8712_get_sec_ie(pnetwork->network.IEs,
-				 pnetwork->network.IELength, rsn_ie, &rsn_len,
-				 wpa_ie, &wpa_len);
-		if (wpa_len > 0) {
-			memset(buf, 0, MAX_WPA_IE_LEN);
-			n = sprintf(buf, "wpa_ie=");
-			for (i = 0; i < wpa_len; i++) {
-				n += snprintf(buf + n, MAX_WPA_IE_LEN - n,
-							"%02x", wpa_ie[i]);
-				if (n >= MAX_WPA_IE_LEN)
-					break;
-			}
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVCUSTOM;
-			iwe.u.data.length = (u16)strlen(buf);
-			start = iwe_stream_add_point(info, start, stop,
-				&iwe, buf);
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVGENIE;
-			iwe.u.data.length = (u16)wpa_len;
-			start = iwe_stream_add_point(info, start, stop,
-				&iwe, wpa_ie);
-		}
-		if (rsn_len > 0) {
-			memset(buf, 0, MAX_WPA_IE_LEN);
-			n = sprintf(buf, "rsn_ie=");
-			for (i = 0; i < rsn_len; i++) {
-				n += snprintf(buf + n, MAX_WPA_IE_LEN - n,
-							"%02x", rsn_ie[i]);
-				if (n >= MAX_WPA_IE_LEN)
-					break;
-			}
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVCUSTOM;
-			iwe.u.data.length = strlen(buf);
-			start = iwe_stream_add_point(info, start, stop,
-				&iwe, buf);
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVGENIE;
-			iwe.u.data.length = rsn_len;
-			start = iwe_stream_add_point(info, start, stop, &iwe,
-				rsn_ie);
-		}
-	}
 
-	{ /* parsing WPS IE */
-		u8 wps_ie[512];
-		uint wps_ielen;
+	start = translate_scan_wpa(info, pnetwork, &iwe, start, stop);
+
+	start = translate_scan_wps(info, pnetwork, &iwe, start, stop);
 
-		if (r8712_get_wps_ie(pnetwork->network.IEs,
-		    pnetwork->network.IELength,
-		    wps_ie, &wps_ielen)) {
-			if (wps_ielen > 2) {
-				iwe.cmd = IWEVGENIE;
-				iwe.u.data.length = (u16)wps_ielen;
-				start = iwe_stream_add_point(info, start, stop,
-					&iwe, wps_ie);
-			}
-		}
-	}
 	/* Add quality statistics */
 	iwe.cmd = IWEVQUAL;
 	rssi = r8712_signal_scale_mapping(pnetwork->network.Rssi);
-- 
2.20.0

