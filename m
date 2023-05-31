Return-Path: <netdev+bounces-6809-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08CE771842A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:05:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3E03281486
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B84B515487;
	Wed, 31 May 2023 14:05:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D441429C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:05:34 +0000 (UTC)
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on20619.outbound.protection.outlook.com [IPv6:2a01:111:f403:7010::619])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24F01731;
	Wed, 31 May 2023 07:05:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bg+UhCcOc82i+Kb609YjWVWmIwRqXVq6wEab9L8oWOyvm/RVoRC0ropgwB1WRt1TEGz6iCVYqcc9mhNYWxLYCRu3d9a5Tup7VdVwn04P1rGnWKXBL6SoGz2vsiO0+ebWNJiYhUUtPVBX1sVYj4zwuwm2bLaUlmEclQNEceJsZTWbim8y2Ms47ErPgYddhLN1TCv6rCWvzLYp72VvOFalLuNhteFjjqlI+pA5ZyBLNmbYISXoJPP9MihEyz6BnDQq9XbBhd9omimoNaBWIxwYKtfBtXjg0gMgey/Uaq3DTJGUw129HUU2z37tcADRt2jFkJyLf+KYEzoNvFIYM/By4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sX73XHr2LGtwdekY6ekMinY5QphYUEzpwxH9IFyGblw=;
 b=W+BqrYG8vZmNAkRgZ7iVA6rWthMtOTDN+i53lxZ2EgEwvNQ5EuJxOEhNF6k2HNIoAfeBluSSkRUhtVFZx6scwwpmpuufUrLcbmleWO87laA/pKH4OTGO1noVw3O+oq2qGyx38DjqR4No2oNbCUvs++pb98eP1bQtBb8q84VSY+USZ2Um4TCHyf7+0MjJzR+jMy0xV5HVKhOlaCEkeFn1oWGGFIOOl2dz4MBhz/h7qGjMPIgARU341SCh2vqPmwG0yRf/meCQscW8yXgCyfOtgl3jkjsGdz1nQ06uvq5DTS0QHq1tDJzBikGmokOYSvXHAO9aVhl9U5tw/QofQZ9CFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sord.co.jp; dmarc=pass action=none header.from=sord.co.jp;
 dkim=pass header.d=sord.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sordcorp.onmicrosoft.com; s=selector2-sordcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sX73XHr2LGtwdekY6ekMinY5QphYUEzpwxH9IFyGblw=;
 b=ShdMMuJo4Nngb1TGxWno9uw/B9bGVgTIibl3tTDHQO0u3URvE33S9qJHhFv2PowOz60+fDw4UrnZnLyQfCN9xXheb781JkoyxrA0o5Jgcf9akWy7zpyfvJ3nO0APrgUOV1GjUNMvSrSWFNyxTrkqB4KiQn+R0JLd3Cg2Mscqw80=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sord.co.jp;
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com (2603:1096:604:13c::13)
 by OSZPR01MB8138.jpnprd01.prod.outlook.com (2603:1096:604:1a7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 13:58:10 +0000
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e]) by OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e%2]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 13:58:10 +0000
Message-ID: <4a3728d1-86ed-bf1b-81cd-bdd2f274609d@sord.co.jp>
Date: Wed, 31 May 2023 22:58:08 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
To: netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
 Alexandru Tachici <alexandru.tachici@analog.com>,
 Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Horatiu Vultur <horatiu.vultur@microchip.com>
