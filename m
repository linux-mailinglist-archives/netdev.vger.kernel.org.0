Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E97C564E2E
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbiGDHEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiGDHEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:04:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139022E7;
        Mon,  4 Jul 2022 00:04:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhypC7tPAW0gmULNqm71bSJEZXWS6IYXe2rUbe6f9Zp/vzN4EHyaNeV9Ce6HxJBv9QwEWBo4UTWhM0lNjFhlXOaC/yZ6kB3zDj2Bz4jhihyrX5z/k0nc7B9lk6WqIqyheYBB0+occZA3xSDt6iQjzaW993X5p+SXqaMmt+0q8B4oAs/55r6yKjQakZEQ3gTNLl+KhfTk5bfBEcygHBJ2hQMFl20EmgfuQ34Tps7tMYFJuabUzl73+iYRdvOkWjNJQoIobSQYswjr3ZpHyMqjH/KGA4nFunNKZ1hAggByPtMQEsoiSzjluYngJVJWLki6OY2zlAKOG1vfPo3EJLlVnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEkIaNjEzGh0MJXfFULTvTKG6HLWjiqbiNpsBJJ7ygU=;
 b=ZZwMU3Rffgjw3l3rsWLsKLpBjhpGTqxFd28vHfTCUQ447WnTFu2aByueltngR1gPm5HofFL+Pzjpf9mdtcj1QvdqRBaU91VCXIudeduIt7tbZvAQQrDhC15UXfAN5z6yog/AXvEyXHdlIk/T2fIvr/R9XPrITYVux9xKHYoBpCHQ7WAYL8LctV8tn5McR8WTtbUz81EDUBAkGwvOFAQGUI2pLUe3RDZzPMX6XsDL0AG/sslAxhy4XI3Ym3Jx58dMWqZKH0TrXREmbpMl95+kBFIwAoNWN/vABKjDKeJ1a2JBFhqRMAbQa7uDYmjVhgbtO0lOGo5rVJdO/1yp1scGzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEkIaNjEzGh0MJXfFULTvTKG6HLWjiqbiNpsBJJ7ygU=;
 b=WWQ6cYKWJQhPNXyP8uJSug1Qs9Wychf1zjNy7bbcDghvqjcOoCe903FpKsgSmxA15G2sqHZOT47B8wZQ+0ylBKSSNF8z4Qv+PIW1eWlgra+Q1hoUfLWsjE5dojDF8tFprLnicjx+3JEjFYQo5uf7jU3KV0ka18wjsaaS2j6CdtU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by BL1PR03MB6088.namprd03.prod.outlook.com (2603:10b6:208:311::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 07:04:36 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%6]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 07:04:35 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oliver@neukum.org, kuba@kernel.org,
        ppd-posix@synaptics.com
Subject: [PATCH 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices
Date:   Mon,  4 Jul 2022 09:04:06 +0200
Message-Id: <20220704070407.45618-2-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704070407.45618-1-lukasz.spintzyk@synaptics.com>
References: <20220704070407.45618-1-lukasz.spintzyk@synaptics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BEXP281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::23)
 To SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82463cdd-7858-4e9a-75b5-08da5d8b70c7
