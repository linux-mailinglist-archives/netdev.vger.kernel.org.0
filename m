Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8AEB2A34
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfING4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:56:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54533 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfING4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:56:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so4797213wmp.4
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EjNuf99IbS+4PZExqSUS3VlhW8wkPYxIFxlmAlPR2Fs=;
        b=Ia83meNPZQM2LNCzlbhzRCRL1NQCIH+ArSzoBtZFFJaBasHeBEsX6/4LDeyw+QiiHj
         5CzOAs7fyukEWDftwPikvD++NiTk/AswNDF85jDWzlA2Moit4186C5p0Ra1NCl6xnT8e
         fVt0BGvJFkr7lJeVGufQSy0dvfTr17xUkL9QptcgA1oF5KPtCktPm4R1SJfhlsy1x0GH
         tI6WOGT48nGhPYGzaPuMb+WDmEkTNUsKii+IM8TdJtqCs2+b+95k5F6slqGGi3NoJi1i
         cmbMwRh9/x+z8KWvXiK3Dq+PK5EeOOgdYQMWjsWe62Y9cJWAug/YEebI3HftGEr1DFin
         hRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EjNuf99IbS+4PZExqSUS3VlhW8wkPYxIFxlmAlPR2Fs=;
        b=MO8GqCtvAuRSfEUd2Y8oHLhHXOd0xkovM+p0uXtVbmIpwDCGUUVBam4BDK4FwyFqgq
         pq5fbc0nQ74g2o2LHAgOrFLdpMPlpYYSQTuc1pggxi6YdQUYwXJbIQUEer0wZ8y2otw+
         3VxLTMvawoGxa8InddlqdL6GZ7h+Kx8MeG3XCa7/deGPkrzM690Iju1FHI4WQA9OHg3j
         XaVTu8QRdkve3S3YI3H7YdN+sLvfPCqyNmqIPDvJpgaSTZ5ME85wVAqL6bI9Efp6nCr2
         aDYgPSw7FBwYDMsC45XdOrGufLFFKvofr9CNm9LuMLAIDlKEJhxF9i+8UtWjJ/7uPo4b
         +VoA==
X-Gm-Message-State: APjAAAVF0343H10M709yewMo2O45nrvGAPnusQ2s5AALpQY29S56Chsk
        epo2QaOm21HwT+Y4bdmER+lPa3YUSGg=
X-Google-Smtp-Source: APXvYqywdeuKU3P6Md1GZQHt8KYcoKPh8Nako29ID2NBBpNvPr966rZch+Zo2Hw1E8tR22pFeGPd+w==
X-Received: by 2002:a7b:c054:: with SMTP id u20mr5984320wmc.11.1568444199099;
        Fri, 13 Sep 2019 23:56:39 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u22sm54510678wru.72.2019.09.13.23.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:56:38 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, idosch@mellanox.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch iproute2-next] devlink: add reload failed indication
Date:   Sat, 14 Sep 2019 08:56:37 +0200
Message-Id: <20190914065637.27226-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c            | 22 +++++++++++++++-------
 include/uapi/linux/devlink.h |  2 ++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 2f084c020765..a1be8528c3c9 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -450,6 +450,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_GENERIC] = MNL_TYPE_FLAG,
 	[DEVLINK_ATTR_TRAP_METADATA] = MNL_TYPE_NESTED,
 	[DEVLINK_ATTR_TRAP_GROUP_NAME] = MNL_TYPE_STRING,
+	[DEVLINK_ATTR_RELOAD_FAILED] = MNL_TYPE_U8,
 };
 
 static const enum mnl_attr_data_type
@@ -1949,11 +1950,6 @@ static void pr_out_region_chunk(struct dl *dl, uint8_t *data, uint32_t len,
 	pr_out_region_chunk_end(dl);
 }
 
-static void pr_out_dev(struct dl *dl, struct nlattr **tb)
-{
-	pr_out_handle(dl, tb);
-}
-
 static void pr_out_section_start(struct dl *dl, const char *name)
 {
 	if (dl->json_output) {
@@ -2629,11 +2625,23 @@ static int cmd_dev_show_cb(const struct nlmsghdr *nlh, void *data)
 	struct dl *dl = data;
 	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
 	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	uint8_t reload_failed = 0;
 
 	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
 	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
 		return MNL_CB_ERROR;
-	pr_out_dev(dl, tb);
+
+	if (tb[DEVLINK_ATTR_RELOAD_FAILED])
+		reload_failed = mnl_attr_get_u8(tb[DEVLINK_ATTR_RELOAD_FAILED]);
+
+	if (reload_failed) {
+		__pr_out_handle_start(dl, tb, true, false);
+		pr_out_bool(dl, "reload_failed", true);
+		pr_out_handle_end(dl);
+	} else {
+		pr_out_handle(dl, tb);
+	}
+
 	return MNL_CB_OK;
 }
 
@@ -3971,7 +3979,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
-		pr_out_dev(dl, tb);
+		pr_out_handle(dl, tb);
 		break;
 	case DEVLINK_CMD_PORT_GET: /* fall through */
 	case DEVLINK_CMD_PORT_SET: /* fall through */
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 3fb683bee6ba..d63cf9723f57 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -410,6 +410,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_TRAP_METADATA,			/* nested */
 	DEVLINK_ATTR_TRAP_GROUP_NAME,			/* string */
 
+	DEVLINK_ATTR_RELOAD_FAILED,			/* u8 0 or 1 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.21.0

