Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5D83BAD8C
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 17:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhGDPCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 11:02:50 -0400
Received: from mout.gmx.net ([212.227.15.18]:55911 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhGDPCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Jul 2021 11:02:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1625410787;
        bh=RNSQYYFuIriR47EualGe3dVp1QibTFyz3MT30NUh6sY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=WaA3l5izUOfpKq09VsyYtEPvfGNAxKPfn1QJewZviQ9xE3fVfsoEKszGO49PupjfP
         DGsmYQOrD6qQxpZdSF9J/JtpSldUQrFH47JKXpFQFcattEnEi1bysQjyys/0Piq/Yb
         xhlm7nJo3srfAfG0zQ5izlUJslGvYcMoa8K4DioE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([83.52.228.41]) by mail.gmx.net
 (mrgmx005 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1M3lY1-1m0KqP3TZj-000rM9; Sun, 04 Jul 2021 16:59:47 +0200
From:   John Wood <john.wood@gmx.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>
Cc:     John Wood <john.wood@gmx.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] mt76/mt7915: Fix unsigned compared against zero
Date:   Sun,  4 Jul 2021 16:59:20 +0200
Message-Id: <20210704145920.24899-1-john.wood@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:n/VraqA2jUH1gvdW771kpSf31uZTCCCagc9quqqb0EcgjiFgR5E
 u02NcADrvAdAoJ7O8MzGR/tdK562pg3DCMXw2jvJ6HT4oH+WmA0ehebmASfgVEB5nmvgWNR
 1NjJGg1/vL2VQIaMMtHs/kXsIJYJk5QqRz3v7lwV7gjmmudpmhjzhnah2VMDpP09x5kvQs7
 DVgkaDUr7f3r6wemEOY6w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oC2EW4JkHSE=:C895kBVBwg/Pcc8pMrv+Vk
 uPfCGXmCkV9eRvAMFe6mTYc/cfYoozl33Sm53y9veWv+5NkvGFYWfH5mHa94R66A/mu8nLCs/
 vhTca6Ihd3nbDwNiGqzw6XGWniL64q1OHF1yJdDWvCEROTbOuFVXXjBlCgPTqE/+OrsqaBYAY
 TxN+n30EWO8K0J72k5VfaneU0m939BctjsPeqauDJ0FD0V4eDQLSWcE6vN1NyKGQ5Nh91q3Dy
 Jy2wSi9YyQBuBjxco1XoAjwta1R+UzoHw6Qed4r3GWMWeygx8PTJo1umFa8tDhr/EH+6DH8y3
 qFbBBmXFy2Uz7oKMPS8qs/CF/sPgNPX/TRY9MOQz6M+M47SVnb0f7F3rn/MpUY6buLToDLIze
 UwKrWNZAhF+N1JsfziJr9LIEgdcjYHNbB7k22ZSa8xWRhFgL/WPQJY94AXyl7lHzufetyZz8V
 md4kbrt2u12Hh4x1KCCw4NBUiOMhIdnmHKlbSYE7CxjIF2YozcST19EjXSVqg9xZBdW8ZxSh9
 CN4SZSSiasvrMAkXkiSOPXjC0PXEQdzvacnHNiXvA0QynC+r+Y3WtjWfbDsWU5Q9mmnuKWhO2
 +fZGzLSJJMcnwTnPkCAKycyC2b+XqzEmwkRv8HTiaQWgMdsRcJV0yA64MyNdV/NVX4eFnG/a3
 JdUPzSb/w5rFhh6PCU2ApWRgciIdSpdp1LhLqmIQNMncgOWOjCL8Z2TnB+VF0fDK/Cqzw5Rlh
 JUB1XrFsFSDLr07/awBpyPzkmlmlB3BGifPxRzNTUmqK7FKqjvwV3TLLVevG+hAD5gQ+map8N
 HwHxcha1Mnx222JXzspCAPG3Ce9kKxffpUzT/K788EU/B66ePFovV9uyER0KIV8WxnUuJNFlQ
 eLWaneAQRS4mK5ByGyhBIywhiB71uGEDhPlnkvzTOzird2XRGvao3ubpfr6Oc5bJhAB/raWnH
 pg4ije8C7onQ/9Pggih+Wdo2GZrWdcSQdpBMolblCHwsdyIEGl2k2F88bQJXTSSpxmQVdhvnk
 4Qh2yjUR9N4igHuFqJQ4snz1jWLDFrE2tBaCYOxvtNBvA4s7iF0KqFRCJk27oM69c3K3wEI16
 uYHRzlZXuHk7uhC8oxgDO+pFHE8dOOacElD
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mt7915_dpd_freq_idx() function can return a negative value but this
value is assigned to an unsigned variable named idx. Then, the code
tests if this variable is less than zero. This can never happen with an
unsigned type.

So, change the idx type to a signed one.

Addresses-Coverity-ID: 1484753 ("Unsigned compared against 0")
Fixes: 495184ac91bb8 ("mt76: mt7915: add support for applying pre-calibrat=
ion data")
Signed-off-by: John Wood <john.wood@gmx.com>
=2D--
Changelog v1 -> v2
- Add Cc to stable@vger.kernel.org

 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net=
/wireless/mediatek/mt76/mt7915/mcu.c
index b3f14ff67c5a..764f25a828fa 100644
=2D-- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3440,8 +3440,9 @@ int mt7915_mcu_apply_tx_dpd(struct mt7915_phy *phy)
 {
 	struct mt7915_dev *dev =3D phy->dev;
 	struct cfg80211_chan_def *chandef =3D &phy->mt76->chandef;
-	u16 total =3D 2, idx, center_freq =3D chandef->center_freq1;
+	u16 total =3D 2, center_freq =3D chandef->center_freq1;
 	u8 *cal =3D dev->cal, *eep =3D dev->mt76.eeprom.data;
+	int idx;

 	if (!(eep[MT_EE_DO_PRE_CAL] & MT_EE_WIFI_CAL_DPD))
 		return 0;
=2D-
2.25.1

