Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116E0453BB1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 22:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhKPVgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 16:36:53 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49988 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhKPVgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 16:36:52 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20211116213353euoutp02bacb1c03296c924e382ecc319d554afc~4JFoVaaeO2977229772euoutp02G
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 21:33:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20211116213353euoutp02bacb1c03296c924e382ecc319d554afc~4JFoVaaeO2977229772euoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637098433;
        bh=7zpv7g2U7sL+mGXLiZJgqjq88W3YDYatpwIDiDtq+Gk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=QGykfDn//llS+whNBQPF+o+roNUyIGqC2YcghotKnGZAp30MvhurbIH5ZkhAWwoOY
         Y9zfRWZhFvqCOOhay/VW1HikoM7n60iJarcfl5ilFlWM95BwE5pPl45nLt6Lu4xWJK
         yRzwszA/MUcWTeO1foCmxneKZr5+9aPUJUPPmL54=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211116213353eucas1p10d3238c2f42774ba246306c2ff73819d~4JFoHbhxv0376903769eucas1p1y;
        Tue, 16 Nov 2021 21:33:53 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id E3.61.09887.1C324916; Tue, 16
        Nov 2021 21:33:53 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20211116213352eucas1p1d5481ca560d4fe712a346fd8ce792e7a~4JFnC3kub2323923239eucas1p1G;
        Tue, 16 Nov 2021 21:33:52 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211116213352eusmtrp28142d08b3e1b8493ca98ce3893f8241e~4JFnCNow51546415464eusmtrp2X;
        Tue, 16 Nov 2021 21:33:52 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-1e-619423c1e837
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id EF.B8.09404.0C324916; Tue, 16
        Nov 2021 21:33:52 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20211116213352eusmtip1e2bae9fe4d284b42b52d2c840b088479~4JFm3qn4y0369903699eusmtip14;
        Tue, 16 Nov 2021 21:33:52 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ax88796c: use bit numbers insetad of bit masks
