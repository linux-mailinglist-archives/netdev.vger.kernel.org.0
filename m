Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B362E2525BB
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 05:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgHZDN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 23:13:29 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:56508 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726672AbgHZDN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 23:13:29 -0400
Received: from localhost.localdomain (unknown [159.226.5.100])
        by APP-03 (Coremail) with SMTP id rQCowADX3ho200Vfqr_JBA--.3629S2;
        Wed, 26 Aug 2020 11:12:54 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ptp: ptp_ines: Remove redundant null check
Date:   Wed, 26 Aug 2020 03:12:51 +0000
Message-Id: <20200826031251.4362-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowADX3ho200Vfqr_JBA--.3629S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jr4xAFWUAw4DZr43Kry7GFg_yoWxZrXEkw
        10qF1I9r4UXw40yw12kw4rurWv9a4kXr1rX3Wvqa13A39rWr15ArWv9rWkXw1Duw43CFsx
        Jr93Wr18Ca9I9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb2AYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Gryq6s0DMcIj6I8E87Iv67AKxVWaoV
        W8JcWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8GwCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
        6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jtYFZUUUUU=
X-Originating-IP: [159.226.5.100]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiAxAAA13qZUwcAQAAsT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because kfree_skb already checked NULL skb parameter,
so the additional check is unnecessary, just remove it.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/ptp/ptp_ines.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ines.c b/drivers/ptp/ptp_ines.c
index 7711651ff19e..2c1fb99aa37c 100644
--- a/drivers/ptp/ptp_ines.c
+++ b/drivers/ptp/ptp_ines.c
@@ -663,8 +663,7 @@ static void ines_txtstamp(struct mii_timestamper *mii_ts,
 
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	if (old_skb)
-		kfree_skb(old_skb);
+	kfree_skb(old_skb);
 
 	schedule_delayed_work(&port->ts_work, 1);
 }
-- 
2.17.1

