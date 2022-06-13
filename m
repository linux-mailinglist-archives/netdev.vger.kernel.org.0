Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE0D548186
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 10:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiFMIED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 04:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239525AbiFMIDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 04:03:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF3162CE
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 01:03:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGLmlcUnOQ8DTNj5+n4y+oV4OB5RXrtTYLbCA/ORiJeuTp6dL3eoVb8dLW3M3gmVd1kUbGtg47GEYAAxHj2bE0lKHcg0VC0uB5EvACPaTN+qt6rv9/7eBZvHcfULkbWjI/JuJ9F7+waRVqvLb58M9Dx3iCBXyPrJJP+MxNl5wcf/i58eBAKWx78Pj3gL0Hwt8ismCCm8q2FPbVnQNlSw/u3UwwPS07uvEevXH2VJA1Go2N/7nX0gvJDlqZiEj6aheAyfsf2qPZ0lRT4Q8veF2wHOd/dM+AR0hR79GAhneQ6VUSwION6TupgnKAy74FtQZaU72hVFPK/rs8FVQbNmLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEkIaNjEzGh0MJXfFULTvTKG6HLWjiqbiNpsBJJ7ygU=;
 b=DSonnbG4wNk3QHsdSdnpWWG4trhl1MuQ6KrxShVpiIUoVyZu7a02Z9atTAPQFA4httEOFxDux0AcXE+ybPhsXVtuRr+p+TZ7tNKLlNYlN6TNPZexyGYqC9LqMN94RV9UCfYnC7zNdL882LeShIrsBaCzkqGIbxSWSi+6sRoclNU0j51d/iKxsX1mfXC+vEON49HUXiKhWTVMx9dSrmK3ukDOPP8VS2zLUj5Xof+gjMkMCc1dIxHLJya0kDc+fmhlE8AhGwm57nbS4b6br1UG8EZ94L4eXmlwR4rRLYeu3e7vt5+HgvYslSzPvq6soDd8S9NH8ycezEwP+yYerPa2dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEkIaNjEzGh0MJXfFULTvTKG6HLWjiqbiNpsBJJ7ygU=;
 b=klPXXuNQ6XCIESHdDkv5AAqGxf7xB/AN/0HP5YOCtqOKxjgiWpOyTbuAjzHowMpGg87lq0J8gSd+DDzzp47lscbzYDaB+72tO8iCBsC74AxDD4bunKDJUi4ZraOjsn7MDC4V/7qq2yDu0u+WrDUOQm47lLjEUuoT+7P7kRDgufE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by PH0PR03MB5765.namprd03.prod.outlook.com (2603:10b6:510:40::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Mon, 13 Jun
 2022 08:03:09 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%5]) with mapi id 15.20.5332.013; Mon, 13 Jun 2022
 08:03:09 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     oliver@neukum.org, ppd-posix@synaptics.com
Subject: [PATCH 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices
Date:   Mon, 13 Jun 2022 10:02:34 +0200
Message-Id: <20220613080235.15724-2-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613080235.15724-1-lukasz.spintzyk@synaptics.com>
References: <20220613080235.15724-1-lukasz.spintzyk@synaptics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BEXP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::15)
 To SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e98c154-07bd-4cec-647b-08da4d1326cd
