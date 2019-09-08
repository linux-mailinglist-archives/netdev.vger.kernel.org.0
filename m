Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26848AD146
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 01:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbfIHXyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 19:54:52 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45670 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731203AbfIHXyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 19:54:52 -0400
Received: by mail-qt1-f195.google.com with SMTP id r15so14081095qtn.12
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 16:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/mu3kFz/4noHhOUuDA1Y/A1WY6xVTU9kSlUa3R8hWlM=;
        b=RAXeWOYZkf5rPeE2GzfYKwt+KLUQwEFnfbtI0u51pP34bitygO67p3UeJAiNfH3HzB
         q3/zQzTNdz+1tHEXqib3cL24BJ08VqYGR5/IdhWVljztEWrY7I0lBmUQ9GXbsi64aE0t
         F81Hc+ZTwcsFZDgWIqhBe1q/yjx0WCd5j1HprrkgMsdZClX1FpiBaoYjk0aExbekn92i
         QcIQ3Gj5C+JYXjbF3AHOQNJwg8vxkm5Cv28cIoqPTE5Pq8sbn6poFO7pFlvPUZNdTca6
         mica4telzXBTYLnGatp2vG4KeeFk0T0SoRaypKQTgvuvEt7mJYmx81vFMHyon8tDedE3
         FgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/mu3kFz/4noHhOUuDA1Y/A1WY6xVTU9kSlUa3R8hWlM=;
        b=ofb0uEjWDYHHPRB8cXzfZ+fpRNCHp9902UjA3dxZM16G0IoNi8Nrc8PcBuGgoHeF4O
         w4+ZUu5c8vhyFfMWI2sLMhRDq4VSOYplu/IyCsHGIL3A2q64GEaISioIwHH4PIgtO+OQ
         v6L/amDD6plkiV2+PAKjYPNqVXl0z80cwS8svPDuocHxcLfWtDTQykxInmoYUu4+rUU+
         0HZ6d0bn1YcpNrW9n8xUKeYsm47zCElwalfydowWaj3DAEYHZ6fD9IRrXFoKZlQLQsaT
         JyzfFQt6PZIS84QBvfuyJpBScI6DFLkG5aUrEX050xWYQ/pkHWHFLb/mqNvu9X2iUCB8
         L1bQ==
X-Gm-Message-State: APjAAAXn1iWBKHGWml28pNTpMbWmjSv1l1xRGrRRJe2ZQ/oMvyR5JrjS
        sM8LtZseWDv9dhckbul25UL5AA==
X-Google-Smtp-Source: APXvYqwKv9hldVIoIsb9+Ha/+gZPcGgDcnTBtGdBV6Q6XJnwLNce4T7hljUjqSo73FHy70KkST6UfQ==
X-Received: by 2002:ac8:3876:: with SMTP id r51mr21080913qtb.66.1567986891058;
        Sun, 08 Sep 2019 16:54:51 -0700 (PDT)
Received: from penelope.pa.netronome.com (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id p27sm5464406qkm.92.2019.09.08.16.54.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 16:54:50 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 01/11] devlink: extend 'fw_load_policy' values
Date:   Mon,  9 Sep 2019 00:54:17 +0100
Message-Id: <20190908235427.9757-2-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190908235427.9757-1-simon.horman@netronome.com>
References: <20190908235427.9757-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Add the 'disk' value to the generic 'fw_load_policy' devlink parameter.
This value indicates that firmware should always be loaded from disk
only.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 Documentation/networking/devlink-params.txt | 2 ++
 include/uapi/linux/devlink.h                | 1 +
 2 files changed, 3 insertions(+)

diff --git a/Documentation/networking/devlink-params.txt b/Documentation/networking/devlink-params.txt
index 2d26434ddcf8..fadb5436188d 100644
--- a/Documentation/networking/devlink-params.txt
+++ b/Documentation/networking/devlink-params.txt
@@ -48,4 +48,6 @@ fw_load_policy		[DEVICE, GENERIC]
 			  Load firmware version preferred by the driver.
 			* DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH (1)
 			  Load firmware currently stored in flash.
+			* DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK (2)
+			  Load firmware currently available on host's disk.
 			Type: u8
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 546e75dd74ac..c25cc29a6647 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -202,6 +202,7 @@ enum devlink_param_cmode {
 enum devlink_param_fw_load_policy_value {
 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DRIVER,
 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH,
+	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK,
 };
 
 enum {
-- 
2.11.0

