Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63360C15B5
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 16:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfI2ONt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 10:13:49 -0400
Received: from mout.gmx.net ([212.227.15.18]:58237 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfI2ONt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Sep 2019 10:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1569766407;
        bh=yEinVkrAXAA8zQDhZFR9oqEyIJv63B/asAyfFNVqSM4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=RRG3VDdMKFbrKf/asVjppSdST3OMVT0er6CYNahZdgkbg9SBKmCG8fMjeJIBmxFar
         kiOfjgVRaTAIUsPwuo5NyBAI4d50UlXJaleKXIss6WmKmm7NNo2nlXZYfGpJqX3tYT
         Qs1B/LL3odoO/RywBNaakPU3od+Vz21PRlb8aMZE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.130]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MxDkw-1hugcp2Khk-00xXQe; Sun, 29 Sep 2019 16:13:27 +0200
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Dmitry Osipenko <digetx@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH RFC V2] nl80211: Fix init of cfg80211 channel definition
Date:   Sun, 29 Sep 2019 16:12:59 +0200
Message-Id: <1569766379-9516-1-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:VbwrAyG5najNxf/+021dm/Rj8RcIWUM6M25RtSPhDVFJD5+dhjl
 ZyrkNsajURwYh/nGeIeoybai2Yc859S+5BSH0OpWxp0sUfQDmRICBXv34FsIwnj4ZcbJ15m
 Ql91Yski7W0bUWxefiexBmswUVfhtp1xiuP13ftHZJQSsvVlOYa08ejqblmgFkmRcIqoy0H
 9tSLs3PgcndFSvbt8IUkg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sqSrEt0BRbI=:KELXrJoVqL4wpDbb1rpmtP
 g9SOdSGC39BpbJZiYuxIIqrUhN1G9ijQ9KqAc7bTrhJaFnccPU0e3by/HhK0GGmYKiO/x1w+w
 VgVVyzlrWT3w+q6veBMJ9rU2CB+5LkOqztsRoa0J8A6YZLLZrJAsfadWjwet7O/W+LXgLW6of
 UwY1q/iYYetSdCKnCftRYZ3Tw38Hs1BpJmsha2PaqFXt8ctKMyTjQKQ4Zd/D+TQSZneVmI/xP
 9hK6XgcCE1neiMgE8voFMfpPEFiRxGfjF86FnJ9NEVs1TDEdCO4RE8bsuKFV+vgaaqDEG3G3Z
 xqpVB/ze0qZHfdNvSbgYLEMR2iHILMdPYHVYG3iqs/ZiVPlcRGs3vRC+O+D9yuy3bBlNOsIMT
 4lvVPZcWUJxKnodiAQ6SQh4622jNGCPTLwXDUwGk+CYKgGc5jQEnmIYig0BGHQnDCV7hpGh1b
 MbY3PAzzYcMwlRN8E/SBgo8ViZbKml9uVYOJ1g2jUFXm7e/t8XYFjBfwvkSpFvV9nyFZ6yxPV
 7dCqP+/G8hGY1Fes+aYMK/J2zxJfzaM5aJWZpd1YQFA/srCZhwCmY+NoJjFbCkkvrfk/nFYdf
 WwIX4/wqQL4qmD3a9OzFUkd2EUxmjQQeNFTJCZsTBjBTdLQs3AYKQByAB3LnfLCdzL6GbUfAl
 +Y+TD8U6NBxH+IAc1dAaWpTzLHXb1dy1Wd3zOL+c/y8ebbCRUmijadVRvhMyn4hTOURG7SuOX
 G0RCbG8KKMl7e8d/eX20Br2bu3/xnlg/D8mJaKdbdNamK0qR+DveMyhXLAVh40ROwDu5IrGBT
 f5o8f81xGrc2KIFDTiqlztnZBQTRsVOnVooqpCgmzoDkLJ4F6iBpGaRbBku4B/eZDc8GizWQE
 /kx/f505Cf+RumtNgR2Lq8v91k7c9G+hQczEo7UP7na66xDxmSX9lEGFGgFCR19TzspFNeoO4
 kMwxJiS+BQUuzhp5eMh6RCIfbYFlUZvOPe6E+nbNp+l9U6FdsB/A3puvL610/G0Nm3ov/TLCp
 G1r6k8SN//9B+2ImRdTiaxKoFfiOOOZC7VfAoqSD1023Bfkr+kPE7hwCR64Z2IcrSFXt6Wjrj
 8hNxsbCrw0VYSAqbQes3r2UASPPE6gIXKxBJprvZFHpBm19klaV8FlS58vrrws975LRTlgwYF
 +YW+eLPErIpR6YDhhN4XD4l3MvvTkQM3dZbamNg6wodEsRktg4vjLulC9ECRyNi5Rvt6Kq15X
 jaca6XPJJy93UAou/v0+dt7ZtXOquZiGD9mSc1Sp23n5XgkmiaI4oW1bKF1WKxiQpdN065i0s
 p/aad+pTWp0dEsr+HZrNPOVJVKVoJeuFWr2+F12QYnqoBI2B/1+KjH5WtmUqKyNEtnDgO+kKg
 33gkvxlvFF1JcePxynZXG81KH+z3HsUdO5tTdSA3gvzsh4bZB0nj7Z7DkKteW48GfmnTt2GTG
 +/83uuwjWleQ8nj3U5LE7grQ2scpzQy9t8ieO20n3iyxwwmdupeMlIrZVjA0atAMuOOH0aWMG
 6Ug==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 2a38075cd0be ("nl80211: Add support for EDMG channels")
