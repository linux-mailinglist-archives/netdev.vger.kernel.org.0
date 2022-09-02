Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59B95AA71E
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 07:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiIBFDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 01:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiIBFDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 01:03:13 -0400
Received: from mail.tkos.co.il (wiki.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA455B4E84
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 22:03:11 -0700 (PDT)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id 8E8F1440602;
        Fri,  2 Sep 2022 08:01:56 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1662094916;
        bh=D6u5SAG1dDi/HWOD3MuhsxWSm0ClasUboOozWZahHVY=;
        h=From:To:Cc:Subject:Date:From;
        b=Rst+CeIuCbhJwWyi1+SY0JSMzJ3TgwyzgY4ebkNzjF9TgjvaydQEt7OSpwdPzYWPm
         98/rIRqakuHg1/L8yWOxQHt6IaJcdYFRAiWVQomS4YYivfJF892nD8/5pd/MrxdZ3r
         7Q0LzPSBZFQdK3D4gPdOtlLmcy/PNTKhf9e+t5S9LkIy5i+ieK7dl4ugwVKUFlL/qD
         w4ovH+BI8Mc6KRM0yrMi4i6sickY4lxFT2Bo5uM1d55yAgz/0T+8JPv4f40vxKBPOk
         eSah/4ZCo0KpHUAnVN/NbfuGn8QMeVWMeFxvqod8UZr7sxOZd3Q69ZoT1q2qxWG7Nc
         brsCVxbPmk98Q==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH iproute2] man: devlink-region(8): document the 'new' subcommand
Date:   Fri,  2 Sep 2022 08:01:17 +0300
Message-Id: <a9287bd06c374ed54ff824e49aca18df0366a595.1662094877.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some driver provide no region snapshot unless created first with the
'new' operation. Add documentation and example.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 man/man8/devlink-region.8 | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/man/man8/devlink-region.8 b/man/man8/devlink-region.8
index e6617c189c34..b70679613341 100644
--- a/man/man8/devlink-region.8
+++ b/man/man8/devlink-region.8
@@ -22,6 +22,14 @@ devlink-region \- devlink address region access
 .BR "devlink region show"
 .RI "[ " DEV/REGION " ]"
 
+.ti -8
+.BR "devlink region new"
+.RI "" DEV/REGION ""
+.BR "[ "
+.BR "snapshot"
+.RI "" SNAPSHOT_ID ""
+.BR "]"
+
 .ti -8
 .BR "devlink region del"
 .RI "" DEV/REGION ""
@@ -56,6 +64,17 @@ devlink-region \- devlink address region access
 .I "DEV/REGION"
 - specifies the devlink device and address-region to query.
 
+.SS devlink region new - Create a snapshot specified by address-region name and snapshot ID
+
+.PP
+.I "DEV/REGION"
+- specifies the devlink device and address-region to snapshot
+
+.PP
+snapshot
+.I "SNAPSHOT_ID"
+- optionally specifies the snapshot ID to assign. If not specified, devlink will assign a unique ID to the snapshot.
+
 .SS devlink region del - Delete a snapshot specified by address-region name and snapshot ID
 
 .PP
@@ -106,6 +125,11 @@ devlink region show
 List available address regions and snapshot.
 .RE
 .PP
+devlink region new pci/0000:00:05.0/cr-space
+.RS 4
+Create a new snapshot from cr-space address region from device pci/0000:00:05.0.
+.RE
+.PP
 devlink region del pci/0000:00:05.0/cr-space snapshot 1
 .RS 4
 Delete snapshot id 1 from cr-space address region from device pci/0000:00:05.0.
-- 
2.35.1

