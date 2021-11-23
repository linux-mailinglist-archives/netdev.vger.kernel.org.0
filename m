Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F1745A0EE
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbhKWLLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:11:12 -0500
Received: from mail.loongson.cn ([114.242.206.163]:40328 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234587AbhKWLLK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 06:11:10 -0500
Received: from localhost.localdomain (unknown [111.9.175.10])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxltOJy5xh+ZgAAA--.1064S2;
        Tue, 23 Nov 2021 19:07:59 +0800 (CST)
From:   Huang Pei <huangpei@loongson.cn>
To:     netdev@vger.kernel.org, ambrosehua@gmail.com
Cc:     linux-arch@vger.kernel.org, lkp@intel.com
Subject: [PATCH 1/2] hamradio: fix macro redefine warning
Date:   Tue, 23 Nov 2021 19:07:48 +0800
Message-Id: <20211123110749.15310-1-huangpei@loongson.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9DxltOJy5xh+ZgAAA--.1064S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKryDAr15Jr13GryUXw13urg_yoW3Gwb_Cr
        1avr93Xr1DGw4jqr429r4rAa45Cw10gwn7uF9ag393Ww12yF47AFWkCrs7Jrs8CFW7ZFnx
        C34UCF18A3ySgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbw8YjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2Iq
        xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
        106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
        xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7
        xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8
        Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07jY6wZUUUUU=
X-CM-SenderInfo: xkxd0whshlqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MIPS/IA64 define END as assembly function ending, which conflict
with END definition in mkiss.c, just undef it at first

Reported-by: lkp@intel.com
Signed-off-by: Huang Pei <huangpei@loongson.cn>
---
 drivers/net/hamradio/mkiss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index e2b332b54f06..7da2bb8a443c 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -31,6 +31,8 @@
 
 #define AX_MTU		236
 
+/* some arch define END as assembly function ending, just undef it */
+#undef	END
 /* SLIP/KISS protocol characters. */
 #define END             0300		/* indicates end of frame	*/
 #define ESC             0333		/* indicates byte stuffing	*/
-- 
2.20.1