Date:   Tue, 16 Nov 2021 22:29:15 +0100
Message-Id: <20211116212916.820183-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42LZduznOd2DylMSDa7vkLB4/W86i8Wc8y0s
        Fhe29bFa3Dy0gtHi8q45bBZrj9xltzi2QMyB3WPLyptMHptWdbJ5fHx6i8Wjb8sqRo/Pm+QC
        WKO4bFJSczLLUov07RK4MuYtvcha0MNecfLwadYGxh+sXYycHBICJhKNt9rYuhi5OIQEVjBK
        rP5zlR3C+cIo8WjXQ2YI5zOjxMYTP9hhWqb8amaESCwHapl+hQUkISTwnFHizcVcEJtNwFGi
        f+kJsB0iAv4SK2c1MoLYzAKXGCWuHzYBsYUFXCRaz54Dq2ERUJW4s+cFG4jNK2AjcfDkBqj7
        5CXark9nhIgLSpyc+QRsF7+AlsSapussEDPlJZq3zga7VEJgD4fEr2tbGSGaXSTWLtvEBmEL
        S7w6vgXqAxmJ/zvnM3UxcgDZ9RKTJ5lB9PYwSmyb84MFosZa4s65X2wgNcwCmhLrd+lDhB0l
        Ot7OYIFo5ZO48VYQ4gQ+iUnbpjNDhHklOtqEIKpVJNb174EaKCXR+2oF1GEeEucOrWCbwKg4
        C8ljs5A8Mwth7wJG5lWM4qmlxbnpqcVGeanlesWJucWleel6yfm5mxiBaeb0v+NfdjAuf/VR
        7xAjEwfjIUYJDmYlEd6UqsmJQrwpiZVVqUX58UWlOanFhxilOViUxHlF/jQkCgmkJ5akZqem
        FqQWwWSZODilGpiS//sv7n9tfV9Mr0xg8uTo6Gti9x9yPFts97ZaNXZC1ue6yytdvdYbH4uV
        SfB6ZmXyftlB5n0n/z9y4nrIXHtrf91P1nTbHfO2zZRJ9IotXvxqbwTHZL4Lsztv17e7KxQ1
        LarIb/yk9t6t+6Plqr6th352/Am+sZd/raYH2+dXVnN3FYZwLZRg/nmrTevhLrnzPM9LD/cv
        /tqdb+G8tvx1Xv/f4Av1ldPir81surs3rppxoczS6+w7c6a/8zZuuXlAPlVx86Vjzz7+fRR/
        PMlo4w/jzC2zDV6tXXt4enX4dEu7V9+vu+/K9LkW4m26z/0l95f9KapXeyeZME79IRj+JXf6
        nCVT1M4/WPpT+5zqVSWW4oxEQy3mouJEAOhIE3iiAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e/4Xd0DylMSDW6t57N4/W86i8Wc8y0s
        Fhe29bFa3Dy0gtHi8q45bBZrj9xltzi2QMyB3WPLyptMHptWdbJ5fHx6i8Wjb8sqRo/Pm+QC
        WKP0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLLUov07RL0MuYt
        vcha0MNecfLwadYGxh+sXYycHBICJhJTfjUzdjFycQgJLGWUePnuLlMXIwdQQkpi5dx0iBph
        iT/Xutggap4ySqzqmQvWzCbgKNG/9ASYLSLgL9HbNZEFpIhZ4AqjxP7GCWAJYQEXidaz58Bs
        FgFViTt7XrCB2LwCNhIHT26AukJeou36dEaIuKDEyZlPWECOYBZQl1g/TwgkzC+gJbGm6ToL
        iM0MVN68dTbzBEaBWUg6ZiF0zEJStYCReRWjSGppcW56brGRXnFibnFpXrpecn7uJkZgnGw7
        9nPLDsaVrz7qHWJk4mA8xCjBwawkwptSNTlRiDclsbIqtSg/vqg0J7X4EKMp0AcTmaVEk/OB
        kZpXEm9oZmBqaGJmaWBqaWasJM7rWdCRKCSQnliSmp2aWpBaBNPHxMEp1cDUOCEpctYF5UiO
        Fd57ludpTxaqyfrZdPxoYKDDKZ76ffrh8t0vQm66HNzt7+qX0p9fJ+/0wqBR2oL//zOnMI9g
        +R/v5RWOnN2/5qJHwp2A29qamw1yJJ1als9ZoN35o0vgTO6dy2nOmwTX7TndO32SV8f7dfYV
        aUwrPXw2CETsqWT4IP1p5cqCBsYqcQFJkY1FoiI1S3hK0o+43Ml98UfYd1pIGu+ROvNr2T/Z
        J6c0y7y98Iw/RU/4qbXQby/rslmLXX0Eoz5wLdHYcC9iR+Iv4Z2n7xzi4A9vX2AS6rlUfmN5
        2qy7d4X55nO4GWbbR7vMMZwRmdAiethA6OjcHjsn8/pupXUp9/jW67oFKLEUZyQaajEXFScC
        AAMhvj0cAwAA
X-CMS-MailID: 20211116213352eucas1p1d5481ca560d4fe712a346fd8ce792e7a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20211116213352eucas1p1d5481ca560d4fe712a346fd8ce792e7a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211116213352eucas1p1d5481ca560d4fe712a346fd8ce792e7a
References: <CGME20211116213352eucas1p1d5481ca560d4fe712a346fd8ce792e7a@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the values of EVENT_* constants from bit masks to bit numbers as
accepted by {clear,set,test}_bit() functions.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 drivers/net/ethernet/asix/ax88796c_main.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/asix/ax88796c_main.h b/drivers/net/ethernet/asix/ax88796c_main.h
index 80263c3cef75..4a83c991dcbe 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.h
+++ b/drivers/net/ethernet/asix/ax88796c_main.h
@@ -127,9 +127,9 @@ struct ax88796c_device {
 		#define AX_PRIV_FLAGS_MASK	(AX_CAP_COMP)
 
 	unsigned long		flags;
-		#define EVENT_INTR		BIT(0)
-		#define EVENT_TX		BIT(1)
-		#define EVENT_SET_MULTI		BIT(2)
+		#define EVENT_INTR		0
+		#define EVENT_TX		1
+		#define EVENT_SET_MULTI		2
 
 };
 
-- 
2.30.2

