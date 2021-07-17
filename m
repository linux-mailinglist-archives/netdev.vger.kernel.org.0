Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86C93CC3CF
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 16:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbhGQO2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 10:28:49 -0400
Received: from mout.gmx.net ([212.227.17.21]:40919 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230003AbhGQO2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Jul 2021 10:28:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626531940;
        bh=n3EhBd6g6EullEPmuncXfs0nUfb+J8NOZnJm03h6DA4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=IL9xYQVNCUe9jYAbAHFQnSPhPwmVpc2iSXVjdLYU6pG0ACuBJ5CvaKdcxrRHczBq5
         wUqwaR1QB8vsWc9gUMnl1hGpWaSWQRiLCEGzRlW6cFML7hLkrwRQnF625B4rVDPchH
         VWAbrW2E0omyrnFeKa7iST/cM3SVBz0WHkAvBEXE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([83.52.228.41]) by mail.gmx.net
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MMobU-1loCJT3T3k-00IiO2; Sat, 17 Jul 2021 16:25:40 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipw2x00: Use struct_size helper instead of open-coded arithmetic
Date:   Sat, 17 Jul 2021 16:25:13 +0200
Message-Id: <20210717142513.5411-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Ru/Pibk/lZndp5qrfhU1MnR6aLkIINCcZkhHRZitNjMn3JVB3Zn
 MNglWYlfL+XxKAgv6J2amocnYjf3Td4IC6IFQmTbJJE7uQbJAtfntDEvvwxXtSM0lGss0sF
 W9HsfilzI94b+UTrxkYcouXNe4pBc0lvf3JuucAZjce0USIwF9uggM53owS+4uBuqT4peuL
 XUUT/5KMLC/+k4GXfwWIg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NKvonOFWUrQ=:6Uj8kRxZ5duVe8O3va/7So
 oixGSj9MtlLoMrAa0mE3UR00n/vGqKs3d586ssbL5mbXH+m9kxvlRlOJSUOXWhENXsiNPqDdU
 SUD0mWWWhL59XaSQgFEbIr2hLERXsCbWQYPCk3vKotWMbghl0SoU18KuKdwVFlzxTxkk3Iqni
 S0J49Rf+Qp2C+40paMJdJaZbuBo2Fw+fT0kOyRlsERdJ58mmraPItoWZINtKrFXXfaiVFzmSn
 ereocu/IOdMcTJBnk0OfBY7ZdiBNk5P8Dif05hnLXz3VZH+83e3sm24MywScFvzS/OgOI3HJQ
 jysTf81xP9LKafwPg9gzDZs+awBiqFRXwGq/Mynhs5GI4cAR0G9FiRgL0hGdMNg1wKFFtqni+
 XfX77PXNI8GeIcMq1LAPOpRS/HbGfSkBtJtnBHQGmMkvQGilbkUok63ftQUrrAe6hU0fyeE8r
 kxTSpVDuKdA4/yIQW2lUgiOBGrFcnvgomgAw5NJMojLZebWSTnSzZ2eKPJ2ioLNZxWSXxr+Ru
 BNGLGfyjxArTkzuHOvKHd4CpoGiBy83KB+0KlcnZxk7Bzc1UDV6dZHBolVoBazOIwA/OHg+hZ
 K070WjtHXyUaDLjY4AkrH2nF8Ko0TNkg2yUFflYtB72gOzYNi7Wsl8WK5OxUcmZduQuVlR9Dk
 TCOAt06HN8Ca82d3r8UO7zyjFQnGh3rufERRhr/HmESYdAWLBHYAhpUKOMff24CZYwZuto/Rk
 YAEd8gcIHaFUwm/QkdYqFxT+En84aR0RRsP/4ebwdkY6dzBlRnC0WN0lRWc55auhAe2Rgh93f
 rS7DDWikUesxaNPdF/KS3gslyvvw7rX7U2h5Lj4CS+PoqCSnCgx1vP7aYmvRsW2k74Rygp34W
 x0YVUys7HvQ0RiKWvvLKvOYQibU0m87meNt0Zqk5m0GpDimhAccTiC9hXXRGYobgJ2XSk7ttq
 q82I4e1gB9hTnf8lbgIhm6wH00Do1KX7VyBXN7UK1e4l4nmdjbgP0GDsrVcxcKkSyja5k5U5d
 KElOuVr7Eh9ceOth1cs2c0wfc2KDQSZCNM7Bfm/XaPHvbfcCVxuxLZiKt8d2juU8kRU8hXtZe
 KtrgaTGF4vjw74owaHIFI+yCKriUgrOvq61
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dynamic size calculations (especially multiplication) should not be
performed in memory allocator function arguments due to the risk of them
overflowing. This could lead to values wrapping around and a smaller
allocation being made than the caller was expecting. Using those
allocations could lead to linear overflows of heap memory and other
misbehaviors.

To avoid this scenario, use the struct_size helper.

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c b/drivers/net/=
wireless/intel/ipw2x00/libipw_tx.c
index d9baa2fa603b..36d1e6b2568d 100644
=2D-- a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
@@ -179,8 +179,8 @@ static struct libipw_txb *libipw_alloc_txb(int nr_frag=
s, int txb_size,
 {
 	struct libipw_txb *txb;
 	int i;
-	txb =3D kmalloc(sizeof(struct libipw_txb) + (sizeof(u8 *) * nr_frags),
-		      gfp_mask);
+
+	txb =3D kmalloc(struct_size(txb, fragments, nr_frags), gfp_mask);
 	if (!txb)
 		return NULL;

=2D-
2.25.1