X-MS-TrafficTypeDiagnostic: PH0PR03MB5765:EE_
X-Microsoft-Antispam-PRVS: <PH0PR03MB576543611A99355AD10C568FE1AB9@PH0PR03MB5765.namprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ve9tqE7A3pGfqosyEFK8J3bH/afhpmPIRWALRe9eBqlzYd1F5L+O8hIEV0vYYKhWQc/TNzr8hzNUykrRcrweXOz4ovFV9nu6UXJhyBjsVyyJnzQp89TT2a1yxHJBLRx131DZf7/dC+OzHYqVmUWYwXgmf4e0Yb8cVmrr11oxIdZsreuetVO32cu5VR1XmInx6hM89/mY0k1Ar1HW0j4LsOO+Bm6dcCx6t+8fOsmDRoE/L3l6YoZavHMHVFJx42E3wNfyTCKBnK6ocDEfkMYnpHMU9gva7UBPPjnnNGa8v+5FbKk3NZZna5klnF7Yg1guFrRJ9Zj7cpzVMKiATE7sDVJbqifIDxemDeH0UQYgHumVl3i9+12bxiMVlNyfSVzRRuOuwNwXXlflN+DHoXquZXSY9EtknLcZyKBBmLFyrmyZw7WbjO2D/Y1uYtqocD9rAoYl3SdKwwbxzmQXC0Qbw5qAnm1wWRcJokiKDI58MEG8FthBgA+NvlwOZY+wgTgYqiwsh+v4IyAfQgsNjPIAxvk3qVdznAHUUwXwEOAqpe3d23D3Hh2ZuVoLujUsuM647UCtQHUDwwPdtDsmb50rwMYhOHQS/3jX52v7j6r+pRhXd8vmgwRq9Mg5YNsUbO0HelLghZnQ2TDbxCoMwCVk2H71qJdEggXkbxDcN4idmzo8TN7r915sIsBvifuLRxZqOpmqsr3lsihh1Fs2C3XxcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(19627235002)(36756003)(316002)(83380400001)(186003)(2616005)(107886003)(1076003)(5660300002)(6916009)(6486002)(4326008)(66946007)(8676002)(66556008)(66476007)(2906002)(6666004)(8936002)(52116002)(38350700002)(508600001)(6506007)(38100700002)(26005)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2JQellVRDBqaTd1OHl2UHJ6MWpQK1BWRjNjRzJHd3F4dVlFTGhMaWNNWEFF?=
 =?utf-8?B?T1dBaVJFMnNBVmozYTc5UWxJNFdXQ3RiSVRaakMvWjVxWVlXMTl5M3NzQ08w?=
 =?utf-8?B?T3Y5NEdqUmY1UXdEWGZ2ckppWnpKOUNpeGo5M2N1UytWUmdvaGtUa3J6RjVS?=
 =?utf-8?B?cmUvczZTYk5aL0JHRDdMOGhmQXd4OHoxQ0FkZkJsTWpvb1hVYU5ucmRiTGh4?=
 =?utf-8?B?N0VFcUNLdmpMOWRxRVE2WmZZZGY1ZTl0MFhzdmhCYUxzZVRxTDVNU2grRFFu?=
 =?utf-8?B?bTJLeFN0djRNTy9uVnFnK01vRFNIQUJJajRmOW1DZ1lsS2I0S1phNkJEMTNm?=
 =?utf-8?B?Nko2U3lFZE1MWGF6MlVZbWxIeXpqaUFUQTQwdGJmdXJab29HWDRXRDlmaGRM?=
 =?utf-8?B?TjdaT1J2OFRrQnc3azJYTlFJazJYRzZON0l4TGxHMGNoRXF6d0R6c3p2L3Fr?=
 =?utf-8?B?djE1a0FMN2ljOFRuZWg5dVZFYlhRZU1kSGpJNUdFc3BLTzVTSkVJeWNVcWlD?=
 =?utf-8?B?M0F0b1A3TEhXVzl1Ym5RWldENkpsUm9MVlQ4Z2FmOE1hazJXUERkci9KUmlH?=
 =?utf-8?B?NzZwMGk3VnJhYS94S2pJbHJnSkE1OU5La1ZEOUthaytDcU43a0dPaC9tWmt2?=
 =?utf-8?B?U0VzN0hWNldFSXU3TkhDRUhlZHZBQjhZazZnbFc0VU1ySGJ5Q3J0enFEL3h3?=
 =?utf-8?B?dDU3bzdtVjJOTklveFJzejE0WFhCN2FhKzBQQU9LaW5kZlQzcXNKcVJibU5F?=
 =?utf-8?B?WmEray9XOGZmVTExdXB4YWVyUU56eHF0dEZobnU0OHBZc2pPTkxCOUJJNmd4?=
 =?utf-8?B?SVQzcER4Nm1hakZBYWE2OHBaRVI0M1pyQU9yZlplYWVVOFlhSml3SUNCT0JH?=
 =?utf-8?B?dTI2ekJjaTR5M0NmODBadlpFaVFneTBvY09aemFXUTJiekR2UHhIOGg4MU9L?=
 =?utf-8?B?SW1yYXU4SGJBTlh1bkVGYXQxZmR6WmVVREg2Y2MzLythMFYzN09XVjZWYUQz?=
 =?utf-8?B?L3lOWSs2STdIWVBiWUlZR25ZKzhTUzRHUGJUcEV3YzlXYlNJdFdXQ3NwS3J5?=
 =?utf-8?B?WTljRVl4STBTOHFWekJwMnFDckZEZ0VXZTRUVE8vT1k0Q01xVTE0NXduejl1?=
 =?utf-8?B?OHNDWVRNN1J3a0d4UzRLMS9NcFhWWEtSc2kwaGZ2KzlIWFJCbDdlVE10WXBN?=
 =?utf-8?B?SUkxblFLQTI0d2Z0TGpRcnh4TmdyMWlTdDd0U1lDVk1iemx4TGViblNCZTFG?=
 =?utf-8?B?OWJSOGlmWit1WVVaRlJOcVk0NmxTRldzU2h0QVJvSWdrRWlFWjZjdmg1QjJM?=
 =?utf-8?B?ckczMnVjYlptRis3Q2ZMNEY0VnFQZENHSVFNOHNFRWVJY01jRVg2VHRFSWFq?=
 =?utf-8?B?Y3phd2VHdW5kbUdWcmxFMG0vVG02ekh5SzBHMkh0NHBhSHl0L1lkOVQwYWZz?=
 =?utf-8?B?cTlZV0gwMG1ZR3daeFlKZUF5YzdMeXNyemJOcWMwTTkvY1ViQ2YzeEVQNElk?=
 =?utf-8?B?Zk8zTTNIdHBjSDJ3ckdMZUp1Mnl4eEIzWGxXWWc5RW1ucitMOUk5dlljWjRl?=
 =?utf-8?B?cXJaWWtHTEZwU0RtNWFEeVlmT2VBZGZFVmdSS2RRTFUwNmRzaS9nQXdVeC8r?=
 =?utf-8?B?U2tUQUpKNU9HdmNkaWNlR1l0WTI1L3Q3ZHpmUkQyejBSLy9qSmQ3N3N0aE90?=
 =?utf-8?B?a3NVNVNpNlBMV29heWF0N0RSVlRYdS9LSmU0NDNDOUswTktPUzNQNWR3Qm9B?=
 =?utf-8?B?RlBsbzNBMW1uemt4NEVSeW50QVcvM0FJUk52RWM1b0dSQm0yVEtUN0h0ejha?=
 =?utf-8?B?UXBXYnU0SUxOcXU5NEU1K1JkY1ZIeTY2QjY3b2JuWm44SjlndlZncExuNFJo?=
 =?utf-8?B?aHRNeFNnd1RnTGM2VEhRMXRNUHhQcURUL1JGZ2ZlK25EUnJ6ZHRUUVBEQ0NY?=
 =?utf-8?B?ZTNmSWhwWUN0bnhsYzlMU1BWLzJvRlFkK0ZnZDlCUHVNOEhWRk5nb2N3MmlJ?=
 =?utf-8?B?V0xSMWxQZWcrdy9UUE9KZGhOMndpdkUyclVDM0V3Z2NpenVGUVo5RnljaXkx?=
 =?utf-8?B?QVhuMDdTaXhtQmVrSTRKanlhZXBmT25VcWhTSC82Q2FkVXluWUNwZVY1bi83?=
 =?utf-8?B?STZLaExxUnFKVEpxSlFUV3hScEh0Uk56VlVRVEV1SjRWU0o3M3ZZcGtOWGRX?=
 =?utf-8?B?b1ZLQktvdytycVNKQVJqR0pMVlFyMDVuSmRYVnhhblJ0ZjhkV3JDSnYzVzlX?=
 =?utf-8?B?dW9oSkFVZjlUQ0h4ekNDc2lVRmVyVmVrREZqajRoVzJlWXpCYVBvRDYxZVg3?=
 =?utf-8?B?Mkdwc2dFcy9ER1pncjBYQlc3RTBYc1lOdnR0cklJcVdkc2ZaSWUzdz09?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e98c154-07bd-4cec-647b-08da4d1326cd
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 08:03:09.3774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gz6WVI+6SZ0pKIKqou0y9fLBc23D86jSKCEreBKoSgmpq2K3c9cLYxY1YaiAnd1XVVOx0uLayOKOizHmXyWwRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB5765
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

