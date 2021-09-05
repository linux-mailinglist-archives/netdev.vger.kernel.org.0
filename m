Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59696400E78
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 08:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbhIEGwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 02:52:08 -0400
Received: from mout.gmx.net ([212.227.15.15]:59355 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhIEGwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 02:52:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1630824651;
        bh=6y4lA42xc7tbqPJz5XFWFgyW1+53pCMMuYhyZwSm6Ro=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=NwV3+hdVBu6FFKg/gaTjSLrOPfLGDyyRXwKwz7rMO8LzfxKN6wwC8gU1vvrd0QrY+
         JU5pi9afRmoVHXSABFDYCOwT4868KsuhCH05H1YwbIBaFXfzfGjGANRMKjrwUDoR1V
         OT2ohUu0IoSylgB5xfxsLoxps6BBv5fWuhDY4xsw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx005 [212.227.17.184]) with ESMTPSA (Nemesis) id
 1N2mFi-1n5tpf1DNk-0136Ew; Sun, 05 Sep 2021 08:50:51 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>, Kees Cook <keescook@chromium.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ice: Prefer kcalloc over open coded arithmetic
Date:   Sun,  5 Sep 2021 08:50:20 +0200
Message-Id: <20210905065020.8402-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+8UMAYn+RM81PwzAkSSA8SCmKnqFtkt58lXmqMqyJoXaChR1nGw
 3Q2wbyks2rcsgf0CJuEOCx5SIeql4noaCvDaVlGM8v+7uIEm/Z08j5d88OykfcD5eCJX03I
 wybeEl4uqzweayVCmpmKZOrkhm//QBmpTWMFX3NaiWTKBE5/6Up5aXsm0hlC1vAaChB2B/P
 me/ix+WjvAW/M0bkZa1Tw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:YsDFeOrnaks=:cWqMkulV7aAz3pbocBPWEO
 ESlov06l7+ocXmDR2HU3lAv7ke9LKojHaQ7+s9oYKa7xLjJthx3i41tOuF+CMm5x3G8K6PcuS
 /MirnAO9PjdOi3zAVdO05Vzwe7EOYAh9nQoPKOVQbpYnjobHsYtG/5Mam2cltYtjbfLcS9Vbg
 xyYfpFFmV8qGa+y8b4lIbyov6ZqzbzL/5U6xJ+udOoSdt0xtWIbSTEfR6Em/9gsHQMQ1rZy4T
 oCoy5HTxHwSyHF3NMo7KF3ps6vBqkvM5ebQ8lRIUTpN3IzTKkBFFy94HcYq7WxytHWpp/C5kc
 tOv2MYL2zB4yXkY0k0FSe2wduXeJHf2/C0uf0oBY/apeRLKJYAFS72T/2959Qqvx5MtEvaAOI
 cE2lgEtYxHu6hXbES9fvOs3vsAh1cWJnCPcCA1OvPx39rbUJNj7xw/H09nEDYoDyK1AABf+hR
 F5ekU5CKKsFTQPcIT4kSoi8GJCwLjQLGKmvGhew8gnz6/qJVWdZ4F+F1ja4lQjILjgqkNr22/
 Xyggj2ktllCejurrth17c4jvR4yvOD8hijgrIE3QL1OOlSNeATokEck10oNb6wyrUXq+JZxC4
 mH3EYANuokHeM4TNcg0M2v56TPehvyQr18DLkZJmERGFzABeaHWrLlvcuMcrydS0cMhPaCdPa
 PhgLRYpkb+sC0bnYRlQ1/O6/Y58CdEIPAcisA6yAEWBzVJKaCrUU4+UtWhX8bN0s5Dt1oiE4S
 O+VlUEYDhFJpAAhS3SNnVbdslNuY6uyqjO3scf3l6q2n/ybkFJ1gAaKrIx2bXZ42Og/kH8fWC
 HanbF+rCOpiYUwKnkWtpiVRT8NoM8ACMkVdvcedOSpKCH9n7z6je9tCeu2goT7pB6FkZpSx5G
 Pfpz/RKzOOwvkk5f4S/cgZsYxD8CDJiuwYNj03DiQyZxVAU+0K0akDuQwGVgeoAaVS1oTyDHW
 bSoWUtDzcXlq7lcLC5JokjqJCwUH/MpbmDx8Cv/XJQWd8jHRN5wKPQcTnUwWRX4kkwzQtbh6L
 zPxB2yjkz9cSkeLJyCdcYYvMfN71emAz0QDIbNPo36x7iykLEkJGJTA8YD9hzMmuPKxtRN91Z
 CiwTZbqMU0PZGaEf1bTIkTKfovUOOcKkFA/RhZ7CvBe6cTvZfocst8hDw==
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

In this case this is not actually dynamic sizes: both sides of the
multiplication are constant values. However it is best to refactor this
anyway, just to keep the open-coded math idiom out of code.

So, use the purpose specific kcalloc() function instead of the argument
size * count in the kzalloc() function.

[1] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#open-cod=
ed-arithmetic-in-allocator-arguments

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 drivers/net/ethernet/intel/ice/ice_arfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ether=
net/intel/ice/ice_arfs.c
index 88d98c9e5f91..3071b8e79499 100644
=2D-- a/drivers/net/ethernet/intel/ice/ice_arfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
@@ -513,7 +513,7 @@ void ice_init_arfs(struct ice_vsi *vsi)
 	if (!vsi || vsi->type !=3D ICE_VSI_PF)
 		return;

-	arfs_fltr_list =3D kzalloc(sizeof(*arfs_fltr_list) * ICE_MAX_ARFS_LIST,
+	arfs_fltr_list =3D kcalloc(ICE_MAX_ARFS_LIST, sizeof(*arfs_fltr_list),
 				 GFP_KERNEL);
 	if (!arfs_fltr_list)
 		return;
=2D-
2.25.1

