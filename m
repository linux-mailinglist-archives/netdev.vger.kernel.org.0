Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993946D0C01
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjC3Q5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjC3Q5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:57:05 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF82196
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:57:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ns2V6FDbOSuCj7wi3GOkn8l/n794xtFKrJOpCJtA0gXmXlIjU2os7K8HP/FMy+35d7N8ng5/wayVk3BHRJiljQ/ga6izbJ0u3kCXn5WsPD1+35rkdaWMfeznEGBrh1sTDQth0bn+wm4VCXV43Y8CXsx0SNjdtUMFJGTVpNYesKh8JMWwE9G3DWBgAvNMg7skAfOxxUO4dv5IcUmCjgEjlz6M6rYQ1Ht0g77NHQ6AHn//DgdWYnIKXo8lyM6MpQN4CrnyE8+mKzWkVxXQgSGA6rFipUjiLHDr4GFVmjOKT68wCesb1WwymDioTNw2uswguskmEMYsmYOEnLfG2SUNnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyVH1QBmP9LLaQVgemarr8zduIzdlY2exjL2N7i0zaw=;
 b=M5AZeJ+QqIB+DP1zhV8Xm3fOVpZVCIvkFjI5vO+vRLhVmb4babtkoaTLYlcvt/7iKUbNdwn6Ebq9ZxZkpYL7hPmrUP9KogwY/j9J1MmN0d7axIx9/B6Wzm2+xYOvyTqUWAYyxBosfkXWyi95BXqpuZpsp5tfMD6a+tHTDe9HaBgrBbI04IjpcIyMtsIxwAvlCm1E6PDXMTXp0r/4YbvcK4C4NfEh8jLVDEEqcNCo7kTQGplBDcP2Z1sui87CUgpUcmTbTGKaBdRHQoacG1I/P9ddP8iVnfo7W+26ererNdI64kHQlHnXhO31/3pME6rJgnaHlteR+ZPtAuxbGUmitA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyVH1QBmP9LLaQVgemarr8zduIzdlY2exjL2N7i0zaw=;
 b=ISh5tSUsBwVg0hkLcxJJqo4qIcy3pgjC+Ik2hm8csepMjHJgQUH70IOpzP4V0us29niax4ZzD2xkxvf0bJEcNq3i8GG6/20KcW/cfv7UaV7QJqCXkzaEjR2SiKc8RyyIIU857ztLDr3TQnNS9AN0S3Zus/PjUncrnh+IGIN2oIxVv3ErDrW6ysQ++oE8Cx1Yn8y1GXfHnDoi9NSFgEcb5mqy/jg/exQULTmvD4OSfxqgIkm+5IcJVQHFoKPpDM9ftsQz31d568nXoa0s2dev0MkR8zKQkqTgk7uaGo9n1dZw017r8zFLZz9KeIttNCUqCHtINoUO8XhgakZEKMIUyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3127.namprd12.prod.outlook.com (2603:10b6:a03:d8::33)
 by SA1PR12MB7224.namprd12.prod.outlook.com (2603:10b6:806:2bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 16:57:00 +0000
Received: from BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::ebc5:c372:d99a:fdb5]) by BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::ebc5:c372:d99a:fdb5%4]) with mapi id 15.20.6222.033; Thu, 30 Mar 2023
 16:57:00 +0000