Content-Language: en-US
Subject: [PATCH net-next v2 2/2] net: phy: adin: add support for inverting the
 link status output signal
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:404:56::14) To OSZPR01MB7049.jpnprd01.prod.outlook.com
 (2603:1096:604:13c::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB7049:EE_|OSZPR01MB8138:EE_
X-MS-Office365-Filtering-Correlation-Id: c7b0ba84-fedd-4a1e-5e30-08db61df1195
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TMcefUMUzAbWxh5a0d6q8KRbkUGwb3b6JpCYp3gTovd0BMVtNQqD9iPYkDOgSVxTBNbvgtwtUIXqCl8v5kj69tSwiMVxHJIQd1u+jWw6vSslJMlwTh6aqmdvNOxP6LaQqbA22Xm20KPm515qBT/J1NA3c0P6fRSRE2tQjfV93C2uDGg4iWGqpvYiQSxSggqwlN1GtAFCLnkVWr00sJbqU6ljKCOQr3KLEv/hCfVL1vLvPRqtXq0+eYOXl/7Kpk/0/FOZulMDoH1ZuJFPwCPE0znFX7W7m9k9td2xb5u6k8EIXeQEGQtLpKDcQM8VrrHnI9O+wjt1DrwHqF1eFfwUquZq3L0BkuoGy7vRuRcINJPEP0vqL4wjFdyuwkLvoSoEbK7OS9ab+iVGvyzwrSpYnGCVknHMgPf7jXCwSqXtShAT4/tkqSHm5O4V8bAL0/dHpIYUJu4p9ASgzufquMnh959RgZYvOBaTjs/NYZsyLQRxSmzIWfbP1UPlHHw/OqbDxPGAxU3z6ernd8/P8oojAhX/AmaFyim2oZ8Q4m6gVF4bnBn2ZFkme6BBvc8qUxAD1ujQthSw5xTtU2qKZfszwFGpduxqj/n7kRvQkHTNjBg24WAqastFiqv/MJJ2xWthnA2kToh/NUKdg3ff8sxxDg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7049.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39850400004)(346002)(396003)(366004)(136003)(451199021)(38100700002)(41300700001)(31686004)(6512007)(6506007)(186003)(2616005)(26005)(6486002)(478600001)(8676002)(54906003)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(8936002)(44832011)(7416002)(86362001)(2906002)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGEzTk9McHlOcXRwOHFqU0FEdi9FamFmMzl1aTYvU3hsYjFvYXhsZFhjRmMy?=
 =?utf-8?B?R2p4Z2RNeENUbEpBcitVMVNUWFlLb3RxWjEvMFl1UWlxU2JTZGVGVStWTmQz?=
 =?utf-8?B?Y0RiM3dycUdKbmJ0eXZhTVlLanZTZkxveDZyS2poaloyOFVKQUt0VDdlRkVk?=
 =?utf-8?B?c2R1d3BFanpVbXBxT3dnZ3FDOC9WYWNlbU1xQXo2Q3JMUXQxeEovZHN4Rit2?=
 =?utf-8?B?L0syL3lCT25TT2RROEdocmxzN3NsRHBDamZvVzhad0pIeTBDVHoxTE56L0dG?=
 =?utf-8?B?WkNwUzVzdHM2K3NpM3lBVjhZODI1N1lwSUo3WlI3VXZXR1IzWjRzcWZ0T0xE?=
 =?utf-8?B?ZnNwN1Fwek1Zd1NlR1FMOHVTN0U0TVF3MEVpMU5uZ0RHck1yVlRKR0VlTXRt?=
 =?utf-8?B?QXR5bldON05NVjBodHRZTklQQXdIYjIwU0V4OUNub1JhblRlaTNoZ0JFeTly?=
 =?utf-8?B?ZnRESW5mY2JoK3Z1ZXNVYkx5ay9STHB1eTMrWU5Wa1ZNRzVHSjBIQ2hiN0gy?=
 =?utf-8?B?aUlIVmhRSHdCVGRQbEUxVmF4a2wwZHFaQTkxU1htT2hER2VtRnVqdll0Z3Q5?=
 =?utf-8?B?K0dObEkvZGVTdmEySCtPVTZTY05JUnFVR2dDMGVTRDh0RXNSZk4vTEJXRXJq?=
 =?utf-8?B?WTRWeGpqNXVQWU16SHlRbk9USWRObkN5RVhVZVg2SmZwRFNrMzJUNWMya0Zy?=
 =?utf-8?B?MDJseWNHbk1OUi9VZ2JtVnJDbWZkcDkrb3BtY2ZMdlF6VTlwS1FPdjdrNTIx?=
 =?utf-8?B?ekdsNmc3SWtJVVRxM3M3RU85TWJJQk9oLy9UQ2dLbXZ4em9qMVdyWkpRUnJm?=
 =?utf-8?B?VWdoY0xwL1NoUXJua0lqWG43NUtVcHBMayttQUtKMnRaM3lOTHRscFNuemhl?=
 =?utf-8?B?ZmxoK1Z1ZnFkVG51bXNPRDhuWTh5MllNa1ZmR3N3U1BQb0x2R2tvZHFiMGUz?=
 =?utf-8?B?Q21JWklESVFXaG1Sd1Q1MnJDL0pQQzdiTE1KWlJ6Sy9pcEdFM2RDaThjd2wr?=
 =?utf-8?B?dFRTWFVqM2ZxT2Y1WVJTS0hLbGRjTFh3L2hUV0F3dGZCUjNSN2hhTUMrSzRK?=
 =?utf-8?B?bHRjYUkyVitCNnVhK0RmWG9wQWFFSGY4eXRiVTZFcWNMNmpFZENCRjh1V1dz?=
 =?utf-8?B?VEVvcFBsMUlaOTJXWWhpblZRdElreE9XVlhKd3o2a2Y5azhmSFhhSXpKVmRz?=
 =?utf-8?B?UW0ycG94MGV1K09NeUhTOFdYdzk5ekxnMEgrZzUwbTZZdkhtenlKZHhoMGVY?=
 =?utf-8?B?WTBXVmhQY21sVkVqTUZhUmlOWWpYVkJzaWpPWTU3Vnc0ZUlrWG82N2dBTS9p?=
 =?utf-8?B?M1hSMEZvd0g2RDFJR3pzLzhnTHkybzhwT2hHUElEUkFicExINzdTVEJVbWNU?=
 =?utf-8?B?U1o3QitsVWZPUG9FckJqcUt0YU5aZjlXK2xyaW9WM1FjTU5jK1RnQnBMTGps?=
 =?utf-8?B?K2tpellvTU5zS2FiWkVDUWYwd1VPR2J5YTB3a3o2SE4xWFJ1NFFiR2I2UTVN?=
 =?utf-8?B?bi9NOXZYY2s2dU9hY2tmVnhvbzUyd2xkTCt2eXhTdjl6NE5rTTZBbzlMNVFs?=
 =?utf-8?B?MklEQnVjMU5WVlpGd1dvaW90cmtidUptdFlaUWcwRWQ3WnBOcDh0Yi9DQjNy?=
 =?utf-8?B?WlZ6dEF2N2dnaUptdlhUd3B6MjJjWUsxWURxczU3K2I0WnN2dHY4bFhYQ2dk?=
 =?utf-8?B?SWZtWDM4Q0dwU3dXSGRseDlLRDJYc05lVm1lRkhldXlYNHpFbndPRHVkQ25U?=
 =?utf-8?B?NjRmQmp6OWdXZHk0bnM0SkZ5R3NwWWh3eTV2cHBlbUYwY0FiUm84MjNxQTdR?=
 =?utf-8?B?UyszZnd0NEdFUXRyd0c1SDB2NkswM2h4RW1iUWROL3NuRkwxODZPM1FIWTJx?=
 =?utf-8?B?Tm41TWxVN3ZQbkIzeW96YVlXS0hOOWFsakNieG42SzFzWkxQYlkyZlVRSm80?=
 =?utf-8?B?WThIN3BZMHJjdVV0U3EvblVGRGxVdmVEZkJXaXU0bXJxbFFhQjZjUTZXY3h4?=
 =?utf-8?B?QWY1U1RWSG14OEtPWm9PUDdIOG5vMWFUNFBBQUtPTUF5eWc1RGF3NjJHdFNU?=
 =?utf-8?B?ajBRZVNHUzd5SVZOdUNQZkN0djNYdURVcnJIQ0xJdkdicU12QXV1R3hJY0Vu?=
 =?utf-8?B?Tmt3My9VYkxGeXVxMFl5ZStUbWlWUUlhS3NNOXA4allPelRkRFUxa1pIcmFx?=
 =?utf-8?B?NXc9PQ==?=