introduced a member to the cfg80211 channel definition. Unfortunately
the channel definitions are allocated on the stack and are not always
initialized via memset. Now this results in a broken probe of brcmfmac
driver, because cfg80211_chandef_valid() accesses uninitialized memory
and fail. Fix this by init the remaining occurences with memset.

Reported-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Fixes: 2a38075cd0be ("nl80211: Add support for EDMG channels")
=2D--
 net/mac80211/util.c    | 1 +
 net/wireless/nl80211.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 051a02d..d887753 100644
=2D-- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1885,6 +1885,7 @@ struct sk_buff *ieee80211_build_probe_req(struct iee=
e80211_sub_if_data *sdata,
 	 * in order to maximize the chance that we get a response.  Some
 	 * badly-behaved APs don't respond when this parameter is included.
 	 */
+	memset(&chandef, 0, sizeof(struct cfg80211_chan_def));
 	chandef.width =3D sdata->vif.bss_conf.chandef.width;
 	if (flags & IEEE80211_PROBE_FLAG_DIRECTED)
 		chandef.chan =3D NULL;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d21b158..9a107be 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2636,10 +2636,10 @@ int nl80211_parse_chandef(struct cfg80211_register=
ed_device *rdev,

 	control_freq =3D nla_get_u32(attrs[NL80211_ATTR_WIPHY_FREQ]);

+	memset(chandef, 0, sizeof(struct cfg80211_chan_def));
 	chandef->chan =3D ieee80211_get_channel(&rdev->wiphy, control_freq);
 	chandef->width =3D NL80211_CHAN_WIDTH_20_NOHT;
 	chandef->center_freq1 =3D control_freq;
-	chandef->center_freq2 =3D 0;

 	/* Primary channel not allowed */
 	if (!chandef->chan || chandef->chan->flags & IEEE80211_CHAN_DISABLED) {
@@ -3178,6 +3178,7 @@ static int nl80211_send_iface(struct sk_buff *msg, u=
32 portid, u32 seq, int flag
 		int ret;
 		struct cfg80211_chan_def chandef;

+		memset(&chandef, 0, sizeof(struct cfg80211_chan_def));
 		ret =3D rdev_get_channel(rdev, wdev, &chandef);
 		if (ret =3D=3D 0) {
 			if (nl80211_send_chandef(msg, &chandef))
=2D-
2.7.4

