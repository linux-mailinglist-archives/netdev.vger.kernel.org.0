Return-Path: <netdev+bounces-8107-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACAC6722B7C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:41:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 608E6281369
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C265A22618;
	Mon,  5 Jun 2023 15:40:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03B91F93A
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:40:37 +0000 (UTC)
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846F510A;
	Mon,  5 Jun 2023 08:40:29 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
	by mx0c-0054df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3559tOme024705;
	Mon, 5 Jun 2023 11:40:08 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2172.outbound.protection.outlook.com [104.47.75.172])
	by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3r02e3gqhw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jun 2023 11:40:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4TnJustRvcet1Q3O1uovYMErJSA1YeqQlvuD9sa/WH0+NkkwcDzR+IK/q19lvs/nU6iME2HCOCXpw8ZOFxWBm3g+pL1YpJxZBMfFPObSEIKSYvx4HeyU+MQR6gtqrLFmUOQZ0M6HT6H7XxgLV4LXLucXJdj0NYapYbgoPso46ASuVskINXsTdBLUZjw/zC+xlu1OMHnwl/UpiR2xPZns2R4Y4M70JTFQVwY3dgq2DDx3qkvrEKcpZEbJ5zJFg/de58dyQoIMzmoS6MNPlswaXeUT5LX1VXvP21X9QhStLJpinxC8ZvjrWmZACpnbC6Lg4zx5ISmmKqobVgMGvmUqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CMKvmj/qor/Z4U9ywTTACd7t7rxz/O+ZcpEynFZNMDY=;
 b=ViN4vPUbdxtR5HwvWZ/Bsb1bzaw87LL4MddmPnxkb80oZKACHA0IVgpgKbnsmVLTNhAMA/LMjKGrifsIKg0h7Dh3K+ul12tY5m6mBjAV5hCTJPxZXFDQJ6F+huyYEQbHJs3qBEEZ8R/f7VrZJe7d74foy7WtkXABUhRP7nJPec0GCrqabM+fPkBf/BcfTBF968UW9ArESq8LoUoLHU7hjByxjMpBcU6rcbEb9FagMkzmIUtSyvLWymVaHCQ1d/7Ctj2syCKRjPARL5j3PG7DfTPM4CMV4Pct1u2zELgX4iAQ7gEjOcW7AiHbyvLtaZrvCC0UFvW4wAN7hJqY2vOZGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMKvmj/qor/Z4U9ywTTACd7t7rxz/O+ZcpEynFZNMDY=;
 b=y/kITPKNo7Oe1W0FVsm2tieo3JE0d4rrRKGTkK4wq3pdxpTfff37Fafuoqrl6mCiZ1guRj1o7SBgUEOSbYNapXroZeojKJ8n7bwYicJBOAUXNnnxw2qSRPfOlltPzMxE+c8t0HK55pG5qszcyPjWOHit0GrZ3MJ89wWkNrRu+JU=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT3PR01MB10571.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 15:40:06 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 15:40:06 +0000
From: Robert Hancock <robert.hancock@calian.com>
To: Woojung Huh <woojung.huh@microchip.com>, UNGLinuxDriver@microchip.com,
        Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 2/2] net: dsa: microchip: remove KSZ9477 PHY errata handling
