Return-Path: <netdev+bounces-6244-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D9D7154F5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F036428108C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBFA86AAC;
	Tue, 30 May 2023 05:36:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9B763DE
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:36:54 +0000 (UTC)
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2080.outbound.protection.outlook.com [40.107.114.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C798EC;
	Mon, 29 May 2023 22:36:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbIoUl4T3Ld3/G/zC4s2OpHwVLaQIEcfrXV42KY3yHJNlAKhvJtKX8dazQwhV/10xFL8YF/5WqtoBijSII2NqTvlS0M/e2X1A8ZaYuVdV0/q6XHKatXuhF+faITA6duQutP7PwseM/8sfgsIXuR11GZmlmQ4OCm1I7u8losmeTWrznsBb22uEGkt4Au2cheWC/vS/vIHBWH0hYrJ2gFy48jceWgKotwjvyKlDVDe3BN6Rv3yayMM2HU+0XVHo+jiQaJ/EdjONzvaIyii8GtodwJvHDDXr4YvgkT39qJTJQyWSpnoDwQjba6soMVznYcGva0HePClXMdKsKEDAC4aIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7lwWTYyV8XWKnqgyhnARwTSVKqZUcSHxhGXhWq3ues=;
 b=gDiZRe5BkefeQBOrodq4mqj/OrFTqP7J9LSolIImAgxXF2fx8veacqJvlodHR4YOtXjWtDMCw+LmycC4MdWNuuLPplwp6YIQgvMGcS9GvCjaYz3k4f61xuUacF/Yu2My5595y1lVz/bIFqmGK6Q2C7LUfv2NRXKpT4qcnUVCWqDVxE4PjgPEVpf45+9w2jHgpSWogtA5GWUNuHs1lpVnhd4rfSxeXYumYSP5lZ0olAMYc0vWfb9dlQGh2r0nFG0uy2sX6l0KIaI0jc+UkGshLhJ1f65p36zEUXhdhVek/nvbtfAy982aNDHHmxcH46f2mAVqrXuV/flSKqjz4tzJPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sord.co.jp; dmarc=pass action=none header.from=sord.co.jp;
 dkim=pass header.d=sord.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sordcorp.onmicrosoft.com; s=selector2-sordcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7lwWTYyV8XWKnqgyhnARwTSVKqZUcSHxhGXhWq3ues=;
 b=uJWzzUm90TG2mjfgdRdXFHHMmkR59/EAVM4pORfTu21lJxB5tQZSLMppiug60DwvQYjE2SSwfng+7ZnO7c7KOlIkUN0AZJ2hwoMM1+MUJpS3PHxF/bgzacx7UoFaz5WaKr+gVKizLiPkxdTXLnoSxhSVwOGPxHczUR4g278dQg8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sord.co.jp;
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com (2603:1096:604:13c::13)
 by TYWPR01MB11894.jpnprd01.prod.outlook.com (2603:1096:400:3fc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 05:36:51 +0000
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e]) by OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e%2]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 05:36:51 +0000
Message-ID: <7eedd83d-7d87-ba3e-7a38-990f05a44579@sord.co.jp>
Date: Tue, 30 May 2023 14:36:49 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To: netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
 Alexandru Tachici <alexandru.tachici@analog.com>
