Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0FB3E2E18
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 18:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241405AbhHFQDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 12:03:34 -0400
Received: from tulum.helixd.com ([162.252.81.98]:49593 "EHLO tulum.helixd.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhHFQDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 12:03:33 -0400
Received: from [IPv6:2600:8801:8800:12e8:6d98:f916:e67:fd3] (unknown [IPv6:2600:8801:8800:12e8:6d98:f916:e67:fd3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id 62A542080B;
        Fri,  6 Aug 2021 09:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1628265796;
        bh=QJMa01oEKTubyq4zv0bQA9VLTrB3Xj1DPTBcnc33tL8=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=GC/zHDY8/+rhOx84B6LXYZuOVCQid3MNjRQ8wH9qI1x0r3mrSN0jJn4iWO9su514p
         aXHaVWUi20Pi+Ao6/ZVKG+5GkNqLVde/MdfO57UJuCrzwJMVLMrwRJzxJULEkDjVEv
         JX0s6Iu9yTbWwvBQ3Htjvvl8X84mmJ3r4rPh7DMA=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
From:   Dario Alcocer <dalcocer@helixd.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <YPsJnLCKVzEUV5cb@lunn.ch>
 <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
 <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com> <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com> <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com> <YQGu2r02XdMR5Ajp@lunn.ch>
 <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
 <fea36eed-eaff-4381-b2fd-628b60237aab@helixd.com>
Message-ID: <de5758c6-4379-1b70-19ff-d6dd2b3ea269@helixd.com>
Date:   Fri, 6 Aug 2021 09:03:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fea36eed-eaff-4381-b2fd-628b60237aab@helixd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got mv88e6xxx_dump working by doing the following:

* copying nexthop.h and rtnetlink.h from /usr/include/uapi/linux to 
/usr/include/linux
* commenting out the undefined symbol references (see patch below)

diff --git a/desc-devlink.c b/desc-devlink.c
index 820121e..1876b65 100644
--- a/desc-devlink.c
+++ b/desc-devlink.c
@@ -182,24 +182,24 @@ static const struct pretty_nla_desc __attr_desc[] = {

  	NLATTR_DESC_STRING(DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME),
  	NLATTR_DESC_STRING(DEVLINK_ATTR_FLASH_UPDATE_COMPONENT),
-	NLATTR_DESC_STRING(DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG),
-	NLATTR_DESC_U64(DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE),
-	NLATTR_DESC_U64(DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL),
+	//NLATTR_DESC_STRING(DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG),
+	//NLATTR_DESC_U64(DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE),
+	//NLATTR_DESC_U64(DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL),

-	NLATTR_DESC_U16(DEVLINK_ATTR_PORT_PCI_PF_NUMBER),
-	NLATTR_DESC_U16(DEVLINK_ATTR_PORT_PCI_VF_NUMBER),
+	//NLATTR_DESC_U16(DEVLINK_ATTR_PORT_PCI_PF_NUMBER),
+	//NLATTR_DESC_U16(DEVLINK_ATTR_PORT_PCI_VF_NUMBER),

  	//DEVLINK_ATTR_STATS,				/* nested */

-	NLATTR_DESC_STRING(DEVLINK_ATTR_TRAP_NAME),
-	NLATTR_DESC_U8(DEVLINK_ATTR_TRAP_ACTION),
-	NLATTR_DESC_U8(DEVLINK_ATTR_TRAP_TYPE),
-	NLATTR_DESC_FLAG(DEVLINK_ATTR_TRAP_GENERIC),
+	//NLATTR_DESC_STRING(DEVLINK_ATTR_TRAP_NAME),
+	//NLATTR_DESC_U8(DEVLINK_ATTR_TRAP_ACTION),
+	//NLATTR_DESC_U8(DEVLINK_ATTR_TRAP_TYPE),
+	//NLATTR_DESC_FLAG(DEVLINK_ATTR_TRAP_GENERIC),
  	//DEVLINK_ATTR_TRAP_METADATA,			/* nested */
-	NLATTR_DESC_STRING(DEVLINK_ATTR_TRAP_GROUP_NAME),
+	//NLATTR_DESC_STRING(DEVLINK_ATTR_TRAP_GROUP_NAME),

-	NLATTR_DESC_U8(DEVLINK_ATTR_RELOAD_FAILED),
-	NLATTR_DESC_U64(DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS),
+	//NLATTR_DESC_U8(DEVLINK_ATTR_RELOAD_FAILED),
+	//NLATTR_DESC_U64(DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS),
  };

  const struct pretty_nlmsg_desc devlink_msg_desc[] = {
@@ -264,16 +264,16 @@ const struct pretty_nlmsg_desc devlink_msg_desc[] = {
  	NLMSG_DESC(DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET, attr),
  	NLMSG_DESC(DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR, attr),
  	NLMSG_DESC(DEVLINK_CMD_FLASH_UPDATE, attr),
-	NLMSG_DESC(DEVLINK_CMD_FLASH_UPDATE_END, attr),
-	NLMSG_DESC(DEVLINK_CMD_FLASH_UPDATE_STATUS, attr),
-	NLMSG_DESC(DEVLINK_CMD_TRAP_GET, attr),
-	NLMSG_DESC(DEVLINK_CMD_TRAP_SET, attr),
-	NLMSG_DESC(DEVLINK_CMD_TRAP_NEW, attr),
-	NLMSG_DESC(DEVLINK_CMD_TRAP_DEL, attr),
-	NLMSG_DESC(DEVLINK_CMD_TRAP_GROUP_GET, attr),
-	NLMSG_DESC(DEVLINK_CMD_TRAP_GROUP_SET, attr),
-	NLMSG_DESC(DEVLINK_CMD_TRAP_GROUP_NEW, attr),
-	NLMSG_DESC(DEVLINK_CMD_TRAP_GROUP_DEL, attr),
+	//NLMSG_DESC(DEVLINK_CMD_FLASH_UPDATE_END, attr),
+	//NLMSG_DESC(DEVLINK_CMD_FLASH_UPDATE_STATUS, attr),
+	//NLMSG_DESC(DEVLINK_CMD_TRAP_GET, attr),
+	//NLMSG_DESC(DEVLINK_CMD_TRAP_SET, attr),
+	//NLMSG_DESC(DEVLINK_CMD_TRAP_NEW, attr),
+	//NLMSG_DESC(DEVLINK_CMD_TRAP_DEL, attr),
+	//NLMSG_DESC(DEVLINK_CMD_TRAP_GROUP_GET, attr),
+	//NLMSG_DESC(DEVLINK_CMD_TRAP_GROUP_SET, attr),
+	//NLMSG_DESC(DEVLINK_CMD_TRAP_GROUP_NEW, attr),
+	//NLMSG_DESC(DEVLINK_CMD_TRAP_GROUP_DEL, attr),
  };

  const unsigned int devlink_msg_n_desc = ARRAY_SIZE(devlink_msg_desc);
diff --git a/mv88e6xxx_dump.c b/mv88e6xxx_dump.c
index 09a67c1..a744a74 100644
--- a/mv88e6xxx_dump.c
+++ b/mv88e6xxx_dump.c
@@ -220,17 +220,17 @@ static const enum mnl_attr_data_type 
devlink_policy[DEVLINK_ATTR_MAX + 1] = {
  	[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS] = MNL_TYPE_U64,
  	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = MNL_TYPE_U64,
  	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = MNL_TYPE_STRING,
-	[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG] = MNL_TYPE_STRING,
-	[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE] = MNL_TYPE_U64,
-	[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL] = MNL_TYPE_U64,
-	[DEVLINK_ATTR_STATS] = MNL_TYPE_NESTED,
-	[DEVLINK_ATTR_TRAP_NAME] = MNL_TYPE_STRING,
-	[DEVLINK_ATTR_TRAP_ACTION] = MNL_TYPE_U8,
-	[DEVLINK_ATTR_TRAP_TYPE] = MNL_TYPE_U8,
-	[DEVLINK_ATTR_TRAP_GENERIC] = MNL_TYPE_FLAG,
-	[DEVLINK_ATTR_TRAP_METADATA] = MNL_TYPE_NESTED,
-	[DEVLINK_ATTR_TRAP_GROUP_NAME] = MNL_TYPE_STRING,
-	[DEVLINK_ATTR_RELOAD_FAILED] = MNL_TYPE_U8,
+	//[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG] = MNL_TYPE_STRING,
+	//[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE] = MNL_TYPE_U64,
+	//[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL] = MNL_TYPE_U64,
+	//[DEVLINK_ATTR_STATS] = MNL_TYPE_NESTED,
+	//[DEVLINK_ATTR_TRAP_NAME] = MNL_TYPE_STRING,
+	//[DEVLINK_ATTR_TRAP_ACTION] = MNL_TYPE_U8,
+	//[DEVLINK_ATTR_TRAP_TYPE] = MNL_TYPE_U8,
+	//[DEVLINK_ATTR_TRAP_GENERIC] = MNL_TYPE_FLAG,
+	//[DEVLINK_ATTR_TRAP_METADATA] = MNL_TYPE_NESTED,
+	//[DEVLINK_ATTR_TRAP_GROUP_NAME] = MNL_TYPE_STRING,
+	//[DEVLINK_ATTR_RELOAD_FAILED] = MNL_TYPE_U8,
  };

  static int attr_cb(const struct nlattr *attr, void *data)

