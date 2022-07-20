Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB1F57B0C8
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 08:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238916AbiGTGG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 02:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiGTGG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 02:06:28 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2045.outbound.protection.outlook.com [40.107.96.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB7367CB9;
        Tue, 19 Jul 2022 23:06:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8eOemyxXAlcTXGv8Undy/jkTqwwMor3W+P6kLqjlTbiWY8qmprdlLS6ND96AnODL7Y+uxVsXO1C1SPZm4axaG5fOAA51IOChwUnE8wvJKgwwKAFB2wXsSbM/eeo8tjy2QZtxY3rRNHd/b1OCAKdVz8p3iQZ+Tpm9o5ouXz2C4+T9MrhanM1eEfxwir0f00wFt+4/qPljvfnob3N2loebdyaRWEd0dcX2USDNXq8MmnqqeriE8d2YuIlIJO8EAm7dBOcfbiHtYQiwoJejXpd89cWc2sKlW5gfoCgAi4niCES6h3p9tDT4o5l619osEAGtm70259hHN/NoqwgtoBhmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4vnW+5mJiQYQyp+6YA7OE0Yp8BZa5Anbx9H5BioudI=;
 b=Vi0hPgI3eb1k26WoYvIJ2NbbcV+TADWt3F0Xa4CsVH2HR7B5alxn8L7MkER+oiyOjb2/J0E+f1gcKp4c2iCxXaui0jSTnsjVlUOsdWcx/RuCjEM88jws2iUPYMt0K+fgXjObzDqwMwi66PWr0zsvW2nZab0SNDCSn+yNK0kd7WRLIpUZOS6G5f2zut5n1laxreDvRF1ZyXUZoO2HszS/sr14AlAJ66jIIDU7V8jw8KDEsd5pihvru1fxDWF6ETUU7X81rRm2XdmR+qVABsrKh7FmycJcC0mqEOTicEArwbLy+4GfNCmmf4La+9zNtUMrCXbJ9NzVCpkQVhGFDv1fIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4vnW+5mJiQYQyp+6YA7OE0Yp8BZa5Anbx9H5BioudI=;
 b=hligcmSIdfKNxp9rPkWLq0FDZhfV8y31ix9wWDvXFG72lJMEhooWmLN+/ol+QK2oFxV4VAXeewWvfCXGPdmSAAJlJxyarFijx6aFWagfULhoMxKRtoBLSC2YQcZIIghd60FjD/RtN0TPDvT260VcM4ravjyM/InAqbuYLhcKwYo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by BN9PR03MB6025.namprd03.prod.outlook.com (2603:10b6:408:136::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Wed, 20 Jul
 2022 06:06:25 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%7]) with mapi id 15.20.5438.023; Wed, 20 Jul 2022
 06:06:25 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oliver@neukum.org, kuba@kernel.org,
        ppd-posix@synaptics.com, Bernice.Chen@synaptics.com