Message-ID: <6e02aaab-18fe-692d-52cb-71212db44ade@nvidia.com>
Date:   Thu, 30 Mar 2023 09:56:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
From:   Andy Roulin <aroulin@nvidia.com>
Subject: [PATCH net-next] ethtool: reset #lanes when lanes is omitted
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0103.namprd03.prod.outlook.com
 (2603:10b6:a03:333::18) To BYAPR12MB3127.namprd12.prod.outlook.com
 (2603:10b6:a03:d8::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3127:EE_|SA1PR12MB7224:EE_
X-MS-Office365-Filtering-Correlation-Id: 651cadf8-c3e8-4b14-59bb-08db313fc7a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t8/1HhD81VHdynfWEwYyrlwspmbKxPxWYc89pOPW69HPmAgpKKlsZTYiJZDALyv2fT/aGsILjAA6kCSE5yOxmABjqfBaqsm6/m7DUx1l1hoLfgCRemtqpaTIm05j9qzmo9beoM43Fg+40wuBvRhlg9X+WJDlsO3hbVQaWLj08S+Cs8ulpcvV9B5XijESiqDrGb1VejwEO3lvP8itMOV4AHTalYlQyDAkuQuMnCxhn+A/QM183/rv+gdxCBDPCCoy6qkCIFOqec9lt8niNavTpOnbiyGO8JIA7HZdjDK0mCSwaJCqdd4Tdm4LQXmL93YCxm+iYcs0qLmjAa5DkzMDn2SJbqi6zb5z7uE6p0PPSPvjPfKTfmHzcEk4lVVAdoyhz06bqw/WvXzEOESYYAj/b2bt/Aknpyre8qFoFx8muHp8GqMsX2GIjlRtpBifsA7Ap9ZOcMZ8gjN6D7zjqRFrlPtgFkIxI5it/ayEyzvVZdVHtPWdVA+5cUT14fVQu90eHD4tEoFtpY/EjIKVNLDguacVyMgZNTI9+vS/0LBXkqfYJlNg8B0n0mEH3VCwqiNUpGkKAlEnkW+CbgSaRCB11nJpnICNjzdvknkuaRY5NqQc7xVLS+SFSp7vSzmnSWBndieIblmIh2WHtlhP3qKx8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3127.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199021)(26005)(8676002)(6486002)(66556008)(4326008)(66476007)(41300700001)(2906002)(66946007)(6916009)(36756003)(478600001)(31696002)(8936002)(5660300002)(38100700002)(86362001)(316002)(31686004)(2616005)(107886003)(6512007)(186003)(6506007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2xZSytJTExoZzd3NWJzVks1dGd3Rjh6RTZIL1hvbkhudEwwbkZJbSt1R3Np?=
 =?utf-8?B?eUpSU2JXWU5TamlIbjBPOE8vcDJDOUVCR0d1SzY2ZUIyK3dOcXdhcG9CNVVh?=
 =?utf-8?B?bDlScWlMR3FmUTJuemREMVpBek1udllYZTZGNzZWV0FicFNyUlNZL2lFQkFL?=
 =?utf-8?B?ajlKVSt3QWx5RWR4SFFMdHFDa09wOWlMRnN4Y255UEhjMnBwK09CNmFsSWcz?=
 =?utf-8?B?b3Nza3hTdmZvNkFWdHNPOTJBaWpYNVRSaWczYXJFVEVrY0hGV1dwK1hKT3hO?=
 =?utf-8?B?Qi9GNDhJdGNnbUE0VG9xYVZwcTYrbE1wZkkva3EvNXJidWx5RTZjNGZJSmlM?=
 =?utf-8?B?YWdrcDcyM1FCa2ZxbmU2WFZMeGQwUWlIVjd3bUEvU3lMWWZZRTFLR05WZWU4?=
 =?utf-8?B?YVo0eTR5R2dCRUVKSitpcHc1TllTRW4zOHd2WG83czJ6WU9ia3JNOUMyemRV?=
 =?utf-8?B?bzFWZVB0TDJnRjR0aTN5R3pJK2ZkYVVYeFd2ZVArTVFGN0JtZFlhMUNLWlg2?=
 =?utf-8?B?eWJQa2tPUjVUN1Uva3p0V3E5bmFTdDhFd0JIdHJ0M0I5V1YrNFV5ajdxUHR3?=
 =?utf-8?B?QVJWcXd2aGwxZ1JaQlZsMGVic1o2Q0xMWHR6ZjJXS25rSG40U0dSV3dsclJw?=
 =?utf-8?B?YlpjMkdzMFVISURoczMxQ3ZiT2c0bFU1N0Q1OExZTENMbi9HaU9idTY0R2Rz?=
 =?utf-8?B?c2pJUWtNQnBXb2NXd2lpVXJVbStpL2lMYmhZS1NkNmhnSG1SOVF6RDV3clR3?=
 =?utf-8?B?dmxXOHUxRmlqN2hwOTlsL2hPZlV4NnBZM0N3S0pBMjJld0JDbUpPa3NmSHZL?=
 =?utf-8?B?eXJMcC9ZeXFIVVhjM3p5c25WYVFxbys3UGpYeVRYZ1lNRmNzdjNuVVhlVXVo?=
 =?utf-8?B?T0dmaytxSVJQTTMzRmh4ZnBacWVMTUlNdWZ3SWZNM3VCZ0ozY3FKalZxY29o?=
 =?utf-8?B?amJBN2c4em1OTGlCeFBmS1I1d2p5SEdYc1VtRHlHTHVIa2xYa1NBNUZidkpG?=
 =?utf-8?B?bmRNMnN2K3pVQURtZktnOGZjWVA3aktpUWt4aWNVMVlHZFEyNXBZbXl1RXdP?=
 =?utf-8?B?aXE3cHN4dEROTXJSVmd1cVc4bGhPUWZkMUZqUmY5dHVCRk1QbFcrbDlaTVhQ?=
 =?utf-8?B?RHNzOFBrc0xDMnU4bkRPM0pEa3FJK3NZbFN5NnE0eFBUM0h5N1dyemEzekht?=
 =?utf-8?B?Z1VtQ3pqMFNQQ3VVdGV6bndyYWFPNEdmU2YwSmx4TE5ONVB4MXRXYTZCbWxa?=
 =?utf-8?B?UXV6VGQvdGZabnI3alpZZXVVcTlpQit3clZMbUV2OEVtaWpnZXhlbWRGWENj?=
 =?utf-8?B?eElBa1lWN1ZxQUJVOGhINjNUaVZzUVYvbEtNWHBHRGJHS201QXA5ZW1KN2c0?=
 =?utf-8?B?cDFqYWdRb0Vmcm5jV0dRdm51L21SdTBnY1MyMHN2TTFOeldiSEJHNHdGdjJs?=
 =?utf-8?B?ZDlVV0lidEZ1RkQzNWptL1QxdThLZEVST3hxNVJzRitaZWplNXFMd0Z4SzV1?=
 =?utf-8?B?bVFNck5RaDIxSXJKenBQZjlkdHhVbXZJUHFmUzFhL3F4akYydllCL2l6L2Jx?=
 =?utf-8?B?UnBoenR5QlNmSEJLWk1vOHJETXF0NFBFUVBjOW9ZNEQwaWxvRTFPYW9wSkxQ?=
 =?utf-8?B?K0ErYis4UDVBUXkwcVFwc0U4Uk1iSks4SVhHK2ovOUFGbnhLanQ2Y3cxd2Iz?=
 =?utf-8?B?QWZiRjVDbytCV2JCR0piNlJScDd0VUpSV29yYjdrZDNjTFFPT0cvODk5ZnIv?=
 =?utf-8?B?VkhDZURINmsyUjNTaVpWSzZoTm0xdmtoVWN2NHFBd3FHamJyZzhFaUpnZWlr?=
 =?utf-8?B?TDN3b1Vac0pnQUZxMUtTcXUvSEEvSkk2MWRHd3ZCUHhMNjU5NGVqVjgwN01C?=
 =?utf-8?B?cXRNSUxYY25vQlpZV2xEcmgrRjJNL1pkbnJpNzBtcGFSREltZTdrV0Q2V3I5?=
 =?utf-8?B?TUZueWhCTlUrTUZkdHVlQzR5SzBFUTNidTdRK3JXSVFZN0xKVDRqRGJvRnpy?=
 =?utf-8?B?Sk5YdXIvdGVWdWczTjErS05oM0FZU1ZRdXphb0I0dFZBbHA3d3NjSk8yYTAy?=
 =?utf-8?B?b0pGc1N0ajUvT0E3UVU2Nk5DdXVEOUtjZFltdHlCejFraWJRUjJtd0F0aXIx?=
 =?utf-8?Q?GsnXD5PcKtux8X8OvJyNsVxzR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 651cadf8-c3e8-4b14-59bb-08db313fc7a5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3127.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 16:57:00.6934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8epS3mwo8oliOBhjKCzzY4GcRz68lqHle8nJVLoTFvOGsOD2I/aS2tsfr6q1/oWcVSiA4aYjfbzfrRtTgJ7eCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7224
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

