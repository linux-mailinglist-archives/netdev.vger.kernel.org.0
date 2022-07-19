Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A0C579313
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbiGSGZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbiGSGZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:25:17 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8676DA183;
        Mon, 18 Jul 2022 23:25:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJGR+Q2sYeK+owZlKWugDNItOP93j6z0nSZW1T/6QsnAv2fUh2NoYsdG/+sVl1rZMch57QngXOn3mKNDeHJCy1uNM+1xLSfZrZNRICZ8GVgdLg2G2A8TVuXLrFQJRIszWISSp1k6EYGuVLEFM1TUf0K7Y0WXAX1H+aSoVAg3C/SakH3IxSGsPNnSTfZCweUcMUhW63oFz3IUdu3NfhtdpMYw4D22USd5eAXfyYR9U0oE1Si21VqvhlQW0+QD+zyJ/5FZeDD2gBJv4EvUCAwE1BvXAT40blf69UqXzsyg7pMXqkFytbxNTX759WmUaodmQsEK7HPIio2SYIXYymQjrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdTEjQOe4b1GldRvub1MFybVVEWnTdj4aUp+DixfhBE=;
 b=EX+CgBIWdbXReRuu0b4esOOedeHFJwLWDF3Skq3I7mPguG3NUUHWuYU5DU7q7QoEDZQUmRoXDdhs+U7lEyKzLaEPBgyql5HK4kOLEzk+cXUkQCymzHuLQmDD7OYu9CTm3RpF81jrxiMzSq/F6W+i9QEBBaTde7fG2mh3v7ZnUnZFuGcN8ynW/mcpyfU7faVwEARaiTGiM3dWH3wlFeOcTSf42T9TEHcnoyVSdoaTPcjyrvwzizZPROJriKRainBSRpgZ4dA7pnz/ZU77edeTJrk5vupHtpLl9FhJdyjIxn5RN75EzgOc+yRSXLC5cXwqwVhZr6aOgQAQN2vXrFpBng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdTEjQOe4b1GldRvub1MFybVVEWnTdj4aUp+DixfhBE=;
 b=b6h/uI1nKofjNAzSeXJCkWabELdhkiYuTGKwZVXydnR6v6pD1sHvKwUwpFgEo+epLLnIsN6aVwKhLnlorS9OQl9Kd6E6aeBi5HB/X4L9hBfD2aQhEa3nNFHCW69+KcORxxC8rZkW2pGtBYHhxpNs4hsHDtojQhimQ9WkPHrUjUo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by MW4PR03MB6650.namprd03.prod.outlook.com (2603:10b6:303:12d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Tue, 19 Jul
 2022 06:25:13 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%7]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 06:25:13 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oliver@neukum.org, kuba@kernel.org,
        ppd-posix@synaptics.com, Bernice.Chen@synaptics.com