From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Subject: [PATCH net-next 2/2] net: phy: adin: add support for inverting the
 link status output signal
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0036.jpnprd01.prod.outlook.com
 (2603:1096:405:1::24) To OSZPR01MB7049.jpnprd01.prod.outlook.com
 (2603:1096:604:13c::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB7049:EE_|TYWPR01MB11894:EE_
X-MS-Office365-Filtering-Correlation-Id: 27f8a8ab-b09f-4c67-429d-08db60cfde75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BP5z0rFOctRpPsZaTVfd1jw4dbz1wJ35ov5YGPkTAk+fRR3hOAfqBnWjNgZIGfwkfPZUcMpJLwG5hPGR+WBlLDioE32g8YryH06p6pECIw9HQYGCX+aDzoVRRTts02sAD8UcpD6oadcXeYk6XCNhZJgJVEVhFJ8FKboFDXCPRJWZHNRi5XmMAmSzrYOabZY1xpA/N/JIqX2FBGvF0/EgfWyQcKUl4lf27GFogONyu0YW8XRystbDMLRBm+6K4zyQTf6+znZd3FsZFchqr+mx5cn2ogbsebDfrHnba+Fh8YuOiTWgDDIzgskucEy5FM6aCpLOlSu9Bn1gQ+9LCb5729qFdvL7EF8jW0hdS5C0E0v3drmEL7yHHtktgKVHG6Mx1XvI3gXJS7ETQ/4kd1+6gSt2+EXIB58Z8GaqNfVMByDi6dbjlfLg+uXFeq57SlWdp25DEG6ulQH+vm5UP3vmqNwOdSnMqaaADgxx/D5PCnX5Ax7HrROKlhbLfldM09q48fJmBZ7PZgF7nSiUXZk3gxi+BFoMz6hL2KxzziXrfvgq/aogJGlt1VIy7Hx05kcHbU7zCdeFmOcBe1WiCZVDjJ+wXj3wYrSYSUNBjQSlGawWt5UXCTVy8YKqVmi9+6JwSe9RT60mlxRWm0R6HMRgzw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7049.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(366004)(39850400004)(451199021)(478600001)(8676002)(8936002)(54906003)(41300700001)(5660300002)(86362001)(6486002)(316002)(31686004)(4326008)(66476007)(66556008)(66946007)(6512007)(44832011)(31696002)(6506007)(26005)(186003)(2616005)(2906002)(36756003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2IrKzg3STVwMEd4QjhuRVAvOUFwNXg2YmxOWm53MnVIQWtydmd4aE5HUUJo?=
 =?utf-8?B?K2d0WTdWWG5rdmtUY01Fa2VsSHpaSHgzUlpWNHF1cTNMbVp1YnIvY0ZCSlBr?=
 =?utf-8?B?US9IOWc4QlovY01uekpzTU5KYzlLT1ZUb2lSSzhXbW9rTUxyWE5LUnpzNmdk?=
 =?utf-8?B?UTk3OTc3cU5BZExLTTFjWkUwRFZSOXVUYUpBV0JBN2Y0QlhmZWZVRk1yTG1m?=
 =?utf-8?B?Q1VMdWRyazE3RmJhRi9yR0E4VEZJL0Vna0dxMDZKZzhaK2F2a0FtamtQdmVM?=
 =?utf-8?B?Y3hrT3BGbnFtWFVmQjVPTy90WWFKL3o1UCt6UTZON2RpNDVaVUxyb0EwK3FF?=
 =?utf-8?B?UzJFcC8zdUFvdlYyMHNXUXc2eThOMnJkQTF4bVB2WEF5eGlSZGxZTFZjM3ZU?=
 =?utf-8?B?SkRzRG42dlYwaDk4ckFQWXV3NXlwVWZROU5UL3dRTjZzQ0JqSi9ZakZvcE9y?=
 =?utf-8?B?TmdvYkpTL3BqNkdETzFWemY2RnhTVzlsQ1h1M2lsaW5jclIxU3BScmJ5bkVs?=
 =?utf-8?B?dTVaQzkrZ2czR04wNlJYTFAvdFFDZ3JtT0tKSDVucG1IZ3Q5L1VuWmx1M0pI?=
 =?utf-8?B?VFRYYnBiU3MzUGl6azVRa0YzMER4UWFNMFF6ZmxHQTlEVTZwZTNJZThXbE1o?=
 =?utf-8?B?Y2NpL3pOUGJqYnY5SUNSSm9VM2pEeGYyRG9NREdyWkg4M0dldVFoUXBEbEQz?=
 =?utf-8?B?YThPY1ZsVVdxbjNzWWJJK0xkYUhER0RKV1ZYWDJITmtWSzdsM0VIR01yYmJp?=
 =?utf-8?B?bEdoMVViYnplS0Exc0N6U2RMNFQ0c0hNcmJObnR5bkh5V3AzSUhmVC9VRDVn?=
 =?utf-8?B?YXJ0QVFtTFFoSjRmaHJLTDIzTzJIWmxSQTltTlY2Y1c2b1IwQVB2UE5LZEdy?=
 =?utf-8?B?Nk0xQmtUeUFtbXZIYnA0MUM3U3dqWGVxQXhRTzhyaklCeERvZ3pLOWVQTFNZ?=
 =?utf-8?B?OXFLUTdDTDBBdlNnV29hVDVNOEJxN2x6eDFEM0twTTNGWHhKZ2tqWXJiaWJO?=
 =?utf-8?B?cjZtVDZsNkJuWWpmMzdpc092UDBrYXNXQ1B4Z0dYSjVGQ1lRaG9Sa201dEdi?=
 =?utf-8?B?bWt0a2txVjc4WU1GNnUvbk9BUGJ0NHFyVW16Q1M3YWF0NXdLWU1HZm1GL0FX?=
 =?utf-8?B?bzdBQ2JNR1ZxUzhJOWhUbUtvNndYTmFCZjdnMTlGNGptdlNOOWl1eVdUSTJT?=
 =?utf-8?B?OXF4OThKY1dXYzJ5RkpobU0zMUdVOTlZYlVvMjZOWVdnRTZkZjFuanNzODZT?=
 =?utf-8?B?aG4zdE43bGU0L0ozMTFzS1VoaUQ2d2pYV1FoK1FDaExSY3ZyczJydEVhN1F2?=
 =?utf-8?B?VHUxc2E4RTZndW5hRnpNK2dLNmdNVndHcExubmZZVDE4ZlN0SFRTdG1XeHc4?=
 =?utf-8?B?elZ6ZHN1ZWlPOHdvdTJIeUgvRHZQQy9lMkNQUmNDczRrQld5NjB2d21qSGZY?=
 =?utf-8?B?RjNFUmhtVEtzS1JHR2NWQVdKNG52SjlST0xNZFJEdlBmekJVZ0tic1lqU1dD?=
 =?utf-8?B?VHMvY0NCcU9XajJkNCtHNUlRMXU0T1g5aUl3VlZVNk50Y3loTmJIOHJCSUZ0?=
 =?utf-8?B?bm5rN0dSUzUyR1k3VTY2S1kzRG1BOTJzVzNsUFozREdzTzRIc3BDRnNRUVAr?=
 =?utf-8?B?T05tK0ErcHpkaDR5WGtTZ2lxdkV3bWxVeWxNTGhYTDIzYlJwM2hxbzNCbkNC?=
 =?utf-8?B?V3h6NFNuZlp0YURlL094WkFkbnN2NDhaeC9Gd0toZGJwMy8yZVFZOTJuZGg1?=
 =?utf-8?B?UkRqRzNuc1BOVUJ0aUJWclZIVHBiYjU2WUxDb1UySjBsMU54NVluL1F3dksr?=
 =?utf-8?B?TXp0eXR6TnI1UlVzaEsxRVVUNmlicXpSTUVZNTVlRXdsclEzL3JDZUlKS3Y3?=
 =?utf-8?B?ZkJ5YXZkRzdVRUNQNnphbURXVzBkWEprMmllL29vQitLcHRUbnJjai92R0pS?=
 =?utf-8?B?WWlkUjVNMHF1RVdLWk8yODU2Y1ZvRDE2QUxJd29oWGpQU2xPeDRya2hqN3Nz?=
 =?utf-8?B?a1hwdDJnT3U0WHdQOVlaYk9UYTdaaHdBcVNROUVEV2RVZXloQ1J5UlZTU0Ft?=
 =?utf-8?B?eEZMUmtCRWRqOUcwcVNtOUJMZVV0bWxCcURCeVBDQlAvZW9kNTFpK0NkZ1I5?=
 =?utf-8?B?SVMxUjB1cmlVMmd6RTBkdStMb3k4Z3N3RTZ1aUtWOXUxUU9tM3l2YXhEZ0Zu?=
 =?utf-8?B?NkE9PQ==?=
X-OriginatorOrg: sord.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 27f8a8ab-b09f-4c67-429d-08db60cfde75
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7049.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 05:36:51.0625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: cf867293-59a2-46d0-8328-dfdea9397b80
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CkLAkjhanzk/lV1d3OVJL3X90E5dxLqxs1t/9yN3MU87LB+6L7JgYVcB5A6pIrW7mIAzrZXn/f8aEuHX/OIlJ0HVfVKWYAZS9mHMDX+7jm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB11894
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The ADIN1200/ADIN1300 supports inverting the link status output signal
on the LINK_ST pin.

Add support for selecting this feature via device-tree properties.

Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
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



