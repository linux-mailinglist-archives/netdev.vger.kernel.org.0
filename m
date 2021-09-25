Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4B0418279
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 15:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245696AbhIYN5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 09:57:36 -0400
Received: from mout.gmx.net ([212.227.17.21]:34479 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245152AbhIYN5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 09:57:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632578152;
        bh=wsLjtxkpsN+vcmLOIIZnPLOCURQLRZMPI5INf/awxEU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=a0KSAWGbVgyDrvHU+aw7oricmm3bq/fKVC+FwtLNOfRlUcOLr3LOhojB5LeJWV78m
         kfXv6/95MSE1czsBtO/zLtSVolX7HyAF7wd7K6gJFSRaMQ3i2cznJCVEU5zhKxgIhD
         iSnmEzrdrmk4YHdDZX53UJLAgI6TPEcp6q67Zxks=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MJE6F-1m9Z8F1XJr-00KkWl; Sat, 25 Sep 2021 15:55:52 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] nl80211: prefer struct_size over open coded arithmetic
Date:   Sat, 25 Sep 2021 15:55:32 +0200
Message-Id: <20210925135533.20522-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DohsjkVrV1ahNMCZZNV9sE/acN7UW1Gkox/fR7Br9RXawj+VriF
 6YRaaTzbV5pavlIxBxPQNcX0Zpr753PRYHT5BbDUD0BzMRp9A9yoyF+ZclvG3BSAF+8Tkt7
 vgtkQBhPrlY+1SCFM1Fy1IZ0oHzA11jrwGHJbbRT3B1WteQOnlJ57Vrcg8k6ba94iWgrZgz
 73PzqeKdu2NFEAbwstfNw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:A1//LMqVrBI=:gvszn0LTXAZzyTbkRvC9h3
 y7ELRkA+DvbQxZweQIxHIq9T3y80fbAryfri4HXD5MIfyncO826GemAXuW64tproo5O9yOFte
 cEqhZWbYjz8M7XFfFnETm6kWHjex3ls4WqkDgwauAjl98wqwA6IdnLzYkqMEGU9hc+0RwbaWC
 0cydLpr4cRdBDzvfOJerpE5/7oMJDR5ZQCiiUCB6HaaQ7+H2jJNMlPKd/PRCscnoWqvqOJFM/
 kOkSw/YRVI7QK2R5teuZpzjIekdqWYXMQz8E6RkehWZ7ODZyB/H9gqNfQeNTlBr03/Voo29aE
 jnLG3Qxdr75wL2RLzzlfi1WoFXzPoE1VIHSCJ7SnvxbcyGrsky07hY7W2TubOzY+E9ELHBk6M
 7W/bL4eycX/bNzKPrvFfKSMeGIK8iSxKN22CtQ7dOa5rJb16eec+mzCZmIcbq4+dUGh17RAML
 KnWFzBMqJDz3+Gd2rFojwSPluD1tZ5WJ14KquuBMDRvmOPKBOQGV3pgaOOOvV4zF3msn7P8YE
 girAtbtVbtxG4sguh+EaDb0LG9k/Df+QSjVtATA7T22UX3mkLGm7N8s64i2G2njbsw+Wbo/hT
 EJEfby6/6YWvc22SLF71iKCndSH5qiedtG1PrHEN33Ztqso121wPCemdyIC5+OMZFY6r23KDc
 nrIZxgg+OY3YRmJUBnTnosI1CFbKvYTuEqbh9qUXFb9wwO1GMzlhKLQajhRiEg3kwEaP9/+HS
 Y+h/kTwXJBHnSmpL5dUmkdZl2xtz0VdB2w5nNnz1t0X6eH3XI3BZgCcQKycwsiYiEzuSW2Ezu
 TAQ/+BX7f1HNdzRmw9qEydtJ1x9GdpSLwo+kQqc6VThVdE7DQrn/7rc4ktJXly688uGJbJT9o
 689l29WT0nhN6GjRk8YUhzPC0amanDY8onq/8PKf4tHyRCrolLoDzVEEJ6sLltYLt6E8/agTL
 y98TCP7kyO4eKi6jYwaQVcsE2/VKDjkrMOlQlEORQQ/8VQKRWYRaBHUG3cbQ9yYG8RSo68+I6
 dTEDrcVV6oefWGtyiWEdmk1DJVqrksrLFpC3v/t3Ij0M0GheKCmQlcSiSJZmNHXCOoq7xSYDK
 sT2xTWIJSUpmKA=
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

This code was detected with the help of Coccinelle and audited and fixed
manually.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-co=
ded-arithmetic-in-allocator-arguments

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
Changelog v1 -> v2
- Rebase against v5.15-rc2
- Remove the unnecessary "size" variable (Gustavo A. R. Silva).
- Update the commit changelog to inform that this code was detected
  using a Coccinelle script (Gustavo A. R. Silva).

 net/wireless/nl80211.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bf7cd4752547..fa7ff61c5b07 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11767,8 +11767,8 @@ static int nl80211_set_cqm_rssi(struct genl_info *=
info,
 	if (n_thresholds) {
 		struct cfg80211_cqm_config *cqm_config;

-		cqm_config =3D kzalloc(sizeof(struct cfg80211_cqm_config) +
-				     n_thresholds * sizeof(s32), GFP_KERNEL);
+		cqm_config =3D kzalloc(struct_size(cqm_config, rssi_thresholds,
+						 n_thresholds), GFP_KERNEL);
 		if (!cqm_config) {
 			err =3D -ENOMEM;
 			goto unlock;
@@ -11777,7 +11777,8 @@ static int nl80211_set_cqm_rssi(struct genl_info *=
info,
 		cqm_config->rssi_hyst =3D hysteresis;
 		cqm_config->n_rssi_thresholds =3D n_thresholds;
 		memcpy(cqm_config->rssi_thresholds, thresholds,
-		       n_thresholds * sizeof(s32));
+		       flex_array_size(cqm_config, rssi_thresholds,
+				       n_thresholds));

 		wdev->cqm_config =3D cqm_config;
 	}
@@ -15081,9 +15082,7 @@ static int nl80211_set_sar_specs(struct sk_buff *s=
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

