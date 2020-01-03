Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D415012F601
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 10:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgACJUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 04:20:54 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:55528 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbgACJUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 04:20:54 -0500
Received: from localhost.localdomain (unknown [159.226.5.100])
        by APP-03 (Coremail) with SMTP id rQCowAAXt3BqBw9e7zfDAQ--.37S3;
        Fri, 03 Jan 2020 17:20:43 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: Remove redundant BUG_ON() check in phonet_pernet
Date:   Fri,  3 Jan 2020 09:20:40 +0000
Message-Id: <1578043240-35541-1-git-send-email-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: rQCowAAXt3BqBw9e7zfDAQ--.37S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr45Ww43XF18tw15XrW7twb_yoWxAFcEyF
        4xu3Wjvw10gr1j9r4Yqw45ArZxXa4vqF1xGr1DKFZ7Aa98Krn8Z3ykur18GFW7Wrs0kr1f
        A3W7Ary5uwnxujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbFxYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z2
        80aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
        zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx
        8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s02
        6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
        I_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
        6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj4
        0_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j
        6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jY6wZUUUUU=
X-Originating-IP: [159.226.5.100]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBAMEA102S2KgFwAAs1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Passing NULL to phonet_pernet causes a crash via BUG_ON.
Dereferencing net in net_generic() also has the same effect.
This patch removes the redundant BUG_ON check on the same parameter.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 net/phonet/pn_dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index 49bd76a..ac0fae0 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -35,8 +35,6 @@ static unsigned int phonet_net_id __read_mostly;
 
 static struct phonet_net *phonet_pernet(struct net *net)
 {
-	BUG_ON(!net);
-
 	return net_generic(net, phonet_net_id);
 }
 
-- 
2.7.4