X-OriginatorOrg: sord.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b0ba84-fedd-4a1e-5e30-08db61df1195
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7049.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 13:58:10.4378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: cf867293-59a2-46d0-8328-dfdea9397b80
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /0VsBGBkclJKvid2IVxuByjOCdb4vF/XJ1GNlAn3cHN7P29shaVek1/uqlk8BrAQKslUFPfvK4kzNAxh+nniSX7KOm89MK357CHQAgVCXgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB8138
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The ADIN1200/ADIN1300 supports inverting the link status output signal
on the LINK_ST pin.

Add support for selecting this feature via device-tree properties.

Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/adin.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 134637584a83..331f9574328f 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -140,6 +140,9 @@
 #define ADIN1300_RMII_20_BITS			0x0004
 #define ADIN1300_RMII_24_BITS			0x0005
 
+#define ADIN1300_GE_LNK_STAT_INV_REG		0xff3c
+#define   ADIN1300_GE_LNK_STAT_INV_EN		BIT(0)
+
 /**
  * struct adin_cfg_reg_map - map a config value to aregister value
  * @cfg:	value in device configuration
@@ -495,6 +498,15 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	if (device_property_read_bool(&phydev->mdio.dev,
+				      "adi,link-stat-inv")) {
+		rc = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+				      ADIN1300_GE_LNK_STAT_INV_REG,
+				      ADIN1300_GE_LNK_STAT_INV_EN);
+		if (rc < 0)
+			return rc;
+	}
+
 	phydev_dbg(phydev, "PHY is using mode '%s'\n",
 		   phy_modes(phydev->interface));
 
-- 
2.30.2


