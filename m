Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8706357826C
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbiGRMgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234537AbiGRMgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:36:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8ED3E0DC;
        Mon, 18 Jul 2022 05:36:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kU00M/HfGiP1yqslaH3a5jqMsNlAaNWUJhkj1MDviMnHhpF8P1tK0dqvcsm7jTckneMh7k/CAFSXP6xMg5XKgLPTvIchkMTxypQykWLAGexQ8Okx+0ga+AgW/y1zPyIDb8l05IPd3Ub3LjvoQGjedUTdSReEDM03F2BdfsjZpQjCIhRCfk/yTwb0gAYjjmkQCCcWyTJCVzPmvK1o4Kr1txg+WpJodNywuKeoGDteUEvjeA6eQ6oEW+PLAzkBNEX8Nqd50zP2TF9CS+99FvrQ3LHmjJMZlNGPKDBPC3Yeb7TCGdZuYT+MdS9O1OtMBBlqFKVTvynkReyV5Usc1/dfkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIBA6SaIQDgiyX43ZMoL5ZRp1ZT0Wv8JGx7bz03IrU0=;
 b=MGzhEHqKvx+EDQ6i9bjEplA+OZGZEF6hn0BqCcSB6kvangGXBhKF7zLOfk7SXcGnCEPvd47fmmZ5ak4cMWwRvlKhtCmUE09smUMfaS6S2UIX4H0OVttEKQs2NCW6huq0znPnHBJpeeqqjfqgiNeevMYXtTBFb0CkQuwJRMww1ROZY2Bk01gzNBNFNnVi87qxnf+7emt6ukPI5NpBMUDbS8K/aff9F9BotzHQnnwBCXj1J+QAZ950PtL+CopDgnezzvvsW1IofyK5Br+ejCO22bKlHuJyxP3vHfSF4QNHa3aa99QlE2ObjnMWPKyLKYWgybFoRF7cRJBYQ/ZpQ05C/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIBA6SaIQDgiyX43ZMoL5ZRp1ZT0Wv8JGx7bz03IrU0=;
 b=NbeTPfz7oc40lVD/7wka3R7UkxP86gDKtmb6CGAngEm4tjSOQAB6AqUUlPsLKzx8C15uqy9hm38uMnfDm5P4Rv8sgVlO3xudtOA37bQpZEUxEod2YeqXVgX6lNyxJEmmSvqWtYtC3qPFJ+dwPMAq7NBeTnhq1qRWd7FRmX/eFhU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by BN9PR03MB6171.namprd03.prod.outlook.com (2603:10b6:408:100::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Mon, 18 Jul
 2022 12:36:36 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%7]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 12:36:35 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oliver@neukum.org, kuba@kernel.org,
        ppd-posix@synaptics.com, Bernice.Chen@synaptics.com
