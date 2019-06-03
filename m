Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446BA33A19
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfFCVrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:47:55 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33210 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfFCVrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:47:55 -0400
Received: by mail-ed1-f65.google.com with SMTP id y17so10849292edr.0;
        Mon, 03 Jun 2019 14:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MAT8OhoS4E4LTraS73i1GkEab4d2tmtFt+UsInKjjJY=;
        b=VBXBHrPvpSV9c710oZQ/FURflCEUoDTzB2RsYYgOCVVgjMVNXiD5bLiXCZCFwcDnvY
         4ZxP7ZineS8Zr0tO9wosc3nmO6TAkxrWp54rwY9om/RaukbnjBTUsOeYv4t8uhaPsJu2
         oR4aYRxNPFUQ1YVC0FTz17jP38hO6TT6ZqiOfadcM6sNoStkP56sGqjJPGjUxxkXgsWF
         +Cvico5SinDL2F/m87OmvsXih5rOYvdaXNnBikOJ2v0XY9X3ooZy6EJ6ojIzSa3qUtlX
         lpverQaCNzdXzbI9wVblP0LgqNXzcuSGU3WnvMrawroQgUQSJ/+3zfuzCPcdwvH/4Rwy
         vliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MAT8OhoS4E4LTraS73i1GkEab4d2tmtFt+UsInKjjJY=;
        b=rnvuMuU0X93qDQK+FRlrC8h6uoLtBSBc3UM8gaeTgRFEEL5VrT8SN+Ta+VN8L8OUKp
         qnlBedNGFyZYoSd4AToNe3oNO4biuIK6H9RHMEvhWl7WB/Duj1DDHD5A7JH2YeE9kbNJ
         0VwgbIAsKwTuRkFkRAQ9E2uAVcEcs0RjgZYRnTSTItum8csZyWEzkBPLXSfPIfOIqoIi
         ISuY/5y/Cb70kSMQLneS1gtUdWEh4csiy1eqh9ln/i7aCs7B2L4qWBPYTibHdAk9F6K4
         pUzQQLsDOEkCSsegVj2Q9EwrukWZFrElLDPWVQyGiFG1bK5TBQWMX797oQzX7uJRjq4u
         hVAQ==
X-Gm-Message-State: APjAAAWjgXk4dzz1S3q7Kj5QzB/IJcqX7scAbEOukTMgzjp1VPnXPUsY
        mvs8ufXcGku9jGCwlnDfDuW9IX1tZWQ=
X-Google-Smtp-Source: APXvYqztp4bl5Go/CL9OzkdSXd1fkORq8n4jiBnd3Uk9KoeuelIAM0v75z/280Ucla5BqFyXTwwKVQ==
X-Received: by 2002:a17:906:318a:: with SMTP id 10mr4143419ejy.245.1559595066841;
        Mon, 03 Jun 2019 13:51:06 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id j12sm856780ejq.44.2019.06.03.13.51.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 13:51:06 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] net: mscc: ocelot: Fix some struct initializations
Date:   Mon,  3 Jun 2019 13:49:53 -0700
Message-Id: <20190603204953.44235-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0.rc3
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/ethernet/mscc/ocelot_ace.c:335:37: warning: suggest braces
around initialization of subobject [-Wmissing-braces]
        struct ocelot_vcap_u64 payload = { 0 };
                                           ^
                                           {}
drivers/net/ethernet/mscc/ocelot_ace.c:336:28: warning: suggest braces
around initialization of subobject [-Wmissing-braces]
        struct vcap_data data = { 0 };
                                  ^
                                  {}
drivers/net/ethernet/mscc/ocelot_ace.c:683:37: warning: suggest braces
around initialization of subobject [-Wmissing-braces]
        struct ocelot_ace_rule del_ace = { 0 };
                                           ^
                                           {}
drivers/net/ethernet/mscc/ocelot_ace.c:743:28: warning: suggest braces
around initialization of subobject [-Wmissing-braces]
        struct vcap_data data = { 0 };
                                  ^
                                  {}
4 warnings generated.

One way to fix these warnings is to add additional braces like Clang
suggests; however, there has been a bit of push back from some
maintainers[1][2], who just prefer memset as it is unambiguous, doesn't
depend on a particular compiler version[3], and properly initializes all
subobjects. Do that here so there are no more warnings.

[1]: https://lore.kernel.org/lkml/022e41c0-8465-dc7a-a45c-64187ecd9684@amd.com/
[2]: https://lore.kernel.org/lkml/20181128.215241.702406654469517539.davem@davemloft.net/
[3]: https://lore.kernel.org/lkml/20181116150432.2408a075@redhat.com/

Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")
Link: https://github.com/ClangBuiltLinux/linux/issues/505
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index afbeb837a372..34d8260b8cb8 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -332,10 +332,13 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 {
 	u32 val, msk, type, type_mask = 0xf, i, count;
 	struct ocelot_ace_vlan *tag = &ace->vlan;
-	struct ocelot_vcap_u64 payload = { 0 };
-	struct vcap_data data = { 0 };
+	struct ocelot_vcap_u64 payload;
+	struct vcap_data data;
 	int row = (ix / 2);
 
+	memset(&payload, 0, sizeof(payload));
+	memset(&data, 0, sizeof(data));
+
 	/* Read row */
 	vcap_row_cmd(ocelot, row, VCAP_CMD_READ, VCAP_SEL_ALL);
 	vcap_cache2entry(ocelot, &data);
@@ -680,10 +683,12 @@ static void ocelot_ace_rule_del(struct ocelot_acl_block *block,
 
 int ocelot_ace_rule_offload_del(struct ocelot_ace_rule *rule)
 {
-	struct ocelot_ace_rule del_ace = { 0 };
+	struct ocelot_ace_rule del_ace;
 	struct ocelot_ace_rule *ace;
 	int i, index;
 
+	memset(&del_ace, 0, sizeof(del_ace));
+
 	/* Gets index of the rule */
 	index = ocelot_ace_rule_get_index_id(acl_block, rule);
 
@@ -740,8 +745,9 @@ static void ocelot_acl_block_destroy(struct ocelot_acl_block *block)
 
 int ocelot_ace_init(struct ocelot *ocelot)
 {
-	struct vcap_data data = { 0 };
+	struct vcap_data data;
 
+	memset(&data, 0, sizeof(data));
 	vcap_entry2cache(ocelot, &data);
 	ocelot_write(ocelot, vcap_is2.entry_count, S2_CORE_MV_CFG);
 	vcap_cmd(ocelot, 0, VCAP_CMD_INITIALIZE, VCAP_SEL_ENTRY);
-- 
2.22.0.rc3

