Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5FC6D0DDE
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjC3Sid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjC3Sib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:38:31 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F439AD14
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:38:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrClhVYr0KtR5UAPXbJHCjPuD4LkIqtfT69DYoPM7+tqXIS1P+fw9jfh/q2a2ez3VuZOCxrB5wMgyVqhpWt8waLScQZQ7m0X9GyrkUiDK7F6QFU/Hoyf3V4j31D+p4CC2GobSuSp+SRqH78gCfxWmWN1Sn6RCAgszUWmK5JxBIKWhOFlu6yWaNQ0Ezoh/aXpv3uKE7u4Rmx/2KBfZNL/oF0NnOZZLsz1NrieyC0rYvHlRHYU3V9uP2le62QU90fh27QaIWyU3zBXAEzDKi7/MbOqqLwgU6R9lgr0DZtV6frkjUcAUle9Gz0Jaf4Uce9rU6Xpo5Oc6rwVvwHxqsW63w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyVH1QBmP9LLaQVgemarr8zduIzdlY2exjL2N7i0zaw=;
 b=TF1OxpDy8SaClbY3R6s5IA07IFoTi9OziSuWjJQTWfVQBNze++SZF0cbvZ+uakGdA0pjbN4nS3sp6ULcyEkGXcI8zKPV23AkjO3VI879CngTatB7R+2pVOUkQin0gqX9fCx+hSqPNxhyCIuq3UVd7liUIdQzzpwhPlvn44yr5V0XlhNPPVJQD+cI8a1hMRZaSHcG9OLifoB/qqSwekEgGgmBDt7MRRt1oCYR0DvAGWBOgMqHn2KyRLCTpb5YxeiwO9zsq1KhVYnAG7WohZD3lVhU0qj0EWtM7iksgtGOsc4X9ExT0oWZu+T9TvAuVVKCiGfy2fGZ8pC7XR6k++QSvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyVH1QBmP9LLaQVgemarr8zduIzdlY2exjL2N7i0zaw=;
 b=fAvBsy18fdBL5rxrl58nyy7jlgDMSKLPxy1VUMFmvUteEUmfJHczcIrEhMY+x9p6xe1h6GD4BNpvYQiz+YWU8e4WPJf0FlPyleJFGcsUrPGWh77IHMR680OrWSZbYiZWHUaJCAhH3ZtZCloCMmOfjsE/z93oLO88zTn1l2ox0a8HNzhWvUJKTN25m0o49Xu5sRTOhRHs0OgHpg8cxcrUWhBn633MKBeGxorcbSHzIoWBDXYZkfVxZ5j6pd7w9DPf1ubL/F8n1c40iKin0dkzSCflDumnsSeCJKJJqyl9tRugOeNZphJeM203Lk1laSQJo7z0IQn/SMTxPkbM20bZCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3127.namprd12.prod.outlook.com (2603:10b6:a03:d8::33)
 by DM4PR12MB6544.namprd12.prod.outlook.com (2603:10b6:8:8d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.22; Thu, 30 Mar 2023 18:38:28 +0000
Received: from BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::ebc5:c372:d99a:fdb5]) by BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::ebc5:c372:d99a:fdb5%4]) with mapi id 15.20.6222.033; Thu, 30 Mar 2023
 18:38:28 +0000