X-MS-TrafficTypeDiagnostic: BL1PR03MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DvjvtJlDM9zFlNbd8GFAMZVfj1VewbzVJFpz6OUWqZ6wcDAWc1Mph87pOKMjNfKGDw1gpGf1xeqg8rotcqGGet7jnXgmp65dpDmAivu62rmtUyowVPnZ7bVEzuXm9P+4oe+nJgD6Qw88AVc+yrjcJPE1LQeKOqnFmhrsIEQGPlNr0yHRveoVjsefoKZYnrJx/UNEVzaE0OPam4EEa7cTxo7lPzRzSUNj3P9KyhuFh+/sNqMja54QaZHak3lXrS5XjTBf2QvhIpjLk3s0yOxUJZE3Ci+Hai97dGvOjhdSrZJOpO1E95cz14jP5KRSjTqydFT6wkpGQI7htXQajdv6y/nz1j0lTqzxlqeykPVICxNGwbqWvZmLbsV2G3jQymTUDl/ITDaWeBIqpBIZhvLDUIqG1qgxvF1z5ckqP5m1AFZ1gCXBIlDHOJjaBxNMq11hTfigC8RmdTuIzmcxxsl758EriCPNvy1+jWK/gnVIn86knIDBmhUZmzzGHvgI5ZeNqVD1Tm/CYe8QscxKCpTjqiuoLaw08Xcfxcj3QFJ+HQCWWU1zmpvYFNnpeA/FT0QlWKc5Rq+0ufR2554YjC2D9cDGCDaqDp/d5anDHYT83wbQTbP53jeu/k5FC8Sjy1ovD4J6gQqC7RuwBBjA8psmHm+PEjwCQ5ikkzk3YsWzzGaUaqIpdbXg6Ld65xJKpvzKvrsblzaLPzADcYy7u4H01GlAcpo/4eDtOE2kMcK6ayiR9+gV0LpLlIDQNjI+NjYYkFSNd95o2qfu2euRBRt0+YDm1lQw8GxqE/rGv/aR8kK00+DmV4FIv0fSMerHpwMd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(366004)(136003)(396003)(39850400004)(8936002)(66946007)(4326008)(38350700002)(38100700002)(19627235002)(41300700001)(316002)(36756003)(6916009)(186003)(6506007)(52116002)(107886003)(2616005)(2906002)(6486002)(83380400001)(478600001)(6512007)(86362001)(8676002)(66476007)(6666004)(5660300002)(66556008)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzJhR3c2b1pZSUJpUnlnWkFuUHhSWWduYU44dGIyRTlpcE45Vis5WW5FR0dp?=
 =?utf-8?B?eGp6TjQxV3F2aVl4SURzdDI0cWlFUzF2c3JhNTEwSUZUQVdaYUluYjFRQkp4?=
 =?utf-8?B?WFl3VHYwQ3RTa1p6YWpWRXBzVWNpN3B1ZVZmWGZZR2xXb1IxN01NUlJtMmxw?=
 =?utf-8?B?U2Z1NHFwRHh5SWx4U25xaWFyK2lRQktCc0o5bnltdFhYaTNBNXREU2JsTEFI?=
 =?utf-8?B?ZjJKeWdpblExY3poVkN6VU5uVFFRV1hzSFpDNHJYL1I3bTJRRW11QzhVSGpN?=
 =?utf-8?B?dEtQV29FRVA0U2ZrQlEvaldnVHdBdVRYOEtRTG43WjlrMmtha01HdldTYkFN?=
 =?utf-8?B?T3I3azkzQVAvTXQ2NzYvT2FaTkhvMUo3ZytRd1Y1UDlLR2N2KytOUS93Wmkw?=
 =?utf-8?B?WkVud2JpcC9mQ0hoS1N5TGN4clRwSGVDOHlNanZhRkFhMHhjK3Z3U0JCa1Nn?=
 =?utf-8?B?dGo2aVVaN2ZQaitycW5lcGxFd0diLzRMUkw3ZGI3eWg0WXdES3pvLzZ4VEdM?=
 =?utf-8?B?TVJpS2pkRGNRZW5GdEkxYUJpa3VyNFhUSU1qVzBTbDR5eERoQWE1L1RQbW1n?=
 =?utf-8?B?Umh0WXltTXlXa0xLRFVxeGp2TU5tUStqa29VL2NveVRsK2JOOThDYlFXVDQ2?=
 =?utf-8?B?UE9ieEdNcy96MWthV0p1aDk0bDhKaUZSTExnUHBPNFN2a1RjVTBLNVQwL0hn?=
 =?utf-8?B?em1BR3M1Zi9IYi9XT1hXUE0zQWN4Y1lFVStWSE1HWXhKc1pUMGJ2WjhhdXR3?=
 =?utf-8?B?aE9nOUtZR1BBcHZyQUg0ZWRYaFBrVUF5YWpaU1V3VzJMQkcxKzEwZlo1UEhy?=
 =?utf-8?B?MlB6Um5oQkJrRjZEbkFxaEt1WGJ4SWhNa09mMS9tTHVHM2xyR1VFOC9uM2pm?=
 =?utf-8?B?NGlZZnFLQVNHQUNWVzJPbFBvTW9wbEp2YmVGbVl6RUN5akRTREhNWHJuVldS?=
 =?utf-8?B?T3VYV2lHWDJwVGJhNXNxdDZhOVFXSUovSmFDZmIzdkMzVlFacjdDZThuaytj?=
 =?utf-8?B?anhSeUlZVTB6d1VVRmZhSi9Hc3JlSWJqYXNicCtaSFA4dGVDQ0VXVUpFcEdT?=
 =?utf-8?B?SVlzTndGb1U0emlITGQ0N1dKaDcrZUdiY1JlKzU1RGtvQytyV0Z0NlZpZzk0?=
 =?utf-8?B?U3JlMTdib2RjdDZVQytLZmsrc3VlRzdQSzlPVTc0Nm4rTm5QbTlMVVlwcktW?=
 =?utf-8?B?M1RjUEtsUFo3QWM4TW1MTGRVYlNIMTlzS0F0U1NJMm9kUFIwS1ZHZjVVQzY2?=
 =?utf-8?B?VDBGOFpnSC9ZNFV0bEVxcEpHaWl6WVZuZWlhMkdNbFlUTGExVzNyd2VWSmhW?=
 =?utf-8?B?NFZuSjk2aWk3V1l0bzNzWGp6MnhkaUlVNml0VktWcnB5MVBqSmxHQk8wUmVa?=
 =?utf-8?B?STAxNVZCdUUvTElSeE5ESE5IWFgwM09OWUdyL3VlUldZd3hQbXNBVElKc2RE?=
 =?utf-8?B?ajB6ekZxZ29BTVVPSVNGQ1NLODlSZ01TbWtqNmhpSlVaUm5YR2FZU1pjNjhL?=
 =?utf-8?B?bXZ0RWFMZEtEQnJueTJ1NFFJVlorSU45UllzSU5Mak9CMC9EaXRkYkZqenBa?=
 =?utf-8?B?a3hsbGJwTzdkMkFLTnl6aUJmRHRxajdrVFBrOWsxS2ovUUJMdnBtRFZtZ3ZD?=
 =?utf-8?B?ZmhvYUFvTDZ5dnBNbDNuT2RWUEtRWGJBcE1kMGdUanVKZHlES042Q2xlZlpD?=
 =?utf-8?B?d0cwb0tjb2JoSkJZRmFRb29lR2hlWnE5NnBCbXJBSjBhdXJqZy9OTzBVOFBJ?=
 =?utf-8?B?SHlwQTlWeUs2VnczOVdEbWRmODdkQnJ3eDBEZURsNHRLY1EwRDZWSGh3ZzBt?=
 =?utf-8?B?a1NYQ1plUWJOcnNOVlkyMDlOOEo5WEhIWklybzRHY3ZGMWVUQXRPRDVWMXFn?=
 =?utf-8?B?VmZkUmlMY2tWMXE2MXpRL2xBMVREWDBWakpWbVBHU2ZTaG5Oem41cWpYUDIv?=
 =?utf-8?B?NUdaNzJ0aWxRaHFyRlo0eTd4UEZ5ZDhpNm9xa1dvNkFJUktQemk4bkhWRDZa?=
 =?utf-8?B?VW11MHZKVXM0NlR0d3JscEdRbHFtbnNQZ1ZqdEtlK2o0KzEvRFhZY2xyWG81?=
 =?utf-8?B?OUtkNlNKOTE0QllOdlFaM25lTitHWWoybmh2TG1IR0d3YVBjMUZWSmEyTnZP?=
 =?utf-8?Q?bWbZ9yc83km3fVq+NCi0k5mz6?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82463cdd-7858-4e9a-75b5-08da5d8b70c7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 07:04:30.2178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3XL9bKy4ta1hxeEBpoCHeMNDnsr3VVNnPIZgPyrP3yZruSDGN+BxGhEEKjc4F5ugCAeR1wYVZzsVMhtDTkZLkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR03MB6088
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dominik Czerwik <dominik.czerwik@synaptics.com>

