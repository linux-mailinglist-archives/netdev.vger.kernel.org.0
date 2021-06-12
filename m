Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83AE3A4F40
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 16:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhFLOhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 10:37:54 -0400
Received: from mout.gmx.net ([212.227.15.18]:53379 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230191AbhFLOhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 10:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1623508529;
        bh=4GRBqMXu77f5LzS1AYmY/Pv3PyBwvmo8iWWSKO+eOSM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=MOUpEMFz2zwru/v/vvDy+q8zQBqjKnDBqkptW8QS+wxzQ/4z4NfOnO77JaNYUHowL
         ZJ8JmgUjJLtNAAUF0bHUqvK3lvjRpAh18C7y7Yu+A5CxXTPlTeuA7X53oKA6TKZWaX
         MyN/WQIGTLnBllo9wSB3BDcAECZ3hdySw3bx96fU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([83.52.228.41]) by mail.gmx.net
 (mrgmx004 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1MG9gE-1m6QjE3X3M-00Gct6; Sat, 12 Jun 2021 16:35:29 +0200
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
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76/mt7915: Fix unsigned compared against zero
Date:   Sat, 12 Jun 2021 16:35:05 +0200
Message-Id: <20210612143505.7637-1-john.wood@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RLOmvHMXqv6YzC6MbWRgT6VnA5VAhfOSQfIeL9vcZRQOX2acGVX
 iFXwCXoE4TnDXw5rfZ0VQBHl2rJ2xS7R4Rm6FhL3+iTmFFmT1Okpy9Uu5nwBDJ2vGH8lxoK
 Q01TmeCapD6wUdgI51jJ9t176VmNcezyrJMHUELa/8EKxo5VcJPOf4vvbu7y3dkc60p4QAK
 xzAYFKNLbqYHIs81Pc8Dg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XQhJptkxzu8=:GGdsO5+3quPg2/g0XpWZlq
 y0lAUcznNQGLmuH16OSKkJIM4Y5/1EoH2WK6+oqLGe6LgZu+8x9SKeHr0djXqltXoF6J5XxOY
 ALRycaueYFMpUZzbNG+RmXleNj8jO4mlKOjmioYPHZYFP/gxNYUGEDMFCxURxp7zBiktfG2iT
 ZvFlCmZoILCizNSKhbF/yp9oyHxgVpe4kkd9S3KOMl5ashU5DCAXWqnfXUkRDcwieCuI72R7R
 AhTugHHYhE3uIzwp2LUwAKfrabcXNMb4mJ3NuY3iAqDHJ3NK4S0EN6IJc4ezxK3LloMal67eY
 /ibmICAdETG+6pvTI2v+KjiMra/M1gFQEK8mnILXE8cVLSLb/We3HxAD+l6kPWSo6c3vqcJi6
 iJmTmfncgmAvpJuEKYMkA05p1ImF2/+BBpRBRf80H2SwAmFehKOjBuitB5K03cs+DGqRVza69
 IJrCBKj4DfiXd2UlCBf77jYdL7SsVWW4cMYvX4Hn4//c5++RowKsZ8y9btg8vGyETa+Ll9jfl
 uwUi/1PWRmoQl+/SgU5sEGugHB0ap7Ttmb+9yTvYZPBfL8N3+bjNM4Rpv4gmDK+L3RdjPLAIi
 dqtdPCXRpERtFzyJD1SQKMBaqbPzpnPS/Ag8ebeqwdQWf3Z8LeYbPaIk0Q+Zhxb4bMZWRIF+l
 OuRngIlIRrfsA1AMvDkqhdxdP4rbvonSfwhkFzvx6exXl4pgko6I0x75PY7SIizeunCxMIaBy
 GsAH0TSCWn8i3HKLBwNvp52UvZZVeUJBqREQ0ut3F+C4+dDea1o62bKlhtDxHRQsELyXKxYQG
 3pwq/ojHjW1fjCybKyu4HiQBMSsg6Dqdk5DX6bLK/b/xpD6kPW/mDwH+tI1uZMVwh9iFBUBhe
 q2CKAxApNZfzEzIRpIdAEN0FTESLfRiuj97IGsFaPF/hTbavQtdEHryZejTlNmHCkHGA3lw5+
 p/5HmwTAS74AydtlI6QbhXE02pnCKspy77tuHpb+Pg166zkwTeu7jYYK8qvXsy8Z3BcmsvDqU
 TM10UDILOhMK9Rfu+vDGNHorrpxBZIqzyToOEZ9msLnhqvYdu4GCST0Rh9tSFx6RZhfG5ap4I
 9vA83+u7aHTVXJEwAKBoW9mOAN3l/eIkbc9
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