Message-ID: <659c7c1d-6aa9-0d90-00e4-7a6025ae40b5@nvidia.com>
Date:   Thu, 30 Mar 2023 11:38:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
From:   Andy Roulin <aroulin@nvidia.com>
Subject: [PATCH net] ethtool: reset #lanes when lanes is omitted
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0048.namprd11.prod.outlook.com
 (2603:10b6:a03:80::25) To BYAPR12MB3127.namprd12.prod.outlook.com
 (2603:10b6:a03:d8::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3127:EE_|DM4PR12MB6544:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e9aa569-9a55-4293-680b-08db314df408
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpfnxYFfu/pTCxTkkv+3uaGztyOC5pprNVFhuJkZ4Rb6n5gR4IMy6x/oqQrDec8zQlBoz4yjvTKRMzWj2SX+UPIJn1w1DKXtmQw32i9PX991CrQ1gwf9qNIYS0z+cUzu3OP92CDDqGH15m78SmxsuzvaICCDOZITVSQnO+gExBfrDI0n+zBOXVr9iaAeqNwQI9M7UttiiKLqQZSOzgvO+V0bcHwUfqwfy32OQ3MaL+z4Dzd6CnoHkJ5+XAtoNtbXmAxfE6E3vJ2zYw4MsiC56p0oepxkgk1ygtekEq0jM95nFFxaEzxZHycaDwl8dr46QsbBsT3ev/7g/6PgXe5JCOmrFKQ4pdvRVseo3Y+Xrlga1lM1ZP0Ty5fjWkPlyavn8+XulaU71D4HNzUBOJkNeA69VzIoLrDiIRTTphYb+E7/zBsLkzQgovFw6YS4OjYrz5ZWB/MWFfjVVJmFdIdIQwmOjP7nisLGvDvEk+zobYUDVnBBCEM9IZSLgv9nx2ZzmY+Ant95rGCSp0L1hxUMIBWRi3IHi3RZ52nCyG+ZseaHgq2Cgc9wXfgSt/+deOx+MBBn8tl5FWLpEVKWpwE0LJ9aylK74yLzHeDE+Vk3qcPVVPjbQBymSSY+IqtuelNbYtsxDaVEEnPCFZTeuGYHFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3127.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199021)(6486002)(478600001)(31696002)(86362001)(38100700002)(36756003)(2616005)(107886003)(83380400001)(186003)(6512007)(6506007)(26005)(41300700001)(31686004)(2906002)(8936002)(5660300002)(316002)(8676002)(6916009)(66476007)(4326008)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2E2eHpnb1RsRHRvbXd6TSs0MWtaR2F0djY5QkU2dDdQb3l1TGJrWnZqNWZq?=
 =?utf-8?B?UER5Z1RGd3JJY09VeXZ4Vmh1TkRxYWVLZmlXSlo4YXdRL0l4TWtJZnA0MUZZ?=
 =?utf-8?B?eTQ4cGR2VmJBWHR4aG9wWkkxTHBhS1FIcGZlVXRIUFRKREhFNjVYT0pwRzB3?=
 =?utf-8?B?ZUM2VGRXeWFHaTU5T1pvSXcrWWM3cFlXWHpIdFBrYWE5TTFseWRONzEzZ1pz?=
 =?utf-8?B?WTV5U0JSSTZhTG9oSWFMbFJBNDFMWHU5YVBYLzFZRHJiUDNrK0l5b1lxNk56?=
 =?utf-8?B?WjBkb0VaZ3ZaM1B4bVAxOC9ZUmM0UzdjQ2hnNjl0OXdQUXRrSnBYd25JS2ZQ?=
 =?utf-8?B?STB3QmxzNnhXOVdOVXVvRitUcnVYQXl3VERzZFZhZGZRejQ4eTBtamljV3Iw?=
 =?utf-8?B?VUNaQ3VWamJWRDZvYzdIVlhoWmNCZUtQckdNWEJqRStBSnQ0R1JjY1hCM2RX?=
 =?utf-8?B?MVo5czFxL1V3anhCTWZOZWZCRW12eEk0a0VnOUVIcVJENVQ3ZFZNWjVvam13?=
 =?utf-8?B?OEgyK09RSkZvVkFYcGNLdjN1U2p5TmlPeWlPeVBUcFpJNUlJcDV0dHdBZjRU?=
 =?utf-8?B?MUlBSWdlYlRnWUFOclltbDRvQy9sRU5yQ3BZUFR6VFlqbWo2UElwNms0di84?=
 =?utf-8?B?M3dnQWsvTldDcWdBK1VPMGlCSDRKc09aRk1Xc0YrODZnMnNNdnp1WW1nVnkv?=
 =?utf-8?B?eWt5VzNTdnlMR3JycllrUkdLWlIvRXVhZStjY2dFU3ZSTklGMlMvcHpmU3pw?=
 =?utf-8?B?N1hjbW0xZVRmT1dWU1VOWHE0Qm9vQ0RCMDZYNkdyYmJsaUJnMll3QnhVMU1K?=
 =?utf-8?B?MzNUR3c4cHhlR1l5Z1FRZDlkRDRzMTJ4cVhURml0Z3JueUxrR3dWRTRFUkNK?=
 =?utf-8?B?alFmQ3pBWXVjOG9menlRcDVMempmVk5zS3d2bDYyd2NiOGJmRis1LzZUN3M2?=
 =?utf-8?B?TTZES3VwWnpPTytTY1lzSVdTYmMyd2FVVFFnaFBzenhwY2VqbzJ6MUY0ZU03?=
 =?utf-8?B?ZWI3Mk9XM2F1T3B5ak9Wd2xqc0VCcUVlZWhHMkpIV1VUakdiQW5ReVFRMnZS?=
 =?utf-8?B?elgrOUpzWmdpRTAyWkpjVHRiSXIvS3IwTFFkN0t5c3kyZk02bjU1aDZsSDlT?=
 =?utf-8?B?djBsYUJuTW1YUXV4bzJrSS9SYTlwa2wzeDI0aWZlcVpQUFEvSFJURks5Szha?=
 =?utf-8?B?R3p5b20zVEhPYzIyTUhCQ3FIRTkyYUp1NlZqS1pRUDFQcGhzZ0ZRVHRiNEZW?=
 =?utf-8?B?dTJHNVJoU01XMUFtRFg0WlRIT3FKMGFqQXNOcVpSWlJlSWpjQ2JYT3NRb29H?=
 =?utf-8?B?aTdBWkYwZ2F5angvSVp2Mzc3VHBBY2IwYy9oNWc0OFZaWkJFRm1Dd2kzOUdx?=
 =?utf-8?B?TDFzRUVJclFmSHoyb1NBenZOZCtVRWlpRXBEaHVJMTBzWDVOQnBSc2paOW0v?=
 =?utf-8?B?OGtpUkhQQ1RwQzh2MWs5WEhFdHRhQ0g0eGhpb1JBWlRYWDNqTnNMY0poMTlZ?=
 =?utf-8?B?Mi9XQzBtYlZCbjJ6b2hqcVpIVDJGejlJdHE0ZnB3WEovZVRVczNJNDBSZXZO?=
 =?utf-8?B?bzBWbjBGSDZOVi9JSjdxNWZ1Tkw5TjdiTjdIc2owVk52eW1scUxkbzZQOWlk?=
 =?utf-8?B?T2NaUUdZTmFnVEdwbkcwOWRpbTlxbThHMDIxUHFRTFQ2MEI2RWFIdVVJMGxo?=
 =?utf-8?B?RmdGNSs3VkRCUkxsektLOXJWYnYvVm1wWTBMd2REa3JYakVqdmFvQUYrYXY2?=
 =?utf-8?B?Sms1S3B5dTRDdVd6bktoVURFemRLYU8vbW9MenNQcmhYZ3RLaFVvZHovWGEr?=
 =?utf-8?B?UkVoZCs1VHp2KzNtaWNVdUFxcnZTZFZ2bHl5akRjdzl2aUZIOHJFZ21FR0Uw?=
 =?utf-8?B?VmRRQVcwck0wVW9zcS9YWTlQejBDVklUYVpnTWdjSWFXWHk3cnVmZ3U2Zmxq?=
 =?utf-8?B?aGI1UitKdDR0ZVRDZVFlNVRLUzVTN25tY2FmdnExVHRtZ294c28xMUROODhv?=
 =?utf-8?B?eDBaMFp3TWdvb3MxUHR5VEFwdGZEOWJabmlGcEFUdmJ0RW5Xa2w2M3hoYUp2?=
 =?utf-8?B?QU92c3pBVlNUNXZYVWNOdFlVNFZxOUlXTFFUbWhJVnU3UFNBSDBEOHFVZ1VS?=
 =?utf-8?Q?DnI5g27Yqv2RTDogFcaEpiTPo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e9aa569-9a55-4293-680b-08db314df408
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3127.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 18:38:28.1538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: smTE9QDSW7ZSphJwALjRFx4WuxIrIiGBkIubGmXhPtoEGFolBMjLEdDop3jiKHkZuUy6GlpvINSrqmqQKo7XQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6544
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the number of lanes was forced and then subsequently the user
omits this parameter, the ksettings->lanes is reset. The driver
should then reset the number of lanes to the device's default
for the specified speed.

However, although the ksettings->lanes is set to 0, the mod variable
is not set to true to indicate the driver and userspace should be
notified of the changes.

Fixes: 012ce4dd3102 ("ethtool: Extend link modes settings uAPI with lanes")
Signed-off-by: Andy Roulin <aroulin@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 net/ethtool/linkmodes.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index fab66c169b9f..20165e07ef90 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -270,11 +270,12 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 					    "lanes configuration not supported by device");
 			return -EOPNOTSUPP;
 		}
-	} else if (!lsettings->autoneg) {
-		/* If autoneg is off and lanes parameter is not passed from user,
-		 * set the lanes parameter to 0.
+	} else if (!lsettings->autoneg && ksettings->lanes) {
+		/* If autoneg is off and lanes parameter is not passed from user but
+		 * it was defined previously then set the lanes parameter to 0.
 		 */
 		ksettings->lanes = 0;
+		*mod = true;
 	}
 
 	ret = ethnl_update_bitset(ksettings->link_modes.advertising,
-- 
2.20.1

