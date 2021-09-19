Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9A2410B4F
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhISLmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:42:32 -0400
Received: from mout.gmx.net ([212.227.17.21]:51267 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhISLmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 07:42:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632051657;
        bh=zcMJKXoxY0q09KFAPU9VFCC+gFn0wKfbaB0yYvTThgM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Cjv1jpUK7CYyxLJCRDKAP/AKCnkoiCFyqPknEquYPvNyQH2dkiZ95NY2nBzuj6Mfp
         dOWtTuuK5mWoAvTaPKwfMDqo1PgQ8fQIKAvQpXApHWjSPxhf2PznPxvEDFJQSAuMNW
         873diz/YoT4FDNPasWXsDgcuI4VdwQ6jUJxK8CRY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MDQeU-1mZ2jv0Qa6-00ATTn; Sun, 19 Sep 2021 13:40:57 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nl80211: prefer struct_size over open coded arithmetic
Date:   Sun, 19 Sep 2021 13:40:40 +0200
Message-Id: <20210919114040.41522-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8TLI47CD+YebazCO/52EvQKfcvJPJGRJcO7Rtr9g4W7wWhbe46O
 iUtegOwdVUxuSFfOuS4C/inGN5O91I9LZW7/83hJYbXPx+KhbFYsprZ/1TVuSCCLs7HoFdM
 ejmGhtDtYFO6s76cCv/+VcZan3g+pgtOFWwTClg0paSD5g/OAUGipdUCQYjNKYXJQSXLJap
 sV1am2MQkH2fwpXv+GNXA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oCn579lJzVg=:wiDu61UsML4WMCKlWU7zIY
 zKngrsagcFnpKhIEnot7bqff58/FoEuLqU29ei9FcdJBSqxrBgqDKUJhIaxld//bx8xhasvh7
 sKS6j/RcLPAgca5QWJTeKeq8zFw/0dSwHRYw34uWYQs/dAJiXNdaFP9LPRFR8XESkpB1DXC7X
 9iBR/mlBnJmEytTTWI579ffmFo3AGjy0H+qm0iXDdKzgAs4qKHhTiJQSRHVlY0WSjeubvK35u
 KfSPwwPC9Hl5dEmekZIB8Ic1hYu82LeoV2bMdYTzGYWablFLI+WGtUpIOJMG9ASrZkCuhC1N4
 47GkqJFX3f1ZvZG6YxInW69Bmxs/B/mVo+qTAH5IYnn4+ReR7QPIsQn+CEi9RQuTuRPtrlurv
 llIF3KToDpaPGNDtrXwakPsVefD5XYegKXqDSk43cGwUYqFigNXM6Ed8cPqaWCj5eAFmJgY20
 25FhlT+CD0S/zYYPdOU38/fFN2C6KNDYA6Im3TX50fPEdvTIf+rzdDgnmy26UDRpvaN9WAXOH
 L7lS7oajJo4CeXoU6NhPaa443J+s+/TOHtLpOZ04eobr+rCcSrWpUwrAIu9fo7xkgpI6EQLGI
 RLXSdn7axqg3K3tM1CgZ+fXDHz82/Pf0VjhOayirCLp0/8PCgSxuY9xKEhnOo0fTB6IkkNGeA
 VnevqQiRAqICSSVjvfUGp9Xz/okiv935KoWoaVHUlkRv8lh7MncApDuYbgnddJLptm6OTIBw2
 zu5S2aV51H6WT/9HuEPjJ1k0wliyDHnpMAnlqVyTb/DZh+QUZcRmm0IFO/zNZBWuVH37hYU5g
 3hJGvact71ARd/b2Xw2EaGDp2W95WmiRfSiPUFfQwIURyT26gYVP7z34JcEUesCOw9pjFDngv
 efB4Q3xDBJwcLOsk8L8BFj/Cl0mRmT4OeljfPIMAXN67aVsTu8MbAKvLlMHJm29EXAjYrOLjJ
 FKNwUATAbIOTCVKsTft05flQ9mBk7Vmkly5L1b1sevUoTH08LIR0Pg016dSeIo6KiHvE/H8Y0
 1DVcVeMyY+yaZoR4NwOB8Nw6bDVVYppPxNNW7qnSKCrVxvcIdZF9f96XbMmZR+Gb9P+8cgecs
 NSopheKd2MzbwA=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted in the "Deprecated Interfaces, Language Features, Attributes,
and Conventions" documentation [1], size calculations (especially
multiplication) should not be performed in memory allocator (or similar)
function arguments due to the risk of them overflowing. This could lead
to values wrapping around and a smaller allocation being made than the
caller was expecting. Using those allocations could lead to linear
overflows of heap memory and other misbehaviors.

So, use the struct_size() helper to do the arithmetic instead of the
argument "size + count * size" in the kzalloc() functions.

Also, take the opportunity to refactor the memcpy() call to use the
flex_array_size() helper.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-co=
ded-arithmetic-in-allocator-arguments

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 net/wireless/nl80211.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bf7cd4752547..b56856349ced 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11766,9 +11766,10 @@ static int nl80211_set_cqm_rssi(struct genl_info =
*info,
 	wdev_lock(wdev);
 	if (n_thresholds) {
 		struct cfg80211_cqm_config *cqm_config;
+		size_t size =3D struct_size(cqm_config, rssi_thresholds,
+					  n_thresholds);

-		cqm_config =3D kzalloc(sizeof(struct cfg80211_cqm_config) +
-				     n_thresholds * sizeof(s32), GFP_KERNEL);
+		cqm_config =3D kzalloc(size, GFP_KERNEL);
 		if (!cqm_config) {
 			err =3D -ENOMEM;
 			goto unlock;
@@ -11777,7 +11778,8 @@ static int nl80211_set_cqm_rssi(struct genl_info *=
info,
 		cqm_config->rssi_hyst =3D hysteresis;
 		cqm_config->n_rssi_thresholds =3D n_thresholds;
 		memcpy(cqm_config->rssi_thresholds, thresholds,
-		       n_thresholds * sizeof(s32));
+		       flex_array_size(cqm_config, rssi_thresholds,
+				       n_thresholds));

 		wdev->cqm_config =3D cqm_config;
 	}
@@ -15081,9 +15083,7 @@ static int nl80211_set_sar_specs(struct sk_buff *s=
kb, struct genl_info *info)
 	if (specs > rdev->wiphy.sar_capa->num_freq_ranges)
 		return -EINVAL;

-	sar_spec =3D kzalloc(sizeof(*sar_spec) +
-			   specs * sizeof(struct cfg80211_sar_sub_specs),
-			   GFP_KERNEL);
+	sar_spec =3D kzalloc(struct_size(sar_spec, sub_specs, specs), GFP_KERNEL=
);
 	if (!sar_spec)
 		return -ENOMEM;

=2D-
2.25.1