Date: Mon,  5 Jun 2023 09:39:43 -0600
Message-Id: <20230605153943.1060444-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230605153943.1060444-1-robert.hancock@calian.com>
References: <20230605153943.1060444-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYXPR02CA0063.namprd02.prod.outlook.com
 (2603:10b6:930:cd::8) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB8838:EE_|YT3PR01MB10571:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b09b854-3316-49f3-ead5-08db65db2313
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4Bj+lOIjtW5lUSe83zmd/vCBiYrx/6PO9iiF0StPLFDYJB5Ps4KAGRIEXrcnd558CvhXzYvKZiFML99gVfVFHcFoECZk7BOGqszAKFd91w03qGpd43auN+diHjiEGh8MbpKZTN5neCqJXf6TmYwdwi+Ug/2/ISILVkEeeuj+TKv/ZcVk3sUKBcDmqZjgIhXKb0LJSsEwhZPTcRlic5ocNbxfNCqeLOQqdrYZy/yKgw84cmLuZAO/pf/Dbt5MNsn2hlET9/P7FkNKCHwC9GI0zP683v6Y+yAuU4ZYxlcbFZKh7efggaEtn92hBXNx0JJNT1FxaORKQ2cdcRI8HuGS5GjB11VZSYs7dvuvInUTBedr9cZCxNW3iQI0BTcaWC3HaJd3Y9RV8HM2ATGbB4U+wiursLQT+6D/WUR0KYuR06CxrGS4ZR7J3B87xSMG2PjtQwPPCcUrtfAlTsYhs4IM7reNZISo6Leoup9pJxF9DuZNe/9TJAsbjieZ3Ro23ztqD9QjWUVBUpMoe06cG1wcBvnCBf/ZhurUFcf76ogN7hby6BPcY2lZcqip1H1rFCCDJsAaPpdFZSs6I82G1lUvqVncrdiF2D4F5WW+UYp5dAqbvWWihjjfWvZWlLdl61BG37NpmefDL9rPNSY/d9EjOQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(366004)(346002)(39850400004)(451199021)(36756003)(2906002)(86362001)(44832011)(7416002)(5660300002)(83380400001)(6666004)(6486002)(52116002)(186003)(6512007)(1076003)(26005)(6506007)(107886003)(921005)(478600001)(110136005)(66556008)(316002)(38100700002)(66476007)(4326008)(38350700002)(2616005)(41300700001)(66946007)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?5LCHQihWLhcKRfnQjOqpA8PhXQ9gUE7Nc4ePdq1SExPwnaiCbBCpTjK54/j2?=
 =?us-ascii?Q?pv6m1BcUykVFqQLIqJw3EXV3KzdsFxT/aHUTk2UauarknsSYQjXk3fnegtYE?=
 =?us-ascii?Q?+pZqlGfuZ7S0uKjp3W5SfURO4a2d2yYiOieiQO3Q6yoshnlaSBqughZHMH6j?=
 =?us-ascii?Q?4Yz2/wkOldl0THakL2UbL+NG5Vp01sv12iFokiBF8m98alkKv4PSNTQrD3mt?=
 =?us-ascii?Q?+mY6N9AewYx5bf/n3AUhshxHldy5eg8A03swITbNruineYGrKJC8hSWo6fbv?=
 =?us-ascii?Q?WnkXDFjFZ/GGzoucuYnYrXwDvfkGQ3BN8nh23UbDuwAYdVT36soZQNGuT1xd?=
 =?us-ascii?Q?vNlGZsvULaoghh6BN0AGSo5uVQ0SvYCBFCGHQnafFpGSejp/yckj3V8CUZhu?=
 =?us-ascii?Q?ipafV7fYuuRLVKFBmTMyJBwWTRHXojeq8gSUJPgAqClakB+PiooXuz40HF1V?=
 =?us-ascii?Q?kVlv++sYWeMpcJs26uATIdwfY3SI+nDYRSdyt0xxC2pdMD4HHb6IdT5sOAV3?=
 =?us-ascii?Q?a0pvlTAOyUex1ovBCzpziwYuDg/0maRcdmTZui9JSJHWog9BKMogbSB5BKV3?=
 =?us-ascii?Q?ia8Cn+6f40HwGcOuoaI8n2A1kl2YRxkp2NhYQPyBP1jmUDPV2uQaPRxs9tzt?=
 =?us-ascii?Q?zwQdwWa0R5p3pFT0Gao714CGmiKcF6zACM2t61xp8EtFpdBEJjvCqe8jhzC5?=
 =?us-ascii?Q?oT9Aen543i7P2Y7mCw4zsBp4K6hCCztyHjPi0B5FDjlDqnMUzDh9rzlHRPiu?=
 =?us-ascii?Q?RXWotYALi2/VsMXnvDwvIF06AhDuC202W+y4/3fzV5+z8r0k0PQm11ZprqGe?=
 =?us-ascii?Q?3dBcnZnANQAlBXq/HhWjVkAHmoDKLerGyzRW0cq6zZhr6raNeyYTZNl9mkQo?=
 =?us-ascii?Q?vuwgFPGGmQryl/esN3qDmNofNoas1ia+WlO/5MeGigCCsUt91HRnn0Y6ie66?=
 =?us-ascii?Q?pNPtATaylfdR4frEiBmOAG/IeLC6/KlM8pkVbst8RAl1jC5A9NkZN3OcuZYv?=
 =?us-ascii?Q?PpihD/FlcwnuhLAdfvs2vkTC6x2Z+ny4oERPmk7d4DxXRNE752oQHYX6ejQj?=
 =?us-ascii?Q?vwiVRD7WH3MwKwVxownNUGwz63dHo6hHp9LXy2NFrq0cRNlX6cqFlilTJONL?=
 =?us-ascii?Q?XPl1w1WHmw6hFXZ4FsGOge6oGIiFyFwbrc/Us6uyf4hHKrz+hacs4DziYtKs?=
 =?us-ascii?Q?Mqqr5WrMs9UtxuztTIFEFGuIvD9r/G9Zw1VPt3gsxxwtNRW1/PGVPwzDwXs2?=
 =?us-ascii?Q?ooAcXUsZIIxlLuMz1WBqaoJjT8cqKOv2KtxllIWf8LqCtVQgeNwuIvqvC4VS?=
 =?us-ascii?Q?cRKeOzfxcgRGPQ1oj3R0h/JE88uUxNqjfSWjmxMRCjI8GjSTySsKq3BE91Nn?=
 =?us-ascii?Q?2zp4oSbcvvprlJ6URm/wVnq1aIW3TFT6WGpKrAcbrOmNPUskdI9uoSJuwcEP?=
 =?us-ascii?Q?zwxEMd7dERFdRwFwoo7AK6zVlThn4hIvR424+pCXPe5lun6el2XiZ5lybdeR?=
 =?us-ascii?Q?GGFS3wHON0bnxuVM/t6lixvU8+aHO1ZqTtnOx9D41YYEb/zvhZPZJh0s9z4K?=
 =?us-ascii?Q?RbsbwoEVqEXbiwwr83kB+e58GFI0ONiQfiI/XIQqVVFdOZmp9b/1HzxSvWqs?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?JhJMZc3FkzE4wYbOMeCEM7MnZ5bRx+94gD1h0jUs81GprtX8tH7Ws5xfxIF+?=
 =?us-ascii?Q?8HYljGTHu4Z7Lrcd/aNlqe07MVefe/MBLF64JnFUWtiRdVfsSCjf299YXPoK?=
 =?us-ascii?Q?BgvAkjcjjnEFzr5ifhIY/o/Ann0YVDAExBaPypFnM+U0I0lUDQSF3VjsitmE?=
 =?us-ascii?Q?enNzXaGAUqgzqYSyutWjNFAF2X6BECkja3TF6upL6rnaCoP1Xg/aJOABexPS?=
 =?us-ascii?Q?5EWQL31kwkr3qwPaAHU462CjwYd2Mu/3ZMUA9iftCQJX9pCTXX6MWIBqHHRn?=
 =?us-ascii?Q?3dlcbKZqouyHUCCi8oDEr9Fb7m9gJ6yO0X14HTOa5ZfCXRTS7g+NXIwQy5JU?=
 =?us-ascii?Q?FYyRENtqet+Ldxj0YHkJKi1pYOWAHQPqnGJnrGJf44XSkweV+qWzgEN2Xu2e?=
 =?us-ascii?Q?zXLkXv/v2wif5iHPgDPVLq+JC5Op+UJv990afjFrq25UpOLbms6COG43n1xX?=
 =?us-ascii?Q?zIe6RSZoZCDrxMjrRxFxs5G0osex6qT5cyR65h+Cc2OTCVVtzSBIwZK/El6t?=
 =?us-ascii?Q?7pUW4KVOu8iW0EHgxDhLMmwzpg2iy7g0MUtsl9WsxWq/lz889JWwZXR3zgIJ?=
 =?us-ascii?Q?ea36l7fb1kV5p7CdYUE7/H2srQllOOf5Az8+O2B7n8Q7MlL/rLGoufT0WXxV?=
 =?us-ascii?Q?1rRju4nrIlvYeg5bzYMuDO88bFbKG/eBEC+ehixtFdu5XhKs2p8Rjz2BNSKB?=
 =?us-ascii?Q?5NGeBUrN60t2PAICwTFUSHFIJK6zS8bAouqj1ZMQTK0ArTDkqliATnWD+f0A?=
 =?us-ascii?Q?GhWNjfH7TwkHOu67jJXYR1eXn6wHWN1/IhLRJxQMtF7WUBdHeoEIYUGvK5bf?=
 =?us-ascii?Q?el1qiXRkdj+qFC8mXBcJmw0x4tk+pOLMNFQVq+I7TSVWG26yNCNRu8YdMwH/?=
 =?us-ascii?Q?Jefmy4hFb2qYUAsTPBeBJQqBfP4GU1/cETXdqi5QL0zsoPGHFuYombnAwVz0?=
 =?us-ascii?Q?iX+x4j4mRuVvIuf8hcdiVlGMQE+T+wTiFY8VLqjdyWY9qxSsk0zkqLWFw6sc?=
 =?us-ascii?Q?T6lk5xcv7zx20yq/AcP74cODGA=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b09b854-3316-49f3-ead5-08db65db2313
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 15:40:06.5461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3I1k1TqDidHK1tcAIG6UB3k9ZxaY+22ER9p/WUuAuqqxqrvJ+xWtIIubCXLgEbga0IQ5q8dyjkuAHmunjESnVeTO0YPbX5/aCSUTZqj7cdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB10571
X-Proofpoint-GUID: zTksXJQcBL-E_F3EbeKs2VrsR_w3EnAO
X-Proofpoint-ORIG-GUID: zTksXJQcBL-E_F3EbeKs2VrsR_w3EnAO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-05_31,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050135
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The KSZ9477 PHY errata handling code has now been moved into the Micrel
PHY driver, so it is no longer needed inside the DSA switch driver.
Remove it.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/microchip/ksz9477.c    | 74 ++------------------------
 drivers/net/dsa/microchip/ksz_common.c |  4 --
 drivers/net/dsa/microchip/ksz_common.h |  1 -
 3 files changed, 4 insertions(+), 75 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 3019f54049fc..fc5157a10af5 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -889,62 +889,6 @@ static phy_interface_t ksz9477_get_interface(struct ksz_device *dev, int port)
 	return interface;
 }
 
