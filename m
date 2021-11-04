Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16BE4450A8
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 09:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhKDI6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 04:58:46 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:50618 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230229AbhKDI6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 04:58:43 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-05 (Coremail) with SMTP id zQCowAA3+PQOoINhj9xCBg--.35075S2;
        Thu, 04 Nov 2021 16:55:42 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     krzysztof.kozlowski@canonical.com, yashsri421@gmail.com,
        davem@davemloft.net, rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] NFC: nfcmrvl: add unanchor after anchor
Date:   Thu,  4 Nov 2021 08:55:41 +0000
Message-Id: <1636016141-3645490-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: zQCowAA3+PQOoINhj9xCBg--.35075S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jry8Jry3JFyfKr1DtF48Xrb_yoWfXwb_KF
        WDJFy3Xrs5urZYyr1UKa4Fvry0kF1Iqrn7uFySqryaqrZ5KF429w4qyrZ3Jws8Gr4Dt3W3
        Ga4qq34rArWkKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbckFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8ZwCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
        0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUhdbbUUUUU=
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the error path, the anchored urb is unanchored.
But in the successful path, the anchored urb is not.
Therefore, it might be better to add unanchor().

Fixes: f26e30c ("NFC: nfcmrvl: Initial commit for Marvell NFC driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/nfc/nfcmrvl/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index bcd563c..f8ae517 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -146,9 +146,9 @@ nfcmrvl_submit_bulk_urb(struct nfcmrvl_usb_drv_data *drv_data, gfp_t mem_flags)
 		if (err != -EPERM && err != -ENODEV)
 			nfc_err(&drv_data->udev->dev,
 				"urb %p submission failed (%d)\n", urb, -err);
-		usb_unanchor_urb(urb);
 	}
 
+	usb_unanchor_urb(urb);
 	usb_free_urb(urb);
 
 	return err;
-- 
2.7.4

