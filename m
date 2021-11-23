Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C916C45A0EC
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhKWLLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:11:12 -0500
Received: from mail.loongson.cn ([114.242.206.163]:40338 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234813AbhKWLLK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 06:11:10 -0500
Received: from localhost.localdomain (unknown [111.9.175.10])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxltOJy5xh+ZgAAA--.1064S3;
        Tue, 23 Nov 2021 19:08:00 +0800 (CST)
From:   Huang Pei <huangpei@loongson.cn>
To:     netdev@vger.kernel.org, ambrosehua@gmail.com
Cc:     linux-arch@vger.kernel.org, lkp@intel.com
Subject: [PATCH 2/2] slip: fix macro redefine warning
Date:   Tue, 23 Nov 2021 19:07:49 +0800
Message-Id: <20211123110749.15310-2-huangpei@loongson.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211123110749.15310-1-huangpei@loongson.cn>
References: <20211123110749.15310-1-huangpei@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9DxltOJy5xh+ZgAAA--.1064S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKryDAr15tF43tw4rWw1Dtrb_yoW3WFg_Kw
        13Zr93XF1YkFnYqrW3Kr4rAFWYkw1UXwn7Wwnag343Xw1j9w48AFWkCa18Jr9xCr4vvFnx
        C3yYkry0y343KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbaxYjsxI4VWkKwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7
        IE14v26r18M28IrcIa0xkI8VCY1x0267AKxVWUXVWUCwA2ocxC64kIII0Yj41l84x0c7CE
        w4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6x
        kF7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY
        1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4
        xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCa
        FVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFV
        Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
        x4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
        1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_
        JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYx
        BIdaVFxhVjvjDU0xZFpf9x07b589NUUUUU=
X-CM-SenderInfo: xkxd0whshlqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MIPS/IA64 define END as assembly function ending, which conflict
with END definition in slip.h, just undef it at first

Reported-by: lkp@intel.com
Signed-off-by: Huang Pei <huangpei@loongson.cn>
---
 drivers/net/slip/slip.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/slip/slip.h b/drivers/net/slip/slip.h
index c420e5948522..3d7f88b330c1 100644
--- a/drivers/net/slip/slip.h
+++ b/drivers/net/slip/slip.h
@@ -40,6 +40,8 @@
 					   insmod -oslip_maxdev=nnn	*/
 #define SL_MTU		296		/* 296; I am used to 600- FvK	*/
 
+/* some arch define END as assembly function ending, just undef it */
+#undef	END
 /* SLIP protocol characters. */
 #define END             0300		/* indicates end of frame	*/
 #define ESC             0333		/* indicates byte stuffing	*/
-- 
2.20.1