-static void ksz9477_port_mmd_write(struct ksz_device *dev, int port,
-				   u8 dev_addr, u16 reg_addr, u16 val)
-{
-	ksz_pwrite16(dev, port, REG_PORT_PHY_MMD_SETUP,
-		     MMD_SETUP(PORT_MMD_OP_INDEX, dev_addr));
-	ksz_pwrite16(dev, port, REG_PORT_PHY_MMD_INDEX_DATA, reg_addr);
-	ksz_pwrite16(dev, port, REG_PORT_PHY_MMD_SETUP,
-		     MMD_SETUP(PORT_MMD_OP_DATA_NO_INCR, dev_addr));
-	ksz_pwrite16(dev, port, REG_PORT_PHY_MMD_INDEX_DATA, val);
-}
-
-static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
-{
-	/* Apply PHY settings to address errata listed in
-	 * KSZ9477, KSZ9897, KSZ9896, KSZ9567, KSZ8565
-	 * Silicon Errata and Data Sheet Clarification documents:
-	 *
-	 * Register settings are needed to improve PHY receive performance
-	 */
-	ksz9477_port_mmd_write(dev, port, 0x01, 0x6f, 0xdd0b);
-	ksz9477_port_mmd_write(dev, port, 0x01, 0x8f, 0x6032);
-	ksz9477_port_mmd_write(dev, port, 0x01, 0x9d, 0x248c);
-	ksz9477_port_mmd_write(dev, port, 0x01, 0x75, 0x0060);
-	ksz9477_port_mmd_write(dev, port, 0x01, 0xd3, 0x7777);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x06, 0x3008);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x08, 0x2001);
-
-	/* Transmit waveform amplitude can be improved
-	 * (1000BASE-T, 100BASE-TX, 10BASE-Te)
-	 */
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x04, 0x00d0);
-
-	/* Energy Efficient Ethernet (EEE) feature select must
-	 * be manually disabled (except on KSZ8565 which is 100Mbit)
-	 */
-	if (dev->info->gbit_capable[port])
-		ksz9477_port_mmd_write(dev, port, 0x07, 0x3c, 0x0000);
-
-	/* Register settings are required to meet data sheet
-	 * supply current specifications
-	 */
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x13, 0x6eff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x14, 0xe6ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x15, 0x6eff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x16, 0xe6ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x17, 0x00ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x18, 0x43ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x19, 0xc3ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1a, 0x6fff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1b, 0x07ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1c, 0x0fff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1d, 0xe7ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1e, 0xefff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x20, 0xeeee);
-}
-
 void ksz9477_get_caps(struct ksz_device *dev, int port,
 		      struct phylink_config *config)
 {
@@ -1029,20 +973,10 @@ void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	/* enable 802.1p priority */
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_PRIO_ENABLE, true);
 