This improves performance and stability of
DL-3xxx/DL-5xxx/DL-6xxx device series.

Signed-off-by: Dominik Czerwik <dominik.czerwik@synaptics.com>
Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
---
 drivers/net/usb/cdc_ncm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index d55f59ce4a31..4594bf2982ee 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -2,6 +2,7 @@
  * cdc_ncm.c
  *
  * Copyright (C) ST-Ericsson 2010-2012
+ * Copyright (C) 2022 Synaptics Incorporated. All rights reserved.
  * Contact: Alexey Orishko <alexey.orishko@stericsson.com>
  * Original author: Hans Petter Selasky <hans.petter.selasky@stericsson.com>
  *
@@ -1904,6 +1905,19 @@ static const struct driver_info cdc_ncm_info = {
 	.set_rx_mode = usbnet_cdc_update_filter,
 };
 
+/* Same as cdc_ncm_info, but with FLAG_SEND_ZLP  */
+static const struct driver_info cdc_ncm_zlp_info = {
+	.description = "CDC NCM (SEND ZLP)",
+	.flags = FLAG_POINTTOPOINT | FLAG_NO_SETINT | FLAG_MULTI_PACKET
+			| FLAG_LINK_INTR | FLAG_ETHER | FLAG_SEND_ZLP,
+	.bind = cdc_ncm_bind,
+	.unbind = cdc_ncm_unbind,
+	.manage_power = usbnet_manage_power,
+	.status = cdc_ncm_status,
+	.rx_fixup = cdc_ncm_rx_fixup,
+	.tx_fixup = cdc_ncm_tx_fixup,
+};
+
 /* Same as cdc_ncm_info, but with FLAG_WWAN */
 static const struct driver_info wwan_info = {
 	.description = "Mobile Broadband Network Device",
@@ -2010,6 +2024,16 @@ static const struct usb_device_id cdc_devs[] = {
 	  .driver_info = (unsigned long)&wwan_info,
 	},
 
+	/* DisplayLink docking stations */
+	{ .match_flags = USB_DEVICE_ID_MATCH_INT_INFO
+		| USB_DEVICE_ID_MATCH_VENDOR,
+	  .idVendor = 0x17e9,
+	  .bInterfaceClass = USB_CLASS_COMM,
+	  .bInterfaceSubClass = USB_CDC_SUBCLASS_NCM,
+	  .bInterfaceProtocol = USB_CDC_PROTO_NONE,
+	  .driver_info = (unsigned long)&cdc_ncm_zlp_info,
+	},
+
 	/* Generic CDC-NCM devices */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM,
 		USB_CDC_SUBCLASS_NCM, USB_CDC_PROTO_NONE),
-- 
2.36.1

