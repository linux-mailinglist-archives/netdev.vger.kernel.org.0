Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E05423443A
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 12:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732487AbgGaKrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 06:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729141AbgGaKrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 06:47:23 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B73C061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 03:47:22 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a15so27547341wrh.10
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 03:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=eVcg9NbgirkLFv5qDGy67mb6aJn69HzIYVXBnNnuV+U=;
        b=EdQSZMohyuryKqaH/XJWFWMgS8gADATW/YZ4N+imqOU7FYEvM4KOZba33ky5ATQHX+
         r+yQarb8i0EMQis7kmLGCNDdziCRl/T040imB34W0O125fPkw9l691pFS9oufMa8CmN/
         aZ4e9d4ly+G2ce3uX9J+sNPJ3U0hExt+Jk8W8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eVcg9NbgirkLFv5qDGy67mb6aJn69HzIYVXBnNnuV+U=;
        b=fiS3/RbQfxpoJmRpfVHofuEXa5qAsqmQmZ/2JfpEVcbDj1g8R7JmKUSxmdnAd/Tm4o
         OO9b/hIoe5UryCb+HS0qho+A0Wql1bmm1mVcS6ahaZM9/5qeWbTatwkWb+/YhVo8y6aN
         7wsP2KOH+4FfcvmD25VbdJs173j0vlsiaPUBW/zDAohi027YJa4HU8uCvwWoED9erKnJ
         9uZD6czTZnHxoG92BBF1QVlovN6fX5MpPqP225nHag4yKd3t4QWdD2z6lWnw81gAoVfY
         itcqGh2RJp72cOB00udYFbS7jjC0Q9aq41nACqE/UHdWDOuNr1dchg/Z6VMJbcvfYBJY
         ju0w==
X-Gm-Message-State: AOAM532hxe2NhCtKtdsaw5yEkwzxF7RessBKzDzu/z/6xXUdnqaQlRa0
        10AS7FJZSlgbleYa/4awh4TPB2Uk6q+3hcLJ+dSrNC03RSXlnttgGXZ8J/7kLHY4tqZBrQ1meEg
        rOvTIBxZgbKEpzoLFAkJN4YfxLnJr4o2zzVGr3f3BluRpiiE6O3Ie+iyMA7VkzPvY6WxSH/TrpP
        51dK0c
X-Google-Smtp-Source: ABdhPJyA0/Ei6o4doLf0iirW7EudGL2WJBnesyhySNgTLrpEl0UHhyhCjd67ykHTiauCZreZoy0uIA==
X-Received: by 2002:adf:f248:: with SMTP id b8mr3155676wrp.247.1596192440595;
        Fri, 31 Jul 2020 03:47:20 -0700 (PDT)
Received: from lxhimalayas.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k4sm14370602wrd.72.2020.07.31.03.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 03:47:19 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, davem@davemloft.net,
        jiri@mellanox.com, kuba@kernel.org, michael.chan@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v3 iproute2-next] devlink: Add board.serial_number to info subcommand.
Date:   Fri, 31 Jul 2020 03:46:43 -0700
Message-Id: <20200731104643.35726-1-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 2.18.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for reading board serial_number to devlink info
subcommand. Example:

$ devlink dev info pci/0000:af:00.0 -jp
{
    "info": {
        "pci/0000:af:00.0": {
            "driver": "bnxt_en",
            "serial_number": "00-10-18-FF-FE-AD-1A-00",
            "board.serial_number": "433551F+172300000",
            "versions": {
                "fixed": {
                    "board.id": "7339763 Rev 0.",
                    "asic.id": "16D7",
                    "asic.rev": "1"
                },
                "running": {
                    "fw": "216.1.216.0",
                    "fw.psid": "0.0.0",
                    "fw.mgmt": "216.1.192.0",
                    "fw.mgmt.api": "1.10.1",
                    "fw.ncsi": "0.0.0.0",
                    "fw.roce": "216.1.16.0"
                }
            }
        }
    }
}

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
---
v2: Rebase. Resending the patch as I see this patch didn't make it to
mailing list.
v3: Rebase the patch and remove the line from commit message
"This patch has dependency on updated include/uapi/linux/devlink.h file."
as the headers are updated.
---
 devlink/devlink.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 7dbe9c7e..f4230dac 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -648,6 +648,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_REGION_CHUNK_LEN] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_INFO_DRIVER_NAME] = MNL_TYPE_STRING,
 	[DEVLINK_ATTR_INFO_SERIAL_NUMBER] = MNL_TYPE_STRING,
+	[DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER] = MNL_TYPE_STRING,
 	[DEVLINK_ATTR_INFO_VERSION_FIXED] = MNL_TYPE_NESTED,
 	[DEVLINK_ATTR_INFO_VERSION_RUNNING] = MNL_TYPE_NESTED,
 	[DEVLINK_ATTR_INFO_VERSION_STORED] = MNL_TYPE_NESTED,
@@ -2979,6 +2980,16 @@ static void pr_out_info(struct dl *dl, const struct nlmsghdr *nlh,
 		print_string(PRINT_ANY, "serial_number", "serial_number %s",
 			     mnl_attr_get_str(nla_sn));
 	}
+
+	if (tb[DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER]) {
+		struct nlattr *nla_bsn = tb[DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER];
+
+		if (!dl->json_output)
+			__pr_out_newline();
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, "board.serial_number", "board.serial_number %s",
+			     mnl_attr_get_str(nla_bsn));
+	}
 	__pr_out_indent_dec();
 
 	if (has_versions) {
@@ -3014,6 +3025,7 @@ static int cmd_versions_show_cb(const struct nlmsghdr *nlh, void *data)
 		tb[DEVLINK_ATTR_INFO_VERSION_STORED];
 	has_info = tb[DEVLINK_ATTR_INFO_DRIVER_NAME] ||
 		tb[DEVLINK_ATTR_INFO_SERIAL_NUMBER] ||
+		tb[DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER] ||
 		has_versions;
 
 	if (has_info)
-- 
2.18.2