-	if (dev->info->internal_phy[port]) {
-		/* do not force flow control */
-		ksz_port_cfg(dev, port, REG_PORT_CTRL_0,
-			     PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
-			     false);
-
-		if (dev->info->phy_errata_9477)
-			ksz9477_phy_errata_setup(dev, port);
-	} else {
-		/* force flow control */
-		ksz_port_cfg(dev, port, REG_PORT_CTRL_0,
-			     PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
-			     true);
-	}
+	/* force flow control for non-PHY ports only */
+	ksz_port_cfg(dev, port, REG_PORT_CTRL_0,
+		     PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
+		     !dev->info->internal_phy[port]);
 
 	if (cpu_port)
 		member = dsa_user_ports(ds);
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 768f649d2f40..813b91a816bb 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1270,7 +1270,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.tc_cbs_supported = true,
 		.tc_ets_supported = true,
 		.ops = &ksz9477_dev_ops,
-		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -1303,7 +1302,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_nirqs = 2,
 		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
-		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -1336,7 +1334,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_nirqs = 2,
 		.num_tx_queues = 4,
 		.ops = &ksz9477_dev_ops,
-		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -1423,7 +1420,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.tc_cbs_supported = true,
 		.tc_ets_supported = true,
 		.ops = &ksz9477_dev_ops,
-		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 5aa58aac3e07..a66b56857ec6 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -60,7 +60,6 @@ struct ksz_chip_data {
 	bool tc_cbs_supported;
 	bool tc_ets_supported;
 	const struct ksz_dev_ops *ops;
-	bool phy_errata_9477;
 	bool ksz87xx_eee_link_erratum;
 	const struct ksz_mib_names *mib_names;
 	int mib_cnt;
-- 
2.40.1