Subject: [PATCH v3 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices
Date:   Mon, 18 Jul 2022 14:36:17 +0200
Message-Id: <20220718123618.7410-1-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <YtAJ2KleMpkeFfQq@kroah.com>
References: <YtAJ2KleMpkeFfQq@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0019.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::12) To SJ0PR03MB6533.namprd03.prod.outlook.com
 (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 952cc97e-ba51-4685-68c8-08da68ba2738
X-MS-TrafficTypeDiagnostic: BN9PR03MB6171:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9MqeVEQ65/ixowCjxpd6EcHQ1iupctc1+3flhRfyF27QxKQNB5OM2s/+Tf8Irjgskgt2sE/muqXW+a1EGlsrfkmFqmblbXs+mNOK9OSUBlFl4Ihn/3tQeQR87kvNxpCU7/e2yPBMI5XuCuXG8meSSj7xIqN3foKLXrH+YH6rsHpoVO/bAc59iA6IrZqGzhOLFdR53BCtbyzsj7s3rVlfVdsqI9DaIdtPaFkvdmqsDBtwyr3feojBKfRbN3nGO3Z9KkWi/IvJylf3dlHlpiaJkC4Y3tJMiWVrh1bM6yYKEMksbbm2Lszmm5fyPcMH76k7B2zPn348QL9XII6unuk/6prMmJKbnT6PRX7Ri7adjJoq0EbkX+Tgno09VJxDC72iE6rWRRgH7bleplQzI73UNQyVzMiSY8P1ZAL/UkoYlHquueBzpSK1aq26B5ANZtKnJCEICNgSZPgciiI7h5bfEvMKB3OS3slDb/25NZ0VhOIwkKU5FBsRatHkr37hj2w7dRH2kBS8Ly+EHV5nwGI3KqMAjw42Mb9F/wkKWXYlwMnbSr9fOxKjBiNcadhlx8sW+fkns3XIaq/6osp34j8q+paXDO9Pk7MY15sveUdeolHxI3LxWdOGynJ9AkznhI9ur+B69ky4eLKXWBw5q6V5cToAal75BdbtqUu0NZOVMW7HtRQ/hUSscHj3udhCRuuqdYqfyBiKGrabFAaI3FcvlaXmihkQtRjkpZQiM9zM03KBUFenfh32KlLl29JwOBYgpwFXStI1FQAxO6kmOIpV2xRRjKau8dvAHF+5BYcfUEPzAQSpua+y++gx504/UO0C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(39860400002)(396003)(346002)(136003)(6916009)(38350700002)(19627235002)(38100700002)(316002)(36756003)(66556008)(66946007)(4326008)(8676002)(66476007)(26005)(41300700001)(2906002)(6666004)(186003)(6512007)(83380400001)(86362001)(5660300002)(2616005)(6486002)(478600001)(8936002)(107886003)(6506007)(52116002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1RVWkcxUWtCWW90RXFFcko1N0ZNQjZCcUxQNThtTUJjd1BVNnB4eEdiTzJT?=
 =?utf-8?B?SmllT3NsZGtjbTR4QWhKVytvVGZzRGRPU0JNU1Y3V3gvSDAzVmErNDlvall5?=
 =?utf-8?B?Z2tvYnhPR2xKZnJwaVlPRVpmUnlRUTdrbFZwUFMvZlhURlZlYnlDcXRjZm14?=
 =?utf-8?B?Q1o3clE1RXBiK0RQN3pDcCs3Y1pxWDJnNmZydVlqMHVCWWRxV2tFdGMxdUk1?=
 =?utf-8?B?NTQzRmJxK3lXM0Rtdk9oWFIxZEdBc1hvSFN3L2Znb3crSlpPUFhnVVZyekZF?=
 =?utf-8?B?ZG5lRXBwOStUcEM0bHJsVnFSTTR4ekIyWkE4UnhobmhiT2wvWWVUbzV4YWxN?=
 =?utf-8?B?U1dCakpjS2VyQ1ZNRHczN3N4ajFHUXJ0a0xENE9DUEhHY0lUWFJRd2FpOTBP?=
 =?utf-8?B?b05WdTBRb2tSOUQ0dHNHUGp0L0VSaGtTQzd6aVAwMzhPVDFRYWRtdGJUbUtq?=
 =?utf-8?B?aDhFZjQreDU4NWl6emJrZXRXQlY2THlEcHVJazhCZzNycWdpamJqTnVlVHUz?=
 =?utf-8?B?cDVvMDJHaGFJVXVlYmF1OWgvRC9NY1FzYUdWQkhycGFwcjBrRUZMSW9wNEoz?=
 =?utf-8?B?VDF6M0tGc1NVQ054aEFyWmJsOGRTdDR3OTRTcXk3QWxZcG8wcEpYWHhTOWFY?=
 =?utf-8?B?eVYvdHc0V3JlcEtwNU5pSWpmYkJpMTJIVTRvSUpXZ0ZRNGZoeUFBY1BKbm90?=
 =?utf-8?B?NDM1L3VMQy9kSS9WdGlYNWlYZmp4TjNPUWNDSGxZU1g3RnpaVk4ramNraGgv?=
 =?utf-8?B?alRLWEFGYnI5Y2RsNGV4TWRXSmwxeXpqeS81NHNPcXVJTmZ1Zmw1ZkhIRWxO?=
 =?utf-8?B?SmE2ZVFOeTVHNk56STdOUmhKU21UUjlNc21iRjU5Mm1DZXN3ZmxjRE9CcGc1?=
 =?utf-8?B?OG1RY0lURjk5cVpKWmxQdTErUWExd0M0UmMyZXNqVExvQ2ZKdFJ1bUZjVVBO?=
 =?utf-8?B?cG1RTXpWZVJUM2I5YUNNVE5ZTHRHUkZWKytRWkZlYkM0N3h3N2ZDcnNLWHo5?=
 =?utf-8?B?d2ZsOEhRZW5QOG1vdEVhd2ROc0djTGJRV0ZVNytnWjgwR0NtYWM3aTU4clFm?=
 =?utf-8?B?dld5V2kxalR6UzNvajM5dXJaUnRmaVN4UWhEUDBtMXhUOTVZY3NCU0NNb0Q2?=
 =?utf-8?B?UGVXU0JnQ0ZQdGhzQ1ljVzE5ZDdYeWVoUUwzT2E0ZEIvdUpxVWIwdXZWeWNZ?=
 =?utf-8?B?clAwR2NUMkFjajlIdE0ycWR5QmZ4L1lqVldrZTMvMFAwZ1VONG9Ndy9QRFhU?=
 =?utf-8?B?MXhNejA2U0ppK1ZTQ3lDMVg5Wm5ZQmd3OEd5S2FFMjdnT3U3OGdtMFdqZzNk?=
 =?utf-8?B?Zi9IZExRS0RrV05QVytCV0gzUGE0azBrVUZUSnM3Wm9UeGJOS2ZEckxsWHRv?=
 =?utf-8?B?NFE1NktQNzZvSzhhbHZIUVJiaXdNQTUzL3JKajBoZFBQNTJHTGhNMi8yMUdG?=
 =?utf-8?B?YzhvSC9LVGIyZDJuOXZKZVJocFJ5WjVMOWFPcXM2U0FzbnkzUjlMdi9teGs5?=
 =?utf-8?B?UldEdEJxNzNKci95clVKV05Za1JUVjhJQnZTaFlqd3BqSXpGWFlQN000M1p2?=
 =?utf-8?B?WU9GNEV2ZFhQV281ZVcyRUhYWDB1aHpxbWFWckJjMDRscUw0NSsyN1dVUU1m?=
 =?utf-8?B?L1VrazBwZDIraFVqMkJWSGVvTE9YaEljVWY1MUZiWkUzQXJHSDQ3aENoVkZp?=
 =?utf-8?B?bVdMQ095cm5yNmtjUHo1Z0JzbDZkZmFjUUU2cG1aK09ncFF6eUVlcTJFZzRV?=
 =?utf-8?B?QzdCaWdFcDMwQlY4RkV2MmxNeDVrdkNrb1R0L1k4bzhEMXZlK3hpRXo1TEJ2?=
 =?utf-8?B?eGRISDh0aGV3RVB6bUZ2YlAwNEFqTGZ0ak9HNnptajhmQkF4aGNKRlZmWUk5?=
 =?utf-8?B?akU0Wll4RmQ2bFd1ZzNsT1ZwdTRyUlIvOEQxbm45ZHo3b1lmT0d5MWo1U0I3?=
 =?utf-8?B?TFFvU3l6VXdLNXMweko2dWhIdUYzSEJML3NPZ1FId3NqczF3ZVN0MW02eDdw?=
 =?utf-8?B?MVNNT2FacjhGdWd5cENNWkx6SjBwZW1WWStzRjEzQWRWQjhoaVpPSXFBTFZT?=
 =?utf-8?B?emVWWW90VTZqSUpwOThGYVJJWDN2RkxQUU5LTDVYZkU1cWlqRUNZd2pnQ2V2?=
 =?utf-8?B?Q2FNTTZJVTdJa0gvNjc5S1dSTXZucWJ0dFVjajcySGZzcmFmNmRyRTdNZzRS?=
 =?utf-8?B?QWc9PQ==?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 952cc97e-ba51-4685-68c8-08da68ba2738
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 12:36:35.8966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNckzpqMgvyRa/aYyqinQutdo0SfcHxfcjUtmrt+TWyIxO900+ny2HhiGl1SQOF9MgOgHyBoHvearlGp1dIJbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR03MB6171
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

v3: We have decided to remove that copyright as this is not really 
    necessary.

    This is v3 revision of the patch series.
    Please forgive me it is wrongly resubmitted with git-send-mail.

 drivers/net/usb/cdc_ncm.c ssary +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index d55f59ce4a31..af84ac0d65c9 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
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

