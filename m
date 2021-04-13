Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0811135DB87
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbhDMJp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:45:56 -0400
Received: from m12-18.163.com ([220.181.12.18]:47477 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhDMJpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 05:45:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=3/bHXVzFNaRdXvSYPl
        2V8FEalM5QD/aDw5WwKyuiQ/M=; b=EAHdK0F7Km1Qaq2eWpJ55P8VkDJsRGmPxJ
        dDWJU4CGMMgapwqK6b8eaOSzwUSl6N+qtYtAwv7GvSRitPeVTGQ31bEIo06Hh7ww
        p0x96asJO7WKGnfTZVsqmgxqUcsrIfrBthahpKnuaUCGBO6aqu4HC/l0TvdbYbvc
        41bxpXPeA=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowADnbIEvaHVg8nqbdg--.36679S2;
        Tue, 13 Apr 2021 17:45:21 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     davem@davemloft.net, alex.dewar90@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc: st-nci: remove unnecessary label
Date:   Tue, 13 Apr 2021 17:45:30 +0800
Message-Id: <20210413094530.22076-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EsCowADnbIEvaHVg8nqbdg--.36679S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrWxKry3JrW7uFWUKr1DGFg_yoWftrg_ur
        y5XryxXrW8Gr1Yy34DurnxZr95Kw4UWry8Ww1agasxKryDGw1DC3yq9rn3Jw1UWr18AFyq
        93Z3C34Syr98ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5Ub15UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/xtbBLBFzsV++LMuPpQAAsT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

in st_nci_spi_write function, first assign a value to a variable then
goto exit label. return statement just follow the label and exit label
just used once, so we should directly return and remove exit label.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/st-nci/spi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index 8db323a..09df6ea 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -95,17 +95,14 @@ static int st_nci_spi_write(void *phy_id, struct sk_buff *skb)
 	 */
 	if (!r) {
 		skb_rx = alloc_skb(skb->len, GFP_KERNEL);
-		if (!skb_rx) {
-			r = -ENOMEM;
-			goto exit;
-		}
+		if (!skb_rx)
+			return -ENOMEM;
 
 		skb_put(skb_rx, skb->len);
 		memcpy(skb_rx->data, buf, skb->len);
 		ndlc_recv(phy->ndlc, skb_rx);
 	}
 
-exit:
 	return r;
 }
 
-- 
1.9.1