Subject: [PATCH v5 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices
Date:   Wed, 20 Jul 2022 08:05:17 +0200
Message-Id: <20220720060518.541-1-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <4e061614-851e-0dd4-59b2-7110b1a4c339@suse.com>
References: <4e061614-851e-0dd4-59b2-7110b1a4c339@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::18) To SJ0PR03MB6533.namprd03.prod.outlook.com
 (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e19eac5c-ef63-47e8-f83e-08da6a15f9fe
X-MS-TrafficTypeDiagnostic: BN9PR03MB6025:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KPIj5Web+U+3u/fvl0xwz8icKcmMqnwCESgSoFr98x+1QTmQZgvTSWIUuGFWrE/U1jmU4qQgNOkutuknDIpEjQJxuVrqfNdTE2X8uLT+0YyS7MIZ2pTAi7aNEdekbfjkz+A5kgUCzARohoV9lq1cz2GBK7YpGjDV7woxNaEAy+uLdL/auxc77//bCosYZkCtkoAU2BMAijBn6pusIwwb8m1tujp5iD8eRRtnqIgNm5Z8ysAPE7GX0i3i2R+Im67LeWP1r/vVc1+C+tl39RrK1VJewTCQFx2eqcVmheUnE2yJjwUtqNY4fsMU9nxGBL9JRqrRJ1/vd9sImDVNU17zHXVRbnWAtNPrrfLj4YZVh9CeaN3yy7Mo215i/3kaLe+0JVG1T6ooUv7ew82xsyyWBKMuqLDrTWBYpB/tQtDedhMQ1Y1XQabqe929EVz9tznm3xwTPP+9qckhInvksnpJ+nwlngtgMGf3F371N/OPdJBIxmEiH8N1dl/hBSgigP2bB32jjHMa+JSvWCpKhkYra4hxSCRl77r31NLgAV3aahtbgcRIygZm7XDD9cF5ttivkZVYKnoEeUGfAbD0ynoH/O769Xk3i2h9Q7fPR53JGFHh++bIzBtWFfZJ87jWGAcHvUgtXlLLxxt9VpmixjkBfFJiLy0x5nd/q0n/ZJeYMH+z5fztWCEjW51Ise6tfKRch9k0wg4vmpO4tkhrANyxY2MbyM1ElMJfV8R1x2CqFk4fJ2YYUo/tOrzcgPMfDjXuLOCo268z/tbh/3us7FdLa8MpH+q5hl+k3xlLxoO0JQA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(4326008)(1076003)(66476007)(478600001)(2616005)(8676002)(8936002)(186003)(66556008)(26005)(52116002)(36756003)(6506007)(6486002)(107886003)(41300700001)(6512007)(6666004)(19627235002)(316002)(5660300002)(6916009)(38100700002)(83380400001)(38350700002)(2906002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEJJVk5tei9kR3ZRTkhNa1BMaWdLY2lHeERWQVpSdHZSUzhUYlMrZW5lUng4?=
 =?utf-8?B?VzE1ODZwbzhLTWkvU2RvbU1zcW9pZ25PR3hHQ0tZYVh5R21Dc1QyZm53SjR2?=
 =?utf-8?B?ZmcrV2x0MFVWSFdsdUNLRlJhUFR3UlA3V2xyNXZua1RISWRNTUxINi9Na0RQ?=
 =?utf-8?B?dWFSWkpONHpqQmI2a0xxSlVrQXcrK2ZvQ3ZTY1VqQnhqUjlVUE83V0VtQ1oy?=
 =?utf-8?B?d3hWQUVtK210WXJIemRNL29aUEtFUXZ0cHNETUdiNkMrdjRXVzFwQ05GN3ZY?=
 =?utf-8?B?TzJwR0ZBOWFVRlhNOXMvUElYck5OT0pPbS9NT2xaNUpDMVpiQ1RiMFBnMCtC?=
 =?utf-8?B?eEVES2NVdm00dEVUYXpTVkdGMGFLWDlrZGVRU2VkTVM2T2x0S3IvclExaWNu?=
 =?utf-8?B?bm5qK0xBaURGMG44RlhRSHZuOTl3Mko1eUxxeW1QanBGMElTTXFKREF6cHJU?=
 =?utf-8?B?YUZnTUNtamUzMVJnVzJJV0h5S0d6M0g3MVF0bE9VWHRVb3M5WDBpQ29zam8x?=
 =?utf-8?B?aVBtYnVCaFI2dFRDYzRQTzVYZTRSKzlrMStCNTRNS0dVWVBqQzEvb0lTTStm?=
 =?utf-8?B?aUNxRTZQT1NHWkxoRnVKQUh0M1lnTEcxKzJOSzFCYUY2c3RtSTBxQ2o0UkxF?=
 =?utf-8?B?RzVJUkZ2YzJSSW01STljMWxkVXBwdlBjdENrOUVLT0xXV2h6NFBuaWhybTNG?=
 =?utf-8?B?UzNFMW8zZVRPSnlsREk3YnFVTHBaVzVhRzhkeWtaSWNuKzJrRjZsSFY3QmJI?=
 =?utf-8?B?QjBjeVFDWlMyazlGL2FzV3dqMG9GcUZ5QlhDeTZjeko0M3FsTy92aGxNUERa?=
 =?utf-8?B?bUdoT0RmWHdoNzFhNmVnUzBTWWJXYkxoeGo1QzJjU0xJYWM1Nm5meU1YNWtq?=
 =?utf-8?B?aUZ0T3ZuTHQzSFhUSEZwcmlkZ3h0eTBjQVdDN3dRV3l4WHRkOUtiOEJMUGFI?=
 =?utf-8?B?UUJpMnlOK0taVHg0d05SQlpUcURrUW9rSDczY0haRThzeGswU1ZPZDhWSExo?=
 =?utf-8?B?R3NhT2cvZHBJNFZtQ0I1amNUd2V3M2hObXdtT3NZWW0rTTI2M0NnZXRGYjE4?=
 =?utf-8?B?QnROSjZ4T0lIU1JWd3V5YmpRcnVPNVl5NEhXZVRiZVlUMy9YRHBxWGxrYjI3?=
 =?utf-8?B?dlBZNVpwWE5SVlVxbGh6OWpmZEV3anIrTHF3Q0I1cURsKzBFZklVTjRzRTll?=
 =?utf-8?B?Qy9hSmkyZmV2dmtzajBjcHFTM1Ird3N1a0Fob0g5WjhETTFiTWFqVDI0TWZU?=
 =?utf-8?B?U29oUmQzbzYyOGMyMHZJeXNEMHRNNmdXNTNORCtMU0RWN0QxOWoxdVE2SHJG?=
 =?utf-8?B?M0t6MjJYTDZTN09SdW40MU9kck43THRRZHg0ODFGTTM0aVUwaSs5eUVmRTNN?=
 =?utf-8?B?ZWorOTFxOFpxRUs3UytzSDlxRXJsN2l1SXZoYkhyV29zb3VxRkJ4Z003STY2?=
 =?utf-8?B?NjJJbndzL25UVzZ0c2RwRURUeTUvTUVKWnBMQUZJOUp5WGtOOERCRVpsa1JY?=
 =?utf-8?B?ZzBmVkhGbmZNQ1VJck1GSmsxc3FNRUNoTkJtVFd6QVVIeGhiYnZUb1ZXa0Rh?=
 =?utf-8?B?aFpIcmlROXV2MEduOENCMDcwR0s5NmswT010QXZxekpFeXlNZmpPczhIRWl1?=
 =?utf-8?B?TXdQbTNnRE1NK0FEK1RKSmhlZ0VnYzdpdUF2VGYyUmRJek0yUGw2QW1WbHN5?=
 =?utf-8?B?TndGVE5ldnFXTlk1Vko3bzdsZ3U3SElqVGxqeUI4NUZtVndYeGs0MjdKRTJX?=
 =?utf-8?B?T2JHNE55RGhDU0lmVTFaYVB6OEpHWFNUOEJ1b1FYVUczTFp5ZkNQYmdQRVh3?=
 =?utf-8?B?NE5IUVpKMU9sVHBHT0RhZDdzMFh2SkNSMVJFa0YxdENGOW5KalFQeGZBWlc5?=
 =?utf-8?B?Vjc4MTQrU2YrNWdrSlQ0WDNRYXNsRzF0S09iNHlDSDB2elJCSDNWbHlFMnZh?=
 =?utf-8?B?R3RKMWhxL1hIdGRZMEUrRDRhM3MwRXFFeWxUdTd0VjJRRlBLTkpKalJ0VWNH?=
 =?utf-8?B?YzhmYktUT1NPZHZMUDNFZTk5NDBOaDdmVnovMFE2bHIzV2lYTS9BdEZrUkpM?=
 =?utf-8?B?SzFmTmZRUWhuWUpqNDRMM3V0Nm9NNDBvR0V4cWI2MVlwUEZ4S2NVdmk5V3ZX?=
 =?utf-8?Q?BWcH+udb4FBn6+Gg87SUpPYaR?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e19eac5c-ef63-47e8-f83e-08da6a15f9fe
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 06:06:24.9002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rlKlxsrE5Rg//kt5gMt87bBoJ/faEihso8YY6XNlV2qb3vqwCjW1IOBgrugQIjMKl5BVE6/zhuMXC/9SmLDmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR03MB6025
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dominik Czerwik <dominik.czerwik@synaptics.com>

This improves performance and stability of
DL-3xxx/DL-5xxx/DL-6xxx device series.

Specifically prevents device from temporary network dropouts when
playing video from the web and network traffic going through is high.

Signed-off-by: Dominik Czerwik <dominik.czerwik@synaptics.com>
Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
---
v2: Added Sign-off-by: Bernice Chen as company lawyer.
v3:
  - Remove copyright as this is not really necessary.
  - Removed Sign-off-by: Bernice Chen
v4: No new changes, just resubmit with changed [PATCH v4 2/2]
v5: As asked by Oliver Neukum.
    Mark in original cdc_ncm_info description that it does not send ZLP

 drivers/net/usb/cdc_ncm.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index d55f59ce4a31..8d5cbda33f66 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1892,7 +1892,7 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
 }
 
 static const struct driver_info cdc_ncm_info = {
-	.description = "CDC NCM",
+	.description = "CDC NCM (NO ZLP)",
 	.flags = FLAG_POINTTOPOINT | FLAG_NO_SETINT | FLAG_MULTI_PACKET
 			| FLAG_LINK_INTR | FLAG_ETHER,
 	.bind = cdc_ncm_bind,
@@ -1904,6 +1904,19 @@ static const struct driver_info cdc_ncm_info = {
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
@@ -2010,6 +2023,16 @@ static const struct usb_device_id cdc_devs[] = {
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