Subject: [PATCH v4 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices
Date:   Tue, 19 Jul 2022 08:24:51 +0200
Message-Id: <20220719062452.25507-1-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <YtVw+6SC7rtKDzaw@kroah.com>
References: <YtVw+6SC7rtKDzaw@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0020.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::16) To SJ0PR03MB6533.namprd03.prod.outlook.com
 (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 712ff264-d70d-4b8c-f133-08da694f6fed
X-MS-TrafficTypeDiagnostic: MW4PR03MB6650:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Y1/tY+o6SQmBtGtw5+hXHFRJL3aNNRZv2iHBdXqS5hTwLXZR/0eT44PrgSSrGfKHG7owea5M8fG0wriunWzVz0pmlzmVwTBBhIwpuIJ6wRCxZmYO9kUyWXrwXI39bp+RlSvi3744myanpWm8eI5GN6jWEgD/9zGDUITpn4UTAVniJkSBbLVcrpJUR4NcrZeMFNmTEjPnUUSY2P6MD465qmcGHYeQVtP27xVojWfiYZi92nkOMO5Z9L3f+wOfFmwDFwJikJ94WRHM0WanPEDughRZexiap2Qvv/kCSN5hTAIfZx3QICDjUjqQC/0ZNiz0RpknaEJGHwpQdtO6MZ07Q2MsnWQLrGQiPozHwmjCOCAI1t8rc5O7GJ6jgUMqZBAW+KWiL/fCfBtPkemVa82p+amsst/MsLIDjB/SXvYJrIBebicMM5xbvvL1VK1DtAG0lxYyqf0aOYMrNFbP9uveueg2YYZOlg76DX9qwIVjKhK0xYC/Om1Ph81Oequ1GFI+l0pqR4HKclZfgwbUQiUrztER3GKUT8SflPlQbz9XxSQfh7cjRl2zNQfLLFd3Ur+nKgHfTQS8tijgruQdislnydQ5NW24YtyDE3QK6ULKdfR9kYqDhjaOmCajM0W/hSaC/SyJomCIvVBYlBGal1b1w9CWk9tulqoW23oGyFr4FQZ0Xep5Nm/8c2oVl5ryEruLEo2AMKLsBYEHPNYM1lF6Q4iHnAeOrV49qz54vcz1P0OnUwJjwpn38DdJWinjffNDszA8a6YxattPaUeKN3w6yecFfdKXzsf4mLU853m9p4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(136003)(376002)(346002)(396003)(36756003)(5660300002)(8936002)(2906002)(86362001)(66556008)(19627235002)(4326008)(66476007)(8676002)(316002)(52116002)(478600001)(41300700001)(6506007)(186003)(1076003)(107886003)(6486002)(6512007)(38350700002)(38100700002)(2616005)(83380400001)(6916009)(6666004)(26005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3YwMnZuQzN5Zkxod0tlVWxUKzNabTZxYXRmQlBaOEZIUTBTeUI2UkUzUEx6?=
 =?utf-8?B?ajJVWk1DTit1VTJLV2owSUhGeXpTV2dWWjFkT2x5L09PMFp2NDZWU0RyWU1P?=
 =?utf-8?B?NytOU3hFL2NGeGxIeUNNTlo3dnFlbXdvMWNMcFhqSDcrRDk4OHN6REFKWG9K?=
 =?utf-8?B?WC91SXNXZmNpM2N3WEZyVnV3Sld4VVdkQ2sxaU5MVjNqNU1LbXlFVU50UFJr?=
 =?utf-8?B?VXdXQlg2M1dCazBvQkF1Y1J3Y1I0M0l4aGtKWnFabXlzSmN1MkVYNXR6YWl2?=
 =?utf-8?B?dWl2SC9MeWZzanZhYmNuUTBMTnhQMU5XU01lQmgrUUNwaXlJVHNibzNZSHR6?=
 =?utf-8?B?dkErbklqZ3Job2dyQ0cxbGRZeUY4SFkvN09UckJOYlJBanVFVjQ5Z1ZGemZt?=
 =?utf-8?B?ZGNDZE1rYS96M0FNczVmL0hNdkh2Smcrd1JRSU52SnMwc1dSZXJoZXg5SE95?=
 =?utf-8?B?anQzemtCWlUzUU5TNkpvdS8wa1NLMDVPVFZlQldGa3BHNUZVSmo0ZXpFaWto?=
 =?utf-8?B?M3lMZ0l1UzVvYjQ0V3lUWG95VVczbURrMC90b1pKUEJzNytlZVpRQTFRV2Ny?=
 =?utf-8?B?WlZwWnM4NWZ4dXNkOUpLQnVqUWo2RHAyR25sbzRXcXZZVzRWOWErbFBtV2tn?=
 =?utf-8?B?UVJSMkRtWWxsMzhKQ2t2aWRmWmhmbkIvaDUrRnpBT0puRHJqNVpLR1QxTGN5?=
 =?utf-8?B?NU9MTkkxRnpBKzk4RHB6MHRzRXl5NzV5R3Bpc0hvZ0tjQUxkZUN6amc4aVN1?=
 =?utf-8?B?WlFFY1RZRTBzT0pwN2tiblZKNko0SFl0NkZiODhPOCtxSGczVWorUFkzb3ZY?=
 =?utf-8?B?SldDdjU1L3FwblhzMFo1WjNqWjl1cDI1cjVralptYzRFQko0WVhTUStidndn?=
 =?utf-8?B?SVYzcDZocWpDWnVLVjB1dFZSMWhmeVUzdVVwU2M1M251YWVMQzlzeUpqOE9Y?=
 =?utf-8?B?M3Q5Sk56OXNCYThGNDZBOGdUdHhCUFkwaTVCOVkrRU5kSFZOa2FGL0tDQ2N1?=
 =?utf-8?B?eUdtUEYzV3NRZmxLZ0tNelNucXNPTUdXUlVwMG0xYnJ3ejRxSVZyNXVoQkdE?=
 =?utf-8?B?Ly9TNGU3ay9XZzdjVVhvaE1mTmI5UUE1Y3U1MVlkNlpXTG1TMldzUGZaMUk1?=
 =?utf-8?B?dlFaY0xhaGFncnIxVlV0THljdEZFRldSczFjN2FLeEgrbDN3UnRzdDBJcnV1?=
 =?utf-8?B?NkNWZ1dmT1RKcW0raE1iQVl1dU43OHppRkRKZWlldTRkWCtEWjhhS1pZaG8v?=
 =?utf-8?B?d1hsbThvNGtEWHNpcUZwQ1IrMnFISWpHQ2xsOVRKYmtHS0xWNEZOTlI2M0Zs?=
 =?utf-8?B?dk1oRFNFT0RKM05YWlZyOGNYNEtubmI5NFppVlNSbDVGZndqWlZHKzFuaFV6?=
 =?utf-8?B?ckp1Ny9YVFB6RGw0MkUrcUJpT2NHUE1YMkp1RmJ5cEYvczgvTnAvSUFNRkd5?=
 =?utf-8?B?cTNINGdpdUIwQlJMSmpET3dhQUhsK2N4TExVNEdrOEJMNHZ2ckhpY3F3U2s0?=
 =?utf-8?B?L0t0SGxUcGkvU1A4T3puR3VzUU5ZMlZHaUZVRVo1TDBneG9OZkNKY1RWaHpz?=
 =?utf-8?B?WjBWcHVNM2YvQ2o3bzIvUkNpRTArN0JMdDlFcGlLWUwxSmdVSTI0ZW5EMG1V?=
 =?utf-8?B?RFNHNDVISkV5SjRPWWxXM2pXbmFNYkNVRHpEazh3akNRbGczR0ZNalFiUFNa?=
 =?utf-8?B?dGpXS1Z1RzkxWWRWaDBvdUFJekRMOE9JS0xVa3VBcVBBZk1FdVNpZzF0S0M0?=
 =?utf-8?B?WGRJQW5xODVndlNDVUhhTVZGTmIxcEJoWjlHOFNLZ1liUGxFRENQYS9jQ2NC?=
 =?utf-8?B?Ym1wcjJxVTdkQ3IxdEtTSFp1OHRnM3NvcEpxd1JWaVJ3UVBrT2h1WUphVXM5?=
 =?utf-8?B?YWNtc0YvOFVZWk1DMkR0anNwcDVzZlNZa2F4OUc1akN3a0hrTk02aEU4UHA3?=
 =?utf-8?B?MVhlMUs1OVA1dEJoQ0ticnpYWW5sRGFjQjNGSzVCOUFVODdQWWNrMkdZeWhj?=
 =?utf-8?B?MmNHbGJEQzl2bGQzV2hLQWk3TUtQUWEvVGJsdlIvMi9Ob000eEFSM3lKWm5N?=
 =?utf-8?B?VlY4Vmlsc3FRZ2JaNG40d0RMa2lXM0l0OFV3c2FXYXM1Qnl3cGJkR3J1MWFh?=
 =?utf-8?Q?WvI0QQ4vNXQuZ1T9Ar/jisxyX?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 712ff264-d70d-4b8c-f133-08da694f6fed
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 06:25:12.9731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UY93sZueJoChmwFnfM4yn5sydYyVfg4lKZv+4ZYOpDaf1qHo+qFxmY6khpBPoBPmeSXgWUU+vHOGemnHL74X8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR03MB6650
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
 drivers/net/usb/cdc_ncm.c | 23 +++++++++++++++++++++++
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

