Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDAEDC15B1
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 16:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbfI2OIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 10:08:21 -0400
Received: from mout.gmx.net ([212.227.17.22]:37371 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfI2OIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Sep 2019 10:08:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1569766085;
        bh=W0sfinC4h6Atx/RxDA6fFQGxhL5Z6DccjwtuY5qYb8s=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=CHYWpxI+UtDlx9OCRS0PZapeBhaYmTjtDM7uPn7qihcaCHHk1crvoQn8iNN0N6dud
         jiIdS3lOMDuzv0oanHsm2FEHL3PiR4afy+Ip/6RevUnNb2wtkkYuSHHlMnUtQJsobA
         3S8EAjzQQ6LaT/ZXhBvbMwRb12zfGv+OQpehsO7s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.130]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1Mqb1c-1hjaeC423E-00mbEX; Sun, 29 Sep 2019 16:08:05 +0200
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Dmitry Osipenko <digetx@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH RFC] nl80211: Fix init of cfg80211 channel definition
Date:   Sun, 29 Sep 2019 16:07:35 +0200
Message-Id: <1569766055-9392-1-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:KVkXE8PDvmCamWy6a8ic/jRJx0kFv18miP/9HkbmN3t8j9XkMJ0
 4yuogEuEtNRJU9Vrjqr+6gspixnG7ZewrETwsvQ1HQxk0r6YXROvbx9/V3fEPCjYEhcpeq0
 M/jn7o+6a92dEnSqSnaCApqS9dryqOpY+JHnWIp1IyTskoeQz3zaA3EMA2AzncL5CDBU5QS
 RXA8pxF7K43DvFC2ow3aA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:WmNVB4jci0c=:QyX1bC4K/g/jlbhqSaC9Aq
 1kmp4h0fqyrhJ2KDTGMUhWX/59rqKpSh0CDc2BMGGDPGuaJ/rpTuAnHwKdA/itniCtuIQzb4F
 DZCcWgOWhQxI/WK2KWMGVWpu2h+lgMowpDdZfpTINfiFN5USPEzM5M86clqvko5+95TiKZxn0
 n/nQPV8JielkvL3u7AQyDcusH8seyhyZvhf5R2/kIOukZP1P925coxPpxXS7e3mvxxOVYfqg8
 5r9FkMV46pwcY0JPWcDPiBoUK3OnBf91JBWLHZjp3MO1HLuGieMg+Y3rqgFR6LPfV5RL+rKH3
 sNOJaI8EVxGJTFQr7uVKFGDhvVmRPkjgn9cknl+4PZtvc/Dgj9TrbHYZySh0Q8bhsq8xRSjdp
 M5O+lCVuHn4+F1iE4Yuaw0JUsnhvqhIap4a4KMNrJDPXNd1kywr83Wcg6VwodvO3x6prJA8et
 yt6lLe6nsKTF3/tuHgECQxSORz/lh2Ab5BMFsEDie61OtVEuHBjbOS245K3GEx4kF5cISftnn
 lCArOxFItcup/AKE3rsGsHnHHwAGX2X8DdefzKvOIzXkyk6tjwK5nubuHhIXJYMCI8qS7yZpZ
 cWP6Up2m13Z4mA9zypyoPCaE9K+vQ9kUft9BKdaJ6nnvzbkJ0/5TAcHulNyGNYyGuK8hBvxu7
 dmCBPc6MCh2mF00cl7uPtcj1fIdQoUQVNpxUFZr0wMORV7B24j3YHl/9IrYDbmuamFQp1ZwDd
 9LAqnMtYOBLcYXJhBmVGJ4KOiwxPUTw28eYFpWp+UVEx7ipQ9Hh3zRBByA0D4P6I3aDKMZcZC
 nDqCELSButlceatRpSS6URX9irH/QHhxsoU3S42Q4C3WVism/7KGlMsvm00iScYM2rIjEeE6w
 qOMaJdOIO9x2Z00zP6nfwTWxuKNWjyRElmrHPjRTrCieURyd1NXNW/RU7gafy1cjhRYoCbPjn
 rYAbnu1FPRISFKsqBzW5xUrohNlr4njLguxWqS2ldz7kdZ8VRaeaxUKQC6hCcQvQy/Z7tjD1v
 xsB1bwtYFoJNuxzTwt8UobNomXj8vnUhkfr3Jpbp57oIitoVlzS+i1gK869cuWDJ8T3XZ4qYx
 3TtbXp4d+ab5Kp/Uy520PyVRc/yhNpxF/sTDR2sUFtp13QR1boNnJBU8j7GhRn8mXXvIsy+IS
 H962/x6mroK52gwm57KtLXsOwheOVqmaC5RDhOeb1+i2myYgdnm0/Zc9NjN/kIkAwvcH1fvmT
 Rim68FFMp6IU/xrsn3B54hoKvED1L0IxZeTyw8g==
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

